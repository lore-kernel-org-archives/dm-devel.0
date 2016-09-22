From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm crypt: fix crash on exit
Date: Thu, 22 Sep 2016 17:30:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1609221702020.4447@file01.intranet.prod.int.rdu2.redhat.com>
References: <1474467749-30783-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474467749-30783-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rabin Vincent <rabin.vincent@axis.com>
Cc: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
List-Id: dm-devel.ids

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>


On Wed, 21 Sep 2016, Rabin Vincent wrote:

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
> ---
>  drivers/md/dm-crypt.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 8742957..6fc8923 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -113,8 +113,7 @@ struct iv_tcw_private {
>   * and encrypts / decrypts at the same time.
>   */
>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
> -	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
> -	     DM_CRYPT_EXIT_THREAD};
> +	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
>  
>  /*
>   * The fields in here must be read only after initialization.
> @@ -1207,18 +1206,20 @@ continue_locked:
>  		if (!RB_EMPTY_ROOT(&cc->write_tree))
>  			goto pop_from_list;
>  
> -		if (unlikely(test_bit(DM_CRYPT_EXIT_THREAD, &cc->flags))) {
> -			spin_unlock_irq(&cc->write_thread_wait.lock);
> -			break;
> -		}
> -
> -		__set_current_state(TASK_INTERRUPTIBLE);
> +		set_current_state(TASK_INTERRUPTIBLE);
>  		__add_wait_queue(&cc->write_thread_wait, &wait);
>  
>  		spin_unlock_irq(&cc->write_thread_wait.lock);
>  
> +		if (unlikely(kthread_should_stop())) {
> +			set_task_state(current, TASK_RUNNING);
> +			remove_wait_queue(&cc->write_thread_wait, &wait);
> +			break;
> +		}
> +
>  		schedule();
>  
> +		set_task_state(current, TASK_RUNNING);
>  		spin_lock_irq(&cc->write_thread_wait.lock);
>  		__remove_wait_queue(&cc->write_thread_wait, &wait);
>  		goto continue_locked;
> @@ -1533,13 +1534,8 @@ static void crypt_dtr(struct dm_target *ti)
>  	if (!cc)
>  		return;
>  
> -	if (cc->write_thread) {
> -		spin_lock_irq(&cc->write_thread_wait.lock);
> -		set_bit(DM_CRYPT_EXIT_THREAD, &cc->flags);
> -		wake_up_locked(&cc->write_thread_wait);
> -		spin_unlock_irq(&cc->write_thread_wait.lock);
> +	if (cc->write_thread)
>  		kthread_stop(cc->write_thread);
> -	}
>  
>  	if (cc->io_queue)
>  		destroy_workqueue(cc->io_queue);
> -- 
> 2.1.4
> 
