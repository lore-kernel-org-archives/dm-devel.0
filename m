From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 67/78] libmultipath: Fall back to SG_IO if no UID
	could be assigned
Date: Mon, 16 Mar 2015 13:36:54 +0100
Message-ID: <1426509425-15978-68-git-send-email-hare@suse.de>
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

Relying on udev attributes or sysfs vpd pages might fail,
in which case we're unable to assign an UID and multipath
will fail to start up.
Implement a fallback to read VPD page 0x83 directly in
these cases.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 53 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f8a0503..d5dda2c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -770,6 +770,29 @@ get_serial (char * str, int maxlen, int fd)
 	return 1;
 }
 
+#define DEFAULT_SGIO_LEN 254
+
+static int
+sgio_get_vpd (unsigned char * buff, int maxlen, int fd)
+{
+	int len = DEFAULT_SGIO_LEN;
+
+	if (fd < 0) {
+		errno = EBADF;
+		return -1;
+	}
+retry:
+	if (0 == do_inq(fd, 0, 1, 0x83, buff, len)) {
+		len = buff[3] + (buff[2] << 8);
+		if (len >= maxlen)
+			return len;
+		if (len > DEFAULT_SGIO_LEN)
+			goto retry;
+		return 0;
+	}
+	return -1;
+}
+
 static int
 get_geometry(struct path *pp)
 {
@@ -788,15 +811,19 @@ get_geometry(struct path *pp)
 }
 
 static int
-get_vpd (struct udev_device *parent, int pg, char * str, int maxlen)
+get_vpd (struct udev_device *parent, int fd, int pg, char * str, int maxlen)
 {
 	int len = -ENODATA, buff_len;
 	unsigned char buff[4096];
 
 	memset(buff, 0x0, 4096);
-	if (sysfs_get_vpd(parent, pg, buff, 4096) <= 0) {
-		condlog(3, "failed to get vpd pg%02x", pg);
-		return -EIO;
+	if (!parent || sysfs_get_vpd(parent, pg, buff, 4096) <= 0) {
+		condlog(3, "failed to read sysfs vpd pg%02x", pg);
+		if (sgio_get_vpd(buff, 4096, fd) <= 0) {
+			condlog(3, "failed to issue vpd inquiry for pg%02x",
+				pg);
+			return -errno;
+		}
 	}
 
 	if (buff[1] != pg) {
@@ -1298,7 +1325,7 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 	if (!attr_path || pp->sg_id.host_no == -1)
 		return -ENODEV;
 
-	if (get_vpd(parent, 0x80, pp->serial, SERIAL_SIZE) > 0)
+	if (get_vpd(parent, pp->fd, 0x80, pp->serial, SERIAL_SIZE) > 0)
 		condlog(3, "%s: serial = %s",
 			pp->dev, pp->serial);
 
@@ -1428,11 +1455,7 @@ get_vpd_uid(struct path * pp)
 		parent = udev_device_get_parent(parent);
 	}
 
-	if (!parent) {
-		condlog(3, "%s: no scsi device found in sysfs", pp->dev);
-		return -ENXIO;
-	}
-	return get_vpd(parent, 0x83, pp->wwid, WWID_SIZE);
+	return get_vpd(parent, pp->fd, 0x83, pp->wwid, WWID_SIZE);
 }
 
 static int
@@ -1471,14 +1494,16 @@ get_uid (struct path * pp)
 		if (pp->uid_attribute) {
 			len = get_udev_uid(pp, pp->uid_attribute);
 			origin = "udev";
-		} else {
+		}
+		if (len <= 0) {
 			len = get_vpd_uid(pp);
 			if (len > 0)
 				origin = "sysfs";
-			else {
-				len = get_udev_uid(pp, DEFAULT_UID_ATTRIBUTE);
+		}
+		if (len <= 0) {
+			len = get_udev_uid(pp, DEFAULT_UID_ATTRIBUTE);
+			if (len > 0)
 				origin = "udev";
-			}
 		}
 	}
 	if ( len < 0 ) {
-- 
1.8.4.5
