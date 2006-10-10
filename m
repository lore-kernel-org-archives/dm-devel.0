From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: New read-balancing patch for dm-raid1.c
Date: Tue, 10 Oct 2006 21:02:44 +0200
Message-ID: <20061010190244.GA4792@redhat.com>
References: <1160410439.30654.12.camel@hydrogen.msp.redhat.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1160410439.30654.12.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: heinzm@redhat.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


Jon,

the "if (ms->read_count_reset)" should read "if (!ms->read_count_reset)"
to disable read balancing and the 2 while loops could be merged into one.

Heinz

On Mon, Oct 09, 2006 at 11:13:59AM -0500, Jonathan Brassow wrote:
> Looking for some opinions/comments on this read balancing patch.  (Basic
> implementation details in patch header.)
> 
> I haven't gone to too much trouble to make the read balancing code
> generic, since there is only one policy right now.  In the future, I
> will likely have to swap out the three fields in the mirror set
> structure for a void pointer that will contain data for various other
> read balancing policies.  I have, however, constructed the new table
> line arguments in such a way that the read-balancing arguments are easy
> to identify and pass to an initialization function without knowing too
> much about the actual arguments.
> 
> One thing I'm not all that fond of is the order that the mirror is set
> up.  The read-balancing arguments are parsed before 'alloc_context' is
> called - meaning that new read-balancing structures would be allocated
> first, then linked in later... and read-balancing is set up before the
> default mirror device is chosen.  I don't really care for
> 'alloc_context' setting up 'ms->read_mirror', while other fields are
> initialized after 'alloc_context'.  I don't think this is too much of a
> problem though.
> 
>  brassow
> 
> This patch adds read balancing.  The round-robin method is the first
> to be implemented, but provisions are made for others to be implemented
> in the future.
> 
> The allowable mirror table arguments has been expanded.  It is now
> as follows:
> 
>        <start> <length> mirror \
>        <log-type> <# log params> <log params> \
> *new*  [readbalance <# rb params> <rb params>] \
>        <# mirrors> <device1> <offset1> ... <deviceN> <offsetN>
> 
> The new read balancing arguments are optional, and the only
> currently valid read balancing arguments are:
>        readbalance 2 roundrobin <count>
> Where 'count' is the number of I/Os that go to a device before
> switching to the next device.
> 
> 'struct mirror *choose_mirror(struct mirror_set *ms)' is the
> function that chooses the read mirror based on read balancing
> policy.  It should only be called when the region of the
> mirror being read from is known to be in-sync.  'choose_mirror'
> will avoid selecting devices with error_counts > 0 - returning
> NULL if no devices are available.
> 
> Index: linux-2.6.18/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-2.6.18.orig/drivers/md/dm-raid1.c	2006-10-05 13:38:27.000000000 -0500
> +++ linux-2.6.18/drivers/md/dm-raid1.c	2006-10-09 10:31:47.000000000 -0500
> @@ -135,6 +135,9 @@ struct mirror_set {
>  	struct mirror *default_mirror;	/* Default mirror */
>  
>  	unsigned int nr_mirrors;
> +	unsigned int read_count_reset; /* number of reads before switching */
> +	atomic_t read_count;      /* Read counter for read balancing */
> +	struct mirror *read_mirror; /* Last mirror read. */
>  	struct mirror mirror[0];
>  };
>  
> @@ -686,10 +689,59 @@ static void do_recovery(struct mirror_se
>  /*-----------------------------------------------------------------
>   * Reads
>   *---------------------------------------------------------------*/
> -static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
> +
> +/* choose_mirror
> + * @ms: the mirror set
> + *
> + * This function is used for read balancing.
> + *
> + * Returns: chosen mirror, or NULL on failure
> + */
> +static struct mirror *choose_mirror(struct mirror_set *ms)
>  {
> -	/* FIXME: add read balancing */
> -	return ms->default_mirror;
> +	unsigned int i;
> +	struct mirror *start_mirror = ms->read_mirror;
> +
> +	/*
> +	 * If 'read_count_reset' is zero here, then read-balancing
> +	 * is disabled.
> +	 */
> +	if (ms->read_count_reset)) {
> +		do {
> +			if (likely(!atomic_read(&ms->read_mirror->error_count)))
> +				goto use_mirror;
> +
> +			if (ms->read_mirror-- == ms->mirror)
> +				ms->read_mirror += ms->nr_mirrors;
> +		} while (ms->read_mirror != start_mirror);
> +		return NULL;
> +	}
> +
> +	/*
> +	 * Perform ms->read_count_reset reads on each working mirror then
> +	 * advance to the next one.  start_mirror stores
> +	 * the first we tried, so we know when we're done.
> +	 */
> +	do {
> +		if (likely(!atomic_read(&ms->read_mirror->error_count)) &&
> +		    !atomic_dec_and_test(&ms->read_count))
> +			goto use_mirror;
> +
> +		atomic_set(&ms->read_count, ms->read_count_reset);
> +
> +		if (ms->read_mirror-- == ms->mirror)
> +			ms->read_mirror += ms->nr_mirrors;
> +	} while (ms->read_mirror != start_mirror);
> +
> +	/*
> +	 * We've rejected every mirror.
> +	 * Confirm the start_mirror can be used.
> +	 */
> +	if (unlikely(atomic_read(&ms->read_mirror->error_count)))
> +		return NULL;
> +
> +use_mirror:
> +	return ms->read_mirror;
>  }
>  
>  /*
> @@ -714,7 +766,7 @@ static void do_reads(struct mirror_set *
>  		 * We can only read balance if the region is in sync.
>  		 */
>  		if (rh_in_sync(&ms->rh, region, 0))
> -			m = choose_mirror(ms, bio->bi_sector);
> +			m = choose_mirror(ms);
>  		else
>  			m = ms->default_mirror;
>  
> @@ -907,6 +959,7 @@ static struct mirror_set *alloc_context(
>  	ms->nr_mirrors = nr_mirrors;
>  	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
>  	ms->in_sync = 0;
> +	ms->read_mirror = &ms->mirror[DEFAULT_MIRROR];
>  	ms->default_mirror = &ms->mirror[DEFAULT_MIRROR];
>  
>  	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
> @@ -1028,6 +1081,7 @@ static struct dirty_log *create_dirty_lo
>  static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  {
>  	int r;
> +	unsigned int read_count_reset = 0, read_balance_args;
>  	unsigned int nr_mirrors, m, args_used;
>  	struct mirror_set *ms;
>  	struct dirty_log *dl;
> @@ -1039,6 +1093,29 @@ static int mirror_ctr(struct dm_target *
>  	argv += args_used;
>  	argc -= args_used;
>  
> +	if (!argc) {
> +		ti->error = "Invalid number of arguments";
> +		dm_destroy_dirty_log(dl);
> +		return -EINVAL;
> +	} else if (!strcmp("readbalance", argv[0]) &&
> +		   (sscanf(argv[1], "%u", &read_balance_args) == 1)) {
> +		/*
> +		 * When there is more than one read-balancing policy,
> +		 * we will push this next if statement into an
> +		 * initialization function.
> +		 */
> +		if ((read_balance_args == 2) &&
> +		    !strcmp("roundrobin", argv[2]) &&
> +		    (sscanf(argv[3], "%u", &read_count_reset) == 1)) {
> +			argv += 4;
> +			argc -= 4;
> +		} else {
> +			ti->error = "Invalid read-balancing arguments";
> +			dm_destroy_dirty_log(dl);
> +			return -EINVAL;
> +		}
> +	}
> +
>  	if (!argc || sscanf(argv[0], "%u", &nr_mirrors) != 1 ||
>  	    nr_mirrors < 2 || nr_mirrors > KCOPYD_MAX_REGIONS + 1) {
>  		ti->error = "Invalid number of mirrors";
> @@ -1060,6 +1137,8 @@ static int mirror_ctr(struct dm_target *
>  		return -ENOMEM;
>  	}
>  
> +	ms->read_count_reset = read_count_reset;
> +
>  	/* Get the mirror parameter sets */
>  	for (m = 0; m < nr_mirrors; m++) {
>  		r = get_mirror(ms, ti, m, argv);
> @@ -1147,7 +1226,7 @@ static int mirror_map(struct dm_target *
>  		return 0;
>  	}
>  
> -	m = choose_mirror(ms, bio->bi_sector);
> +	m = choose_mirror(ms);
>  	if (!m)
>  		return -EIO;

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
