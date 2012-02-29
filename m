From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 09/13] dm thin: held root support
Date: Wed, 29 Feb 2012 09:50:13 -0500
Message-ID: <1330527017-28618-10-git-send-email-snitzer@redhat.com>
References: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

This allows userland access to the thinp data mappings.

Signed-off-by: Joe Thornber <ejt@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt |   11 +++
 drivers/md/dm-thin-metadata.c                     |   78 ++++++++++++++++++++-
 drivers/md/dm-thin-metadata.h                     |    1 +
 drivers/md/dm-thin.c                              |   38 ++++++++++
 4 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 60fc5cf..13e42fb 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -289,6 +289,17 @@ iii) Messages
 	the current transaction id is when you change it with this
 	compare-and-swap message.
 
+    hold_root
+
+        Reserve a copy of the data mapping btree for use by userland.
+        This allows userland to inspect the mappings as they were when
+        this message was executed.  Use the pool's status command to
+        get the root block.
+
+    release_root
+
+        Release a previously reserved copy of the data mapping btree.
+
 'thin' target
 -------------
 
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 0bc3033..f3ba61d 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1081,10 +1081,46 @@ int dm_pool_get_metadata_transaction_id(struct dm_pool_metadata *pmd,
 	return 0;
 }
 
-static int __get_held_metadata_root(struct dm_pool_metadata *pmd,
-				    dm_block_t *result)
+static int __hold_metadata_root(struct dm_pool_metadata *pmd)
+{
+	int r, r2;
+	struct thin_disk_superblock *disk_super;
+	struct dm_block *sblock;
+
+	r = dm_bm_write_lock(pmd->bm, THIN_SUPERBLOCK_LOCATION,
+			     &sb_validator, &sblock);
+	if (r)
+		return r;
+
+	disk_super = dm_block_data(sblock);
+	if (le64_to_cpu(disk_super->held_root)) {
+		DMWARN("pool already has a held root");
+		r = -EBUSY;
+	} else {
+		__le64 root = disk_super->data_mapping_root;
+		dm_sm_inc_block(pmd->metadata_sm, le64_to_cpu(root));
+		disk_super->held_root = root;
+		pmd->need_commit = 1;
+	}
+
+	r2 = dm_bm_unlock(sblock);
+	return r ? r : r2;
+}
+
+int dm_pool_hold_metadata_root(struct dm_pool_metadata *pmd)
 {
 	int r;
+
+	down_write(&pmd->root_lock);
+	r = __hold_metadata_root(pmd);
+	up_write(&pmd->root_lock);
+
+	return r;
+}
+
+static int __release_metadata_root(struct dm_pool_metadata *pmd)
+{
+	int r, r2;
 	struct thin_disk_superblock *disk_super;
 	struct dm_block *sblock;
 
@@ -1094,6 +1130,44 @@ static int __get_held_metadata_root(struct dm_pool_metadata *pmd,
 		return r;
 
 	disk_super = dm_block_data(sblock);
+	if (!le64_to_cpu(disk_super->held_root)) {
+		DMWARN("pool has no held root");
+		r = -EINVAL;
+	} else {
+		__le64 root = disk_super->held_root;
+		dm_sm_dec_block(pmd->metadata_sm, le64_to_cpu(root));
+		disk_super->held_root = cpu_to_le64(0ULL);
+		pmd->need_commit = 1;
+	}
+
+	r2 = dm_bm_unlock(sblock);
+	return r ? r : r2;
+}
+
+int dm_pool_release_metadata_root(struct dm_pool_metadata *pmd)
+{
+	int r;
+
+	down_write(&pmd->root_lock);
+	r = __release_metadata_root(pmd);
+	up_write(&pmd->root_lock);
+
+	return r;
+}
+
+static int __get_held_metadata_root(struct dm_pool_metadata *pmd,
+				    dm_block_t *result)
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
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 859c168..cfc7d0b 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -79,6 +79,7 @@ int dm_pool_get_metadata_transaction_id(struct dm_pool_metadata *pmd,
  * Hold/get root for userspace transaction.
  */
 int dm_pool_hold_metadata_root(struct dm_pool_metadata *pmd);
+int dm_pool_release_metadata_root(struct dm_pool_metadata *pmd);
 
 int dm_pool_get_held_metadata_root(struct dm_pool_metadata *pmd,
 				   dm_block_t *result);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c143cf1..2e7c1bc 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2107,6 +2107,36 @@ static int process_set_transaction_id_mesg(unsigned argc, char **argv, struct po
 	return 0;
 }
 
+static int process_hold_root_mesg(unsigned argc, char **argv, struct pool *pool)
+{
+	int r;
+
+	r = check_arg_count(argc, 1);
+	if (r)
+		return r;
+
+	r = dm_pool_hold_metadata_root(pool->pmd);
+	if (r)
+		DMWARN("hold root request failed");
+
+	return r;
+}
+
+static int process_release_root_mesg(unsigned argc, char **argv, struct pool *pool)
+{
+	int r;
+
+	r = check_arg_count(argc, 1);
+	if (r)
+		return r;
+
+	r = dm_pool_release_metadata_root(pool->pmd);
+	if (r)
+		DMWARN("release root request failed");
+
+	return r;
+}
+
 /*
  * Messages supported:
  *   create_thin	<dev_id>
@@ -2114,6 +2144,8 @@ static int process_set_transaction_id_mesg(unsigned argc, char **argv, struct po
  *   delete		<dev_id>
  *   trim		<dev_id> <new_size_in_sectors>
  *   set_transaction_id <current_trans_id> <new_trans_id>
+ *   hold_root
+ *   release_root
  */
 static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
 {
@@ -2133,6 +2165,12 @@ static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
 	else if (!strcasecmp(argv[0], "set_transaction_id"))
 		r = process_set_transaction_id_mesg(argc, argv, pool);
 
+	else if (!strcasecmp(argv[0], "hold_root"))
+		r = process_hold_root_mesg(argc, argv, pool);
+
+	else if (!strcasecmp(argv[0], "release_root"))
+		r = process_release_root_mesg(argc, argv, pool);
+
 	else
 		DMWARN("Unrecognised thin pool target message received: %s", argv[0]);
 
-- 
1.7.1
