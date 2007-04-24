From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/Makefile libchecke ...
Date: 24 Apr 2007 18:49:17 -0000
Message-ID: <20070424184917.11635.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-04-24 19:49:17

Modified files:
	libcheckers    : Makefile checkers.c checkers.h 
	libmultipath   : discovery.c switchgroup.c 

Log message:
	Pulled in patches for RDAC storage support.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.1&r2=1.32.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/switchgroup.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1

--- multipath-tools/libcheckers/Makefile	2006/06/06 18:32:43	1.5
+++ multipath-tools/libcheckers/Makefile	2007/04/24 18:49:16	1.5.2.1
@@ -6,7 +6,7 @@
 
 include ../Makefile.inc
 
-OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o
+OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o rdac.o
 
 all: $(BUILD)
 
--- multipath-tools/libcheckers/checkers.c	2006/06/06 18:46:38	1.1
+++ multipath-tools/libcheckers/checkers.c	2007/04/24 18:49:16	1.1.2.1
@@ -7,6 +7,7 @@
 #include "tur.h"
 #include "hp_sw.h"
 #include "emc_clariion.h"
+#include "rdac.h"
 #include "readsector0.h"
 
 static struct checker checkers[] = {
@@ -48,6 +49,15 @@
 	},
 	{
 		.fd         = 0,
+		.name       = RDAC,
+		.message    = "",
+		.context    = NULL,
+		.check      = rdac,
+		.init       = rdac_init,
+		.free       = rdac_free
+	},
+	{
+		.fd         = 0,
 		.name       = READSECTOR0,
 		.message    = "",
 		.context    = NULL,
--- multipath-tools/libcheckers/checkers.h	2006/07/13 19:49:22	1.5
+++ multipath-tools/libcheckers/checkers.h	2007/04/24 18:49:16	1.5.2.1
@@ -14,6 +14,7 @@
 #define DIRECTIO     "directio"
 #define TUR          "tur"
 #define HP_SW        "hp_sw"
+#define RDAC         "rdac"
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
 
--- multipath-tools/libmultipath/discovery.c	2007/01/10 20:08:08	1.32.2.1
+++ multipath-tools/libmultipath/discovery.c	2007/04/24 18:49:16	1.32.2.2
@@ -164,7 +164,7 @@
  * not multipath(8), ran by udev
  */
 #if DAEMON
-#define WAIT_MAX_SECONDS 5
+#define WAIT_MAX_SECONDS 60
 #define WAIT_LOOP_PER_SECOND 5
 
 static int
@@ -760,7 +760,8 @@
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 	
-	if (mask & DI_PRIO && pp->state != PATH_DOWN)
+	if (mask & DI_PRIO &&
+	    (pp->state == PATH_UP || pp->priority == PRIO_UNDEF))
 		get_prio(pp);
 
 	if (mask & DI_WWID && !strlen(pp->wwid))
--- multipath-tools/libmultipath/switchgroup.c	2006/06/06 18:32:43	1.5
+++ multipath-tools/libmultipath/switchgroup.c	2007/04/24 18:49:16	1.5.2.1
@@ -28,7 +28,7 @@
 		priority = 0;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state != PATH_DOWN)
+			if (pp->state == PATH_UP)
 				priority += pp->priority;
 		}
 		pgp->priority = priority;
