From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: reserve fewer pages
Date: Wed, 25 May 2011 12:48:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105251248041.21920@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-kcopyd: reserve fewer pages

Because we allocate pages from page allocator, we don't need to large amount
of pages. Reserve just the minimum of pages needed to process one job.
The maximum job size is SUB_JOB_SIZE, thus we calculate the number of reserved
pages from this.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c    |    6 +++---
 drivers/md/dm-raid1.c     |    3 +--
 drivers/md/dm-snap.c      |    7 +------
 include/linux/dm-kcopyd.h |    3 +--
 4 files changed, 6 insertions(+), 13 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-25 17:40:59.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-25 17:43:23.000000000 +0200
@@ -30,6 +30,7 @@
 #define SUB_JOB_SIZE	128
 #define SPLIT_COUNT	8
 #define MIN_JOBS	1
+#define RESERVE_PAGES	DIV_ROUND_UP(SUB_JOB_SIZE << SECTOR_SHIFT, PAGE_SIZE)
 
 /*-----------------------------------------------------------------
  * Each kcopyd client has its own little pool of preallocated
@@ -616,8 +617,7 @@ int kcopyd_cancel(struct kcopyd_job *job
 /*-----------------------------------------------------------------
  * Client setup
  *---------------------------------------------------------------*/
-int dm_kcopyd_client_create(unsigned int nr_pages,
-			    struct dm_kcopyd_client **result)
+int dm_kcopyd_client_create(struct dm_kcopyd_client **result)
 {
 	int r = -ENOMEM;
 	struct dm_kcopyd_client *kc;
@@ -643,7 +643,7 @@ int dm_kcopyd_client_create(unsigned int
 
 	kc->pages = NULL;
 	kc->nr_pages = kc->nr_free_pages = 0;
-	r = client_alloc_pages(kc, nr_pages);
+	r = client_alloc_pages(kc, RESERVE_PAGES);
 	if (r)
 		goto bad_client_pages;
 
Index: linux-2.6.39-fast/include/linux/dm-kcopyd.h
===================================================================
--- linux-2.6.39-fast.orig/include/linux/dm-kcopyd.h	2011-05-24 22:13:16.000000000 +0200
+++ linux-2.6.39-fast/include/linux/dm-kcopyd.h	2011-05-25 17:43:23.000000000 +0200
@@ -25,8 +25,7 @@
  * To use kcopyd you must first create a dm_kcopyd_client object.
  */
 struct dm_kcopyd_client;
-int dm_kcopyd_client_create(unsigned num_pages,
-			    struct dm_kcopyd_client **result);
+int dm_kcopyd_client_create(struct dm_kcopyd_client **result);
 void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc);
 
 /*
Index: linux-2.6.39-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-raid1.c	2011-05-25 17:40:11.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-raid1.c	2011-05-25 17:43:23.000000000 +0200
@@ -22,7 +22,6 @@
 #define DM_MSG_PREFIX "raid1"
 
 #define MAX_RECOVERY 1	/* Maximum number of regions recovered in parallel. */
-#define DM_KCOPYD_PAGES 64
 
 #define DM_RAID1_HANDLE_ERRORS 0x01
 #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
@@ -1116,7 +1115,7 @@ static int mirror_ctr(struct dm_target *
 		goto err_destroy_wq;
 	}
 
-	r = dm_kcopyd_client_create(DM_KCOPYD_PAGES, &ms->kcopyd_client);
+	r = dm_kcopyd_client_create(&ms->kcopyd_client);
 	if (r)
 		goto err_destroy_wq;
 
Index: linux-2.6.39-fast/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-snap.c	2011-05-24 22:13:16.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-snap.c	2011-05-25 17:43:23.000000000 +0200
@@ -40,11 +40,6 @@ static const char dm_snapshot_merge_targ
 #define SNAPSHOT_COPY_PRIORITY 2
 
 /*
- * Reserve 1MB for each snapshot initially (with minimum of 1 page).
- */
-#define SNAPSHOT_PAGES (((1UL << 20) >> PAGE_SHIFT) ? : 1)
-
-/*
  * The size of the mempool used to track chunks in use.
  */
 #define MIN_IOS 256
@@ -1116,7 +1111,7 @@ static int snapshot_ctr(struct dm_target
 		goto bad_hash_tables;
 	}
 
-	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
+	r = dm_kcopyd_client_create(&s->kcopyd_client);
 	if (r) {
 		ti->error = "Could not create kcopyd client";
 		goto bad_kcopyd;
