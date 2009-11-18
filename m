From: heinzm@sourceware.org
Subject: dmraid/lib/format/ataraid pdc.h
Date: 18 Nov 2009 10:04:10 -0000
Message-ID: <20091118100410.7096.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-11-18 10:04:10

Modified files:
	lib/format/ataraid: pdc.h 

Log message:
	Added new identified pdc metadata signature offsets

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.h.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/lib/format/ataraid/pdc.h	2009/09/16 11:45:14	1.4
+++ dmraid/lib/format/ataraid/pdc.h	2009/11/18 10:04:09	1.5
@@ -13,7 +13,7 @@
 
 #include <stdint.h>
 
-#define PDC_CONFIGOFFSETS	63,255,256,16,399,591,675,735,974,991
+#define PDC_CONFIGOFFSETS	63,255,256,16,399,591,675,735,911,974,991,3087
 #define	PDC_DATAOFFSET 0
 
 /*
