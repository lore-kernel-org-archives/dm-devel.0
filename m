From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Close file descriptors if forking returns an
	error.
Date: Thu,  8 Jan 2009 14:25:04 -0500
Message-ID: <1231442704-19032-2-git-send-email-konrad@virtualiron.com>
References: <1231442704-19032-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1231442704-19032-1-git-send-email-konrad@virtualiron.com>
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

From: Konrad Rzeszutek <konrad@mars.virtualiron.com>

And also use vfork instead of fork so that the heap space count
of the parent process (multipathd) will not be counted against
the program which will executed (scsi_id or other).
---
 libmultipath/callout.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/libmultipath/callout.c b/libmultipath/callout.c
index 4dd33c5..6f9d195 100644
--- a/libmultipath/callout.c
+++ b/libmultipath/callout.c
@@ -68,7 +68,7 @@ int execute_program(char *path, char *value, int len)
 		return -1;
 
 
-	pid = fork();
+	pid = vfork();
 
 	switch(pid) {
 	case 0:
@@ -91,6 +91,9 @@ int execute_program(char *path, char *value, int len)
 
 		exit(-1);
 	case -1:
+		close(fds[0]);
+		close(fds[1]);
+		condlog(0, "error forking: %s. errno:%d\n", path, errno);
 		return -1;
 	default:
 		/* parent reads from fds[0] */
-- 
1.5.4.1
