From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 04/08] dm: use spinlock for _minor_lock
Date: Mon, 17 Apr 2006 11:16:02 -0400
Message-ID: <20060417151602.GA18954@locomotive.unixthugs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Device Mapper Development List <dm-devel@redhat.com>
List-Id: dm-devel.ids


 In order to truly serialize reference counting and properly handle the final
 dm_put, we need to use atomic_dec_and_lock, since another thread of execution
 can attempt to "resurrect" a potentially dead mapped_device.

 This patch replaces the _minor_lock mutex with a spinlock, and leverages
 atomic_dec_and_lock to properly serialize reference counting.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 drivers/md/dm.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/drivers/md/dm.c 2.6.17-rc1-staging2/drivers/md/dm.c
--- 2.6.17-rc1-staging1/drivers/md/dm.c	2006-04-17 10:51:45.000000000 -0400
+++ 2.6.17-rc1-staging2/drivers/md/dm.c	2006-04-17 10:51:45.000000000 -0400
@@ -26,6 +26,7 @@ static const char *_name = DM_NAME;
 static unsigned int major = 0;
 static unsigned int _major = 0;
 
+static DEFINE_SPINLOCK(_minor_lock);
 /*
  * One of these is allocated per bio.
  */
@@ -746,14 +747,13 @@ static int dm_any_congested(void *conges
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
-static DEFINE_MUTEX(_minor_lock);
 static DEFINE_IDR(_minor_idr);
 
 static void free_minor(unsigned int minor)
 {
-	mutex_lock(&_minor_lock);
+	spin_lock(&_minor_lock);
 	idr_remove(&_minor_idr, minor);
-	mutex_unlock(&_minor_lock);
+	spin_unlock(&_minor_lock);
 }
 
 /*
@@ -770,7 +770,7 @@ static int specific_minor(struct mapped_
 	if (!r)
 		return -ENOMEM;
 
-	mutex_lock(&_minor_lock);
+	spin_lock(&_minor_lock);
 
 	if (idr_find(&_minor_idr, minor)) {
 		r = -EBUSY;
@@ -789,7 +789,7 @@ static int specific_minor(struct mapped_
 	}
 
 out:
-	mutex_unlock(&_minor_lock);
+	spin_unlock(&_minor_lock);
 	return r;
 }
 
@@ -802,7 +802,7 @@ static int next_free_minor(struct mapped
 	if (!r)
 		return -ENOMEM;
 
-	mutex_lock(&_minor_lock);
+	spin_lock(&_minor_lock);
 
 	r = idr_get_new(&_minor_idr, MINOR_ALLOCED, &m);
 	if (r) {
@@ -818,7 +818,7 @@ static int next_free_minor(struct mapped
 	*minor = m;
 
 out:
-	mutex_unlock(&_minor_lock);
+	spin_unlock(&_minor_lock);
 	return r;
 }
 
@@ -888,9 +888,9 @@ static struct mapped_device *alloc_dev(u
 	init_waitqueue_head(&md->eventq);
 
 	/* Populate the mapping, nobody knows we exist yet */
-	mutex_lock(&_minor_lock);
+	spin_lock(&_minor_lock);
 	old_ide = idr_replace(&_minor_idr, md, minor);
-	mutex_unlock(&_minor_lock);
+	spin_unlock(&_minor_lock);
 
 	BUG_ON(old_ide != MINOR_ALLOCED);
 
@@ -1021,13 +1021,13 @@ static struct mapped_device *dm_find_md(
 	if (MAJOR(dev) != _major || minor >= (1 << MINORBITS))
 		return NULL;
 
-	mutex_lock(&_minor_lock);
+	spin_lock(&_minor_lock);
 
 	md = idr_find(&_minor_idr, minor);
 	if (md && (md == MINOR_ALLOCED || (dm_disk(md)->first_minor != minor)))
 		md = NULL;
 
-	mutex_unlock(&_minor_lock);
+	spin_unlock(&_minor_lock);
 
 	return md;
 }
@@ -1061,11 +1061,10 @@ void dm_put(struct mapped_device *md)
 {
 	struct dm_table *map;
 
-	if (atomic_dec_and_test(&md->holders)) {
+	if (atomic_dec_and_lock(&md->holders, &_minor_lock)) {
 		map = dm_get_table(md);
-		mutex_lock(&_minor_lock);
 		idr_replace(&_minor_idr, MINOR_ALLOCED, md->disk->first_minor);
-		mutex_unlock(&_minor_lock);
+		spin_unlock(&_minor_lock);
 		if (!dm_suspended(md)) {
 			dm_table_presuspend_targets(map);
 			dm_table_postsuspend_targets(map);
