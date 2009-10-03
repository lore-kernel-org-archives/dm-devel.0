From: Mike Galbraith <efault@gmx.de>
Subject: Re: Do not overload dispatch queue (Was: Re: IO
 scheduler based IO controller V10)
Date: Sat, 03 Oct 2009 21:07:44 +0200
Message-ID: <1254596864.7153.9.camel@marge.simson.net>
References: <1254549378.8299.21.camel@marge.simson.net>
	<20091003112915.GA12925@redhat.com> <20091003124049.GB12925@redhat.com>
	<20091003132115.GB31616@kernel.dk> <20091003135623.GD12925@redhat.com>
	<1254578553.7499.5.camel@marge.simson.net>
	<20091003142840.GE31616@kernel.dk>
	<1254581496.8293.8.camel@marge.simson.net>
	<20091003151445.GF31616@kernel.dk>
	<1254585420.7539.2.camel@marge.simson.net>
	<20091003173532.GG31616@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091003173532.GG31616@kernel.dk>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Sat, 2009-10-03 at 19:35 +0200, Jens Axboe wrote:
> On Sat, Oct 03 2009, Mike Galbraith wrote:
> > On Sat, 2009-10-03 at 17:14 +0200, Jens Axboe wrote:
> > > On Sat, Oct 03 2009, Mike Galbraith wrote:
> > > > On Sat, 2009-10-03 at 16:28 +0200, Jens Axboe wrote:
> > > > > On Sat, Oct 03 2009, Mike Galbraith wrote:
> > > > > > On Sat, 2009-10-03 at 09:56 -0400, Vivek Goyal wrote:
> > > > > > 
> > > > > > > I have kept the overload delay period as "cfq_slice_sync" same as Mike had
> > > > > > > done. We shall have to experiment what is a good waiting perioed. Is 100ms
> > > > > > > too long if we are waiting for a request from same process which recently
> > > > > > > finished IO and we did not enable idle on it.
> > > > > > > 
> > > > > > > I guess we can tweak the delay period as we move along.
> > > > > > 
> > > > > > I kept the delay period very short to minimize possible damage. Without
> > > > > > the idle thing, it wasn't enough, but with, worked a treat, as does your
> > > > > > patch.
> > > > > 
> > > > > Can you test the current line up of patches in for-linus? It has the
> > > > > ramp up I talked about included as well.
> > > > 
> > > > Well, it hasn't hit git.kernel.org yet, it's at...
> > > > 
> > > > * block-for-linus        1d22351 cfq-iosched: add a knob for desktop interactiveness
> > > 
> > > It's the top three patches here, kernel.org sync sometimes takes a
> > > while...
> > > 
> > > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-linus
> > 
> > Ok, already had the first two in, added the last.
> > 
> > Entered uncharted territory for konsole -e exit, but lost a bit of
> > throughput for home-brew concurrent git test.
> > 
> > perf stat      1.70     1.94     1.32     1.89     1.87    1.7     fairness=1 overload_delay=1
> >                1.55     1.79     1.38     1.53     1.57    1.5     desktop=1 +last_end_sync
> >                1.09     0.87     1.11     0.96     1.11    1.0     block-for-linus
> 
> So that's pure goodness, at least.

Yeah, but it's a double edged sword, _maybe_ cut too far in the other
direction.  (impression)

> > perf stat testo.sh                               Avg
> > 108.12   106.33    106.34    97.00    106.52   104.8  1.000 fairness=0 overload_delay=0
> >  93.98   102.44     94.47    97.70     98.90    97.4   .929 fairness=0 overload_delay=1
> >  90.87    95.40     95.79    93.09     94.25    93.8   .895 fairness=1 overload_delay=0
> >  89.93    90.57     89.13    93.43     93.72    91.3   .871 fairness=1 overload_delay=1
> >  89.81    88.82     91.56    96.57     89.38    91.2   .870 desktop=1 +last_end_sync
> >  92.61    94.60     92.35    93.17     94.05    93.3   .890 block-for-linus
> 
> Doesn't look too bad, all things considered. Apart from "stock" cfq,
> it's consistent. And being consistent is a Good Thing. Performance wise,
> it's losing out to "stock" but looks pretty competetive otherwise.

No, not bad at all, still a large win over stock.

> So far that looks like a winner. The dictator wanted good latency, he's
> getting good latency. I'll continue working on this on monday, while I'm
> waiting for delivery of the Trabant.

I'm unsure feel wise.  Disk is sounding too seeky, which worries me.

	-Mike
