From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 20 Jul 2011 21:24:52 -0000
Message-ID: <20110720212452.6404.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-07-20 21:24:52

Modified files:
	libmultipath   : discovery.c 

Log message:
	Fix for BZ# 703501. Change to cciss sysfs handling.  Not applicable upstream

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.20&r2=1.32.2.21

--- multipath-tools/libmultipath/discovery.c	2011/04/05 18:41:45	1.32.2.20
+++ multipath-tools/libmultipath/discovery.c	2011/07/20 21:24:52	1.32.2.21
@@ -817,8 +817,7 @@
 		return 1;
 	}
 
-	if(safe_sprintf(dev_path, "%s/device/cciss%u/c%ud%u", curpath->dev,
-			controller, controller, lun)) {
+	if(safe_sprintf(dev_path, "%s/device", curpath->dev)) {
 		condlog(0, "dev_path too small");
 		return 1;
 	}
