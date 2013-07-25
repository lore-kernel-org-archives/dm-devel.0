From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: rport tmo cleanup
Date: Thu, 25 Jul 2013 16:32:13 -0500
Message-ID: <20130725213212.GH2113@dhcp80-209.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The current code to set fast_io_fail_tmo and dev_loss_tmo fails
if you want to set fast_io_fail_tmo from "off" to 600. Also,
it often unnecessarily sets dev_loss_tmo to itself before setting
it to the final value. This patch cleans up these issues.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |   79 ++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 37 deletions(-)

Index: multipath-tools-130724/libmultipath/discovery.c
===================================================================
--- multipath-tools-130724.orig/libmultipath/discovery.c
+++ multipath-tools-130724/libmultipath/discovery.c
@@ -322,9 +322,12 @@ sysfs_set_rport_tmo(struct multipath *mp
 	struct udev_device *rport_dev = NULL;
 	char value[16];
 	char rport_id[32];
-	unsigned long long tmo = 0;
+	int delay_fast_io_fail = 0;
+	int current_dev_loss = 0;
 	int ret;
 
+	if (!mpp->dev_loss && mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)
+		return;
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
 	rport_dev = udev_device_new_from_subsystem_sysname(conf->udev,
@@ -337,22 +340,8 @@ sysfs_set_rport_tmo(struct multipath *mp
 	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
 		pp->sg_id.channel, pp->sg_id.scsi_id, rport_id);
 
-	/*
-	 * This is tricky.
-	 * dev_loss_tmo will be limited to 600 if fast_io_fail
-	 * is _not_ set.
-	 * fast_io_fail will be limited by the current dev_loss_tmo
-	 * setting.
-	 * So to get everything right we first need to increase
-	 * dev_loss_tmo to the fast_io_fail setting (if present),
-	 * then set fast_io_fail, and _then_ set dev_loss_tmo
-	 * to the correct value.
-	 */
 	memset(value, 0, 16);
-	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
-	    mpp->fast_io_fail != MP_FAST_IO_FAIL_ZERO &&
-	    mpp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
-		/* Check if we need to temporarily increase dev_loss_tmo */
+	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		ret = sysfs_attr_get_value(rport_dev, "dev_loss_tmo",
 					   value, 16);
 		if (ret <= 0) {
@@ -360,38 +349,40 @@ sysfs_set_rport_tmo(struct multipath *mp
 				"error %d", rport_id, -ret);
 			goto out;
 		}
-		if (sscanf(value, "%llu\n", &tmo) != 1) {
+		if (sscanf(value, "%u\n", &current_dev_loss) != 1) {
 			condlog(0, "%s: Cannot parse dev_loss_tmo "
 				"attribute '%s'", rport_id, value);
 			goto out;
 		}
-		if (mpp->fast_io_fail >= tmo) {
-			snprintf(value, 16, "%u", mpp->fast_io_fail + 1);
-		}
-	} else if (mpp->dev_loss > 600) {
-		condlog(3, "%s: limiting dev_loss_tmo to 600, since "
-			"fast_io_fail is not set", rport_id);
-		snprintf(value, 16, "%u", 600);
-	} else {
-		snprintf(value, 16, "%u", mpp->dev_loss);
-	}
-	if (strlen(value)) {
-		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
-					   value, strlen(value));
-		if (ret <= 0) {
-			if (ret == -EBUSY)
-				condlog(3, "%s: rport blocked", rport_id);
+		if ((mpp->dev_loss &&
+		     mpp->fast_io_fail >= (int)mpp->dev_loss) ||
+	            (!mpp->dev_loss &&
+                     mpp->fast_io_fail >= (int)current_dev_loss)) {
+			condlog(3, "%s: limiting fast_io_fail_tmo to %d, since "
+                        	"it must be less than dev_loss_tmo",
+				rport_id, mpp->dev_loss - 1);
+			if (mpp->dev_loss)
+				mpp->fast_io_fail = mpp->dev_loss - 1;
 			else
-				condlog(0, "%s: failed to set dev_loss_tmo to %s, error %d",
-					rport_id, value, -ret);
-			goto out;
+				mpp->fast_io_fail = current_dev_loss - 1;
 		}
+		if (mpp->fast_io_fail >= (int)current_dev_loss)
+			delay_fast_io_fail = 1;
+	}
+	if (mpp->dev_loss > 600 &&
+	    (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF ||
+             mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET)) {
+		condlog(3, "%s: limiting dev_loss_tmo to 600, since "
+			"fast_io_fail is unset or off", rport_id);
+		mpp->dev_loss = 600;
 	}
 	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 			sprintf(value, "off");
 		else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
 			sprintf(value, "0");
+		else if (delay_fast_io_fail)
+			snprintf(value, 16, "%u", current_dev_loss - 1);
 		else
 			snprintf(value, 16, "%u", mpp->fast_io_fail);
 		ret = sysfs_attr_set_value(rport_dev, "fast_io_fail_tmo",
@@ -402,9 +393,10 @@ sysfs_set_rport_tmo(struct multipath *mp
 			else
 				condlog(0, "%s: failed to set fast_io_fail_tmo to %s, error %d",
 					rport_id, value, -ret);
+			goto out;
 		}
 	}
-	if (tmo > 0) {
+	if (mpp->dev_loss) {
 		snprintf(value, 16, "%u", mpp->dev_loss);
 		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
 					   value, strlen(value));
@@ -414,6 +406,19 @@ sysfs_set_rport_tmo(struct multipath *mp
 			else
 				condlog(0, "%s: failed to set dev_loss_tmo to %s, error %d",
 					rport_id, value, -ret);
+			goto out;
+		}
+	}
+	if (delay_fast_io_fail) {
+		snprintf(value, 16, "%u", mpp->fast_io_fail);
+		ret = sysfs_attr_set_value(rport_dev, "fast_io_fail_tmo",
+					   value, strlen(value));
+		if (ret <= 0) {
+			if (ret == -EBUSY)
+				condlog(3, "%s: rport blocked", rport_id);
+			else
+				condlog(0, "%s: failed to set fast_io_fail_tmo to %s, error %d",
+					rport_id, value, -ret);
 		}
 	}
 out:
