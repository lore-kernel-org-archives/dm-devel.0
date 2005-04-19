From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: pidfile doesn't stop multiple multipathd processes from
	running.
Date: Tue, 19 Apr 2005 17:37:54 -0500
Message-ID: <20050419223754.GG8789@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DKU6Jbt7q3WqK7+M"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The current pidfile implementation doesn't stop multiple multipathd processes
from running. Running
# while true; do multipthd; done
happily makes tons of them.

The attached patch, against multipath-tools-0.4.4-pre15, fixes this.

-Ben

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pidfile-fix.patch"

diff -urN multipath-tools-0.4.4-pre15/multipathd/pidfile.c multipath-tools-pidfile-fix/multipathd/pidfile.c
--- multipath-tools-0.4.4-pre15/multipathd/pidfile.c	2005-03-31 09:59:45.000000000 -0600
+++ multipath-tools-pidfile-fix/multipathd/pidfile.c	2005-04-19 16:11:54.000000000 -0500
@@ -19,79 +19,68 @@
 */
 
 #include <sys/types.h> /* for pid_t */
+#include <sys/stat.h>  /* for open */
 #include <signal.h>    /* for kill() */
 #include <errno.h>     /* for ESHRC */
 #include <stdio.h>     /* for f...() */
 #include <string.h>    /* for memset() */
 #include <stdlib.h>    /* for atoi() */
 #include <unistd.h>    /* for unlink() */
-
+#include <fcntl.h>     /* for fcntl() */
 #include <debug.h>
 
 #include "pidfile.h"
 
-/* Check if a process exists. */
-static int process_exists(pid_t pid)
-{
-	if (pid > 0)
-		return (kill(pid, 0) == 0 || errno != ESRCH);
-	return 0;
-}
-
-/* Return the pid in a pidfile, or return 0 
- * if the process or pidfile does not exist. */
-static pid_t pidfile_pid(const char *pidFile)
-{
-	FILE *f;
-	char pidstr[20];
-	unsigned ret;
-
-	memset(pidstr, 0, sizeof(pidstr));
-
-	if (!(f = fopen(pidFile, "r"))) {
-		return 0;
-	}
-	if (fread(pidstr, sizeof(char), sizeof(pidstr)-1, f) <= 0) {
-		goto noproc;
-	}
-	ret = atoi(pidstr);
-	
-	if (!process_exists((pid_t)ret)) {
-		goto noproc;
-	}
-	fclose(f);
-	return (pid_t)ret;
-
-noproc:
-	fclose(f);
-	unlink(pidFile);
-	return 0;
-}
-
 int pidfile_create(const char *pidFile, pid_t pid)
 {
-	FILE *f;
 	char buf[20];
-	pid_t oldpid;
-
-	oldpid = pidfile_pid(pidFile);
+	struct flock lock;
+	int fd, value;
 
-	if (oldpid != 0) {
-		condlog(0, "File [%s] exists and process id [%d] is running.", 
-			pidFile, (int)pid);
-		return 1;
-	}
-	if (!(f = fopen(pidFile, "w"))) {
+	if((fd = open(pidFile, O_WRONLY | O_CREAT,
+		       (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH))) < 0) {
 		condlog(0, "Cannot open pidfile [%s], error was [%s]",
 			pidFile, strerror(errno));
 		return 1;
 	}
+	lock.l_type = F_WRLCK;
+	lock.l_start = 0;
+	lock.l_whence = SEEK_SET;
+	lock.l_len = 0;
+
+	if (fcntl(fd, F_SETLK, &lock) < 0) {
+		if (errno != EACCES && errno != EAGAIN)
+			condlog(0, "Cannot lock pidfile [%s], error was [%s]",
+				pidFile, strerror(errno));
+		else
+			condlog(0, "process is already running");
+		goto fail;
+	}
+	if (ftruncate(fd, 0) < 0) {
+		condlog(0, "Cannot truncate pidfile [%s], error was [%s]",
+			pidFile, strerror(errno));
+		goto fail;
+	}
 	memset(buf, 0, sizeof(buf));
 	snprintf(buf, sizeof(buf)-1, "%u", pid);
-	fwrite(buf, sizeof(char), strlen(buf), f);
-	fflush(f);
-	fclose(f);
-
+	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
+		condlog(0, "Cannot write pid to pidfile [%s], error was [%s]",
+			pidFile, strerror(errno));
+		goto fail;
+	}
+	if ((value = fcntl(fd, F_GETFD, 0)) < 0) {
+		condlog(0, "Cannot get close-on-exec flag from pidfile [%s], "
+			"error was [%s]", pidFile, strerror(errno));
+		goto fail;
+	}
+	value |= FD_CLOEXEC;
+	if (fcntl(fd, F_SETFD, value) < 0) {
+		condlog(0, "Cannot set close-on-exec flag from pidfile [%s], "
+			"error was [%s]", pidFile, strerror(errno));
+		goto fail;
+	}
 	return 0;
+fail:
+	close(fd);
+	return 1;
 }
-

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--DKU6Jbt7q3WqK7+M--
