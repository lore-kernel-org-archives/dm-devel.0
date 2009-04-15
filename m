From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [k-ueda@ct.jp.nec.com: Re: request-based
	dm-multipath]
Date: Wed, 15 Apr 2009 18:24:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904151757160.23374@hs20-bc2-1.build.redhat.com>
References: <20090410151914.GA3800@redhat.com>
	<20090410153102.GC3800@redhat.com>
	<Pine.LNX.4.64.0904151443170.23593@hs20-bc2-1.build.redhat.com>
	<20090415201829.GB9064@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090415201829.GB9064@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com, Michael Christie <mchristi@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, agk@redhat.com
List-Id: dm-devel.ids

On Wed, 15 Apr 2009, Mike Snitzer wrote:

> On Wed, Apr 15 2009 at  3:09pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > On Fri, 10 Apr 2009, Mike Snitzer wrote:
> > 
> > > Hi Mikulaus,
> > > 
> > > Figured I'd give you this heads up on the request-based multipath
> > > patches too considering your recent "bottom-layer barrier support"
> > > patchset (where you said multipath support is coming later).
> > > 
> > > We likely want to coordinate with the NEC guys so as to make sure things
> > > are in order for the request-based patches to get merged along with your
> > > remaining barrier work for 2.6.31.
> > > 
> > > Mike
> > > 
> > > p.s. below you can see I mistakenly said to Kiyoshi that the recent
> > > barrier patches that got merged upstream were "the last of the DM
> > > barrier support"...
> > 
> > Hi
> > 
> > I would say one thing about the request-based patches --- don't do this.
> > 
> > Your patch adds an alternate I/O path to request processing on device 
> > mapper.
> > 
> > So, with your patch, there will be two I/O request paths. It means that 
> > any work on generic device-mapper code that will have to be done in the 
> > future (such as for example barriers that I did) will be twice harder. It 
> > will take twice the time to understand request processing, twice brain 
> > capacity to remember it, twice the time for coding, twice the time for 
> > code review, twice the time for testing.
> > 
> > If the patch goes in, it will make a lot of things twice harder. And once 
> > the patch is in productive kernels, there'd be very little possibility to 
> > pull it out.
> > 
> > What is the exact reason for your patch? I suppose that it's some 
> > performance degradation caused by the fact that dm-multipath doesn't 
> > distributes requests optimally across both paths. dm-multipath has 
> > pluggable path selectors, so you could improve dm-round-robin.c (or write 
> > alternate path selector module) and you don't have to touch generic dm 
> > code to solve this problem.
> > 
> > The point is that improving dm-multipath target with better path selector 
> > is much less intrusive than patching device mapper core. If you improve 
> > dm-multipath target, only people hacking on dm-multipath will have to 
> > learn about your code. If you modify generic dm.c file, anyone doing 
> > anything on device mapper must learn about your code --- so human time 
> > consumed in much worse in this case.
> > 
> > So, try the alternate solution (write new path selector for dm-multipath) 
> > and then you can compare them and see the result --- and then it can be 
> > consisdered if the high human time consumed by patching dm.c is worth the 
> > performance improvement.
> 
> Mikulas,
> 
> Section 3.1 of the the following 2007 Linux Symposium paper answers the
> "why?" on request-based dm-multipath:
> http://ols.108.redhat.com/2007/Reprints/ueda-Reprint.pdf
>
> In summary:
> With request-based multipath performance and path error handling is
> improved.  
> 
> Performance:
> The I/O scheduler is leveraged to merge bios into requests; and these
> requests are then able to be more evenly balanced across the available
> paths (no need to starve other paths like the bio-based multipath is
> prone to do).

So you can improve the bio-based selector. You can count number&size of 
outstanding requests on each path and select the less loaded path.

You can remember several end positions of last requests and when new 
request matches one of them, send it to the appropriate path, assuming 
that the lower device's scheduler will marge that. Or --- another solution 
is to access queues of the underlying devices and ask them if there's 
anything to merge --- and then send the request down the path that has 
some adjacent request.

I know that the round-robin selector is silly, but you just haven't even 
try to improve it.

If there is non-intrusive solution (improve path selector), it should be 
tried first, before making an intrusive solution (alternate request path 
in dm core).

> Error handling:
> Finer grained error statistics are available when interfacing more
> directly with the hardware like the request-based multipath does.

You can signal it via flags in bios. No need to rewrite dm core.

> NEC may already have comparative performance data that will help
> illustrate the improvement associated with request-based multipath?
> They apparently have dynamic load balancing patches that they developed
> for use with the current bio-based multipath.

So where is it better and why? Does it save CPU time or disk throughtput? 
How? On which workload?

Did they really try to implement some smart path ballancing that takes 
into account merging?

> It'd be interesting to understand the performance difference between
> that bio-based implementation and the new request-based implementations
> (both service-time and queue-length) of dynamic load balancing.
> 
> Mike

There is downside and benchmarks completely ignore it. It makes 
programming harder.

For example, suppose that you committed rq-based multipath before 
barriers. It would make barrier writing much harder and the result is that 
people will get barriers later and meanwhile won't be able to turn on 
write cache. So rq-based multipath patch improves performance for 
multipath devices (you can measure it) and DEGRADES performance for normal 
disks (no barriers, no hardware cache). And you see how many users use 
ATA+SCSI disks and how many use multipath, you may consider that 
performance of multipath is really not that important.

Besides barriers, I'm also developing new snapshot implementation, if 
programming of barriers were harder, I'd be lagged on development of 
snapshots --- so rq-based multipath would degrade performance of snapshots 
(although it doesn't touch snapshot code at all --- the performance 
degradation comes from comsuming excessive human time that could be used 
for other, better things).

And these are things that benchmarks won't show you. Benchmarks just show 
you improvement, but they can't show you the downside. But if you don't 
consider them, you cause damage to Linux.

Mikulas
