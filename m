From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RT 1/2 v2] dm-snapshot: fix crash with the realtime kernel
Date: Mon, 25 Nov 2019 18:25:12 +0100
Message-ID: <20191125172512.q65pmda66un3cm2e@linutronix.de>
References: <alpine.LRH.2.02.1911121057490.12815@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1911121057490.12815@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Nikos Tsironis <ntsironis@arrikto.com>, Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, linux-rt-users@vger.kernel.org, tglx@linutronix.de
List-Id: dm-devel.ids

On 2019-11-12 11:09:51 [-0500], Mikulas Patocka wrote:
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-snap.c	2019-11-12 16:44:36.000000000 +0100
> +++ linux-2.6/drivers/md/dm-snap.c	2019-11-12 17:01:46.000000000 +0100
…
>  static void dm_exception_table_lock(struct dm_exception_table_lock *lock)
>  {
> +#ifndef CONFIG_PREEMPT_RT_BASE
>  	hlist_bl_lock(lock->complete_slot);
>  	hlist_bl_lock(lock->pending_slot);
> +#else
> +	spin_lock(lock->lock);

if you also set the lowest bit for complete_slot + pending_slot then
patch 2 of this mini series wouldn't be required. That means we could
keep the debug code on -RT. Or am I missing something?

> +#endif
>  }

Sebastian
