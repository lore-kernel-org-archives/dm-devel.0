From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH 2/6] multipathd: adopt static char* arr in
	daemon_status
Date: Sun, 16 Aug 2020 09:42:44 +0800
Message-ID: <b6e1e24f-5695-f29f-ce88-bff2d5e3fac1@huawei.com>
References: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
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
To: bmarzins@redhat.com, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids


We adopt static char* array (demon_status_msg) in daemon_status func,
so it looks more simpler and easier to expand.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 multipathd/main.c | 30 +++++++++++++++---------------
 multipathd/main.h |  3 ++-
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9ec6585..cab1d0d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -153,24 +153,24 @@ static volatile sig_atomic_t exit_sig;
 static volatile sig_atomic_t reconfig_sig;
 static volatile sig_atomic_t log_reset_sig;

+static const char *demon_status_msg[DAEMON_STATUS_SIZE] = {
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
+	enum daemon_status status = get_running_state();
+
+	if (status < DAEMON_INIT || status >= DAEMON_STATUS_SIZE)
+		return NULL;
+
+	return demon_status_msg[status];
 }

 /*
diff --git a/multipathd/main.h b/multipathd/main.h
index 5dff17e..6a5592c 100644
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
1.8.3.1
