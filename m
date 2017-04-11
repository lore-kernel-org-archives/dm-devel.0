From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 3/5] dm: export a table+mapped device to the ioctl interface
Date: Tue, 11 Apr 2017 17:33:42 +0200
Message-ID: <20170411153344.27092-4-enric.balletbo@collabora.com>
References: <20170411153344.27092-1-enric.balletbo@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170411153344.27092-1-enric.balletbo@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Will Drewry <wad@chromium.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Will Drewry <wad@chromium.org>

One function is added which allows for a programmatically created
mapped device to be inserted into the dm-ioctl hash table. This binds
the device to a name and, optional, uuid which is needed by udev and
allows for userspace management of the mapped device.

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/md/dm-ioctl.c         | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  6 ++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 4da6fc6..cdd7a14 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1929,6 +1929,45 @@ void dm_interface_exit(void)
 }
 
 /**
+ * dm_ioctl_export - Permanently export a mapped device via the ioctl interface
+ * @md: Pointer to mapped_device
+ * @name: Buffer (size DM_NAME_LEN) for name
+ * @uuid: Buffer (size DM_UUID_LEN) for uuid or NULL if not desired
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name,
+		    const char *uuid)
+{
+	int r = 0;
+	struct hash_cell *hc;
+
+	if (!md) {
+		r = -ENXIO;
+		goto out;
+	}
+
+	/* The name and uuid can only be set once. */
+	mutex_lock(&dm_hash_cells_mutex);
+	hc = dm_get_mdptr(md);
+	mutex_unlock(&dm_hash_cells_mutex);
+	if (hc) {
+		DMERR("%s: already exported", dm_device_name(md));
+		r = -ENXIO;
+		goto out;
+	}
+
+	r = dm_hash_insert(name, uuid, md);
+	if (r) {
+		DMERR("%s: could not bind to '%s'", dm_device_name(md), name);
+		goto out;
+	}
+
+	/* Let udev know we've changed. */
+	dm_kobject_uevent(md, KOBJ_CHANGE, dm_get_event_nr(md));
+out:
+	return r;
+}
+
+/**
  * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
  * @md: Pointer to mapped_device
  * @name: Buffer (size DM_NAME_LEN) for name
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 013ac2e..b60892e 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -405,6 +405,12 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
 void *dm_get_mdptr(struct mapped_device *md);
 
 /*
+ * Export the device via the ioctl interface (uses mdptr).
+ */
+int dm_ioctl_export(struct mapped_device *md, const char *name,
+		    const char *uuid);
+
+/*
  * A device can still be used while suspended, but I/O is deferred.
  */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
-- 
2.9.3
