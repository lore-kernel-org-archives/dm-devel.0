From: Guangliang Zhao <gzhao@suse.com>
Subject: [PATCH 2/3 v2] dm raid1: add interface to set resync speed
Date: Mon, 17 Dec 2012 16:26:36 +0800
Message-ID: <1355732797-7233-3-git-send-email-gzhao@suse.com>
References: <1355732797-7233-1-git-send-email-gzhao@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1355732797-7233-1-git-send-email-gzhao@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
List-Id: dm-devel.ids

Add ioctl to control resync speed, userspace tool
is dmsetup message, message format is:
	dmsetup message $device 0 "set-max-resync-speed $speed"
e.g.
	dmsetup message /dev/dm-2 "set-max-resync-speed 12345"

Signed-off-by: Guangliang Zhao <gzhao@suse.com>
---
 drivers/md/dm-raid1.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 43e428a..3cdad37 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1361,6 +1361,49 @@ static void mirror_resume(struct dm_target *ti)
 }
 
 /*
+ * convert speed into members of ratelimit_state
+ */
+static void speed_to_rlimit(struct mirror_set *ms, struct ratelimit_state *rl,
+			    unsigned int speed)
+{
+	sector_t region_size = dm_rh_get_region_size(ms->rh);
+
+	rl->interval = RESYNC_JIFFIES;
+	rl->burst = (speed * (RESYNC_JIFFIES / HZ)) << 1;
+	rl->burst = DIV_ROUND_UP(rl->burst, region_size);
+}
+
+/*
+ * Message interface
+ *	set-max-resync-speed $speed(KB/s)
+ */
+static int mirror_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct mirror_set *ms = ti->private;
+	unsigned int speed;
+	int ret = 0;
+
+	if (!strcasecmp(argv[0], "set-max-resync-speed")) {
+		if (sscanf(argv[1], "%u", &speed) != 1) {
+			DMWARN("invalid speed parameter %s", argv[1]);
+			ret = -EINVAL;
+			goto error;
+		}
+
+		speed_to_rlimit(ms, &ms->ms_rlimit, speed);
+		goto out;
+	} else {
+		ret = -EINVAL;
+		goto error;
+	}
+
+error:
+	DMWARN("unrecognised message received.");
+out:
+	return ret;
+}
+
+/*
  * device_status_char
  * @m: mirror device/leg we want the status of
  *
@@ -1450,6 +1493,7 @@ static struct target_type mirror_target = {
 	.presuspend = mirror_presuspend,
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
+	.message = mirror_message,
 	.status	 = mirror_status,
 	.iterate_devices = mirror_iterate_devices,
 };
-- 
1.7.10.4
