From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
	controller V10)
Date: Sat, 3 Oct 2009 15:21:15 +0200
Message-ID: <20091003132115.GB31616@kernel.dk>
References: <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk> <1254507215.8667.7.camel@marge.simson.net> <20091002181903.GN31616@kernel.dk> <1254548931.8299.18.camel@marge.simson.net> <1254549378.8299.21.camel@marge.simson.net> <20091003112915.GA12925@redhat.com> <20091003124049.GB12925@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756271AbZJCNVN@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091003124049.GB12925@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Sat, Oct 03 2009, Vivek Goyal wrote:
> On Sat, Oct 03, 2009 at 07:29:15AM -0400, Vivek Goyal wrote:
> > On Sat, Oct 03, 2009 at 07:56:18AM +0200, Mike Galbraith wrote:
> > > On Sat, 2009-10-03 at 07:49 +0200, Mike Galbraith wrote:
> > > > On Fri, 2009-10-02 at 20:19 +0200, Jens Axboe wrote:
> > > > 
> > > > > If you could do a cleaned up version of your overload patch based on
> > > > > this:
> > > > > 
> > > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1d2235152dc745c6d94bedb550fea84cffdbf768
> > > > > 
> > > > > then lets take it from there.
> > > 
> > 
> > > Note to self: build the darn thing after last minute changes.
> > > 
> > > Block:  Delay overloading of CFQ queues to improve read latency.
> > > 
> > > Introduce a delay maximum dispatch timestamp, and stamp it when:
> > >         1. we encounter a known seeky or possibly new sync IO queue.
> > >         2. the current queue may go idle and we're draining async IO.
> > >         3. we have sync IO in flight and are servicing an async queue.
> > >         4  we are not the sole user of disk.
> > > Disallow exceeding quantum if any of these events have occurred recently.
> > > 
> > 
> > So it looks like primarily the issue seems to be that we done lot of
> > dispatch from async queue and if some sync queue comes in now, it will
> > experience latencies.
> > 
> > For a ongoing seeky sync queue issue will be solved up to some extent
> > because previously we did not choose to idle for that queue now we will
> > idle, hence async queue will not get a chance to overload the dispatch
> > queue.
> > 
> > For the sync queues where we choose not to enable idle, we still will see
> > the latencies. Instead of time stamping on all the above events, can we 
> > just keep track of last sync request completed in the system and don't
> > allow async queue to flood/overload the dispatch queue with-in certain 
> > time limit of that last sync request completion. This just gives a buffer
> > period to that sync queue to come back and submit more requests and
> > still not suffer large latencies?
> > 
> > Thanks
> > Vivek
> > 
> 
> Hi Mike,
> 
> Following is a quick hack patch for the above idea. It is just compile and
> boot tested. Can you please see if it helps in your scenario.
> 
> Thanks
> Vivek
> 
> 
> o Do not allow more than max_dispatch requests from an async queue, if some
>   sync request has finished recently. This is in the hope that sync activity
>   is still going on in the system and we might receive a sync request soon.
>   Most likely from a sync queue which finished a request and we did not enable
>   idling on it.

This is pretty much identical to the scheme I described, except for the
ramping of queue depth. I've applied it, it's nice and simple and I
believe this will get rid of the worst of the problem.

Things probably end up being a bit simplistic, but we can always tweak
around later.

-- 
Jens Axboe
