From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 0/5] device mapper percpu patches
Date: Wed, 7 Nov 2018 17:47:09 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1811071741470.20405@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181106213458.308968760@debian-a64.vm>
	<20181107222904.GB24491@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181107222904.GB24491@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 7 Nov 2018, Mike Snitzer wrote:

> On Tue, Nov 06 2018 at  4:34pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > These are the device mapper percpu patches.
> > 
> > Note that I didn't test request-based device mapper because I don't have
> > hardware for it (the patches don't convert request-base targets to percpu
> > values, but there are a few inevitable changes in dm-rq.c).
> 
> Patches 1 - 3 make sense.  But the use of percpu inflight counters isn't
> something I can get upstream.  Any more scalable counter still needs to
> be wired up to the block stats interfaces (the one you did in patch 5 is
> only for the "inflight" fsffs file, there is also the generic diskstats
> callout to part_in_flight(), etc).  Wiring up both part_in_flight() and
> part_in_flight_rw() to optionally callout to a new callback isn't going
> to fly.. especially if that callout is looping up the sum of percpu
> counters.
> 
> I checked with Jens and now that in 4.21 all of the old request-based IO
> path is gone (and given that blk-mq bypasses use of ->in_flight[]): the
> only consumer of the existing ->in_flight[] is the bio-based IO path.
> 
> Given that now only bio-based is consuming it, and your work was focused
> on making bio-based DM's "pending" IO accounting more scalable, it is
> best to just change block core's ->in_flight[] directly.
> 
> But Jens is against switching to using percpu counters because they are
> really slow when summing the counts.  And diskstats does that
> frequently.  Jens said at least 2 other attempts were made and rejected
> to switch over to percpu counters.

I'd like to know - which kernel part needs to sum the percpu IO counters 
frequently?

My impression was that the counters need to be summed only when the user 
is reading the files in sysfs and that is not frequent at all.

I forgot about "/proc/diskstats" - but - is reading them really frequent? 
Do we want to sacrifice IOPS throughput for the sake of improving the time 
of reading "/proc/diskstats"?

Mikulas

> Jens' suggestion is to implement a new generic rolling per-node
> counter.  Would you be open to trying that?
> 
> Mike
> 
