From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/3] libmultipath: add uid failback for dasd
	devices
Date: Tue, 15 Sep 2020 16:45:11 -0500
Message-ID: <1600206312-6497-3-git-send-email-bmarzins@redhat.com>
References: <1600206312-6497-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1600206312-6497-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Add failback code to get the uid for dasd devices from sysfs. Copied
from dasdinfo

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h  |  1 +
 libmultipath/discovery.c | 37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 39a5e415..947ba467 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -8,6 +8,7 @@
  */
 #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
 #define DEFAULT_NVME_UID_ATTRIBUTE	"ID_WWN"
+#define DEFAULT_DASD_UID_ATTRIBUTE	"ID_UID"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
 #define DEFAULT_SELECTOR	"service-time 0"
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3f1b1d71..2096fb48 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1950,12 +1950,44 @@ get_vpd_uid(struct path * pp)
 	return get_vpd_sysfs(parent, 0x83, pp->wwid, WWID_SIZE);
 }
 
+/* based on code from s390-tools/dasdinfo/dasdinfo.c */
+static ssize_t dasd_get_uid(struct path *pp)
+{
+	struct udev_device *parent;
+	char value[80];
+	char *p;
+	int i;
+
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev, "ccw",
+							       NULL);
+	if (!parent)
+		return -1;
+
+	if (sysfs_attr_get_value(parent, "uid", value, 80) < 0)
+		return -1;
+
+	p = value - 1;
+	/* look for the 4th '.' and cut there */
+	for (i = 0; i < 4; i++) {
+		p = index(p + 1, '.');
+		if (!p)
+			break;
+	}
+	if (p)
+		*p = '\0';
+
+	return strlcpy(pp->wwid, value, WWID_SIZE);
+}
+
 static ssize_t uid_fallback(struct path *pp, int path_state,
 			    const char **origin)
 {
 	ssize_t len = -1;
 
-	if (pp->bus == SYSFS_BUS_SCSI) {
+	if (pp->bus == SYSFS_BUS_CCW) {
+		len = dasd_get_uid(pp);
+		*origin = "sysfs";
+	} else if (pp->bus == SYSFS_BUS_SCSI) {
 		len = get_vpd_uid(pp);
 		*origin = "sysfs";
 		if (len < 0 && path_state == PATH_UP) {
@@ -2003,6 +2035,9 @@ static bool has_uid_fallback(struct path *pp)
 		  !strcmp(pp->uid_attribute, ""))) ||
 		(pp->bus == SYSFS_BUS_NVME &&
 		 (!strcmp(pp->uid_attribute, DEFAULT_NVME_UID_ATTRIBUTE) ||
+		  !strcmp(pp->uid_attribute, ""))) ||
+		(pp->bus == SYSFS_BUS_CCW &&
+		 (!strcmp(pp->uid_attribute, DEFAULT_DASD_UID_ATTRIBUTE) ||
 		  !strcmp(pp->uid_attribute, ""))));
 }
 
-- 
2.17.2
