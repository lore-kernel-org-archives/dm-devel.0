From: jim owens <jowens@hp.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 12:01:08 -0400
Message-ID: <4AC623C4.5050003@hp.com>
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
	<alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

Linus Torvalds wrote:
> 
> I really think we should do latency first, and throughput second.

Agree.

> It's _easy_ to get throughput. The people who care just about throughput 
> can always just disable all the work we do for latency.

But in my experience it is not that simple...

The argument latency vs throughput or desktop vs server is wrong.

I/O can never keep up with the ability of CPUs to dirty data.

On desktops and servers (really many-user-desktops) we want
minimum latency but the enemy is dirty VM.  If we ignore the
need for throughput to flush dirty pages, VM gets angry and
forced VM page cleaning I/O is bad I/O.

We want min latency with low dirty page percent but need to
switch to max write throughput at some high dirty page percent.

We can not prevent the cliff we fall off where the system
chokes because the dirty page load is too high, but if we
only worry about latency, we bring that choke point cliff in
so it happens with a lower load.  A 10% lower overload point
might be fine to get 100% better latency, but would desktop
users accept a 50% lower overload point where running one
more application makes the system appear hung?

Even desktop users commonly measure "how much work can I do
before the system becomes unresponsive".

jim
