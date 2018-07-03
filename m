From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] libmultipath: more debug output in alua
	prioritizer
Date: Tue,  3 Jul 2018 09:57:07 +0200
Message-ID: <20180703075707.834-3-mwilck@suse.com>
References: <20180703075707.834-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180703075707.834-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Help debug problems with ALUA commands by emitting more
meaningful error messages.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/alua.c      |  5 ++++-
 libmultipath/prioritizers/alua_rtpg.c | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 03d0a0e0..b24e2d48 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -67,8 +67,11 @@ get_alua_info(struct path * pp, unsigned int timeout)
 	}
 	condlog(3, "%s: reported target port group is %i", pp->dev, tpg);
 	rc = get_asymmetric_access_state(pp->fd, tpg, timeout);
-	if (rc < 0)
+	if (rc < 0) {
+		condlog(2, "%s: get_asymmetric_access_state returned %d",
+			__func__, rc);
 		return -ALUA_PRIO_GETAAS_FAILED;
+	}
 
 	condlog(3, "%s: aas = %02x [%s]%s", pp->dev, rc, aas_print_string(rc),
 		(rc & 0x80) ? " [preferred]" : "");
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 34b5f3ce..811ce7a2 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -19,6 +19,7 @@
 #include <sys/ioctl.h>
 #include <inttypes.h>
 #include <libudev.h>
+#include <errno.h>
 
 #define __user
 #include <scsi/sg.h>
@@ -318,8 +319,11 @@ retry:
 	hdr.sbp			= sense;
 	hdr.timeout		= get_prio_timeout(timeout, SGIO_TIMEOUT);
 
-	if (ioctl(fd, SG_IO, &hdr) < 0)
+	if (ioctl(fd, SG_IO, &hdr) < 0) {
+		condlog(2, "%s: sg ioctl failed: %s",
+			__func__, strerror(errno));
 		return -RTPG_RTPG_FAILED;
+	}
 
 	rc = scsi_error(&hdr, OPERATION_CODE_RTPG);
 	if (rc == SCSI_ERROR) {
@@ -355,8 +359,10 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
 	}
 	memset(buf, 0, buflen);
 	rc = do_rtpg(fd, buf, buflen, timeout);
-	if (rc < 0)
+	if (rc < 0) {
+		PRINT_DEBUG("%s: do_rtpg returned %d", __func__, rc);
 		goto out;
+	}
 	scsi_buflen = get_unaligned_be32(&buf[0]) + 4;
 	if (scsi_buflen > UINT_MAX)
 		scsi_buflen = UINT_MAX;
@@ -364,8 +370,8 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
 		free(buf);
 		buf = (unsigned char *)malloc(scsi_buflen);
 		if (!buf) {
-			PRINT_DEBUG ("malloc failed: could not allocate"
-				"%u bytes", scsi_buflen);
+			PRINT_DEBUG("malloc failed: could not allocate %"
+				    PRIu64 " bytes", scsi_buflen);
 			return -RTPG_RTPG_FAILED;
 		}
 		buflen = scsi_buflen;
@@ -389,6 +395,8 @@ get_asymmetric_access_state(int fd, unsigned int tpg, unsigned int timeout)
 			}
 		}
 	}
+	if (rc == -RTPG_TPG_NOT_FOUND)
+		condlog(2, "%s: port group %d not found", __func__, tpg);
 out:
 	free(buf);
 	return rc;
-- 
2.17.1
