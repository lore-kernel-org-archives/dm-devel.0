From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 06/12] multipathd: use nanosleep for strict timing
Date: Wed, 14 Mar 2018 12:46:39 -0500
Message-ID: <1521049605-22050-7-git-send-email-bmarzins@redhat.com>
References: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521049605-22050-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

In order to safely use SIGALRM in a multi-threaded program, only one
thread can schedule and wait on SIGALRM at a time. All other threads
must have SIGALRM blocked, and be unable to schedule an alarm. The
strict_timing code in checkerloop was unblocking SIGALRM, and calling
setitimer(), without any locking.  Instead, it should use nanosleep()
to sleep for the correct length of time, since that doesn't depend or
interfere with signals.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6ba6131..ce914ab 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1855,7 +1855,6 @@ checkerloop (void *ap)
 	struct path *pp;
 	int count = 0;
 	unsigned int i;
-	struct itimerval timer_tick_it;
 	struct timespec last_time;
 	struct config *conf;
 
@@ -1873,8 +1872,7 @@ checkerloop (void *ap)
 
 	while (1) {
 		struct timespec diff_time, start_time, end_time;
-		int num_paths = 0, ticks = 0, signo, strict_timing, rc = 0;
-		sigset_t mask;
+		int num_paths = 0, ticks = 0, strict_timing, rc = 0;
 
 		if (clock_gettime(CLOCK_MONOTONIC, &start_time) != 0)
 			start_time.tv_sec = 0;
@@ -1962,25 +1960,18 @@ checkerloop (void *ap)
 		if (!strict_timing)
 			sleep(1);
 		else {
-			timer_tick_it.it_interval.tv_sec = 0;
-			timer_tick_it.it_interval.tv_usec = 0;
 			if (diff_time.tv_nsec) {
-				timer_tick_it.it_value.tv_sec = 0;
-				timer_tick_it.it_value.tv_usec =
+				diff_time.tv_sec = 0;
+				diff_time.tv_nsec =
 				     1000UL * 1000 * 1000 - diff_time.tv_nsec;
-			} else {
-				timer_tick_it.it_value.tv_sec = 1;
-				timer_tick_it.it_value.tv_usec = 0;
-			}
-			setitimer(ITIMER_REAL, &timer_tick_it, NULL);
+			} else
+				diff_time.tv_sec = 1;
 
-			sigemptyset(&mask);
-			sigaddset(&mask, SIGALRM);
 			condlog(3, "waiting for %lu.%06lu secs",
-				timer_tick_it.it_value.tv_sec,
-				timer_tick_it.it_value.tv_usec);
-			if (sigwait(&mask, &signo) != 0) {
-				condlog(3, "sigwait failed with error %d",
+				diff_time.tv_sec,
+				diff_time.tv_nsec / 1000);
+			if (nanosleep(&diff_time, NULL) != 0) {
+				condlog(3, "nanosleep failed with error %d",
 					errno);
 				conf = get_multipath_config();
 				conf->strict_timing = 0;
-- 
2.7.4
