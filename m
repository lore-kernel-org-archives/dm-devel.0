From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/6] dm cache metadata: check the metadata
	version when reading the superblock
Date: Mon, 11 Nov 2013 12:20:45 -0500
Message-ID: <1384190448-3861-4-git-send-email-snitzer@redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Need to check the version to verify on-disk metadata is supported.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-metadata.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 8601425..9ef0752 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -20,7 +20,13 @@
 
 #define CACHE_SUPERBLOCK_MAGIC 06142003
 #define CACHE_SUPERBLOCK_LOCATION 0
-#define CACHE_VERSION 1
+
+/*
+ * defines a range of metadata versions that this module can handle.
+ */
+#define MIN_CACHE_VERSION 1
+#define MAX_CACHE_VERSION 1
+
 #define CACHE_METADATA_CACHE_SIZE 64
 
 /*
@@ -134,6 +140,18 @@ static void sb_prepare_for_write(struct dm_block_validator *v,
 						      SUPERBLOCK_CSUM_XOR));
 }
 
+static int check_metadata_version(struct cache_disk_superblock *disk_super)
+{
+	uint32_t metadata_version = le32_to_cpu(disk_super->version);
+	if (metadata_version < MIN_CACHE_VERSION || metadata_version > MAX_CACHE_VERSION) {
+		DMERR("Cache metadata version %u found, but only versions between %u and %u supported.",
+		      metadata_version, MIN_CACHE_VERSION, MAX_CACHE_VERSION);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int sb_check(struct dm_block_validator *v,
 		    struct dm_block *b,
 		    size_t sb_block_size)
@@ -164,7 +182,7 @@ static int sb_check(struct dm_block_validator *v,
 		return -EILSEQ;
 	}
 
-	return 0;
+	return check_metadata_version(disk_super);
 }
 
 static struct dm_block_validator sb_validator = {
@@ -270,7 +288,7 @@ static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 	disk_super->flags = 0;
 	memset(disk_super->uuid, 0, sizeof(disk_super->uuid));
 	disk_super->magic = cpu_to_le64(CACHE_SUPERBLOCK_MAGIC);
-	disk_super->version = cpu_to_le32(CACHE_VERSION);
+	disk_super->version = cpu_to_le32(MAX_CACHE_VERSION);
 	memset(disk_super->policy_name, 0, sizeof(disk_super->policy_name));
 	memset(disk_super->policy_version, 0, sizeof(disk_super->policy_version));
 	disk_super->policy_hint_size = 0;
-- 
1.7.4.4
