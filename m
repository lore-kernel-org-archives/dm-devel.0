From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v5 1/3] dm: export a table+mapped device to the ioctl interface
Date: Sat, 20 Feb 2016 10:13:50 -0800
Message-ID: <1455992032-14594-2-git-send-email-keescook@chromium.org>
References: <1455992032-14594-1-git-send-email-keescook@chromium.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1455992032-14594-1-git-send-email-keescook@chromium.org>
Sender: linux-doc-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, Dan Ehrenberg <dehrenberg@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chen Yu <yu.c.chen@intel.com>, Vishnu Pratap Singh <vishnu.ps@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, David Zeuthen <zeuthen@google.com>
List-Id: dm-devel.ids

From: Will Drewry <wad@chromium.org>

If a mapped device and table is configured without traversing the dm-ioctl
interface (dm-fs-style), then it will not be bound to a name or uuid. This
means that it will be inaccessible for userspace management and udev
will be unhappy with the lack of a name or uuid.

The function added in this change performs the required association to
transition to being managed by the ioctl interface.

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v5: resurrection
v4: https://patchwork.kernel.org/patch/104860/
---
 drivers/md/dm-ioctl.c         | 35 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  6 ++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 80a439543259..e0efc6844b3a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1923,6 +1923,41 @@ void dm_interface_exit(void)
 	dm_hash_exit();
 }
 
+
+/**
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
+	return r;
+}
 /**
  * dm_copy_name_and_uuid - Copy mapped device name & uuid into supplied buffers
  * @md: Pointer to mapped_device
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ec1c61c87d89..87afa0552398 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -381,6 +381,12 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
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
2.6.3

