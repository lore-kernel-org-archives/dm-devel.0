From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: fix libudev bug in
	sysfs_get_tgt_nodename
Date: Mon, 11 Jun 2012 16:32:35 -0500
Message-ID: <20120611213235.GE3211@ether.msp.redhat.com>
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
List-Id: dm-devel.ids

In a recent patch, I introduced a bug into sysfs_get_tgt_nodename().
multipath must not unreference the target udevice before it copies the
tgt_nodename to another location, otherwise the value pointer will be
pointing at freed memory.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Index: multipath-tools-120518/libmultipath/discovery.c
===================================================================
--- multipath-tools-120518.orig/libmultipath/discovery.c
+++ multipath-tools-120518/libmultipath/discovery.c
@@ -215,11 +215,13 @@ sysfs_get_tgt_nodename (struct path *pp,
 		const char *value;
 
 		value = udev_device_get_sysattr_value(tgtdev, "node_name");
-		udev_device_unref(tgtdev);
 		if (value) {
 			strncpy(node, value, NODE_NAME_SIZE);
+			udev_device_unref(tgtdev);
 			return 0;
 		}
+		else
+			udev_device_unref(tgtdev);
 	}
 
 	/* Check for iSCSI */
@@ -238,11 +240,13 @@ sysfs_get_tgt_nodename (struct path *pp,
 			const char *value;
 
 			value = udev_device_get_sysattr_value(tgtdev, "targetname");
-			udev_device_unref(tgtdev);
 			if (value) {
 				strncpy(node, value, NODE_NAME_SIZE);
+				udev_device_unref(tgtdev);
 				return 0;
 			}
+			else
+				udev_device_unref(tgtdev);
 		}
 	}
 	return 1;
