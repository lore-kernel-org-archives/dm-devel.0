From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 03/24] multipath-tools: decrease verbosity of
	state messages
Date: Mon, 10 Dec 2018 10:49:38 +0100
Message-ID: <20181210094959.11338-4-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

With verbosity level 3, thousands of "path state = running" messages
are logged, which are pretty much irrelevant, as the checker state
takes precedence. Also the "get_state" message is totally useless.

With this patch, the path state is reported exactly once per path
and check.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c |  4 +---
 multipathd/main.c        | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 63558ad8..f9a59011 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1433,7 +1433,7 @@ path_offline (struct path * pp)
 	}
 
 
-	condlog(3, "%s: path state = %s", pp->dev, buff);
+	condlog(4, "%s: path state = %s", pp->dev, buff);
 
 	if (pp->bus == SYSFS_BUS_SCSI) {
 		if (!strncmp(buff, "offline", 7)) {
@@ -1552,8 +1552,6 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 	struct checker * c = &pp->checker;
 	int state;
 
-	condlog(3, "%s: get_state", pp->dev);
-
 	if (!checker_selected(c)) {
 		if (daemon) {
 			if (pathinfo(pp, conf, DI_SYSFS) != PATHINFO_OK) {
diff --git a/multipathd/main.c b/multipathd/main.c
index c781115c..e07ef502 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1904,6 +1904,16 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	pp->tick = checkint;
 
 	newstate = path_offline(pp);
+	if (newstate == PATH_UP) {
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		newstate = get_state(pp, conf, 1, newstate);
+		pthread_cleanup_pop(1);
+	} else {
+		checker_clear_message(&pp->checker);
+		condlog(3, "%s: state %s, checker not called",
+			pp->dev, checker_state_name(newstate));
+	}
 	/*
 	 * Wait for uevent for removed paths;
 	 * some LLDDs like zfcp keep paths unavailable
@@ -1912,14 +1922,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	if (newstate == PATH_REMOVED)
 		newstate = PATH_DOWN;
 
-	if (newstate == PATH_UP) {
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
-		newstate = get_state(pp, conf, 1, newstate);
-		pthread_cleanup_pop(1);
-	} else
-		checker_clear_message(&pp->checker);
-
 	if (pp->wwid_changed) {
 		condlog(2, "%s: path wwid has changed. Refusing to use",
 			pp->dev);
-- 
2.19.2
