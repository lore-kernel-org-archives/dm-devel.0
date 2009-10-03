From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Do not overload dispatch queue (Was: Re: IO
	scheduler based IO controller V10)
Date: Sat, 3 Oct 2009 09:56:23 -0400
Message-ID: <20091003135623.GD12925@redhat.com>
References: <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	<20091002173732.GK31616@kernel.dk>
	<1254507215.8667.7.camel@marge.simson.net>
	<20091002181903.GN31616@kernel.dk>
	<1254548931.8299.18.camel@marge.simson.net>
	<1254549378.8299.21.camel@marge.simson.net>
	<20091003112915.GA12925@redhat.com>
	<20091003124049.GB12925@redhat.com>
	<20091003132115.GB31616@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091003132115.GB31616@kernel.dk>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Sat, Oct 03, 2009 at 03:21:15PM +0200, Jens Axboe wrote:
> On Sat, Oct 03 2009, Vivek Goyal wrote:
> > On Sat, Oct 03, 2009 at 07:29:15AM -0400, Vivek Goyal wrote:
> > > On Sat, Oct 03, 2009 at 07:56:18AM +0200, Mike Galbraith wrote:
> > > > On Sat, 2009-10-03 at 07:49 +0200, Mike Galbraith wrote:
> > > > > On Fri, 2009-10-02 at 20:19 +0200, Jens Axboe wrote:
> > > > > 
> > > > > > If you could do a cleaned up version of your overload patch based on
> > > > > > this:
> > > > > > 
> > > > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1d2235152dc745c6d94bedb550fea84cffdbf768
> > > > > > 
> > > > > > then lets take it from there.
> > > > 
> > > 
> > > > Note to self: build the darn thing after last minute changes.
> > > > 
> > > > Block:  Delay overloading of CFQ queues to improve read latency.
> > > > 
> > > > Introduce a delay maximum dispatch timestamp, and stamp it when:
> > > >         1. we encounter a known seeky or possibly new sync IO queue.
> > > >         2. the current queue may go idle and we're draining async IO.
> > > >         3. we have sync IO in flight and are servicing an async queue.
> > > >         4  we are not the sole user of disk.
> > > > Disallow exceeding quantum if any of these events have occurred recently.
> > > > 
> > > 
> > > So it looks like primarily the issue seems to be that we done lot of
> > > dispatch from async queue and if some sync queue comes in now, it will
> > > experience latencies.
> > > 
> > > For a ongoing seeky sync queue issue will be solved up to some extent
> > > because previously we did not choose to idle for that queue now we will
> > > idle, hence async queue will not get a chance to overload the dispatch
> > > queue.
> > > 
> > > For the sync queues where we choose not to enable idle, we still will see
> > > the latencies. Instead of time stamping on all the above events, can we 
> > > just keep track of last sync request completed in the system and don't
> > > allow async queue to flood/overload the dispatch queue with-in certain 
> > > time limit of that last sync request completion. This just gives a buffer
> > > period to that sync queue to come back and submit more requests and
> > > still not suffer large latencies?
> > > 
> > > Thanks
> > > Vivek
> > > 
> > 
> > Hi Mike,
> > 
> > Following is a quick hack patch for the above idea. It is just compile and
> > boot tested. Can you please see if it helps in your scenario.
> > 
> > Thanks
> > Vivek
> > 
> > 
> > o Do not allow more than max_dispatch requests from an async queue, if some
> >   sync request has finished recently. This is in the hope that sync activity
> >   is still going on in the system and we might receive a sync request soon.
> >   Most likely from a sync queue which finished a request and we did not enable
> >   idling on it.
> 
> This is pretty much identical to the scheme I described, except for the
> ramping of queue depth. I've applied it, it's nice and simple and I
> believe this will get rid of the worst of the problem.
> 
> Things probably end up being a bit simplistic, but we can always tweak
> around later.

I have kept the overload delay period as "cfq_slice_sync" same as Mike had
done. We shall have to experiment what is a good waiting perioed. Is 100ms
too long if we are waiting for a request from same process which recently
finished IO and we did not enable idle on it.

I guess we can tweak the delay period as we move along.

Thanks
Vivek
