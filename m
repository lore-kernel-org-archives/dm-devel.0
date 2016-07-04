From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC] block: fix blk_queue_split() resource exhaustion
Date: Mon, 4 Jul 2016 18:47:29 +0800
Message-ID: <CACVXFVNTKsRQ0PQTL47-ceP-KqMR-zR4DO1v-ey5NTUYv8bUog@mail.gmail.com>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <CACVXFVMTp17gcM8HEMrZ+0TJWgpGk+VWDgC7t+rMAancWZEFFw@mail.gmail.com> <20160704082006.GN3239@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160704082006.GN3239@soda.linbit>
Sender: linux-bcache-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: linux-block <linux-block@vger.kernel.org>, Roland Kammerer <roland.kammerer@linbit.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Jul 4, 2016 at 4:20 PM, Lars Ellenberg
<lars.ellenberg@linbit.com> wrote:
> On Sat, Jul 02, 2016 at 06:28:29PM +0800, Ming Lei wrote:
>> The idea looks good, but not sure it can cover all cases of
>> dm over brbd or brbd over dm and maintaining two lists
>> becomes too complicated.
>>
>> One clean solution may be to convert the loop of generic_make_request()
>> into the following way:
>>
>> do {
>>     struct bio *splitted, *remainder = NULL;
>>     struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>>
>>     blk_queue_split(q, &bio, &remainder, q->bio_split);
>>
>>     ret = q->make_request_fn(q, bio);
>>
>>     if (remainder)
>>          bio_list_add(current->bio_list, remainder);
>>     bio = bio_list_pop(current->bio_list);
>> } while (bio)
>
> Not good enough.
>
> Consider DRBD on device-mapper on device-mapper on scsi,
> or insert multipath and / or md raid into the stack.
> The iterative call to q->make_request_fn() in the second iteration
> may queue bios after the remainder.

But this remainder is not the top remainder any more, I guess you mean
the following situation:

- drbd_make_request(bio)
       ->generic_make_request(bio)
              ->bio is added into current->bio_list
- bio is splitted as bio_a and bio_b in generic_make_request()
- dm_make_request(bio_a)
        ->generic_make_request(bio_a)
               ->bio_a is add into current_list
- bio_a is splitted as bio_a_a and bio_a_b in generic_make_request()
- dm_make_request(bio_a_a)
      ->.....
- bio_a_b is added into current->bio_list
- dm_make_request(bio_a_b)

But it is correct because bio_a depends on both bio_a_a and bio_a_b.
Or I understand you wrong?

>
> Goal was to first process all "deeper level" bios
> before processing the remainder.

For the reported bio splitting issue, I think the goal is to make sure all
BIOs generated from 'bio' inside .make_request_fn(bio) are queued
before the 'current' remainder. Cause it is the issue introduced by
blk_split_bio().

Thanks,
Ming

>
> You can achieve this by doing last-in-first-out on bio_list,
> or by using two lists, as I suggested in the original post.
>
>     Lars
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
