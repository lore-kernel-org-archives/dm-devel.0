From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 50/57] multipathd: strict loop timings
Date: Wed, 27 Apr 2016 13:10:51 +0200
Message-ID: <1461755458-29225-51-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This patch implements a new configuration value 'strict_timing',
which causes each path checker loop to start at exactly one second
after the last one. Longer path checker loops will be properly
accounted, so that each path is guaranteed to be checked within
'polling_interval' seconds.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.h      |  1 +
 libmultipath/dict.c        |  4 +++
 multipath/multipath.conf.5 | 14 ++++++++
 multipathd/main.c          | 79 +++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 87 insertions(+), 11 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index e9828ea..466e31e 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -135,6 +135,7 @@ struct config {
 	int delay_watch_checks;
 	int delay_wait_checks;
 	int uxsock_timeout;
+	int strict_timing;
 	int retrigger_tries;
 	int retrigger_delay;
 	int ignore_new_devs;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 89d42a1..7f912ec 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -399,6 +399,9 @@ declare_def_snprint(retrigger_delay, print_int)
 declare_def_handler(uev_wait_timeout, set_int)
 declare_def_snprint(uev_wait_timeout, print_int)
 
+declare_def_handler(strict_timing, set_yes_no)
+declare_def_snprint(strict_timing, print_yes_no)
+
 static int
 def_config_dir_handler(vector strvec)
 {
@@ -1365,6 +1368,7 @@ init_keywords(void)
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
+	install_keyword("strict_timing", &def_strict_timing_handler, &snprint_def_strict_timing);
 	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
 	install_keyword("partition_delimiter", &def_partition_delim_handler, &snprint_def_partition_delim);
 	install_keyword("config_dir", &def_config_dir_handler, &snprint_def_config_dir);
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b21279e..2ff88c4 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -498,6 +498,20 @@ used until it has passed
 checks. Default is
 .I no
 .TP
+.B strict_timinig
+If set to
+.I yes
+, multipathd will start a new path checker loop after exactly one second,
+so that each path check will occur at exactly
+.I polling_interval
+seconds. On busy systems path checks might take longer than one second;
+here the missing ticks will be accounted for on the next round.
+A warning will be printed if path checks take longer than
+.I polling_interval
+seconds.
+Default is
+.I no
+.TP
 .B uxsock_timeout
 CLI receive timeout in milliseconds. For larger systems CLI commands
 might timeout before the multipathd lock is released and the CLI command
diff --git a/multipathd/main.c b/multipathd/main.c
index 33a3503..d8fa88f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1260,7 +1260,7 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
  * Returns '1' if the path has been checked, '0' otherwise
  */
 int
-check_path (struct vectors * vecs, struct path * pp)
+check_path (struct vectors * vecs, struct path * pp, int ticks)
 {
 	int newstate;
 	int new_path_up = 0;
@@ -1273,7 +1273,9 @@ check_path (struct vectors * vecs, struct path * pp)
 	     pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp)
 		return 0;
 
-	if (pp->tick && --pp->tick)
+	if (pp->tick)
+		pp->tick -= (pp->tick > ticks) ? ticks : pp->tick;
+	if (pp->tick)
 		return 0; /* don't check this path yet */
 
 	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV &&
@@ -1515,6 +1517,8 @@ checkerloop (void *ap)
 	struct path *pp;
 	int count = 0;
 	unsigned int i;
+	struct itimerval timer_tick_it;
+	struct timeval last_time;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	vecs = (struct vectors *)ap;
@@ -1527,23 +1531,41 @@ checkerloop (void *ap)
 		pp->checkint = conf->checkint;
 	}
 
+	/* Tweak start time for initial path check */
+	if (gettimeofday(&last_time, NULL) != 0)
+		last_time.tv_sec = 0;
+	else
+		last_time.tv_sec -= 1;
+
 	while (1) {
 		struct timeval diff_time, start_time, end_time;
-		int num_paths = 0;
+		int num_paths = 0, ticks = 0, signo, strict_timing;
+		sigset_t mask;
 
 		if (gettimeofday(&start_time, NULL) != 0)
 			start_time.tv_sec = 0;
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(vecs->lock);
 		pthread_testcancel();
-		condlog(4, "tick");
+		strict_timing = conf->strict_timing;
+		if (start_time.tv_sec && last_time.tv_sec) {
+			timersub(&start_time, &last_time, &diff_time);
+			condlog(4, "tick (%lu.%06lu secs)",
+				diff_time.tv_sec, diff_time.tv_usec);
+			last_time.tv_sec = start_time.tv_sec;
+			last_time.tv_usec = start_time.tv_usec;
+			ticks = diff_time.tv_sec;
+		} else {
+			ticks = 1;
+			condlog(4, "tick (%d ticks)", ticks);
+		}
 #ifdef USE_SYSTEMD
 		if (use_watchdog)
 			sd_notify(0, "WATCHDOG=1");
 #endif
 		if (vecs->pathvec) {
 			vector_foreach_slot (vecs->pathvec, pp, i) {
-				num_paths += check_path(vecs, pp);
+				num_paths += check_path(vecs, pp, ticks);
 			}
 		}
 		if (vecs->mpvec) {
@@ -1560,15 +1582,49 @@ checkerloop (void *ap)
 		}
 
 		lock_cleanup_pop(vecs->lock);
+		diff_time.tv_usec = 0;
 		if (start_time.tv_sec &&
-		    gettimeofday(&end_time, NULL) == 0 &&
-		    num_paths) {
+		    gettimeofday(&end_time, NULL)) {
 			timersub(&end_time, &start_time, &diff_time);
-			condlog(3, "checked %d path%s in %lu.%06lu secs",
-				num_paths, num_paths > 1 ? "s" : "",
-				diff_time.tv_sec, diff_time.tv_usec);
+			if (num_paths) {
+				condlog(3, "checked %d path%s in %lu.%06lu secs",
+					num_paths, num_paths > 1 ? "s" : "",
+					diff_time.tv_sec, diff_time.tv_usec);
+				if (diff_time.tv_sec > conf->max_checkint)
+					condlog(1, "path checkers took longer "
+						"than %lu seconds, consider "
+						"increasing max_polling_interval",
+						diff_time.tv_sec);
+			}
+		}
+
+		if (!strict_timing)
+			sleep(1);
+		else {
+			timer_tick_it.it_interval.tv_sec = 0;
+			timer_tick_it.it_interval.tv_usec = 0;
+			if (diff_time.tv_usec) {
+				timer_tick_it.it_value.tv_sec = 0;
+				timer_tick_it.it_value.tv_usec =
+					(unsigned long)1000000 - diff_time.tv_usec;
+			} else {
+				timer_tick_it.it_value.tv_sec = 1;
+				timer_tick_it.it_value.tv_usec = 0;
+			}
+			setitimer(ITIMER_REAL, &timer_tick_it, NULL);
+
+			sigemptyset(&mask);
+			sigaddset(&mask, SIGALRM);
+			condlog(3, "waiting for %lu.%06lu secs",
+				timer_tick_it.it_value.tv_sec,
+				timer_tick_it.it_value.tv_usec);
+			if (sigwait(&mask, &signo) != 0) {
+				condlog(3, "sigwait failed with error %d",
+					errno);
+				conf->strict_timing = 0;
+				break;
+			}
 		}
-		sleep(1);
 	}
 	return NULL;
 }
@@ -1819,6 +1875,7 @@ signal_init(void)
 	sigaddset(&set, SIGHUP);
 	sigaddset(&set, SIGUSR1);
 	sigaddset(&set, SIGUSR2);
+	sigaddset(&set, SIGALRM);
 	pthread_sigmask(SIG_BLOCK, &set, NULL);
 
 	signal_set(SIGHUP, sighup);
-- 
2.6.6
