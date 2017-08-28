From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] multipathd: don't flood system with
	sd_notify calls
Date: Tue, 29 Aug 2017 00:05:33 +0200
Message-ID: <20170828220536.13208-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

DAEMON_RUNNING is only used by checkerloop to indicate that
path checkers are running. checkerloop switches back and forth
between DAEMON_IDLE and DAEMON_RUNNING in every iteration, i.e.
it performs two status changes per second on an idle system.
The repeated sd_notify() calls cause a lot of traffic on dbus as
systemd forwards these messages on the system bus. This can be
seen with systemd.log_level=debug. Better skip these notifications
that don't provide useful information to the user, who is very
unlikely to catch the daemon in "running" state anyway.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4be2c579..b5e2b00d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -161,15 +161,27 @@ sd_notify_status(void)
 	case DAEMON_CONFIGURE:
 		return "STATUS=configure";
 	case DAEMON_IDLE:
-		return "STATUS=idle";
 	case DAEMON_RUNNING:
-		return "STATUS=running";
+		return "STATUS=up";
 	case DAEMON_SHUTDOWN:
 		return "STATUS=shutdown";
 	}
 	return NULL;
 }
 
+static void do_sd_notify(enum daemon_status old_state)
+{
+	/*
+	 * Checkerloop switches back and forth between idle and running state.
+	 * No need to tell systemd each time.
+	 * These notifications cause a lot of overhead on dbus.
+	 */
+	if ((running_state == DAEMON_IDLE || running_state == DAEMON_RUNNING) &&
+	    (old_state == DAEMON_IDLE || old_state == DAEMON_RUNNING))
+		return;
+	sd_notify(0, sd_notify_status());
+}
+
 static void config_cleanup(void *arg)
 {
 	pthread_mutex_unlock(&config_lock);
@@ -179,10 +191,12 @@ void post_config_state(enum daemon_status state)
 {
 	pthread_mutex_lock(&config_lock);
 	if (state != running_state) {
+		enum daemon_status old_state = running_state;
+
 		running_state = state;
 		pthread_cond_broadcast(&config_cond);
 #ifdef USE_SYSTEMD
-		sd_notify(0, sd_notify_status());
+		do_sd_notify(old_state);
 #endif
 	}
 	pthread_mutex_unlock(&config_lock);
@@ -195,6 +209,8 @@ int set_config_state(enum daemon_status state)
 	pthread_cleanup_push(config_cleanup, NULL);
 	pthread_mutex_lock(&config_lock);
 	if (running_state != state) {
+		enum daemon_status old_state = running_state;
+
 		if (running_state != DAEMON_IDLE) {
 			struct timespec ts;
 
@@ -207,7 +223,7 @@ int set_config_state(enum daemon_status state)
 			running_state = state;
 			pthread_cond_broadcast(&config_cond);
 #ifdef USE_SYSTEMD
-			sd_notify(0, sd_notify_status());
+			do_sd_notify(old_state);
 #endif
 		}
 	}
-- 
2.14.0
