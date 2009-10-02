From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 16:45:42 +0200
Message-ID: <1254494742.7307.37.camel@marge.simson.net>
References: <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254340730.7695.32.camel@marge.simson.net>
	 <1254341139.7695.36.camel@marge.simson.net>
	 <20090930202447.GA28236@redhat.com>
	 <1254382405.7595.9.camel@marge.simson.net>
	 <20091001185816.GU14918@kernel.dk>
	 <1254464628.7158.101.camel@marge.simson.net>
	 <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu>
	 <20091002092839.GA26962@kernel.dk>
	 <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755945AbZJBOpw@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Fri, 2009-10-02 at 07:24 -0700, Linus Torvalds wrote:
> 
> On Fri, 2 Oct 2009, Jens Axboe wrote:
> > 
> > It's really not that simple, if we go and do easy latency bits, then
> > throughput drops 30% or more.
> 
> Well, if we're talking 500-950% improvement vs 30% deprovement, I think 
> it's pretty clear, though. Even the server people do care about latencies. 
> 
> Often they care quite a bit, in fact.
> 
> And Mike's patch didn't look big or complicated.

But it is a hack.  (thought about and measured, but hack nonetheless)

I haven't tested it on much other than reader vs streaming writer.  It
may well destroy the rest of the IO universe. I don't have the hw to
even test any hairy chested IO.

	-Mike
