From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: multipath-tools: Fix rtpg buffer length calculation
Date: Wed, 2 Sep 2009 14:40:17 -0500
Message-ID: <20090902194016.GG15326@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Since you use scsi_buflen to allocate the correct size for the
SCSI RTPG request buffer, You need to have the "+4" in its
calculation, not just in the check to see if the request buffer is
already big enough, otherwise, you'll fail the check, but you
won't allocate a new buffer that is big enough.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prioritizers/alua_rtpg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: multipath-tools-090902/libmultipath/prioritizers/alua_rtpg.c
===================================================================
--- multipath-tools-090902.orig/libmultipath/prioritizers/alua_rtpg.c
+++ multipath-tools-090902/libmultipath/prioritizers/alua_rtpg.c
@@ -267,8 +267,8 @@ get_asymmetric_access_state(int fd, unsi
 	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
 		return rc;
-	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
-	if (buflen < (scsi_buflen + 4)) {
+	scsi_buflen = (buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3]) + 4;
+	if (buflen < scsi_buflen) {
 		free(buf);
 		buf = (unsigned char *)malloc(scsi_buflen);
 		if (!buf) {
