From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 08:14:48 -0700 (PDT)
Message-ID: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
References: <1254340730.7695.32.camel@marge.simson.net>
	<1254341139.7695.36.camel@marge.simson.net>
	<20090930202447.GA28236@redhat.com>
	<1254382405.7595.9.camel@marge.simson.net>
	<20091001185816.GU14918@kernel.dk>
	<1254464628.7158.101.camel@marge.simson.net>
	<20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu>
	<20091002092839.GA26962@kernel.dk>
	<alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	<20091002145610.GD31616@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091002145610.GD31616@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids



On Fri, 2 Oct 2009, Jens Axboe wrote:
> 
> Mostly they care about throughput, and when they come running because
> some their favorite app/benchmark/etc is now 2% slower, I get to hear
> about it all the time. So yes, latency is not ignored, but mostly they
> yack about throughput.

The reason they yack about it is that they can measure it.

Give them the benchmark where it goes the other way, and tell them why 
they see a 2% deprovement. Give them some button they can tweak, because 
they will.

But make the default be low-latency. Because everybody cares about low 
latency, and the people who do so are _not_ the people who you give 
buttons to tweak things with.

> I agree, we can easily make CFQ be very about about latency. If you
> think that is fine, then lets just do that. Then we'll get to fix the
> server side up when the next RHEL/SLES/whatever cycle is honing in on a
> kernel, hopefully we wont have to start over when that happens.

I really think we should do latency first, and throughput second.

It's _easy_ to get throughput. The people who care just about throughput 
can always just disable all the work we do for latency. If they really 
care about just throughput, they won't want fairness either - none of that 
complex stuff.

			Linus
