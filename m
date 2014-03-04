From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: stop using bi_private
Date: Tue, 4 Mar 2014 18:24:49 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1403041721520.29476@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Device mapper uses the bi_private field as a pointer to dm_target_io or 
dm_rq_clone_bio_info. With current kernel, the bio structure is embedded 
in the structures dm_target_io and dm_rq_clone_bio_info, so the pointer to 
the structure that contains the bio can be found with the macro 
container_of.

This patch removes the use of bi_private and uses container_of instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-3.14-rc4/drivers/md/dm.c
===================================================================
--- linux-3.14-rc4.orig/drivers/md/dm.c	2014-03-01 17:19:05.000000000 +0100
+++ linux-3.14-rc4/drivers/md/dm.c	2014-03-01 17:23:31.000000000 +0100
@@ -753,7 +753,7 @@ static void dec_pending(struct dm_io *io
 static void clone_endio(struct bio *bio, int error)
 {
 	int r = 0;
-	struct dm_target_io *tio = bio->bi_private;
+	struct dm_target_io *tio = dm_per_bio_data(bio, 0);
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
@@ -787,7 +787,8 @@ static void clone_endio(struct bio *bio,
  */
 static void end_clone_bio(struct bio *clone, int error)
 {
-	struct dm_rq_clone_bio_info *info = clone->bi_private;
+	struct dm_rq_clone_bio_info *info =
+			container_of(clone, struct dm_rq_clone_bio_info, clone);
 	struct dm_rq_target_io *tio = info->tio;
 	struct bio *bio = info->orig;
 	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
@@ -1113,7 +1114,6 @@ static void __map_bio(struct dm_target_i
 	struct dm_target *ti = tio->ti;
 
 	clone->bi_end_io = clone_endio;
-	clone->bi_private = tio;
 
 	/*
 	 * Map the clone.  If r == 0 we don't need to do
@@ -1529,7 +1529,6 @@ static int dm_rq_bio_constructor(struct 
 	info->orig = bio_orig;
 	info->tio = tio;
 	bio->bi_end_io = end_clone_bio;
-	bio->bi_private = info;
 
 	return 0;
 }
