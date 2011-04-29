From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] workqueue: fix deadlock in worker_maybe_bind_and_lock()
Date: Fri, 29 Apr 2011 22:40:52 +0200
Message-ID: <201104292240.52825.rjw@sisk.pl>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com> <20110429160039.GP16552@htj.dyndns.org> <20110429161824.GQ16552@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110429161824.GQ16552@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Thilo-Alexander Ginkel <thilo@ginkel.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Friday, April 29, 2011, Tejun Heo wrote:
> From 5035b20fa5cd146b66f5f89619c20a4177fb736d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 29 Apr 2011 18:08:37 +0200
> 
> If a rescuer and stop_machine() bringing down a CPU race with each
> other, they may deadlock on non-preemptive kernel.  The CPU won't
> accept a new task, so the rescuer can't migrate to the target CPU,
> while stop_machine() can't proceed because the rescuer is holding one
> of the CPU retrying migration.  GCWQ_DISASSOCIATED is never cleared
> and worker_maybe_bind_and_lock() retries indefinitely.
> 
> This problem can be reproduced semi reliably while the system is
> entering suspend.
> 
>  http://thread.gmane.org/gmane.linux.kernel/1122051
> 
> A lot of kudos to Thilo-Alexander for reporting this tricky issue and
> painstaking testing.
> 
> stable: This affects all kernels with cmwq, so all kernels since and
>         including v2.6.36 need this fix.

Well, _that_ explains quite a number of mysterious reports where
suspend or poweroff hang randomly.

Thanks a lot of fixing it!

Rafael


> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
> Tested-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
> Cc: stable@kernel.org
> ---
> Will soon send pull request to Linus.  Thank you very much.
> 
>  kernel/workqueue.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 04ef830..e3378e8 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1291,8 +1291,14 @@ __acquires(&gcwq->lock)
>  			return true;
>  		spin_unlock_irq(&gcwq->lock);
>  
> -		/* CPU has come up inbetween, retry migration */
> +		/*
> +		 * We've raced with CPU hot[un]plug.  Give it a breather
> +		 * and retry migration.  cond_resched() is required here;
> +		 * otherwise, we might deadlock against cpu_stop trying to
> +		 * bring down the CPU on non-preemptive kernel.
> +		 */
>  		cpu_relax();
> +		cond_resched();
>  	}
>  }
>  
> 
