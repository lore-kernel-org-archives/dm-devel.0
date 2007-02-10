From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] device-mapper: Bad Block relocation target
Date: Fri, 9 Feb 2007 17:23:04 -0800
Message-ID: <20070209172304.c063dcbd.akpm@linux-foundation.org>
References: <20070210010159.835207B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <evms-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070210010159.835207B409F@zog.reactivated.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: evms-devel-bounces@lists.sourceforge.net
Errors-To: evms-devel-bounces@lists.sourceforge.net
To: Daniel Drake <dsd@gentoo.org>
Cc: dm-devel@redhat.com, evms-devel@lists.sourceforge.net, kevcorry@us.ibm.com
List-Id: dm-devel.ids

On Sat, 10 Feb 2007 01:01:57 +0000 (GMT)
Daniel Drake <dsd@gentoo.org> wrote:

> The BBR target is designed to remap I/O write failures to another safe
> location on disk. Note that most disk drives have BBR built into them,
> this means that our software BBR will be only activated when all hardware
> BBR replacement sectors have been used.
> 
> This patch is included in the EVMS tarball, and Gentoo have been shipping
> it as part of the default kernel for a long time. I know that some users
> are running it, and haven't seen any reported bugs in a long time.
> 
> Please consider this for -mm and possible later inclusion in mainline.
> 
> I haven't been involved in the development of this target, but have brushed
> it up a little from the one included in the EVMS tarball.
> 
> Kevin, I see from mailing list archives that you were somehow involved in
> this project. Can you clarify who the main developers were so that we can
> include this in the history if it gets merged?
>

Some minorish things..
 
> +static struct workqueue_struct *dm_bbr_wq = NULL;

Unneeded initialisation.

> +static struct bbr_private *bbr_alloc_private(void)
> +{
> +	struct bbr_private *bbr_id;
> +
> +	bbr_id = kmalloc(sizeof(*bbr_id), GFP_KERNEL);
> +	if (bbr_id) {
> +		memset(bbr_id, 0, sizeof(*bbr_id));

kzalloc.

> +		INIT_WORK(&bbr_id->remap_work, bbr_remap_handler, bbr_id);
> +		bbr_id->remap_root_lock = SPIN_LOCK_UNLOCKED;
> +		bbr_id->remap_ios_lock = SPIN_LOCK_UNLOCKED;

This initialisation will confound lockdep.  Please use spin_lock_init().

Then please test this code under lockdep ;)

> +		bbr_id->in_use_replacement_blks = (atomic_t)ATOMIC_INIT(0);
> +	}
> +
> +	return bbr_id;
> +}
> +
> +static void bbr_free_private(struct bbr_private *bbr_id)
> +{
> +	if (bbr_id->bbr_table) {
> +		vfree(bbr_id->bbr_table);
> +	}

unneeded braces.

> +	bbr_free_remap(bbr_id);
> +	kfree(bbr_id);
> +}
> +
> +static u32 crc_table[256];
> +static u32 crc_table_built = 0;

unneeded initialisation.

> +static void build_crc_table(void)
> +{
> +	u32 i, j, crc;
> +
> +	for (i = 0; i <= 255; i++) {
> +		crc = i;
> +		for (j = 8; j > 0; j--) {
> +			if (crc & 1)
> +				crc = (crc >> 1) ^ CRC_POLYNOMIAL;
> +			else
> +				crc >>= 1;
> +		}
> +		crc_table[i] = crc;
> +	}
> +	crc_table_built = 1;
> +}
> +
> +static u32 calculate_crc(u32 crc, void *buffer, u32 buffersize)
> +{
> +	unsigned char *current_byte;
> +	u32 temp1, temp2, i;
> +
> +	current_byte = (unsigned char *) buffer;
> +	/* Make sure the crc table is available */
> +	if (!crc_table_built)
> +		build_crc_table();
> +	/* Process each byte in the buffer. */
> +	for (i = 0; i < buffersize; i++) {
> +		temp1 = (crc >> 8) & 0x00FFFFFF;
> +		temp2 = crc_table[(crc ^ (u32) * current_byte) &
> +				  (u32) 0xff];
> +		current_byte++;
> +		crc = temp1 ^ temp2;
> +	}
> +	return crc;
> +}

Can't this use the kernel's crc library functions?

> +
> +/**
> + * bbr_table_to_remap_list
> + *
> + * The on-disk bbr table is sorted by the replacement sector LBA. In order to
> + * improve run time performance, the in memory remap list must be sorted by
> + * the bad sector LBA. This function is called at discovery time to initialize
> + * the remap list. This function assumes that at least one copy of meta data
> + * is valid.
> + **/
> +static u32 bbr_table_to_remap_list(struct bbr_private *bbr_id)
> +{
> +	u32 in_use_blks = 0;
> +	int i, j;
> +	struct bbr_table *p;
> +
> +	for (i = 0, p = bbr_id->bbr_table;
> +	     i < bbr_id->nr_sects_bbr_table;
> +	     i++, p++) {
> +		if (!p->in_use_cnt) {
> +			break;
> +		}

unneeded braces

> +		in_use_blks += p->in_use_cnt;
> +		for (j = 0; j < p->in_use_cnt; j++) {
> +			bbr_insert_remap_entry(bbr_id, &p->entries[j]);
> +		}

more

> +	}
> +	if (in_use_blks) {
> +		char b[32];
> +		DMWARN("dm-bbr: There are %u BBR entries for device %s",
> +		       in_use_blks, format_dev_t(b, bbr_id->dev->bdev->bd_dev));
> +	}
> +
> +	return in_use_blks;
> +}
> +
> +/**
> + * bbr_search_remap_entry
> + *
> + * Search remap entry for the specified sector. If found, return a pointer to
> + * the table entry. Otherwise, return NULL.
> + **/
> +static struct bbr_table_entry *bbr_search_remap_entry(
> +	struct bbr_private *bbr_id,
> +	u64 lsn)
> +{
> +	struct bbr_runtime_remap *p;
> +
> +	spin_lock_irq(&bbr_id->remap_root_lock);
> +	p = bbr_binary_search(bbr_id->remap_root, lsn);
> +	spin_unlock_irq(&bbr_id->remap_root_lock);
> +	if (p) {
> +		return (&p->remap);
> +	} else {
> +		return NULL;
> +	}

more.

> +}
> +
> +/**
> + * bbr_remap
> + *
> + * If *lsn is in the remap table, return TRUE and modify *lsn,
> + * else, return FALSE.
> + **/
> +static inline int bbr_remap(struct bbr_private *bbr_id,
> +			    u64 *lsn)

lsn is a sector number?  Is u64 the appropriate type to be using?  Why not
the more efficient sector_t?

> +
> +/**
> + * bbr_remap_probe
> + *
> + * If any of the sectors in the range [lsn, lsn+nr_sects] are in the remap
> + * table return TRUE, Else, return FALSE.
> + **/
> +static inline int bbr_remap_probe(struct bbr_private *bbr_id,
> +				  u64 lsn, u64 nr_sects)

And here (everywhere)

> +{
> +	u64 tmp, cnt;
> +
> +	if (atomic_read(&bbr_id->in_use_replacement_blks)) {
> +		for (cnt = 0, tmp = lsn;
> +		     cnt < nr_sects;
> +		     cnt += bbr_id->blksize_in_sects, tmp = lsn + cnt) {
> +			if (bbr_remap(bbr_id,&tmp)) {
> +				return 1;
> +			}

braces.  (everywhere)

> +			DMWARN("dm-bbr: device %s: Trying to remap bad sector "PFU64" to sector "PFU64,

80-cols, please.

> +	/* KMC: Is this the right way to walk the bvec list? */

bio_for_each_segment()?

> +	for (i = 0;
> +	     i < bio->bi_vcnt;
> +	     i++, bio->bi_idx++, starting_lsn += count) {
> +
> +		/* Bvec info: number of sectors, page,
> +		 * and byte-offset within page.
> +		 */
> +		count = bio_iovec(bio)->bv_len >> SECTOR_SHIFT;
> +		pl.page = bio_iovec(bio)->bv_page;
> +		offset = bio_iovec(bio)->bv_offset;
> +
> +
>
> ...
>
> +int __init dm_bbr_init(void)

static?

> +{
> +	int rc;
> +
> +	rc = dm_register_target(&bbr_target);
> +	if (rc) {
> +		DMERR("dm-bbr: error registering target.");
> +		goto err1;
> +	}
> +
> +	bbr_remap_cache = kmem_cache_create("bbr-remap",
> +					    sizeof(struct bbr_runtime_remap),
> +					    0, SLAB_HWCACHE_ALIGN, NULL, NULL);

SLAB_HWCACHE_ALIGN uses extra space.  Is it really needed?

> +	if (!bbr_remap_cache) {
> +		DMERR("dm-bbr: error creating remap cache.");
> +		rc = ENOMEM;
> +		goto err2;
> +	}
> +
> +	bbr_io_cache = kmem_cache_create("bbr-io", sizeof(struct dm_bio_details),
> +					 0, SLAB_HWCACHE_ALIGN, NULL, NULL);

ditto

> +	if (!bbr_io_cache) {
> +		DMERR("dm-bbr: error creating io cache.");
> +		rc = ENOMEM;
> +		goto err3;
> +	}
> +
> +	bbr_io_pool = mempool_create(256, mempool_alloc_slab,
> +				     mempool_free_slab, bbr_io_cache);
> +	if (!bbr_io_pool) {
> +		DMERR("dm-bbr: error creating io mempool.");
> +		rc = ENOMEM;
> +		goto err4;
> +	}
> +
> +	dm_bbr_wq = create_workqueue("dm-bbr");

Could this be a single-threaded workqueue?

> +void __exit dm_bbr_exit(void)

static?

> +{
> +	dm_io_put(1);
> +	destroy_workqueue(dm_bbr_wq);
> +	mempool_destroy(bbr_io_pool);
> +	kmem_cache_destroy(bbr_io_cache);
> +	kmem_cache_destroy(bbr_remap_cache);
> +	dm_unregister_target(&bbr_target);
> +}
> +
> +module_init(dm_bbr_init);
> +module_exit(dm_bbr_exit);
> +MODULE_LICENSE("GPL");
>
> ...
>
> +#if BITS_PER_LONG > 32
> +#define PFU64 "%lu"
> +#else
> +#define PFU64 "%Lu"
> +#endif

This gets ugly.  And I expect it'll generate a warning storm on powerpc,
where u64 is `unsigned long', not `unsigned long long'.  Please just use
%Lu and typecast the argument to `unsigned long long' at each callsite.

> +/**
> + * struct bbr_table_entry
> + * @bad_sect:		LBA of bad location.
> + * @replacement_sect:	LBA of new location.
> + *
> + * Structure to describe one BBR remap.
> + **/
> +struct bbr_table_entry {
> +	u64 bad_sect;
> +	u64 replacement_sect;
> +};

sector_t?



-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier.
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
