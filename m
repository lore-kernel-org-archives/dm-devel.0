From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/39] libmultipath: fixup possible buffer
	overflow in alua_rtpg.c
Date: Thu, 16 Jun 2016 11:47:22 +0200
Message-ID: <1466070465-1021-17-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

We need to reserve an additional 4 bytes for the length of
the response buffer, so add a proper range check to avoid
accidental wrap-arounds.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/prioritizers/alua_rtpg.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 636aae5..22b0d4f 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -15,6 +15,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include <sys/ioctl.h>
 #include <inttypes.h>
 #include <libudev.h>
@@ -219,6 +220,9 @@ get_target_port_group(struct path * pp)
 			goto out;
 
 		scsi_buflen = (buf[2] << 8 | buf[3]) + 4;
+		/* Paranoia */
+		if (scsi_buflen >= USHRT_MAX)
+			scsi_buflen = USHRT_MAX;
 		if (buflen < scsi_buflen) {
 			free(buf);
 			buf = (unsigned char *)malloc(scsi_buflen);
@@ -303,7 +307,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
 	struct rtpg_tpg_dscr *	dscr;
 	int			rc;
 	int			buflen;
-	uint32_t		scsi_buflen;
+	uint64_t		scsi_buflen;
 
 	buflen = 4096;
 	buf = (unsigned char *)malloc(buflen);
@@ -317,6 +321,8 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
 	if (rc < 0)
 		goto out;
 	scsi_buflen = (buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3]) + 4;
+	if (scsi_buflen > UINT_MAX)
+		scsi_buflen = UINT_MAX;
 	if (buflen < scsi_buflen) {
 		free(buf);
 		buf = (unsigned char *)malloc(scsi_buflen);
-- 
2.6.6
