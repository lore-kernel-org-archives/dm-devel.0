From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 11 Aug 2010 23:05:50 -0000
Message-ID: <20100811230550.32654.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-08-11 23:05:50

Modified files:
	libmultipath   : discovery.c 

Log message:
	Fix for bz #576600
	Patch to allow multipath to handle virtio devices. Mostly for testing purposes.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.14&r2=1.32.2.15

--- multipath-tools/libmultipath/discovery.c	2010/06/23 16:28:07	1.32.2.14
+++ multipath-tools/libmultipath/discovery.c	2010/08/11 23:05:50	1.32.2.15
@@ -481,6 +481,7 @@
 	char attr_path[FILE_NAME_SIZE];
 	char attr_buff[FILE_NAME_SIZE];
 	unsigned int unused;
+	char vdisk;
 
 	pp->bus = SYSFS_BUS_UNDEF;
 
@@ -489,6 +490,12 @@
 		strcpy(pp->product_id, "GNBD");
 		pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id);
 		return 0;
+	} else if (sscanf(pp->dev, "vd%c", &vdisk) == 1 &&
+		   'a' <= vdisk && vdisk <= 'z'){
+		strcpy(pp->vendor_id,  "VIRTIO");
+		strcpy(pp->product_id, "VIRTIO");
+		pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id);
+		return 0;
 	}
 	/*
 	 * This is ugly : we should be able to do a simple
