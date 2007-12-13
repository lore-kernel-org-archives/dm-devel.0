From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 04/06] dm: trigger change uevent on rename
Date: Thu, 13 Dec 2007 14:43:26 +0000
Message-ID: <20071213144326.GW24157@agk.fab.redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Scott James Remnant <scott@ubuntu.com>
List-Id: dm-devel.ids

From: Alasdair G Kergon <agk@redhat.com>

Insert a missing KOBJ_CHANGE notification when a device is renamed.

Cc: Scott James Remnant <scott@ubuntu.com> 
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c |    2 ++
 drivers/md/dm.c       |    7 ++++++-
 drivers/md/dm.h       |    2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc5/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm-ioctl.c	2007-12-12 15:43:06.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm-ioctl.c	2007-12-12 15:43:13.000000000 +0000
@@ -332,6 +332,8 @@ static int dm_hash_rename(const char *ol
 		dm_table_put(table);
 	}
 
+	dm_kobject_uevent(hc->md);
+
 	dm_put(hc->md);
 	up_write(&_hash_lock);
 	kfree(old_name);
Index: linux-2.6.24-rc5/drivers/md/dm.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm.c	2007-12-12 15:43:06.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm.c	2007-12-12 15:43:13.000000000 +0000
@@ -1514,7 +1514,7 @@ int dm_resume(struct mapped_device *md)
 
 	dm_table_unplug_all(map);
 
-	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
+	dm_kobject_uevent(md);
 
 	r = 0;
 
@@ -1528,6 +1528,11 @@ out:
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
+void dm_kobject_uevent(struct mapped_device *md)
+{
+	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
+}
+
 uint32_t dm_next_uevent_seq(struct mapped_device *md)
 {
 	return atomic_add_return(1, &md->uevent_seq);
Index: linux-2.6.24-rc5/drivers/md/dm.h
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm.h	2007-12-12 15:43:06.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm.h	2007-12-12 15:43:13.000000000 +0000
@@ -187,4 +187,6 @@ union map_info *dm_get_mapinfo(struct bi
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
+void dm_kobject_uevent(struct mapped_device *md);
+
 #endif
