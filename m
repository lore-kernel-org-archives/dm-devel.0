From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/6] dm ioctl: interlock resume and table clear
Date: Sun, 23 May 2010 17:44:57 -0400
Message-ID: <1274651101-9784-3-git-send-email-snitzer@redhat.com>
References: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

When resuming an inactive table there is a lack of testable state during
its transition to being live (hc->new_map is NULL and md->map isn't
set).  Interlock allows table_clear() to _know_ there isn't a live table
yet.

This interlock also has the side-effect of serializing N resumes to the
_same_ mapped_device (more coarsely than the suspend_lock provides).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c |   34 +++++++++++++++++++++++++++++++---
 drivers/md/dm.c       |   17 +++++++++++++++++
 drivers/md/dm.h       |    3 +++
 3 files changed, 51 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -871,6 +871,17 @@ static int do_resume(struct dm_ioctl *pa
 	}
 
 	md = hc->md;
+	up_write(&_hash_lock);
+
+	dm_lock_resume(md);
+
+	down_write(&_hash_lock);
+	if (!hc || hc->md != md) {
+		DMWARN("device has been removed from the dev hash table.");
+		up_write(&_hash_lock);
+		r = -ENXIO;
+		goto out;
+	}
 
 	new_map = hc->new_map;
 	hc->new_map = NULL;
@@ -891,8 +902,8 @@ static int do_resume(struct dm_ioctl *pa
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
 			dm_table_destroy(new_map);
-			dm_put(md);
-			return PTR_ERR(old_map);
+			r = PTR_ERR(old_map);
+			goto out;
 		}
 
 		if (dm_table_get_mode(new_map) & FMODE_WRITE)
@@ -913,6 +924,8 @@ static int do_resume(struct dm_ioctl *pa
 	if (!r)
 		r = __dev_status(md, param);
 
+out:
+	dm_unlock_resume(md);
 	dm_put(md);
 	return r;
 }
@@ -1209,6 +1222,20 @@ static int table_clear(struct dm_ioctl *
 		return -ENXIO;
 	}
 
+	md = hc->md;
+	up_write(&_hash_lock);
+
+	dm_lock_resume(md);
+
+	down_write(&_hash_lock);
+	hc = dm_get_mdptr(md);
+	if (!hc || hc->md != md) {
+		DMWARN("device has been removed from the dev hash table.");
+		up_write(&_hash_lock);
+		r = -ENXIO;
+		goto out;
+	}
+
 	if (hc->new_map) {
 		dm_table_destroy(hc->new_map);
 		hc->new_map = NULL;
@@ -1217,8 +1244,9 @@ static int table_clear(struct dm_ioctl *
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
 	r = __dev_status(hc->md, param);
-	md = hc->md;
 	up_write(&_hash_lock);
+out:
+	dm_unlock_resume(md);
 	dm_put(md);
 	return r;
 }
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -116,6 +116,12 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 struct mapped_device {
 	struct rw_semaphore io_lock;
 	struct mutex suspend_lock;
+	/*
+	 * Resuming inactive table lacks testable state during its
+	 * transition to being live.  Interlock allows other operations
+	 * (e.g. table_clear) to _know_ there isn't a live table yet.
+	 */
+	struct mutex resume_lock;
 	rwlock_t map_lock;
 	atomic_t holders;
 	atomic_t open_count;
@@ -1876,6 +1882,7 @@ static struct mapped_device *alloc_dev(i
 
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
+	mutex_init(&md->resume_lock);
 	spin_lock_init(&md->deferred_lock);
 	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
@@ -1997,6 +2004,16 @@ static void free_dev(struct mapped_devic
 	kfree(md);
 }
 
+void dm_lock_resume(struct mapped_device *md)
+{
+	mutex_lock(&md->resume_lock);
+}
+
+void dm_unlock_resume(struct mapped_device *md)
+{
+	mutex_unlock(&md->resume_lock);
+}
+
 static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
 	struct dm_md_mempools *p;
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h
+++ linux-2.6/drivers/md/dm.h
@@ -66,6 +66,9 @@ int dm_table_alloc_md_mempools(struct dm
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
+void dm_lock_resume(struct mapped_device *md);
+void dm_unlock_resume(struct mapped_device *md);
+
 /*
  * To check the return value from dm_table_find_target().
  */
