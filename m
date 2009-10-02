From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 19:13:54 +0200
Message-ID: <20091002171354.GH31616@kernel.dk>
References: <20090930202447.GA28236@redhat.com>
	<1254382405.7595.9.camel@marge.simson.net>
	<20091001185816.GU14918@kernel.dk>
	<1254464628.7158.101.camel@marge.simson.net>
	<20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu>
	<20091002092839.GA26962@kernel.dk>
	<alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	<20091002145610.GD31616@kernel.dk>
	<2c0942db0910020933l6d312c6ahae0e00619f598b39@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2c0942db0910020933l6d312c6ahae0e00619f598b39@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ray Lee <ray-lk@madrabbit.org>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Fri, Oct 02 2009, Ray Lee wrote:
> On Fri, Oct 2, 2009 at 7:56 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > In some cases I wish we had a server vs desktop switch, since it would
> > decisions on this easier. I know you say that servers care about
> > latency, but not at all to the extent that desktops do. Most desktop
> > users would gladly give away the top of the performance for latency,
> > that's not true of most server users. Depends on what the server does,
> > of course.
> 
> If most of the I/O on a system exhibits seeky tendencies, couldn't the
> schedulers notice that and use that as the hint for what to optimize?
> 
> I mean, there's no switch better than the actual I/O behavior itself.

Heuristics like that have a tendency to fail. What's the cut-off point?
Additionally, heuristics based on past process/system behaviour also has
a tendency to be suboptimal, since things aren't static.

We already look at seekiness of individual processes or groups. IIRC,
as-iosched also keeps a per-queue tracking.

-- 
Jens Axboe
