From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 10:04:18 +0200
Message-ID: <20091002080417.GG14918@kernel.dk>
References: <20090925202636.GC15007@redhat.com>
	<1253976676.7005.40.camel@marge.simson.net>
	<1254034500.7933.6.camel@marge.simson.net>
	<20090927164235.GA23126@kernel.dk>
	<1254340730.7695.32.camel@marge.simson.net>
	<1254341139.7695.36.camel@marge.simson.net>
	<20090930202447.GA28236@redhat.com>
	<1254382405.7595.9.camel@marge.simson.net>
	<20091001185816.GU14918@kernel.dk>
	<1254464628.7158.101.camel@marge.simson.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1254464628.7158.101.camel@marge.simson.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Galbraith <efault@gmx.de>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Oct 02 2009, Mike Galbraith wrote:
> On Thu, 2009-10-01 at 20:58 +0200, Jens Axboe wrote:
> > On Thu, Oct 01 2009, Mike Galbraith wrote:
> > > > CIC_SEEK_THR is 8K jiffies so that would be 8seconds on 1000HZ system. Try
> > > > using one "slice_idle" period of 8 ms. But it might turn out to be too
> > > > short depending on the disk speed.
> > > 
> > > Yeah, it is too short, as is even _400_ ms.  Trouble is, by the time
> > > some new task is determined to be seeky, the damage is already done.
> > > 
> > > The below does better, though not as well as "just say no to overload"
> > > of course ;-)
> > 
> > So this essentially takes the "avoid impact from previous slice" to a
> > new extreme, but idling even before dispatching requests from the new
> > queue. We basically do two things to prevent this already - one is to
> > only set the slice when the first request is actually serviced, and the
> > other is to drain async requests completely before starting sync ones.
> > I'm a bit surprised that the former doesn't solve the problem fully, I
> > guess what happens is that if the drive has been flooded with writes, it
> > may service the new read immediately and then return to finish emptying
> > its writeback cache. This will cause an impact for any sync IO until
> > that cache is flushed, and then cause that sync queue to not get as much
> > service as it should have.
> 
> I did the stamping selection other than how long have we been solo based
> on these possibly wrong speculations:
> 
> If we're in the idle window and doing the async drain thing, we've at
> the spot where Vivek's patch helps a ton.  Seemed like a great time to
> limit the size of any io that may land in front of my sync reader to
> plain "you are not alone" quantity.

You can't be in the idle window and doing async drain at the same time,
the idle window doesn't start until the sync queue has completed a
request. Hence my above rant on device interference.

> If we've got sync io in flight, that should mean that my new or old
> known seeky queue has been serviced at least once.  There's likely to be
> more on the way, so delay overloading then too. 
> 
> The seeky bit is supposed to be the earlier "last time we saw a seeker"
> thing, but known seeky is too late to help a new task at all unless you
> turn off the overloading for ages, so I added the if incalculable check
> for good measure, hoping that meant the task is new, may want to exec.
> 
> Stamping any place may (see below) possibly limit the size of the io the
> reader can generate as well as writer, but I figured what's good for the
> goose is good for the the gander, or it ain't really good.  The overload
> was causing the observed pain, definitely ain't good for both at these
> times at least, so don't let it do that.
> 
> > Perhaps the "set slice on first complete" isn't working correctly? Or
> > perhaps we just need to be more extreme.
> 
> Dunno, I was just tossing rocks and sticks at it.
> 
> I don't really understand the reasoning behind overloading:  I can see
> that allows cutting thicker slabs for the disk, but with the streaming
> writer vs reader case, seems only the writers can do that.  The reader
> is unlikely to be alone isn't it?  Seems to me that either dd, a flusher
> thread or kjournald is going to be there with it, which gives dd a huge
> advantage.. it has two proxies to help it squabble over disk, konsole
> has none.

That is true, async queues have a huge advantage over sync ones. But
sync vs async is only part of it, any combination of queued sync, queued
sync random etc have different ramifications on behaviour of the
individual queue.

It's not hard to make the latency good, the hard bit is making sure we
also perform well for all other scenarios.

-- 
Jens Axboe
