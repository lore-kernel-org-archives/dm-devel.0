From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority/pp_alua rtpg.c
Date: 7 Jul 2009 18:44:12 -0000
Message-ID: <20090707184412.25032.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-07-07 18:44:12

Modified files:
	path_priority/pp_alua: rtpg.c 

Log message:
	Multipath needs to actually allocate the correct size buffer when it realizes
	that the existing rtpg buffer is too small.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/rtpg.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.3&r2=1.3.2.4

--- multipath-tools/path_priority/pp_alua/rtpg.c	2009/05/06 22:57:58	1.3.2.3
+++ multipath-tools/path_priority/pp_alua/rtpg.c	2009/07/07 18:44:11	1.3.2.4
@@ -269,8 +269,8 @@
 	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
 		goto out;
-	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
-	if (buflen < (scsi_buflen + 4)) {
+	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3] + 4;
+	if (buflen < scsi_buflen) {
 		free(buf);
 		buf = (unsigned char *)malloc(scsi_buflen);
 		if (!buf) {
