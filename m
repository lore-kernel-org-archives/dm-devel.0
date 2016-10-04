From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 05/15] multipathd,
 libmultipathd: Make delays independent of clock jumps
Date: Tue, 4 Oct 2016 10:38:42 -0700
Message-ID: <ec6115d4-9147-894d-830c-09de71679cb9@sandisk.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Time synchronization software like ntpd can adjust the clock
forwards and backwards. Avoid that the duration of a delay is
influenced by clock jumps initiated by time synchronization
software.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 libmultipath/Makefile       |  2 +-
 libmultipath/checkers/rbd.c | 12 +++++-------
 libmultipath/checkers/tur.c | 20 +++++++++-----------
 libmultipath/time-util.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 libmultipath/time-util.h    | 13 +++++++++++++
 multipathd/cli.c            |  6 ++----
 multipathd/main.c           | 39 +++++++++++++++++++++++----------------
 multipathd/uxlsnr.c         | 19 +++++++++++--------
 8 files changed, 106 insertions(+), 47 deletions(-)
 create mode 100644 libmultipath/time-util.c
 create mode 100644 libmultipath/time-util.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 92f130c..495cebe 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -47,7 +47,7 @@ endif
 OBJS = memory.o parser.o vector.o devmapper.o callout.o \
 	hwtable.o blacklist.o util.o dmparser.o config.o \
 	structs.o discovery.o propsel.o dict.o \
-	pgpolicies.o debug.o defaults.o uevent.o \
+	pgpolicies.o debug.o defaults.o uevent.o time-util.o \
 	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
 	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
 	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
index 41259c3..bfec2c9 100644
--- a/libmultipath/checkers/rbd.c
+++ b/libmultipath/checkers/rbd.c
@@ -27,6 +27,7 @@
 
 #include "../libmultipath/debug.h"
 #include "../libmultipath/uevent.h"
+#include "../libmultipath/time-util.h"
 
 struct rbd_checker_context;
 typedef int (thread_fn)(struct rbd_checker_context *ct, char *msg);
@@ -75,7 +76,7 @@ int libcheck_init(struct checker * c)
 		return 1;
 	memset(ct, 0, sizeof(struct rbd_checker_context));
 	ct->holders = 1;
-	pthread_cond_init(&ct->active, NULL);
+	pthread_cond_init_mono(&ct->active);
 	pthread_mutex_init(&ct->lock, NULL);
 	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
 	c->context = ct;
@@ -538,12 +539,9 @@ static void *rbd_thread(void *ctx)
 
 static void rbd_timeout(struct timespec *tsp)
 {
-	struct timeval now;
-
-	gettimeofday(&now, NULL);
-	tsp->tv_sec = now.tv_sec;
-	tsp->tv_nsec = now.tv_usec * 1000;
-	tsp->tv_nsec += 1000000; /* 1 millisecond */
+	clock_gettime(CLOCK_MONOTONIC, tsp);
+	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
+	normalize_timespec(tsp);
 }
 
 static int rbd_exec_fn(struct checker *c, thread_fn *fn)
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 94e4190..ac272d4 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -20,6 +20,7 @@
 #include "../libmultipath/debug.h"
 #include "../libmultipath/sg_include.h"
 #include "../libmultipath/uevent.h"
+#include "../libmultipath/time-util.h"
 
 #define TUR_CMD_LEN 6
 #define HEAVY_CHECK_COUNT       10
@@ -60,7 +61,7 @@ int libcheck_init (struct checker * c)
 	ct->state = PATH_UNCHECKED;
 	ct->fd = -1;
 	ct->holders = 1;
-	pthread_cond_init(&ct->active, NULL);
+	pthread_cond_init_mono(&ct->active);
 	pthread_mutex_init(&ct->lock, NULL);
 	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
 	c->context = ct;
@@ -237,29 +238,26 @@ static void *tur_thread(void *ctx)
 
 static void tur_timeout(struct timespec *tsp)
 {
-	struct timeval now;
-
-	gettimeofday(&now, NULL);
-	tsp->tv_sec = now.tv_sec;
-	tsp->tv_nsec = now.tv_usec * 1000;
-	tsp->tv_nsec += 1000000; /* 1 millisecond */
+	clock_gettime(CLOCK_MONOTONIC, tsp);
+	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
+	normalize_timespec(tsp);
 }
 
 static void tur_set_async_timeout(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
-	struct timeval now;
+	struct timespec now;
 
-	gettimeofday(&now, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &now);
 	ct->time = now.tv_sec + c->timeout;
 }
 
 static int tur_check_async_timeout(struct checker *c)
 {
 	struct tur_checker_context *ct = c->context;
-	struct timeval now;
+	struct timespec now;
 
-	gettimeofday(&now, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &now);
 	return (now.tv_sec > ct->time);
 }
 
diff --git a/libmultipath/time-util.c b/libmultipath/time-util.c
new file mode 100644
index 0000000..6d79c0e
--- /dev/null
+++ b/libmultipath/time-util.c
@@ -0,0 +1,42 @@
+#include <assert.h>
+#include <pthread.h>
+#include <time.h>
+#include "time-util.h"
+
+/* Initialize @cond as a condition variable that uses the monotonic clock */
+void pthread_cond_init_mono(pthread_cond_t *cond)
+{
+	pthread_condattr_t attr;
+	int res;
+
+	res = pthread_condattr_init(&attr);
+	assert(res == 0);
+	res = pthread_condattr_setclock(&attr, CLOCK_MONOTONIC);
+	assert(res == 0);
+	res = pthread_cond_init(cond, &attr);
+	assert(res == 0);
+	res = pthread_condattr_destroy(&attr);
+	assert(res == 0);
+}
+
+/* Ensure that 0 <= ts->tv_nsec && ts->tv_nsec < 1000 * 1000 * 1000. */
+void normalize_timespec(struct timespec *ts)
+{
+	while (ts->tv_nsec < 0) {
+		ts->tv_nsec += 1000UL * 1000 * 1000;
+		ts->tv_sec--;
+	}
+	while (ts->tv_nsec >= 1000UL * 1000 * 1000) {
+		ts->tv_nsec -= 1000UL * 1000 * 1000;
+		ts->tv_sec++;
+	}
+}
+
+/* Compute *res = *a - *b */
+void timespecsub(const struct timespec *a, const struct timespec *b,
+		 struct timespec *res)
+{
+	res->tv_sec = a->tv_sec - b->tv_sec;
+	res->tv_nsec = a->tv_nsec - b->tv_nsec;
+	normalize_timespec(res);
+}
diff --git a/libmultipath/time-util.h b/libmultipath/time-util.h
new file mode 100644
index 0000000..b76d2aa
--- /dev/null
+++ b/libmultipath/time-util.h
@@ -0,0 +1,13 @@
+#ifndef _TIME_UTIL_H_
+#define _TIME_UTIL_H_
+
+#include <pthread.h>
+
+struct timespec;
+
+void pthread_cond_init_mono(pthread_cond_t *cond);
+void normalize_timespec(struct timespec *ts);
+void timespecsub(const struct timespec *a, const struct timespec *b,
+		 struct timespec *res);
+
+#endif /* _TIME_UTIL_H_ */
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 9a19728..e8a9384 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -454,7 +454,6 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 	struct handler * h;
 	vector cmdvec = NULL;
 	struct timespec tmo;
-	struct timeval now;
 
 	r = get_cmdvec(cmd, &cmdvec);
 
@@ -476,9 +475,8 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 	/*
 	 * execute handler
 	 */
-	if (gettimeofday(&now, NULL) == 0) {
-		tmo.tv_sec = now.tv_sec + timeout;
-		tmo.tv_nsec = now.tv_usec * 1000;
+	if (clock_gettime(CLOCK_MONOTONIC, &tmo) == 0) {
+		tmo.tv_sec += timeout;
 	} else {
 		tmo.tv_sec = 0;
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index 96ef01f..f4cd906 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -25,6 +25,11 @@
 #include <time.h>
 
 /*
+ * libmultipath
+ */
+#include "time-util.h"
+
+/*
  * libcheckers
  */
 #include "checkers.h"
@@ -106,7 +111,7 @@ int ignore_new_devs;
 enum daemon_status running_state = DAEMON_INIT;
 pid_t daemon_pid;
 pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
-pthread_cond_t config_cond = PTHREAD_COND_INITIALIZER;
+pthread_cond_t config_cond;
 
 /*
  * global copy of vecs for use in sig handlers
@@ -193,7 +198,7 @@ int set_config_state(enum daemon_status state)
 		if (running_state != DAEMON_IDLE) {
 			struct timespec ts;
 
-			clock_gettime(CLOCK_REALTIME, &ts);
+			clock_gettime(CLOCK_MONOTONIC, &ts);
 			ts.tv_sec += 1;
 			rc = pthread_cond_timedwait(&config_cond,
 						    &config_lock, &ts);
@@ -1744,7 +1749,7 @@ checkerloop (void *ap)
 	int count = 0;
 	unsigned int i;
 	struct itimerval timer_tick_it;
-	struct timeval last_time;
+	struct timespec last_time;
 	struct config *conf;
 
 	pthread_cleanup_push(rcu_unregister, NULL);
@@ -1763,24 +1768,23 @@ checkerloop (void *ap)
 	}
 
 	/* Tweak start time for initial path check */
-	if (gettimeofday(&last_time, NULL) != 0)
+	if (clock_gettime(CLOCK_MONOTONIC, &last_time) != 0)
 		last_time.tv_sec = 0;
 	else
 		last_time.tv_sec -= 1;
 
 	while (1) {
-		struct timeval diff_time, start_time, end_time;
+		struct timespec diff_time, start_time, end_time;
 		int num_paths = 0, ticks = 0, signo, strict_timing, rc = 0;
 		sigset_t mask;
 
-		if (gettimeofday(&start_time, NULL) != 0)
+		if (clock_gettime(CLOCK_MONOTONIC, &start_time) != 0)
 			start_time.tv_sec = 0;
 		if (start_time.tv_sec && last_time.tv_sec) {
-			timersub(&start_time, &last_time, &diff_time);
+			timespecsub(&start_time, &last_time, &diff_time);
 			condlog(4, "tick (%lu.%06lu secs)",
-				diff_time.tv_sec, diff_time.tv_usec);
-			last_time.tv_sec = start_time.tv_sec;
-			last_time.tv_usec = start_time.tv_usec;
+				diff_time.tv_sec, diff_time.tv_nsec / 1000);
+			last_time = start_time;
 			ticks = diff_time.tv_sec;
 		} else {
 			ticks = 1;
@@ -1831,16 +1835,17 @@ checkerloop (void *ap)
 			lock_cleanup_pop(vecs->lock);
 		}
 
-		diff_time.tv_usec = 0;
+		diff_time.tv_nsec = 0;
 		if (start_time.tv_sec &&
-		    gettimeofday(&end_time, NULL) == 0) {
-			timersub(&end_time, &start_time, &diff_time);
+		    clock_gettime(CLOCK_MONOTONIC, &end_time) == 0) {
+			timespecsub(&end_time, &start_time, &diff_time);
 			if (num_paths) {
 				unsigned int max_checkint;
 
 				condlog(3, "checked %d path%s in %lu.%06lu secs",
 					num_paths, num_paths > 1 ? "s" : "",
-					diff_time.tv_sec, diff_time.tv_usec);
+					diff_time.tv_sec,
+					diff_time.tv_nsec / 1000);
 				conf = get_multipath_config();
 				max_checkint = conf->max_checkint;
 				put_multipath_config(conf);
@@ -1861,10 +1866,10 @@ checkerloop (void *ap)
 		else {
 			timer_tick_it.it_interval.tv_sec = 0;
 			timer_tick_it.it_interval.tv_usec = 0;
-			if (diff_time.tv_usec) {
+			if (diff_time.tv_nsec) {
 				timer_tick_it.it_value.tv_sec = 0;
 				timer_tick_it.it_value.tv_usec =
-					(unsigned long)1000000 - diff_time.tv_usec;
+				     1000UL * 1000 * 1000 - diff_time.tv_nsec;
 			} else {
 				timer_tick_it.it_value.tv_sec = 1;
 				timer_tick_it.it_value.tv_usec = 0;
@@ -2523,6 +2528,8 @@ main (int argc, char *argv[])
 			strerror(errno));
 	umask(umask(077) | 022);
 
+	pthread_cond_init_mono(&config_cond);
+	
 	udev = udev_new();
 
 	while ((arg = getopt(argc, argv, ":dsv:k::Bn")) != EOF ) {
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 7a9faf3..daaaa99 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -32,6 +32,7 @@
 #include "defaults.h"
 #include "config.h"
 #include "mpath_cmd.h"
+#include "time-util.h"
 
 #include "main.h"
 #include "cli.h"
@@ -99,21 +100,22 @@ void free_polls (void)
 		FREE(polls);
 }
 
-void check_timeout(struct timeval start_time, char *inbuf,
+void check_timeout(struct timespec start_time, char *inbuf,
 		   unsigned int timeout)
 {
-	struct timeval diff_time, end_time;
+	struct timespec diff_time, end_time;
 
-	if (start_time.tv_sec && gettimeofday(&end_time, NULL) == 0) {
-		timersub(&end_time, &start_time, &diff_time);
+	if (start_time.tv_sec &&
+	    clock_gettime(CLOCK_MONOTONIC, &end_time) == 0) {
 		unsigned long msecs;
 
+		timespecsub(&end_time, &start_time, &diff_time);
 		msecs = diff_time.tv_sec * 1000 +
-			diff_time.tv_usec / 1000;
+			diff_time.tv_nsec / (1000 * 1000);
 		if (msecs > timeout)
 			condlog(2, "cli cmd '%s' timeout reached "
 				"after %lu.%06lu secs", inbuf,
-				diff_time.tv_sec, diff_time.tv_usec);
+				diff_time.tv_sec, diff_time.tv_nsec / 1000);
 	}
 }
 
@@ -220,7 +222,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		/* see if a client wants to speak to us */
 		for (i = 1; i < num_clients + 1; i++) {
 			if (polls[i].revents & POLLIN) {
-				struct timeval start_time;
+				struct timespec start_time;
 
 				c = NULL;
 				pthread_mutex_lock(&client_lock);
@@ -236,7 +238,8 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 						i, polls[i].fd);
 					continue;
 				}
-				if (gettimeofday(&start_time, NULL) != 0)
+				if (clock_gettime(CLOCK_MONOTONIC, &start_time)
+				    != 0)
 					start_time.tv_sec = 0;
 				if (recv_packet(c->fd, &inbuf,
 						uxsock_timeout) != 0) {
-- 
2.10.0
