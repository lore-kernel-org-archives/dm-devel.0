From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: make tgt_node_name work for iscsi
	devices
Date: Thu, 12 Jan 2012 22:14:56 -0600
Message-ID: <20120113041456.GL1241@ether.msp.redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

tgt_node_name wasn't displaying anything for iscsi devices. With this
change, if multipath can't get the node_name, it will check
sys/devices/platform/hostX/sessionY/iscsi_session/sessionY/targetname
and if this is available, it will get the node name from there.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |   20 ++++++++++++++++++--
 libmultipath/structs.h   |    2 +-
 2 files changed, 19 insertions(+), 3 deletions(-)

Index: multipath-tools-111219/libmultipath/discovery.c
===================================================================
--- multipath-tools-111219.orig/libmultipath/discovery.c
+++ multipath-tools-111219/libmultipath/discovery.c
@@ -210,10 +210,11 @@ sysfs_get_size (struct sysfs_device * de
 }
 
 int
-sysfs_get_fc_nodename (struct sysfs_device * dev, char * node,
+sysfs_get_tgt_nodename (struct sysfs_device * dev, char * node,
 		       unsigned int host, unsigned int channel,
 		       unsigned int target)
 {
+	unsigned int checkhost, session;
 	char attr_path[SYSFS_PATH_SIZE];
 	size_t len;
 
@@ -225,6 +226,21 @@ sysfs_get_fc_nodename (struct sysfs_devi
 	}
 
 	len = sysfs_attr_get_value(attr_path, "node_name", node, NODE_NAME_SIZE);
+	if (len)
+		return 0;
+
+	if (sscanf(dev->devpath, "/devices/platform/host%u/session%u/",
+	           &checkhost, &session) != 2)
+		return 1;
+	if (checkhost != host)
+		return 1;
+	if (safe_sprintf(attr_path, "/devices/platform/host%u/session%u/iscsi_session/session%u", host, session, session)) {
+		condlog(0, "attr_path too small");
+		return 1;
+	}
+
+	len = sysfs_attr_get_value(attr_path, "targetname", node,
+				   NODE_NAME_SIZE);
 	if (!len)
 		return 1;
 
@@ -562,7 +578,7 @@ scsi_sysfs_pathinfo (struct path * pp, s
 	/*
 	 * target node name
 	 */
-	if(!sysfs_get_fc_nodename(parent, pp->tgt_node_name,
+	if(!sysfs_get_tgt_nodename(parent, pp->tgt_node_name,
 				 pp->sg_id.host_no,
 				 pp->sg_id.channel,
 				 pp->sg_id.scsi_id)) {
Index: multipath-tools-111219/libmultipath/structs.h
===================================================================
--- multipath-tools-111219.orig/libmultipath/structs.h
+++ multipath-tools-111219/libmultipath/structs.h
@@ -5,7 +5,7 @@
 
 #define WWID_SIZE		128
 #define SERIAL_SIZE		65
-#define NODE_NAME_SIZE		65
+#define NODE_NAME_SIZE		224
 #define PATH_STR_SIZE		16
 #define PARAMS_SIZE		1024
 #define FILE_NAME_SIZE		256
