From: mwilck@suse.com
Subject: [PATCH 17/23] multipathd: add cleanup_child() exit
	handler
Date: Thu, 24 Sep 2020 15:40:48 +0200
Message-ID: <20200924134054.14632-18-mwilck@suse.com>
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

cleanup_child() calls all cleanups in the right order, in an
exit handler.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 48 +++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f9749e5..e7b479a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3023,6 +3023,28 @@ static void cleanup_rcu(int dummy __attribute__((unused)), void *arg)
 	rcu_unregister_thread();
 }
 
+static void cleanup_child(void)
+{
+	cleanup_threads();
+	cleanup_vecs();
+	cleanup_foreign();
+	cleanup_checkers();
+	cleanup_prio();
+	if (poll_dmevents)
+		cleanup_dmevent_waiter();
+
+	cleanup_pidfile();
+	if (logsink == 1) {
+		logsink = 0;
+		log_thread_stop();
+	}
+	cleanup_conf();
+
+#ifdef _DEBUG_
+	dbg_free_final(NULL);
+#endif
+}
+
 static int sd_notify_exit(int err)
 {
 #ifdef USE_SYSTEMD
@@ -3049,7 +3071,11 @@ child (__attribute__((unused)) void *param)
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
 	crdp = setup_rcu();
-	on_exit(cleanup_rcu, crdp);
+
+	if (on_exit(cleanup_rcu, crdp) ||
+	    atexit(cleanup_child)) {
+		fprintf(stderr, "failed to register cleanup handlers\n");
+	}
 
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
@@ -3212,26 +3238,8 @@ child (__attribute__((unused)) void *param)
 
 	exit_code = 0;
 failed:
-	cleanup_threads();
-	cleanup_vecs();
-	cleanup_foreign();
-	cleanup_checkers();
-	cleanup_prio();
-	if (poll_dmevents)
-		cleanup_dmevent_waiter();
-
-	/* We're done here */
-	cleanup_pidfile();
 	condlog(2, "--------shut down-------");
-
-	if (logsink == 1) {
-		logsink = 0;
-		log_thread_stop();
-	}
-	cleanup_conf();
-#ifdef _DEBUG_
-	dbg_free_final(NULL);
-#endif
+	/* All cleanup is done in the cleanup_child() exit handler */
 	return sd_notify_exit(exit_code);
 }
 
-- 
2.28.0
