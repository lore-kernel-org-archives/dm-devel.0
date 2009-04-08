From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] [prio] Memory leak if failed to do RTPG.
Date: Wed,  8 Apr 2009 18:11:25 -0400
Message-ID: <1239228685-5658-1-git-send-email-konrad@virtualiron.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

We don't de-alloc the buf variable if we fail on the first
do_rtpg call.
---
 libmultipath/prioritizers/alua_rtpg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 7151cdd..5a8a59f 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -263,7 +263,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
 	}
 	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
-		return rc;
+		goto out;
 	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
 	if (buflen < (scsi_buflen + 4)) {
 		free(buf);
-- 
1.5.4.1
