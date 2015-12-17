From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: corruption causing crash in __queue_work
Date: Thu, 17 Dec 2015 12:46:10 +0200
Message-ID: <56729272.2010803@kyup.com>
References: <20151209160803.GK30240@mtj.duckdns.org>
 <56685573.1020805@kyup.com> <20151209162744.GN30240@mtj.duckdns.org>
 <566945A2.1050208@kyup.com> <20151210152901.GR30240@mtj.duckdns.org>
 <566AF262.8050009@kyup.com> <20151211170805.GT30240@mtj.duckdns.org>
 <566E80AE.7020502@kyup.com> <20151214153147.GA14957@redhat.com>
 <CAJFSNy6qc-m_=FNuzrFJnvKJR2zSE12m8sQ3CCBRaBtyf=6AFg@mail.gmail.com>
 <20151214203138.GA2871@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151214203138.GA2871@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On 12/14/2015 10:31 PM, Mike Snitzer wrote:
> On Mon, Dec 14 2015 at  3:11pm -0500,
> Nikolay Borisov <kernel@kyup.com> wrote:
> 
>> On Mon, Dec 14, 2015 at 5:31 PM, Mike Snitzer <snitzer@redhat.com> wrote:
>>> On Mon, Dec 14 2015 at  3:41P -0500,
>>> Nikolay Borisov <kernel@kyup.com> wrote:
>>>
>>>> Had another poke at the backtrace that is produced and here what the
>>>> delayed_work looks like:
>>>>
>>>> crash> struct delayed_work ffff88036772c8c0
>>>> struct delayed_work {
>>>>   work = {
>>>>     data = {
>>>>       counter = 1537
>>>>     },
>>>>     entry = {
>>>>       next = 0xffff88036772c8c8,
>>>>       prev = 0xffff88036772c8c8
>>>>     },
>>>>     func = 0xffffffffa0211a30 <do_waker>
>>>>   },
>>>>   timer = {
>>>>     entry = {
>>>>       next = 0x0,
>>>>       prev = 0xdead000000200200
>>>>     },
>>>>     expires = 4349463655,
>>>>     base = 0xffff88047fd2d602,
>>>>     function = 0xffffffff8106da40 <delayed_work_timer_fn>,
>>>>     data = 18446612146934696128,
>>>>     slack = -1,
>>>>     start_pid = -1,
>>>>     start_site = 0x0,
>>>>     start_comm =
>>>> "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
>>>>   },
>>>>   wq = 0xffff88030cf65400,
>>>>   cpu = 21
>>>> }
>>>>
>>>> From this it seems that the timer is also cancelled/expired judging by
>>>> the values in timer -> entry. But then again in dm-thin the pool is
>>>> first suspended, which implies the following functions were called:
>>>>
>>>> cancel_delayed_work(&pool->waker);
>>>> cancel_delayed_work(&pool->no_space_timeout);
>>>> flush_workqueue(pool->wq);
>>>>
>>>> so at that point dm-thin's workqueue should be empty and it shouldn't be
>>>> possible to queue any more delayed work. But the crashdump clearly shows
>>>> that the opposite is happening. So far all of this points to a race
>>>> condition and inserting some sleeps after umount and after vgchange -Kan
>>>> (command to disable volume group and suspend, so the cancel_delayed_work
>>>> is invoked) seems to reduce the frequency of crashes, though it doesn't
>>>> eliminate them.
>>>
>>> 'vgchange -Kan' doesn't suspend the pool before it destroys the device.
>>> So the cancel_delayed_work()s you referenced aren't applicable.
>>
>> Hm, but does it not in fact destroy it. Using the following simple
>> stap script proves so:
>>
>>
>> probe module("dm_thin_pool").function("__pool_destroy") {
>>     print("=========__pool_destroy======");
>>     print_backtrace();
>>
>> }
>>
>> probe module("dm_thin_pool").function("pool_postsuspend") {
>>
>>     printf("==== POOL_POSTSUSPEND =====\n");
>>     print_backtrace();
>>
>> }
>>
>> Produces the following backtraces:
>>
>> ==== POOL_POSTSUSPEND =====
>>  0xffffffffa033ad40 : pool_postsuspend+0x0/0x50 [dm_thin_pool]
>>  0xffffffff8148a5bf : suspend_targets+0x3f/0x90 [kernel]
>>  0xffffffff8148a668 : dm_table_postsuspend_targets+0x18/0x20 [kernel]
>>  0xffffffff814886dc : __dm_destroy+0x17c/0x190 [kernel]
>>  0xffffffff81488723 : dm_destroy+0x13/0x20 [kernel]
>>  0xffffffff8148f55a : dev_remove+0xfa/0x130 [kernel]
>>  0xffffffff8148fe94 : ctl_ioctl+0x1d4/0x2e0 [kernel]
>>  0xffffffff8148ffb3 : dm_ctl_ioctl+0x13/0x20 [kernel]
>>  0xffffffff811af3f3 : do_vfs_ioctl+0x73/0x380 [kernel]
>>  0xffffffff811af792 : sys_ioctl+0x92/0xa0 [kernel]
>>  0xffffffff8159ae2e : entry_SYSCALL_64_fastpath+0x12/0x71 [kernel]
>> =========__pool_destroy====== 0xffffffffa033ae20 :
>> __pool_destroy+0x0/0x110 [dm_thin_pool]
>>  0xffffffffa033af61 : __pool_dec+0x31/0x50 [dm_thin_pool]
>>  0xffffffffa033afae : pool_dtr+0x2e/0x70 [dm_thin_pool]
>>  0xffffffff8148c085 : dm_table_destroy+0x65/0x120 [kernel]
>>  0xffffffff8148868a : __dm_destroy+0x12a/0x190 [kernel]
>>  0xffffffff81488723 : dm_destroy+0x13/0x20 [kernel]
>>  0xffffffff8148f55a : dev_remove+0xfa/0x130 [kernel]
>>  0xffffffff8148fe94 : ctl_ioctl+0x1d4/0x2e0 [kernel]
>>  0xffffffff8148ffb3 : dm_ctl_ioctl+0x13/0x20 [kernel]
>>  0xffffffff811af3f3 : do_vfs_ioctl+0x73/0x380 [kernel]
>>  0xffffffff811af792 : sys_ioctl+0x92/0xa0 [kernel]
>>  0xffffffff8159ae2e : entry_SYSCALL_64_fastpath+0x12/0x71 [kernel]
>>
>> When I run vgchange -Kan on a volume group. So in __dm_destroy before
>> dm_table_destroy (which calls pool_dtr)
>> the device is checked to see if it is suspended, and if not not dm
>> core would invoke the pre/post suspend hooks, and
>> this should cause the workqueue to be flushed and in quiescent state. No?
>>
>> What am I missing?
> 
> Nothing, clearly you're right!
>  
>>>
>>> Can you try this patch?
>>
>> I've scheduled some machines to go online with this patch and
>> will report back if it changes the situation. Thanks a lot!
> 
> Shouldn't make any difference given the above.
> 
> But in that the suspend hooks are used during destroy (if not already
> suspended): makes this report all the more bizarre.

I applied the following patch:

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 493c38e08bd2..ccbbf7823cf3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3506,8 +3506,8 @@ static void pool_postsuspend(struct dm_target *ti)
        struct pool_c *pt = ti->private;
        struct pool *pool = pt->pool;

-       cancel_delayed_work(&pool->waker);
-       cancel_delayed_work(&pool->no_space_timeout);
+       cancel_delayed_work_sync(&pool->waker);
+       cancel_delayed_work_sync(&pool->no_space_timeout);
        flush_workqueue(pool->wq);
        (void) commit(pool);
 }

And this seems to have resolved the crashes. For the past 24 hours I
haven't seen a single server crash whereas before at least 3-5 servers
would crash.

Given that, it seems like a race condition between destroying the
workqueue from dm-thin and cancelling all the delayed work.

Tejun, I've looked at cancel_delayed_work/cancel_delayed_work_sync and
they both call try_to_grab_pending and then their function diverges. Is
it possible that there is a latent race condition between canceling the
delayed work and the subsequent re-scheduling of the work item?
