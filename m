From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: corruption causing crash in __queue_work
Date: Thu, 17 Dec 2015 12:15:37 -0500
Message-ID: <20151217171537.GA24921@redhat.com>
References: <566AF262.8050009@kyup.com>
 <20151211170805.GT30240@mtj.duckdns.org>
 <566E80AE.7020502@kyup.com>
 <20151214153147.GA14957@redhat.com>
 <CAJFSNy6qc-m_=FNuzrFJnvKJR2zSE12m8sQ3CCBRaBtyf=6AFg@mail.gmail.com>
 <20151214203138.GA2871@redhat.com>
 <56729272.2010803@kyup.com>
 <20151217153327.GI4026@mtj.duckdns.org>
 <5672D810.2010404@kyup.com>
 <20151217155032.GJ4026@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151217155032.GJ4026@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Nikolay Borisov <kernel@kyup.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 17 2015 at 10:50am -0500,
Tejun Heo <tj@kernel.org> wrote:

> Hello, Nikolay.
> 
> On Thu, Dec 17, 2015 at 05:43:12PM +0200, Nikolay Borisov wrote:
> > Right, but my initial understanding was that when canceling the delayed
> > work and then issuing flush_workqueue would act the same way as if
> > cancel_delayed_work_sync is called wrt to this particular delayed item, no?
> 
> Not necessarily.  cancel_delayed_work() cancels whatever is currently
> pending.  flush_workqueue() flushes whatever is pending and in flight
> at the time of invocation.  Imagine the following scenario.
> 
> 1. Work item is running but hasn't requeued itself yet.
> 
> 2. cancel_delayed_work_sync() doesn't do anything as it's not pending.

Did you mean cancel_delayed_work()?

> 3. flush_workqueue() starts and waits for the running instance.
> 
> 4. The running instance requeues itself but this isn't included in the
>    scope of the above flush_workqueue().
> 
> 5. flush_workqueue() returns when the work item is finished (but it's
>    still queued).

Hmm, the comment above cancel_delayed_work() is pretty misleading then:

 * Note:
 * The work callback function may still be running on return, unless
 * it returns %true and the work doesn't re-arm itself.  Explicitly flush or
 * use cancel_delayed_work_sync() to wait on it.

Given dm-thin.c:pool_postsuspend() does:

        cancel_delayed_work(&pool->waker);
        cancel_delayed_work(&pool->no_space_timeout);
        flush_workqueue(pool->wq);

I wouldn't have thought cancel_delayed_work_sync() was needed.
