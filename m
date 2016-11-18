From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/14] dm,
 persistence: Remove an unused argument from
 dm_block_manager_create()
Date: Fri, 18 Nov 2016 14:28:17 -0800
Message-ID: <97745a3d-e9fa-93a8-fab9-2ecfba0ebcbb@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The 'cache_size' argument of dm_block_manager_create() has never
been used. Hence remove it and also the definitions of the constants
passed as 'cache_size' argument.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-cache-metadata.c                | 3 ---
 drivers/md/dm-era-target.c                    | 2 --
 drivers/md/dm-thin-metadata.c                 | 2 --
 drivers/md/persistent-data/dm-block-manager.c | 1 -
 drivers/md/persistent-data/dm-block-manager.h | 2 +-
 5 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 6955778..d459999 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -27,8 +27,6 @@
 #define MIN_CACHE_VERSION 1
 #define MAX_CACHE_VERSION 1
 
-#define CACHE_METADATA_CACHE_SIZE 64
-
 /*
  *  3 for btree insert +
  *  2 for btree lookup used within space map
@@ -504,7 +502,6 @@ static int __create_persistent_data_objects(struct dm_cache_metadata *cmd,
 {
 	int r;
 	cmd->bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
-					  CACHE_METADATA_CACHE_SIZE,
 					  CACHE_MAX_CONCURRENT_LOCKS);
 	if (IS_ERR(cmd->bm)) {
 		DMERR("could not create block manager");
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index bf2b267..77f0b4e 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -254,7 +254,6 @@ static struct dm_block_validator sb_validator = {
  * Low level metadata handling
  *--------------------------------------------------------------*/
 #define DM_ERA_METADATA_BLOCK_SIZE 4096
-#define DM_ERA_METADATA_CACHE_SIZE 64
 #define ERA_MAX_CONCURRENT_LOCKS 5
 
 struct era_metadata {
@@ -615,7 +614,6 @@ static int create_persistent_data_objects(struct era_metadata *md,
 	int r;
 
 	md->bm = dm_block_manager_create(md->bdev, DM_ERA_METADATA_BLOCK_SIZE,
-					 DM_ERA_METADATA_CACHE_SIZE,
 					 ERA_MAX_CONCURRENT_LOCKS);
 	if (IS_ERR(md->bm)) {
 		DMERR("could not create block manager");
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index a15091a..0f0251d 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -77,7 +77,6 @@
 #define THIN_SUPERBLOCK_MAGIC 27022010
 #define THIN_SUPERBLOCK_LOCATION 0
 #define THIN_VERSION 2
-#define THIN_METADATA_CACHE_SIZE 64
 #define SECTOR_TO_BLOCK_SHIFT 3
 
 /*
@@ -686,7 +685,6 @@ static int __create_persistent_data_objects(struct dm_pool_metadata *pmd, bool f
 	int r;
 
 	pmd->bm = dm_block_manager_create(pmd->bdev, THIN_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
-					  THIN_METADATA_CACHE_SIZE,
 					  THIN_MAX_CONCURRENT_LOCKS);
 	if (IS_ERR(pmd->bm)) {
 		DMERR("could not create block manager");
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 1e33dd5..4aea053 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -360,7 +360,6 @@ struct dm_block_manager {
 
 struct dm_block_manager *dm_block_manager_create(struct block_device *bdev,
 						 unsigned block_size,
-						 unsigned cache_size,
 						 unsigned max_held_per_thread)
 {
 	int r;
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index 3627d1b..e728937 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -33,7 +33,7 @@ void *dm_block_data(struct dm_block *b);
 struct dm_block_manager;
 struct dm_block_manager *dm_block_manager_create(
 	struct block_device *bdev, unsigned block_size,
-	unsigned cache_size, unsigned max_held_per_thread);
+	unsigned max_held_per_thread);
 void dm_block_manager_destroy(struct dm_block_manager *bm);
 
 unsigned dm_bm_block_size(struct dm_block_manager *bm);
-- 
2.10.1
