From: Ingo Molnar <mingo@elte.hu>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 21:01:10 +0200
Message-ID: <20091002190110.GA25297@elte.hu>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain> <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk> <20091002175629.GA14860@elte.hu> <20091002180437.GL31616@kernel.dk> <20091002183649.GE8161@mit.edu> <20091002184549.GS31616@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756796AbZJBTCP@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091002184549.GS31616@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Oct 02 2009, Theodore Tso wrote:
> > On Fri, Oct 02, 2009 at 08:04:37PM +0200, Jens Axboe wrote:
> > > > i'd say 'latency' describes it even better. 'interactivity' as a term is 
> > > > a bit overladen.
> > > 
> > > I'm not too crazy about it either. How about just using 'desktop' 
> > > since this is obviously what we are really targetting? 'latency' 
> > > isn't fully descriptive either, since it may not necessarily 
> > > provide the best single IO latency (noop would).
> > 
> > As Linus has already pointed out, it's not necessarily "desktop" 
> > versus "server".  There will be certain high frequency transaction 
> > database workloads (for example) that will very much care about 
> > latency.  I think "low_latency" may be the best term to use.
> 
> Not necessarily, but typically it will be. As already noted, I don't 
> think latency itself is a very descriptive term for this.

Why not? Nobody will think of 'latency' as something that requires noop, 
but as something that in practice achieves low latencies, for stuff that 
people use.

	Ingo
