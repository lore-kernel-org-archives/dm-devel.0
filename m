From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v5 00/11] simplify block layer based on immutable biovecs
Date: Mon, 27 Jul 2015 13:50:48 -0400
Message-ID: <20150727175048.GA18183@redhat.com>
References: <1436166674-31362-1-git-send-email-mlin@kernel.org>
 <1436764355.30675.10.camel@hasee>
 <20150713153537.GA30898@redhat.com>
 <1437675702.11359.25.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437675702.11359.25.camel@ssi>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Dongsu Park <dpark@posteo.net>, Kent Overstreet <kent.overstreet@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 23 2015 at  2:21pm -0400,
Ming Lin <mlin@kernel.org> wrote:

> On Mon, 2015-07-13 at 11:35 -0400, Mike Snitzer wrote:
> > On Mon, Jul 13 2015 at  1:12am -0400,
> > Ming Lin <mlin@kernel.org> wrote:
> > 
> > > On Mon, 2015-07-06 at 00:11 -0700, mlin@kernel.org wrote:
> > > > Hi Mike,
> > > > 
> > > > On Wed, 2015-06-10 at 17:46 -0400, Mike Snitzer wrote:
> > > > > I've been busy getting DM changes for the 4.2 merge window finalized.
> > > > > As such I haven't connected with others on the team to discuss this
> > > > > issue.
> > > > > 
> > > > > I'll see if we can make time in the next 2 days.  But I also have
> > > > > RHEL-specific kernel deadlines I'm coming up against.
> > > > > 
> > > > > Seems late to be staging this extensive a change for 4.2... are you
> > > > > pushing for this code to land in the 4.2 merge window?  Or do we have
> > > > > time to work this further and target the 4.3 merge?
> > > > > 
> > > > 
> > > > 4.2-rc1 was out.
> > > > Would you have time to work together for 4.3 merge? 
> > > 
> > > Ping ...
> > > 
> > > What can I do to move forward?
> > 
> > You can show further testing.  Particularly that you've covered all the
> > edge cases.
> > 
> > Until someone can produce some perf test results where they are actually
> > properly controlling for the splitting, we have no useful information.
> > 
> > The primary concerns associated with this patchset are:
> > 1) In the context of RAID, XFS's use of bio_add_page() used to build up
> >    optimal IOs when the underlying block device provides striping info
> >    via IO limits.  With this patchset how large will bios become in
> >    practice _without_ bio_add_page() being bounded by the underlying IO
> >    limits?
> 
> Totally new to XFS code.
> Did you mean xfs_buf_ioapply_map() -> bio_add_page()?

Yes.  But there is also:
xfs_vm_writepage -> xfs_submit_ioend -> xfs_bio_add_buffer -> bio_add_page

Basically in the old code XFS sized IO accordingly based on the
bio_add_page feedback loop.

> The largest size could be BIO_MAX_PAGES pages, that is 256 pages(1M
> bytes).

Independent of this late splitting work (but related): we really should
look to fixup/extend BIO_MAX_PAGES to cover just barely "too large"
configurations, e.g. 10+2 RAID6 with 128K chunk, so 1280K for a full
stripe.  Ideally we'd be able to read/reite full stripes.

> > 2) The late splitting that occurs for the (presummably) large bios that
> >    are sent down.. how does it cope/perform in the face of very
> >    low/fragmented system memory?
> 
> I tested in qemu-kvm with 1G/1100M/1200M memory.
> 10 HDDs were attached to qemu via virtio-blk.
> Then created MD RAID6 array and mkfs.xfs on it.
> 
> I use bs=2M, so there will be a lot of bio splits.
> 
> [global]
> ioengine=libaio
> iodepth=64
> direct=1
> runtime=1200
> time_based
> group_reporting
> numjobs=8
> gtod_reduce=0
> norandommap
> 
> [job1]
> bs=2M
> directory=/mnt
> size=100M
> rw=write
> 
> Here is the results:
> 
> memory		4.2-rc2		4.2-rc2-patched
> ------		-------		---------------
> 1G		OOM		OOM
> 1100M		fail		OK
> 1200M		OK		OK
> 
> "fail" means it hit a page allocation failure.
> http://minggr.net/pub/block_patches_tests/dmesg.4.2.0-rc2
> 
> I tested 3 times for each kernel to confirm that with 1100M memory,
> 4.2-rc2 always hit a page allocation failure and 4.2-rc2-patched is OK.
> 
> So the patched kernel performs better in this case.

Interesting.  Seems to prove Kent's broader point that he used mempools
and handles allocations better than the old code did.

> > 3) More open-ended comment than question: Linux has evolved to perform
> >    well on "enterprise" systems.  We generally don't fall off a cliff on 
> >    performance like we used to.  The concern associated with this
> >    patchset is that if it goes in without _real_ due-diligence on
> >    "enterprise" scale systems and workloads it'll be too late once we
> >    notice the problem(s).
> > 
> > So we really need answers to 1 and 2 above in order to feel better about
> > the risks associated 3.
> > 
> > Alasdair's feedback to you on testing still applies (and hasn't been
> > done AFAIK):
> > https://www.redhat.com/archives/dm-devel/2015-May/msg00203.html
> > 
> > Particularly:
> > "you might need to instrument the kernels to tell you the sizes of the
> > bios being created and the amount of splitting actually happening."
> 
> I added a debug patch to record the amount of splitting actually
> happened. https://goo.gl/Iiyg4Y
> 
> In the qemu 1200M memory test case,
> 
> $ cat /sys/block/md0/queue/split
> discard split: 0, write same split: 0, segment split: 27400
> 
> > 
> > and
> > 
> > "You may also want to test systems with a restricted amount of available
> > memory to show how the splitting via worker thread performs.  (Again,
> > instrument to prove the extent to which the new code is being exercised.)"
> 
> Does above test with qemu make sense?

The test is showing that systems with limited memory are performing
better but, without looking at the patchset in detail, I'm not sure what
your splitting accounting patch is showing.

Are you saying that:
1) the code only splits via worker threads
2) with 27400 splits in the 1200M case the splitting certainly isn't
   making things any worse.

But for me the bigger take away is: the old merge_bvec code (no late
splitting) is more prone to allocation failure then the new code.

On that point alone I'm OK with this patchset going forward.

I'll reviewer the implementation details as they relate to DM now, but
that is just a formality.  My hope is that I'll be abke to provide my
Acked-by very soon.

Mike
