From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 06/08] dm: fix refcounting
Date: Mon, 17 Apr 2006 11:16:02 -0400
Message-ID: <20060417151602.GA18977@locomotive.unixthugs.org>
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


 For the most part, reference counting in the dm code is ok, but it must be
 taken under the _minor_lock. There are paths where a mapped_device pointer
 is returned and then a reference is taken - and taking the reference may be
 too late.

 This patch fixes a number of paths so that the reference is always taken
 under the lock.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 drivers/md/dm-ioctl.c |   21 ++++++++++++++-------
 drivers/md/dm.c       |   14 +++-----------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/drivers/md/dm.c 2.6.17-rc1-staging2/drivers/md/dm.c
--- 2.6.17-rc1-staging1/drivers/md/dm.c	2006-04-17 10:51:48.000000000 -0400
+++ 2.6.17-rc1-staging2/drivers/md/dm.c	2006-04-17 10:51:48.000000000 -0400
@@ -1026,7 +1026,7 @@ int dm_create_with_minor(unsigned int mi
 	return create_aux(minor, 1, result);
 }
 
-static struct mapped_device *dm_find_md(dev_t dev)
+struct mapped_device *dm_get_md(dev_t dev)
 {
 	struct mapped_device *md;
 	unsigned minor = MINOR(dev);
@@ -1043,6 +1043,8 @@ static struct mapped_device *dm_find_md(
 	if (md) {
 		if (test_bit(DMF_FREEING, &md->flags))
 			md = NULL;
+		else
+			dm_get(md);
 	}
 
 	spin_unlock(&_minor_lock);
@@ -1050,16 +1052,6 @@ static struct mapped_device *dm_find_md(
 	return md;
 }
 
-struct mapped_device *dm_get_md(dev_t dev)
-{
-	struct mapped_device *md = dm_find_md(dev);
-
-	if (md)
-		dm_get(md);
-
-	return md;
-}
-
 void *dm_get_mdptr(struct mapped_device *md)
 {
 	return md->interface_ptr;
diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/drivers/md/dm-ioctl.c 2.6.17-rc1-staging2/drivers/md/dm-ioctl.c
--- 2.6.17-rc1-staging1/drivers/md/dm-ioctl.c	2006-04-13 20:22:45.000000000 -0400
+++ 2.6.17-rc1-staging2/drivers/md/dm-ioctl.c	2006-04-17 10:51:48.000000000 -0400
@@ -102,8 +102,10 @@ static struct hash_cell *__get_name_cell
 	unsigned int h = hash_str(str);
 
 	list_for_each_entry (hc, _name_buckets + h, name_list)
-		if (!strcmp(hc->name, str))
+		if (!strcmp(hc->name, str)) {
+			dm_get(hc->md);
 			return hc;
+		}
 
 	return NULL;
 }
@@ -114,8 +116,10 @@ static struct hash_cell *__get_uuid_cell
 	unsigned int h = hash_str(str);
 
 	list_for_each_entry (hc, _uuid_buckets + h, uuid_list)
-		if (!strcmp(hc->uuid, str))
+		if (!strcmp(hc->uuid, str)) {
+			dm_get(hc->md);
 			return hc;
+		}
 
 	return NULL;
 }
@@ -611,10 +615,8 @@ static struct hash_cell *__find_device_h
 		return __get_name_cell(param->name);
 
 	md = dm_get_md(huge_decode_dev(param->dev));
-	if (md) {
+	if (md)
 		mdptr = dm_get_mdptr(md);
-		dm_put(md);
-	}
 
 	return mdptr;
 }
@@ -628,7 +630,6 @@ static struct mapped_device *find_device
 	hc = __find_device_hash_cell(param);
 	if (hc) {
 		md = hc->md;
-		dm_get(md);
 
 		/*
 		 * Sneakily write in both the name and the uuid
@@ -653,6 +654,7 @@ static struct mapped_device *find_device
 static int dev_remove(struct dm_ioctl *param, size_t param_size)
 {
 	struct hash_cell *hc;
+	struct mapped_device *md;
 
 	down_write(&_hash_lock);
 	hc = __find_device_hash_cell(param);
@@ -663,8 +665,11 @@ static int dev_remove(struct dm_ioctl *p
 		return -ENXIO;
 	}
 
+	md = hc->md;
+
 	__hash_remove(hc);
 	up_write(&_hash_lock);
+	dm_put(md);
 	param->data_size = 0;
 	return 0;
 }
@@ -790,7 +795,6 @@ static int do_resume(struct dm_ioctl *pa
 	}
 
 	md = hc->md;
-	dm_get(md);
 
 	new_map = hc->new_map;
 	hc->new_map = NULL;
@@ -1078,6 +1082,7 @@ static int table_clear(struct dm_ioctl *
 {
 	int r;
 	struct hash_cell *hc;
+	struct mapped_device *md;
 
 	down_write(&_hash_lock);
 
@@ -1096,7 +1101,9 @@ static int table_clear(struct dm_ioctl *
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
 	r = __dev_status(hc->md, param);
+	md = hc->md;
 	up_write(&_hash_lock);
+	dm_put(md);
 	return r;
 }
 
