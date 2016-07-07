From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [RFC] block: fix blk_queue_split() resource
	exhaustion
Date: Thu, 7 Jul 2016 10:03:28 +0200
Message-ID: <20160707080328.GG13335@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
	<CACVXFVMTp17gcM8HEMrZ+0TJWgpGk+VWDgC7t+rMAancWZEFFw@mail.gmail.com>
	<20160704082006.GN3239@soda.linbit>
	<CACVXFVNTKsRQ0PQTL47-ceP-KqMR-zR4DO1v-ey5NTUYv8bUog@mail.gmail.com>
	<20160706123841.GA13335@soda.linbit>
	<CACVXFVPO1mwf9+MKosv_xY8Wz2KeShVVnefffgVr0wr=Tdo57Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACVXFVPO1mwf9+MKosv_xY8Wz2KeShVVnefffgVr0wr=Tdo57Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, NeilBrown <neilb@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block <linux-block@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@g>
List-Id: dm-devel.ids

On Wed, Jul 06, 2016 at 11:57:51PM +0800, Ming Lei wrote:
> > ==== my suggestion
> >
> > generic_make_request(bio_orig)
> >                 NULL                    in-flight=0
> > bio_orig        empty                   in-flight=0
> > qA->make_request_fn(bio_orig)
> >   blk_queue_split()
> >   result:
> >   bio_s, and bio_r stuffed away to head of remainder list.
> >                                         in-flight=1
> >   bio_c = bio_clone(bio_s)
> >   generic_make_request(bio_c to qB)
> >                 bio_c
> > <-return
> >                 bio_c
> >   bio_list_pop()
> >                 empty
> > qB->make_request_fn(bio_c)
> >   (Assume it does not clone, but only remap.
> >   But it may also be a striping layer,
> >   and queue more than one bio here.)
> >   generic_make_request(bio_c to qC)
> >                 bio_c
> > <-return
> >   bio_list_pop()
> >                 empty
> > qC->make_request_fn(bio_c)
> >   generic_make_request(bio_c to qD)
> >                 bio_c
> > <-return
> >   bio_list_pop()
> >                 empty
> > qD->make_request_fn(bio_c)
> >         dispatches to hardware
> > <-return
> >                 empty
> >    bio_list_pop()
> >    NULL, great, lets pop from remainder list
> > qA->make_request_fn(bio_r)              in-flight=?
> >
> >         May block, but only until completion of bio_c.
> >         Which may already have happened.
> >
> >         *makes progress*
> 
> I admit your solution is smart, but it isn't easy to prove it as correct
> in theory.  But if the traversal can be mapped into pre-order traversal
> of the above binary tree, it may be correct.

What are you talking about.
There is no tree.
There is a single fifo.
And I suggest to make that one fifo, and one lifo instead.

  |<------ original bio ----->|
  |piece|----remainder--------|
  
  |piece| is then processed, just as it was before,
  all recursive submissions turned into iterative processing,
  in the exact order they have been called recursively.
  Until all deeper level submissions have been fully processed.
  
  If deeper levels are again calling bio_queue_split, their
  respective remainder are queued in front of the "top level"
  remainder.
  
  And only then, the remainders are processed,
  just as if they did come in as "original bio", see above.

So if it did make progress before,
it will make progress now.

    Lars
