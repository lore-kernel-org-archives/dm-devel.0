From: mwilck@suse.com
Subject: [PATCH 06/23] multipathd: move threads destruction into
	separate function
Date: Thu, 24 Sep 2020 15:40:37 +0200
Message-ID: <20200924134054.14632-7-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Also, introduce booleans that indicate a certain thread has
been started successfully. Using these booleans, we can avoid
crashing by cancelling threads that have never been started.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 76 +++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 25 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1cdbff1..8b9df55 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -129,6 +129,9 @@ static volatile enum daemon_status running_state = DAEMON_INIT;
 pid_t daemon_pid;
 static pthread_mutex_t config_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t config_cond;
+static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_thr;
+static bool check_thr_started, uevent_thr_started, uxlsnr_thr_started,
+	uevq_thr_started, dmevent_thr_started;
 
 static inline enum daemon_status get_running_state(void)
 {
@@ -2927,6 +2930,39 @@ static void cleanup_vecs(void)
 	FREE(gvecs);
 }
 
+static void cleanup_threads(void)
+{
+	stop_io_err_stat_thread();
+
+	if (check_thr_started)
+		pthread_cancel(check_thr);
+	if (uevent_thr_started)
+		pthread_cancel(uevent_thr);
+	if (uxlsnr_thr_started)
+		pthread_cancel(uxlsnr_thr);
+	if (uevq_thr_started)
+		pthread_cancel(uevq_thr);
+	if (dmevent_thr_started)
+		pthread_cancel(dmevent_thr);
+
+	if (check_thr_started)
+		pthread_join(check_thr, NULL);
+	if (uevent_thr_started)
+		pthread_join(uevent_thr, NULL);
+	if (uxlsnr_thr_started)
+		pthread_join(uxlsnr_thr, NULL);
+	if (uevq_thr_started)
+		pthread_join(uevq_thr, NULL);
+	if (dmevent_thr_started)
+		pthread_join(dmevent_thr, NULL);
+
+	/*
+	 * As all threads are joined now, and we're in DAEMON_SHUTDOWN
+	 * state, no new waiter threads will be created any more.
+	 */
+	pthread_attr_destroy(&waiter_attr);
+}
+
 /*
  * Use a non-default call_rcu_data for child().
  *
@@ -2971,7 +3007,6 @@ static void cleanup_rcu(int dummy __attribute__((unused)), void *arg)
 static int
 child (__attribute__((unused)) void *param)
 {
-	pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_thr;
 	pthread_attr_t log_attr, misc_attr, uevent_attr;
 	struct vectors * vecs;
 	int rc;
@@ -3070,9 +3105,12 @@ child (__attribute__((unused)) void *param)
 		condlog(0, "failed to create cli listener: %d", rc);
 		goto failed;
 	}
-	else if (state != DAEMON_CONFIGURE) {
-		condlog(0, "cli listener failed to start");
-		goto failed;
+	else {
+		uxlsnr_thr_started = true;
+		if (state != DAEMON_CONFIGURE) {
+			condlog(0, "cli listener failed to start");
+			goto failed;
+		}
 	}
 
 	if (poll_dmevents) {
@@ -3085,7 +3123,8 @@ child (__attribute__((unused)) void *param)
 			condlog(0, "failed to create dmevent waiter thread: %d",
 				rc);
 			goto failed;
-		}
+		} else
+			dmevent_thr_started = true;
 	}
 
 	/*
@@ -3094,7 +3133,8 @@ child (__attribute__((unused)) void *param)
 	if ((rc = pthread_create(&uevent_thr, &uevent_attr, ueventloop, udev))) {
 		condlog(0, "failed to create uevent thread: %d", rc);
 		goto failed;
-	}
+	} else
+		uevent_thr_started = true;
 	pthread_attr_destroy(&uevent_attr);
 
 	/*
@@ -3103,11 +3143,13 @@ child (__attribute__((unused)) void *param)
 	if ((rc = pthread_create(&check_thr, &misc_attr, checkerloop, vecs))) {
 		condlog(0,"failed to create checker loop thread: %d", rc);
 		goto failed;
-	}
+	} else
+		check_thr_started = true;
 	if ((rc = pthread_create(&uevq_thr, &misc_attr, uevqloop, vecs))) {
 		condlog(0, "failed to create uevent dispatcher: %d", rc);
 		goto failed;
-	}
+	} else
+		uevq_thr_started = true;
 	pthread_attr_destroy(&misc_attr);
 
 	while (1) {
@@ -3136,22 +3178,7 @@ child (__attribute__((unused)) void *param)
 		}
 	}
 
-	pthread_cancel(check_thr);
-	pthread_cancel(uevent_thr);
-	pthread_cancel(uxlsnr_thr);
-	pthread_cancel(uevq_thr);
-	if (poll_dmevents)
-		pthread_cancel(dmevent_thr);
-
-	pthread_join(check_thr, NULL);
-	pthread_join(uevent_thr, NULL);
-	pthread_join(uxlsnr_thr, NULL);
-	pthread_join(uevq_thr, NULL);
-	if (poll_dmevents)
-		pthread_join(dmevent_thr, NULL);
-
-	stop_io_err_stat_thread();
-
+	cleanup_threads();
 	cleanup_vecs();
 	cleanup_foreign();
 	cleanup_checkers();
@@ -3178,7 +3205,6 @@ child (__attribute__((unused)) void *param)
 	conf = rcu_dereference(multipath_conf);
 	rcu_assign_pointer(multipath_conf, NULL);
 	call_rcu(&conf->rcu, rcu_free_config);
-	pthread_attr_destroy(&waiter_attr);
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
2.28.0
