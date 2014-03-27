From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 4/4] [dm-thin, dm-cache,
	dm-era] Take care to copy the space map roots before locking the
	superblock.
Date: Thu, 27 Mar 2014 14:13:23 +0000
Message-ID: <1395929603-14604-5-git-send-email-ejt@redhat.com>
References: <1395929603-14604-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1395929603-14604-1-git-send-email-ejt@redhat.com>
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

Paranoia patch.  In theory this operation can fail, but in practise it
never does because we're careful to check what size buffer is needed.
---
 drivers/md/dm-cache-metadata.c |   60 +++++++++++++++++++-----------
 drivers/md/dm-era-target.c     |   68 +++++++++++++++++++++-------------
 drivers/md/dm-thin-metadata.c  |   80 +++++++++++++++++++++++-----------------
 3 files changed, 127 insertions(+), 81 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 3e7fd7d..53ab31e 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -120,6 +120,12 @@ struct dm_cache_metadata {
 	unsigned policy_version[CACHE_POLICY_VERSION_SIZE];
 	size_t policy_hint_size;
 	struct dm_cache_statistics stats;
+
+	/*
+	 * Reading the space map root can fail, so we read it into this
+	 * buffer before the superblock is locked and updated.
+	 */
+	__u8 metadata_space_map_root[SPACE_MAP_ROOT_SIZE];
 };
 
 /*-------------------------------------------------------------------
@@ -260,11 +266,31 @@ static void __setup_mapping_info(struct dm_cache_metadata *cmd)
 	}
 }
 
+static int __save_sm_root(struct dm_cache_metadata *cmd)
+{
+	int r;
+	size_t metadata_len;
+
+	r = dm_sm_root_size(cmd->metadata_sm, &metadata_len);
+	if (r < 0)
+		return r;
+
+	return dm_sm_copy_root(cmd->metadata_sm, &cmd->metadata_space_map_root,
+			       metadata_len);
+}
+
+static void __copy_sm_root(struct dm_cache_metadata *cmd,
+			   struct cache_disk_superblock *disk_super)
+{
+	memcpy(&disk_super->metadata_space_map_root,
+	       &cmd->metadata_space_map_root,
+	       sizeof(cmd->metadata_space_map_root));
+}
+
 static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 {
 	int r;
 	struct dm_block *sblock;
-	size_t metadata_len;
 	struct cache_disk_superblock *disk_super;
 	sector_t bdev_size = i_size_read(cmd->bdev->bd_inode) >> SECTOR_SHIFT;
 
@@ -272,12 +298,16 @@ static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 	if (bdev_size > DM_CACHE_METADATA_MAX_SECTORS)
 		bdev_size = DM_CACHE_METADATA_MAX_SECTORS;
 
-	r = dm_sm_root_size(cmd->metadata_sm, &metadata_len);
+	r = dm_tm_pre_commit(cmd->tm);
 	if (r < 0)
 		return r;
 
-	r = dm_tm_pre_commit(cmd->tm);
-	if (r < 0)
+	/*
+	 * dm_sm_copy_root() can fail.  So we need to do it before we start
+	 * updating the superblock.
+	 */
+	r = __save_sm_root(cmd);
+	if (r)
 		return r;
 
 	r = superblock_lock_zero(cmd, &sblock);
@@ -293,10 +323,7 @@ static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 	memset(disk_super->policy_version, 0, sizeof(disk_super->policy_version));
 	disk_super->policy_hint_size = 0;
 
-	r = dm_sm_copy_root(cmd->metadata_sm, &disk_super->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0)
-		goto bad_locked;
+	__copy_sm_root(cmd, disk_super);
 
 	disk_super->mapping_root = cpu_to_le64(cmd->root);
 	disk_super->hint_root = cpu_to_le64(cmd->hint_root);
@@ -313,10 +340,6 @@ static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 	disk_super->write_misses = cpu_to_le32(0);
 
 	return dm_tm_commit(cmd->tm, sblock);
-
-bad_locked:
-	dm_bm_unlock(sblock);
-	return r;
 }
 
 static int __format_metadata(struct dm_cache_metadata *cmd)
@@ -560,7 +583,6 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 				flags_mutator mutator)
 {
 	int r;
-	size_t metadata_len;
 	struct cache_disk_superblock *disk_super;
 	struct dm_block *sblock;
 
@@ -578,8 +600,8 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 	if (r < 0)
 		return r;
 
-	r = dm_sm_root_size(cmd->metadata_sm, &metadata_len);
-	if (r < 0)
+	r = __save_sm_root(cmd);
+	if (r)
 		return r;
 
 	r = superblock_lock(cmd, &sblock);
@@ -606,13 +628,7 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 	disk_super->read_misses = cpu_to_le32(cmd->stats.read_misses);
 	disk_super->write_hits = cpu_to_le32(cmd->stats.write_hits);
 	disk_super->write_misses = cpu_to_le32(cmd->stats.write_misses);
-
-	r = dm_sm_copy_root(cmd->metadata_sm, &disk_super->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0) {
-		dm_bm_unlock(sblock);
-		return r;
-	}
+	__copy_sm_root(cmd, disk_super);
 
 	return dm_tm_commit(cmd->tm, sblock);
 }
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index ca65f90..0254b6d 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -289,6 +289,12 @@ struct era_metadata {
 	 * A flag that is set whenever a writeset has been archived.
 	 */
 	bool archived_writesets;
+
+	/*
+	 * Reading the space map root can fail, so we read it into this
+	 * buffer before the superblock is locked and updated.
+	 */
+	__u8 metadata_space_map_root[SPACE_MAP_ROOT_SIZE];
 };
 
 static int superblock_read_lock(struct era_metadata *md,
@@ -453,16 +459,33 @@ bad:
 	return r;
 }
 
+static int save_sm_root(struct era_metadata *md)
+{
+	int r;
+	size_t metadata_len;
+
+	r = dm_sm_root_size(md->sm, &metadata_len);
+	if (r < 0)
+		return r;
+
+	return dm_sm_copy_root(md->sm, &md->metadata_space_map_root,
+			       metadata_len);
+}
+
+static void copy_sm_root(struct era_metadata *md, struct superblock_disk *disk)
+{
+	memcpy(&disk->metadata_space_map_root,
+	       &md->metadata_space_map_root,
+	       sizeof(md->metadata_space_map_root));
+}
+
 /*
  * Writes a superblock, including the static fields that don't get updated
  * with every commit (possible optimisation here).  'md' should be fully
  * constructed when this is called.
  */
-static int prepare_superblock(struct era_metadata *md, struct superblock_disk *disk)
+static void prepare_superblock(struct era_metadata *md, struct superblock_disk *disk)
 {
-	int r;
-	size_t metadata_len;
-
 	disk->magic = cpu_to_le64(SUPERBLOCK_MAGIC);
 	disk->flags = cpu_to_le32(0ul);
 
@@ -470,14 +493,7 @@ static int prepare_superblock(struct era_metadata *md, struct superblock_disk *d
 	memset(disk->uuid, 0, sizeof(disk->uuid));
 	disk->version = cpu_to_le32(MAX_ERA_VERSION);
 
-	r = dm_sm_root_size(md->sm, &metadata_len);
-	if (r < 0)
-		return r;
-
-	r = dm_sm_copy_root(md->sm, &disk->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0)
-		return r;
+	copy_sm_root(md, disk);
 
 	disk->data_block_size = cpu_to_le32(md->block_size);
 	disk->metadata_block_size = cpu_to_le32(METADATA_BLOCK_SIZE >> SECTOR_SHIFT);
@@ -488,8 +504,6 @@ static int prepare_superblock(struct era_metadata *md, struct superblock_disk *d
 	disk->writeset_tree_root = cpu_to_le64(md->writeset_tree_root);
 	disk->era_array_root = cpu_to_le64(md->era_array_root);
 	disk->metadata_snap = cpu_to_le64(md->metadata_snap);
-
-	return 0;
 }
 
 static int write_superblock(struct era_metadata *md)
@@ -498,17 +512,18 @@ static int write_superblock(struct era_metadata *md)
 	struct dm_block *sblock;
 	struct superblock_disk *disk;
 
+	r = save_sm_root(md);
+	if (r) {
+		DMERR("%s: save_sm_root failed", __func__);
+		return r;
+	}
+
 	r = superblock_lock_zero(md, &sblock);
 	if (r)
 		return r;
 
 	disk = dm_block_data(sblock);
-	r = prepare_superblock(md, disk);
-	if (r) {
-		DMERR("%s: prepare_superblock failed", __func__);
-		dm_bm_unlock(sblock); /* FIXME: does this commit? */
-		return r;
-	}
+	prepare_superblock(md, disk);
 
 	return dm_tm_commit(md->tm, sblock);
 }
@@ -930,6 +945,12 @@ static int metadata_commit(struct era_metadata *md)
 		}
 	}
 
+	r = save_sm_root(md);
+	if (r) {
+		DMERR("%s: save_sm_root failed", __func__);
+		return r;
+	}
+
 	r = dm_tm_pre_commit(md->tm);
 	if (r) {
 		DMERR("%s: pre commit failed", __func__);
@@ -942,12 +963,7 @@ static int metadata_commit(struct era_metadata *md)
 		return r;
 	}
 
-	r = prepare_superblock(md, dm_block_data(sblock));
-	if (r) {
-		DMERR("%s: prepare_superblock failed", __func__);
-		dm_bm_unlock(sblock); /* FIXME: does this commit? */
-		return r;
-	}
+	prepare_superblock(md, dm_block_data(sblock));
 
 	return dm_tm_commit(md->tm, sblock);
 }
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 8bc585c..10c0f67 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -192,6 +192,13 @@ struct dm_pool_metadata {
 	 * operation possible in this state is the closing of the device.
 	 */
 	bool fail_io:1;
+
+	/*
+	 * Reading the space map roots can fail, so we read it into these
+	 * buffers before the superblock is locked and updated.
+	 */
+	__u8 data_space_map_root[SPACE_MAP_ROOT_SIZE];
+	__u8 metadata_space_map_root[SPACE_MAP_ROOT_SIZE];
 };
 
 struct dm_thin_device {
@@ -431,26 +438,53 @@ static void __setup_btree_details(struct dm_pool_metadata *pmd)
 	pmd->details_info.value_type.equal = NULL;
 }
 
+static int save_sm_roots(struct dm_pool_metadata *pmd)
+{
+	int r;
+	size_t len;
+
+	r = dm_sm_root_size(pmd->metadata_sm, &len);
+	if (r < 0)
+		return r;
+
+	r = dm_sm_copy_root(pmd->metadata_sm, &pmd->metadata_space_map_root, len);
+	if (r < 0)
+		return r;
+
+	r = dm_sm_root_size(pmd->data_sm, &len);
+	if (r < 0)
+		return r;
+
+	return dm_sm_copy_root(pmd->data_sm, &pmd->data_space_map_root, len);
+}
+
+static void copy_sm_roots(struct dm_pool_metadata *pmd,
+			  struct thin_disk_superblock *disk)
+{
+	memcpy(&disk->metadata_space_map_root,
+	       &pmd->metadata_space_map_root,
+	       sizeof(pmd->metadata_space_map_root));
+
+	memcpy(&disk->data_space_map_root,
+	       &pmd->data_space_map_root,
+	       sizeof(pmd->data_space_map_root));
+}
+
 static int __write_initial_superblock(struct dm_pool_metadata *pmd)
 {
 	int r;
 	struct dm_block *sblock;
-	size_t metadata_len, data_len;
 	struct thin_disk_superblock *disk_super;
 	sector_t bdev_size = i_size_read(pmd->bdev->bd_inode) >> SECTOR_SHIFT;
 
 	if (bdev_size > THIN_METADATA_MAX_SECTORS)
 		bdev_size = THIN_METADATA_MAX_SECTORS;
 
-	r = dm_sm_root_size(pmd->metadata_sm, &metadata_len);
-	if (r < 0)
-		return r;
-
-	r = dm_sm_root_size(pmd->data_sm, &data_len);
+	r = dm_sm_commit(pmd->data_sm);
 	if (r < 0)
 		return r;
 
-	r = dm_sm_commit(pmd->data_sm);
+	r = save_sm_roots(pmd);
 	if (r < 0)
 		return r;
 
@@ -471,15 +505,7 @@ static int __write_initial_superblock(struct dm_pool_metadata *pmd)
 	disk_super->trans_id = 0;
 	disk_super->held_root = 0;
 
-	r = dm_sm_copy_root(pmd->metadata_sm, &disk_super->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0)
-		goto bad_locked;
-
-	r = dm_sm_copy_root(pmd->data_sm, &disk_super->data_space_map_root,
-			    data_len);
-	if (r < 0)
-		goto bad_locked;
+	copy_sm_roots(pmd, disk_super);
 
 	disk_super->data_mapping_root = cpu_to_le64(pmd->root);
 	disk_super->device_details_root = cpu_to_le64(pmd->details_root);
@@ -488,10 +514,6 @@ static int __write_initial_superblock(struct dm_pool_metadata *pmd)
 	disk_super->data_block_size = cpu_to_le32(pmd->data_block_size);
 
 	return dm_tm_commit(pmd->tm, sblock);
-
-bad_locked:
-	dm_bm_unlock(sblock);
-	return r;
 }
 
 static int __format_metadata(struct dm_pool_metadata *pmd)
@@ -769,6 +791,10 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	if (r < 0)
 		return r;
 
+	r = save_sm_roots(pmd);
+	if (r < 0)
+		return r;
+
 	r = superblock_lock(pmd, &sblock);
 	if (r)
 		return r;
@@ -780,21 +806,9 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
 	disk_super->trans_id = cpu_to_le64(pmd->trans_id);
 	disk_super->flags = cpu_to_le32(pmd->flags);
 
-	r = dm_sm_copy_root(pmd->metadata_sm, &disk_super->metadata_space_map_root,
-			    metadata_len);
-	if (r < 0)
-		goto out_locked;
-
-	r = dm_sm_copy_root(pmd->data_sm, &disk_super->data_space_map_root,
-			    data_len);
-	if (r < 0)
-		goto out_locked;
+	copy_sm_roots(pmd, disk_super);
 
 	return dm_tm_commit(pmd->tm, sblock);
-
-out_locked:
-	dm_bm_unlock(sblock);
-	return r;
 }
 
 struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
-- 
1.7.10.4
