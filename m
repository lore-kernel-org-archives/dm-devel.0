From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath-tools: Improvement to max_fds
Date: Wed, 13 May 2009 23:03:06 -0500
Message-ID: <20090514040306.GA25508@ether.msp.redhat.com>
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

Setting max_fds to unlimited doesn't actually work.  In the kernel, there is a
fixed limit to the maximum number of open fds a process can have.  If you try
to set max_fds to greater than this, it fails.  This patch replaces the special
value "unlimited" with a new special value, "max".  If you set max_fds to "max",
multipath will use the actual system limit, which it looks up from
/proc/sys/fs/nr_open.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c        |   39 +++++++++++++++++++++++++++++++++------
 libmultipath/structs.h     |    1 -
 multipath.conf.annotated   |    2 +-
 multipath/main.c           |   11 +++--------
 multipath/multipath.conf.5 |    8 ++++++++
 multipathd/main.c          |   11 +++--------
 6 files changed, 48 insertions(+), 24 deletions(-)

Index: multipath-tools-090513/libmultipath/dict.c
===================================================================
--- multipath-tools-090513.orig/libmultipath/dict.c
+++ multipath-tools-090513/libmultipath/dict.c
@@ -156,23 +156,52 @@ def_minio_handler(vector strvec)
 }
 
 static int
+get_sys_max_fds(int *max_fds)
+{
+	FILE *file;
+	int nr_open;
+	int ret = 1;
+
+	file = fdopen("/proc/sys/fs/nr_open", "r");
+	if (!file) {
+		fprintf(stderr, "Cannot open /proc/sys/fs/nr_open : %s\n",
+			strerror(errno));
+		return 1;
+	}
+	if (fscanf(file, "%d", &nr_open) != 1) {
+		fprintf(stderr, "Cannot read max open fds from /proc/sys/fs/nr_open");
+		if (ferror(file))
+			fprintf(" : %s\n", strerror(errno));
+		else
+			fprintf("\n");
+	} else {
+		*max_fds = nr_open;
+		ret = 0;
+	}
+	fclose(file);
+	return ret;
+}
+
+
+static int
 max_fds_handler(vector strvec)
 {
 	char * buff;
+	int r = 0;
 
 	buff = set_value(strvec);
 
 	if (!buff)
 		return 1;
 
-	if (strlen(buff) == 9 &&
-	    !strcmp(buff, "unlimited"))
-		conf->max_fds = MAX_FDS_UNLIMITED;
+	if (strlen(buff) == 3 &&
+	    !strcmp(buff, "max"))
+		r = get_sys_max_fds(&conf->max_fds);
 	else
 		conf->max_fds = atoi(buff);
 	FREE(buff);
 
-	return 0;
+	return r;
 }
 
 static int
@@ -1777,8 +1806,6 @@ snprint_max_fds (char * buff, int len, v
 	if (!conf->max_fds)
 		return 0;
 
-	if (conf->max_fds < 0)
-		return snprintf(buff, len, "unlimited");
 	return snprintf(buff, len, "%d", conf->max_fds);
 }
 
Index: multipath-tools-090513/libmultipath/structs.h
===================================================================
--- multipath-tools-090513.orig/libmultipath/structs.h
+++ multipath-tools-090513/libmultipath/structs.h
@@ -24,7 +24,6 @@
 #define NO_PATH_RETRY_FAIL	-1
 #define NO_PATH_RETRY_QUEUE	-2
 
-#define MAX_FDS_UNLIMITED	-1
 
 enum free_path_switch {
 	KEEP_PATHS,
Index: multipath-tools-090513/multipath/main.c
===================================================================
--- multipath-tools-090513.orig/multipath/main.c
+++ multipath-tools-090513/multipath/main.c
@@ -428,14 +428,9 @@ main (int argc, char *argv[])
 
 	if (conf->max_fds) {
 		struct rlimit fd_limit;
-		if (conf->max_fds > 0) {
-			fd_limit.rlim_cur = conf->max_fds;
-			fd_limit.rlim_max = conf->max_fds;
-		}
-		else {
-			fd_limit.rlim_cur = RLIM_INFINITY;
-			fd_limit.rlim_max = RLIM_INFINITY;
-		}
+
+		fd_limit.rlim_cur = conf->max_fds;
+		fd_limit.rlim_max = conf->max_fds;
 		if (setrlimit(RLIMIT_NOFILE, &fd_limit) < 0)
 			condlog(0, "can't set open fds limit to %d : %s\n",
 				conf->max_fds, strerror(errno));
Index: multipath-tools-090513/multipath.conf.annotated
===================================================================
--- multipath-tools-090513.orig/multipath.conf.annotated
+++ multipath-tools-090513/multipath.conf.annotated
@@ -113,7 +113,7 @@
 #	# scope   : multipathd
 #	# desc    : Sets the maximum number of open file descriptors for the
 #	#           multipathd process.
-#	# values  : unlimited|n > 0
+#	# values  : max|n > 0
 #	# default : None
 #	#
 #	max_fds		8192
Index: multipath-tools-090513/multipath/multipath.conf.5
===================================================================
--- multipath-tools-090513.orig/multipath/multipath.conf.5
+++ multipath-tools-090513/multipath/multipath.conf.5
@@ -230,6 +230,14 @@ use the WWID as the alias. In either cas
 be overriden by any specific aliases in the \fImultipaths\fR section.
 Default is
 .I no
+.TP
+.B max_fds
+Specify the maximum number of file descriptors that can be opened by multipath
+and multipathd.  This is equivalent to ulimit -n. A value of \fImax\fR will set
+this to the system limit from /proc/sys/fs/nr_open. If this is not set, the
+maximum number of open fds is taken from the calling process. It is usually
+1024. To be safe, this should be set to the maximum number of paths plus 32,
+if that number is greated than 1024.
 .
 .SH "blacklist section"
 The
Index: multipath-tools-090513/multipathd/main.c
===================================================================
--- multipath-tools-090513.orig/multipathd/main.c
+++ multipath-tools-090513/multipathd/main.c
@@ -1375,14 +1375,9 @@ child (void * param)
 
 	if (conf->max_fds) {
 		struct rlimit fd_limit;
-		if (conf->max_fds > 0) {
-			fd_limit.rlim_cur = conf->max_fds;
-			fd_limit.rlim_max = conf->max_fds;
-		}
-		else {
-			fd_limit.rlim_cur = RLIM_INFINITY;
-			fd_limit.rlim_max = RLIM_INFINITY;
-		}
+
+		fd_limit.rlim_cur = conf->max_fds;
+		fd_limit.rlim_max = conf->max_fds;
 		if (setrlimit(RLIMIT_NOFILE, &fd_limit) < 0)
 			condlog(0, "can't set open fds limit to %d : %s\n",
 				conf->max_fds, strerror(errno));
