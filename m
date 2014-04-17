From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFC 09/10] dm-dedup: status function
Date: Thu, 17 Apr 2014 16:48:15 -0400
Message-ID: <535ed0df.8b1a8c0a.7d19.ffffc83b@mx.google.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

The status function prints various statistics about a deduplication
target instance.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>
---
 drivers/md/dm-dedup-target.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-dedup-target.c b/drivers/md/dm-dedup-target.c
index 3b3b9ca..b5ba8a5 100644
--- a/drivers/md/dm-dedup-target.c
+++ b/drivers/md/dm-dedup-target.c
@@ -682,6 +682,39 @@ static void dm_dedup_dtr_fn(struct dm_target *ti)
 	kfree(dc);
 }
 
+static void dm_dedup_status_fn(struct dm_target *ti, status_type_t status_type,
+		unsigned status_flags, char *result, unsigned maxlen)
+{
+	struct dedup_config *dc = ti->private;
+	uint64_t data_total_block_count;
+	uint64_t data_used_block_count;
+	uint64_t data_free_block_count;
+	uint64_t data_actual_block_count;
+	int sz = 0;
+
+	switch (status_type) {
+	case STATUSTYPE_INFO:
+	case STATUSTYPE_TABLE:
+		data_used_block_count = dc->physical_block_counter;
+		data_actual_block_count = dc->logical_block_counter;
+		data_total_block_count = dc->pblocks;
+
+		data_free_block_count =
+			data_total_block_count - data_used_block_count;
+
+		DMEMIT("%llu %llu %llu %llu",
+			data_total_block_count, data_free_block_count,
+			data_used_block_count, data_actual_block_count);
+
+		DMEMIT("%u %s %s", dc->block_size,
+			dc->data_dev->name, dc->metadata_dev->name);
+
+		DMEMIT("%llu %llu %llu %llu %llu %llu",
+			dc->writes, dc->uniqwrites, dc->dupwrites,
+			dc->reads_on_writes, dc->overwrites, dc->newwrites);
+	}
+}
+
 static int dm_dedup_endio_fn(struct dm_target *ti, struct bio *bio, int error)
 {
 	if (error || bio_data_dir(bio) != READ)
@@ -699,6 +732,7 @@ static struct target_type dm_dedup_target = {
 	.dtr = dm_dedup_dtr_fn,
 	.map = dm_dedup_map_fn,
 	.end_io = dm_dedup_endio_fn,
+	.status = dm_dedup_status_fn,
 };
 
 static int __init dm_dedup_init(void)
-- 
1.7.1
