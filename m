From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority/pp_alua rtpg.c
Date: 8 Apr 2009 21:38:45 -0000
Message-ID: <20090408213845.10235.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-04-08 21:38:45

Modified files:
	path_priority/pp_alua: rtpg.c 

Log message:
	Fix for bz #490633. Adjust SCSI RTPG request buffer size in ALUA prioritizer.
	Already upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/rtpg.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3&r2=1.3.2.1

--- multipath-tools/path_priority/pp_alua/rtpg.c	2006/07/13 19:49:23	1.3
+++ multipath-tools/path_priority/pp_alua/rtpg.c	2009/04/08 21:38:44	1.3.2.1
@@ -21,6 +21,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <errno.h>
+#include <inttypes.h>
 
 #define __user
 #include <scsi/sg.h>
@@ -251,14 +252,38 @@
 int
 get_asymmetric_access_state(int fd, unsigned int tpg)
 {
-	unsigned char		buf[128];
+	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
 	struct rtpg_tpg_dscr *	dscr;
 	int			rc;
+	int			buflen;
+	uint32_t		scsi_buflen;
 
-	rc = do_rtpg(fd, buf, sizeof(buf));
+	buflen = 128; /* Initial value from old code */
+	buf = (unsigned char *)malloc(buflen);
+	if (!buf) {
+		PRINT_DEBUG ("malloc failed: could not allocate"
+			"%u bytes\n", buflen);
+		return -RTPG_RTPG_FAILED;
+	}
+	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
 		return rc;
+	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
+	if (buflen < (scsi_buflen + 4)) {
+		free(buf);
+		buf = (unsigned char *)malloc(scsi_buflen);
+		if (!buf) {
+			PRINT_DEBUG ("malloc failed: could not allocate"
+				"%u bytes\n", scsi_buflen);
+			return -RTPG_RTPG_FAILED;
+		}
+		buflen = scsi_buflen;
+		rc = do_rtpg(fd, buf, buflen);
+		if (rc < 0)
+			goto out;
+	}
+
 
 	tpgd = (struct rtpg_data *) buf;
 	rc   = -RTPG_TPG_NOT_FOUND;
@@ -274,7 +299,8 @@
 			}
 		}
 	}
-
+out:
+	free(buf);
 	return rc;
 }
 
