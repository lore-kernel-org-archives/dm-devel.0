From: jing xia <jing.xia.mail@gmail.com>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Thu, 14 Jun 2018 15:16:41 +0800
Message-ID: <CAN=25QPkyNQfNmv8k5jgqRFcKo==pNVNEk+5Fpm+nqutY3ysWA@mail.gmail.com>
References: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com> <20180612212007.GA22717@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180612212007.GA22717@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Thank for your comment,I appreciate it.

On Wed, Jun 13, 2018 at 5:20 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, Jun 12 2018 at  4:03am -0400,
> Jing Xia <jing.xia.mail@gmail.com> wrote:
>
>> Performance test in android reports that the phone sometimes gets
>> hanged and shows black screen for about several minutes.The sysdump shows:
>> 1. kswapd and other tasks who enter the direct-reclaim path are waiting
>> on the dm_bufio_lock;
>
> Do you have an understanding of where they are waiting?  Is it in
> dm_bufio_shrink_scan()?
>

I'm sorry I don't make the issue clear.The kernel version in our
platform is k4.4, and
the implementation of dm_bufio_shrink_count() is still need to gain
the dm_bufio_lock.
So kswapd and other tasks in direct-reclaim are blocked in
dm_bufio_shrink_count().
According the sysdump,
1. those tasks are doing the shrink  in the same dm_bufio_shrinker
(the first dm_bufio_shrinker in the shrink_list), and waiting for the
same mutex lock;
2. the __GFP_FS is set to all of those tasks;

The dm_bufio_lock is not necessary in dm_bufio_shrink_count() at the
latest version,
but the issue may still happens, because the lock is also needed in
dm_bufio_shrink_scan().

the relevant stack traces please refer to:

PID: 855    TASK: ffffffc07844a700  CPU: 1   COMMAND: "kswapd0"
 #0 [ffffffc078357920] __switch_to at ffffff8008085e48
 #1 [ffffffc078357940] __schedule at ffffff8008850cc8
 #2 [ffffffc0783579a0] schedule at ffffff8008850f4c
 #3 [ffffffc0783579c0] schedule_preempt_disabled at ffffff8008851284
 #4 [ffffffc0783579e0] __mutex_lock_slowpath at ffffff8008852898
 #5 [ffffffc078357a50] mutex_lock at ffffff8008852954
 #6 [ffffffc078357a70] dm_bufio_shrink_count at ffffff8008591d08
 #7 [ffffffc078357ab0] do_shrink_slab at ffffff80081753e0
 #8 [ffffffc078357b30] shrink_slab at ffffff8008175f3c
 #9 [ffffffc078357bd0] shrink_zone at ffffff8008178860
#10 [ffffffc078357c70] balance_pgdat at ffffff8008179838
#11 [ffffffc078357d70] kswapd at ffffff8008179e48
#12 [ffffffc078357e20] kthread at ffffff80080bae34

PID: 15538  TASK: ffffffc006833400  CPU: 3   COMMAND: "com.qiyi.video"
 #0 [ffffffc027637660] __switch_to at ffffff8008085e48
 #1 [ffffffc027637680] __schedule at ffffff8008850cc8
 #2 [ffffffc0276376e0] schedule at ffffff8008850f4c
 #3 [ffffffc027637700] schedule_preempt_disabled at ffffff8008851284
 #4 [ffffffc027637720] __mutex_lock_slowpath at ffffff8008852898
 #5 [ffffffc027637790] mutex_lock at ffffff8008852954
 #6 [ffffffc0276377b0] dm_bufio_shrink_count at ffffff8008591d08
 #7 [ffffffc0276377f0] do_shrink_slab at ffffff80081753e0
 #8 [ffffffc027637870] shrink_slab at ffffff8008175f3c
 #9 [ffffffc027637910] shrink_zone at ffffff8008178860
#10 [ffffffc0276379b0] do_try_to_free_pages at ffffff8008178bc4
#11 [ffffffc027637a50] try_to_free_pages at ffffff8008178f3c
#12 [ffffffc027637af0] __perform_reclaim at ffffff8008169130
#13 [ffffffc027637b70] __alloc_pages_nodemask at ffffff800816c9b8
#14 [ffffffc027637c90] handle_mm_fault at ffffff800819025c
#15 [ffffffc027637d80] do_page_fault at ffffff80080949f8
#16 [ffffffc027637df0] do_mem_abort at ffffff80080812f8


>> 2. the task who gets the dm_bufio_lock is stalled for IO completions,
>> the relevant stack trace as :
>>
>> PID: 22920  TASK: ffffffc0120f1a00  CPU: 1   COMMAND: "kworker/u8:2"
>>  #0 [ffffffc0282af3d0] __switch_to at ffffff8008085e48
>>  #1 [ffffffc0282af3f0] __schedule at ffffff8008850cc8
>>  #2 [ffffffc0282af450] schedule at ffffff8008850f4c
>>  #3 [ffffffc0282af470] schedule_timeout at ffffff8008853a0c
>>  #4 [ffffffc0282af520] schedule_timeout_uninterruptible at ffffff8008853aa8
>>  #5 [ffffffc0282af530] wait_iff_congested at ffffff8008181b40
>>  #6 [ffffffc0282af5b0] shrink_inactive_list at ffffff8008177c80
>>  #7 [ffffffc0282af680] shrink_lruvec at ffffff8008178510
>>  #8 [ffffffc0282af790] mem_cgroup_shrink_node_zone at ffffff80081793bc
>>  #9 [ffffffc0282af840] mem_cgroup_soft_limit_reclaim at ffffff80081b6040
>
> Understanding the root cause for why the IO isn't completing quick
> enough would be nice.  Is the backing storage just overwhelmed?
>

Some information we can get from the sysdump:
1. swap-space is used out;
2. many tasks need to allocate a lot of  memory;
3. IOwait is 100%;

>> This patch aims to reduce the dm_bufio_lock contention when multiple
>> tasks do shrink_slab() at the same time.It is acceptable that task
>> will be allowed to reclaim from other shrinkers or reclaim from dm-bufio
>> next time, rather than stalled for the dm_bufio_lock.
>
> Your patch just looks to be papering over the issue.  Like you're
> treating the symptom rather than the problem.
>
Yes, maybe you are right.

>> Signed-off-by: Jing Xia <jing.xia@unisoc.com>
>> Signed-off-by: Jing Xia <jing.xia.mail@gmail.com>
>
> You only need one Signed-off-by.
>
Thanks, I got it.

>> ---
>>  drivers/md/dm-bufio.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
>> index c546b56..402a028 100644
>> --- a/drivers/md/dm-bufio.c
>> +++ b/drivers/md/dm-bufio.c
>> @@ -1647,10 +1647,19 @@ static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
>>  static unsigned long
>>  dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>>  {
>> +     unsigned long count;
>> +     unsigned long retain_target;
>> +
>>       struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
>> -     unsigned long count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
>> +
>> +     if (!dm_bufio_trylock(c))
>> +             return 0;
>> +
>> +     count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
>>                             READ_ONCE(c->n_buffers[LIST_DIRTY]);
>> -     unsigned long retain_target = get_retain_buffers(c);
>> +     retain_target = get_retain_buffers(c);
>> +
>> +     dm_bufio_unlock(c);
>>
>>       return (count < retain_target) ? 0 : (count - retain_target);
>>  }
>> --
>> 1.9.1
>>
>
> The reality of your patch is, on a heavily used bufio-backed volume,
> you're effectively disabling the ability to reclaim bufio memory via the
> shrinker.
>
> Because chances are the bufio lock will always be contended for a
> heavily used bufio client.
>

If the bufio lock will always be contended for a heavily used bufio client, this
patch is may not a good way to solve the problem.

> But after a quick look, I'm left wondering why dm_bufio_shrink_scan()'s
> dm_bufio_trylock() isn't sufficient to short-circuit the shrinker for
> your use-case?
> Maybe __GFP_FS is set so dm_bufio_shrink_scan() only ever uses
> dm_bufio_lock()?
>
> Is a shrinker able to be reentered by the VM subsystem
> (e.g. shrink_slab() calls down into same shrinker from multiple tasks
> that hit direct reclaim)?
> If so, a better fix could be to add a flag to the bufio client so we can
> know if the same client is being re-entered via the shrinker (though
> it'd likely be a bug for the shrinker to do that!).. and have
> dm_bufio_shrink_scan() check that flag and return SHRINK_STOP if set.
>
> That said, it could be that other parts of dm-bufio are monopolizing the
> lock as part of issuing normal IO (to your potentially slow
> backend).. in which case just taking the lock from the shrinker even
> once will block like you've reported.
>
> It does seem like additional analysis is needed to pinpoint exactly what
> is occuring.  Or some additional clarification needed (e.g. are the
> multiple tasks waiting for the bufio lock, as you reported with "1"
> above, waiting for the same exact shrinker's ability to get the same
> bufio lock?)
>
> But Mikulas, please have a look at this reported issue and let us know
> your thoughts.
>
> Thanks,
> Mike
