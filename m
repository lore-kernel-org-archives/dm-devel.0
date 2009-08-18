From: bmarzins@sourceware.org
Subject: multipath-tools multipathd/copy.c multipathd/m ...
Date: 18 Aug 2009 21:12:03 -0000
Message-ID: <20090818211203.28562.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-08-18 21:12:02

Modified files:
	multipathd     : copy.c main.c 
	path_priority/pp_alua: rtpg.c 

Log message:
	Change warning messages when creating the private multipathd namespace, so that they don't scare users who don't have unneeded callouts installed.  Not
	applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/copy.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.21&r2=1.69.2.22
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/rtpg.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.4&r2=1.3.2.5

--- multipath-tools/multipathd/Attic/copy.c	2007/12/15 00:27:40	1.5.2.1
+++ multipath-tools/multipathd/Attic/copy.c	2009/08/18 21:12:01	1.5.2.2
@@ -24,7 +24,10 @@
 	fdin = open (src, O_RDONLY);
 
 	if (fdin < 0) {
-		condlog(0, "[copy.c] cannot open %s", src);
+		if (errno == ENOENT)
+			condlog(3, "callout %s does not exist, ignoring");
+		else
+			condlog(0, "[copy.c] cannot open %s", src);
 		return -1;
 	}
 	/*
--- multipath-tools/multipathd/main.c	2009/05/06 17:26:45	1.69.2.21
+++ multipath-tools/multipathd/main.c	2009/08/18 21:12:01	1.69.2.22
@@ -1338,8 +1338,11 @@
 	 */
 	vector_foreach_slot (conf->binvec, bin,i) {
 		if ((fd = open(bin, O_RDONLY)) < 0) {
-			condlog(0, "cannot open %s : %s\n", bin,
-				strerror(errno));
+			if (errno == ENOENT)
+				condlog(3, "callout %s does not exist, ignoring");
+			else
+				condlog(0, "cannot open %s : %s", bin,
+					strerror(errno));
 			continue;
 		}
 		if (fstat(fd, &statbuf) < 0) {
@@ -1368,11 +1371,8 @@
 	 * populate the ramfs with callout binaries
 	 */
 	vector_foreach_slot (conf->binvec, bin,i) {
-		if (copytodir(bin, CALLOUT_DIR) < 0) {
-			condlog(0, "cannot copy %s in ramfs : %s", bin,
-				strerror(errno));
+		if (copytodir(bin, CALLOUT_DIR) < 0)
 			continue;
-		}
 		condlog(4, "cp %s in ramfs", bin);
 	}
 	free_strvec(conf->binvec);
--- multipath-tools/path_priority/pp_alua/rtpg.c	2009/07/07 18:44:11	1.3.2.4
+++ multipath-tools/path_priority/pp_alua/rtpg.c	2009/08/18 21:12:02	1.3.2.5
@@ -269,7 +269,7 @@
 	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
 		goto out;
-	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3] + 4;
+	scsi_buflen = (buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3]) + 4;
 	if (buflen < scsi_buflen) {
 		free(buf);
 		buf = (unsigned char *)malloc(scsi_buflen);
