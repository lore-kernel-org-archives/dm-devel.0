From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 01/04] dm: export name and uuid
Date: Wed, 17 Oct 2007 13:53:58 +0100
Message-ID: <20071017125358.GM24157@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch adds a function to obtain a copy of a mapped device's name and uuid.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-ioctl.c         |   32 ++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 33 insertions(+)

Index: linux-2.6.23/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-ioctl.c	2007-10-14 00:08:12.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-ioctl.c	2007-10-16 13:09:27.000000000 +0100
@@ -1515,3 +1515,35 @@ void dm_interface_exit(void)
 
 	dm_hash_exit();
 }
+
+/**
+ * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
+ * @md: Pointer to mapped_device
+ * @name: Buffer (size DM_NAME_LEN) for name
+ * @uuid: Buffer (size DM_UUID_LEN) for uuid or empty string if uuid not defined
+ */
+int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
+{
+	int r = 0;
+	struct hash_cell *hc;
+
+	if (!md)
+		return -ENXIO;
+
+	dm_get(md);
+	down_read(&_hash_lock);
+	hc = dm_get_mdptr(md);
+	if (!hc || hc->md != md) {
+		r = -ENXIO;
+		goto out;
+	}
+
+	strcpy(name, hc->name);
+	strcpy(uuid, hc->uuid ? : "");
+
+out:
+	up_read(&_hash_lock);
+	dm_put(md);
+
+	return r;
+}
Index: linux-2.6.23/include/linux/device-mapper.h
===================================================================
--- linux-2.6.23.orig/include/linux/device-mapper.h	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.23/include/linux/device-mapper.h	2007-10-14 00:08:31.000000000 +0100
@@ -188,6 +188,7 @@ int dm_wait_event(struct mapped_device *
  * Info functions.
  */
 const char *dm_device_name(struct mapped_device *md);
+int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
