From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: remove dm_get_mapinfo
Date: Mon, 3 Mar 2014 17:43:31 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1403031742250.15269@file01.intranet.prod.int.rdu2.redhat.com>
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

Remove dm_get_mapinfo because no target uses it. Targets can allocate
per-request data using ti->per_bio_data_size, this is much more flexible
than union map_info.

We leave union map_info only for request-based target multipath that uses
it. This patch also deletes the "unsigned long long ll" field of union
map_info, because no one uses it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c               |   10 ----------
 include/linux/device-mapper.h |    3 ---
 2 files changed, 13 deletions(-)

Index: linux-3.14-rc4/drivers/md/dm.c
===================================================================
--- linux-3.14-rc4.orig/drivers/md/dm.c	2014-03-01 17:07:14.000000000 +0100
+++ linux-3.14-rc4/drivers/md/dm.c	2014-03-01 17:15:58.000000000 +0100
@@ -94,13 +94,6 @@ struct dm_rq_clone_bio_info {
 	struct bio clone;
 };
 
-union map_info *dm_get_mapinfo(struct bio *bio)
-{
-	if (bio && bio->bi_private)
-		return &((struct dm_target_io *)bio->bi_private)->info;
-	return NULL;
-}
-
 union map_info *dm_get_rq_mapinfo(struct request *rq)
 {
 	if (rq && rq->end_io_data)
@@ -1195,7 +1188,6 @@ static struct dm_target_io *alloc_tio(st
 
 	tio->io = ci->io;
 	tio->ti = ti;
-	memset(&tio->info, 0, sizeof(tio->info));
 	tio->target_bio_nr = target_bio_nr;
 
 	return tio;
@@ -2881,8 +2873,6 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
-EXPORT_SYMBOL(dm_get_mapinfo);
-
 /*
  * module hooks
  */
Index: linux-3.14-rc4/include/linux/device-mapper.h
===================================================================
--- linux-3.14-rc4.orig/include/linux/device-mapper.h	2014-03-01 17:07:28.000000000 +0100
+++ linux-3.14-rc4/include/linux/device-mapper.h	2014-03-01 17:15:07.000000000 +0100
@@ -23,7 +23,6 @@ typedef enum { STATUSTYPE_INFO, STATUSTY
 
 union map_info {
 	void *ptr;
-	unsigned long long ll;
 };
 
 /*
@@ -291,7 +290,6 @@ struct dm_target_callbacks {
 struct dm_target_io {
 	struct dm_io *io;
 	struct dm_target *ti;
-	union map_info info;
 	unsigned target_bio_nr;
 	struct bio clone;
 };
@@ -403,7 +401,6 @@ int dm_copy_name_and_uuid(struct mapped_
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
-union map_info *dm_get_mapinfo(struct bio *bio);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
