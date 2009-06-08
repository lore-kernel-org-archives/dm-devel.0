From: bmarzins@sourceware.org
Subject: multipath-tools libcheckers/tur.c libmultipath ...
Date: 8 Jun 2009 21:38:02 -0000
Message-ID: <20090608213802.2788.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-06-08 21:38:02

Modified files:
	libcheckers    : tur.c 
	libmultipath   : discovery.c 

Log message:
	Fix for 473039. TUR checker can now return PATH_GHOST. Already upstream.
	More work for 437588.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/tur.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4.2.2&r2=1.4.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.7&r2=1.32.2.8

--- multipath-tools/libcheckers/tur.c	2009/04/21 00:05:22	1.4.2.2
+++ multipath-tools/libcheckers/tur.c	2009/06/08 21:38:01	1.4.2.3
@@ -21,6 +21,7 @@
 #define HEAVY_CHECK_COUNT       10
 
 #define MSG_TUR_UP	"tur checker reports path is up"
+#define MSG_TUR_GHOST	"tur checker reports path in standby state"
 #define MSG_TUR_DOWN	"tur checker reports path is down"
 
 /* from linux/include/scsi/scsi.h */
@@ -91,6 +92,17 @@
 			if (--retry_tur)
 				goto retry;
 		}
+		else if( key == 0x2){
+			/* Not Ready */
+			
+			/*Note : Other ALUA states are either UP or DOWN*/
+			if( asc == 0x04 && ascq == 0x0b){
+			/*LOGICAL UNIT NOT ACCESSIBLE, TARGET PORT IN STANDBY STATE*/
+				MSG(c, MSG_TUR_GHOST);
+				return PATH_GHOST;
+			}
+		}
+
 		MSG(c, MSG_TUR_DOWN);
 		return PATH_DOWN;
 	}
--- multipath-tools/libmultipath/discovery.c	2009/04/21 00:05:22	1.32.2.7
+++ multipath-tools/libmultipath/discovery.c	2009/06/08 21:38:02	1.32.2.8
@@ -742,12 +742,34 @@
 }
 
 static int
+get_uid (struct path * pp)
+{
+	char buff[CALLOUT_MAX_SIZE];
+
+	if (!pp->getuid)
+		select_getuid(pp);
+
+	if (apply_format(pp->getuid, &buff[0], pp)) {
+		condlog(0, "error formatting uid callout command");
+		memset(pp->wwid, 0, WWID_SIZE);
+	} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
+		condlog(0, "error calling out %s", buff);
+		memset(pp->wwid, 0, WWID_SIZE);
+		return 1;
+	}
+	condlog(3, "%s: uid = %s (callout)", pp->dev ,pp->wwid);
+	return 0;
+}
+
+static int
 get_prio (struct path * pp)
 {
 	char buff[CALLOUT_MAX_SIZE];
 	char prio[16];
 
 	if (!pp->getprio_selected) {
+		if (!strlen(pp->wwid))
+			get_uid(pp);
 		select_getprio(pp);
 		pp->getprio_selected = 1;
 	}
@@ -768,26 +790,6 @@
 	return 0;
 }
 
-static int
-get_uid (struct path * pp)
-{
-	char buff[CALLOUT_MAX_SIZE];
-
-	if (!pp->getuid)
-		select_getuid(pp);
-
-	if (apply_format(pp->getuid, &buff[0], pp)) {
-		condlog(0, "error formatting uid callout command");
-		memset(pp->wwid, 0, WWID_SIZE);
-	} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
-		condlog(0, "error calling out %s", buff);
-		memset(pp->wwid, 0, WWID_SIZE);
-		return 1;
-	}
-	condlog(3, "%s: uid = %s (callout)", pp->dev ,pp->wwid);
-	return 0;
-}
-
 extern int
 pathinfo (struct path *pp, vector hwtable, int mask)
 {
@@ -815,12 +817,12 @@
 	if (mask & DI_CHECKER && get_state(pp))
 		goto blank;
 	
-	if (mask & DI_PRIO && pp->state != PATH_DOWN)
-		get_prio(pp);
-
 	if (mask & DI_WWID && !strlen(pp->wwid))
 		get_uid(pp);
 
+	if (mask & DI_PRIO && pp->state != PATH_DOWN)
+		get_prio(pp);
+
 #ifndef DAEMON
 	close(pp->fd);
 	pp->fd = -1;
