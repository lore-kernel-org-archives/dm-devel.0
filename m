From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: Remove trailing whitespace
Date: Sat,  5 Nov 2016 17:58:32 +0100
Message-ID: <20161105165832.23273-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 2 +-
 multipathd/main.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 4f90cf5..a1f25d5 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -449,7 +449,7 @@ Default value is: \fBmanual\fR
 .TP
 .B  rr_min_io
 Number of I/O requests to route to a path before switching to the next in the
-same path group. This is only for \fIBlock I/O\fR(BIO) based multipath and 
+same path group. This is only for \fIBlock I/O\fR(BIO) based multipath and
 only apply to \fIround-robin\fR path_selector.
 .RS
 .TP
diff --git a/multipathd/main.c b/multipathd/main.c
index aec89e7..d6f081f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2579,7 +2579,7 @@ main (int argc, char *argv[])
 	umask(umask(077) | 022);
 
 	pthread_cond_init_mono(&config_cond);
-	
+
 	udev = udev_new();
 
 	while ((arg = getopt(argc, argv, ":dsv:k::Bn")) != EOF ) {
-- 
2.10.2
