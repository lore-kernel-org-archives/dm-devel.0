From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC] block: fix blk_queue_split() resource exhaustion
Date: Thu, 7 Jul 2016 21:14:59 +0800
Message-ID: <CACVXFVNZD9Li9gf2r-jjPkSHin5XmSpWFseRt2-5SYdn4GYj0g@mail.gmail.com>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <CACVXFVMTp17gcM8HEMrZ+0TJWgpGk+VWDgC7t+rMAancWZEFFw@mail.gmail.com>
 <20160704082006.GN3239@soda.linbit> <CACVXFVNTKsRQ0PQTL47-ceP-KqMR-zR4DO1v-ey5NTUYv8bUog@mail.gmail.com>
 <20160706123841.GA13335@soda.linbit> <CACVXFVPO1mwf9+MKosv_xY8Wz2KeShVVnefffgVr0wr=Tdo57Q@mail.gmail.com>
 <20160707080328.GG13335@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160707080328.GG13335@soda.linbit>
Sender: linux-bcache-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: linux-block <linux-block@vger.kernel.org>, Roland Kammerer <roland.kammerer@linbit.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Jul 7, 2016 at 4:03 PM, Lars Ellenberg
<lars.ellenberg@linbit.com> wrote:
> On Wed, Jul 06, 2016 at 11:57:51PM +0800, Ming Lei wrote:
>> > ==== my suggestion
>> >
>> > generic_make_request(bio_orig)
>> >                 NULL                    in-flight=0
>> > bio_orig        empty                   in-flight=0
>> > qA->make_request_fn(bio_orig)
>> >   blk_queue_split()
>> >   result:
>> >   bio_s, and bio_r stuffed away to head of remainder list.
>> >                                         in-flight=1
>> >   bio_c = bio_clone(bio_s)
>> >   generic_make_request(bio_c to qB)
>> >                 bio_c
>> > <-return
>> >                 bio_c
>> >   bio_list_pop()
>> >                 empty
>> > qB->make_request_fn(bio_c)
>> >   (Assume it does not clone, but only remap.
>> >   But it may also be a striping layer,
>> >   and queue more than one bio here.)
>> >   generic_make_request(bio_c to qC)
>> >                 bio_c
>> > <-return
>> >   bio_list_pop()
>> >                 empty
>> > qC->make_request_fn(bio_c)
>> >   generic_make_request(bio_c to qD)
>> >                 bio_c
>> > <-return
>> >   bio_list_pop()
>> >                 empty
>> > qD->make_request_fn(bio_c)
>> >         dispatches to hardware
>> > <-return
>> >                 empty
>> >    bio_list_pop()
>> >    NULL, great, lets pop from remainder list
>> > qA->make_request_fn(bio_r)              in-flight=?
>> >
>> >         May block, but only until completion of bio_c.
>> >         Which may already have happened.
>> >
>> >         *makes progress*
>>
>> I admit your solution is smart, but it isn't easy to prove it as correct
>> in theory.  But if the traversal can be mapped into pre-order traversal
>> of the above binary tree, it may be correct.
>
> What are you talking about.
> There is no tree.
> There is a single fifo.
> And I suggest to make that one fifo, and one lifo instead.

The implementation may use fifo(queue) or lifo(stack), but the traversal
order actually is pre-order on one binary tree if we think the splitted bio and
the cloned bio as left child, and the remainder bio as right child.

The big benifit of modeling the algorithem as tree is that the implementation
can be proved easily.

Your patch is very similar with non-recursive pre-order algorithem.

And the one line change approach is just the typical pre-order
recursive algorithem on binary tree.

Let's abstract the one line change into following pseudocode:

bio_list_add_head(current->bio_list, bio);

while (!bio_list_empty(current->bio_list)) {

       bio = bio_list_pop(current->bio_list);

        q->make_request_fn(q, bio);   //visit the node
}

q->make_request_fn(q, bio)
       -> blk_queue_split(split, bio)
              -> generic_make_request(remainder)
                    ->bio_list_add_head(current->bio_list, bio);
              -> push(split) & pop(split) & visit the split bio
                        ->generic_make_request(cloned_bio)
                              ->bio_list_add_head(current->bio_list, bio);

If you compare the above with the non-recursive pre-order traversal
implementation[1], it is basically same.

[1] http://algorithmsandme.in/2015/03/preorder-traversal-of-tree-without-recursion/

The main difference between oneline change and this patch is the submit
order in the following situation:

q->make_request_fn(bio)
          ->generic_make_request(cloned_bio0)
          ->generic_make_request(cloned_bio1)
          ->generic_make_request(cloned_bio2)

But the three BIOs are often submitted into different queues, so the order
may not make a big difference. Even they are submitted to same queue
(disk), the order change may not be a issue too because there is still
I/O scheduler.

And do we have stacked driver which submits several BIOs to same queue
in .make_request_fn()?

If there isn't such case, I suggest the oneline change, together with
the pre-order traversal comment since it is very simple.

Thanks,

>
>   |<------ original bio ----->|
>   |piece|----remainder--------|
>
>   |piece| is then processed, just as it was before,
>   all recursive submissions turned into iterative processing,
>   in the exact order they have been called recursively.
>   Until all deeper level submissions have been fully processed.
>
>   If deeper levels are again calling bio_queue_split, their
>   respective remainder are queued in front of the "top level"
>   remainder.
>
>   And only then, the remainders are processed,
>   just as if they did come in as "original bio", see above.
>
> So if it did make progress before,
> it will make progress now.
>
>     Lars
>
