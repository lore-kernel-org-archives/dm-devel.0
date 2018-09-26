From: Helen Koike <helen.koike@collabora.com>
Subject: [PATCH 1/2] dm ioctl: add a device mapper ioctl function.
Date: Wed, 26 Sep 2018 01:45:46 -0300
Message-ID: <bb62cb08eceb53a5558f6c655bc003fbf35d87d6.1537936397.git.helen.koike@collabora.com>
References: <cover.1537936397.git.helen.koike@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1537936397.git.helen.koike@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

Add a dm_ioctl_cmd to issue the equivalent of a DM ioctl call in kernel.

Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/md/dm-ioctl.c         | 50 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  6 +++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b810ea77e6b1..68ce2557c62b 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2024,3 +2024,53 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
 
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
+	int r = 0;
+	int ioctl_flags;
+	unsigned int cmd;
+	ioctl_fn fn = NULL;
+	size_t input_param_size;
+	struct file *filp = NULL;
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
index 6fb0808e87c8..df5a5a60f9aa 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/math64.h>
 #include <linux/ratelimit.h>
+#include <linux/dm-ioctl.h>
 
 struct dm_dev;
 struct dm_target;
@@ -424,6 +425,11 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio,
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
2.19.0
