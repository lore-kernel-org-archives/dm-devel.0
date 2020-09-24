From: mwilck@suse.com
Subject: [PATCH v2 06/21] multipathd: generalize and fix
	wait_for_state_change_if()
Date: Thu, 24 Sep 2020 15:37:01 +0200
Message-ID: <20200924133716.14120-7-mwilck@suse.com>
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

It's unlikely but not impossible that other threads change the state
while we're waiting, and if we grab the lock again, it's still not
what we wanted. We need to continue waiting until either the condition
is met, or time timeout expired.

Moreover, generalize this code so that it can also be used in
set_config_state().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d081b3e..1fb0ee6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -223,6 +223,23 @@ static void config_cleanup(__attribute__((unused)) void *arg)
 	pthread_mutex_unlock(&config_lock);
 }
 
+#define __wait_for_state_change(condition, ms)				\
+	({								\
+		struct timespec tmo;					\
+		int rc = 0;						\
+									\
+		if (condition) {					\
+			get_monotonic_time(&tmo);			\
+			tmo.tv_nsec += (ms) * 1000 * 1000;		\
+			normalize_timespec(&tmo);			\
+			do						\
+				rc = pthread_cond_timedwait(		\
+					&config_cond, &config_lock, &tmo); \
+			while (rc == 0 && (condition));			\
+		}							\
+		rc;							\
+	})
+
 /*
  * If the current status is @oldstate, wait for at most @ms milliseconds
  * for the state to change, and return the new state, which may still be
@@ -232,20 +249,14 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms)
 {
 	enum daemon_status st;
-	struct timespec tmo;
 
 	if (oldstate == DAEMON_SHUTDOWN)
 		return DAEMON_SHUTDOWN;
 
 	pthread_mutex_lock(&config_lock);
 	pthread_cleanup_push(config_cleanup, NULL);
+	__wait_for_state_change(running_state == oldstate, ms);
 	st = running_state;
-	if (st == oldstate && clock_gettime(CLOCK_MONOTONIC, &tmo) == 0) {
-		tmo.tv_nsec += ms * 1000 * 1000;
-		normalize_timespec(&tmo);
-		(void)pthread_cond_timedwait(&config_cond, &config_lock, &tmo);
-		st = running_state;
-	}
 	pthread_cleanup_pop(1);
 	return st;
 }
-- 
2.28.0
