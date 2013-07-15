From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/29] multipathd: valgrind fixes
Date: Mon, 15 Jul 2013 15:00:26 +0200
Message-ID: <1373893230-26077-26-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

valgrind complained about uninitialized memory.
As usual, valgrind was right, although the memory never was
actually referenced.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   27 +++++++++++++++++----------
 libmultipath/sysfs.c     |    6 ++++--
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 092930a..c59dbc2 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -321,7 +321,7 @@ static void
 sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 {
 	struct udev_device *rport_dev = NULL;
-	char value[11];
+	char value[16];
 	char rport_id[32];
 	unsigned long long tmo = 0;
 	int ret;
@@ -349,7 +349,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	 * then set fast_io_fail, and _then_ set dev_loss_tmo
 	 * to the correct value.
 	 */
-	value[0] = '\0';
+	memset(value, 0, 16);
 	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_ZERO &&
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
@@ -367,17 +367,18 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 			goto out;
 		}
 		if (mpp->fast_io_fail >= tmo) {
-			snprintf(value, 11, "%u", mpp->fast_io_fail);
+			snprintf(value, 16, "%u", mpp->fast_io_fail);
 		}
 	} else if (mpp->dev_loss > 600) {
 		condlog(3, "%s: limiting dev_loss_tmo to 600, since "
 			"fast_io_fail is not set", rport_id);
-		snprintf(value, 11, "%u", 600);
+		snprintf(value, 16, "%u", 600);
 	} else {
-		snprintf(value, 11, "%u", mpp->dev_loss);
+		snprintf(value, 16, "%u", mpp->dev_loss);
 	}
 	if (strlen(value)) {
-		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11);
+		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
+					   value, strlen(value));
 		if (ret <= 0) {
 			if (ret == -EBUSY)
 				condlog(3, "%s: rport blocked", rport_id);
@@ -393,9 +394,9 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 		else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
 			sprintf(value, "0");
 		else
-			snprintf(value, 11, "%u", mpp->fast_io_fail);
+			snprintf(value, 16, "%u", mpp->fast_io_fail);
 		ret = sysfs_attr_set_value(rport_dev, "fast_io_fail_tmo",
-					   value, 11);
+					   value, strlen(value));
 		if (ret <= 0) {
 			if (ret == -EBUSY)
 				condlog(3, "%s: rport blocked", rport_id);
@@ -405,9 +406,9 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 		}
 	}
 	if (tmo > 0) {
-		snprintf(value, 11, "%u", mpp->dev_loss);
+		snprintf(value, 16, "%u", mpp->dev_loss);
 		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
-					   value, 11);
+					   value, strlen(value));
 		if (ret <= 0) {
 			if (ret == -EBUSY)
 				condlog(3, "%s: rport blocked", rport_id);
@@ -809,6 +810,9 @@ cciss_sysfs_pathinfo (struct path * pp)
 static int
 common_sysfs_pathinfo (struct path * pp)
 {
+	if (!pp)
+		return 1;
+
 	if (!pp->udev) {
 		condlog(4, "%s: udev not initialised", pp->dev);
 		return 1;
@@ -1059,6 +1063,9 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 {
 	int path_state;
 
+	if (!pp)
+		return 1;
+
 	condlog(3, "%s: mask = 0x%x", pp->dev, mask);
 
 	/*
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 0670e0a..8ba27d4 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -102,7 +102,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	int fd;
 	ssize_t size = -1;
 
-	if (!dev || !attr_name || !value)
+	if (!dev || !attr_name || !value || !value_len)
 		return 0;
 
 	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
@@ -152,9 +152,10 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 	char attr[255];
 	int r;
 
-	if (!pp->udev)
+	if (!pp->udev || !size)
 		return 1;
 
+	attr[0] = '\0';
 	if (sysfs_attr_get_value(pp->udev, "size", attr, 255) == 0) {
 		condlog(3, "%s: No size attribute in sysfs", pp->dev);
 		return 1;
@@ -164,6 +165,7 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 
 	if (r != 1) {
 		condlog(3, "%s: Cannot parse size attribute", pp->dev);
+		*size = 0;
 		return 1;
 	}
 
-- 
1.7.10.4
