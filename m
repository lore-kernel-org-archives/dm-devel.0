From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: improved daemon setup
Date: Wed, 9 Nov 2005 16:00:16 -0600
Message-ID: <20051109220015.GD26529@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
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


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

If you log into a machine and start the multipathd daemon, you will hang on
logout, because multipathd doesn't fully detach itself from the calling
processes. Also, occasionally the device mapper library functions will print
error messages to stdout.  These appear in the terminal that was used to
start multipathd, if it was started by hand (not by init scripts).  To fix these
I added some code to fully daemonize multipathd, and redirect stdout and
stderr to /dev/console.

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="daemonize.patch"

diff -urpN a/multipathd/main.c b/multipathd/main.c
--- a/multipathd/main.c	2005-11-07 12:13:07.000000000 -0600
+++ b/multipathd/main.c	2005-11-09 14:52:36.000000000 -0600
@@ -3,6 +3,9 @@
 #include <libdevmapper.h>
 #include <wait.h>
 #include <sys/mman.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <errno.h>
 
 /*
  * libsysfs
@@ -1559,6 +1562,53 @@ child (void * param)
 	exit(0);
 }
 
+static int
+daemonize(void)
+{
+	int pid, i;
+	int in_fd, out_fd;
+
+	if( (pid = fork()) < 0){
+		fprintf(stderr, "Failed first fork : %s\n", strerror(errno));
+		return -1;
+	}
+	else if (pid != 0)
+		return pid;
+
+	setsid();
+
+	if ( (pid = fork()) < 0)
+		fprintf(stderr, "Failed second fork : %s\n", strerror(errno));
+	else if (pid != 0)
+		_exit(0);
+
+	in_fd = open("/dev/null", O_RDONLY);
+	if (in_fd < 0){
+		fprintf(stderr, "cannot open /dev/null for input : %s\n",
+			strerror(errno));
+		_exit(0);
+	}
+	out_fd = open("/dev/console", O_WRONLY);
+	if (out_fd < 0){
+		fprintf(stderr, "cannot open /dev/console for output : %s\n",
+			strerror(errno));
+		_exit(0);
+	}
+
+	close(STDIN_FILENO);
+	dup(in_fd);
+	close(STDOUT_FILENO);
+	dup(out_fd);
+	close(STDERR_FILENO);
+	dup(out_fd);
+
+	close(in_fd);
+	close(out_fd);
+	chdir("/");
+	umask(0);
+	return 0;
+}
+
 int
 main (int argc, char *argv[])
 {
@@ -1607,7 +1657,7 @@ main (int argc, char *argv[])
 	if (!logsink)
 		err = 0;
 	else
-		err = fork();
+		err = daemonize();
 	
 	if (err < 0)
 		/* error */

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--OXfL5xGRrasGEqWY--
