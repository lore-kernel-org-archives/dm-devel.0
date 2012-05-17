From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH] [dm-thin] Allow userland access to metadata of a
	live thin provisioning pool
Date: Thu, 17 May 2012 15:47:22 +0100
Message-ID: <1337266042-2875-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

New feature.

This patch implements two new messages that can be sent to the thin
pool target allowing it to take a snapshot of the _metadata_.  This,
read-only snapshot can be accessed by userland, concurrently with the
live target.

Only one metadata snapshot can be held at a time.  The pool's status
line will give the block location for the current msnap.

The thin-provisioning-tools have been updated to v0.1.5.  The
thin_dump program can now be used to display the msnap.  eg,

    thin_dump -m <msnap root> <metadata dev>

Available here: https://github.com/jthornber/thin-provisioning-tools

Now that userland can access the metadata we can do various things
that have traditionally been kernel side tasks:

     i) Incremental backups.

     By using metadata snapshots we can work out what blocks have
     changed over time.  Combined with data snapshots we can ensure
     the data doesn't change while we back it up.

     A short proof of concept script can be found here:

     https://github.com/jthornber/thinp-test-suite/blob/master/incremental_backup_example.rb

     ii) Migration of thin devices from one pool to another.

     iii) Merging snapshots back into an external origin.

     iv) Asyncronous replication.
---
 Documentation/device-mapper/thin-provisioning.txt |   11 ++
 drivers/md/dm-thin-metadata.c                     |  128 ++++++++++++++++++++-
 drivers/md/dm-thin-metadata.h                     |   13 ++-
 drivers/md/dm-thin.c                              |   40 ++++++-
 4 files changed, 182 insertions(+), 10 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 3370bc4..897e66d 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -287,6 +287,17 @@ iii) Messages
 	the current transaction id is when you change it with this
 	compare-and-swap message.
 
+    reserve_metadata_snap
+
+        Reserve a copy of the data mapping btree for use by userland.
+        This allows userland to inspect the mappings as they were when
+        this message was executed.  Use the pool's status command to
+        get the root block.
+
+    release_metadata_snap
+
+        Release a previously reserved copy of the data mapping btree.
+
 'thin' target
 -------------
 
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 737d388..7e272e2 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1082,12 +1082,82 @@ int dm_pool_get_metadata_transaction_id(struct dm_pool_metadata *pmd,
 	return 0;
 }
 
-static int __get_held_metadata_root(struct dm_pool_metadata *pmd,
-				    dm_block_t *result)
+static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
+{
+	int r, inc;
+	struct thin_disk_superblock *disk_super;
+	struct dm_block *copy, *sblock;
+	dm_block_t held_root;
+
+	/*
+	 * Copy the superblock.
+	 */
+	dm_sm_inc_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
+	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION, &sb_validator, &copy, &inc);
+	if (r)
+		return r;
+	BUG_ON(!inc);
+
+	held_root = dm_block_location(copy);
+	disk_super = dm_block_data(copy);
+	if (le64_to_cpu(disk_super->held_root)) {
+		DMWARN("pool already has a metadata snapshot");
+		dm_tm_dec(pmd->tm, held_root);
+		dm_tm_unlock(pmd->tm, copy);
+		pmd->need_commit = 1;
+		return -EBUSY;
+	}
+
+	/*
+	 * Wipe the spacemap since we're not publishing this.
+	 */
+	memset(&disk_super->data_space_map_root, 0, sizeof(disk_super->data_space_map_root));
+	memset(&disk_super->metadata_space_map_root, 0,
+	       sizeof(disk_super->metadata_space_map_root));
+
+	/*
+	 * Increment the data structures that need to be preserved.
+	 */
+	dm_tm_inc(pmd->tm, le64_to_cpu(disk_super->data_mapping_root));
+	dm_tm_inc(pmd->tm, le64_to_cpu(disk_super->device_details_root));
+	dm_tm_unlock(pmd->tm, copy);
+
+	/*
+	 * Write the held root into the superblock.
+	 */
+	r = dm_bm_write_lock(pmd->bm, THIN_SUPERBLOCK_LOCATION,
+			     &sb_validator, &sblock);
+	if (r) {
+		dm_tm_dec(pmd->tm, held_root);
+		pmd->need_commit = 1;
+		return r;
+	}
+
+	disk_super = dm_block_data(sblock);
+	disk_super->held_root = cpu_to_le64(held_root);
+	dm_tm_unlock(pmd->tm, sblock);
+
+	pmd->need_commit = 1;
+	return 0;
+}
+
+int dm_pool_reserve_metadata_snap(struct dm_pool_metadata *pmd)
+{
+	int r;
+
+	down_write(&pmd->root_lock);
+	r = __reserve_metadata_snap(pmd);
+	up_write(&pmd->root_lock);
+
+	return r;
+}
+
+static int __release_metadata_snap(struct dm_pool_metadata *pmd)
 {
 	int r;
 	struct thin_disk_superblock *disk_super;
-	struct dm_block *sblock;
+	struct dm_block *sblock, *copy;
+	dm_block_t held_root;
 
 	r = dm_bm_write_lock(pmd->bm, THIN_SUPERBLOCK_LOCATION,
 			     &sb_validator, &sblock);
@@ -1095,18 +1165,64 @@ static int __get_held_metadata_root(struct dm_pool_metadata *pmd,
 		return r;
 
 	disk_super = dm_block_data(sblock);
+	held_root = le64_to_cpu(disk_super->held_root);
+	disk_super->held_root = cpu_to_le64(0);
+	pmd->need_commit = 1;
+
+	dm_tm_unlock(pmd->tm, sblock);
+
+	if (!held_root) {
+		DMWARN("pool has no metadata snap");
+		return -EINVAL;
+	}
+
+	r = dm_tm_read_lock(pmd->tm, held_root, &sb_validator, &copy);
+	if (r)
+		return r;
+
+	disk_super = dm_block_data(copy);
+	dm_sm_dec_block(pmd->metadata_sm, le64_to_cpu(disk_super->data_mapping_root));
+	dm_sm_dec_block(pmd->metadata_sm, le64_to_cpu(disk_super->device_details_root));
+	dm_sm_dec_block(pmd->metadata_sm, held_root);
+	return dm_tm_unlock(pmd->tm, copy);
+}
+
+int dm_pool_release_metadata_snap(struct dm_pool_metadata *pmd)
+{
+	int r;
+
+	down_write(&pmd->root_lock);
+	r = __release_metadata_snap(pmd);
+	up_write(&pmd->root_lock);
+
+	return r;
+}
+
+static int __get_metadata_snap(struct dm_pool_metadata *pmd,
+			       dm_block_t *result)
+{
+	int r;
+	struct thin_disk_superblock *disk_super;
+	struct dm_block *sblock;
+
+	r = dm_bm_read_lock(pmd->bm, THIN_SUPERBLOCK_LOCATION,
+			    &sb_validator, &sblock);
+	if (r)
+		return r;
+
+	disk_super = dm_block_data(sblock);
 	*result = le64_to_cpu(disk_super->held_root);
 
 	return dm_bm_unlock(sblock);
 }
 
-int dm_pool_get_held_metadata_root(struct dm_pool_metadata *pmd,
-				   dm_block_t *result)
+int dm_pool_get_metadata_snap(struct dm_pool_metadata *pmd,
+			      dm_block_t *result)
 {
 	int r;
 
 	down_read(&pmd->root_lock);
-	r = __get_held_metadata_root(pmd, result);
+	r = __get_metadata_snap(pmd, result);
 	up_read(&pmd->root_lock);
 
 	return r;
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index ed4725e..b88918c 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -90,11 +90,18 @@ int dm_pool_get_metadata_transaction_id(struct dm_pool_metadata *pmd,
 
 /*
  * Hold/get root for userspace transaction.
+ *
+ * The metadata snapshot is a copy of the current superblock (minus the
+ * space maps).  Userland can access the data structures for READ
+ * operations only.  A small performance hit is incurred by providing this
+ * copy of the metadata to userland due to extra copy-on-write operations
+ * on the metadata nodes.  Release this as soon as you finish with it.
  */
-int dm_pool_hold_metadata_root(struct dm_pool_metadata *pmd);
+int dm_pool_reserve_metadata_snap(struct dm_pool_metadata *pmd);
+int dm_pool_release_metadata_snap(struct dm_pool_metadata *pmd);
 
-int dm_pool_get_held_metadata_root(struct dm_pool_metadata *pmd,
-				   dm_block_t *result);
+int dm_pool_get_metadata_snap(struct dm_pool_metadata *pmd,
+			      dm_block_t *result);
 
 /*
  * Actions on a single virtual device.
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2fd87b5..1645529 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2274,6 +2274,36 @@ static int process_set_transaction_id_mesg(unsigned argc, char **argv, struct po
 	return 0;
 }
 
+static int process_reserve_metadata_snap_mesg(unsigned argc, char **argv, struct pool *pool)
+{
+	int r;
+
+	r = check_arg_count(argc, 1);
+	if (r)
+		return r;
+
+	r = dm_pool_reserve_metadata_snap(pool->pmd);
+	if (r)
+		DMWARN("metadata snap request failed");
+
+	return r;
+}
+
+static int process_release_metadata_snap_mesg(unsigned argc, char **argv, struct pool *pool)
+{
+	int r;
+
+	r = check_arg_count(argc, 1);
+	if (r)
+		return r;
+
+	r = dm_pool_release_metadata_snap(pool->pmd);
+	if (r)
+		DMWARN("release metadata snap request failed");
+
+	return r;
+}
+
 /*
  * Messages supported:
  *   create_thin	<dev_id>
@@ -2281,6 +2311,8 @@ static int process_set_transaction_id_mesg(unsigned argc, char **argv, struct po
  *   delete		<dev_id>
  *   trim		<dev_id> <new_size_in_sectors>
  *   set_transaction_id <current_trans_id> <new_trans_id>
+ *   reserve_metadata_snap
+ *   release_metadata_snap
  */
 static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
 {
@@ -2300,6 +2332,12 @@ static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
 	else if (!strcasecmp(argv[0], "set_transaction_id"))
 		r = process_set_transaction_id_mesg(argc, argv, pool);
 
+	else if (!strcasecmp(argv[0], "reserve_metadata_snap"))
+		r = process_reserve_metadata_snap_mesg(argc, argv, pool);
+
+	else if (!strcasecmp(argv[0], "release_metadata_snap"))
+		r = process_release_metadata_snap_mesg(argc, argv, pool);
+
 	else
 		DMWARN("Unrecognised thin pool target message received: %s", argv[0]);
 
@@ -2359,7 +2397,7 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 		if (r)
 			return r;
 
-		r = dm_pool_get_held_metadata_root(pool->pmd, &held_root);
+		r = dm_pool_get_metadata_snap(pool->pmd, &held_root);
 		if (r)
 			return r;
 
-- 
1.7.9.5
