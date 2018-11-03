From: Helen Koike <helen.koike@collabora.com>
Subject: [PATCH v10 1/2] dm ioctl: add a device mapper ioctl function.
Date: Sat,  3 Nov 2018 00:53:40 -0300
Message-ID: <20181103035341.16893-2-helen.koike@collabora.com>
References: <20181103035341.16893-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181103035341.16893-1-helen.koike@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: agk@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, enric.balletbo@collabora.com, wad@chromium.org, linux-doc@vger.kernel.org, linux-lvm@redhat.com, kernel@collabora.com, richard.weinberger@gmail.com, keescook@chromium.org
List-Id: dm-devel.ids

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

Add a dm_ioctl_cmd to issue the equivalent of a DM ioctl call in kernel.

Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>

---

Changes since v9:
 - https://www.redhat.com/archives/linux-lvm/2018-September/msg00016.html
 - Reorganize variables
---
 drivers/md/dm-ioctl.c         | 49 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  6 +++++
 2 files changed, 55 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f666778ad237..ae34c2030a9c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2018,3 +2018,52 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
 
 	return r;
 }
+
+/**
+ * dm_ioctl_cmd - Device mapper ioctl's
+ * @command: ioctl command
+ * @param: Pointer to device mapped ioctl struct
+ */
+int dm_ioctl_cmd(uint command, struct dm_ioctl *param)
+{
+	struct file *filp = NULL;
+	size_t input_param_size;
+	int ioctl_flags, r;
+	unsigned int cmd;
+	ioctl_fn fn;
+
+	if (_IOC_TYPE(command) != DM_IOCTL)
+		return -ENOTTY;
+
+	/* DM_DEV_ARM_POLL is not supported */
+	if (command == DM_DEV_ARM_POLL)
+		return -EINVAL;
+
+	cmd = _IOC_NR(command);
+
+	/*
+	 * Nothing more to do for the version command.
+	 */
+	if (cmd == DM_VERSION_CMD)
+		return 0;
+
+	fn = lookup_ioctl(cmd, &ioctl_flags);
+	if (!fn) {
+		DMWARN("dm_ioctl: unknown command 0x%x", command);
+		return -ENOTTY;
+	}
+
+	input_param_size = param->data_size;
+	r = validate_params(cmd, param);
+	if (r)
+		return r;
+
+	param->data_size = sizeof(*param);
+	r = fn(filp, param, input_param_size);
+
+	if (unlikely(param->flags & DM_BUFFER_FULL_FLAG) &&
+	    unlikely(ioctl_flags & IOCTL_FLAGS_NO_PARAMS))
+		DMERR("ioctl %d tried to output some data but has IOCTL_FLAGS_NO_PARAMS set", cmd);
+
+	return r;
+}
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index d7bee8669f10..8b2e4ae6a498 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/math64.h>
 #include <linux/ratelimit.h>
+#include <linux/dm-ioctl.h>
 
 struct dm_dev;
 struct dm_target;
@@ -423,6 +424,11 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio,
 			  sector_t start);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
+/*
+ * Device mapper ioctl function.
+ */
+int dm_ioctl_cmd(unsigned int command, struct dm_ioctl *param);
+
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
 
 /*
-- 
2.19.1
