From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [RFC] block: fix blk_queue_split() resource exhaustion
Date: Mon, 4 Jul 2016 10:20:07 +0200
Message-ID: <20160704082006.GN3239@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <CACVXFVMTp17gcM8HEMrZ+0TJWgpGk+VWDgC7t+rMAancWZEFFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVMTp17gcM8HEMrZ+0TJWgpGk+VWDgC7t+rMAancWZEFFw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block <linux-block@vger.kernel.org>, Roland Kammerer <roland.kammerer@linbit.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Sat, Jul 02, 2016 at 06:28:29PM +0800, Ming Lei wrote:
> The idea looks good, but not sure it can cover all cases of
> dm over brbd or brbd over dm and maintaining two lists
> becomes too complicated.
> 
> One clean solution may be to convert the loop of generic_make_request()
> into the following way:
> 
> do {
>     struct bio *splitted, *remainder = NULL;
>     struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> 
>     blk_queue_split(q, &bio, &remainder, q->bio_split);
> 
>     ret = q->make_request_fn(q, bio);
> 
>     if (remainder)
>          bio_list_add(current->bio_list, remainder);
>     bio = bio_list_pop(current->bio_list);
> } while (bio)

Not good enough.

Consider DRBD on device-mapper on device-mapper on scsi,
or insert multipath and / or md raid into the stack.
The iterative call to q->make_request_fn() in the second iteration
may queue bios after the remainder.

Goal was to first process all "deeper level" bios
before processing the remainder.

You can achieve this by doing last-in-first-out on bio_list,
or by using two lists, as I suggested in the original post.

    Lars
