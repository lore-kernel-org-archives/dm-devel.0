From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 6/8] dm: add the ability to attach per-bio-data
	to dm_noclone bio
Date: Tue, 19 Feb 2019 17:17:19 -0500
Message-ID: <20190219221721.29830-7-snitzer@redhat.com>
References: <20190219221721.29830-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190219221721.29830-1-snitzer@redhat.com>
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

A DM target can manage its own per-bio-data objects and attach them to
the new 'noclone_private' member in struct dm_noclone.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c               | 16 ++++++++--------
 include/linux/device-mapper.h | 17 +++++++++++++++++
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6868b80fc70c..8ff0ced278d7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -158,13 +158,6 @@ struct table_device {
 	struct dm_dev dm_dev;
 };
 
-struct dm_noclone {
-	struct mapped_device *md;
-	bio_end_io_t *orig_bi_end_io;
-	void *orig_bi_private;
-	unsigned long start_time;
-};
-
 static struct kmem_cache *_rq_tio_cache;
 static struct kmem_cache *_rq_cache;
 static struct kmem_cache *_noclone_cache;
@@ -1802,13 +1795,15 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 			if (unlikely(!noclone))
 				goto no_fast_path;
 
+			noclone->magic = DM_NOCLONE_MAGIC;
 			noclone->md = md;
 			noclone->start_time = jiffies;
 			noclone->orig_bi_end_io = bio->bi_end_io;
 			noclone->orig_bi_private = bio->bi_private;
 			bio->bi_end_io = noclone_endio;
 			bio->bi_private = noclone;
-		}
+		} else
+			noclone = bio->bi_private;
 
 		start_io_acct(md, bio);
 		r = ti->type->map(ti, bio);
@@ -1822,6 +1817,11 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 			else
 				ret = generic_make_request(bio);
 			break;
+		case DM_MAPIO_NOCLONE_FAILED:
+			end_io_acct(md, bio, noclone->start_time);
+			kmem_cache_free(_noclone_cache, noclone);
+			goto no_fast_path;
+			break;
 		case DM_MAPIO_KILL:
 			bio_io_error(bio);
 			break;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 4ab2b0f53ae8..b3e33d5cae8b 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -322,6 +322,22 @@ struct dm_target {
 	bool no_clone:1;
 };
 
+#define DM_NOCLONE_MAGIC 9693664
+struct dm_noclone {
+	unsigned magic;
+	struct mapped_device *md;
+	bio_end_io_t *orig_bi_end_io;
+	void *orig_bi_private;
+	void *noclone_private;
+	unsigned long start_time;
+};
+
+static inline struct dm_noclone *dm_get_noclone_from_bio(struct bio *bio)
+{
+	struct dm_noclone *noclone = bio->bi_private;
+	return (noclone && noclone->magic == DM_NOCLONE_MAGIC) ? noclone : NULL;
+}
+
 /* Each target can link one of these into the table */
 struct dm_target_callbacks {
 	struct list_head list;
@@ -572,6 +588,7 @@ do {									\
 #define DM_MAPIO_REQUEUE	DM_ENDIO_REQUEUE
 #define DM_MAPIO_DELAY_REQUEUE	DM_ENDIO_DELAY_REQUEUE
 #define DM_MAPIO_KILL		4
+#define DM_MAPIO_NOCLONE_FAILED	5
 
 #define dm_sector_div64(x, y)( \
 { \
-- 
2.15.0
