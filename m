From: Guangliang Zhao <gzhao@suse.com>
Subject: [PATCH 2/3] dm raid1: add interface to set resync speed
Date: Thu, 22 Nov 2012 14:27:52 +0800
Message-ID: <1353565673-4233-3-git-send-email-gzhao@suse.com>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1353565673-4233-1-git-send-email-gzhao@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Add ioctl to control resync speed, userspace tool
is dmsetup message, message format is:
	dmsetup message $device 0 "set $speed"
e.g.
	dmsetup message /dev/dm-2 "set 12345"

Signed-off-by: Guangliang Zhao <gzhao@suse.com>
---
 drivers/md/dm-raid1.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index fb87779..1da25eb 100644
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
+ *	set speed(KB/s)
+ */
+static int mirror_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct mirror_set *ms = ti->private;
+	unsigned int speed;
+	int ret = 0;
+
+	if (!strcasecmp(argv[0], "set")) {
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
