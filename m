From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 20:04:37 +0200
Message-ID: <20091002180437.GL31616@kernel.dk>
References: <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> <20091002145610.GD31616@kernel.dk> <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain> <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk> <20091002175629.GA14860@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756673AbZJBSEf@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091002175629.GA14860@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 02 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Oct 02 2009, Ingo Molnar wrote:
> > > 
> > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > On Fri, Oct 02 2009, Ingo Molnar wrote:
> > > > > 
> > > > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > 
> > > > > > It's not _that_ easy, it depends a lot on the access patterns. A 
> > > > > > good example of that is actually the idling that we already do. 
> > > > > > Say you have two applications, each starting up. If you start them 
> > > > > > both at the same time and just care for the dumb low latency, then 
> > > > > > you'll do one IO from each of them in turn. Latency will be good, 
> > > > > > but throughput will be aweful. And this means that in 20s they are 
> > > > > > both started, while with the slice idling and priority disk access 
> > > > > > that CFQ does, you'd hopefully have both up and running in 2s.
> > > > > > 
> > > > > > So latency is good, definitely, but sometimes you have to worry 
> > > > > > about the bigger picture too. Latency is more than single IOs, 
> > > > > > it's often for complete operation which may involve lots of IOs. 
> > > > > > Single IO latency is a benchmark thing, it's not a real life 
> > > > > > issue. And that's where it becomes complex and not so black and 
> > > > > > white. Mike's test is a really good example of that.
> > > > > 
> > > > > To the extent of you arguing that Mike's test is artificial (i'm not 
> > > > > sure you are arguing that) - Mike certainly did not do an artificial 
> > > > > test - he tested 'konsole' cache-cold startup latency, such as:
> > > > 
> > > > [snip]
> > > > 
> > > > I was saying the exact opposite, that Mike's test is a good example of 
> > > > a valid test. It's not measuring single IO latencies, it's doing a 
> > > > sequence of valid events and looking at the latency for those. It's 
> > > > benchmarking the bigger picture, not a microbenchmark.
> > > 
> > > Good, so we are in violent agreement :-)
> > 
> > Yes, perhaps that last sentence didn't provide enough evidence of 
> > which category I put Mike's test into :-)
> > 
> > So to kick things off, I added an 'interactive' knob to CFQ and 
> > defaulted it to on, along with re-enabling slice idling for hardware 
> > that does tagged command queuing. This is almost completely identical 
> > to what Vivek Goyal originally posted, it's just combined into one and 
> > uses the term 'interactive' instead of 'fairness'. I think the former 
> > is a better umbrella under which to add further tweaks that may 
> > sacrifice throughput slightly, in the quest for better latency.
> > 
> > It's queued up in the for-linus branch.
> 
> i'd say 'latency' describes it even better. 'interactivity' as a term is 
> a bit overladen.

I'm not too crazy about it either. How about just using 'desktop' since
this is obviously what we are really targetting? 'latency' isn't fully
descriptive either, since it may not necessarily provide the best single
IO latency (noop would).

-- 
Jens Axboe
