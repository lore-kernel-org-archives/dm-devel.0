From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/3] persistent data: log errors using
	DMERR_LIMIT instead of DMERR
Date: Fri, 30 Nov 2012 09:45:26 -0500
Message-ID: <1354286727-31933-2-git-send-email-snitzer@redhat.com>
References: <1354286727-31933-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1354286727-31933-1-git-send-email-snitzer@redhat.com>
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

Nearly all of persistent-data is in the IO path and as such it should
throttle the errors that is logs.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-block-manager.c    |   11 +++++------
 drivers/md/persistent-data/dm-btree-spine.c      |   14 +++++++-------
 drivers/md/persistent-data/dm-space-map-common.c |   16 ++++++++--------
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 47b683e..ec4cb3c 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -429,17 +429,16 @@ static int dm_bm_validate_buffer(struct dm_block_manager *bm,
 			return 0;
 		r = v->check(v, (struct dm_block *) buf, dm_bufio_get_block_size(bm->bufio));
 		if (unlikely(r)) {
-			DMERR("%s validator check failed for block %llu", v->name,
-			      (unsigned long long) dm_bufio_get_block_number(buf));
+			DMERR_LIMIT("%s validator check failed for block %llu", v->name,
+				    (unsigned long long) dm_bufio_get_block_number(buf));
 			return r;
 		}
 		aux->validator = v;
 	} else {
 		if (unlikely(aux->validator != v)) {
-			DMERR("validator mismatch (old=%s vs new=%s) for block %llu",
-				aux->validator->name, v ? v->name : "NULL",
-				(unsigned long long)
-					dm_bufio_get_block_number(buf));
+			DMERR_LIMIT("validator mismatch (old=%s vs new=%s) for block %llu",
+				    aux->validator->name, v ? v->name : "NULL",
+				    (unsigned long long) dm_bufio_get_block_number(buf));
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index d9a7912..1a23460 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -45,8 +45,8 @@ static int node_check(struct dm_block_validator *v,
 	uint32_t flags;
 
 	if (dm_block_location(b) != le64_to_cpu(h->blocknr)) {
-		DMERR("node_check failed blocknr %llu wanted %llu",
-		      le64_to_cpu(h->blocknr), dm_block_location(b));
+		DMERR_LIMIT("node_check failed blocknr %llu wanted %llu",
+			    le64_to_cpu(h->blocknr), dm_block_location(b));
 		return -ENOTBLK;
 	}
 
@@ -54,8 +54,8 @@ static int node_check(struct dm_block_validator *v,
 					       block_size - sizeof(__le32),
 					       BTREE_CSUM_XOR));
 	if (csum_disk != h->csum) {
-		DMERR("node_check failed csum %u wanted %u",
-		      le32_to_cpu(csum_disk), le32_to_cpu(h->csum));
+		DMERR_LIMIT("node_check failed csum %u wanted %u",
+			    le32_to_cpu(csum_disk), le32_to_cpu(h->csum));
 		return -EILSEQ;
 	}
 
@@ -63,12 +63,12 @@ static int node_check(struct dm_block_validator *v,
 
 	if (sizeof(struct node_header) +
 	    (sizeof(__le64) + value_size) * le32_to_cpu(h->max_entries) > block_size) {
-		DMERR("node_check failed: max_entries too large");
+		DMERR_LIMIT("node_check failed: max_entries too large");
 		return -EILSEQ;
 	}
 
 	if (le32_to_cpu(h->nr_entries) > le32_to_cpu(h->max_entries)) {
-		DMERR("node_check failed, too many entries");
+		DMERR_LIMIT("node_check failed, too many entries");
 		return -EILSEQ;
 	}
 
@@ -77,7 +77,7 @@ static int node_check(struct dm_block_validator *v,
 	 */
 	flags = le32_to_cpu(h->flags);
 	if (!(flags & INTERNAL_NODE) && !(flags & LEAF_NODE)) {
-		DMERR("node_check failed, node is neither INTERNAL or LEAF");
+		DMERR_LIMIT("node_check failed, node is neither INTERNAL or LEAF");
 		return -EILSEQ;
 	}
 
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index f3a9af8..1ff5f99 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -39,8 +39,8 @@ static int index_check(struct dm_block_validator *v,
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(mi_le->blocknr)) {
-		DMERR("index_check failed blocknr %llu wanted %llu",
-		      le64_to_cpu(mi_le->blocknr), dm_block_location(b));
+		DMERR_LIMIT("index_check failed blocknr %llu wanted %llu",
+			    le64_to_cpu(mi_le->blocknr), dm_block_location(b));
 		return -ENOTBLK;
 	}
 
@@ -48,8 +48,8 @@ static int index_check(struct dm_block_validator *v,
 					       block_size - sizeof(__le32),
 					       INDEX_CSUM_XOR));
 	if (csum_disk != mi_le->csum) {
-		DMERR("index_check failed csum %u wanted %u",
-		      le32_to_cpu(csum_disk), le32_to_cpu(mi_le->csum));
+		DMERR_LIMIT("index_check failed csum %u wanted %u",
+			    le32_to_cpu(csum_disk), le32_to_cpu(mi_le->csum));
 		return -EILSEQ;
 	}
 
@@ -89,8 +89,8 @@ static int bitmap_check(struct dm_block_validator *v,
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(disk_header->blocknr)) {
-		DMERR("bitmap check failed blocknr %llu wanted %llu",
-		      le64_to_cpu(disk_header->blocknr), dm_block_location(b));
+		DMERR_LIMIT("bitmap check failed blocknr %llu wanted %llu",
+			    le64_to_cpu(disk_header->blocknr), dm_block_location(b));
 		return -ENOTBLK;
 	}
 
@@ -98,8 +98,8 @@ static int bitmap_check(struct dm_block_validator *v,
 					       block_size - sizeof(__le32),
 					       BITMAP_CSUM_XOR));
 	if (csum_disk != disk_header->csum) {
-		DMERR("bitmap check failed csum %u wanted %u",
-		      le32_to_cpu(csum_disk), le32_to_cpu(disk_header->csum));
+		DMERR_LIMIT("bitmap check failed csum %u wanted %u",
+			    le32_to_cpu(csum_disk), le32_to_cpu(disk_header->csum));
 		return -EILSEQ;
 	}
 
-- 
1.7.4.4
