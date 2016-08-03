From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/5] multipath-tools: add 'void' for no arguments
	functions
Date: Wed,  3 Aug 2016 20:13:56 +0200
Message-ID: <1470248040-11789-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Found by checkpatch - ERROR: Bad function definition

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 2 +-
 mpathpersist/main.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index cf7141a..48d36e9 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -466,7 +466,7 @@ int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
 	return MPATH_PR_SUCCESS;
 }
 
-int mpath_isLittleEndian()
+int mpath_isLittleEndian(void)
 {
 	int num = 1;
 	if(*(char *)&num == 1)
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 6e922a2..5bf0740 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -675,7 +675,7 @@ void mpath_print_buf_readfullstat( struct prin_resp *pr_buff)
 	}
 }
 
-static void usage()
+static void usage(void)
 {
 	fprintf(stderr,
 			"Usage: mpathpersist [OPTIONS] [DEVICE]\n"
-- 
2.7.4
