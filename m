From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFCv2 09/10] dm-dedup: status function
Date: Thu, 28 Aug 2014 18:15:36 -0400
Message-ID: <53ffb65b.081e320a.723f.25a8@mx.google.com>
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
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

The status function prints various statistics about a deduplication
target instance.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>
---
 drivers/md/dm-dedup-target.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-dedup-target.c b/drivers/md/dm-dedup-target.c
index 0887543..699af96 100644
--- a/drivers/md/dm-dedup-target.c
+++ b/drivers/md/dm-dedup-target.c
@@ -744,6 +744,39 @@ static void dm_dedup_dtr_fn(struct dm_target *ti)
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
+		DMEMIT("%llu %llu %llu %llu ",
+			data_total_block_count, data_free_block_count,
+			data_used_block_count, data_actual_block_count);
+
+		DMEMIT("%u %s %s ", dc->block_size,
+			dc->data_dev->name, dc->metadata_dev->name);
+
+		DMEMIT("%llu %llu %llu %llu %llu %llu",
+			dc->writes, dc->uniqwrites, dc->dupwrites,
+			dc->reads_on_writes, dc->overwrites, dc->newwrites);
+	}
+}
+
 static int mark_lbn_pbn_bitmap(void *key, int32_t ksize,
 		void *value, int32_t vsize, void *data)
 {
@@ -885,6 +918,7 @@ static struct target_type dm_dedup_target = {
 	.map = dm_dedup_map_fn,
 	.end_io = dm_dedup_endio_fn,
 	.message = dm_dedup_message_fn,
+	.status = dm_dedup_status_fn,
 };
 
 static int __init dm_dedup_init(void)
-- 
1.7.1
