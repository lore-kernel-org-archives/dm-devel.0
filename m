From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] libmultipath: get_uid: check VPD pages for
	SCSI only
Date: Tue,  6 Mar 2018 23:15:47 +0100
Message-ID: <20180306221550.10030-2-mwilck@suse.com>
References: <20180306221550.10030-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180306221550.10030-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The VPD code won't work for non-SCSI devices, anyway. For indentation
reasons, I moved the "retrigger_tries" case to a separate function,
which is also called only for SCSI devices.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 50 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3d38a2550980..53182a85fa10 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1807,9 +1807,38 @@ get_vpd_uid(struct path * pp)
 		parent = udev_device_get_parent(parent);
 	}
 
+	if (!parent)
+		return -EINVAL;
+
 	return get_vpd_sysfs(parent, 0x83, pp->wwid, WWID_SIZE);
 }
 
+static ssize_t scsi_uid_fallback(struct path *pp, int path_state,
+			     const char **origin)
+{
+	ssize_t len = 0;
+	int retrigger;
+	struct config *conf;
+
+	conf = get_multipath_config();
+	retrigger = conf->retrigger_tries;
+	put_multipath_config(conf);
+	if (pp->retriggers >= retrigger &&
+	    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
+		len = get_vpd_uid(pp);
+		*origin = "sysfs";
+		pp->uid_attribute = NULL;
+		if (len < 0 && path_state == PATH_UP) {
+			condlog(1, "%s: failed to get sysfs uid: %s",
+				pp->dev, strerror(-len));
+			len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
+					   WWID_SIZE);
+			*origin = "sgio";
+		}
+	}
+	return len;
+}
+
 int
 get_uid (struct path * pp, int path_state, struct udev_device *udev)
 {
@@ -1851,7 +1880,6 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 		len = get_rbd_uid(pp);
 		origin = "sysfs";
 	} else {
-		int retrigger;
 
 		if (pp->uid_attribute) {
 			len = get_udev_uid(pp, pp->uid_attribute, udev);
@@ -1861,26 +1889,12 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 					"%s: failed to get udev uid: %s",
 					pp->dev, strerror(-len));
 
-		} else {
+		} else if (pp->bus == SYSFS_BUS_SCSI) {
 			len = get_vpd_uid(pp);
 			origin = "sysfs";
 		}
-		conf = get_multipath_config();
-		retrigger = conf->retrigger_tries;
-		put_multipath_config(conf);
-		if (len <= 0 && pp->retriggers >= retrigger &&
-		    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
-			len = get_vpd_uid(pp);
-			origin = "sysfs";
-			pp->uid_attribute = NULL;
-			if (len < 0 && path_state == PATH_UP) {
-				condlog(1, "%s: failed to get sysfs uid: %s",
-					pp->dev, strerror(-len));
-				len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
-						   WWID_SIZE);
-				origin = "sgio";
-			}
-		}
+		if (len <= 0 && pp->bus == SYSFS_BUS_SCSI)
+			len = scsi_uid_fallback(pp, path_state, &origin);
 	}
 	if ( len < 0 ) {
 		condlog(1, "%s: failed to get %s uid: %s",
-- 
2.16.1
