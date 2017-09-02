From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 11/31] libmultipath: get_refwwid: use
	get_udev_device
Date: Sun,  3 Sep 2017 00:38:40 +0200
Message-ID: <20170902223900.7339-12-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Call the factored-out function to obtain the udev device.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7326132b..7a3db318 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1176,12 +1176,12 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 
 		pp = find_path_by_dev(pathvec, buff);
 		if (!pp) {
-			struct udev_device *udevice = udev_device_new_from_subsystem_sysname(udev, "block", buff);
+			struct udev_device *udevice =
+				get_udev_device(buff, dev_type);
 
-			if (!udevice) {
-				condlog(2, "%s: can't get udev device", buff);
+			if (!udevice)
 				return 1;
-			}
+
 			conf = get_multipath_config();
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
@@ -1214,12 +1214,12 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		}
 		pp = find_path_by_dev(pathvec, buff);
 		if (!pp) {
-			struct udev_device *udevice = udev_device_new_from_devnum(udev, 'b', parse_devt(dev));
+			struct udev_device *udevice =
+				get_udev_device(dev, dev_type);
 
-			if (!udevice) {
-				condlog(2, "%s: can't get udev device", dev);
+			if (!udevice)
 				return 1;
-			}
+
 			conf = get_multipath_config();
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
@@ -1244,12 +1244,11 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 	}
 
 	if (dev_type == DEV_UEVENT) {
-		struct udev_device *udevice = udev_device_new_from_environment(udev);
+		struct udev_device *udevice = get_udev_device(dev, dev_type);
 
-		if (!udevice) {
-			condlog(2, "%s: can't get udev device", dev);
+		if (!udevice)
 			return 1;
-		}
+
 		conf = get_multipath_config();
 		ret = store_pathinfo(pathvec, conf, udevice,
 				     flags, &pp);
-- 
2.14.0
