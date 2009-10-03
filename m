From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Sat, 03 Oct 2009 11:00:34 +0200
Message-ID: <1254560434.17052.14.camel@marge.simson.net>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
	 <1254549378.8299.21.camel@marge.simson.net>
	 <20091003072401.GV31616@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754190AbZJCJAj@vger.kernel.org>
In-Reply-To: <20091003072401.GV31616@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Sat, 2009-10-03 at 09:24 +0200, Jens Axboe wrote:

> After shutting down the computer yesterday, I was thinking a bit about
> this issue and how to solve it without incurring too much delay. If we
> add a stricter control of the depth, that may help. So instead of
> allowing up to max_quantum (or larger) depths, only allow gradual build
> up of that the farther we get away from a dispatch from the sync IO
> queues. For example, when switching to an async or seeky sync queue,
> initially allow just 1 in flight. For the next round, if there still
> hasn't been sync activity, allow 2, then 4, etc. If we see sync IO queue
> again, immediately drop to 1.
> 
> It could tie in with (or partly replace) the overload feature. The key
> to good latency and decent throughput is knowing when to allow queue
> build up and when not to.

Hm.  Starting at 1 sounds a bit thin (like IDLE), multiple iterations to
build/unleash any sizable IO, but that's just my gut talking.

	-Mike
