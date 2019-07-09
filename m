From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/4] multipath-tools (coverity): assert
 availability of CLOCK_MONOTONIC
Date: Tue, 9 Jul 2019 07:40:03 +0000
Message-ID: <20190709073909.32112-4-martin.wilck@suse.com>
References: <20190709073909.32112-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190709073909.32112-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <Martin.Wilck@suse.com>

clock_gettime() fails only if either an invalid pointer is passed,
or if the requested clock ID is not available. While availability of
CLOCK_REALTIME is guaranteed, CLOCK_MONOTONIC is not, at least not
by POSIX (Linux seems to have it, always). Provide a wrapper that
can be called without error checking, and which aborts in the highly
unlikely case that the monotonic clock can't be obtained. That saves
us from checking the error code of clock_gettime() at every invocation
(handling this sort of error "correctly" is almost impossible anyway),
and should still satisfy coverity.

Not doing this for libdmmp here, as it has it's own error checking
and doesn't use headers from libmultipath.

----
v2: Fix mistake that with -DNDEBUG, clock_gettime wouldn't be called
at all (Bart van Assche).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c |  6 +++---
 libmultipath/time-util.c    |  9 +++++++++
 libmultipath/time-util.h    |  1 +
 multipathd/main.c           | 34 +++++++++++++---------------------
 multipathd/uxlsnr.c         |  8 +++-----
 5 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 6b08dbbb..e886fcf8 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -290,7 +290,7 @@ static void *tur_thread(void *ctx)
 
 static void tur_timeout(struct timespec *tsp)
 {
-	clock_gettime(CLOCK_MONOTONIC, tsp);
+	get_monotonic_time(tsp);
 	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
 	normalize_timespec(tsp);
 }
@@ -300,7 +300,7 @@ static void tur_set_async_timeout(struct checker *c)
 	struct tur_checker_context *ct = c->context;
 	struct timespec now;
 
-	clock_gettime(CLOCK_MONOTONIC, &now);
+	get_monotonic_time(&now);
 	ct->time = now.tv_sec + c->timeout;
 }
 
@@ -309,7 +309,7 @@ static int tur_check_async_timeout(struct checker *c)
 	struct tur_checker_context *ct = c->context;
 	struct timespec now;
 
-	clock_gettime(CLOCK_MONOTONIC, &now);
+	get_monotonic_time(&now);
 	return (now.tv_sec > ct->time);
 }
 
diff --git a/libmultipath/time-util.c b/libmultipath/time-util.c
index 6d79c0e5..a3739a2d 100644
--- a/libmultipath/time-util.c
+++ b/libmultipath/time-util.c
@@ -3,6 +3,15 @@
 #include <time.h>
 #include "time-util.h"
 
+void get_monotonic_time(struct timespec *res)
+{
+	struct timespec ts;
+	int rv = clock_gettime(CLOCK_MONOTONIC, &ts);
+
+	assert(rv == 0);
+	*res = ts;
+}
+
 /* Initialize @cond as a condition variable that uses the monotonic clock */
 void pthread_cond_init_mono(pthread_cond_t *cond)
 {
diff --git a/libmultipath/time-util.h b/libmultipath/time-util.h
index b76d2aa4..b23d328a 100644
--- a/libmultipath/time-util.h
+++ b/libmultipath/time-util.h
@@ -5,6 +5,7 @@
 
 struct timespec;
 
+void get_monotonic_time(struct timespec *res);
 void pthread_cond_init_mono(pthread_cond_t *cond);
 void normalize_timespec(struct timespec *ts);
 void timespecsub(const struct timespec *a, const struct timespec *b,
diff --git a/multipathd/main.c b/multipathd/main.c
index 7a5cd115..2e4973d7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -283,11 +283,10 @@ int set_config_state(enum daemon_status state)
 		else if (running_state != DAEMON_IDLE) {
 			struct timespec ts;
 
-			if (clock_gettime(CLOCK_MONOTONIC, &ts) == 0) {
-				ts.tv_sec += 1;
-				rc = pthread_cond_timedwait(&config_cond,
-							    &config_lock, &ts);
-			}
+			get_monotonic_time(&ts);
+			ts.tv_sec += 1;
+			rc = pthread_cond_timedwait(&config_cond,
+						    &config_lock, &ts);
 		}
 		if (!rc && (running_state != DAEMON_SHUTDOWN)) {
 			running_state = state;
@@ -1888,15 +1887,12 @@ static int check_path_reinstate_state(struct path * pp) {
 	}
 
 	if (pp->disable_reinstate) {
-		/* If we don't know how much time has passed, automatically
-		 * reinstate the path, just to be safe. Also, if there are
-		 * no other usable paths, reinstate the path
-		 */
-		if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0 ||
-				pp->mpp->nr_active == 0) {
+		/* If there are no other usable paths, reinstate the path */
+		if (pp->mpp->nr_active == 0) {
 			condlog(2, "%s : reinstating path early", pp->dev);
 			goto reinstate_path;
 		}
+		get_monotonic_time(&curr_time);
 		if ((curr_time.tv_sec - pp->dis_reinstate_time ) > pp->mpp->san_path_err_recovery_time) {
 			condlog(2,"%s : reinstate the path after err recovery time", pp->dev);
 			goto reinstate_path;
@@ -1932,8 +1928,7 @@ static int check_path_reinstate_state(struct path * pp) {
 	 * delay the path, so there's no point in checking if we should
 	 */
 
-	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
-		return 0;
+	get_monotonic_time(&curr_time);
 	/* when path failures has exceeded the san_path_err_threshold
 	 * place the path in delayed state till san_path_err_recovery_time
 	 * so that the cutomer can rectify the issue within this time. After
@@ -2315,17 +2310,14 @@ checkerloop (void *ap)
 	condlog(2, "path checkers start up");
 
 	/* Tweak start time for initial path check */
-	if (clock_gettime(CLOCK_MONOTONIC, &last_time) != 0)
-		last_time.tv_sec = 0;
-	else
-		last_time.tv_sec -= 1;
+	get_monotonic_time(&last_time);
+	last_time.tv_sec -= 1;
 
 	while (1) {
 		struct timespec diff_time, start_time, end_time;
 		int num_paths = 0, ticks = 0, strict_timing, rc = 0;
 
-		if (clock_gettime(CLOCK_MONOTONIC, &start_time) != 0)
-			start_time.tv_sec = 0;
+		get_monotonic_time(&start_time);
 		if (start_time.tv_sec && last_time.tv_sec) {
 			timespecsub(&start_time, &last_time, &diff_time);
 			condlog(4, "tick (%lu.%06lu secs)",
@@ -2384,8 +2376,8 @@ checkerloop (void *ap)
 		}
 
 		diff_time.tv_nsec = 0;
-		if (start_time.tv_sec &&
-		    clock_gettime(CLOCK_MONOTONIC, &end_time) == 0) {
+		if (start_time.tv_sec) {
+			get_monotonic_time(&end_time);
 			timespecsub(&end_time, &start_time, &diff_time);
 			if (num_paths) {
 				unsigned int max_checkint;
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 04cbb7c7..bc71679e 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -130,10 +130,10 @@ void check_timeout(struct timespec start_time, char *inbuf,
 {
 	struct timespec diff_time, end_time;
 
-	if (start_time.tv_sec &&
-	    clock_gettime(CLOCK_MONOTONIC, &end_time) == 0) {
+	if (start_time.tv_sec) {
 		unsigned long msecs;
 
+		get_monotonic_time(&end_time);
 		timespecsub(&end_time, &start_time, &diff_time);
 		msecs = diff_time.tv_sec * 1000 +
 			diff_time.tv_nsec / (1000 * 1000);
@@ -280,9 +280,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 						i, polls[i].fd);
 					continue;
 				}
-				if (clock_gettime(CLOCK_MONOTONIC, &start_time)
-				    != 0)
-					start_time.tv_sec = 0;
+				get_monotonic_time(&start_time);
 				if (recv_packet_from_client(c->fd, &inbuf,
 							    uxsock_timeout)
 				    != 0) {
-- 
2.22.0
