From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 43/72] libmultipath: dev_loss_tmo is unsigned
Date: Sat, 12 Oct 2019 21:28:31 +0000
Message-ID: <20191012212703.12989-44-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Make MAX_DEV_LOSS_TMO reflect the fact that the kernel supports
timeouts up to UINT_MAX, and fix comparisons in discovery.c.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/defaults.h  |  4 +++-
 libmultipath/discovery.c | 13 ++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 4dfe007c..d7034655 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,5 +1,7 @@
 #ifndef _DEFAULTS_H
 #define _DEFAULTS_H
+#include <limits.h>
+
 /*
  * If you add or modify a value also update multipath/multipath.conf.5
  * and the TEMPLATE in libmultipath/hwtable.c
@@ -55,7 +57,7 @@
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
 
-#define MAX_DEV_LOSS_TMO	0x7FFFFFFF
+#define MAX_DEV_LOSS_TMO	UINT_MAX
 #define DEFAULT_PIDFILE		"/" RUN_DIR "/multipathd.pid"
 #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4d93c91b..5fbc2ac7 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -624,9 +624,10 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_ZERO &&
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
 		/* Check if we need to temporarily increase dev_loss_tmo */
-		if (mpp->fast_io_fail >= tmo) {
+		if ((unsigned int)mpp->fast_io_fail >= tmo) {
 			/* Increase dev_loss_tmo temporarily */
-			snprintf(value, 16, "%u", mpp->fast_io_fail + 1);
+			snprintf(value, sizeof(value), "%u",
+				 (unsigned int)mpp->fast_io_fail + 1);
 			ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
 						   value, strlen(value));
 			if (ret <= 0) {
@@ -757,10 +758,11 @@ sysfs_set_scsi_tmo (struct multipath *mpp, int checkint)
 {
 	struct path *pp;
 	int i;
-	int dev_loss_tmo = mpp->dev_loss;
+	unsigned int dev_loss_tmo = mpp->dev_loss;
 
 	if (mpp->no_path_retry > 0) {
-		uint64_t no_path_retry_tmo = (uint64_t)mpp->no_path_retry * checkint;
+		uint64_t no_path_retry_tmo =
+			(uint64_t)mpp->no_path_retry * checkint;
 
 		if (no_path_retry_tmo > MAX_DEV_LOSS_TMO)
 			no_path_retry_tmo = MAX_DEV_LOSS_TMO;
@@ -774,7 +776,8 @@ sysfs_set_scsi_tmo (struct multipath *mpp, int checkint)
 			mpp->alias, dev_loss_tmo);
 	}
 	mpp->dev_loss = dev_loss_tmo;
-	if (mpp->dev_loss && mpp->fast_io_fail >= (int)mpp->dev_loss) {
+	if (mpp->dev_loss && mpp->fast_io_fail > 0 &&
+	    (unsigned int)mpp->fast_io_fail >= mpp->dev_loss) {
 		condlog(3, "%s: turning off fast_io_fail (%d is not smaller than dev_loss_tmo)",
 			mpp->alias, mpp->fast_io_fail);
 		mpp->fast_io_fail = MP_FAST_IO_FAIL_OFF;
-- 
2.23.0
