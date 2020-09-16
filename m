From: mwilck@suse.com
Subject: [PATCH 02/19] multipathd: avoid sending "READY=1" to
	systemd on early shutdown
Date: Wed, 16 Sep 2020 17:37:01 +0200
Message-ID: <20200916153718.582-3-mwilck@suse.com>
References: <20200916153718.582-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

If multipathd gets a shutdown request during initial reconfigure(),
it shouldn't send "READY=1" to systemd. Ensure this by sending
"READY=1" via post_config_state().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d5e90b2..afc6c99 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -189,6 +189,8 @@ static void do_sd_notify(enum daemon_status old_state,
 {
 	char notify_msg[MSG_SIZE];
 	const char *msg;
+	static bool startup_done = false;
+
 	/*
 	 * Checkerloop switches back and forth between idle and running state.
 	 * No need to tell systemd each time.
@@ -205,6 +207,11 @@ static void do_sd_notify(enum daemon_status old_state,
 
 	if (msg && !safe_sprintf(notify_msg, "STATUS=%s", msg))
 		sd_notify(0, notify_msg);
+
+	if (new_state == DAEMON_IDLE && !startup_done) {
+		sd_notify(0, "READY=1");
+		startup_done = true;
+	}
 }
 #endif
 
@@ -2913,9 +2920,6 @@ child (__attribute__((unused)) void *param)
 	struct vectors * vecs;
 	struct multipath * mpp;
 	int i;
-#ifdef USE_SYSTEMD
-	int startup_done = 0;
-#endif
 	int rc;
 	int pid_fd = -1;
 	struct config *conf;
@@ -3075,12 +3079,6 @@ child (__attribute__((unused)) void *param)
 			}
 			lock_cleanup_pop(vecs->lock);
 			post_config_state(DAEMON_IDLE);
-#ifdef USE_SYSTEMD
-			if (!startup_done) {
-				sd_notify(0, "READY=1");
-				startup_done = 1;
-			}
-#endif
 		}
 	}
 
-- 
2.28.0
