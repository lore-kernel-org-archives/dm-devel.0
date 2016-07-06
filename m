From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [RFC] block: fix blk_queue_split() resource exhaustion
Date: Wed, 6 Jul 2016 14:38:41 +0200
Message-ID: <20160706123841.GA13335@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <CACVXFVMTp17gcM8HEMrZ+0TJWgpGk+VWDgC7t+rMAancWZEFFw@mail.gmail.com>
 <20160704082006.GN3239@soda.linbit>
 <CACVXFVNTKsRQ0PQTL47-ceP-KqMR-zR4DO1v-ey5NTUYv8bUog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVNTKsRQ0PQTL47-ceP-KqMR-zR4DO1v-ey5NTUYv8bUog@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block <linux-block@vger.kernel.org>, Roland Kammerer <roland.kammerer@linbit.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jul 04, 2016 at 06:47:29PM +0800, Ming Lei wrote:
> >> One clean solution may be to convert the loop of generic_make_request()
> >> into the following way:
> >>
> >> do {
> >>     struct bio *splitted, *remainder = NULL;
> >>     struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> >>
> >>     blk_queue_split(q, &bio, &remainder, q->bio_split);
> >>
> >>     ret = q->make_request_fn(q, bio);
> >>
> >>     if (remainder)
> >>          bio_list_add(current->bio_list, remainder);
> >>     bio = bio_list_pop(current->bio_list);
> >> } while (bio)
> >
> > Not good enough.


> > Goal was to first process all "deeper level" bios
> > before processing the remainder.
> 
> For the reported bio splitting issue, I think the goal is to make sure all
> BIOs generated from 'bio' inside .make_request_fn(bio) are queued
> before the 'current' remainder. Cause it is the issue introduced by
> blk_split_bio().

Stacking:
	qA (limitting layer)
	-> qB (remapping)
	-> qC (remapping)
	-> qD (hardware)

[in fact you don't even need four layers,
 this is just to clarify that the stack may be more complex than you
 assume it would be]

Columns below:
1) argument to generic_make_request() and its target queue.
2) current->bio_list
3) "in-flight" counter of qA.

==== In your new picture, iiuc:

generic_make_request(bio_orig)
		NULL			in-flight=0
bio_orig	empty
  blk_queue_split()
  result:
  bio_s, bio_r	
qA->make_request_fn(bio_s)
					in-flight=1
  bio_c = bio_clone(bio_s)
  generic_make_request(bio_c to qB)
		bio_c
<-return
  bio_list_add(bio_r)
  		bio_c, bio_r
  bio_list_pop()
  		bio_r
qB->make_request_fn(bio_c)
  (Assume it does not clone, but only remap.
  But it may also be a striping layer,
  and queue more than one bio here.)
  generic_make_request(bio_c to qC)
  		bio_r, bio_c
<-return
  bio_list_pop()
  		bio_c
qA->make_request_fn(bio_r)		in-flight still 1

	BLOCKS, because bio_c has not been processed to its final
	destination qD yet, and not dispatched to hardware.


==== my suggestion

generic_make_request(bio_orig)
		NULL			in-flight=0
bio_orig	empty			in-flight=0
qA->make_request_fn(bio_orig)
  blk_queue_split()
  result:
  bio_s, and bio_r stuffed away to head of remainder list.
					in-flight=1
  bio_c = bio_clone(bio_s)
  generic_make_request(bio_c to qB)
		bio_c
<-return
  		bio_c
  bio_list_pop()
  		empty
qB->make_request_fn(bio_c)
  (Assume it does not clone, but only remap.
  But it may also be a striping layer,
  and queue more than one bio here.)
  generic_make_request(bio_c to qC)
  		bio_c
<-return
  bio_list_pop()
  		empty
qC->make_request_fn(bio_c)
  generic_make_request(bio_c to qD)
  		bio_c
<-return
  bio_list_pop()
  		empty
qD->make_request_fn(bio_c)
	dispatches to hardware
<-return
		empty
   bio_list_pop()
   NULL, great, lets pop from remainder list
qA->make_request_fn(bio_r)		in-flight=?

	May block, but only until completion of bio_c.
	Which may already have happened.

	*makes progress*

Thanks,

    Lars
