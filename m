From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Sat, 3 Oct 2009 15:17:16 +0200
Message-ID: <20091003131716.GZ31616@kernel.dk>
References: <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk>
	<20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk>
	<1254507215.8667.7.camel@marge.simson.net>
	<20091002181903.GN31616@kernel.dk>
	<1254548931.8299.18.camel@marge.simson.net>
	<1254549378.8299.21.camel@marge.simson.net>
	<20091003072401.GV31616@kernel.dk>
	<1254560434.17052.14.camel@marge.simson.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1254560434.17052.14.camel@marge.simson.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Galbraith <efault@gmx.de>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Sat, Oct 03 2009, Mike Galbraith wrote:
> On Sat, 2009-10-03 at 09:24 +0200, Jens Axboe wrote:
> 
> > After shutting down the computer yesterday, I was thinking a bit about
> > this issue and how to solve it without incurring too much delay. If we
> > add a stricter control of the depth, that may help. So instead of
> > allowing up to max_quantum (or larger) depths, only allow gradual build
> > up of that the farther we get away from a dispatch from the sync IO
> > queues. For example, when switching to an async or seeky sync queue,
> > initially allow just 1 in flight. For the next round, if there still
> > hasn't been sync activity, allow 2, then 4, etc. If we see sync IO queue
> > again, immediately drop to 1.
> > 
> > It could tie in with (or partly replace) the overload feature. The key
> > to good latency and decent throughput is knowing when to allow queue
> > build up and when not to.
> 
> Hm.  Starting at 1 sounds a bit thin (like IDLE), multiple iterations to
> build/unleash any sizable IO, but that's just my gut talking.

Not sure, will need some testing of course. But it'll build up quickly.

-- 
Jens Axboe
