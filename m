From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/14] block: make QUEUE_SYSFS_BIT_FNS a little more useful
Date: Wed, 22 Jul 2020 08:25:45 +0200
Message-ID: <20200722062552.212200-8-hch@lst.de>
References: <20200722062552.212200-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200722062552.212200-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
List-Id: dm-devel.ids

Generate the queue_sysfs_entry given that we have all the required
information for it, and rename the generated show and store methods
to match the other ones in the file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-sysfs.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index ce418d9128a0b2..cfbb039da8751f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -257,16 +257,16 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
-#define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
+#define QUEUE_SYSFS_BIT_FNS(_name, flag, neg)				\
 static ssize_t								\
-queue_show_##name(struct request_queue *q, char *page)			\
+queue_##_name##_show(struct request_queue *q, char *page)		\
 {									\
 	int bit;							\
 	bit = test_bit(QUEUE_FLAG_##flag, &q->queue_flags);		\
 	return queue_var_show(neg ? !bit : bit, page);			\
 }									\
 static ssize_t								\
-queue_store_##name(struct request_queue *q, const char *page, size_t count) \
+queue_##_name##_store(struct request_queue *q, const char *page, size_t count) \
 {									\
 	unsigned long val;						\
 	ssize_t ret;							\
@@ -281,7 +281,12 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 	else								\
 		blk_queue_flag_clear(QUEUE_FLAG_##flag, q);		\
 	return ret;							\
-}
+}									\
+static struct queue_sysfs_entry queue_##_name##_entry = {		\
+	.attr	= { .name = __stringify(_name), .mode = 0644 },		\
+	.show	= queue_##_name##_show,					\
+	.store	= queue_##_name##_store,				\
+};
 
 QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
 QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
@@ -661,12 +666,6 @@ static struct queue_sysfs_entry queue_zone_append_max_entry = {
 	.show = queue_zone_append_max_show,
 };
 
-static struct queue_sysfs_entry queue_nonrot_entry = {
-	.attr = {.name = "rotational", .mode = 0644 },
-	.show = queue_show_nonrot,
-	.store = queue_store_nonrot,
-};
-
 static struct queue_sysfs_entry queue_zoned_entry = {
 	.attr = {.name = "zoned", .mode = 0444 },
 	.show = queue_zoned_show,
@@ -699,18 +698,6 @@ static struct queue_sysfs_entry queue_rq_affinity_entry = {
 	.store = queue_rq_affinity_store,
 };
 
-static struct queue_sysfs_entry queue_iostats_entry = {
-	.attr = {.name = "iostats", .mode = 0644 },
-	.show = queue_show_iostats,
-	.store = queue_store_iostats,
-};
-
-static struct queue_sysfs_entry queue_random_entry = {
-	.attr = {.name = "add_random", .mode = 0644 },
-	.show = queue_show_random,
-	.store = queue_store_random,
-};
-
 static struct queue_sysfs_entry queue_poll_entry = {
 	.attr = {.name = "io_poll", .mode = 0644 },
 	.show = queue_poll_show,
-- 
2.27.0
