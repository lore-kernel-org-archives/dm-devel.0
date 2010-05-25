From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 25 May 2010 23:23:08 -0000
Message-ID: <20100525232308.18704.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-05-25 23:23:07

Modified files:
	libmultipath   : discovery.c 

Log message:
	Fix for bz #512065
	If you can't get /sys/class/fc_transport/target%i:%i:%i/node_name, try
	/sys/class/fc_transport/target%i:%i:%i/node_name.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.28.2.7&r2=1.28.2.8

--- multipath-tools/libmultipath/discovery.c	2008/04/14 17:59:54	1.28.2.7
+++ multipath-tools/libmultipath/discovery.c	2010/05/25 23:23:07	1.28.2.8
@@ -553,6 +553,21 @@
 	if (0 <= readattr(attr_path, attr_buff) && strlen(attr_buff) > 0)
 		strncpy(curpath->tgt_node_name, attr_buff,
 			strlen(attr_buff) - 1);
+	else {
+		if(safe_sprintf(attr_path,
+			"%s/class/iscsi_transport/target%i:%i:%i/target_name",
+				sysfs_path,
+				curpath->sg_id.host_no,
+				curpath->sg_id.channel,
+				curpath->sg_id.scsi_id)) {
+			condlog(0, "attr_path too small");
+			return 1;
+		}
+		if (0 <= readattr(attr_path, attr_buff) &&
+		    strlen(attr_buff) > 0)
+			strncpy(curpath->tgt_node_name, attr_buff,
+				strlen(attr_buff) - 1);
+	}
 	condlog(3, "tgt_node_name = %s", curpath->tgt_node_name);
 
 	return 0;
