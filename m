From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 08/10] dm-integrity: add a bitmap mode
Date: Mon, 29 Apr 2019 14:57:24 +0200
Message-ID: <20190429125746.036036640@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-bitmap.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Add a new bitmap mode for dm-integrity.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/dm-integrity.txt |   23 +
 drivers/md/dm-integrity.c                    |  534 +++++++++++++++++++++++++--
 2 files changed, 525 insertions(+), 32 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-27 10:28:49.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-29 11:43:38.000000000 +0200
@@ -24,6 +24,7 @@
 
 #define DEFAULT_INTERLEAVE_SECTORS	32768
 #define DEFAULT_JOURNAL_SIZE_FACTOR	7
+#define DEFAULT_SECTORS_PER_BITMAP_BIT	32768
 #define DEFAULT_BUFFER_SECTORS		128
 #define DEFAULT_JOURNAL_WATERMARK	50
 #define DEFAULT_SYNC_MSEC		10000
@@ -33,6 +34,8 @@
 #define METADATA_WORKQUEUE_MAX_ACTIVE	16
 #define RECALC_SECTORS			8192
 #define RECALC_WRITE_SUPER		16
+#define BITMAP_BLOCK_SIZE		4096	/* don't change it */
+#define BITMAP_FLUSH_INTERVAL		(10 * HZ)
 
 /*
  * Warning - DEBUG_PRINT prints security-sensitive data to the log,
@@ -48,6 +51,7 @@
 #define SB_MAGIC			"integrt"
 #define SB_VERSION_1			1
 #define SB_VERSION_2			2
+#define SB_VERSION_3			3
 #define SB_SECTORS			8
 #define MAX_SECTORS_PER_BLOCK		8
 
@@ -60,12 +64,14 @@ struct superblock {
 	__u64 provided_data_sectors;	/* userspace uses this value */
 	__u32 flags;
 	__u8 log2_sectors_per_block;
-	__u8 pad[3];
+	__u8 log2_blocks_per_bitmap_bit;
+	__u8 pad[2];
 	__u64 recalc_sector;
 };
 
 #define SB_FLAG_HAVE_JOURNAL_MAC	0x1
 #define SB_FLAG_RECALCULATING		0x2
+#define SB_FLAG_DIRTY_BITMAP		0x4
 
 #define	JOURNAL_ENTRY_ROUNDUP		8
 
@@ -155,9 +161,16 @@ struct dm_integrity_c {
 	struct workqueue_struct *metadata_wq;
 	struct superblock *sb;
 	unsigned journal_pages;
+	unsigned n_bitmap_blocks;
+
 	struct page_list *journal;
 	struct page_list *journal_io;
 	struct page_list *journal_xor;
+	struct page_list *recalc_bitmap;
+	struct page_list *may_write_bitmap;
+	struct bitmap_block_status *bbs;
+	unsigned bitmap_flush_interval;
+	struct delayed_work bitmap_flush_work;
 
 	struct crypto_skcipher *journal_crypt;
 	struct scatterlist **journal_scatterlist;
@@ -184,6 +197,7 @@ struct dm_integrity_c {
 	__s8 log2_metadata_run;
 	__u8 log2_buffer_sectors;
 	__u8 sectors_per_block;
+	__u8 log2_blocks_per_bitmap_bit;
 
 	unsigned char mode;
 	int suspending;
@@ -236,6 +250,7 @@ struct dm_integrity_c {
 
 	bool journal_uptodate;
 	bool just_formatted;
+	bool recalculate_flag;
 
 	struct alg_spec internal_hash_alg;
 	struct alg_spec journal_crypt_alg;
@@ -292,6 +307,16 @@ struct journal_io {
 	struct journal_completion *comp;
 };
 
+struct bitmap_block_status {
+	struct work_struct work;
+	struct dm_integrity_c *ic;
+	unsigned idx;
+	unsigned long *bitmap;
+	struct bio_list bio_queue;
+	spinlock_t bio_queue_lock;
+
+};
+
 static struct kmem_cache *journal_io_cache;
 
 #define JOURNAL_IO_MEMPOOL	32
@@ -427,7 +452,9 @@ static void wraparound_section(struct dm
 
 static void sb_set_version(struct dm_integrity_c *ic)
 {
-	if (ic->meta_dev || ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
+	if (ic->mode == 'B' || ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP))
+		ic->sb->version = SB_VERSION_3;
+	else if (ic->meta_dev || ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
 		ic->sb->version = SB_VERSION_2;
 	else
 		ic->sb->version = SB_VERSION_1;
@@ -451,6 +478,135 @@ static int sync_rw_sb(struct dm_integrit
 	return dm_io(&io_req, 1, &io_loc, NULL);
 }
 
+#define BITMAP_OP_TEST_ALL_SET		0
+#define BITMAP_OP_TEST_ALL_CLEAR	1
+#define BITMAP_OP_SET			2
+#define BITMAP_OP_CLEAR			3
+
+static bool block_bitmap_op(struct dm_integrity_c *ic, struct page_list *bitmap, sector_t sector, sector_t n_sectors, int mode)
+{
+	unsigned long bit, end_bit, this_end_bit, page, end_page;
+	unsigned long *data;
+
+	if (unlikely(((sector | n_sectors) & ((1 << ic->sb->log2_sectors_per_block) - 1)) != 0)) {
+		DMCRIT("invalid bitmap access (%llx,%llx,%d,%d,%d)\n",
+			(unsigned long long)sector,
+			(unsigned long long)n_sectors,
+			ic->sb->log2_sectors_per_block,
+			ic->log2_blocks_per_bitmap_bit,
+			mode);
+		BUG();
+	}
+
+	if (unlikely(!n_sectors))
+		return true;
+
+	bit = sector >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+	end_bit = (sector + n_sectors - 1) >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+
+	page = bit / (PAGE_SIZE * 8);
+	bit %= PAGE_SIZE * 8;
+
+	end_page = end_bit / (PAGE_SIZE * 8);
+	end_bit %= PAGE_SIZE * 8;
+
+repeat:
+	if (page < end_page) {
+		this_end_bit = PAGE_SIZE * 8 - 1;
+	} else {
+		this_end_bit = end_bit;
+	}
+
+	data = lowmem_page_address(bitmap[page].page);
+
+	if (mode == BITMAP_OP_TEST_ALL_SET) {
+		while (bit <= this_end_bit) {
+			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
+				do {
+					if (data[bit / BITS_PER_LONG] != -1)
+						return false;
+					bit += BITS_PER_LONG;
+				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
+				continue;
+			}
+			if (!test_bit(bit, data))
+				return false;
+			bit++;
+		}
+	} else if (mode == BITMAP_OP_TEST_ALL_CLEAR) {
+		while (bit <= this_end_bit) {
+			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
+				do {
+					if (data[bit / BITS_PER_LONG] != 0)
+						return false;
+					bit += BITS_PER_LONG;
+				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
+				continue;
+			}
+			if (test_bit(bit, data))
+				return false;
+			bit++;
+		}
+	} else if (mode == BITMAP_OP_SET) {
+		while (bit <= this_end_bit) {
+			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
+				do {
+					data[bit / BITS_PER_LONG] = -1;
+					bit += BITS_PER_LONG;
+				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
+				continue;
+			}
+			__set_bit(bit, data);
+			bit++;
+		}
+	} else if (mode == BITMAP_OP_CLEAR) {
+		if (!bit && this_end_bit == PAGE_SIZE * 8 - 1)
+			clear_page(data);
+		else while (bit <= this_end_bit) {
+			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
+				do {
+					data[bit / BITS_PER_LONG] = 0;
+					bit += BITS_PER_LONG;
+				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
+				continue;
+			}
+			__clear_bit(bit, data);
+			bit++;
+		}
+	} else {
+		BUG();
+	}
+
+	if (unlikely(page < end_page)) {
+		bit = 0;
+		page++;
+		goto repeat;
+	}
+
+	return true;
+}
+
+static void block_bitmap_copy(struct dm_integrity_c *ic, struct page_list *dst, struct page_list *src)
+{
+	unsigned n_bitmap_pages = DIV_ROUND_UP(ic->n_bitmap_blocks, PAGE_SIZE / BITMAP_BLOCK_SIZE);
+	unsigned i;
+
+	for (i = 0; i < n_bitmap_pages; i++) {
+		unsigned long *dst_data = lowmem_page_address(dst[i].page);
+		unsigned long *src_data = lowmem_page_address(src[i].page);
+		copy_page(dst_data, src_data);
+	}
+}
+
+static struct bitmap_block_status *sector_to_bitmap_block(struct dm_integrity_c *ic, sector_t sector)
+{
+	unsigned bit = sector >> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+	unsigned bitmap_block = bit / (BITMAP_BLOCK_SIZE * 8);
+
+	BUG_ON(bitmap_block >= ic->n_bitmap_blocks);
+	return &ic->bbs[bitmap_block];
+}
+
 static void access_journal_check(struct dm_integrity_c *ic, unsigned section, unsigned offset,
 				 bool e, const char *function)
 {
@@ -1784,6 +1940,20 @@ offload_to_thread:
 		goto journal_read_write;
 	}
 
+	if (ic->mode == 'B' && dio->write) {
+		if (!block_bitmap_op(ic, ic->may_write_bitmap, dio->range.logical_sector, dio->range.n_sectors, BITMAP_OP_TEST_ALL_SET)) {
+			struct bitmap_block_status *bbs = sector_to_bitmap_block(ic, dio->range.logical_sector);
+
+			spin_lock(&bbs->bio_queue_lock);
+			bio_list_add(&bbs->bio_queue, bio);
+			spin_unlock(&bbs->bio_queue_lock);
+
+			queue_work(ic->writer_wq, &bbs->work);
+
+			return;
+		}
+	}
+
 	dio->in_flight = (atomic_t)ATOMIC_INIT(2);
 
 	if (need_sync_io) {
@@ -1810,10 +1980,14 @@ offload_to_thread:
 
 	if (need_sync_io) {
 		wait_for_completion_io(&read_comp);
-		if (unlikely(ic->recalc_wq != NULL) &&
-		    ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
+		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
 		    dio->range.logical_sector + dio->range.n_sectors > le64_to_cpu(ic->sb->recalc_sector))
 			goto skip_check;
+		if (ic->mode == 'B') {
+			if (!block_bitmap_op(ic, ic->recalc_bitmap, dio->range.logical_sector, dio->range.n_sectors, BITMAP_OP_TEST_ALL_CLEAR))
+				goto skip_check;
+		}
+
 		if (likely(!bio->bi_status))
 			integrity_metadata(&dio->work);
 		else
@@ -1851,8 +2025,22 @@ static void pad_uncommitted(struct dm_in
 		wraparound_section(ic, &ic->free_section);
 		ic->n_uncommitted_sections++;
 	}
-	WARN_ON(ic->journal_sections * ic->journal_section_entries !=
-		(ic->n_uncommitted_sections + ic->n_committed_sections) * ic->journal_section_entries + ic->free_sectors);
+	if (WARN_ON(ic->journal_sections * ic->journal_section_entries !=
+		(ic->n_uncommitted_sections + ic->n_committed_sections) * ic->journal_section_entries + ic->free_sectors)) {
+		printk(KERN_CRIT "dm-integrity: "
+			"journal_sections %u, "
+			"journal_section_entries %u, "
+			"n_uncommitted_sections %u, "
+			"n_committed_sections %u, "
+			"journal_section_entries %u, "
+			"free_sectors %u\n",
+			ic->journal_sections,
+			ic->journal_section_entries,
+			ic->n_uncommitted_sections,
+			ic->n_committed_sections,
+			ic->journal_section_entries,
+			ic->free_sectors);
+	}
 }
 
 static void integrity_commit(struct work_struct *w)
@@ -2139,11 +2327,14 @@ static void integrity_recalc(struct work
 	sector_t area, offset;
 	sector_t metadata_block;
 	unsigned metadata_offset;
+	sector_t logical_sector, n_sectors;
 	__u8 *t;
 	unsigned i;
 	int r;
 	unsigned super_counter = 0;
 
+	DEBUG_print("start recalculation... (position %llx)\n", le64_to_cpu(ic->sb->recalc_sector));
+
 	spin_lock_irq(&ic->endio_wait.lock);
 
 next_chunk:
@@ -2152,8 +2343,13 @@ next_chunk:
 		goto unlock_ret;
 
 	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
-	if (unlikely(range.logical_sector >= ic->provided_data_sectors))
+	if (unlikely(range.logical_sector >= ic->provided_data_sectors)) {
+		if (ic->mode == 'B') {
+			DEBUG_print("queue_delayed_work: bitmap_flush_work\n");
+			queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, 0);
+		}
 		goto unlock_ret;
+	}
 
 	get_area_and_offset(ic, range.logical_sector, &area, &offset);
 	range.n_sectors = min((sector_t)RECALC_SECTORS, ic->provided_data_sectors - range.logical_sector);
@@ -2161,11 +2357,33 @@ next_chunk:
 		range.n_sectors = min(range.n_sectors, ((sector_t)1U << ic->sb->log2_interleave_sectors) - (unsigned)offset);
 
 	add_new_range_and_wait(ic, &range);
-
 	spin_unlock_irq(&ic->endio_wait.lock);
+	logical_sector = range.logical_sector;
+	n_sectors = range.n_sectors;
+
+	if (ic->mode == 'B') {
+		if (block_bitmap_op(ic, ic->recalc_bitmap, logical_sector, n_sectors, BITMAP_OP_TEST_ALL_CLEAR)) {
+			goto advance_and_next;
+		}
+		while (block_bitmap_op(ic, ic->recalc_bitmap, logical_sector, ic->sectors_per_block, BITMAP_OP_TEST_ALL_CLEAR)) {
+			logical_sector += ic->sectors_per_block;
+			n_sectors -= ic->sectors_per_block;
+			cond_resched();
+		}
+		while (block_bitmap_op(ic, ic->recalc_bitmap, logical_sector + n_sectors - ic->sectors_per_block, ic->sectors_per_block, BITMAP_OP_TEST_ALL_CLEAR)) {
+			n_sectors -= ic->sectors_per_block;
+			cond_resched();
+		}
+		get_area_and_offset(ic, logical_sector, &area, &offset);
+	}
+
+	DEBUG_print("recalculating: %lx, %lx\n", logical_sector, n_sectors);
 
 	if (unlikely(++super_counter == RECALC_WRITE_SUPER)) {
 		recalc_write_super(ic);
+		if (ic->mode == 'B') {
+			queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, ic->bitmap_flush_interval);
+		}
 		super_counter = 0;
 	}
 
@@ -2180,7 +2398,7 @@ next_chunk:
 	io_req.client = ic->io;
 	io_loc.bdev = ic->dev->bdev;
 	io_loc.sector = get_data_sector(ic, area, offset);
-	io_loc.count = range.n_sectors;
+	io_loc.count = n_sectors;
 
 	r = dm_io(&io_req, 1, &io_loc, NULL);
 	if (unlikely(r)) {
@@ -2189,8 +2407,8 @@ next_chunk:
 	}
 
 	t = ic->recalc_tags;
-	for (i = 0; i < range.n_sectors; i += ic->sectors_per_block) {
-		integrity_sector_checksum(ic, range.logical_sector + i, ic->recalc_buffer + (i << SECTOR_SHIFT), t);
+	for (i = 0; i < n_sectors; i += ic->sectors_per_block) {
+		integrity_sector_checksum(ic, logical_sector + i, ic->recalc_buffer + (i << SECTOR_SHIFT), t);
 		t += ic->tag_size;
 	}
 
@@ -2202,6 +2420,9 @@ next_chunk:
 		goto err;
 	}
 
+advance_and_next:
+	cond_resched();
+
 	spin_lock_irq(&ic->endio_wait.lock);
 	remove_range_unlocked(ic, &range);
 	ic->sb->recalc_sector = cpu_to_le64(range.logical_sector + range.n_sectors);
@@ -2217,6 +2438,89 @@ unlock_ret:
 	recalc_write_super(ic);
 }
 
+static void bitmap_block_work(struct work_struct *w)
+{
+	struct bitmap_block_status *bbs = container_of(w, struct bitmap_block_status, work);
+	struct dm_integrity_c *ic = bbs->ic;
+	struct bio *bio;
+	struct bio_list bio_queue;
+	struct bio_list waiting;
+
+	bio_list_init(&waiting);
+
+	spin_lock(&bbs->bio_queue_lock);
+	bio_queue = bbs->bio_queue;
+	bio_list_init(&bbs->bio_queue);
+	spin_unlock(&bbs->bio_queue_lock);
+
+	while ((bio = bio_list_pop(&bio_queue))) {
+		struct dm_integrity_io *dio;
+
+		dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
+
+		if (block_bitmap_op(ic, ic->may_write_bitmap, dio->range.logical_sector, dio->range.n_sectors, BITMAP_OP_TEST_ALL_SET)) {
+			remove_range(ic, &dio->range);
+			INIT_WORK(&dio->work, integrity_bio_wait);
+			queue_work(ic->wait_wq, &dio->work);
+		} else {
+			block_bitmap_op(ic, ic->journal, dio->range.logical_sector, dio->range.n_sectors, BITMAP_OP_SET);
+			bio_list_add(&waiting, bio);
+		}
+	}
+
+	if (bio_list_empty(&waiting))
+		return;
+
+	rw_journal_sectors(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, bbs->idx * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), BITMAP_BLOCK_SIZE >> SECTOR_SHIFT, NULL);
+
+	while ((bio = bio_list_pop(&waiting))) {
+		struct dm_integrity_io *dio = dm_per_bio_data(bio, sizeof(struct dm_integrity_io));
+
+		block_bitmap_op(ic, ic->may_write_bitmap, dio->range.logical_sector, dio->range.n_sectors, BITMAP_OP_SET);
+
+		remove_range(ic, &dio->range);
+		INIT_WORK(&dio->work, integrity_bio_wait);
+		queue_work(ic->wait_wq, &dio->work);
+	}
+
+	queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, ic->bitmap_flush_interval);
+}
+
+static void bitmap_flush_work(struct work_struct *work)
+{
+	struct dm_integrity_c *ic = container_of(work, struct dm_integrity_c, bitmap_flush_work.work);
+	struct dm_integrity_range range;
+	unsigned long limit;
+
+	dm_integrity_flush_buffers(ic);
+
+	range.logical_sector = 0;
+	range.n_sectors = ic->provided_data_sectors;
+
+	spin_lock_irq(&ic->endio_wait.lock);
+	add_new_range_and_wait(ic, &range);
+	spin_unlock_irq(&ic->endio_wait.lock);
+
+	dm_integrity_flush_buffers(ic);
+	if (ic->meta_dev)
+		blkdev_issue_flush(ic->dev->bdev, GFP_NOIO, NULL);
+
+	limit = ic->provided_data_sectors;
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
+		limit = le64_to_cpu(ic->sb->recalc_sector)
+			>> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit)
+			<< (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+	}
+	DEBUG_print("zeroing journal\n");
+	block_bitmap_op(ic, ic->journal, 0, limit, BITMAP_OP_CLEAR);
+	block_bitmap_op(ic, ic->may_write_bitmap, 0, limit, BITMAP_OP_CLEAR);
+
+	rw_journal_sectors(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, 0, ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
+
+	remove_range(ic, &range);
+}
+
+
 static void init_journal(struct dm_integrity_c *ic, unsigned start_section,
 			 unsigned n_sections, unsigned char commit_seq)
 {
@@ -2416,6 +2720,7 @@ clear_journal:
 static void dm_integrity_postsuspend(struct dm_target *ti)
 {
 	struct dm_integrity_c *ic = (struct dm_integrity_c *)ti->private;
+	int r;
 
 	del_timer_sync(&ic->autocommit_timer);
 
@@ -2424,6 +2729,9 @@ static void dm_integrity_postsuspend(str
 	if (ic->recalc_wq)
 		drain_workqueue(ic->recalc_wq);
 
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
+
 	queue_work(ic->commit_wq, &ic->commit_work);
 	drain_workqueue(ic->commit_wq);
 
@@ -2434,6 +2742,17 @@ static void dm_integrity_postsuspend(str
 		dm_integrity_flush_buffers(ic);
 	}
 
+	if (ic->mode == 'B') {
+		dm_integrity_flush_buffers(ic);
+#if 1
+		init_journal(ic, 0, ic->journal_sections, 0);
+		ic->sb->flags &= ~cpu_to_le32(SB_FLAG_DIRTY_BITMAP);
+		r = sync_rw_sb(ic, REQ_OP_WRITE, REQ_FUA);
+		if (unlikely(r))
+			dm_integrity_io_error(ic, "writing superblock", r);
+#endif
+	}
+
 	WRITE_ONCE(ic->suspending, 0);
 
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
@@ -2444,11 +2763,65 @@ static void dm_integrity_postsuspend(str
 static void dm_integrity_resume(struct dm_target *ti)
 {
 	struct dm_integrity_c *ic = (struct dm_integrity_c *)ti->private;
+	int r;
+	DEBUG_print("resume\n");
 
-	replay_journal(ic);
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP)) {
+		DEBUG_print("resume dirty_bitmap\n");
+		rw_journal_sectors(ic, REQ_OP_READ, 0, 0, ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
+		if (ic->mode == 'B') {
+			if (ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit) {
+				block_bitmap_copy(ic, ic->recalc_bitmap, ic->journal);
+				block_bitmap_copy(ic, ic->may_write_bitmap, ic->journal);
+				if (!block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, BITMAP_OP_TEST_ALL_CLEAR)) {
+					ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
+					ic->sb->recalc_sector = cpu_to_le64(0);
+				}
+			} else {
+				DEBUG_print("non-matching blocks_per_bitmap_bit: %u, %u\n", ic->sb->log2_blocks_per_bitmap_bit, ic->log2_blocks_per_bitmap_bit);
+				ic->sb->log2_blocks_per_bitmap_bit = ic->log2_blocks_per_bitmap_bit;
+				block_bitmap_op(ic, ic->recalc_bitmap, 0, ic->provided_data_sectors, BITMAP_OP_SET);
+				block_bitmap_op(ic, ic->may_write_bitmap, 0, ic->provided_data_sectors, BITMAP_OP_SET);
+				block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, BITMAP_OP_SET);
+				rw_journal_sectors(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, 0, ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
+				ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
+				ic->sb->recalc_sector = cpu_to_le64(0);
+			}
+		} else {
+			if (!(ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit &&
+			      block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, BITMAP_OP_TEST_ALL_CLEAR))) {
+				ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
+				ic->sb->recalc_sector = cpu_to_le64(0);
+			}
+			init_journal(ic, 0, ic->journal_sections, 0);
+			replay_journal(ic);
+			ic->sb->flags &= ~cpu_to_le32(SB_FLAG_DIRTY_BITMAP);
+		}
+		r = sync_rw_sb(ic, REQ_OP_WRITE, REQ_FUA);
+		if (unlikely(r))
+			dm_integrity_io_error(ic, "writing superblock", r);
+	} else {
+		replay_journal(ic);
+		if (ic->mode == 'B') {
+			int mode;
+			ic->sb->flags |= cpu_to_le32(SB_FLAG_DIRTY_BITMAP);
+			ic->sb->log2_blocks_per_bitmap_bit = ic->log2_blocks_per_bitmap_bit;
+			r = sync_rw_sb(ic, REQ_OP_WRITE, REQ_FUA);
+			if (unlikely(r))
+				dm_integrity_io_error(ic, "writing superblock", r);
+
+			mode = ic->recalculate_flag ? BITMAP_OP_SET : BITMAP_OP_CLEAR;
+			block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, mode);
+			block_bitmap_op(ic, ic->recalc_bitmap, 0, ic->provided_data_sectors, mode);
+			block_bitmap_op(ic, ic->may_write_bitmap, 0, ic->provided_data_sectors, mode);
+			rw_journal_sectors(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, 0, ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
+		}
+	}
 
-	if (ic->recalc_wq && ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
+	DEBUG_print("testing recalc: %x\n", ic->sb->flags);
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
 		__u64 recalc_pos = le64_to_cpu(ic->sb->recalc_sector);
+		DEBUG_print("recalc pos: %lx / %lx\n", (long)recalc_pos, ic->provided_data_sectors);
 		if (recalc_pos < ic->provided_data_sectors) {
 			queue_work(ic->recalc_wq, &ic->recalc_work);
 		} else if (recalc_pos > ic->provided_data_sectors) {
@@ -2486,6 +2859,8 @@ static void dm_integrity_status(struct d
 		arg_count += !!(ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING));
 		arg_count += ic->mode == 'J';
 		arg_count += ic->mode == 'J';
+		arg_count += ic->mode == 'B';
+		arg_count += ic->mode == 'B';
 		arg_count += !!ic->internal_hash_alg.alg_string;
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
@@ -2495,7 +2870,7 @@ static void dm_integrity_status(struct d
 			DMEMIT(" meta_device:%s", ic->meta_dev->name);
 		if (ic->sectors_per_block != 1)
 			DMEMIT(" block_size:%u", ic->sectors_per_block << SECTOR_SHIFT);
-		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
+		if (ic->recalculate_flag)
 			DMEMIT(" recalculate");
 		DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
@@ -2504,6 +2879,10 @@ static void dm_integrity_status(struct d
 			DMEMIT(" journal_watermark:%u", (unsigned)watermark_percentage);
 			DMEMIT(" commit_time:%u", ic->autocommit_msec);
 		}
+		if (ic->mode == 'B') {
+			DMEMIT(" sectors_per_bit:%llu", (unsigned long long)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit);
+			DMEMIT(" bitmap_flush_interval:%u", jiffies_to_msecs(ic->bitmap_flush_interval));
+		}
 
 #define EMIT_ALG(a, n)							\
 		do {							\
@@ -3085,7 +3464,7 @@ bad:
  *	device
  *	offset from the start of the device
  *	tag size
- *	D - direct writes, J - journal writes, R - recovery mode
+ *	D - direct writes, J - journal writes, B - bitmap mode, R - recovery mode
  *	number of optional arguments
  *	optional arguments:
  *		journal_sectors
@@ -3095,6 +3474,8 @@ bad:
  *		commit_time
  *		meta_device
  *		block_size
+ *		sectors_per_bit
+ *		bitmap_flush_interval
  *		internal_hash
  *		journal_crypt
  *		journal_mac
@@ -3111,10 +3492,13 @@ static int dm_integrity_ctr(struct dm_ta
 		{0, 9, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
-	bool recalculate;
 	bool should_write_sb;
 	__u64 threshold;
 	unsigned long long start;
+	__s8 log2_sectors_per_bitmap_bit = -1;
+	__s8 log2_blocks_per_bitmap_bit;
+	__u64 bits_in_journal;
+	__u64 n_bitmap_bits;
 
 #define DIRECT_ARGUMENTS	4
 
@@ -3138,6 +3522,7 @@ static int dm_integrity_ctr(struct dm_ta
 	init_waitqueue_head(&ic->copy_to_journal_wait);
 	init_completion(&ic->crypto_backoff);
 	atomic64_set(&ic->number_of_mismatches, 0);
+	ic->bitmap_flush_interval = BITMAP_FLUSH_INTERVAL;
 
 	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &ic->dev);
 	if (r) {
@@ -3160,10 +3545,10 @@ static int dm_integrity_ctr(struct dm_ta
 		}
 	}
 
-	if (!strcmp(argv[3], "J") || !strcmp(argv[3], "D") || !strcmp(argv[3], "R"))
+	if (!strcmp(argv[3], "J") || !strcmp(argv[3], "B") || !strcmp(argv[3], "D") || !strcmp(argv[3], "R")) {
 		ic->mode = argv[3][0];
-	else {
-		ti->error = "Invalid mode (expecting J, D, R)";
+	} else {
+		ti->error = "Invalid mode (expecting J, B, D, R)";
 		r = -EINVAL;
 		goto bad;
 	}
@@ -3173,7 +3558,6 @@ static int dm_integrity_ctr(struct dm_ta
 	buffer_sectors = DEFAULT_BUFFER_SECTORS;
 	journal_watermark = DEFAULT_JOURNAL_WATERMARK;
 	sync_msec = DEFAULT_SYNC_MSEC;
-	recalculate = false;
 	ic->sectors_per_block = 1;
 
 	as.argc = argc - DIRECT_ARGUMENTS;
@@ -3185,6 +3569,7 @@ static int dm_integrity_ctr(struct dm_ta
 	while (extra_args--) {
 		const char *opt_string;
 		unsigned val;
+		unsigned long long llval;
 		opt_string = dm_shift_arg(&as);
 		if (!opt_string) {
 			r = -EINVAL;
@@ -3220,6 +3605,14 @@ static int dm_integrity_ctr(struct dm_ta
 				goto bad;
 			}
 			ic->sectors_per_block = val >> SECTOR_SHIFT;
+		} else if (sscanf(opt_string, "sectors_per_bit:%llu%c", &llval, &dummy) == 1) {
+			log2_sectors_per_bitmap_bit = !llval ? 0 : __ilog2_u64(llval);
+		} else if (sscanf(opt_string, "bitmap_flush_interval:%u%c", &val, &dummy) == 1) {
+			if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {
+				r = -EINVAL;
+				ti->error = "Invalid bitmap_flush_interval argument";
+			}
+			ic->bitmap_flush_interval = msecs_to_jiffies(val);
 		} else if (!strncmp(opt_string, "internal_hash:", strlen("internal_hash:"))) {
 			r = get_alg_and_key(opt_string, &ic->internal_hash_alg, &ti->error,
 					    "Invalid internal_hash argument");
@@ -3236,7 +3629,7 @@ static int dm_integrity_ctr(struct dm_ta
 			if (r)
 				goto bad;
 		} else if (!strcmp(opt_string, "recalculate")) {
-			recalculate = true;
+			ic->recalculate_flag = true;
 		} else {
 			r = -EINVAL;
 			ti->error = "Invalid argument";
@@ -3287,6 +3680,12 @@ static int dm_integrity_ctr(struct dm_ta
 	else
 		ic->log2_tag_size = -1;
 
+	if (ic->mode == 'B' && !ic->internal_hash) {
+		r = -EINVAL;
+		ti->error = "Bitmap mode can be only used with internal hash";
+		goto bad;
+	}
+
 	ic->autocommit_jiffies = msecs_to_jiffies(sync_msec);
 	ic->autocommit_msec = sync_msec;
 	timer_setup(&ic->autocommit_timer, autocommit_fn, 0);
@@ -3332,7 +3731,7 @@ static int dm_integrity_ctr(struct dm_ta
 	}
 	INIT_WORK(&ic->commit_work, integrity_commit);
 
-	if (ic->mode == 'J') {
+	if (ic->mode == 'J' || ic->mode == 'B') {
 		ic->writer_wq = alloc_workqueue("dm-integrity-writer", WQ_MEM_RECLAIM, 1);
 		if (!ic->writer_wq) {
 			ti->error = "Cannot allocate workqueue";
@@ -3373,7 +3772,7 @@ static int dm_integrity_ctr(struct dm_ta
 			should_write_sb = true;
 	}
 
-	if (!ic->sb->version || ic->sb->version > SB_VERSION_2) {
+	if (!ic->sb->version || ic->sb->version > SB_VERSION_3) {
 		r = -EINVAL;
 		ti->error = "Unknown version";
 		goto bad;
@@ -3433,6 +3832,27 @@ try_smaller_buffer:
 		ti->error = "The device is too small";
 		goto bad;
 	}
+
+	if (log2_sectors_per_bitmap_bit < 0)
+		log2_sectors_per_bitmap_bit = __fls(DEFAULT_SECTORS_PER_BITMAP_BIT);
+	if (log2_sectors_per_bitmap_bit < ic->sb->log2_sectors_per_block)
+		log2_sectors_per_bitmap_bit = ic->sb->log2_sectors_per_block;
+
+	bits_in_journal = ((__u64)ic->journal_section_sectors * ic->journal_sections) << (SECTOR_SHIFT + 3);
+	if (bits_in_journal > UINT_MAX)
+		bits_in_journal = UINT_MAX;
+	while (bits_in_journal < (ic->provided_data_sectors + ((sector_t)1 << log2_sectors_per_bitmap_bit) - 1) >> log2_sectors_per_bitmap_bit)
+		log2_sectors_per_bitmap_bit++;
+
+	log2_blocks_per_bitmap_bit = log2_sectors_per_bitmap_bit - ic->sb->log2_sectors_per_block;
+	ic->log2_blocks_per_bitmap_bit = log2_blocks_per_bitmap_bit;
+	if (should_write_sb) {
+		ic->sb->log2_blocks_per_bitmap_bit = log2_blocks_per_bitmap_bit;
+	}
+	n_bitmap_bits = ((ic->provided_data_sectors >> ic->sb->log2_sectors_per_block)
+				+ (((sector_t)1 << log2_blocks_per_bitmap_bit) - 1)) >> log2_blocks_per_bitmap_bit;
+	ic->n_bitmap_blocks = DIV_ROUND_UP(n_bitmap_bits, BITMAP_BLOCK_SIZE * 8);
+
 	if (!ic->meta_dev)
 		ic->log2_buffer_sectors = min(ic->log2_buffer_sectors, (__u8)__ffs(ic->metadata_run));
 
@@ -3457,25 +3877,21 @@ try_smaller_buffer:
 	DEBUG_print("	journal_sections %u\n", (unsigned)le32_to_cpu(ic->sb->journal_sections));
 	DEBUG_print("	journal_entries %u\n", ic->journal_entries);
 	DEBUG_print("	log2_interleave_sectors %d\n", ic->sb->log2_interleave_sectors);
-	DEBUG_print("	device_sectors 0x%llx\n", (unsigned long long)ic->device_sectors);
+	DEBUG_print("	device_sectors 0x%llx\n", i_size_read(ic->dev->bdev->bd_inode) >> SECTOR_SHIFT);
 	DEBUG_print("	initial_sectors 0x%x\n", ic->initial_sectors);
 	DEBUG_print("	metadata_run 0x%x\n", ic->metadata_run);
 	DEBUG_print("	log2_metadata_run %d\n", ic->log2_metadata_run);
 	DEBUG_print("	provided_data_sectors 0x%llx (%llu)\n", (unsigned long long)ic->provided_data_sectors,
 		    (unsigned long long)ic->provided_data_sectors);
 	DEBUG_print("	log2_buffer_sectors %u\n", ic->log2_buffer_sectors);
+	DEBUG_print("	bits_in_journal %llu\n", (unsigned long long)bits_in_journal);
 
-	if (recalculate && !(ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))) {
+	if (ic->recalculate_flag && !(ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))) {
 		ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
 		ic->sb->recalc_sector = cpu_to_le64(0);
 	}
 
-	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
-		if (!ic->internal_hash) {
-			r = -EINVAL;
-			ti->error = "Recalculate is only valid with internal hash";
-			goto bad;
-		}
+	if (ic->internal_hash) {
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq ) {
 			ti->error = "Cannot allocate workqueue";
@@ -3512,6 +3928,45 @@ try_smaller_buffer:
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
+
+	}
+
+	if (ic->mode == 'B') {
+		unsigned i;
+		unsigned n_bitmap_pages = DIV_ROUND_UP(ic->n_bitmap_blocks, PAGE_SIZE / BITMAP_BLOCK_SIZE);
+
+		ic->recalc_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
+		if (!ic->recalc_bitmap) {
+			r = -ENOMEM;
+			goto bad;
+		}
+		ic->may_write_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
+		if (!ic->may_write_bitmap) {
+			r = -ENOMEM;
+			goto bad;
+		}
+		ic->bbs = kvmalloc_array(ic->n_bitmap_blocks, sizeof(struct bitmap_block_status), GFP_KERNEL);
+		if (!ic->bbs) {
+			r = -ENOMEM;
+			goto bad;
+		}
+		INIT_DELAYED_WORK(&ic->bitmap_flush_work, bitmap_flush_work);
+		for (i = 0; i < ic->n_bitmap_blocks; i++) {
+			struct bitmap_block_status *bbs = &ic->bbs[i];
+			unsigned sector, pl_index, pl_offset;
+
+			INIT_WORK(&bbs->work, bitmap_block_work);
+			bbs->ic = ic;
+			bbs->idx = i;
+			bio_list_init(&bbs->bio_queue);
+			spin_lock_init(&bbs->bio_queue_lock);
+
+			sector = i * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT);
+			pl_index = sector >> (PAGE_SHIFT - SECTOR_SHIFT);
+			pl_offset = (sector << SECTOR_SHIFT) & (PAGE_SIZE - 1);
+
+			bbs->bitmap = lowmem_page_address(ic->journal[pl_index].page) + pl_offset;
+		}
 	}
 
 	if (should_write_sb) {
@@ -3536,6 +3991,17 @@ try_smaller_buffer:
 		if (r)
 			goto bad;
 	}
+	if (ic->mode == 'B') {
+		unsigned max_io_len = ((sector_t)ic->sectors_per_block << ic->log2_blocks_per_bitmap_bit) * (BITMAP_BLOCK_SIZE * 8);
+		if (!max_io_len)
+			max_io_len = 1U << 31;
+		DEBUG_print("max_io_len: old %u, new %u\n", ti->max_io_len, max_io_len);
+		if (!ti->max_io_len || ti->max_io_len > max_io_len) {
+			r = dm_set_target_max_io_len(ti, max_io_len);
+			if (r)
+				goto bad;
+		}
+	}
 
 	if (!ic->internal_hash)
 		dm_integrity_set(ti, ic);
@@ -3544,6 +4010,7 @@ try_smaller_buffer:
 	ti->flush_supported = true;
 
 	return 0;
+
 bad:
 	dm_integrity_dtr(ti);
 	return r;
@@ -3568,6 +4035,7 @@ static void dm_integrity_dtr(struct dm_t
 		destroy_workqueue(ic->recalc_wq);
 	vfree(ic->recalc_buffer);
 	kvfree(ic->recalc_tags);
+	kvfree(ic->bbs);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
 	mempool_exit(&ic->journal_io_mempool);
@@ -3580,6 +4048,8 @@ static void dm_integrity_dtr(struct dm_t
 	dm_integrity_free_page_list(ic->journal);
 	dm_integrity_free_page_list(ic->journal_io);
 	dm_integrity_free_page_list(ic->journal_xor);
+	dm_integrity_free_page_list(ic->recalc_bitmap);
+	dm_integrity_free_page_list(ic->may_write_bitmap);
 	if (ic->journal_scatterlist)
 		dm_integrity_free_journal_scatterlist(ic, ic->journal_scatterlist);
 	if (ic->journal_io_scatterlist)
@@ -3617,7 +4087,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 2, 0},
+	.version		= {1, 3, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,
Index: linux-2.6/Documentation/device-mapper/dm-integrity.txt
===================================================================
--- linux-2.6.orig/Documentation/device-mapper/dm-integrity.txt	2019-04-27 10:28:49.000000000 +0200
+++ linux-2.6/Documentation/device-mapper/dm-integrity.txt	2019-04-27 10:28:49.000000000 +0200
@@ -21,6 +21,14 @@ mode it calculates and verifies the inte
 mode, the dm-integrity target can be used to detect silent data
 corruption on the disk or in the I/O path.
 
+There's an alternative mode of operation whete dm-integrity uses bitmap
+instead of a journal. If a bit in the bitmap is 1, the corresponding
+region's data and integrity tags are not synchronized - if the machine
+crashes, the unsynchronized regions will be recalculated. The bitmap mode
+is faster than the journal mode, because we don't have to write the data
+twice, but it is also less reliable, because if data corruption happens
+when the machine crashes, it may not be detected.
+
 
 When loading the target for the first time, the kernel driver will format
 the device. But it will only format the device if the superblock contains
@@ -59,6 +67,10 @@ Target arguments:
 		either both data and tag or none of them are written. The
 		journaled mode degrades write throughput twice because the
 		data have to be written twice.
+	B - bitmap mode - data and metadata are written without any
+		synchronization, the driver maintains a bitmap of dirty
+		regions where data and metadata don't match. This mode can
+		only be used with internal hash.
 	R - recovery mode - in this mode, journal is not replayed,
 		checksums are not checked and writes to the device are not
 		allowed. This mode is useful for data recovery if the
@@ -150,6 +162,15 @@ block_size:number
 	Supported values are 512, 1024, 2048 and 4096 bytes.  If not
 	specified the default block size is 512 bytes.
 
+sectors_per_bit:number
+	In the bitmap mode, this parameter specifies the number of
+	512-byte sectors that corresponds to one bitmap bit.
+
+bitmap_flush_interval:number
+	The bitmap flush interval in milliseconds. The metadata buffers
+	are synchronized when this interval expires.
+
+
 The journal mode (D/J), buffer_sectors, journal_watermark, commit_time can
 be changed when reloading the target (load an inactive table and swap the
 tables with suspend and resume). The other arguments should not be changed
@@ -174,6 +195,8 @@ The layout of the formatted block device
 	* flags
 	  SB_FLAG_HAVE_JOURNAL_MAC - a flag is set if journal_mac is used
 	  SB_FLAG_RECALCULATING - recalculating is in progress
+	  SB_FLAG_DIRTY_BITMAP - journal area contains the bitmap of dirty
+		blocks
 	* log2(sectors per block)
 	* a position where recalculating finished
 * journal
