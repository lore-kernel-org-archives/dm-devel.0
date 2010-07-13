From: zkabelac@sourceware.org
Subject: dmraid/lib/format/ataraid lsi.c
Date: 13 Jul 2010 18:19:45 -0000
Message-ID: <20100713181945.8283.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	zkabelac@sourceware.org	2010-07-13 18:19:45

Modified files:
	lib/format/ataraid: lsi.c 

Log message:
	Fix parameters for printing string

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/lsi.c.diff?cvsroot=dm&r1=1.5&r2=1.6

--- dmraid/lib/format/ataraid/lsi.c	2010/03/18 16:53:17	1.5
+++ dmraid/lib/format/ataraid/lsi.c	2010/07/13 18:19:44	1.6
@@ -317,8 +317,8 @@
 		  i, disk->disk_number);
 		P("disks[%u].set_number: %u", lsi, disk->set_number,
 		  i, disk->set_number);
-		P("disks[%u].unknown1: %lu, 0x%lX", lsi, disk->unknown1,
-		  i, (uint64_t) disk->unknown1, (uint64_t) disk->unknown1);
+		P("disks[%u].unknown1: %d %p", lsi, disk->unknown1,
+		  i, disk->unknown1);
 	}
 
 	DP("disk_number: %u", lsi, lsi->disk_number);
