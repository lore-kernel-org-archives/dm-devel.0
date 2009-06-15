From: heinzm@redhat.com
Subject: [PATCH 1/6] dm raid45 target: export region hash
 functions and add a needed one
Date: Mon, 15 Jun 2009 19:21:05 +0200
Message-ID: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

this patch series introduces the raid45 target.
Please include upstream.

The raid45 target supports RAID4 mappings with a dedicated and selectable
parity device and RAID5 mappings with rotating parity (left/right (a)symmetric).
Initial and partial resynchronization functionality utilizes the dm
dirty log module.

A stripe cache handled by the target in order to update or reconstruct
parity is based on memory objects being managed in a separate, sharable
dm-memcache module, which allows for allocation of such objects with
N chunks of page lists with M pages each.

Message interface parsing is performed in the seperate, sharable
dm-message module.

Heinz


Summary of the patch-set
========================
  1/5: dm raid45 target: export region hash functions and add a needed one
  2/5: dm raid45 target: introduce memory cache
  3/5: dm raid45 target: introduce message parser
  4/5: dm raid45 target: export dm_disk from dm.c
  5/5: dm raid45 target: introcuce the raid45 target
  6/5: dm raid45 target: add raid45 modules to Makefile and adjust Kconfig

 include/linux/dm-region-hash.h  |     4 ++++
 drivers/md/dm-region-hash.c     |    21 +++++++++++++++++--
 drivers/md/dm-memcache.h        |    68 ++++++++++++++++++++++
 drivers/md/dm-memcache.c        |   301 ++++++++++++++++++++++
 drivers/md/dm-message.h         |    91 ++++++++++++++++++++++++
 drivers/md/dm-message.c         |   183 ++++++++++++++++++++++++
 drivers/md/dm.c                 |     1 +
 drivers/md/dm-raid45.h          |    28 ++++++++++++++++++++++++++
 drivers/md/dm-raid45.c          |  4580 ++++++++++++++++++++++++++
 drivers/md/Makefile             |     3 +++
 drivers/md/Kconfig              |     9 +++++++++

 11 files changed, 5286 insertions(+), 3 deletions(-)


 .../{dm-region-hash.h.orig => dm-region-hash.h}    |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/dm-region-hash.h.orig b/include/linux/dm-region-hash.h
index a9e652a..bfd21cb 100644
--- a/include/linux/dm-region-hash.h.orig
+++ b/include/linux/dm-region-hash.h
@@ -49,6 +49,7 @@ struct dm_dirty_log *dm_rh_dirty_log(struct dm_region_hash *rh);
  */
 region_t dm_rh_bio_to_region(struct dm_region_hash *rh, struct bio *bio);
 sector_t dm_rh_region_to_sector(struct dm_region_hash *rh, region_t region);
+region_t dm_rh_sector_to_region(struct dm_region_hash *rh, sector_t sector);
 void *dm_rh_region_context(struct dm_region *reg);
 
 /*
@@ -72,11 +73,14 @@ void dm_rh_update_states(struct dm_region_hash *rh, int errors_handled);
 int dm_rh_flush(struct dm_region_hash *rh);
 
 /* Inc/dec pending count on regions. */
+void dm_rh_inc(struct dm_region_hash *rh, region_t region);
 void dm_rh_inc_pending(struct dm_region_hash *rh, struct bio_list *bios);
 void dm_rh_dec(struct dm_region_hash *rh, region_t region);
 
 /* Delay bios on regions. */
 void dm_rh_delay(struct dm_region_hash *rh, struct bio *bio);
+void dm_rh_delay_by_region(struct dm_region_hash *rh, struct bio *bio,
+			   region_t region);
 
 void dm_rh_mark_nosync(struct dm_region_hash *rh,
 		       struct bio *bio, unsigned done, int error);
 .../md/{dm-region-hash.c.orig => dm-region-hash.c} |   21 +++++++++++++++++--
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-region-hash.c.orig b/drivers/md/dm-region-hash.c
index 7b899be..47b088b 100644
--- a/drivers/md/dm-region-hash.c.orig
+++ b/drivers/md/dm-region-hash.c
@@ -107,10 +107,11 @@ struct dm_region {
 /*
  * Conversion fns
  */
-static region_t dm_rh_sector_to_region(struct dm_region_hash *rh, sector_t sector)
+region_t dm_rh_sector_to_region(struct dm_region_hash *rh, sector_t sector)
 {
 	return sector >> rh->region_shift;
 }
+EXPORT_SYMBOL_GPL(dm_rh_sector_to_region);
 
 sector_t dm_rh_region_to_sector(struct dm_region_hash *rh, region_t region)
 {
@@ -488,7 +489,7 @@ void dm_rh_update_states(struct dm_region_hash *rh, int errors_handled)
 }
 EXPORT_SYMBOL_GPL(dm_rh_update_states);
 
-static void rh_inc(struct dm_region_hash *rh, region_t region)
+void dm_rh_inc(struct dm_region_hash *rh, region_t region)
 {
 	struct dm_region *reg;
 
@@ -510,13 +511,14 @@ static void rh_inc(struct dm_region_hash *rh, region_t region)
 
 	read_unlock(&rh->hash_lock);
 }
+EXPORT_SYMBOL_GPL(dm_rh_inc);
 
 void dm_rh_inc_pending(struct dm_region_hash *rh, struct bio_list *bios)
 {
 	struct bio *bio;
 
 	for (bio = bios->head; bio; bio = bio->bi_next)
-		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
+		dm_rh_inc(rh, dm_rh_bio_to_region(rh, bio));
 }
 EXPORT_SYMBOL_GPL(dm_rh_inc_pending);
 
@@ -677,6 +679,19 @@ void dm_rh_delay(struct dm_region_hash *rh, struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(dm_rh_delay);
 
+void dm_rh_delay_by_region(struct dm_region_hash *rh,
+			   struct bio *bio, region_t region)
+{
+	struct dm_region *reg;
+
+	/* FIXME: locking. */
+	read_lock(&rh->hash_lock);
+	reg = __rh_find(rh, region);
+	bio_list_add(&reg->delayed_bios, bio);
+	read_unlock(&rh->hash_lock);
+}
+EXPORT_SYMBOL_GPL(dm_rh_delay_by_region);
+
 void dm_rh_stop_recovery(struct dm_region_hash *rh)
 {
 	int i;
