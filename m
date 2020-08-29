From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH V3 1/5] multipathd: adopt static char* arr in
	daemon_status
Date: Sat, 29 Aug 2020 11:03:04 +0800
Message-ID: <c31619f2-93e6-f317-809c-828026e6ee03@huawei.com>
References: <dc4f5730-157f-8a27-247c-628f38bb6cb5@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <dc4f5730-157f-8a27-247c-628f38bb6cb5@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
To: Martin Wilck <mwilck@suse.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, yanxiaodan@huawei.com, linfeilong@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


We adopt static char* array (demon_status_msg) in daemon_status func,
so it looks more simpler and easier to expand.

V2->V3:
- add default case in sd_notify_status to fix compile error
V1->V2:
- use "int" as the type of "status" (suggested by Martin)

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 multipathd/main.c | 32 +++++++++++++++++---------------
 multipathd/main.h |  3 ++-
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9ec65856..27c3a3ae 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -153,24 +153,24 @@ static volatile sig_atomic_t exit_sig;
 static volatile sig_atomic_t reconfig_sig;
 static volatile sig_atomic_t log_reset_sig;

+static const char *daemon_status_msg[DAEMON_STATUS_SIZE] = {
+	[DAEMON_INIT] = "init",
+	[DAEMON_START] = "startup",
+	[DAEMON_CONFIGURE] = "configure",
+	[DAEMON_IDLE] = "idle",
+	[DAEMON_RUNNING] = "running",
+	[DAEMON_SHUTDOWN] = "shutdown",
+};
+
 const char *
 daemon_status(void)
 {
-	switch (get_running_state()) {
-	case DAEMON_INIT:
-		return "init";
-	case DAEMON_START:
-		return "startup";
-	case DAEMON_CONFIGURE:
-		return "configure";
-	case DAEMON_IDLE:
-		return "idle";
-	case DAEMON_RUNNING:
-		return "running";
-	case DAEMON_SHUTDOWN:
-		return "shutdown";
-	}
-	return NULL;
+	int status = get_running_state();
+
+	if (status < DAEMON_INIT || status >= DAEMON_STATUS_SIZE)
+		return NULL;
+
+	return daemon_status_msg[status];
 }

 /*
@@ -192,6 +192,8 @@ sd_notify_status(enum daemon_status state)
 		return "STATUS=up";
 	case DAEMON_SHUTDOWN:
 		return "STATUS=shutdown";
+	default:
+		return NULL;
 	}
 	return NULL;
 }
diff --git a/multipathd/main.h b/multipathd/main.h
index 5dff17e5..6a5592c0 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -4,12 +4,13 @@
 #define MAPGCINT 5

 enum daemon_status {
-	DAEMON_INIT,
+	DAEMON_INIT = 0,
 	DAEMON_START,
 	DAEMON_CONFIGURE,
 	DAEMON_IDLE,
 	DAEMON_RUNNING,
 	DAEMON_SHUTDOWN,
+	DAEMON_STATUS_SIZE,
 };

 struct prout_param_descriptor;
-- 
2.24.0.windows.2
