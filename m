From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 09/14] dm thin metadata: add
	dm_thin_find_mapped_range()
Date: Thu, 14 May 2015 17:05:07 -0400
Message-ID: <1431637512-64245-10-git-send-email-snitzer@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Retrieve the next run of contiguously mapped blocks.  Useful for working
out where to break up IO.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin-metadata.c | 57 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-thin-metadata.h |  9 +++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 79f6941..edcf4fb 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1419,6 +1419,63 @@ int dm_thin_find_block(struct dm_thin_device *td, dm_block_t block,
 	return r;
 }
 
+/* FIXME: write a more efficient one in btree */
+int dm_thin_find_mapped_range(struct dm_thin_device *td,
+			      dm_block_t begin, dm_block_t end,
+			      dm_block_t *thin_begin, dm_block_t *thin_end,
+			      dm_block_t *pool_begin, bool *maybe_shared)
+{
+	int r;
+	dm_block_t pool_end;
+	struct dm_thin_lookup_result lookup;
+
+	if (end < begin)
+		return -ENODATA;
+
+	/*
+	 * Find first mapped block.
+	 */
+	while (begin < end) {
+		r = dm_thin_find_block(td, begin, true, &lookup);
+		if (r) {
+			if (r != -ENODATA)
+				return r;
+		} else
+			break;
+
+		begin++;
+	}
+
+	if (begin == end)
+		return -ENODATA;
+
+	*thin_begin = begin;
+	*pool_begin = lookup.block;
+	*maybe_shared = lookup.shared;
+
+	begin++;
+	pool_end = *pool_begin + 1;
+	while (begin != end) {
+		r = dm_thin_find_block(td, begin, true, &lookup);
+		if (r) {
+			if (r == -ENODATA)
+				break;
+			else
+				return r;
+		}
+
+		if ((lookup.block != pool_end) ||
+		    (lookup.shared != *maybe_shared))
+			break;
+
+		pool_end++;
+		begin++;
+	}
+
+	*thin_end = begin;
+	return 0;
+}
+
 static int __insert(struct dm_thin_device *td, dm_block_t block,
 		    dm_block_t data_block)
 {
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index fac01a9..f11f140 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -147,6 +147,15 @@ int dm_thin_find_block(struct dm_thin_device *td, dm_block_t block,
 		       int can_issue_io, struct dm_thin_lookup_result *result);
 
 /*
+ * Retrieve the next run of contiguously mapped blocks.  Useful for working
+ * out where to break up IO.  Returns 0 on success, < 0 on error.
+ */
+int dm_thin_find_mapped_range(struct dm_thin_device *td,
+			      dm_block_t begin, dm_block_t end,
+			      dm_block_t *thin_begin, dm_block_t *thin_end,
+			      dm_block_t *pool_begin, bool *maybe_shared);
+
+/*
  * Obtain an unused block.
  */
 int dm_pool_alloc_data_block(struct dm_pool_metadata *pmd, dm_block_t *result);
-- 
2.3.2 (Apple Git-55)
