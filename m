From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmultipath: trigger uevents for partitions, too
Date: Tue, 2 Jul 2019 22:09:42 +0000
Message-ID: <20190702220911.16157-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

We have added code to re-trigger uevents in various cases where
the status of a device changes from multipath to non-multipath,
or vice-versa. When multipathd triggers uevents for paths of a map
because the status of the map has changed, it needs to trigger
events for the partitions of the path devices, too. The kernel
doesn't do this automatically.

Fixes: c5023200 libmultipath: indicate wwid failure in dm_addmap_create()
Fixes: e5d3c3a0 libmultipath: trigger change uevent on new device creation
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index af4d78de..9f100008 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -519,6 +519,42 @@ trigger_udev_change(const struct multipath *mpp)
 	udev_device_unref(udd);
 }
 
+static void trigger_partitions_udev_change(struct udev_device *dev,
+					   const char *action, int len)
+{
+	struct udev_enumerate *part_enum;
+	struct udev_list_entry *item;
+
+	part_enum = udev_enumerate_new(udev);
+	if (!part_enum)
+		return;
+
+	if (udev_enumerate_add_match_parent(part_enum, dev) < 0 ||
+	    udev_enumerate_add_match_subsystem(part_enum, "block") < 0 ||
+	    udev_enumerate_scan_devices(part_enum) < 0)
+		goto unref;
+
+	udev_list_entry_foreach(item,
+				udev_enumerate_get_list_entry(part_enum)) {
+		const char *syspath;
+		struct udev_device *part;
+
+		syspath = udev_list_entry_get_name(item);
+		part = udev_device_new_from_syspath(udev, syspath);
+		if (!part)
+			continue;
+
+		if (!strcmp("partition", udev_device_get_devtype(part))) {
+			condlog(4, "%s: triggering %s event for %s", __func__,
+				action, syspath);
+			sysfs_attr_set_value(part, "uevent", action, len);
+		}
+		udev_device_unref(part);
+	}
+unref:
+	udev_enumerate_unref(part_enum);
+}
+
 void
 trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
 {
@@ -569,6 +605,8 @@ trigger_paths_udev_change(struct multipath *mpp, bool is_mpath)
 				action, pp->dev, is_mpath ? "" : "no ");
 			sysfs_attr_set_value(pp->udev, "uevent",
 					     action, strlen(action));
+			trigger_partitions_udev_change(pp->udev, action,
+						       strlen(action));
 		}
 	}
 
-- 
2.22.0
