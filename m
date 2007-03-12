From: Jim Meyering <jim@meyering.net>
Subject: [PATCH]: lib/fs/libdevmapper.c corner cases
Date: Mon, 12 Mar 2007 16:04:24 +0100
Message-ID: <87y7m2o64n.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Here are a couple more fixes I made before I realized that
the affected file isn't even compiled, and when I compile it manually,
I see it lacks a declaration for log_error (missing #include "log.h"?).

For the final hunk, it'd be good to avoid sscanf altogether,
but if you do continue to use it, be sure to have one more
byte in the buffer than the length specified in the format string.

2007-03-12  Jim Meyering  <jim@meyering.net>

	* lib/fs/libdevmapper.c (do_suspend): Detect write failure reliably.
	(do_load): Likewise.
	(find_mount_point): Avoid buffer overrun for unusually long inputs.

Index: lib/fs/libdevmapper.c
===================================================================
RCS file: /cvs/dm/device-mapper/lib/fs/libdevmapper.c,v
retrieving revision 1.13
diff -u -p -r1.13 libdevmapper.c
--- lib/fs/libdevmapper.c	30 Mar 2004 19:08:57 -0000	1.13
+++ lib/fs/libdevmapper.c	12 Mar 2007 15:00:47 -0000
@@ -145,12 +145,20 @@ static int do_suspend(char *mnt, char *n
 		return 0;

 	if ((fp = fopen(path, "w"))) {
+		int write_failed_errno = 0;
 		c = on ? '1' : '0';
-		if (fputc(c, fp) == (int)c)
-			ret = 1;
-		else
-			log_error("%s: fputc failed: %s", path, strerror(errno));
-		fclose(fp);
+		if (fputc(c, fp) == EOF) {
+			write_failed_errno = errno;
+			fclose(fp);
+		} else {
+			if (fclose(fp) == 0)
+				ret = 1;
+			else
+				write_failed_errno = errno;
+		}
+		if (write_failed_errno)
+			log_error("%s: write failed: %s", path,
+				  strerror(write_failed_errno));
 	} else
 		log_error("%s: fopen failed: %s", path, strerror(errno));

@@ -286,9 +294,17 @@ static int do_load(char *mnt, char *name
 		return 0;

 	if ((fd = open(path, O_RDWR)) != -1) {
-		if (!(ret = write_data(fd, dmt)))
-			log_error("%s: write failed: %s", path, strerror(errno));
-		close(fd);
+		int write_failed_errno = 0;
+		if (!(ret = write_data(fd, dmt))) {
+			write_failed_errno = errno;
+			close(fd);
+		} else {
+			if (close(fd) != 0)
+				write_failed_errno = errno;
+		}
+		if (write_failed_errno)
+			log_error("%s: write failed: %s", path,
+				  strerror(write_failed_errno));
 	}

 	free(path);
@@ -333,8 +349,8 @@ static int do_error_check(char *mnt, cha
 static char *find_mount_point(void)
 {
 	FILE *fp;
-	static char mpoint[4096];
-	char fstype[30];
+	static char mpoint[4097];
+	char fstype[31];

 	if (!(fp = fopen("/proc/mounts", "r"))) {
 		log_error("/proc/mounts: fopen failed: %s", strerror(errno));
