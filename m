From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 02/08] dm: use idr_replace for minor_idr
Date: Mon, 17 Apr 2006 11:16:02 -0400
Message-ID: <20060417151602.GA18928@locomotive.unixthugs.org>
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


 A patch was submitted in August 2004 to replace the old bitmap minor
 allocation tracking with an IDR to both track allocation and provide
 a mapping.

 This works pretty well in execution, but the author overlooked a pretty
 important detail. With the old bitmap, it was enough to just mark the
 minor as allocated and return it. With the IDR code, the mapped_device
 is used to mark the minor as in use. The problem with that approach is
 that the mapped_device isn't done initializing, and is placed on a
 subsystem-wide data structure, which is then unlocked. Even if the
 assignment was delayed or the lock was held until initialization
 completed, there would still be a race when we register the disk with
 the block subsystem since we'd need a minor to register, but we'd need
 to be done registering before making the device available.

 This patch uses a place holder value, MINOR_ALLOCED, to mark the minor
 as allocated but in a state where it can't be used, such as
 mid-allocation or mid-free. At the end of the initialization, we
 replace the place holder with the pointer to the mapped_device, making
 it available to the rest of the dm subsystem.

 During the free process, we again use the place holder value in the
 IDR to indicate the minor is allocated but unavailable for use.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 drivers/md/dm.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/drivers/md/dm.c 2.6.17-rc1-staging2/drivers/md/dm.c
--- 2.6.17-rc1-staging1/drivers/md/dm.c	2006-04-13 20:22:45.000000000 -0400
+++ 2.6.17-rc1-staging2/drivers/md/dm.c	2006-04-17 10:51:42.000000000 -0400
@@ -54,6 +54,8 @@ union map_info *dm_get_mapinfo(struct bi
         return NULL;
 }
 
+#define MINOR_ALLOCED ((void *)-1)
+
 /*
  * Bits for the md->flags field.
  */
@@ -777,7 +779,7 @@ static int specific_minor(struct mapped_
 		goto out;
 	}
 
-	r = idr_get_new_above(&_minor_idr, md, minor, &m);
+	r = idr_get_new_above(&_minor_idr, MINOR_ALLOCED, minor, &m);
 	if (r) {
 		goto out;
 	}
@@ -806,7 +808,7 @@ static int next_free_minor(struct mapped
 		goto out;
 	}
 
-	r = idr_get_new(&_minor_idr, md, &m);
+	r = idr_get_new(&_minor_idr, MINOR_ALLOCED, &m);
 	if (r) {
 		goto out;
 	}
@@ -833,6 +835,7 @@ static struct mapped_device *alloc_dev(u
 {
 	int r;
 	struct mapped_device *md = kmalloc(sizeof(*md), GFP_KERNEL);
+	void *old_ide;
 
 	if (!md) {
 		DMWARN("unable to allocate device, out of memory.");
@@ -888,6 +891,13 @@ static struct mapped_device *alloc_dev(u
 	init_waitqueue_head(&md->wait);
 	init_waitqueue_head(&md->eventq);
 
+	/* Populate the mapping, nobody knows we exist yet */
+	mutex_lock(&_minor_lock);
+	old_ide = idr_replace(&_minor_idr, md, minor);
+	mutex_unlock(&_minor_lock);
+
+	BUG_ON(old_ide != MINOR_ALLOCED);
+
 	return md;
 
  bad4:
@@ -1018,7 +1028,7 @@ static struct mapped_device *dm_find_md(
 	mutex_lock(&_minor_lock);
 
 	md = idr_find(&_minor_idr, minor);
-	if (!md || (dm_disk(md)->first_minor != minor))
+	if (md && (md == MINOR_ALLOCED || (dm_disk(md)->first_minor != minor)))
 		md = NULL;
 
 	mutex_unlock(&_minor_lock);
@@ -1057,6 +1067,9 @@ void dm_put(struct mapped_device *md)
 
 	if (atomic_dec_and_test(&md->holders)) {
 		map = dm_get_table(md);
+		mutex_lock(&_minor_lock);
+		idr_replace(&_minor_idr, MINOR_ALLOCED, md->disk->first_minor);
+		mutex_unlock(&_minor_lock);
 		if (!dm_suspended(md)) {
 			dm_table_presuspend_targets(map);
 			dm_table_postsuspend_targets(map);
