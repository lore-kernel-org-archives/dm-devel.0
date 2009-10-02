From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 11:28:39 +0200
Message-ID: <20091002092839.GA26962@kernel.dk>
References: <1254034500.7933.6.camel@marge.simson.net>
	<20090927164235.GA23126@kernel.dk>
	<1254340730.7695.32.camel@marge.simson.net>
	<1254341139.7695.36.camel@marge.simson.net>
	<20090930202447.GA28236@redhat.com>
	<1254382405.7595.9.camel@marge.simson.net>
	<20091001185816.GU14918@kernel.dk>
	<1254464628.7158.101.camel@marge.simson.net>
	<20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091002092409.GA19529@elte.hu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ingo Molnar <mingo@elte.hu>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Oct 02 2009, Ingo Molnar wrote:
> 
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

It's really not that simple, if we go and do easy latency bits, then
throughput drops 30% or more. You can't say it's black and white latency
vs throughput issue, that's just not how the real world works. The
server folks would be most unpleased.

-- 
Jens Axboe
