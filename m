From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 4/6] block: switch to per-cpu in-flight
	counters
Date: Wed, 5 Dec 2018 12:49:42 -0500
Message-ID: <20181205174942.GA9838@redhat.com>
References: <20181130222226.77216-1-snitzer@redhat.com>
	<20181130222226.77216-5-snitzer@redhat.com>
	<d6a741cd-ea75-19d0-13e3-eb1321e617b4@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d6a741cd-ea75-19d0-13e3-eb1321e617b4@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 05 2018 at 12:30pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/30/18 3:22 PM, Mike Snitzer wrote:
> > diff --git a/block/genhd.c b/block/genhd.c
> > index cdf174d7d329..d4c9dd65def6 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -45,53 +45,76 @@ static void disk_add_events(struct gendisk *disk);
> >  static void disk_del_events(struct gendisk *disk);
> >  static void disk_release_events(struct gendisk *disk);
> >  
> > -void part_inc_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
> > +void part_inc_in_flight(struct request_queue *q, int cpu, struct hd_struct *part, int rw)
> >  {
> >  	if (queue_is_mq(q))
> >  		return;
> >  
> > -	atomic_inc(&part->in_flight[rw]);
> > +	local_inc(&per_cpu_ptr(part->dkstats, cpu)->in_flight[rw]);
> 
> I mentioned this in a previous email, but why isn't this just using
> this_cpu_inc?

I responded to your earlier question on this point but, Mikulas just
extended the existing percpu struct disk_stats and he is using local_t
for reasons detailed in this patch's header:

    We use the local-atomic type local_t, so that if part_inc_in_flight or
    part_dec_in_flight is reentrantly called from an interrupt, the value will
    be correct.

    The other counters could be corrupted due to reentrant interrupt, but the
    corruption only results in slight counter skew - the in_flight counter
    must be exact, so it needs local_t.

> There's also no need to pass in the cpu, if we're not running with
> preempt disabled already we have a problem. 

Why should this be any different than the part_stat_* interfaces?
__part_stat_add(), part_stat_read(), etc also use
per_cpu_ptr((part)->dkstats, (cpu) accessors.
