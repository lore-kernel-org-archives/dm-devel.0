From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Wed, 10 Jun 2015 13:40:52 -0400
Message-ID: <20150610174051.GA32083@redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<20150610171036.GB31918@redhat.com>
	<alpine.LRH.2.02.1506101330400.10164@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1506101330400.10164@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, dm-devel@redhat.com, Coly Li <colyli@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 10 2015 at  1:33pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 10 Jun 2015, Mike Snitzer wrote:
> 
> > On Tue, Jun 09 2015 at  5:21pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > This patch makes it possible to use precise timestamps with nanosecond
> > > granularity in dm statistics.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > 
> > > ---
> > >  Documentation/device-mapper/statistics.txt |   25 ++++-
> > >  drivers/md/dm-stats.c                      |  139 +++++++++++++++++++++--------
> > >  drivers/md/dm-stats.h                      |    4 
> > >  3 files changed, 125 insertions(+), 43 deletions(-)
> > > 
> > > Index: linux-4.1-rc7/drivers/md/dm-stats.c
> > > ===================================================================
> > > --- linux-4.1-rc7.orig/drivers/md/dm-stats.c	2015-06-08 16:02:27.000000000 +0200
> > > +++ linux-4.1-rc7/drivers/md/dm-stats.c	2015-06-08 16:38:43.000000000 +0200
> > > @@ -33,13 +33,14 @@ struct dm_stat_percpu {
> > >  
> > >  struct dm_stat_shared {
> > >  	atomic_t in_flight[2];
> > > -	unsigned long stamp;
> > > +	unsigned long long stamp;
> > >  	struct dm_stat_percpu tmp;
> > >  };
> > >  
> > >  struct dm_stat {
> > >  	struct list_head list_entry;
> > >  	int id;
> > > +	unsigned stat_flags;
> > >  	size_t n_entries;
> > >  	sector_t start;
> > >  	sector_t end;
> > > @@ -53,6 +54,8 @@ struct dm_stat {
> > >  	struct dm_stat_shared stat_shared[0];
> > >  };
> > >  
> > > +#define STAT_PRECISE_TIMESTAMPS		1
> > > +
> > >  struct dm_stats_last_position {
> > >  	sector_t last_sector;
> > >  	unsigned last_rw;
> > > @@ -227,7 +230,8 @@ void dm_stats_cleanup(struct dm_stats *s
> > >  }
> > >  
> > >  static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
> > > -			   sector_t step, const char *program_id, const char *aux_data,
> > > +			   sector_t step, unsigned stat_flags,
> > > +			   const char *program_id, const char *aux_data,
> > >  			   void (*suspend_callback)(struct mapped_device *),
> > >  			   void (*resume_callback)(struct mapped_device *),
> > >  			   struct mapped_device *md)
> > > @@ -268,6 +272,7 @@ static int dm_stats_create(struct dm_sta
> > >  	if (!s)
> > >  		return -ENOMEM;
> > >  
> > > +	s->stat_flags = stat_flags;
> > >  	s->n_entries = n_entries;
> > >  	s->start = start;
> > >  	s->end = end;
> > > @@ -417,15 +422,22 @@ static int dm_stats_list(struct dm_stats
> > >  	return 1;
> > >  }
> > >  
> > > -static void dm_stat_round(struct dm_stat_shared *shared, struct dm_stat_percpu *p)
> > > +static void dm_stat_round(struct dm_stat *s, struct dm_stat_shared *shared,
> > > +			  struct dm_stat_percpu *p)
> > >  {
> > >  	/*
> > >  	 * This is racy, but so is part_round_stats_single.
> > >  	 */
> > > -	unsigned long now = jiffies;
> > > -	unsigned in_flight_read;
> > > -	unsigned in_flight_write;
> > > -	unsigned long difference = now - shared->stamp;
> > > +	unsigned long long now, difference;
> > > +	unsigned in_flight_read, in_flight_write;
> > > +
> > > +	if (likely(!(s->stat_flags & STAT_PRECISE_TIMESTAMPS))) {
> > > +		now = jiffies;
> > > +	} else {
> > > +		now = ktime_to_ns(ktime_get());
> > > +	}
> > > +
> > > +	difference = now - shared->stamp;
> > >  
> > >  	if (!difference)
> > >  		return;
> > 
> > Here 'difference' is in nanosecond resolution if STAT_PRECISE_TIMESTAMPS
> 
> Yes.
> 
> > > @@ -646,11 +673,15 @@ static int dm_stats_clear(struct dm_stat
> > >  /*
> > >   * This is like jiffies_to_msec, but works for 64-bit values.
> > >   */
> > > -static unsigned long long dm_jiffies_to_msec64(unsigned long long j)
> > > +static unsigned long long dm_jiffies_to_msec64(struct dm_stat *s, unsigned long long j)
> > >  {
> > > -	unsigned long long result = 0;
> > > +	unsigned long long result;
> > >  	unsigned mult;
> > >  
> > > +	if (s->stat_flags & STAT_PRECISE_TIMESTAMPS)
> > > +		return j;
> > > +
> > > +	result = 0;
> > >  	if (j)
> > >  		result = jiffies_to_msecs(j & 0x3fffff);
> > >  	if (j >= 1 << 22) {
> > 
> > Yet here you aren't converting ns to ms...
> 
> That function is converting jiffies to ms. When STAT_PRECISE_TIMESTAMPS is 
> not set, the internal times are kept in jiffies and they are converted to 
> ms when being printed. When STAT_PRECISE_TIMESTAMPS is set, the internal 
> times are kept in ns and no conversion is done when they are printed.
> 
> > > @@ -712,16 +743,16 @@ static int dm_stats_print(struct dm_stat
> > >  		       shared->tmp.ios[READ],
> > >  		       shared->tmp.merges[READ],
> > >  		       shared->tmp.sectors[READ],
> > > -		       dm_jiffies_to_msec64(shared->tmp.ticks[READ]),
> > > +		       dm_jiffies_to_msec64(s, shared->tmp.ticks[READ]),
> > >  		       shared->tmp.ios[WRITE],
> > >  		       shared->tmp.merges[WRITE],
> > >  		       shared->tmp.sectors[WRITE],
> > > -		       dm_jiffies_to_msec64(shared->tmp.ticks[WRITE]),
> > > +		       dm_jiffies_to_msec64(s, shared->tmp.ticks[WRITE]),
> > >  		       dm_stat_in_flight(shared),
> > > -		       dm_jiffies_to_msec64(shared->tmp.io_ticks_total),
> > > -		       dm_jiffies_to_msec64(shared->tmp.time_in_queue),
> > > -		       dm_jiffies_to_msec64(shared->tmp.io_ticks[READ]),
> > > -		       dm_jiffies_to_msec64(shared->tmp.io_ticks[WRITE]));
> > > +		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks_total),
> > > +		       dm_jiffies_to_msec64(s, shared->tmp.time_in_queue),
> > > +		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[READ]),
> > > +		       dm_jiffies_to_msec64(s, shared->tmp.io_ticks[WRITE]));
> > >  
> > >  		if (unlikely(sz + 1 >= maxlen))
> > >  			goto buffer_overflow;
> > 
> > So the printed stats won't actually be in msec.
> > 
> > Or am I missing something?
> 
> If STAT_PRECISE_TIMESTAMPS is not set, the printed values are in ms, if it 
> is set, they are in ns.

OK, makes sense.  Otherwise we'd be losing the precision (which defeats
the purpose of this exercise).  Thanks.
