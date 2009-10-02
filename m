From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 19:25:54 +0200
Message-ID: <20091002172554.GJ31616@kernel.dk>
References: <20091001185816.GU14918@kernel.dk>
	<1254464628.7158.101.camel@marge.simson.net>
	<20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu>
	<20091002092839.GA26962@kernel.dk>
	<alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	<20091002145610.GD31616@kernel.dk>
	<alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	<20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091002172046.GA2376@elte.hu>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Fri, Oct 02 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > It's not _that_ easy, it depends a lot on the access patterns. A good 
> > example of that is actually the idling that we already do. Say you 
> > have two applications, each starting up. If you start them both at the 
> > same time and just care for the dumb low latency, then you'll do one 
> > IO from each of them in turn. Latency will be good, but throughput 
> > will be aweful. And this means that in 20s they are both started, 
> > while with the slice idling and priority disk access that CFQ does, 
> > you'd hopefully have both up and running in 2s.
> > 
> > So latency is good, definitely, but sometimes you have to worry about 
> > the bigger picture too. Latency is more than single IOs, it's often 
> > for complete operation which may involve lots of IOs. Single IO 
> > latency is a benchmark thing, it's not a real life issue. And that's 
> > where it becomes complex and not so black and white. Mike's test is a 
> > really good example of that.
> 
> To the extent of you arguing that Mike's test is artificial (i'm not 
> sure you are arguing that) - Mike certainly did not do an artificial 
> test - he tested 'konsole' cache-cold startup latency, such as:

[snip]

I was saying the exact opposite, that Mike's test is a good example of a
valid test. It's not measuring single IO latencies, it's doing a
sequence of valid events and looking at the latency for those. It's
benchmarking the bigger picture, not a microbenchmark.

-- 
Jens Axboe
