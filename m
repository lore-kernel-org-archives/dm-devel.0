From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] dm: Avoid sleeping while holding the dm_bufio lock
Date: Wed, 14 Dec 2016 16:53:16 -0800
Message-ID: <CAD=FV=WUEkuDNktZ1ShYZnbsCMBwjkTBAEX7UJU3UML6Nvy_+Q@mail.gmail.com>
References: <1479410660-31408-1-git-send-email-dianders@chromium.org> <alpine.LRH.2.02.1611231543020.31481@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1611231543020.31481@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Sonny Rao <sonnyrao@chromium.org>, Guenter Roeck <linux@roeck-us.net>
List-Id: dm-devel.ids

Hi,

On Wed, Nov 23, 2016 at 12:57 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Hi
>
> The GFP_NOIO allocation frees clean cached pages. The GFP_NOWAIT
> allocation doesn't. Your patch would incorrectly reuse buffers in a
> situation when the memory is filled with clean cached pages.
>
> Here I'm proposing an alternate patch that first tries GFP_NOWAIT
> allocation, then drops the lock and tries GFP_NOIO allocation.
>
> Note that the root cause why you are seeing this stacktrace is, that your
> block device is congested - i.e. there are too many requests in the
> device's queue - and note that fixing this wait won't fix the root cause
> (congested device).
>
> The congestion limits are set in blk_queue_congestion_threshold to 7/8 to
> 13/16 size of the nr_requests value.
>
> If you don't want your device to report the congested status, you can
> increase /sys/block/<device>/queue/nr_requests - you should test if your
> chromebook is faster of slower with this setting increased. But note that
> this setting won't increase the IO-per-second of the device.
>
> Mikulas
>
>
> On Thu, 17 Nov 2016, Douglas Anderson wrote:
>
>> We've seen in-field reports showing _lots_ (18 in one case, 41 in
>> another) of tasks all sitting there blocked on:
>>
>>   mutex_lock+0x4c/0x68
>>   dm_bufio_shrink_count+0x38/0x78
>>   shrink_slab.part.54.constprop.65+0x100/0x464
>>   shrink_zone+0xa8/0x198
>>
>> In the two cases analyzed, we see one task that looks like this:
>>
>>   Workqueue: kverityd verity_prefetch_io
>>
>>   __switch_to+0x9c/0xa8
>>   __schedule+0x440/0x6d8
>>   schedule+0x94/0xb4
>>   schedule_timeout+0x204/0x27c
>>   schedule_timeout_uninterruptible+0x44/0x50
>>   wait_iff_congested+0x9c/0x1f0
>>   shrink_inactive_list+0x3a0/0x4cc
>>   shrink_lruvec+0x418/0x5cc
>>   shrink_zone+0x88/0x198
>>   try_to_free_pages+0x51c/0x588
>>   __alloc_pages_nodemask+0x648/0xa88
>>   __get_free_pages+0x34/0x7c
>>   alloc_buffer+0xa4/0x144
>>   __bufio_new+0x84/0x278
>>   dm_bufio_prefetch+0x9c/0x154
>>   verity_prefetch_io+0xe8/0x10c
>>   process_one_work+0x240/0x424
>>   worker_thread+0x2fc/0x424
>>   kthread+0x10c/0x114
>>
>> ...and that looks to be the one holding the mutex.
>>
>> The problem has been reproduced on fairly easily:
>> 0. Be running Chrome OS w/ verity enabled on the root filesystem
>> 1. Pick test patch: http://crosreview.com/412360
>> 2. Install launchBalloons.sh and balloon.arm from
>>      http://crbug.com/468342
>>    ...that's just a memory stress test app.
>> 3. On a 4GB rk3399 machine, run
>>      nice ./launchBalloons.sh 4 900 100000
>>    ...that tries to eat 4 * 900 MB of memory and keep accessing.
>> 4. Login to the Chrome web browser and restore many tabs
>>
>> With that, I've seen printouts like:
>>   DOUG: long bufio 90758 ms
>> ...and stack trace always show's we're in dm_bufio_prefetch().
>>
>> The problem is that we try to allocate memory with GFP_NOIO while
>> we're holding the dm_bufio lock.  Instead we should be using
>> GFP_NOWAIT.  Using GFP_NOIO can cause us to sleep while holding the
>> lock and that causes the above problems.
>>
>> The current behavior explained by David Rientjes:
>>
>>   It will still try reclaim initially because __GFP_WAIT (or
>>   __GFP_KSWAPD_RECLAIM) is set by GFP_NOIO.  This is the cause of
>>   contention on dm_bufio_lock() that the thread holds.  You want to
>>   pass GFP_NOWAIT instead of GFP_NOIO to alloc_buffer() when holding a
>>   mutex that can be contended by a concurrent slab shrinker (if
>>   count_objects didn't use a trylock, this pattern would trivially
>>   deadlock).
>>
>> Suggested-by: David Rientjes <rientjes@google.com>
>> Signed-off-by: Douglas Anderson <dianders@chromium.org>
>> ---
>> Note that this change was developed and tested against the Chrome OS
>> 4.4 kernel tree, not mainline.  Due to slight differences in verity
>> between mainline and Chrome OS it became too difficult to reproduce my
>> testing setup on mainline.  This patch still seems correct and
>> relevant to upstream, so I'm posting it.  If this is not acceptible to
>> you then please ignore this patch.
>>
>> Also note that when I tested the Chrome OS 3.14 kernel tree I couldn't
>> reproduce the long delays described in the patch.  Presumably
>> something changed in either the kernel config or the memory management
>> code between the two kernel versions that made this crop up.  In a
>> similar vein, it is possible that problems described in this patch are
>> no longer reproducible upstream.  However, the arguments made in this
>> patch (that we don't want to block while holding the mutex) still
>> apply so I think the patch may still have merit.
>>
>>  drivers/md/dm-bufio.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
>> index b3ba142e59a4..3c767399cc59 100644
>> --- a/drivers/md/dm-bufio.c
>> +++ b/drivers/md/dm-bufio.c
>> @@ -827,7 +827,8 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>>        * dm-bufio is resistant to allocation failures (it just keeps
>>        * one buffer reserved in cases all the allocations fail).
>>        * So set flags to not try too hard:
>> -      *      GFP_NOIO: don't recurse into the I/O layer
>> +      *      GFP_NOWAIT: don't wait; if we need to sleep we'll release our
>> +      *                  mutex and wait ourselves.
>>        *      __GFP_NORETRY: don't retry and rather return failure
>>        *      __GFP_NOMEMALLOC: don't use emergency reserves
>>        *      __GFP_NOWARN: don't print a warning in case of failure
>> @@ -837,7 +838,8 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>>        */
>>       while (1) {
>>               if (dm_bufio_cache_size_latch != 1) {
>> -                     b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
>> +                     b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY |
>> +                                      __GFP_NOMEMALLOC | __GFP_NOWARN);
>>                       if (b)
>>                               return b;
>>               }
>> --
>> 2.8.0.rc3.226.g39d4020
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>
> From: Mikulas Patocka <mpatocka@redhat.com>
>
> Subject: dm-bufio: drop the lock when doing GFP_NOIO alloaction
>
> Drop the lock when doing GFP_NOIO alloaction beacuse the allocation can
> take some time.
>
> Note that we won't do GFP_NOIO allocation when we loop for the second
> time, because the lock shouldn't be dropped between __wait_for_free_buffer
> and __get_unclaimed_buffer.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/md/dm-bufio.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-bufio.c
> +++ linux-2.6/drivers/md/dm-bufio.c
> @@ -822,11 +822,13 @@ enum new_flag {
>  static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client *c, enum new_flag nf)
>  {
>         struct dm_buffer *b;
> +       bool tried_noio_alloc = false;
>
>         /*
>          * dm-bufio is resistant to allocation failures (it just keeps
>          * one buffer reserved in cases all the allocations fail).
>          * So set flags to not try too hard:
> +        *      GFP_NOWAIT: don't sleep and don't release cache
>          *      GFP_NOIO: don't recurse into the I/O layer
>          *      __GFP_NORETRY: don't retry and rather return failure
>          *      __GFP_NOMEMALLOC: don't use emergency reserves
> @@ -837,7 +839,7 @@ static struct dm_buffer *__alloc_buffer_
>          */
>         while (1) {
>                 if (dm_bufio_cache_size_latch != 1) {
> -                       b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +                       b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
>                         if (b)
>                                 return b;
>                 }
> @@ -845,6 +847,15 @@ static struct dm_buffer *__alloc_buffer_
>                 if (nf == NF_PREFETCH)
>                         return NULL;
>
> +               if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
> +                       dm_bufio_unlock(c);
> +                       b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +                       dm_bufio_lock(c);
> +                       if (b)
> +                               return b;
> +                       tried_noio_alloc = true;
> +               }
> +
>                 if (!list_empty(&c->reserved_buffers)) {
>                         b = list_entry(c->reserved_buffers.next,
>                                        struct dm_buffer, lru_list);

I saw a git pull go by today from Mike Snitzer with my version of the
patch in it.  I think this is fine because I think my version of the
patch works all right, but I think Mikulas's version of the patch (see
above) is even better.

Since the "git pull" was to Linus and I believe that my version of the
patch is functional (even if it's not optimal), maybe the right thing
to do is to send a new patch with Mikulas's changes atop mine.
Mikulas: does that sound good to you?  Do you want to send it?

Thanks!

-Doug
