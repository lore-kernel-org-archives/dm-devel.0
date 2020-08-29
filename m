From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH V3 2/5] multipathd: use daemon_status_msg to
 construct sd notify msg in do_sd_notify func
Date: Sat, 29 Aug 2020 11:03:48 +0800
Message-ID: <8e24c49b-6f56-e7ea-7f2a-e7bd9d266e23@huawei.com>
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


sd_notify_status() is very similar with daemon_status(), except
DAEMON_IDLE and DAEMON_RUNNING state. As suggested by Martin,
we can create the sd notification string in a dynamic buffer,
and treat DAEMON_IDLE and DAEMON_RUNNING cases first. Then,
we can use daemon_status_msg[state] for other cases.

V2->V3:
- set MSG_SIZE to 32 and use safe_sprintf as suggested by Martin.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 multipathd/main.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 27c3a3ae..7fe55b12 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -85,6 +85,7 @@

 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
+#define MSG_SIZE 32

 #define LOG_MSG(lvl, verb, pp)					\
 do {								\
@@ -177,30 +178,12 @@ daemon_status(void)
  * I love you too, systemd ...
  */
 #ifdef USE_SYSTEMD
-static const char *
-sd_notify_status(enum daemon_status state)
-{
-	switch (state) {
-	case DAEMON_INIT:
-		return "STATUS=init";
-	case DAEMON_START:
-		return "STATUS=startup";
-	case DAEMON_CONFIGURE:
-		return "STATUS=configure";
-	case DAEMON_IDLE:
-	case DAEMON_RUNNING:
-		return "STATUS=up";
-	case DAEMON_SHUTDOWN:
-		return "STATUS=shutdown";
-	default:
-		return NULL;
-	}
-	return NULL;
-}
-
 static void do_sd_notify(enum daemon_status old_state,
 			 enum daemon_status new_state)
 {
+	char notify_msg[MSG_SIZE];
+	const char prefix[] = "STATUS=";
+	const char *msg = NULL;
 	/*
 	 * Checkerloop switches back and forth between idle and running state.
 	 * No need to tell systemd each time.
@@ -209,7 +192,14 @@ static void do_sd_notify(enum daemon_status old_state,
 	if ((new_state == DAEMON_IDLE || new_state == DAEMON_RUNNING) &&
 	    (old_state == DAEMON_IDLE || old_state == DAEMON_RUNNING))
 		return;
-	sd_notify(0, sd_notify_status(new_state));
+
+	if (new_state == DAEMON_IDLE || new_state == DAEMON_RUNNING)
+		msg = "up";
+	else
+		msg = daemon_status_msg[new_state];
+
+	if (!safe_sprintf(notify_msg, "%s%s", prefix, msg))
+		sd_notify(0, notify_msg);
 }
 #endif

-- 
2.24.0.windows.2
