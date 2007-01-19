From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmeventd/dmeventd.c
Date: 19 Jan 2007 17:22:17 -0000
Message-ID: <20070119172217.18968.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-01-19 17:22:17

Modified files:
	.              : WHATS_NEW 
	dmeventd       : dmeventd.c 

Log message:
	Add cmdline debug & version options to dmeventd.
	Fix oom_adj handling.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.154&r2=1.155
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.40&r2=1.41

--- device-mapper/WHATS_NEW	2007/01/19 15:53:00	1.154
+++ device-mapper/WHATS_NEW	2007/01/19 17:22:17	1.155
@@ -1,5 +1,6 @@
 Version 1.02.16 -
 ===================================
+  Add cmdline debug & version options to dmeventd.
   Add DM_LIB_VERSION definition to configure.h.
   Suppress 'Unrecognised field' error if report field is 'help'.
   Add --separator and --sort to dmsetup (unused).
--- device-mapper/dmeventd/dmeventd.c	2007/01/17 14:45:10	1.40
+++ device-mapper/dmeventd/dmeventd.c	2007/01/19 17:22:17	1.41
@@ -39,7 +39,12 @@
 #include <arpa/inet.h>		/* for htonl, ntohl */
 
 #ifdef linux
-#include <malloc.h>
+#  include <malloc.h>
+
+/* From linux/oom.h */
+#  define OOM_DISABLE (-17)
+#  define OOM_ADJUST_MIN (-16)
+
 #endif
 
 /* FIXME We use syslog for now, because multilog is not yet implemented */
@@ -47,6 +52,7 @@
 
 static volatile sig_atomic_t _exit_now = 0;	/* set to '1' when signal is given to exit */
 static volatile sig_atomic_t _thread_registries_empty = 1;	/* registries are empty initially */
+static int _debug = 0;
 
 /* List (un)link macros. */
 #define	LINK(x, head)		list_add(head, &(x)->list)
@@ -58,9 +64,10 @@
 #define	UNLINK_THREAD(x)	UNLINK(x)
 
 #define DAEMON_NAME "dmeventd"
+#define OOM_ADJ_FILE "/proc/self/oom_adj"
 
 /*
-  Global mutex for thread list access. Has to be held when: 
+  Global mutex for thread list access. Has to be held when:
   - iterating thread list
   - adding or removing elements from thread list
   - changing or reading thread_status's fields:
@@ -75,6 +82,8 @@
 
 #define THREAD_STACK_SIZE (300*1024)
 
+#define DEBUGLOG(fmt, args...) _debuglog(fmt, ## args)
+
 /* Data kept about a DSO. */
 struct dso_data {
 	struct list list;
@@ -172,6 +181,24 @@
 static pthread_mutex_t _timeout_mutex = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t _timeout_cond = PTHREAD_COND_INITIALIZER;
 
+static void _debuglog(const char *fmt, ...)
+{
+        time_t P;
+        va_list ap;
+ 
+        if (!_debug)
+                return;
+ 
+        va_start(ap,fmt);
+
+        time(&P);
+        fprintf(stderr, "dmeventd[%x]: %.15s ", (int)pthread_self(), ctime(&P)+4 );
+        vfprintf(stderr, fmt, ap);
+	fprintf(stderr, "\n");
+
+        va_end(ap);
+}
+
 /* Allocate/free the status structure for a monitoring thread. */
 static struct thread_status *_alloc_thread_status(struct message_data *data,
 						  struct dso_data *dso_data)
@@ -883,11 +910,11 @@
 	   almost as good as dead already... */
 	if (thread_new->events & DM_EVENT_TIMEOUT) {
 		ret = -_register_for_timeout(thread);
-                if (ret) {
-                    _unlock_mutex();
-                    goto out;
-                }
-        }
+		if (ret) {
+		    _unlock_mutex();
+		    goto out;
+		}
+	}
 
 	if (!(thread = _lookup_thread_status(message_data))) {
 		_unlock_mutex();
@@ -1361,7 +1388,7 @@
 		if (thread->status == DM_THREAD_RUNNING) {
 			thread->status = DM_THREAD_SHUTDOWN;
 			break;
-		} 
+		}
 
 		if (thread->status == DM_THREAD_SHUTDOWN) {
 			if (!thread->events) {
@@ -1377,7 +1404,7 @@
 					stack;
 				}
 				break;
-			} 
+			}
 
 			list_del(l);
 			syslog(LOG_ERR,
@@ -1465,31 +1492,39 @@
 	return 0;
 }
 
+/*
+ * Protection against OOM killer if kernel supports it
+ */
 static int _set_oom_adj(int val)
 {
 	FILE *fp;
 
 	struct stat st;
 
-	if (stat("/proc/self/oom_adj", &st) == -1)
-		return -errno;
-
-	fp = fopen("/proc/self/oom_adj", "w");
+	if (stat(OOM_ADJ_FILE, &st) == -1) {
+		if (errno == ENOENT)
+			DEBUGLOG(OOM_ADJ_FILE " not found");
+		else
+			perror(OOM_ADJ_FILE ": stat failed");
+		return 1;
+	}
 
-	if (!fp)
-		return -1;
+	if (!(fp = fopen(OOM_ADJ_FILE, "w"))) {
+		perror(OOM_ADJ_FILE ": fopen failed");
+		return 0;
+	}
 
 	fprintf(fp, "%i", val);
 	fclose(fp);
 
-	return 0;
+	return 1;
 }
 
 static void _daemonize(void)
 {
-	int status;
-	int pid;
+	int child_status;
 	int fd;
+	pid_t pid;
 	struct rlimit rlim;
 	struct timeval tval;
 	sigset_t my_sigset;
@@ -1501,14 +1536,17 @@
 	}
 	signal(SIGTERM, &_exit_handler);
 
-	pid = fork();
-
-	if (pid < 0)
+	switch (pid = fork()) {
+	case -1:
+		perror("fork failed:");
 		exit(EXIT_FAILURE);
 
-	if (pid) {
+	case 0:		/* Child */
+		break;
+
+	default:
 		/* Wait for response from child */
-		while (!waitpid(pid, &status, WNOHANG) && !_exit_now) {
+		while (!waitpid(pid, &child_status, WNOHANG) && !_exit_now) {
 			tval.tv_sec = 0;
 			tval.tv_usec = 250000;	/* .25 sec */
 			select(0, NULL, NULL, NULL, &tval);
@@ -1518,7 +1556,7 @@
 			exit(EXIT_SUCCESS);
 
 		/* Problem with child.  Determine what it is by exit code */
-		switch (WEXITSTATUS(status)) {
+		switch (WEXITSTATUS(child_status)) {
 		case EXIT_LOCKFILE_INUSE:
 			break;
 		case EXIT_DESC_CLOSE_FAILURE:
@@ -1535,10 +1573,9 @@
 			break;
 		}
 
-		exit(EXIT_FAILURE);	/* Redundant */
+		exit(child_status);
 	}
 
-	setsid();
 	if (chdir("/"))
 		exit(EXIT_CHDIR_FAILURE);
 
@@ -1555,28 +1592,61 @@
 	    (open("/dev/null", O_WRONLY) < 0))
 		exit(EXIT_DESC_OPEN_FAILURE);
 
-	openlog("dmeventd", LOG_PID, LOG_DAEMON);
-
-	_lock_pidfile();		/* exits if failure */
+	setsid();
+}
 
-	/* Set the rest of the signals to cause '_exit_now' to be set */
-	signal(SIGINT, &_exit_handler);
-	signal(SIGHUP, &_exit_handler);
-	signal(SIGQUIT, &_exit_handler);
+static void usage(char *prog, FILE *file)
+{
+	fprintf(file, "Usage:\n");
+	fprintf(file, "%s [Vhd]\n", prog);
+	fprintf(file, "\n");
+	fprintf(file, "   -V       Show version of dmeventd\n");
+	fprintf(file, "   -h       Show this help information\n");
+	fprintf(file, "   -d       Don't fork, run in the foreground\n");
+	fprintf(file, "\n");
 }
 
 int main(int argc, char *argv[])
 {
 	int ret;
+	signed char opt;
 	struct dm_event_fifos fifos;
 	//struct sys_log logdata = {DAEMON_NAME, LOG_DAEMON};
 
-	_daemonize();
+	opterr = 0;
+	optind = 0;
 
-	/*
-	 * ENOENT means the kernel does not support oom_adj
-	 */
-	if (_set_oom_adj(-16) != -ENOENT)
+	while ((opt = getopt(argc, argv, "?hVd")) != EOF) {
+		switch (opt) {
+		case 'h':
+			usage(argv[0], stdout);
+			exit(0);
+		case '?':
+			usage(argv[0], stderr);
+			exit(0);
+		case 'd':
+			_debug++;
+			break;
+		case 'V':
+			printf("dmeventd version: %s\n", DM_LIB_VERSION);
+			exit(1);
+			break;
+		}
+	}
+
+	if (!_debug)
+		_daemonize();
+
+	openlog("dmeventd", LOG_PID, LOG_DAEMON);
+
+	_lock_pidfile();		/* exits if failure */
+
+	/* Set the rest of the signals to cause '_exit_now' to be set */
+	signal(SIGINT, &_exit_handler);
+	signal(SIGHUP, &_exit_handler);
+	signal(SIGQUIT, &_exit_handler);
+
+	if (!_set_oom_adj(OOM_DISABLE) && !_set_oom_adj(OOM_ADJUST_MIN))
 		syslog(LOG_ERR, "Failed to set oom_adj to protect against OOM killer");
 
 	_init_thread_signals();
@@ -1600,7 +1670,7 @@
 
 	/* Signal parent, letting them know we are ready to go. */
 	kill(getppid(), SIGTERM);
-	syslog(LOG_INFO, "dmeventd ready for processing.");
+	syslog(LOG_NOTICE, "dmeventd ready for processing.");
 
 	while (!_exit_now) {
 		_process_request(&fifos);
@@ -1619,7 +1689,8 @@
 #endif
 	pthread_mutex_destroy(&_global_mutex);
 
-	syslog(LOG_INFO, "dmeventd shutting down.");
+	syslog(LOG_NOTICE, "dmeventd shutting down.");
 	closelog();
+
 	exit(EXIT_SUCCESS);
 }
