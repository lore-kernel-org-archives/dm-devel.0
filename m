From: mwilck@suse.com
Subject: [PATCH 04/19] multipathd: send "RELOADING=1" to systemd
	on DAEMON_CONFIGURE state
Date: Wed, 16 Sep 2020 17:37:03 +0200
Message-ID: <20200916153718.582-5-mwilck@suse.com>
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

The logic is as follows: child() sets DAEMON_IDLE status after
DAEMON_CONFIGURE when reconfigure() has finished. The only other state change
that can race with that is DAEMON_SHUTDOWN. Other state changes will wait for
DAEMON_IDLE first (see set_config_state()). When DAEMON_CONFIGURE is entered,
and we are not just starting up, send a "RELOADING=1" message to
systemd. After that, we must send "READY=1" when we're done reloading. Also
do that on startup, when DAEMON_IDLE is set for the first time.
See sd_notify(3).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2923c08..8cc9b74 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -210,10 +210,11 @@ static void do_sd_notify(enum daemon_status old_state,
 
 	if (new_state == DAEMON_SHUTDOWN)
 		sd_notify(0, "STOPPING=1");
-	else if (new_state == DAEMON_IDLE && !startup_done) {
+	else if (new_state == DAEMON_IDLE && old_state == DAEMON_CONFIGURE) {
 		sd_notify(0, "READY=1");
 		startup_done = true;
-	}
+	} else if (new_state == DAEMON_CONFIGURE && startup_done)
+		sd_notify(0, "RELOADING=1");
 }
 #endif
 
-- 
2.28.0
