From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 3/4] Subject: dm: add name and uuid env values
Date: Tue, 25 Sep 2007 23:19:54 -0700
Message-ID: <20070926061954.28432.17930.stgit@desktop-andmike.beaverton.ibm.com>
References: <20070926061939.28432.8382.stgit@desktop-andmike.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070926061939.28432.8382.stgit@desktop-andmike.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch obtains DM_NAME and DM_UUID from the dm hash cell structure.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---

 drivers/md/dm-ioctl.c         |   33 +++++++++++++++++++++++++++++++++
 drivers/md/dm-uevent.c        |   12 ++++++++++++
 include/linux/device-mapper.h |    1 +
 3 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 46bc83c..49fd786 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/dm-ioctl.h>
 #include <linux/hdreg.h>
+#include <linux/kobject.h>
 
 #include <asm/uaccess.h>
 
@@ -1515,3 +1516,35 @@ void dm_interface_exit(void)
 
 	dm_hash_exit();
 }
+
+int dm_ue_uuid_name_get(struct kobj_uevent_env *env, struct mapped_device *md)
+{
+	int r = 0;
+	struct hash_cell *hc;
+
+	if (!md)
+		return -ENXIO;
+
+	dm_get(md);
+	down_write(&_hash_lock);
+	hc = dm_get_mdptr(md);
+	if (!hc || hc->md != md) {
+		r = -ENXIO;
+		goto out;
+	}
+
+	if (add_uevent_var(env, "DM_NAME=%s", hc->name)) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	if (add_uevent_var(env, "DM_UUID=%s", hc->uuid)) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+out:
+	up_write(&_hash_lock);
+	dm_put(md);
+	return r;
+}
diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
index 888b9dc..61ca7b1 100644
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -128,6 +128,18 @@ void dm_send_uevents(struct list_head *events, struct kobject *kobj)
 
 	list_for_each_entry_safe(evt, next, events, elist) {
 		list_del_init(&evt->elist);
+
+		/*
+		 * Need to get the uuid here for now. Context of previous
+		 * var adds and locking used for hash_cell not compatable.
+		 */
+		if (dm_ue_uuid_name_get(&evt->ku_env, evt->md)) {
+			DMERR("%s: dm_ue_uuid_name_get() failed",
+			      __FUNCTION__);
+			dm_uevent_free(evt);
+			continue;
+		}
+
 		r = kobject_uevent_env(kobj, evt->action, evt->ku_env.envp);
 		if (r)
 			DMERR("%s: kobject_uevent_env failed", __FUNCTION__);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1373ae9..70b6dc3 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -185,6 +185,7 @@ uint32_t dm_get_event_nr(struct mapped_device *md);
 int dm_wait_event(struct mapped_device *md, int event_nr);
 uint32_t dm_next_uevent_seq(struct mapped_device *md);
 void dm_uevent_add(struct mapped_device *md, struct list_head *elist);
+int dm_ue_uuid_name_get(struct kobj_uevent_env *env, struct mapped_device *md);
 
 /*
  * Info functions.
