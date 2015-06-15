From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/4] dm stats: report histogram of latencies
Date: Mon, 15 Jun 2015 09:06:33 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506150904280.7275@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721430.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<557C6272.8070200@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <557C6272.8070200@gmail.com>
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

These micro optimizations would save one or two instructions, so they are 
not really needed. Also, these micro optimizations are at a code path that 
prints the statistics, not the code path that processes i/o requests.

Mikulas


On Sun, 14 Jun 2015, Coly Li wrote:

> ? 15/6/10 ??5:22, Mikulas Patocka ??:
> > This patch adds an option to dm statistics to collect and report the
> > histogram of latencies.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >
> > ---
> >  Documentation/device-mapper/statistics.txt |   21 ++-
> >  drivers/md/dm-stats.c                      |  201 +++++++++++++++++++++++++----
> >  2 files changed, 196 insertions(+), 26 deletions(-)
> >
> > Index: linux-4.1-rc7/drivers/md/dm-stats.c
> > ===================================================================
> > --- linux-4.1-rc7.orig/drivers/md/dm-stats.c	2015-06-08 16:38:43.000000000 +0200
> > +++ linux-4.1-rc7/drivers/md/dm-stats.c	2015-06-08 17:02:01.000000000 +0200
> > @@ -29,6 +29,7 @@ struct dm_stat_percpu {
> >  	unsigned long long io_ticks[2];
> >  	unsigned long long io_ticks_total;
> >  	unsigned long long time_in_queue;
> > +	unsigned long long *histogram;
> >  };
> >  
> >  struct dm_stat_shared {
> [snip]
> > @@ -619,6 +700,11 @@ static void __dm_stat_init_temporary_per
> >  		shared->tmp.io_ticks[WRITE] += ACCESS_ONCE(p->io_ticks[WRITE]);
> >  		shared->tmp.io_ticks_total += ACCESS_ONCE(p->io_ticks_total);
> >  		shared->tmp.time_in_queue += ACCESS_ONCE(p->time_in_queue);
> > +		if (s->n_histogram_entries) {
> > +			unsigned i;
> > +			for (i = 0; i < s->n_histogram_entries + 1; i++)
> > +				shared->tmp.histogram[i] += ACCESS_ONCE(p->histogram[i]);
> 
> s->n_histogram_entries + 1 in for() looping will be calculated many times, maybe this way could be better,
> 
> +		if (s->n_histogram_entries) {
> +			unsigned i, j;
> +			j = s->n_histogram_entries + 1;
> +			for (i = 0; i < j; i++)
> +				shared->tmp.histogram[i] += ACCESS_ONCE(p->histogram[i]);
> 
> > +		}
> >  	}
> >  }
> >  
> > @@ -648,6 +734,15 @@ static void __dm_stat_clear(struct dm_st
> >  		p->io_ticks_total -= shared->tmp.io_ticks_total;
> >  		p->time_in_queue -= shared->tmp.time_in_queue;
> >  		local_irq_enable();
> > +		if (s->n_histogram_entries) {
> > +			unsigned i;
> > +			for (i = 0; i < s->n_histogram_entries + 1; i++) {
> Same situation here,
> 
> +            unsigned i, j;
> +            j = s->n_histogram_entries + 1;
> +            for (i = 0; i < j; i++) {
> 
> > +				local_irq_disable();
> > +				p = &s->stat_percpu[smp_processor_id()][x];
> > +				p->histogram[i] -= shared->tmp.histogram[i];
> > +				local_irq_enable();
> > +			}
> > +		}
> >  	}
> >  }
> >  
> > @@ -737,7 +832,7 @@ static int dm_stats_print(struct dm_stat
> >  
> >  		__dm_stat_init_temporary_percpu_totals(shared, s, x);
> >  
> > -		DMEMIT("%llu+%llu %llu %llu %llu %llu %llu %llu %llu %llu %d %llu %llu %llu %llu\n",
> > +		DMEMIT("%llu+%llu %llu %llu %llu %llu %llu %llu %llu %llu %d %llu %llu %llu %llu",
> >  		       (unsigned long long)start,
> >  		       (unsigned long long)step,
> >  		       shared->tmp.ios[READ],
> > @@ -753,6 +848,13 @@ static int dm_stats_print(struct dm_stat
> >  		       dm_jiffies_to_msec64(s, shared->tmp.time_in_queue),
> >  		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[READ]),
> >  		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[WRITE]));
> > +		if (s->n_histogram_entries) {
> > +			unsigned i;
> > +			for (i = 0; i < s->n_histogram_entries + 1; i++) {
> Same situation here,
> 
> +                        unsigned i, j;
> +                        j = s->n_histogram_entries + 1;
> +                        for (i = 0; i < j; i++) {
> 
> > +				DMEMIT("%s%llu", !i ? " " : ":", shared->tmp.histogram[i]);
> > +			}
> > +		}
> > +		DMEMIT("\n");
> >  
> >  		if (unlikely(sz + 1 >= maxlen))
> >  			goto buffer_overflow;
> [snip]
> 
> Coly
> 
