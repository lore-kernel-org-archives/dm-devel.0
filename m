From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v3 for-4.4] block: flush queued bios when process blocks
 to avoid deadlock
Date: Thu, 22 Oct 2015 09:53:11 +0800
Message-ID: <CACVXFVOsZuwQ=D1rW_aP+WhOZrqfHf3TkJOgzkiXcNMwGWuM2g@mail.gmail.com>
References: <5384CE82.90601@kernel.dk>
	<alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
	<20151005205943.GB25762@redhat.com>
	<alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
	<20151006185016.GA31955@redhat.com>
	<20151006201637.GA4158@redhat.com>
	<alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
	<20151008150859.GA11770@redhat.com>
	<20151009195203.GA18790@redhat.com>
	<20151009195907.GB18790@redhat.com>
	<20151014204739.GA23449@redhat.com>
	<CACVXFVP7GwgWUHc4sHZwShwmdzFT5ZrHRcEH4zd5A8HommmCJg@mail.gmail.com>
	<alpine.LRH.2.02.1510201544450.5249@file01.intranet.prod.int.rdu2.redhat.com>
	<CACVXFVPfaJwKDzh+t0f9uxxTxrXE33bLZew5+FoKjGiYvsKW1Q@mail.gmail.com>
	<alpine.LRH.2.02.1510211718310.21723@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1510211718310.21723@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Alasdair G. Kergon" <agk@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 22, 2015 at 5:49 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Thu, 22 Oct 2015, Ming Lei wrote:
>
>> > Some drivers (dm-snapshot, dm-thin) do acquire a mutex in .make_requests()
>> > for every bio. It wouldn't be practical to convert them to not acquire the
>> > mutex (and it would also degrade performance of these drivers, if they had
>> > to offload every bio to a worker thread that can acquire the mutex).
>>
>> Lots of drivers handle I/O in that way, and this way makes AIO not possible
>> basically for dm-snapshot.
>
> It doesn't have to do anything with asynchronous I/O. Of course you can do
> asynchronous I/O on dm-snapshot.

But it is actually sync I/O because submit_bio() will block on the semaphore,
so this behavious isn't acceptable from AIO view. That should be why there
are very few drivers to use semaphoe/mutex in I/O path.

I have found zram has removed its rwlock from its I/O path in v3.17.

>
>> >> Also sometimes it can hurt performance by converting I/O submission
>> >> from one context into concurrent contexts of workqueue, especially
>> >> in case of sequential I/O, since plug & plug merge can't be used any
>> >> more.
>> >
>> > You can add blk_start_plug/blk_finish_plug to the function
>> > bio_alloc_rescue. That would be reasonable to make sure that the requests
>> > are merged even when they are offloaded to rescue thread.
>>
>> The IOs submitted from each wq context becomes not contineous any
>> more, so plug merge isn't doable, not mention the extra context switch
>> cost.
>
> If the requests are mergeable, blk_start_plug/blk_finish_plug will merge
> them, if not, it won't.

Plug is per task, and these requests are mergeable previously from one
same task, but after you submit them from different context via wq, it
becomes not mergeable any more via plug. Also context switch isn't free.

>
>> This kind of cost can be introduced for all bio devices just for handling
>> the unusual case, fair?
>
> Offloading bios to a worker thread when the make_request_fn function
> blocks is required to avoid a deadlock (BTW. the deadlock became more
> common in the kernel 4.3 due to unrestricted size of bios).
>
> The bio list current->bio_list introduces a false locking dependency -
> completion of a bio depends on completion of other bios on
> current->bio_list directed for different devices, thus it could create
> circular dependency resulting in deadlock.
>
> To avoid the circular dependency, each bio must be offloaded to a specific
> workqueue, so that completion of bio for device A no longer depends on
> completion of another bio for device B.

You can do that for dm-snapshot only by using per-device thread/wq or
whatever, but it isn't good to make other drivers involved by reusing
rescure wq.

>
>> >> > -       queue_work(bs->rescue_workqueue, &bs->rescue_work);
>> >> > +               spin_lock(&bs->rescue_lock);
>> >> > +               bio_list_add(&bs->rescue_list, bio);
>> >> > +               queue_work(bs->rescue_workqueue, &bs->rescue_work);
>> >> > +               spin_unlock(&bs->rescue_lock);
>> >> > +       }
>> >>
>> >> Not like rescuring path, schedule out can be quite frequent, and the
>> >> above change will switch to submit these I/Os from wq concurrently,
>> >> which might hurt performance for sequential I/O.
>> >>
>> >> Also I am wondering why not submit these I/Os in 'current' context
>> >> just like what flush plug does?
>> >
>> > Processing requests doesn't block (they only take the queue spinlock).
>> >
>> > Processing bios can block (they can take other mutexes or semaphores), so
>> > processing them from the schedule hook is impossible - the bio's
>> > make_request function could attempt to take some lock that is already
>> > held. So - we must offload the bios to a separate workqueue.
>>
>> Yes, so better to just handle dm-snapshot in this way.
>
> All dm targets and almost all other bio-processing drivers can block in
> the make_request_fn function (for example, they may block when allocating
> from a mempool).

blk_queue_bio() and its mq pairs can block in get_request() too, and that is
acceptable, but it isn't friendly/acceptable for AIO to use mutex/semaphoe
in I/O path which can block quite frequently.

--
Ming Lei
