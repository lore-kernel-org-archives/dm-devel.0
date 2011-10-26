From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority/pp_alua rtpg.c
Date: 26 Oct 2011 04:53:45 -0000
Message-ID: <20111026045345.16638.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-10-26 04:53:44

Modified files:
	path_priority/pp_alua: rtpg.c 

Log message:
	Fix for bz #740512.  zero out buffers for do_inquiry and do_rtpg.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/rtpg.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.6&r2=1.3.2.7

--- multipath-tools/path_priority/pp_alua/rtpg.c	2011/10/24 13:41:32	1.3.2.6
+++ multipath-tools/path_priority/pp_alua/rtpg.c	2011/10/26 04:53:44	1.3.2.7
@@ -165,6 +165,7 @@
 	struct inquiry_data	inq;
 	int			rc;
 
+	memset((unsigned char *)&inq, 0, sizeof(inq));
 	rc = do_inquiry(fd, 0, 0x00, &inq, sizeof(inq));
 	if (!rc) {
 		rc = inquiry_data_get_tpgs(&inq);
@@ -181,6 +182,7 @@
 	struct vpd83_dscr *	dscr;
 	int			rc;
 
+	memset(buf, 0, sizeof(buf));
 	rc = do_inquiry(fd, 1, 0x83, buf, sizeof(buf));
 	if (!rc) {
 		vpd83 = (struct vpd83_data *) buf;
@@ -266,6 +268,7 @@
 			"%u bytes\n", buflen);
 		return -RTPG_RTPG_FAILED;
 	}
+	memset(buf, 0, buflen);
 	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
 		goto out;
@@ -279,6 +282,7 @@
 			return -RTPG_RTPG_FAILED;
 		}
 		buflen = scsi_buflen;
+		memset(buf, 0, buflen);
 		rc = do_rtpg(fd, buf, buflen);
 		if (rc < 0)
 			goto out;
