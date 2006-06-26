From: akpm@osdl.org
Subject: [patch 170/215] dm: mirror sector offset fix
Date: Mon, 26 Jun 2006 00:27:26 -0700
Message-ID: <200606260727.k5Q7RQhI030222@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: torvalds@osdl.org
Cc: stable@kernel.org, agk@redhat.com
List-Id: dm-devel.ids


From: Neil Brown <neilb@suse.de>

The device-mapper core does not perform any remapping of bios before passing
them to the targets.  If a particular mapping begins part-way into a device,
targets obtain the sector relative to the start of the mapping by subtracting
ti->begin.

The dm-raid1 target didn't do this everywhere: this patch fixes it, taking
care to subtract ti->begin exactly once for each bio.

[akpm: too late for 2.6.17 - suitable for 2.6.17.x after it has settled]

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/md/dm-raid1.c |   63 +++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

--- linux-2.6.17.11.orig/drivers/md/dm-raid1.c
+++ linux-2.6.17.11/drivers/md/dm-raid1.c
@@ -106,12 +106,42 @@ struct region {
 	struct bio_list delayed_bios;
 };
 
+
+/*-----------------------------------------------------------------
+ * Mirror set structures.
+ *---------------------------------------------------------------*/
+struct mirror {
+	atomic_t error_count;
+	struct dm_dev *dev;
+	sector_t offset;
+};
+
+struct mirror_set {
+	struct dm_target *ti;
+	struct list_head list;
+	struct region_hash rh;
+	struct kcopyd_client *kcopyd_client;
+
+	spinlock_t lock;	/* protects the next two lists */
+	struct bio_list reads;
+	struct bio_list writes;
+
+	/* recovery */
+	region_t nr_regions;
+	int in_sync;
+
+	struct mirror *default_mirror;	/* Default mirror */
+
+	unsigned int nr_mirrors;
+	struct mirror mirror[0];
+};
+
 /*
  * Conversion fns
  */
 static inline region_t bio_to_region(struct region_hash *rh, struct bio *bio)
 {
-	return bio->bi_sector >> rh->region_shift;
+	return (bio->bi_sector - rh->ms->ti->begin) >> rh->region_shift;
 }
 
 static inline sector_t region_to_sector(struct region_hash *rh, region_t region)
@@ -541,35 +571,6 @@ static void rh_start_recovery(struct reg
 	wake();
 }
 
-/*-----------------------------------------------------------------
- * Mirror set structures.
- *---------------------------------------------------------------*/
-struct mirror {
-	atomic_t error_count;
-	struct dm_dev *dev;
-	sector_t offset;
-};
-
-struct mirror_set {
-	struct dm_target *ti;
-	struct list_head list;
-	struct region_hash rh;
-	struct kcopyd_client *kcopyd_client;
-
-	spinlock_t lock;	/* protects the next two lists */
-	struct bio_list reads;
-	struct bio_list writes;
-
-	/* recovery */
-	region_t nr_regions;
-	int in_sync;
-
-	struct mirror *default_mirror;	/* Default mirror */
-
-	unsigned int nr_mirrors;
-	struct mirror mirror[0];
-};
-
 /*
  * Every mirror should look like this one.
  */
@@ -1115,7 +1116,7 @@ static int mirror_map(struct dm_target *
 	struct mirror *m;
 	struct mirror_set *ms = ti->private;
 
-	map_context->ll = bio->bi_sector >> ms->rh.region_shift;
+	map_context->ll = bio_to_region(&ms->rh, bio);
 
 	if (rw == WRITE) {
 		queue_bio(ms, bio, rw);

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dm-fix-deadlock-under-high-i-o-load-in-raid1-setup.patch"
