From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 02/12] libmultipath(coverity): cleanup dup usage
	in execute_program()
Date: Tue,  8 Jan 2019 23:53:59 +0100
Message-ID: <20190108225409.15977-3-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
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

coverity complained about resource leakage here.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/callout.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/libmultipath/callout.c b/libmultipath/callout.c
index d5ca27b..dac088c 100644
--- a/libmultipath/callout.c
+++ b/libmultipath/callout.c
@@ -68,19 +68,20 @@ int execute_program(char *path, char *value, int len)
 	switch(pid) {
 	case 0:
 		/* child */
-		close(STDOUT_FILENO);
 
 		/* dup write side of pipe to STDOUT */
-		if (dup(fds[1]) < 0)
+		if (dup2(fds[1], STDOUT_FILENO) < 0) {
+			condlog(1, "failed to dup2 stdout: %m");
 			return -1;
+		}
+		close(fds[0]);
+		close(fds[1]);
 
 		/* Ignore writes to stderr */
 		null_fd = open("/dev/null", O_WRONLY);
 		if (null_fd > 0) {
-			int err_fd __attribute__ ((unused));
-
-			close(STDERR_FILENO);
-			err_fd = dup(null_fd);
+			if (dup2(null_fd, STDERR_FILENO) < 0)
+				condlog(1, "failed to dup2 stderr: %m");
 			close(null_fd);
 		}
 
-- 
2.19.2
