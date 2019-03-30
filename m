From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 11/17] libmultipath: add get_uid fallback code
	for NVMe devices
Date: Sat, 30 Mar 2019 01:06:00 -0500
Message-ID: <1553925966-20958-12-git-send-email-bmarzins@redhat.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If multipath can't get the uid for NVMe devices from udev, it can get it
directly from sysfs.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 49 ++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 28c00e5..bece67c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1754,8 +1754,8 @@ get_vpd_uid(struct path * pp)
 	return get_vpd_sysfs(parent, 0x83, pp->wwid, WWID_SIZE);
 }
 
-static ssize_t scsi_uid_fallback(struct path *pp, int path_state,
-			     const char **origin, ssize_t old_len)
+static ssize_t uid_fallback(struct path *pp, int path_state,
+			    const char **origin, ssize_t old_len)
 {
 	ssize_t len = old_len;
 	int retrigger;
@@ -1764,17 +1764,36 @@ static ssize_t scsi_uid_fallback(struct path *pp, int path_state,
 	conf = get_multipath_config();
 	retrigger = conf->retrigger_tries;
 	put_multipath_config(conf);
-	if (pp->retriggers >= retrigger &&
-	    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
-		len = get_vpd_uid(pp);
-		*origin = "sysfs";
-		pp->uid_attribute = NULL;
-		if (len < 0 && path_state == PATH_UP) {
-			condlog(1, "%s: failed to get sysfs uid: %s",
-				pp->dev, strerror(-len));
-			len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
-					   WWID_SIZE);
-			*origin = "sgio";
+	if (pp->retriggers >= retrigger) {
+		if (pp->bus == SYSFS_BUS_SCSI &&
+		    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
+			len = get_vpd_uid(pp);
+			*origin = "sysfs";
+			pp->uid_attribute = NULL;
+			if (len < 0 && path_state == PATH_UP) {
+				condlog(1, "%s: failed to get sysfs uid: %s",
+					pp->dev, strerror(-len));
+				len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
+						   WWID_SIZE);
+				*origin = "sgio";
+			}
+		} else if (pp->bus == SYSFS_BUS_NVME) {
+			char value[256];
+			len = sysfs_attr_get_value(pp->udev, "wwid", value,
+						   sizeof(value));
+			if (len <= 0)
+				return -1;
+			len = strlcpy(pp->wwid, value, WWID_SIZE);
+			if (len >= WWID_SIZE) {
+				len = fix_broken_nvme_wwid(pp, value,
+							   WWID_SIZE);
+				if (len > 0)
+					return len;
+				condlog(0, "%s: wwid overflow", pp->dev);
+				len = WWID_SIZE;
+			}
+			*origin = "sysfs";
+			pp->uid_attribute = NULL;
 		}
 	}
 	return len;
@@ -1827,8 +1846,8 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 			len = get_vpd_uid(pp);
 			origin = "sysfs";
 		}
-		if (len <= 0 && pp->bus == SYSFS_BUS_SCSI)
-			len = scsi_uid_fallback(pp, path_state, &origin, len);
+		if (len <= 0)
+			len = uid_fallback(pp, path_state, &origin, len);
 	}
 	if ( len < 0 ) {
 		condlog(1, "%s: failed to get %s uid: %s",
-- 
2.17.2
