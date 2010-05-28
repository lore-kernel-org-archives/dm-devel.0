From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c structs.h
Date: 28 May 2010 04:53:26 -0000
Message-ID: <20100528045326.10188.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2010-05-28 04:53:26

Modified files:
	libmultipath   : discovery.c structs.h 

Log message:
	Fix for 512065. Increase the tgt_node_name size to be able to handle IQNs,
	which can be up to 223 bytes long.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.28.2.8&r2=1.28.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.9&r2=1.17.2.10

--- multipath-tools/libmultipath/discovery.c	2010/05/25 23:23:07	1.28.2.8
+++ multipath-tools/libmultipath/discovery.c	2010/05/28 04:53:25	1.28.2.9
@@ -552,7 +552,7 @@
 	}
 	if (0 <= readattr(attr_path, attr_buff) && strlen(attr_buff) > 0)
 		strncpy(curpath->tgt_node_name, attr_buff,
-			strlen(attr_buff) - 1);
+			NODE_NAME_SIZE - 1);
 	else {
 		if(safe_sprintf(attr_path,
 			"%s/class/iscsi_transport/target%i:%i:%i/target_name",
@@ -566,8 +566,9 @@
 		if (0 <= readattr(attr_path, attr_buff) &&
 		    strlen(attr_buff) > 0)
 			strncpy(curpath->tgt_node_name, attr_buff,
-				strlen(attr_buff) - 1);
+				NODE_NAME_SIZE - 1);
 	}
+	curpath->tgt_node_name[NODE_NAME_SIZE - 1] = '\0';
 	condlog(3, "tgt_node_name = %s", curpath->tgt_node_name);
 
 	return 0;
--- multipath-tools/libmultipath/structs.h	2009/01/17 00:46:51	1.17.2.9
+++ multipath-tools/libmultipath/structs.h	2010/05/28 04:53:25	1.17.2.10
@@ -5,7 +5,7 @@
 
 #define WWID_SIZE		128
 #define SERIAL_SIZE		64
-#define NODE_NAME_SIZE		19
+#define NODE_NAME_SIZE		224
 #define PATH_STR_SIZE  		16
 #define PARAMS_SIZE		1024
 #define FILE_NAME_SIZE		256
