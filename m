From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 2/2] dm thin: Flush data device before committing
	metadata
Date: Wed,  4 Dec 2019 16:07:42 +0200
Message-ID: <20191204140742.26273-3-ntsironis@arrikto.com>
References: <20191204140742.26273-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191204140742.26273-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: thornber@redhat.com, ntsironis@arrikto.com
List-Id: dm-devel.ids

The thin provisioning target maintains per thin device mappings that map
virtual blocks to data blocks in the data device.

When we write to a shared block, in case of internal snapshots, or
provision a new block, in case of external snapshots, we copy the shared
block to a new data block (COW), update the mapping for the relevant
virtual block and then issue the write to the new data block.

Suppose the data device has a volatile write-back cache and the
following sequence of events occur:

1. We write to a shared block
2. A new data block is allocated
3. We copy the shared block to the new data block using kcopyd (COW)
4. We insert the new mapping for the virtual block in the btree for that
   thin device.
5. The commit timeout expires and we commit the metadata, that now
   includes the new mapping from step (4).
6. The system crashes and the data device's cache has not been flushed,
   meaning that the COWed data are lost.

The next time we read that virtual block of the thin device we read it
from the data block allocated in step (2), since the metadata have been
successfully committed. The data are lost due to the crash, so we read
garbage instead of the old, shared data.

This has the following implications:

1. In case of writes to shared blocks, with size smaller than the pool's
   block size (which means we first copy the whole block and then issue
   the smaller write), we corrupt data that the user never touched.

2. In case of writes to shared blocks, with size equal to the device's
   logical block size, we fail to provide atomic sector writes. When the
   system recovers the user will read garbage from that sector instead
   of the old data or the new data.

3. Even for writes to shared blocks, with size equal to the pool's block
   size (overwrites), after the system recovers, the written sectors
   will contain garbage instead of a random mix of sectors containing
   either old data or new data, thus we fail again to provide atomic
   sectors writes.

4. Even when the user flushes the thin device, because we first commit
   the metadata and then pass down the flush, the same risk for
   corruption exists (if the system crashes after the metadata have been
   committed but before the flush is passed down to the data device.)

The only case which is unaffected is that of writes with size equal to
the pool's block size and with the FUA flag set. But, because FUA writes
trigger metadata commits, this case can trigger the corruption
indirectly.

Moreover, apart from internal and external snapshots, the same issue
exists for newly provisioned blocks, when block zeroing is enabled.
After the system recovers the provisioned blocks might contain garbage
instead of zeroes.

To solve this and avoid the potential data corruption we flush the
pool's data device **before** committing its metadata.

This ensures that the data blocks of any newly inserted mappings are
properly written to non-volatile storage and won't be lost in case of a
crash.

Cc: stable@vger.kernel.org
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-thin.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 5a2c494cb552..e0be545080d0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3180,6 +3180,34 @@ static void metadata_low_callback(void *context)
 	dm_table_event(pool->ti->table);
 }
 
+/*
+ * We need to flush the data device **before** committing the metadata.
+ *
+ * This ensures that the data blocks of any newly inserted mappings are
+ * properly written to non-volatile storage and won't be lost in case of a
+ * crash.
+ *
+ * Failure to do so can result in data corruption in the case of internal or
+ * external snapshots and in the case of newly provisioned blocks, when block
+ * zeroing is enabled.
+ */
+static int metadata_pre_commit_callback(void *context)
+{
+	struct pool_c *pt = context;
+	struct bio bio;
+	int r;
+
+	bio_init(&bio, NULL, 0);
+	bio_set_dev(&bio, pt->data_dev->bdev);
+	bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
+
+	r = submit_bio_wait(&bio);
+
+	bio_uninit(&bio);
+
+	return r;
+}
+
 static sector_t get_dev_size(struct block_device *bdev)
 {
 	return i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
@@ -3374,6 +3402,10 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (r)
 		goto out_flags_changed;
 
+	dm_pool_register_pre_commit_callback(pt->pool->pmd,
+					     metadata_pre_commit_callback,
+					     pt);
+
 	pt->callbacks.congested_fn = pool_is_congested;
 	dm_table_add_target_callbacks(ti->table, &pt->callbacks);
 
-- 
2.11.0
