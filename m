From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH V2 2/5] multipathd: use daemon_status_msg to
 construct sd notify msg in do_sd_notify func
Date: Fri, 21 Aug 2020 18:59:20 +0800
Message-ID: <8e3e5a81-dcd5-b3d5-41c7-2f443b854367@huawei.com>
References: <52b3b834-6da6-99c1-a2d1-95c2387c47e3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52b3b834-6da6-99c1-a2d1-95c2387c47e3@huawei.com>
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
To: mwilck@suse.com, Benjamin Marzinski <bmarzins@redhat.com>, Christophe
	Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


sd_notify_status() is very similar with daemon_status(), except
DAEMON_IDLE and DAEMON_RUNNING state. As suggested by Martin,
we can create the sd notification string in a dynamic buffer,
and treat DAEMON_IDLE and DAEMON_RUNNING cases first. Then,
we can use daemon_status_msg[state] for other cases.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 multipathd/main.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 62cf4ff4..4ba015bb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -85,6 +85,7 @@

 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
+#define MSG_SIZE 64

 #define LOG_MSG(lvl, verb, pp)					\
 do {								\
@@ -177,28 +178,12 @@ daemon_status(void)
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
@@ -207,7 +192,18 @@ static void do_sd_notify(enum daemon_status old_state,
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
+	if (snprintf(notify_msg, MSG_SIZE, "%s%s", prefix, msg) >= MSG_SIZE) {
+		condlog(2, "len of msg is should be shorter than %d", MSG_SIZE);
+		return;
+	}
+
+	sd_notify(0, notify_msg);
 }
 #endif

-- 
2.24.0.windows.2
