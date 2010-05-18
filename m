From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH] dm-ioctl: Return data to userspace after
 rename ioctl is processed
Date: Tue, 18 May 2010 15:48:48 +0200
Message-ID: <4BF29AC0.7060208@redhat.com>
References: <4BC4894A.2090306@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BC4894A.2090306@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

An updated version based on Alasdair's comments: __dev_status call added.

Allow data to be returned to userspace after a rename ioctl is processed.
It carries important information for userspace code to react properly,
now checking new DM_UEVENT_GENERATED_FLAG that has been added recently.

Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>
---
 drivers/md/dm-ioctl.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..f67ec28 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -49,6 +49,7 @@ struct vers_iter {
 static struct list_head _name_buckets[NUM_BUCKETS];
 static struct list_head _uuid_buckets[NUM_BUCKETS];
 
+static int __dev_status(struct mapped_device *md, struct dm_ioctl *param);
 static void dm_hash_remove_all(int keep_open_devices);
 
 /*
@@ -285,12 +286,12 @@ retry:
 	up_write(&_hash_lock);
 }
 
-static int dm_hash_rename(uint32_t cookie, uint32_t *flags, const char *old,
-			  const char *new)
+static int dm_hash_rename(struct dm_ioctl *param, const char *new)
 {
 	char *new_name, *old_name;
 	struct hash_cell *hc;
 	struct dm_table *table;
+	int r;
 
 	/*
 	 * duplicate new.
@@ -307,7 +308,7 @@ static int dm_hash_rename(uint32_t cookie, uint32_t *flags, const char *old,
 	hc = __get_name_cell(new);
 	if (hc) {
 		DMWARN("asked to rename to an already existing name %s -> %s",
-		       old, new);
+		       param->name, new);
 		dm_put(hc->md);
 		up_write(&_hash_lock);
 		kfree(new_name);
@@ -317,10 +318,10 @@ static int dm_hash_rename(uint32_t cookie, uint32_t *flags, const char *old,
 	/*
 	 * Is there such a device as 'old' ?
 	 */
-	hc = __get_name_cell(old);
+	hc = __get_name_cell(param->name);
 	if (!hc) {
 		DMWARN("asked to rename a non existent device %s -> %s",
-		       old, new);
+		       param->name, new);
 		up_write(&_hash_lock);
 		kfree(new_name);
 		return -ENXIO;
@@ -345,13 +346,15 @@ static int dm_hash_rename(uint32_t cookie, uint32_t *flags, const char *old,
 		dm_table_put(table);
 	}
 
-	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie))
-		*flags |= DM_UEVENT_GENERATED_FLAG;
+	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, param->event_nr))
+		param->flags |= DM_UEVENT_GENERATED_FLAG;
+
+	r = __dev_status(hc->md, param);
 
 	dm_put(hc->md);
 	up_write(&_hash_lock);
 	kfree(old_name);
-	return 0;
+	return r;
 }
 
 /*-----------------------------------------------------------------
@@ -774,10 +777,7 @@ static int dev_rename(struct dm_ioctl *param, size_t param_size)
 	if (r)
 		return r;
 
-	param->data_size = 0;
-
-	return dm_hash_rename(param->event_nr, &param->flags, param->name,
-			      new_name);
+	return dm_hash_rename(param, new_name);
 }
 
 static int dev_set_geometry(struct dm_ioctl *param, size_t param_size)
