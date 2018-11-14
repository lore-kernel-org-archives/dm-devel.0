From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 5/5] block: use a driver-specific handler for
 the "inflight" value
Date: Wed, 14 Nov 2018 17:49:07 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1811141740440.7875@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181106213858.391264280@debian-a64.vm>
	<20181108145240.GA20087@infradead.org>
	<20181108170701.GA29107@redhat.com>
	<20181114151848.GA22138@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181114151848.GA22138@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Wed, 14 Nov 2018, Christoph Hellwig wrote:

> On Thu, Nov 08, 2018 at 12:07:01PM -0500, Mike Snitzer wrote:
> > Discussed doing that with Jens and reported as much here:
> > 
> > https://www.redhat.com/archives/dm-devel/2018-November/msg00068.html
> > 
> > And Jens gave additional context for why yet another attempt to switch
> > block core's in_flight to percpu counters is doomed (having already been
> > proposed and rejected twice):
> > 
> > https://www.redhat.com/archives/dm-devel/2018-November/msg00071.html
> > 
> > And yes, definitely should've cc'd linux-block (now added).
> 
> So how is dm different from the the other 3 handful of drivers using
> the make_request interface that the per-cpu counters work for dm and
> not the others?

We want to make dm-linear (and dm-stripe) completely lockless, because it 
is used often and we don't want it to degrade performance.

DM already uses srcu to handle table changes, so that the fast path 
doesn't take any locks. And the only one "lock" that is remaining is the 
"in_flight" variable.

As for other drivers, md-raid0 could probably be lockless too (using 
percpu counting similar to dm). The other raid levels can't be lockless 
because they need to check the status of the stripe that is being 
accessed.

Mikulas
