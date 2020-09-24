From: mwilck@suse.com
Subject: [PATCH 03/23] multipathd: move handling of
	io_err_stat_attr into libmultipath
Date: Thu, 24 Sep 2020 15:40:34 +0200
Message-ID: <20200924134054.14632-4-mwilck@suse.com>
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

This thread attribute can be dynamically initialized and destroyed.
No need to carry it along in multipathd. Removal of the symbol
requires a new ABI version.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/io_err_stat.c        |  7 +++++--
 libmultipath/libmultipath.version | 23 ++++++++---------------
 multipathd/main.c                 |  2 --
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 58bc1dd..5363049 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -34,6 +34,7 @@
 #include "lock.h"
 #include "time-util.h"
 #include "io_err_stat.h"
+#include "util.h"
 
 #define TIMEOUT_NO_IO_NSEC		10000000 /*10ms = 10000000ns*/
 #define FLAKY_PATHFAIL_THRESHOLD	2
@@ -70,8 +71,7 @@ struct io_err_stat_path {
 	int		err_rate_threshold;
 };
 
-pthread_t		io_err_stat_thr;
-pthread_attr_t		io_err_stat_attr;
+static pthread_t	io_err_stat_thr;
 
 static pthread_mutex_t io_err_thread_lock = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t io_err_thread_cond = PTHREAD_COND_INITIALIZER;
@@ -727,6 +727,7 @@ static void *io_err_stat_loop(void *data)
 int start_io_err_stat_thread(void *data)
 {
 	int ret;
+	pthread_attr_t io_err_stat_attr;
 
 	if (uatomic_read(&io_err_thread_running) == 1)
 		return 0;
@@ -739,6 +740,7 @@ int start_io_err_stat_thread(void *data)
 	if (!paths)
 		goto destroy_ctx;
 
+	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 0);
 	pthread_mutex_lock(&io_err_thread_lock);
 	pthread_cleanup_push(cleanup_unlock, &io_err_thread_lock);
 
@@ -750,6 +752,7 @@ int start_io_err_stat_thread(void *data)
 				 &io_err_thread_lock) == 0);
 
 	pthread_cleanup_pop(1);
+	pthread_attr_destroy(&io_err_stat_attr);
 
 	if (ret) {
 		io_err_stat_log(0, "cannot create io_error statistic thread");
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 2e531ef..9abdb22 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -1,4 +1,4 @@
-LIBMULTIPATH_0.8.4.1 {
+LIBMULTIPATH_0.8.4.5 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -88,7 +88,6 @@ global:
 	init_checkers;
 	init_foreign;
 	init_prio;
-	io_err_stat_attr;
 	io_err_stat_handle_pathfail;
 	is_path_valid;
 	is_quote;
@@ -209,30 +208,24 @@ global:
 	free_scandir_result;
 	sysfs_attr_get_value;
 
-local:
-	*;
-};
-
-LIBMULTIPATH_0.8.4.2 {
-global:
+	/* added in 0.8.4.2 */
 	libmp_dm_task_run;
 	cleanup_mutex;
-} LIBMULTIPATH_0.8.4.1;
 
-LIBMULTIPATH_0.8.4.3 {
-global:
+	/* added in 0.8.4.3 */
 	libmp_get_multipath_config;
 	get_multipath_config;
 	libmp_put_multipath_config;
 	put_multipath_config;
 	init_config;
 	uninit_config;
-} LIBMULTIPATH_0.8.4.2;
 
-LIBMULTIPATH_0.8.4.4 {
-global:
+	/* added in 0.8.4.4 */
 	udev;
 	logsink;
 	libmultipath_init;
 	libmultipath_exit;
-} LIBMULTIPATH_0.8.4.3;
+
+local:
+	*;
+};
diff --git a/multipathd/main.c b/multipathd/main.c
index be1b5ae..4d714e8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2954,7 +2954,6 @@ child (__attribute__((unused)) void *param)
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
 	setup_thread_attr(&waiter_attr, 32 * 1024, 1);
-	setup_thread_attr(&io_err_stat_attr, 32 * 1024, 0);
 
 	if (logsink == 1) {
 		setup_thread_attr(&log_attr, 64 * 1024, 0);
@@ -3164,7 +3163,6 @@ child (__attribute__((unused)) void *param)
 	rcu_assign_pointer(multipath_conf, NULL);
 	call_rcu(&conf->rcu, rcu_free_config);
 	pthread_attr_destroy(&waiter_attr);
-	pthread_attr_destroy(&io_err_stat_attr);
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
2.28.0
