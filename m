From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 14:22:16 +0200
Message-ID: <1254486136.11743.62.camel@marge.simson.net>
References: <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254340730.7695.32.camel@marge.simson.net>
	 <1254341139.7695.36.camel@marge.simson.net>
	 <20090930202447.GA28236@redhat.com>
	 <1254382405.7595.9.camel@marge.simson.net>
	 <20091001185816.GU14918@kernel.dk>
	 <1254464628.7158.101.camel@marge.simson.net>
	 <20091002080417.GG14918@kernel.dk>
	 <1254473609.6378.24.camel@marge.simson.net>
	 <20091002095555.GB26962@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756036AbZJBMWX@vger.kernel.org>
In-Reply-To: <20091002095555.GB26962@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

On Fri, 2009-10-02 at 11:55 +0200, Jens Axboe wrote:
> On Fri, Oct 02 2009, Mike Galbraith wrote:
> >
> >         /*
> >          * Drain async requests before we start sync IO
> >          */
> >         if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> > 
> > Looked about the same to me as..
> >  
> > 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
> > 
> > ..where Vivek prevented turning 1 into 0, so I stamped it ;-)
> 
> cfq_cfqq_idle_window(cfqq) just tells you whether this queue may enter
> idling, not that it is currently idling. The actual idling happens from
> cfq_completed_request(), here:
> 
>                 else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
>                          sync && !rq_noidle(rq))
>                         cfq_arm_slice_timer(cfqd);
> 
> and after that the queue will be marked as waiting, so
> cfq_cfqq_wait_request(cfqq) is a better indication of whether we are
> currently waiting for a request (idling) or not.

Hm.  Then cfq_cfqq_idle_window(cfqq) actually suits my intent better.

(If I want to reduce async's advantage, I should target specifically, ie
only stamp if this queue is a sync queue....otoh, if this queue is sync,
it is now officially too late, whereas if this queue is dd about to
inflict the wrath of kjournald on my reader's world, stamping now is a
really good idea.. scritch scritch scritch <smoke>)

I'll go tinker with it.  Thanks for the clue.

	-Mike
