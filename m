From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH v6 2/3] dm: export a table+mapped device to the
	ioctl interface
Date: Tue, 18 Apr 2017 18:42:39 +0200
Message-ID: <20170418164240.18079-3-enric.balletbo@collabora.com>
References: <20170418164240.18079-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170418164240.18079-1-enric.balletbo@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Guenter Roeck <groeck@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

From: Will Drewry <wad@chromium.org>

One function is added which allows for a programmatically created
mapped device to be inserted into the dm-ioctl hash table. This binds
the device to a name and, optional, uuid which is needed by udev and
allows for userspace management of the mapped device.

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
v6: none
v5: resurrection
v4: https://patchwork.kernel.org/patch/104860/
---
 drivers/md/dm-ioctl.c         | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  6 ++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 4951bf9..f4c610f 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1924,6 +1924,42 @@ void dm_interface_exit(void)
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
+	if (!md)
+		return -ENXIO;
+
+	/* The name and uuid can only be set once. */
+	mutex_lock(&dm_hash_cells_mutex);
+	hc = dm_get_mdptr(md);
+	mutex_unlock(&dm_hash_cells_mutex);
+	if (hc) {
+		DMERR("%s: already exported", dm_device_name(md));
+		return -ENXIO;
+	}
+
+	r = dm_hash_insert(name, uuid, md);
+	if (r) {
+		DMERR("%s: could not bind to '%s'", dm_device_name(md), name);
+		return r;
+	}
+
+	/* Let udev know we've changed. */
+	dm_kobject_uevent(md, KOBJ_CHANGE, dm_get_event_nr(md));
+
+	return r;
+}
+
+/**
  * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
  * @md: Pointer to mapped_device
  * @name: Buffer (size DM_NAME_LEN) for name
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 9f70b21..2efac3b 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -412,6 +412,12 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
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
