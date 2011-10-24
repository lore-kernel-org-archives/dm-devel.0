From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority pp_alua/rtpg.c p ...
Date: 24 Oct 2011 13:41:32 -0000
Message-ID: <20111024134132.32316.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-10-24 13:41:32

Modified files:
	path_priority/pp_alua: rtpg.c 
	path_priority/pp_balance_units: pp_balance_units.c 

Log message:
	Fix for bz #737072. Shorten the timeout for the alua prio callout function
	from 5 minutes to 1 minute.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/rtpg.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.5&r2=1.3.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_balance_units/pp_balance_units.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6&r2=1.6.2.1

--- multipath-tools/path_priority/pp_alua/rtpg.c	2009/08/18 21:12:02	1.3.2.5
+++ multipath-tools/path_priority/pp_alua/rtpg.c	2011/10/24 13:41:32	1.3.2.6
@@ -29,7 +29,7 @@
 #include "rtpg.h"
 
 #define SENSE_BUFF_LEN  32
-#define DEF_TIMEOUT     300000
+#define DEF_TIMEOUT     60000
 
 /*
  * Macro used to print debug messaged.
--- multipath-tools/path_priority/pp_balance_units/pp_balance_units.c	2006/08/02 21:37:24	1.6
+++ multipath-tools/path_priority/pp_balance_units/pp_balance_units.c	2011/10/24 13:41:32	1.6.2.1
@@ -38,7 +38,7 @@
 #define INQUIRY_CMDLEN  6
 #define INQUIRY_CMD     0x12
 #define SENSE_BUFF_LEN  32
-#define DEF_TIMEOUT     300000
+#define DEF_TIMEOUT     60000
 #define RECOVERED_ERROR 0x01
 #define MX_ALLOC_LEN    255
 #define SCSI_CHECK_CONDITION    0x2
