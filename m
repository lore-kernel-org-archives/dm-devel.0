From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 17/18] multipath: check for NULL from
	udev_device_get_*
Date: Sat, 12 Jan 2013 00:04:54 -0600
Message-ID: <1357970695-3396-17-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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

The udev_device_get_* functions can return NULL, an occassionally do
so in the multipathd code.  multipath needs to check if the result
is NULL before dereferencing it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b8a5cd1..831cfef 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -113,6 +113,7 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 
 	udev_list_entry_foreach(entry,
 				udev_enumerate_get_list_entry(udev_iter)) {
+		const char *devtype;
 		devpath = udev_list_entry_get_name(entry);
 		condlog(4, "Discover device %s", devpath);
 		udevice = udev_device_new_from_syspath(conf->udev, devpath);
@@ -121,7 +122,8 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 			r++;
 			continue;
 		}
-		if(!strncmp(udev_device_get_devtype(udevice), "disk", 4))
+		devtype = udev_device_get_devtype(udevice);
+		if(devtype && !strncmp(devtype, "disk", 4))
 			r += path_discover(pathvec, conf, udevice, flag);
 		udev_device_unref(udevice);
 	}
@@ -459,7 +461,8 @@ scsi_sysfs_pathinfo (struct path * pp)
 
 	parent = pp->udev;
 	while (parent) {
-		if (!strncmp(udev_device_get_subsystem(parent), "scsi", 4)) {
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "scsi", 4)) {
 			attr_path = udev_device_get_sysname(parent);
 			if (!attr_path)
 				break;
@@ -525,7 +528,8 @@ ccw_sysfs_pathinfo (struct path * pp)
 
 	parent = pp->udev;
 	while (parent) {
-		if (!strncmp(udev_device_get_subsystem(parent), "ccw", 3))
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "ccw", 3))
 			break;
 		parent = udev_device_get_parent(parent);
 	}
@@ -581,7 +585,8 @@ cciss_sysfs_pathinfo (struct path * pp)
 
 	parent = pp->udev;
 	while (parent) {
-		if (!strncmp(udev_device_get_subsystem(parent), "cciss", 5)) {
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "cciss", 5)) {
 			attr_path = udev_device_get_sysname(parent);
 			if (!attr_path)
 				break;
@@ -662,7 +667,8 @@ path_offline (struct path * pp)
 
 	parent = pp->udev;
 	while (parent) {
-		if (!strncmp(udev_device_get_subsystem(parent), "scsi", 4))
+		const char *subsys = udev_device_get_subsystem(parent);
+		if (subsys && !strncmp(subsys, "scsi", 4))
 			break;
 		parent = udev_device_get_parent(parent);
 	}
-- 
1.8.0
