From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 70/78] multipathd: use SG_IO as fallback to
	generate uid
Date: Mon, 16 Mar 2015 13:36:57 +0100
Message-ID: <1426509425-15978-71-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

If both udev attribute and sysfs vpd fails to generate a valid
WWID fallback to use SG_IO directly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 61 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 11 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 50444db..009ef0c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -998,7 +998,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 }
 
 static int
-get_vpd (struct udev_device *parent, int fd, int pg, char * str, int maxlen)
+get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
 {
 	int len, buff_len;
 	unsigned char buff[4096];
@@ -1006,11 +1006,39 @@ get_vpd (struct udev_device *parent, int fd, int pg, char * str, int maxlen)
 	memset(buff, 0x0, 4096);
 	if (!parent || sysfs_get_vpd(parent, pg, buff, 4096) <= 0) {
 		condlog(3, "failed to read sysfs vpd pg%02x", pg);
-		if (sgio_get_vpd(buff, 4096, fd) <= 0) {
-			condlog(3, "failed to issue vpd inquiry for pg%02x",
-				pg);
-			return -errno;
-		}
+		return -EINVAL;
+	}
+
+	if (buff[1] != pg) {
+		condlog(3, "vpd pg%02x error, invalid vpd page %02x",
+			pg, buff[1]);
+		return -ENODATA;
+	}
+	buff_len = (buff[2] << 8) + buff[3] + 4;
+	if (buff_len > 4096)
+		condlog(3, "vpd pg%02x page truncated", pg);
+
+	if (pg == 0x80)
+		len = parse_vpd_pg80(buff, str, maxlen);
+	else if (pg == 0x83)
+		len = parse_vpd_pg83(buff, buff_len, str, maxlen);
+	else
+		len = -ENOSYS;
+
+	return len;
+}
+
+static int
+get_vpd_sgio (int fd, int pg, char * str, int maxlen)
+{
+	int len, buff_len;
+	unsigned char buff[4096];
+
+	memset(buff, 0x0, 4096);
+	if (sgio_get_vpd(buff, 4096, fd) <= 0) {
+		condlog(3, "failed to issue vpd inquiry for pg%02x",
+			pg);
+		return -errno;
 	}
 
 	if (buff[1] != pg) {
@@ -1344,7 +1372,7 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 	if (!attr_path || pp->sg_id.host_no == -1)
 		return -ENODEV;
 
-	if (get_vpd(parent, pp->fd, 0x80, pp->serial, SERIAL_SIZE) > 0)
+	if (get_vpd_sysfs(parent, 0x80, pp->serial, SERIAL_SIZE) > 0)
 		condlog(3, "%s: serial = %s",
 			pp->dev, pp->serial);
 
@@ -1474,7 +1502,7 @@ get_vpd_uid(struct path * pp)
 		parent = udev_device_get_parent(parent);
 	}
 
-	return get_vpd(parent, pp->fd, 0x83, pp->wwid, WWID_SIZE);
+	return get_vpd_sysfs(parent, 0x83, pp->wwid, WWID_SIZE);
 }
 
 static int
@@ -1513,19 +1541,30 @@ get_uid (struct path * pp)
 		if (pp->uid_attribute) {
 			len = get_udev_uid(pp, pp->uid_attribute);
 			origin = "udev";
+			if (len <= 0)
+				condlog(2,
+					"%s: failed to get UID attribute '%s'",
+					pp->dev, pp->uid_attribute);
 		}
 		if (len <= 0) {
 			len = get_vpd_uid(pp);
 			if (len > 0) {
 				origin = "sysfs";
 				pp->uid_attribute = NULL;
+			} else {
+				condlog(2, "%s: failed to get sysfs vpd pg83",
+					pp->dev);
 			}
 		}
 		if (len <= 0) {
-			len = get_udev_uid(pp, DEFAULT_UID_ATTRIBUTE);
+			len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
+					   WWID_SIZE);
 			if (len > 0) {
-				origin = "default";
-				pp->uid_attribute = DEFAULT_UID_ATTRIBUTE;
+				origin = "sgio";
+				pp->uid_attribute = NULL;
+			} else {
+				condlog(2, "%s: failed to get sgio vpd pg83",
+					pp->dev);
 			}
 		}
 	}
-- 
1.8.4.5
