From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Mon, 15 Jun 2015 09:04:02 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506150847460.7275@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<557C6266.3040008@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <557C6266.3040008@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Coly Li <colyli@gmail.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Sun, 14 Jun 2015, Coly Li wrote:

> ? 15/6/10 ??5:21, Mikulas Patocka ??:
> > This patch makes it possible to use precise timestamps with nanosecond
> > granularity in dm statistics.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >
> > ---
> >  Documentation/device-mapper/statistics.txt |   25 ++++-
> >  drivers/md/dm-stats.c                      |  139 +++++++++++++++++++++--------
> >  drivers/md/dm-stats.h                      |    4 
> >  3 files changed, 125 insertions(+), 43 deletions(-)
> >
> > Index: linux-4.1-rc7/drivers/md/dm-stats.c
> > ===================================================================
> > --- linux-4.1-rc7.orig/drivers/md/dm-stats.c	2015-06-08 16:02:27.000000000 +0200
> > +++ linux-4.1-rc7/drivers/md/dm-stats.c	2015-06-08 16:38:43.000000000 +0200
> > @@ -33,13 +33,14 @@ struct dm_stat_percpu {
> >  
> [snip]
> > @@ -560,8 +578,17 @@ void dm_stats_account_io(struct dm_stats
> >  
> >  	rcu_read_lock();
> >  
> > -	list_for_each_entry_rcu(s, &stats->list, list_entry)
> > -		__dm_stat_bio(s, bi_rw, bi_sector, end_sector, end, duration, stats_aux);
> > +	got_precise_time = false;
> > +	list_for_each_entry_rcu(s, &stats->list, list_entry) {
> > +		if (s->stat_flags & STAT_PRECISE_TIMESTAMPS && !got_precise_time) {
> > +			if (!end)
> > +				stats_aux->duration_ns = ktime_to_ns(ktime_get());
> > +			else
> > +				stats_aux->duration_ns = ktime_to_ns(ktime_get()) - stats_aux->duration_ns;
> > +			got_precise_time = true;
> > +		}
> There are many conditions user space processes may query the global
> timer resource frequently. ktime_get() will call spin_lock when
> accessing global timer resource, calling ktime_get() for each list entry
> might introduce locking contention when stats->list is quite large.

The above code doesn't call ktime_get() for each list entry - it calls 
ktime_get() only once, then sets got_precise_time, and doesn't call it 
anymore.

> A satisfied solution might be something like this,
> 
> +    now = ktime_to_ns(ktime_get());
> +    list_for_each_entry_rcu(s, &stats->list, list_entry) {
> +        if (s->stat_flags & STAT_PRECISE_TIMESTAMPS && !got_precise_time) {
> +            if (!end)
> +                stats_aux->duration_ns = now;
> +            else
> +                stats_aux->duration_ns = now - stats_aux->duration_ns;
> +            got_precise_time = true;
> +        }

This is worse that the previous code - this piece of code calls 
ktime_get() even if no list entry requires precise timestamps. The 
previous code called ktime_get() only if there is at least one list entry 
that has STAT_PRECISE_TIMESTAMPS set.

> In this case the global timer could be access only once, locking
> contention should be much less. Yes, it looks to be some inaccurate, but
> for hard disk I/O latency measurement, the difference almost could be
> ignored.
> > +		__dm_stat_bio(s, bi_rw, bi_sector, end_sector, end, duration_jiffies, stats_aux);
> > +	}
> >  
> >  	rcu_read_unlock();
> >  }
> [snip]
> > @@ -772,21 +803,31 @@ static int message_stats_create(struct m
> >  	unsigned long long start, end, len, step;
> >  	unsigned divisor;
> >  	const char *program_id, *aux_data;
> > +	unsigned stat_flags = 0;
> > +
> > +	struct dm_arg_set as, as_backup;
> > +	const char *a;
> > +	unsigned feature_args;
> >  
> >  	/*
> >  	 * Input format:
> > -	 *   <range> <step> [<program_id> [<aux_data>]]
> > +	 *   <range> <step> [<extra_parameters> <parameters>] [<program_id> [<aux_data>]]
> >  	 */
> >  
> > -	if (argc < 3 || argc > 5)
> > +	if (argc < 3)
> >  		return -EINVAL;
> >  
> > -	if (!strcmp(argv[1], "-")) {
> > +	as.argc = argc;
> > +	as.argv = argv;
> > +	dm_consume_args(&as, 1);
> > +
> > +	a = dm_shift_arg(&as);
> > +	if (!strcmp(a, "-")) {
> >  		start = 0;
> >  		len = dm_get_size(md);
> >  		if (!len)
> >  			len = 1;
> > -	} else if (sscanf(argv[1], "%llu+%llu%c", &start, &len, &dummy) != 2 ||
> > +	} else if (sscanf(a, "%llu+%llu%c", &start, &len, &dummy) != 2 ||
> >  		   start != (sector_t)start || len != (sector_t)len)
> >  		return -EINVAL;
> >  
> > @@ -794,7 +835,8 @@ static int message_stats_create(struct m
> >  	if (start >= end)
> >  		return -EINVAL;
> >  
> > -	if (sscanf(argv[2], "/%u%c", &divisor, &dummy) == 1) {
> > +	a = dm_shift_arg(&as);
> > +	if (sscanf(a, "/%u%c", &divisor, &dummy) == 1) {
> >  		if (!divisor)
> >  			return -EINVAL;
> >  		step = end - start;
> > @@ -802,18 +844,39 @@ static int message_stats_create(struct m
> >  			step++;
> >  		if (!step)
> >  			step = 1;
> > -	} else if (sscanf(argv[2], "%llu%c", &step, &dummy) != 1 ||
> > +	} else if (sscanf(a, "%llu%c", &step, &dummy) != 1 ||
> >  		   step != (sector_t)step || !step)
> >  		return -EINVAL;
> >  
> > +	as_backup = as;
> > +	a = dm_shift_arg(&as);
> > +	if (a && sscanf(a, "%u%c", &feature_args, &dummy) == 1) {
> > +		while (feature_args--) {
> > +			a = dm_shift_arg(&as);
> > +			if (!a)
> > +				return -EINVAL;
> > +			if (!strcasecmp(a, "precise_timestamps"))
> > +				stat_flags |= STAT_PRECISE_TIMESTAMPS;
> > +			else
> > +				return -EINVAL;
> > +		}
> > +	} else {
> > +		as = as_backup;
> > +	}
> > +
> >  	program_id = "-";
> >  	aux_data = "-";
> >  
> > -	if (argc > 3)
> > -		program_id = argv[3];
> > +	a = dm_shift_arg(&as);
> > +	if (a)
> > +		program_id = a;
> > +
> > +	a = dm_shift_arg(&as);
> > +	if (a)
> > +		aux_data = a;
> >  
> > -	if (argc > 4)
> > -		aux_data = argv[4];
> > +	if (as.argc)
> > +		return -EINVAL;
> >  
> If I could, I would simplify the design to remove the above changes in
> message_stats_create(). Just my suggestion ...

I don't know what you mean - if you remove the above changes in 
message_stats_create - then obviously - the user will not be able to 
enable precise timestamps or histogram.

Mikulas

> [snip]
> 
> Coly
> 
