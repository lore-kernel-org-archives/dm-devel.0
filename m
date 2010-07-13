From: zkabelac@sourceware.org
Subject: dmraid/lib/format/ataraid asr.c
Date: 13 Jul 2010 20:18:19 -0000
Message-ID: <20100713201819.23521.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:18:19

Modified files:
	lib/format/ataraid: asr.c 

Log message:
	Add void to definition of create_drivemagic()

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.c.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/lib/format/ataraid/asr.c	2010/03/18 16:53:17	1.7
+++ dmraid/lib/format/ataraid/asr.c	2010/07/13 20:18:19	1.8
@@ -763,7 +763,7 @@
 
 /* Creates a random integer for a drive magic section */
 static uint32_t
-create_drivemagic()
+create_drivemagic(void)
 {
 
 	srand(time(NULL));
