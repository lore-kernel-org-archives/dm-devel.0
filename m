From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: return client directly and not
	through a pointer
Date: Wed, 25 May 2011 12:49:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105251248380.21920@hs20-bc2-1.build.redhat.com>
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

dm-kcopyd: return client directly and not through a pointer

Make it consistent with dm_io_client_create.
There is no need to return newly created client via an indirect pointer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c    |    9 ++++-----
 drivers/md/dm-raid1.c     |    6 ++++--
 drivers/md/dm-snap.c      |    5 +++--
 include/linux/dm-kcopyd.h |    2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-25 18:32:46.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-25 18:34:30.000000000 +0200
@@ -617,14 +617,14 @@ int kcopyd_cancel(struct kcopyd_job *job
 /*-----------------------------------------------------------------
  * Client setup
  *---------------------------------------------------------------*/
-int dm_kcopyd_client_create(struct dm_kcopyd_client **result)
+struct dm_kcopyd_client *dm_kcopyd_client_create(void)
 {
 	int r = -ENOMEM;
 	struct dm_kcopyd_client *kc;
 
 	kc = kmalloc(sizeof(*kc), GFP_KERNEL);
 	if (!kc)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&kc->job_lock);
 	INIT_LIST_HEAD(&kc->complete_jobs);
@@ -656,8 +656,7 @@ int dm_kcopyd_client_create(struct dm_kc
 	init_waitqueue_head(&kc->destroyq);
 	atomic_set(&kc->nr_jobs, 0);
 
-	*result = kc;
-	return 0;
+	return kc;
 
 bad_io_client:
 	client_free_pages(kc);
@@ -668,7 +667,7 @@ bad_workqueue:
 bad_slab:
 	kfree(kc);
 
-	return r;
+	return ERR_PTR(r);
 }
 EXPORT_SYMBOL(dm_kcopyd_client_create);
 
Index: linux-2.6.39-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-raid1.c	2011-05-25 18:34:53.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-raid1.c	2011-05-25 18:36:26.000000000 +0200
@@ -1115,9 +1115,11 @@ static int mirror_ctr(struct dm_target *
 		goto err_destroy_wq;
 	}
 
-	r = dm_kcopyd_client_create(&ms->kcopyd_client);
-	if (r)
+	ms->kcopyd_client = dm_kcopyd_client_create();
+	if (IS_ERR(ms->kcopyd_client)) {
+		r = PTR_ERR(ms->kcopyd_client);
 		goto err_destroy_wq;
+	}
 
 	wakeup_mirrord(ms);
 	return 0;
Index: linux-2.6.39-fast/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-snap.c	2011-05-25 18:36:50.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-snap.c	2011-05-25 18:37:13.000000000 +0200
@@ -1111,8 +1111,9 @@ static int snapshot_ctr(struct dm_target
 		goto bad_hash_tables;
 	}
 
-	r = dm_kcopyd_client_create(&s->kcopyd_client);
-	if (r) {
+	s->kcopyd_client = dm_kcopyd_client_create();
+	if (IS_ERR(s->kcopyd_client)) {
+		r = PTR_ERR(s->kcopyd_client);
 		ti->error = "Could not create kcopyd client";
 		goto bad_kcopyd;
 	}
Index: linux-2.6.39-fast/include/linux/dm-kcopyd.h
===================================================================
--- linux-2.6.39-fast.orig/include/linux/dm-kcopyd.h	2011-05-25 18:34:07.000000000 +0200
+++ linux-2.6.39-fast/include/linux/dm-kcopyd.h	2011-05-25 18:34:28.000000000 +0200
@@ -25,7 +25,7 @@
  * To use kcopyd you must first create a dm_kcopyd_client object.
  */
 struct dm_kcopyd_client;
-int dm_kcopyd_client_create(struct dm_kcopyd_client **result);
+struct dm_kcopyd_client *dm_kcopyd_client_create(void);
 void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc);
 
 /*
