From: <yael.chemla@foss.arm.com>
Subject: RE: [PATCH 2/2] md: dm-verity: allow parallel processing of bio blocks
Date: Wed, 28 Mar 2018 00:27:45 +0300
Message-ID: <003001d3c612$756b3eb0$6041bc10$@foss.arm.com>
References: <1522003290-27243-1-git-send-email-yael.chemla@foss.arm.com> <1522003290-27243-2-git-send-email-yael.chemla@foss.arm.com> <20180327010633.GB23487@redhat.com> <001201d3c5a9$529b4a10$f7d1de30$@foss.arm.com> <20180327131636.GA26832@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327131636.GA26832@redhat.com>
Content-Language: en-il
Sender: linux-kernel-owner@vger.kernel.org
To: 'Mike Snitzer' <snitzer@redhat.com>
Cc: 'Alasdair Kergon' <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, ofir.drang@gmail.com, 'Yael Chemla' <yael.chemla@arm.com>, 'Eric Biggers' <ebiggers3@gmail.com>
List-Id: dm-devel.ids



> -----Original Message-----
> From: Mike Snitzer <snitzer@redhat.com>
> Sent: Tuesday, 27 March 2018 16:17
> To: yael.chemla@foss.arm.com
> Cc: 'Alasdair Kergon' <agk@redhat.com>; dm-devel@redhat.com; linux-
> kernel@vger.kernel.org; ofir.drang@gmail.com; 'Yael Chemla'
> <yael.chemla@arm.com>; 'Eric Biggers' <ebiggers3@gmail.com>
> Subject: Re: [PATCH 2/2] md: dm-verity: allow parallel processing of bio blocks
> 
> On Tue, Mar 27 2018 at  4:55am -0400,
> yael.chemla@foss.arm.com <yael.chemla@foss.arm.com> wrote:
> 
> > Hi Mike
> > I need to rewrite these patches according to issues you and Eric Biggers
> mentioned.
> > please drop this v1 patch.
> 
> They've been dropped.  BUT please do note that the patches I pushed to
> linux-dm.git were rebased ontop of the 'check_at_most_once' patch.

Thank you so much for many style, formatting and other issues fixes and also for
integration of 'check_at_most_once' patch, it saved me several review iterations.

> 
> I never did get an answer about how the sg array is free'd in certain error
> paths (see "FIXME:" in the 2nd patch).
> 

Regarding free of sg in two error paths, you were correct.
I fixed it by placing several error labels to differentiate each handling.
I also noted that reqdata_arr[b].req was not released properly, this is also fixed.
following is a diff of my fix based on your modifications.
(I can send it in a patch format, but it doesn't include a fix for Eric Biggers comments)


@@ -573,10 +573,9 @@ static void verity_verify_io(struct dm_verity_io *io)
                        verity_bv_skip_block(v, io, &io->iter);
                        continue;
                }
-
                reqdata_arr[b].req = ahash_request_alloc(v->tfm, GFP_NOIO);
                if (unlikely(reqdata_arr[b].req == NULL))
-                       goto err_memfree;
+                       goto err_mem_req;
                ahash_request_set_tfm(reqdata_arr[b].req, v->tfm);
 
                /* +1 for the salt buffer */
@@ -586,7 +585,7 @@ static void verity_verify_io(struct dm_verity_io *io)
                                   GFP_NOIO);
                if (!sg) {
                        DMERR_LIMIT("%s: kmalloc_array failed", __func__);
-                       goto err_memfree;
+                       goto err_mem_sg;
                }
                sg_init_table(sg, num_of_buffs);
                // FIXME: if we 'err_memfree' (or continue;) below how does this sg get kfree()'d?
@@ -595,7 +594,7 @@ static void verity_verify_io(struct dm_verity_io *io)
                                          reqdata_arr[b].want_digest,
                                          &reqdata_arr[b].fec_io, &is_zero);
                if (unlikely(r < 0))
-                       goto err_memfree;
+                       goto err_mem;
 
                if (is_zero) {
                        /*
@@ -605,7 +604,7 @@ static void verity_verify_io(struct dm_verity_io *io)
                        r = verity_for_bv_block(v, io, &io->iter,
                                                verity_bv_zero);
                        if (unlikely(r < 0))
-                               goto err_memfree;
+                               goto err_mem;
                        verity_cb_complete(iodata, r);
                        continue;
                }
@@ -644,7 +643,11 @@ static void verity_verify_io(struct dm_verity_io *io)
        }
        return;
 
-err_memfree:
+err_mem:
+       kfree(sg);
+err_mem_sg:
+       ahash_request_free(reqdata_arr[b].req);
+err_mem_req:
        /*
         * reduce expected requests by the number of unsent
         * requests, -1 accounting for the current block
        atomic_sub(blocks - b - 1, &iodata->expected_reqs);
        verity_cb_complete(iodata, -EIO);

> Also, I fixed some issues I saw in error paths, and lots of formatting.
> 
> I'll be pretty frustrated if you submit v2 that is blind to the kinds of changes I
> made.
> 

I took your modifications and working upon it. 

> I'll send you a private copy of the patches just so you have them for your
> reference.
> 
> Thanks,
> Mike
> 
> 
> > -----Original Message-----
> > From: Mike Snitzer <snitzer@redhat.com>
> > Sent: Tuesday, 27 March 2018 4:07
> > To: Yael Chemla <yael.chemla@foss.arm.com>
> > Cc: Alasdair Kergon <agk@redhat.com>; dm-devel@redhat.com;
> > linux-kernel@vger.kernel.org; ofir.drang@gmail.com; Yael Chemla
> > <yael.chemla@arm.com>
> > Subject: Re: [PATCH 2/2] md: dm-verity: allow parallel processing of
> > bio blocks
> >
> > On Sun, Mar 25 2018 at  2:41pm -0400,
> > Yael Chemla <yael.chemla@foss.arm.com> wrote:
> >
> > >  Allow parallel processing of bio blocks by moving to async.
> > > completion  handling. This allows for better resource utilization of
> > > both HW and  software based hash tfm and therefore better
> > > performance in many cases,  depending on the specific tfm in use.
> > >
> > >  Tested on ARM32 (zynq board) and ARM64 (Juno board).
> > >  Time of cat command was measured on a filesystem with various file sizes.
> > >  12% performance improvement when HW based hash was used (ccree
> driver).
> > >  SW based hash showed less than 1% improvement.
> > >  CPU utilization when HW based hash was used presented 10% less
> > > context  switch, 4% less cycles and 7% less instructions. No
> > > difference in  CPU utilization noticed with SW based hash.
> > >
> > > Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>
> >
> > This one had various issues.  I've fixed most of what I saw and staged in
> linux-next (purely for build test coverage purposes).  I may drop this patch if
> others disagree with it (or my sg deallocation in the error path question isn't
> answered).
> >
> > I've staged the changes here (and in linux-next via 'for-next'):
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
> > .git/log/?h=dm-4.17
> >
> > I switched all the new GFP_KERNEL uses to GFP_NOIO.  The fact that you're
> doing allocations at all (per IO) is bad enough.  Using GFP_KERNEL is a serious
> liability (risk of deadlock if dm-verity were to be used for something like..
> swap.. weird setup but possible).
> >
> > But the gfp flags aside, the need for additional memory and the expectation
> of scalable async parallel IO is potentially at odds with changes like this (that I
> just staged, and had to rebase your 2 patches ontop of):
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
> > .git/commit/?h=dm-4.17&id=a89f6a2cfec86fba7a115642ff082cb4e9450ea6
> >
> > So I'm particulalry interested to hear from google folks to understand if they
> are OK with your proposed verity async crypto API use.
> >
> > Mike
> >
