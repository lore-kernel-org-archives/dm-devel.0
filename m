From: agk@sourceware.org
Subject: device-mapper/dmeventd dmeventd.c
Date: 16 Jan 2007 20:13:05 -0000
Message-ID: <20070116201305.1608.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-16 20:13:04

Modified files:
	dmeventd       : dmeventd.c 

Log message:
	dmeventd oom_adj + reduce thread stack size

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/dmeventd.c.diff?cvsroot=dm&r1=1.35&r2=1.36

--- device-mapper/dmeventd/dmeventd.c	2007/01/16 18:03:40	1.35
+++ device-mapper/dmeventd/dmeventd.c	2007/01/16 20:13:04	1.36
@@ -66,6 +66,8 @@
 #define DM_THREAD_SHUTDOWN 1
 #define DM_THREAD_DONE     2
 
+#define THREAD_STACK_SIZE 300*1024
+
 /* Data kept about a DSO. */
 struct dso_data {
 	struct list list;
@@ -213,6 +215,15 @@
 	return ret;
 }
 
+/* Create a device monitoring thread. */
+static int _pthread_create_smallstack(pthread_t *t, void *(*fun)(void *), void *arg)
+{
+	pthread_attr_t attr;
+	pthread_attr_init(&attr);
+	pthread_attr_setstacksize(&attr, THREAD_STACK_SIZE);
+	return pthread_create(t, &attr, fun, arg);
+}
+
 static void _free_dso_data(struct dso_data *data)
 {
 	dm_free(data->dso_name);
@@ -458,8 +469,7 @@
 	if (!_timeout_running) {
 		pthread_t timeout_id;
 
-		if (!(ret = -pthread_create(&timeout_id, NULL,
-					    _timeout_thread, NULL)))
+		if (!(ret = -_pthread_create_smallstack(&timeout_id, _timeout_thread, NULL)))
 			_timeout_running = 1;
 	}
 
@@ -688,7 +698,7 @@
 /* Create a device monitoring thread. */
 static int _create_thread(struct thread_status *thread)
 {
-	return pthread_create(&thread->thread, NULL, _monitor_thread, thread);
+	return _pthread_create_smallstack(&thread->thread, _monitor_thread, thread);
 }
 
 static int _terminate_thread(struct thread_status *thread)
@@ -1407,6 +1417,21 @@
 	return 0;
 }
 
+static int _set_oom_adj(int val)
+{
+	FILE *fp;
+
+	fp = fopen("/proc/self/oom_adj", "w");
+
+	if (!fp)
+		return 0;
+
+	fprintf(fp, "%i", val);
+	fclose(fp);
+
+	return 1;
+}
+
 static void _daemonize(void)
 {
 	int status;
@@ -1495,6 +1520,9 @@
 
 	_daemonize();
 
+	if (!_set_oom_adj(-16))
+		syslog(LOG_ERR, "Failed to set oom_adj to protect against OOM killer");
+
 	_init_thread_signals();
 
 	//multilog_clear_logging();
