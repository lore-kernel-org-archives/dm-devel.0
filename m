From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 8/8] [dm-cache] cache target
Date: Tue, 12 Feb 2013 17:29:09 +0000
Message-ID: <20130212172909.GJ3228@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-9-git-send-email-ejt@redhat.com>
	<20130212152733.GH12499@agk-dp.fab.redhat.com>
	<20130212164040.GI3228@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130212164040.GI3228@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 12, 2013 at 03:27:33PM +0000, Alasdair G Kergon wrote:
> updated code taken from the all-caches branch of 
> git://github.com/jthornber/linux-2.6
  
File: dm-cache-target.c

> #include <asm/div64.h>
Is this needed anywhere?  We should be using sector_div for sector_t.

> #include <linux/blkdev.h>
Already in dm.h

> #include <linux/list.h>
Already in dm.h

> struct cache_features {
> 	enum cache_mode mode;
> 	bool write_through:1;
> };

We should probably support 'ignore_discard' like thin, so it's possible
to skip internal target discard processing if the user thinks it gives 
them no net benefit.
 
> struct cache {

Rather large - some parts could be moved out into sub structures (stats),
but never mind for now.

> static struct dm_bio_prison_cell *prealloc_get_cell(struct prealloc *p)
> {
> 	struct dm_bio_prison_cell *r = NULL;
> 
> 	if (p->cell1) {
> 		r = p->cell1;
> 		p->cell1 = NULL;
> 
> 	} else if (p->cell2) {
> 		r = p->cell2;
> 		p->cell2 = NULL;
> 	} else
> 		BUG();

Brief comment explaining the assumption here (or at top of fn) to help people
if this BUG() is hit?

> static void prealloc_put_cell(struct prealloc *p, struct dm_bio_prison_cell *cell)
> {
> 	if (!p->cell2)
> 		p->cell2 = cell;
> 
> 	else if (!p->cell1)
> 		p->cell1 = cell;
> 
> 	else
> 		BUG();
> }

Same.

> static dm_dblock_t oblock_to_dblock(struct cache *cache, dm_oblock_t oblock)
> {
> 	sector_t tmp = cache->discard_block_size;
> 	dm_block_t b = from_oblock(oblock);
> 
> 	do_div(tmp, cache->sectors_per_block);

sector_div?  (and elsewhere)

> 	do_div(b, tmp);
> 	return to_dblock(b);
> }


> static void load_stats(struct cache *cache)
> {
> 	struct dm_cache_statistics stats;
> 
> 	dm_cache_get_stats(cache->cmd, &stats);

Make it clearer from the fn name where the stats are "got" from?
e.g. dm_cache_metadata_* or _get_stats_from_*


> static void migration_success_post_commit(struct dm_cache_migration *mg)
> {
> 	unsigned long flags;
> 	struct cache *cache = mg->cache;
> 
> 	if (mg->writeback) {
> 		DMWARN("shouldn't get here");

Explain why.  BUG? or corruption?

> 		return;

> /*
>  * People generally discard large parts of a device, eg, the whole device
>  * when formatting.  Splitting these large discards up into cache block
>  * sized ios and then quiescing (always neccessary for discard) takes too
>  * long.
>  *
>  * We keep it simple, and allow any size of discard to come in, and just
>  * mark off blocks on the discard bitset.  No passdown occurs!
>  *
>  * To implement passdown we need to change the bio_prison such that a cell
>  * can have a key that spans many blocks.  This change is planned for
>  * thin-provisioning.

Re-word the last bit of this slightly so it doesn't become incorrect if thin
provisioning implements this?  (Would we remember to update this comment
otherwise?)

>  */
> static void process_discard_bio(struct cache *cache, struct bio *bio)

> static void cache_dtr(struct dm_target *ti)
> {
> 	struct cache *cache = ti->private;
> 
> 	pr_alert("dm-cache statistics:\n");

alert?!  Just debugging code that you'll be removing, I trust:)

> static int ensure_args__(struct dm_arg_set *as,
> 		       unsigned count, char **error)
> {
> 	if (as->argc < count) {
> 		*error = "Insufficient args";
> 		return -EINVAL;
> 	}
> 
> 	return 0;
> }
> 
> #define ensure_args(n)					\
> 	do {						\
> 		r = ensure_args__(as, n, error);	\
> 		if (r)					\
> 			return r;			\
> 	} while (0)
> 

> static int parse_metadata_dev(struct cache_args *ca, struct dm_arg_set *as,
> 			      char **error)
> {
> 	int r;
> 	sector_t metadata_dev_size;
> 	char b[BDEVNAME_SIZE];
> 
> 	ensure_args(1);

I'm afraid I don't see any benefit of this: it slows down understanding
of the code and has a hidden 'return' that isn't hinted at in the macro 
name to trip people up.

Can we not do something like:

	if (!at_least_one_arg(as, error))
		return -EINVAL;

 
> #define parse(name)					\
> 	do {						\
> 		r = parse_ ## name(ca, &as, error);	\
> 		if (r)					\
> 			return r;			\
> 	} while (0)
> 
> 	parse(metadata_dev);
> 	parse(cache_dev);
> 	parse(origin_dev);
> 	parse(block_size);
> 	parse(features);
> 	parse(policy);
> #undef parse
 
Please just write this out longhand: I don't see the gain from making
the reader deal with a new macro.

> static struct kmem_cache *_migration_cache;

Remove _ prefix I think.

> static int cache_create(struct cache_args *ca, struct cache **result)

Use PTR_ERR maybe?  Maybe not.

> 	ti->num_discard_bios = 1;
> 	ti->discards_supported = true;
> 	ti->discard_zeroes_data_unsupported = true;
> 
> 	if (cache->features.write_through)

Fix:	if (ca->features.write_through)

> 		ti->num_write_bios = cache_num_write_bios;



> static int cache_status(struct dm_target *ti, status_type_t type,
> 			unsigned status_flags, char *result, unsigned maxlen)

Add provision for policy status here too?

> static int process_config_option(struct cache *cache, char **argv)

Document non-standard return value up-front?

> {
> 	if (!strcasecmp(argv[1], "migration_threshold")) {
> 		unsigned long tmp;
> 
> 		if (kstrtoul(argv[2], 10, &tmp))
> 			return -EINVAL;
> 
> 		cache->migration_threshold = tmp;

Does this need any validation or is any value OK/sensible?

> 
> 	} else
> 		return 1; /* Inform caller it's not our option. */

Invert if and return 1 immediately, dropping need for else + indentation?


Document current message(s) supported by this file inline ahead of function here

> static int cache_message(struct dm_target *ti, unsigned argc, char **argv)
> {
> 	int r = 0;
> 	struct cache *cache = ti->private;
> 
> 	if (argc != 3)
> 		return -EINVAL;
> 
> 	r = !strcasecmp(argv[0], "set_config") ? process_config_option(cache, argv) : 1;
> 
> 	if (r == 1) /* Message is for the target -> hand over to policy plugin. */
> 		r = policy_message(cache->policy, argc, argv);
> 

What's responsible for logging that the message wasn't recognised?
  or is EINVAL enough perhaps as we don't really add any info to that?

  Drop 'set_config'?
     => "set" or why not just use the variable name directly as the message?
 

> static int cache_bvec_merge(struct dm_target *ti,
> 			  struct bvec_merge_data *bvm,
> 			  struct bio_vec *biovec, int max_size)

Needs a comment to explain the reasoning here I think.
We act as if the cache dev wasn't present?
Then take the hit and split later if cached?
Have we seen any impact in tests or tried alternatives here?

> static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)

Check carefully. The thin version of this had to be fixed.

> static void dm_cache_exit(void)

Missing __exit (not used anywhere else)

Alasdair
