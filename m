From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 11:36:54 +0200
Message-ID: <1254476214.11022.8.camel@marge.simson.net>
References: <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254340730.7695.32.camel@marge.simson.net>
	 <1254341139.7695.36.camel@marge.simson.net>
	 <20090930202447.GA28236@redhat.com>
	 <1254382405.7595.9.camel@marge.simson.net>
	 <20091001185816.GU14918@kernel.dk>
	 <1254464628.7158.101.camel@marge.simson.net>
	 <20091002080417.GG14918@kernel.dk>  <20091002092409.GA19529@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757453AbZJBJhA@vger.kernel.org>
In-Reply-To: <20091002092409.GA19529@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, riel@redhat.com
List-Id: dm-devel.ids

On Fri, 2009-10-02 at 11:24 +0200, Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > It's not hard to make the latency good, the hard bit is making sure we 
> > also perform well for all other scenarios.
> 
> Looking at the numbers from Mike:
> 
>  | dd competing against perf stat -- konsole -e exec timings, 5 back to 
>  | back runs
>  |                                                         Avg
>  | before         9.15    14.51     9.39    15.06     9.90   11.6
>  | after [+patch] 1.76     1.54     1.93     1.88     1.56    1.7
> 
> _PLEASE_ make read latencies this good - the numbers are _vastly_ 
> better. We'll worry about the 'other' things _after_ we've reached good 
> latencies.
> 
> I thought this principle was a well established basic rule of Linux IO 
> scheduling. Why do we have to have a 'latency vs. bandwidth' discussion 
> again and again? I thought latency won hands down.

Just a note:  In the testing I've done so far, we're better off today
than ever, and I can't recall beating on root ever being anything less
than agony for interactivity.  IO seekers look a lot like CPU sleepers
to me.  Looks like both can be as annoying as hell ;-)

	-Mike
