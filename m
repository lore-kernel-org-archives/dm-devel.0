From: tang.junhui@zte.com.cn
Subject: [PATCH 05/11] multipathd: add need_do_map to indicate
	whether need calling domap() in ev_remove_path()
Date: Thu, 12 Jan 2017 13:52:21 +0800
Message-ID: <1484200347-11188-6-git-send-email-tang.junhui@zte.com.cn>
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

Usually calling domap() in ev_remove_path() is needed, but only last
path need to call domap() in processing for merged uevents to reduce the
count of calling domap() and promote efficiency. So add input parameter
need_do_map to indicate whether need calling domap() in ev_remove_path().

Change-Id: I0a787330a249608396cc3e655465dc820f940539
Signed-off-by: tang.wenjun <tang.wenjun3@zte.com.cn>
---
 multipathd/cli_handlers.c |  2 +-
 multipathd/main.c         | 23 ++++++++++++++++++-----
 multipathd/main.h         |  2 +-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 3a46c09..302fd02 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -693,7 +693,7 @@ cli_del_path (void * v, char ** reply, int * len, void * data)
 		condlog(0, "%s: path already removed", param);
 		return 1;
 	}
-	return ev_remove_path(pp, vecs);
+	return ev_remove_path(pp, vecs, 1);
 }
 
 int
diff --git a/multipathd/main.c b/multipathd/main.c
index ebd7de1..718c5e7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -858,7 +858,7 @@ fail:
 }
 
 static int
-uev_remove_path (struct uevent *uev, struct vectors * vecs)
+uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 {
 	struct path *pp;
 	int ret;
@@ -868,8 +868,18 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs)
 	lock(&vecs->lock);
 	pthread_testcancel();
 	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
-	if (pp)
-		ret = ev_remove_path(pp, vecs);
+	if (pp) {
+		/*
+		 * Make sure merging use the correct wwid
+		 * Othterwise calling domap()
+		 */
+		if (!need_do_map &&
+		    uev->merge_id &&
+		    strcmp(uev->merge_id, pp->wwid))
+			need_do_map = 1;
+		
+		ret = ev_remove_path(pp, vecs, need_do_map);
+	}
 	lock_cleanup_pop(vecs->lock);
 	if (!pp) {
 		/* Not an error; path might have been purged earlier */
@@ -880,7 +890,7 @@ uev_remove_path (struct uevent *uev, struct vectors * vecs)
 }
 
 int
-ev_remove_path (struct path *pp, struct vectors * vecs)
+ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 {
 	struct multipath * mpp;
 	int i, retval = 0;
@@ -902,6 +912,9 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 		if ((i = find_slot(mpp->paths, (void *)pp)) != -1)
 			vector_del_slot(mpp->paths, i);
 
+		if(!need_do_map)
+			goto out;
+
 		/*
 		 * remove the map IFF removing the last path
 		 */
@@ -1179,7 +1192,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 		goto out;
 	}
 	if (!strncmp(uev->action, "remove", 6)) {
-		r = uev_remove_path(uev, vecs);
+		r = uev_remove_path(uev, vecs, 1);
 		goto out;
 	}
 	if (!strncmp(uev->action, "change", 6)) {
diff --git a/multipathd/main.h b/multipathd/main.h
index f810d41..094b04f 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -23,7 +23,7 @@ const char * daemon_status(void);
 int need_to_delay_reconfig (struct vectors *);
 int reconfigure (struct vectors *);
 int ev_add_path (struct path *, struct vectors *, int);
-int ev_remove_path (struct path *, struct vectors *);
+int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
 void sync_map_state (struct multipath *);
-- 
2.8.1.windows.1
