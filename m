From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [k-ueda@ct.jp.nec.com: Re: request-based
	dm-multipath]
Date: Wed, 15 Apr 2009 15:09:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904151443170.23593@hs20-bc2-1.build.redhat.com>
References: <20090410151914.GA3800@redhat.com>
	<20090410153102.GC3800@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090410153102.GC3800@redhat.com>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, 10 Apr 2009, Mike Snitzer wrote:

> Hi Mikulaus,
> 
> Figured I'd give you this heads up on the request-based multipath
> patches too considering your recent "bottom-layer barrier support"
> patchset (where you said multipath support is coming later).
> 
> We likely want to coordinate with the NEC guys so as to make sure things
> are in order for the request-based patches to get merged along with your
> remaining barrier work for 2.6.31.
> 
> Mike
> 
> p.s. below you can see I mistakenly said to Kiyoshi that the recent
> barrier patches that got merged upstream were "the last of the DM
> barrier support"...

Hi

I would say one thing about the request-based patches --- don't do this.

Your patch adds an alternate I/O path to request processing on device 
mapper.

So, with your patch, there will be two I/O request paths. It means that 
any work on generic device-mapper code that will have to be done in the 
future (such as for example barriers that I did) will be twice harder. It 
will take twice the time to understand request processing, twice brain 
capacity to remember it, twice the time for coding, twice the time for 
code review, twice the time for testing.

If the patch goes in, it will make a lot of things twice harder. And once 
the patch is in productive kernels, there'd be very little possibility to 
pull it out.

What is the exact reason for your patch? I suppose that it's some 
performance degradation caused by the fact that dm-multipath doesn't 
distributes requests optimally across both paths. dm-multipath has 
pluggable path selectors, so you could improve dm-round-robin.c (or write 
alternate path selector module) and you don't have to touch generic dm 
code to solve this problem.

The point is that improving dm-multipath target with better path selector 
is much less intrusive than patching device mapper core. If you improve 
dm-multipath target, only people hacking on dm-multipath will have to 
learn about your code. If you modify generic dm.c file, anyone doing 
anything on device mapper must learn about your code --- so human time 
consumed in much worse in this case.

So, try the alternate solution (write new path selector for dm-multipath) 
and then you can compare them and see the result --- and then it can be 
consisdered if the high human time consumed by patching dm.c is worth the 
performance improvement.

Mikulas

> On Fri, Apr 10 2009 at 11:19am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > FYI
> > 
> > ----- Forwarded message from Kiyoshi Ueda <k-ueda@ct.jp.nec.com> -----
> > 
> > > From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > > Date: Fri, 10 Apr 2009 15:08:06 +0900
> > > To: Mike Snitzer <snitzer@redhat.com>
> > > CC: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > > Subject: Re: request-based dm-multipath
> > > 
> > > Hi Mike,
> > > 
> > > > 
> > > > Hi Kiyoshi,
> > > > 
> > > > I just wanted to follow-up with you to understand if you'll be posting
> > > > the request-based patches rebased against 2.6.30-rcX.  Please note that
> > > > Alasdair just requested Linus pull the last of the DM barrier support
> > > > into what will be 2.6.30-rc2.
> > > 
> > > Yes.
> > > Current request-based patch does't have barrier support.
> > > So I think I have to implement barrier support to post the next update.
> > > 
> > > > I'd imagine you'd like the merging of the request-based and dynamic load
> > > > balancer patches to be a priority for 2.6.31?
> > > 
> > > Yes.  That's right.
> > > 
> > > Thanks,
> > > Kiyoshi Ueda
> > 
> > ----- End forwarded message -----
> 
