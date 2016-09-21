From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm crypt: fix crash on exit
Date: Wed, 21 Sep 2016 10:34:23 -0400
Message-ID: <20160921143423.GA9748@redhat.com>
References: <1474467749-30783-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474467749-30783-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rabin Vincent <rabin.vincent@axis.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, mpatocka@redhat.com, Rabin Vincent <rabinv@axis.com>
List-Id: dm-devel.ids

On Wed, Sep 21 2016 at 10:22am -0400,
Rabin Vincent <rabin.vincent@axis.com> wrote:

> From: Rabin Vincent <rabinv@axis.com>
> 
> As the documentation for kthread_stop() says, "if threadfn() may call
> do_exit() itself, the caller must ensure task_struct can't go away".
> dm-crypt does not ensure this and therefore crashes when crypt_dtr()
> calls kthread_stop().  The crash is trivially reproducible by adding a
> delay before the call to kthread_stop() and just opening and closing a
> dm-crypt device.
> 
>  general protection fault: 0000 [#1] PREEMPT SMP
>  CPU: 0 PID: 533 Comm: cryptsetup Not tainted 4.8.0-rc7+ #7
>  task: ffff88003bd0df40 task.stack: ffff8800375b4000
>  RIP: 0010: kthread_stop+0x52/0x300
>  Call Trace:
>   crypt_dtr+0x77/0x120
>   dm_table_destroy+0x6f/0x120
>   __dm_destroy+0x130/0x250
>   dm_destroy+0x13/0x20
>   dev_remove+0xe6/0x120
>   ? dev_suspend+0x250/0x250
>   ctl_ioctl+0x1fc/0x530
>   ? __lock_acquire+0x24f/0x1b10
>   dm_ctl_ioctl+0x13/0x20
>   do_vfs_ioctl+0x91/0x6a0
>   ? ____fput+0xe/0x10
>   ? entry_SYSCALL_64_fastpath+0x5/0xbd
>   ? trace_hardirqs_on_caller+0x151/0x1e0
>   SyS_ioctl+0x41/0x70
>   entry_SYSCALL_64_fastpath+0x1f/0xbd
> 
> This problem was introduced by bcbd94ff481e ("dm crypt: fix a possible
> hang due to race condition on exit").
> 
> Looking at the description of that patch (excerpted below), it seems
> like the problem it addresses can be solved by just using
> set_current_state instead of __set_current_state, since we obviously
> need the memory barrier.
> 
> | dm crypt: fix a possible hang due to race condition on exit
> |
> | A kernel thread executes __set_current_state(TASK_INTERRUPTIBLE),
> | __add_wait_queue, spin_unlock_irq and then tests kthread_should_stop().
> | It is possible that the processor reorders memory accesses so that
> | kthread_should_stop() is executed before __set_current_state().  If
> | such reordering happens, there is a possible race on thread
> | termination: [...]
> 
> So this patch just reverts the aforementioned patch and changes the
> __set_current_state(TASK_INTERRUPTIBLE) to set_current_state(...).  This
> fixes the crash and should also fix the potential hang.
> 
> Fixes: bcbd94ff481e ("dm crypt: fix a possible hang due to race condition on exit")
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org # v4.0+
> Signed-off-by: Rabin Vincent <rabinv@axis.com>

Thanks, I've staged this for the 4.9 merge window.
