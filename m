From: mwilck@suse.com
Subject: [PATCH v2 03/21] multipathd: send "STOPPING=1" to
	systemd on shutdown
Date: Thu, 24 Sep 2020 15:36:58 +0200
Message-ID: <20200924133716.14120-4-mwilck@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-1-mwilck@suse.com>
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

Inform systemd that the daemon is shutting down. See sd_notify(3).

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 53a22a4..c264351 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -208,7 +208,9 @@ static void do_sd_notify(enum daemon_status old_state,
 	if (msg && !safe_sprintf(notify_msg, "STATUS=%s", msg))
 		sd_notify(0, notify_msg);
 
-	if (new_state == DAEMON_IDLE && !startup_done) {
+	if (new_state == DAEMON_SHUTDOWN)
+		sd_notify(0, "STOPPING=1");
+	else if (new_state == DAEMON_IDLE && !startup_done) {
 		sd_notify(0, "READY=1");
 		startup_done = true;
 	}
-- 
2.28.0
