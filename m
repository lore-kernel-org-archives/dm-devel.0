From: mwilck@suse.com
Subject: [PATCH 07/23] multipathd: move conf destruction into
	separate function
Date: Thu, 24 Sep 2020 15:40:38 +0200
Message-ID: <20200924134054.14632-8-mwilck@suse.com>
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

Also removing the comment about dlog() and dm_write_log().
dlog() can cope with get_multipath_config() returning NULL,
and dm_write_log() hasn't accessed the configuration for a while.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 8b9df55..4d5b40b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2892,6 +2892,16 @@ set_oom_adj (void)
 	condlog(0, "couldn't adjust oom score");
 }
 
+static void cleanup_conf(void) {
+	struct config *conf;
+
+	conf = rcu_dereference(multipath_conf);
+	if (!conf)
+		return;
+	rcu_assign_pointer(multipath_conf, NULL);
+	call_rcu(&conf->rcu, rcu_free_config);
+}
+
 static void cleanup_maps(struct vectors *vecs)
 {
 	int queue_without_daemon, i;
@@ -3194,17 +3204,11 @@ child (__attribute__((unused)) void *param)
 
 	condlog(2, "--------shut down-------");
 
-	if (logsink == 1)
+	if (logsink == 1) {
+		logsink = 0;
 		log_thread_stop();
-
-	/*
-	 * Freeing config must be done after condlog() and dm_lib_exit(),
-	 * because logging functions like dlog() and dm_write_log()
-	 * reference the config.
-	 */
-	conf = rcu_dereference(multipath_conf);
-	rcu_assign_pointer(multipath_conf, NULL);
-	call_rcu(&conf->rcu, rcu_free_config);
+	}
+	cleanup_conf();
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-- 
2.28.0
