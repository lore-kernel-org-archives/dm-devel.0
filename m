From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH V4 2/5] multipathd: use daemon_status_msg to
 construct sd notify msg in do_sd_notify func
Date: Mon, 31 Aug 2020 19:37:11 +0800
Message-ID: <76528c71-f8b9-1595-edc1-e9061858a76f@huawei.com>
References: <50b2333d-8c5d-8705-a31a-11bb84980373@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50b2333d-8c5d-8705-a31a-11bb84980373@huawei.com>
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, yanxiaodan@huawei.com, linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com, zkabelac@redhat.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


sd_notify_status() is very similar with daemon_status(), except
DAEMON_IDLE and DAEMON_RUNNING state. As suggested by Martin,
we can create the sd notification string in a dynamic buffer,
and treat DAEMON_IDLE and DAEMON_RUNNING cases first. Then,
we can use daemon_status_msg[state] for other cases.

V3->V4:
- put "STATUS=" in format string to avoid "prefix" var as suggested by
Martin.

V2->V3:
- set MSG_SIZE to 32 and use safe_sprintf as suggested by Martin.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 multipathd/main.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 27c3a3ae..2ccf014a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -85,6 +85,7 @@

 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
+#define MSG_SIZE 32

 #define LOG_MSG(lvl, verb, pp)					\
 do {								\
@@ -177,30 +178,11 @@ daemon_status(void)
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
+	const char *msg;
 	/*
 	 * Checkerloop switches back and forth between idle and running state.
 	 * No need to tell systemd each time.
@@ -209,7 +191,14 @@ static void do_sd_notify(enum daemon_status old_state,
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
+	if (msg && !safe_sprintf(notify_msg, "STATUS=%s", msg))
+		sd_notify(0, notify_msg);
 }
 #endif

-- 
2.24.0.windows.2
