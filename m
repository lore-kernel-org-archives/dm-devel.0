From: zkabelac@sourceware.org
Subject: dmraid/lib/format/ddf ddf1_dump.c
Date: 13 Jul 2010 20:22:38 -0000
Message-ID: <20100713202238.24799.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:22:38

Modified files:
	lib/format/ddf : ddf1_dump.c 

Log message:
	Add missing #include "ddf1_dump.h"

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_dump.c.diff?cvsroot=dm&r1=1.2&r2=1.3

--- dmraid/lib/format/ddf/ddf1_dump.c	2008/06/20 21:52:17	1.2
+++ dmraid/lib/format/ddf/ddf1_dump.c	2010/07/13 20:22:38	1.3
@@ -16,6 +16,7 @@
 #define FORMAT_HANDLER
 #include "ddf1.h"
 #include "ddf1_lib.h"
+#include "ddf1_dump.h"
 
 /* Print DDF GUIDs. */
 #ifdef  NATIVE_LOG_OFFSET
