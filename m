From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] RFC: Changing dm core (1/5): Make _hash_lock
	extern
Date: Thu, 16 Mar 2006 19:17:05 -0500
Message-ID: <441A0001.8050707@ce.jp.nec.com>
References: <4419FF61.9050501@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060008050200070201000809"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4419FF61.9050501@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060008050200070201000809
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

This patch makes _hash_lock extern so that dm.c can touch it.
It's renamed to dm_sem.

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------060008050200070201000809
Content-Type: text/x-patch;
 name="01-dm-sem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-dm-sem.patch"

Rename _hash_lock to dm_sem and make it extern for dm.c.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

--- linux-2.6.16-rc6-mm1-dm.orig/drivers/md/dm.h	2006-03-13 12:16:38.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.01-dm-sem/drivers/md/dm.h	2006-03-16 16:24:31.000000000 -0500
@@ -172,6 +172,7 @@ int dm_split_args(int *argc, char ***arg
  */
 int dm_interface_init(void);
 void dm_interface_exit(void);
+extern struct rw_semaphore dm_sem;
 
 /*
  * Targets for linear and striped mappings
--- linux-2.6.16-rc6-mm1-dm.orig/drivers/md/dm-ioctl.c	2006-03-13 11:20:09.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.01-dm-sem/drivers/md/dm-ioctl.c	2006-03-13 17:35:40.000000000 -0500
@@ -52,7 +52,7 @@ static void dm_hash_remove_all(void);
 /*
  * Guards access to both hash tables.
  */
-static DECLARE_RWSEM(_hash_lock);
+DECLARE_RWSEM(dm_sem);
 
 static void init_buckets(struct list_head *buckets)
 {
@@ -202,7 +202,7 @@ static int dm_hash_insert(const char *na
 	/*
 	 * Insert the cell into both hash tables.
 	 */
-	down_write(&_hash_lock);
+	down_write(&dm_sem);
 	if (__get_name_cell(name))
 		goto bad;
 
@@ -218,12 +218,12 @@ static int dm_hash_insert(const char *na
 	register_with_devfs(cell);
 	dm_get(md);
 	dm_set_mdptr(md, cell);
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 
 	return 0;
 
  bad:
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 	free_cell(cell);
 	return -EBUSY;
 }
@@ -256,14 +256,14 @@ static void dm_hash_remove_all(void)
 	struct hash_cell *hc;
 	struct list_head *tmp, *n;
 
-	down_write(&_hash_lock);
+	down_write(&dm_sem);
 	for (i = 0; i < NUM_BUCKETS; i++) {
 		list_for_each_safe (tmp, n, _name_buckets + i) {
 			hc = list_entry(tmp, struct hash_cell, name_list);
 			__hash_remove(hc);
 		}
 	}
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 }
 
 static int dm_hash_rename(const char *old, const char *new)
@@ -279,7 +279,7 @@ static int dm_hash_rename(const char *ol
 	if (!new_name)
 		return -ENOMEM;
 
-	down_write(&_hash_lock);
+	down_write(&dm_sem);
 
 	/*
 	 * Is new free ?
@@ -288,7 +288,7 @@ static int dm_hash_rename(const char *ol
 	if (hc) {
 		DMWARN("asked to rename to an already existing name %s -> %s",
 		       old, new);
-		up_write(&_hash_lock);
+		up_write(&dm_sem);
 		kfree(new_name);
 		return -EBUSY;
 	}
@@ -300,7 +300,7 @@ static int dm_hash_rename(const char *ol
 	if (!hc) {
 		DMWARN("asked to rename a non existent device %s -> %s",
 		       old, new);
-		up_write(&_hash_lock);
+		up_write(&dm_sem);
 		kfree(new_name);
 		return -ENXIO;
 	}
@@ -327,7 +327,7 @@ static int dm_hash_rename(const char *ol
 		dm_table_put(table);
 	}
 
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 	kfree(old_name);
 	return 0;
 }
@@ -382,7 +382,7 @@ static int list_devices(struct dm_ioctl 
 	struct gendisk *disk;
 	struct dm_name_list *nl, *old_nl = NULL;
 
-	down_write(&_hash_lock);
+	down_write(&dm_sem);
 
 	/*
 	 * Loop through all the devices working out how much
@@ -427,7 +427,7 @@ static int list_devices(struct dm_ioctl 
 	}
 
  out:
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 	return 0;
 }
 
@@ -623,7 +623,7 @@ static struct mapped_device *find_device
 	struct hash_cell *hc;
 	struct mapped_device *md = NULL;
 
-	down_read(&_hash_lock);
+	down_read(&dm_sem);
 	hc = __find_device_hash_cell(param);
 	if (hc) {
 		md = hc->md;
@@ -644,7 +644,7 @@ static struct mapped_device *find_device
 		else
 			param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 	}
-	up_read(&_hash_lock);
+	up_read(&dm_sem);
 
 	return md;
 }
@@ -653,17 +653,17 @@ static int dev_remove(struct dm_ioctl *p
 {
 	struct hash_cell *hc;
 
-	down_write(&_hash_lock);
+	down_write(&dm_sem);
 	hc = __find_device_hash_cell(param);
 
 	if (!hc) {
 		DMWARN("device doesn't appear to be in the dev hash table.");
-		up_write(&_hash_lock);
+		up_write(&dm_sem);
 		return -ENXIO;
 	}
 
 	__hash_remove(hc);
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 	param->data_size = 0;
 	return 0;
 }
@@ -731,12 +731,12 @@ static int do_resume(struct dm_ioctl *pa
 	struct mapped_device *md;
 	struct dm_table *new_map;
 
-	down_write(&_hash_lock);
+	down_write(&dm_sem);
 
 	hc = __find_device_hash_cell(param);
 	if (!hc) {
 		DMWARN("device doesn't appear to be in the dev hash table.");
-		up_write(&_hash_lock);
+		up_write(&dm_sem);
 		return -ENXIO;
 	}
 
@@ -747,7 +747,7 @@ static int do_resume(struct dm_ioctl *pa
 	hc->new_map = NULL;
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 
 	/* Do we need to load a new map ? */
 	if (new_map) {
@@ -1001,12 +1001,12 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
-	down_write(&_hash_lock);
+	down_write(&dm_sem);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
 		DMWARN("device has been removed from the dev hash table.");
 		dm_table_put(t);
-		up_write(&_hash_lock);
+		up_write(&dm_sem);
 		r = -ENXIO;
 		goto out;
 	}
@@ -1014,7 +1014,7 @@ static int table_load(struct dm_ioctl *p
 	if (hc->new_map)
 		dm_table_put(hc->new_map);
 	hc->new_map = t;
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 
 	param->flags |= DM_INACTIVE_PRESENT_FLAG;
 	r = __dev_status(md, param);
@@ -1030,12 +1030,12 @@ static int table_clear(struct dm_ioctl *
 	int r;
 	struct hash_cell *hc;
 
-	down_write(&_hash_lock);
+	down_write(&dm_sem);
 
 	hc = __find_device_hash_cell(param);
 	if (!hc) {
 		DMWARN("device doesn't appear to be in the dev hash table.");
-		up_write(&_hash_lock);
+		up_write(&dm_sem);
 		return -ENXIO;
 	}
 
@@ -1047,7 +1047,7 @@ static int table_clear(struct dm_ioctl *
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
 	r = __dev_status(hc->md, param);
-	up_write(&_hash_lock);
+	up_write(&dm_sem);
 	return r;
 }
 

--------------060008050200070201000809
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060008050200070201000809--
