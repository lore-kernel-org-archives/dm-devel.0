From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 6/7] multipathd: make DAEMON_SHUTDOWN a
	terminal state
Date: Tue, 30 Oct 2018 22:22:48 +0100
Message-ID: <20181030212249.31127-7-mwilck@suse.com>
References: <20181030212249.31127-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030212249.31127-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

It can happen that, before the main thread reacts on DAEMON_SHUTDOWN
and starts cancelling threads, another thread resets the state to
something else. Fix that.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c |  9 +++++++--
 multipathd/main.c         | 10 +++++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 4aea4ce7..a0d57a53 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1124,12 +1124,17 @@ cli_switch_group(void * v, char ** reply, int * len, void * data)
 int
 cli_reconfigure(void * v, char ** reply, int * len, void * data)
 {
+	int rc;
+
 	condlog(2, "reconfigure (operator)");
 
-	if (set_config_state(DAEMON_CONFIGURE) == ETIMEDOUT) {
+	rc = set_config_state(DAEMON_CONFIGURE); 
+	if (rc == ETIMEDOUT) {
 		condlog(2, "timeout starting reconfiguration");
 		return 1;
-	}
+	} else if (rc == EINVAL)
+		/* daemon shutting down */
+		return 1;
 	return 0;
 }
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 1b9b6e18..2f6aa3f0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -206,7 +206,7 @@ static void config_cleanup(void *arg)
 
 static void __post_config_state(enum daemon_status state)
 {
-	if (state != running_state) {
+	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
 		enum daemon_status old_state = running_state;
 
 		running_state = state;
@@ -234,7 +234,9 @@ int set_config_state(enum daemon_status state)
 	if (running_state != state) {
 		enum daemon_status old_state = running_state;
 
-		if (running_state != DAEMON_IDLE) {
+		if (running_state == DAEMON_SHUTDOWN)
+			rc = EINVAL;
+		else if (running_state != DAEMON_IDLE) {
 			struct timespec ts;
 
 			clock_gettime(CLOCK_MONOTONIC, &ts);
@@ -2206,7 +2208,9 @@ checkerloop (void *ap)
 		if (rc == ETIMEDOUT) {
 			condlog(4, "timeout waiting for DAEMON_IDLE");
 			continue;
-		}
+		} else if (rc == EINVAL)
+			/* daemon shutdown */
+			break;
 
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
 		lock(&vecs->lock);
-- 
2.19.1
