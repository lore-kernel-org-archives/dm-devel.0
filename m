From: Ankit Jain <jankit@suse.de>
Subject: [PATCH] multipathd: Disassociate from /dev/console when
	daemonizing
Date: Wed, 11 May 2011 23:14:24 +0530
Message-ID: <4DCACAF8.2080803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Currently, multipathd redirects stdout/stderr to /dev/console,
to be able to show error messages when all else fails.

This patch redirects them to /dev/null instead, to make it a
well behaving daemon. This corresponds to FATE request
https://fate.novell.com/310684 .

This is based on -
git://git.kernel.org/pub/scm/linux/storage/multipath-tools/

----
commit a3dd997d1b0b55a934103e0b28648003675743e3
Author: Ankit Jain <jankit@suse.de>
Date:   Wed May 11 22:18:33 2011 +0530

    multipathd: Disassociate from /dev/console

    When daemonizing, redirect stdout/stderr to /dev/null
    instead of /dev/console. Also, chdir("/") before the redirection,
    so that any error can be reported.
    FATE#310684.

diff --git a/multipathd/main.c b/multipathd/main.c
index e8eee9e..cb77c82 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1540,7 +1540,7 @@ static int
 daemonize(void)
 {
 	int pid;
-	int in_fd, out_fd;
+	int dev_null_fd;

 	if( (pid = fork()) < 0){
 		fprintf(stderr, "Failed first fork : %s\n", strerror(errno));
@@ -1556,31 +1556,24 @@ daemonize(void)
 	else if (pid != 0)
 		_exit(0);

-	in_fd = open("/dev/null", O_RDONLY);
-	if (in_fd < 0){
-		fprintf(stderr, "cannot open /dev/null for input : %s\n",
-			strerror(errno));
-		_exit(0);
-	}
-	out_fd = open("/dev/console", O_WRONLY);
-	if (out_fd < 0){
-		fprintf(stderr, "cannot open /dev/console for output : %s\n",
+	if (chdir("/") < 0)
+		fprintf(stderr, "cannot chdir to '/', continuing\n");
+
+	dev_null_fd = open("/dev/null", O_RDWR);
+	if (dev_null_fd < 0){
+		fprintf(stderr, "cannot open /dev/null for input & output : %s\n",
 			strerror(errno));
 		_exit(0);
 	}

 	close(STDIN_FILENO);
-	dup(in_fd);
+	dup(dev_null_fd);
 	close(STDOUT_FILENO);
-	dup(out_fd);
+	dup(dev_null_fd);
 	close(STDERR_FILENO);
-	dup(out_fd);
-
-	close(in_fd);
-	close(out_fd);
-	if (chdir("/") < 0)
-		fprintf(stderr, "cannot chdir to '/', continuing\n");
+	dup(dev_null_fd);

+	close(dev_null_fd);
 	return 0;
 }


-- 
Ankit Jain
SUSE Labs
