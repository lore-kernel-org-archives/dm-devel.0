From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c structs.h
Date: 10 Oct 2011 03:03:18 -0000
Message-ID: <20111010030318.15102.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2011-10-10 03:03:18

Modified files:
	libmultipath   : discovery.c structs.h 

Log message:
	Fix for bz #650759. tgt_node_name wasn't working for iscsi devices.  multipath
	now tries
	devices/platform/host<x>/session<y>/iscsi_session:session<y>/targetname
	
	if
	
	class/fc_transport/target<x>:<y>:<z>/node_name
	
	fails.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.21&r2=1.32.2.22
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.9&r2=1.18.2.10

--- multipath-tools/libmultipath/discovery.c	2011/07/20 21:24:52	1.32.2.21
+++ multipath-tools/libmultipath/discovery.c	2011/10/10 03:03:17	1.32.2.22
@@ -733,15 +733,35 @@
 		condlog(0, "attr_path too small");
 		return 1;
 	}
-	if (!(attr = sysfs_open_attribute(attr_path)))
-		return 0;
-
-	if (sysfs_read_attribute(attr))
-		goto err;
-
+	if (!(attr = sysfs_open_attribute(attr_path)) ||
+	    sysfs_read_attribute(attr)) {
+		unsigned int checkhost, session;
+		if (attr)
+			goto err;
+		if (safe_sprintf(attr_path,
+				 "%s/devices/platform/host%%u/session%%u/",
+				 sysfs_path)) {
+			condlog(0, "attr_path too small");
+			return 1;
+		}
+		if (sscanf(attr_buff, attr_path, &checkhost, &session) != 2)
+			return 0;
+		if (checkhost != pp->sg_id.host_no)
+			return 0;
+		if (safe_sprintf(attr_path, "%s/devices/platform/host%u/session%u/iscsi_session:session%u/targetname", sysfs_path, checkhost, session, session)) {
+			condlog(0, "attr_path too small");
+			return 1;
+		}
+		if (!(attr = sysfs_open_attribute(attr_path)))
+			return 0;
+		if (sysfs_read_attribute(attr))
+			goto err;
+	}
 	if (attr->len > 0)
 		strncpy(pp->tgt_node_name, attr->value, attr->len - 1);
 
+	sysfs_close_attribute(attr);
+
 	condlog(3, "%s: tgt_node_name = %s",
 		pp->dev, pp->tgt_node_name);
 
--- multipath-tools/libmultipath/structs.h	2011/02/18 18:27:00	1.18.2.9
+++ multipath-tools/libmultipath/structs.h	2011/10/10 03:03:17	1.18.2.10
@@ -5,7 +5,7 @@
 
 #define WWID_SIZE		128
 #define SERIAL_SIZE		64
-#define NODE_NAME_SIZE		19
+#define NODE_NAME_SIZE		224
 #define PATH_STR_SIZE  		16
 #define PARAMS_SIZE		1024
 #define FILE_NAME_SIZE		256
