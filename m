From: mwilck@suse.com
Subject: [PATCH 10/23] multipathd: add helper for systemd
	notification at exit
Date: Thu, 24 Sep 2020 15:40:41 +0200
Message-ID: <20200924134054.14632-11-mwilck@suse.com>
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

Add sd_notify_exit().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 44c1bd1..e742aa5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3023,6 +3023,17 @@ static void cleanup_rcu(int dummy __attribute__((unused)), void *arg)
 	rcu_unregister_thread();
 }
 
+static int sd_notify_exit(int err)
+{
+#ifdef USE_SYSTEMD
+	char msg[24];
+
+	snprintf(msg, sizeof(msg), "ERRNO=%d", err);
+	sd_notify(0, msg);
+#endif
+	return err;
+}
+
 static int
 child (__attribute__((unused)) void *param)
 {
@@ -3218,19 +3229,12 @@ child (__attribute__((unused)) void *param)
 #ifdef _DEBUG_
 	dbg_free_final(NULL);
 #endif
-
-#ifdef USE_SYSTEMD
-	sd_notify(0, "ERRNO=0");
-#endif
-	exit(0);
+	exit(sd_notify_exit(0));
 
 failed:
-#ifdef USE_SYSTEMD
-	sd_notify(0, "ERRNO=1");
-#endif
 	if (pid_fd >= 0)
 		close(pid_fd);
-	exit(1);
+	exit(sd_notify_exit(1));
 }
 
 static int
-- 
2.28.0
