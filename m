From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v3 for-4.4] block: flush queued bios when process blocks
 to avoid deadlock
Date: Thu, 22 Oct 2015 00:38:24 +0800
Message-ID: <CACVXFVPfaJwKDzh+t0f9uxxTxrXE33bLZew5+FoKjGiYvsKW1Q@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1510201544450.5249@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Alasdair G. Kergon" <agk@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 21, 2015 at 4:03 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Sun, 18 Oct 2015, Ming Lei wrote:
>
>> On Thu, Oct 15, 2015 at 4:47 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > From: Mikulas Patocka <mpatocka@redhat.com>
>> >
>> > The block layer uses per-process bio list to avoid recursion in
>> > generic_make_request.  When generic_make_request is called recursively,
>> > the bio is added to current->bio_list and generic_make_request returns
>> > immediately.  The top-level instance of generic_make_request takes bios
>> > from current->bio_list and processes them.
>> >
>> > Commit df2cb6daa4 ("block: Avoid deadlocks with bio allocation by
>> > stacking drivers") created a workqueue for every bio set and code
>> > in bio_alloc_bioset() that tries to resolve some low-memory deadlocks by
>> > redirecting bios queued on current->bio_list to the workqueue if the
>> > system is low on memory.  However another deadlock (see below **) may
>> > happen, without any low memory condition, because generic_make_request
>> > is queuing bios to current->bio_list (rather than submitting them).
>> >
>> > Fix this deadlock by redirecting any bios on current->bio_list to the
>> > bio_set's rescue workqueue on every schedule call.  Consequently, when
>> > the process blocks on a mutex, the bios queued on current->bio_list are
>> > dispatched to independent workqueus and they can complete without
>> > waiting for the mutex to be available.
>>
>> It isn't common to acquire mutex/semaphone inside .make_request()
>> or .request_fn(), so I am wondering it is good to reuse the rescuing
>> workqueue for this unusual case.
>
> Some drivers (dm-snapshot, dm-thin) do acquire a mutex in .make_requests()
> for every bio. It wouldn't be practical to convert them to not acquire the
> mutex (and it would also degrade performance of these drivers, if they had
> to offload every bio to a worker thread that can acquire the mutex).

Lots of drivers handle I/O in that way, and this way makes AIO not possible
basically for dm-snapshot.

>
> You can't acquire a mutex in .request_fn() because .request_fn() is called
> with queue spinlock held.

Lots of drivers are dropping the lock in the request_fn(), but I admit
.request_fn shouldn't be blocked.

>
>> Also sometimes it can hurt performance by converting I/O submission
>> from one context into concurrent contexts of workqueue, especially
>> in case of sequential I/O, since plug & plug merge can't be used any
>> more.
>
> You can add blk_start_plug/blk_finish_plug to the function
> bio_alloc_rescue. That would be reasonable to make sure that the requests
> are merged even when they are offloaded to rescue thread.

The IOs submitted from each wq context becomes not contineous any
more, so plug merge isn't doable, not mention the extra context switch
cost.

This kind of cost can be introduced for all bio devices just for handling
the unusual case, fair?

>
>> > -       queue_work(bs->rescue_workqueue, &bs->rescue_work);
>> > +               spin_lock(&bs->rescue_lock);
>> > +               bio_list_add(&bs->rescue_list, bio);
>> > +               queue_work(bs->rescue_workqueue, &bs->rescue_work);
>> > +               spin_unlock(&bs->rescue_lock);
>> > +       }
>>
>> Not like rescuring path, schedule out can be quite frequent, and the
>> above change will switch to submit these I/Os from wq concurrently,
>> which might hurt performance for sequential I/O.
>>
>> Also I am wondering why not submit these I/Os in 'current' context
>> just like what flush plug does?
>
> Processing requests doesn't block (they only take the queue spinlock).
>
> Processing bios can block (they can take other mutexes or semaphores), so
> processing them from the schedule hook is impossible - the bio's
> make_request function could attempt to take some lock that is already
> held. So - we must offload the bios to a separate workqueue.

Yes, so better to just handle dm-snapshot in this way.


Thanks,
Ming Lei
