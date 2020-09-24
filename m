From: mwilck@suse.com
Subject: [PATCH 02/23] multipathd: Fix liburcu memory leak
Date: Thu, 24 Sep 2020 15:40:33 +0200
Message-ID: <20200924134054.14632-3-mwilck@suse.com>
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

Fix this leak in multipathd, reported by valgrind, that messes up
multipathd's otherwise clean leak report:

==23823== 336 bytes in 1 blocks are possibly lost in loss record 3 of 3
==23823==    at 0x483AB65: calloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==23823==    by 0x4012F16: _dl_allocate_tls (in /lib64/ld-2.31.so)
==23823==    by 0x493BB8E: pthread_create@@GLIBC_2.2.5 (in /lib64/libpthread-2.31.so)
==23823==    by 0x492A9A9: call_rcu_data_init (urcu-call-rcu-impl.h:437)
==23823==    by 0x492AD2F: UnknownInlinedFun (urcu-call-rcu-impl.h:492)
==23823==    by 0x492AD2F: create_call_rcu_data_memb (urcu-call-rcu-impl.h:504)
==23823==    by 0x1164E3: child.constprop.0.isra.0 (main.c:2915)
==23823==    by 0x10F50C: main (main.c:3335)
==23823==
==23823== LEAK SUMMARY:
==23823==    definitely lost: 0 bytes in 0 blocks
==23823==    indirectly lost: 0 bytes in 0 blocks
==23823==      possibly lost: 336 bytes in 1 blocks

The problem is caused by using liburcu's default RCU call handler,
which liburcu refuses to stop/join. See comments in the code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c5c374b..be1b5ae 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2889,6 +2889,47 @@ set_oom_adj (void)
 	condlog(0, "couldn't adjust oom score");
 }
 
+/*
+ * Use a non-default call_rcu_data for child().
+ *
+ * We do this to avoid a memory leak from liburcu.
+ * liburcu never frees the default rcu handler (see comments on
+ * call_rcu_data_free() in urcu-call-rcu-impl.h), its thread
+ * can't be joined with pthread_join(), leaving a memory leak.
+ *
+ * Therefore we create our own, which can be destroyed and joined.
+ */
+static struct call_rcu_data *setup_rcu(void)
+{
+	struct call_rcu_data *crdp;
+
+	rcu_init();
+	rcu_register_thread();
+	crdp = create_call_rcu_data(0UL, -1);
+	if (crdp != NULL)
+		set_thread_call_rcu_data(crdp);
+	return crdp;
+}
+
+static void cleanup_rcu(int dummy __attribute__((unused)), void *arg)
+{
+	struct call_rcu_data *crdp = arg;
+	pthread_t rcu_thread;
+
+	/* Wait for any pending RCU calls */
+	rcu_barrier();
+	if (crdp != NULL) {
+		rcu_thread = get_call_rcu_thread(crdp);
+		/* detach this thread from the RCU thread */
+		set_thread_call_rcu_data(NULL);
+		synchronize_rcu();
+		/* tell RCU thread to exit */
+		call_rcu_data_free(crdp);
+		pthread_join(rcu_thread, NULL);
+	}
+	rcu_unregister_thread();
+}
+
 static int
 child (__attribute__((unused)) void *param)
 {
@@ -2903,10 +2944,12 @@ child (__attribute__((unused)) void *param)
 	char *envp;
 	int queue_without_daemon;
 	enum daemon_status state;
+	struct call_rcu_data *crdp;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
-	rcu_init();
+	crdp = setup_rcu();
+	on_exit(cleanup_rcu, crdp);
 
 	setup_thread_attr(&misc_attr, 64 * 1024, 0);
 	setup_thread_attr(&uevent_attr, DEFAULT_UEVENT_STACKSIZE * 1024, 0);
-- 
2.28.0
