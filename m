From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 24/72] multipath-tools: mark unused params in
 signal and cleanup handlers
Date: Sat, 12 Oct 2019 21:28:07 +0000
Message-ID: <20191012212703.12989-25-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

These parameters are all rightfully unused, yet need to be declared
because of the function prototypes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/file.c        |  2 +-
 libmultipath/foreign.c     |  2 +-
 libmultipath/io_err_stat.c |  4 ++--
 mpathpersist/main.c        |  2 +-
 multipath/main.c           |  2 +-
 multipathd/dmevents.c      |  4 ++--
 multipathd/main.c          | 14 +++++++-------
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/libmultipath/file.c b/libmultipath/file.c
index 8727f160..5cb06e1f 100644
--- a/libmultipath/file.c
+++ b/libmultipath/file.c
@@ -74,7 +74,7 @@ ensure_directories_exist(const char *str, mode_t dir_mode)
 }
 
 static void
-sigalrm(int sig)
+sigalrm(__attribute__((unused)) int sig)
 {
 	/* do nothing */
 }
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 9ef8ad19..f05db162 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -50,7 +50,7 @@ static void wrlock_foreigns(void)
 	pthread_rwlock_wrlock(&foreign_lock);
 }
 
-static void unlock_foreigns(void *unused)
+static void unlock_foreigns(__attribute__((unused)) void *unused)
 {
 	pthread_rwlock_unlock(&foreign_lock);
 }
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 554b7778..6b3a3e19 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -84,7 +84,7 @@ io_context_t	ioctx;
 
 static void cancel_inflight_io(struct io_err_stat_path *pp);
 
-static void rcu_unregister(void *param)
+static void rcu_unregister(__attribute__((unused)) void *param)
 {
 	rcu_unregister_thread();
 }
@@ -689,7 +689,7 @@ static void cleanup_unlock(void *arg)
 	pthread_mutex_unlock((pthread_mutex_t*) arg);
 }
 
-static void cleanup_exited(void *arg)
+static void cleanup_exited(__attribute__((unused)) void *arg)
 {
 	uatomic_set(&io_err_thread_running, 0);
 }
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 278b8d51..56761668 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -50,7 +50,7 @@ struct config *get_multipath_config(void)
 	return multipath_conf;
 }
 
-void put_multipath_config(void * arg)
+void put_multipath_config(__attribute__((unused)) void * arg)
 {
 	/* Noop for now */
 }
diff --git a/multipath/main.c b/multipath/main.c
index 4f4d8e89..b3f8c99b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -86,7 +86,7 @@ struct config *get_multipath_config(void)
 	return multipath_conf;
 }
 
-void put_multipath_config(void *arg)
+void put_multipath_config(__attribute__((unused)) void *arg)
 {
 	/* Noop for now */
 }
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 00348926..b22b47d2 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -370,12 +370,12 @@ static int dmevent_loop (void)
 	return -1; /* never reach there */
 }
 
-static void rcu_unregister(void *param)
+static void rcu_unregister(__attribute__((unused)) void *param)
 {
 	rcu_unregister_thread();
 }
 
-void *wait_dmevents (void *unused)
+void *wait_dmevents (__attribute__((unused)) void *unused)
 {
 	int r;
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 34a57689..ef128a32 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -215,7 +215,7 @@ static void do_sd_notify(enum daemon_status old_state,
 }
 #endif
 
-static void config_cleanup(void *arg)
+static void config_cleanup(__attribute__((unused)) void *arg)
 {
 	pthread_mutex_unlock(&config_lock);
 }
@@ -306,7 +306,7 @@ struct config *get_multipath_config(void)
 	return rcu_dereference(multipath_conf);
 }
 
-void put_multipath_config(void *arg)
+void put_multipath_config(__attribute__((unused)) void *arg)
 {
 	rcu_read_unlock();
 }
@@ -1503,7 +1503,7 @@ out:
 	return r;
 }
 
-static void rcu_unregister(void *param)
+static void rcu_unregister(__attribute__((unused)) void *param)
 {
 	rcu_unregister_thread();
 }
@@ -2685,25 +2685,25 @@ handle_signals(bool nonfatal)
 }
 
 static void
-sighup (int sig)
+sighup(__attribute__((unused)) int sig)
 {
 	reconfig_sig = 1;
 }
 
 static void
-sigend (int sig)
+sigend(__attribute__((unused)) int sig)
 {
 	exit_sig = 1;
 }
 
 static void
-sigusr1 (int sig)
+sigusr1(__attribute__((unused)) int sig)
 {
 	log_reset_sig = 1;
 }
 
 static void
-sigusr2 (int sig)
+sigusr2(__attribute__((unused)) int sig)
 {
 	condlog(3, "SIGUSR2 received");
 }
-- 
2.23.0
