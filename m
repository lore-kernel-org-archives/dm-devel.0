From: heinzm@sourceware.org
Subject: dmraid/lib/device scsi.c
Date: 31 Oct 2008 12:22:35 -0000
Message-ID: <20081031122235.19507.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2008-10-31 12:22:35

Modified files:
	lib/device     : scsi.c 

Log message:
	Reverting white space removal until we find a better solution to handle serial numbers

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/device/scsi.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/lib/device/scsi.c	2008/09/19 14:31:11	1.3
+++ dmraid/lib/device/scsi.c	2008/10/31 12:22:35	1.4
@@ -110,7 +110,7 @@
 		}
 
 		ret = ret &&
-		     (di->serial = dbg_strdup((char *) &response[p->start + 1]));
+		      (di->serial = dbg_strdup(remove_white_space (lc, (char *) &response[p->start + 1], serial_len)));
 	}
 
 	dbg_free(response);
