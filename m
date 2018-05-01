From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 8/8] dm-integrity: recalculate checksums
Date: Tue, 01 May 2018 15:55:24 +0200
Message-ID: <20180501135608.051122228@debian.vm>
References: <20180501135516.961417937@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-recalc.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When using external metadata device and internal hash, recalculate the
checksums when the device is created - so that dm-integrity doesn't have
to overwrite the device. The superblock stores the last position when the
recalculation ended, so that it is properly restarted.

Integrity tags that haven't been recalculated yet are ignored.

This patch also increases the target version to 1.2.0.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |  163 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 161 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-05-01 04:35:29.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-05-01 15:45:41.000000000 +0200
@@ -31,6 +31,8 @@
 #define MIN_LOG2_INTERLEAVE_SECTORS	3
 #define MAX_LOG2_INTERLEAVE_SECTORS	31
 #define METADATA_WORKQUEUE_MAX_ACTIVE	16
+#define RECALC_SECTORS			8192
+#define RECALC_WRITE_SUPER		16
 
 /*
  * Warning - DEBUG_PRINT prints security-sensitive data to the log,
@@ -58,9 +60,12 @@ struct superblock {
 	__u64 provided_data_sectors;	/* userspace uses this value */
 	__u32 flags;
 	__u8 log2_sectors_per_block;
+	__u8 pad[3];
+	__u64 recalc_sector;
 };
 
 #define SB_FLAG_HAVE_JOURNAL_MAC	0x1
+#define SB_FLAG_RECALCULATING		0x2
 
 #define	JOURNAL_ENTRY_ROUNDUP		8
 
@@ -213,6 +218,11 @@ struct dm_integrity_c {
 	struct workqueue_struct *writer_wq;
 	struct work_struct writer_work;
 
+	struct workqueue_struct *recalc_wq;
+	struct work_struct recalc_work;
+	u8 *recalc_buffer;
+	u8 *recalc_tags;
+
 	struct bio_list flush_bio_list;
 
 	unsigned long autocommit_jiffies;
@@ -409,7 +419,7 @@ static void wraparound_section(struct dm
 
 static void sb_set_version(struct dm_integrity_c *ic)
 {
-	if (ic->meta_dev)
+	if (ic->meta_dev || ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
 		ic->sb->version = SB_VERSION_2;
 	else
 		ic->sb->version = SB_VERSION_1;
@@ -1725,9 +1735,14 @@ sleep:
 
 	if (need_sync_io) {
 		wait_for_completion_io(&read_comp);
+		if (unlikely(ic->recalc_wq != NULL) &&
+		    ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
+		    dio->range.logical_sector + dio->range.n_sectors > le64_to_cpu(ic->sb->recalc_sector))
+			goto skip_check;
 		if (likely(!bio->bi_status))
 			integrity_metadata(&dio->work);
 		else
+skip_check:
 			dec_in_flight(dio);
 
 	} else {
@@ -2027,6 +2042,110 @@ static void integrity_writer(struct work
 	spin_unlock_irq(&ic->endio_wait.lock);
 }
 
+static void recalc_write_super(struct dm_integrity_c *ic)
+{
+	int r;
+
+	dm_integrity_flush_buffers(ic);
+	if (dm_integrity_failed(ic))
+		return;
+
+	sb_set_version(ic);
+	r = sync_rw_sb(ic, REQ_OP_WRITE, 0);
+	if (unlikely(r))
+		dm_integrity_io_error(ic, "writing superblock", r);
+}
+
+static void integrity_recalc(struct work_struct *w)
+{
+	struct dm_integrity_c *ic = container_of(w, struct dm_integrity_c, recalc_work);
+	struct dm_integrity_range range;
+	struct dm_io_request io_req;
+	struct dm_io_region io_loc;
+	sector_t area, offset;
+	sector_t metadata_block;
+	unsigned metadata_offset;
+	__u8 *t;
+	unsigned i;
+	int r;
+	unsigned super_counter = 0;
+
+	spin_lock_irq(&ic->endio_wait.lock);
+
+next_chunk:
+
+	if (unlikely(READ_ONCE(ic->suspending)))
+		goto unlock_ret;
+
+	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
+	if (unlikely(range.logical_sector >= ic->provided_data_sectors)) {
+		ic->sb->flags &= ~cpu_to_le32(SB_FLAG_RECALCULATING);
+		ic->sb->recalc_sector = cpu_to_le64(0);
+		goto unlock_ret;
+	}
+	get_area_and_offset(ic, range.logical_sector, &area, &offset);
+	range.n_sectors = min((sector_t)RECALC_SECTORS, ic->provided_data_sectors - range.logical_sector);
+	if (!ic->meta_dev)
+		range.n_sectors = min(range.n_sectors, (1U << ic->sb->log2_interleave_sectors) - (unsigned)offset);
+
+	while (unlikely(!add_new_range(ic, &range)))
+		sleep_on_endio_wait(ic);
+
+	spin_unlock_irq(&ic->endio_wait.lock);
+
+	if (unlikely(++super_counter == RECALC_WRITE_SUPER)) {
+		recalc_write_super(ic);
+		super_counter = 0;
+	}
+
+	if (unlikely(dm_integrity_failed(ic)))
+		goto err;
+
+	io_req.bi_op = REQ_OP_READ;
+	io_req.bi_op_flags = 0;
+	io_req.mem.type = DM_IO_VMA;
+	io_req.mem.ptr.addr = ic->recalc_buffer;
+	io_req.notify.fn = NULL;
+	io_req.client = ic->io;
+	io_loc.bdev = ic->dev->bdev;
+	io_loc.sector = get_data_sector(ic, area, offset);
+	io_loc.count = range.n_sectors;
+
+	r = dm_io(&io_req, 1, &io_loc, NULL);
+	if (unlikely(r)) {
+		dm_integrity_io_error(ic, "reading data", r);
+		goto err;
+	}
+
+	t = ic->recalc_tags;
+	for (i = 0; i < range.n_sectors; i += ic->sectors_per_block) {
+		integrity_sector_checksum(ic, range.logical_sector + i, ic->recalc_buffer + (i << SECTOR_SHIFT), t);
+		t += ic->tag_size;
+	}
+
+	metadata_block = get_metadata_sector_and_offset(ic, area, offset, &metadata_offset);
+
+	r = dm_integrity_rw_tag(ic, ic->recalc_tags, &metadata_block, &metadata_offset, t - ic->recalc_tags, TAG_WRITE);
+	if (unlikely(r)) {
+		dm_integrity_io_error(ic, "writing tags", r);
+		goto err;
+	}
+
+	spin_lock_irq(&ic->endio_wait.lock);
+	remove_range_unlocked(ic, &range);
+	ic->sb->recalc_sector = cpu_to_le64(range.logical_sector + range.n_sectors);
+	goto next_chunk;
+
+err:
+	remove_range(ic, &range);
+	return;
+
+unlock_ret:
+	spin_unlock_irq(&ic->endio_wait.lock);
+
+	recalc_write_super(ic);
+}
+
 static void init_journal(struct dm_integrity_c *ic, unsigned start_section,
 			 unsigned n_sections, unsigned char commit_seq)
 {
@@ -2231,6 +2350,9 @@ static void dm_integrity_postsuspend(str
 
 	WRITE_ONCE(ic->suspending, 1);
 
+	if (ic->recalc_wq)
+		drain_workqueue(ic->recalc_wq);
+
 	queue_work(ic->commit_wq, &ic->commit_work);
 	drain_workqueue(ic->commit_wq);
 
@@ -2253,6 +2375,9 @@ static void dm_integrity_resume(struct d
 	struct dm_integrity_c *ic = (struct dm_integrity_c *)ti->private;
 
 	replay_journal(ic);
+
+	if (ic->recalc_wq && ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
+		queue_work(ic->recalc_wq, &ic->recalc_work);
 }
 
 static void dm_integrity_status(struct dm_target *ti, status_type_t type,
@@ -2420,6 +2545,11 @@ static int initialize_superblock(struct
 		if (!ic->provided_data_sectors)
 			return -EINVAL;
 	} else {
+		if (ic->internal_hash) {
+			ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
+			ic->sb->recalc_sector = cpu_to_le64(0);
+		}
+
 		ic->sb->log2_interleave_sectors = 0;
 		ic->provided_data_sectors = ic->data_device_sectors;
 		ic->provided_data_sectors &= ~(sector_t)(ic->sectors_per_block - 1);
@@ -3237,6 +3367,29 @@ try_smaller_buffer:
 		    (unsigned long long)ic->provided_data_sectors);
 	DEBUG_print("	log2_buffer_sectors %u\n", ic->log2_buffer_sectors);
 
+
+	if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)) {
+		ic->recalc_wq = alloc_workqueue("dm-intergrity-recalc", WQ_MEM_RECLAIM, 1);
+		if (!ic->recalc_wq ) {
+			ti->error = "Cannot allocate workqueue";
+			r = -ENOMEM;
+			goto bad;
+		}
+		INIT_WORK(&ic->recalc_work, integrity_recalc);
+		ic->recalc_buffer = vmalloc(RECALC_SECTORS << SECTOR_SHIFT);
+		if (!ic->recalc_buffer) {
+			ti->error = "Cannot allocate buffer for recalculating";
+			r = -ENOMEM;
+			goto bad;
+		}
+		ic->recalc_tags = kvmalloc((RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size, GFP_KERNEL);
+		if (!ic->recalc_tags) {
+			ti->error = "Cannot allocate tags for recalculating";
+			r = -ENOMEM;
+			goto bad;
+		}
+	}
+
 	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
 			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL);
 	if (IS_ERR(ic->bufio)) {
@@ -3302,6 +3455,12 @@ static void dm_integrity_dtr(struct dm_t
 		destroy_workqueue(ic->commit_wq);
 	if (ic->writer_wq)
 		destroy_workqueue(ic->writer_wq);
+	if (ic->recalc_wq)
+		destroy_workqueue(ic->recalc_wq);
+	if (ic->recalc_buffer)
+		vfree(ic->recalc_buffer);
+	if (ic->recalc_tags)
+		kvfree(ic->recalc_tags);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
 	mempool_destroy(ic->journal_io_mempool);
@@ -3351,7 +3510,7 @@ static void dm_integrity_dtr(struct dm_t
 
 static struct target_type integrity_target = {
 	.name			= "integrity",
-	.version		= {1, 1, 0},
+	.version		= {1, 2, 0},
 	.module			= THIS_MODULE,
 	.features		= DM_TARGET_SINGLETON | DM_TARGET_INTEGRITY,
 	.ctr			= dm_integrity_ctr,
