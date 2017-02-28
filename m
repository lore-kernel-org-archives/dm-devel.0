From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 26/33] libmultipath: reload map if not known to
	udev
Date: Tue, 28 Feb 2017 17:23:22 +0100
Message-ID: <20170228162329.14517-27-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

The previous changes skip map reload if the existing kernel
state appears correct. Sometimes, boot time race conditions
may cause a device to be correctly set up in the kernel but
not in udev. Check this condition, and reload map in this case.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index fb5a5a92..b400bb96 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -39,6 +39,7 @@
 #include "util.h"
 #include "uxsock.h"
 #include "wwids.h"
+#include "sysfs.h"
 
 /* group paths in pg by host adapter
  */
@@ -390,6 +391,35 @@ pgcmp (struct multipath * mpp, struct multipath * cmpp)
 	return r;
 }
 
+static struct udev_device *
+get_udev_for_mpp(const struct multipath *mpp)
+{
+	dev_t devnum;
+	struct udev_device *udd;
+
+	if (!mpp || !mpp->dmi) {
+		condlog(1, "%s called with empty mpp", __func__);
+		return NULL;
+	}
+
+	devnum = makedev(mpp->dmi->major, mpp->dmi->minor);
+	udd = udev_device_new_from_devnum(udev, 'b', devnum);
+	if (!udd) {
+		condlog(1, "failed to get udev device for %s", mpp->alias);
+		return NULL;
+	}
+	return udd;
+}
+
+static int
+is_mpp_known_to_udev(const struct multipath *mpp)
+{
+	struct udev_device *udd = get_udev_for_mpp(mpp);
+	int ret = (udd != NULL);
+	udev_device_unref(udd);
+	return ret;
+}
+
 static void
 select_action (struct multipath * mpp, vector curmp, int force_reload)
 {
@@ -529,6 +559,12 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			mpp->alias);
 		return;
 	}
+	if (!is_mpp_known_to_udev(cmpp)) {
+		mpp->action = ACT_RELOAD;
+		condlog(3, "%s: set ACT_RELOAD (udev device not initialized)",
+			mpp->alias);
+		return;
+	}
 	mpp->action = ACT_NOTHING;
 	condlog(3, "%s: set ACT_NOTHING (map unchanged)",
 		mpp->alias);
-- 
2.11.0
