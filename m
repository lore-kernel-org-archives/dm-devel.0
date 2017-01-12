From: tang.junhui@zte.com.cn
Subject: [PATCH 04/11] multipathd: add need_do_map to indicate
	whether need calling domap() in ev_add_path()
Date: Thu, 12 Jan 2017 13:52:20 +0800
Message-ID: <1484200347-11188-5-git-send-email-tang.junhui@zte.com.cn>
References: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, bmarzins@redhat.com, hare@suse.de, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

Usually calling domap() in ev_add_path() is needed, but only last path
need to call domap() in processing for merged uevents to reduce the
count of calling domap() and promote efficiency. So add input parameter
need_do_map to indicate whether need calling domap() in ev_add_path().

Change-Id: I7f33de49a1d89d91180dcb95cd94e4944ae7ff36
Signed-off-by: tang.wenjun <tang.wenjun3@zte.com.cn>
---
 multipathd/cli_handlers.c |  3 ++-
 multipathd/main.c         | 47 ++++++++++++++++++++++++++++++++++++-----------
 multipathd/main.h         |  2 +-
 3 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b0eeca6..3a46c09 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -670,7 +670,8 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		pp->checkint = conf->checkint;
 	}
 	put_multipath_config(conf);
-	return ev_add_path(pp, vecs);
+	return ev_add_path(pp, vecs, 1);
+
 blacklisted:
 	*reply = strdup("blacklisted\n");
 	*len = strlen(*reply) + 1;
diff --git a/multipathd/main.c b/multipathd/main.c
index adc3258..ebd7de1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -608,7 +608,7 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 }
 
 static int
-uev_add_path (struct uevent *uev, struct vectors * vecs)
+uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
 	struct path *pp;
 	int ret = 0, i;
@@ -640,9 +640,18 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 			r = pathinfo(pp, conf,
 				     DI_ALL | DI_BLACKLIST);
 			put_multipath_config(conf);
-			if (r == PATHINFO_OK)
-				ret = ev_add_path(pp, vecs);
-			else if (r == PATHINFO_SKIPPED) {
+			if (r == PATHINFO_OK) {
+				/*
+				 * Make sure merging use the correct wwid
+				 * Othterwise calling domap()
+				 */
+				if (!need_do_map &&
+				    uev->merge_id &&
+				    strcmp(uev->merge_id, pp->wwid))
+					need_do_map = 1;
+
+				ret = ev_add_path(pp, vecs, need_do_map);
+			} else if (r == PATHINFO_SKIPPED) {
 				condlog(3, "%s: remove blacklisted path",
 					uev->kernel);
 				i = find_slot(vecs->pathvec, (void *)pp);
@@ -681,7 +690,16 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		conf = get_multipath_config();
 		pp->checkint = conf->checkint;
 		put_multipath_config(conf);
-		ret = ev_add_path(pp, vecs);
+		/*
+		 * Make sure merging use the correct wwid
+		 * Othterwise calling domap()
+		 */
+		if (!need_do_map &&
+		    uev->merge_id &&
+		    strcmp(uev->merge_id, pp->wwid))
+			need_do_map = 1;
+
+		ret = ev_add_path(pp, vecs, need_do_map);
 	} else {
 		condlog(0, "%s: failed to store path info, "
 			"dropping event",
@@ -699,7 +717,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
  * 1: error
  */
 int
-ev_add_path (struct path * pp, struct vectors * vecs)
+ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
 	char params[PARAMS_SIZE] = {0};
@@ -767,6 +785,13 @@ rescan:
 	/* persistent reservation check*/
 	mpath_pr_event_handle(pp);
 
+	if (!need_do_map)
+		return 0;
+
+	if (!dm_map_present(mpp->alias)) {
+		mpp->action = ACT_CREATE;
+		start_waiter = 1;
+	}
 	/*
 	 * push the map to the device-mapper
 	 */
@@ -995,7 +1020,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		}
 
 		if (pp->initialized == INIT_REQUESTED_UDEV)
-			retval = uev_add_path(uev, vecs);
+			retval = uev_add_path(uev, vecs, 1);
 		else if (mpp && ro >= 0) {
 			condlog(2, "%s: update path write_protect to '%d' (uevent)", uev->kernel, ro);
 
@@ -1150,7 +1175,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	put_multipath_config(conf);
 
 	if (!strncmp(uev->action, "add", 3)) {
-		r = uev_add_path(uev, vecs);
+		r = uev_add_path(uev, vecs, 1);
 		goto out;
 	}
 	if (!strncmp(uev->action, "remove", 6)) {
@@ -1570,7 +1595,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			conf = get_multipath_config();
 			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
 			if (ret == PATHINFO_OK) {
-				ev_add_path(pp, vecs);
+				ev_add_path(pp, vecs, 1);
 				pp->tick = 1;
 			} else if (ret == PATHINFO_SKIPPED) {
 				put_multipath_config(conf);
@@ -1686,7 +1711,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		}
 		if (!disable_reinstate && reinstate_path(pp, add_active)) {
 			condlog(3, "%s: reload map", pp->dev);
-			ev_add_path(pp, vecs);
+			ev_add_path(pp, vecs, 1);
 			pp->tick = 1;
 			return 0;
 		}
@@ -1709,7 +1734,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			/* Clear IO errors */
 			if (reinstate_path(pp, 0)) {
 				condlog(3, "%s: reload map", pp->dev);
-				ev_add_path(pp, vecs);
+				ev_add_path(pp, vecs, 1);
 				pp->tick = 1;
 				return 0;
 			}
diff --git a/multipathd/main.h b/multipathd/main.h
index f72580d..f810d41 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -22,7 +22,7 @@ void exit_daemon(void);
 const char * daemon_status(void);
 int need_to_delay_reconfig (struct vectors *);
 int reconfigure (struct vectors *);
-int ev_add_path (struct path *, struct vectors *);
+int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *);
 int ev_add_map (char *, char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
-- 
2.8.1.windows.1
