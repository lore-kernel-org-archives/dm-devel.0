From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 4/7] multipathd: add "del maps" multipathd
	command
Date: Thu,  2 Jul 2020 19:07:03 -0500
Message-ID: <1593734826-14059-5-git-send-email-bmarzins@redhat.com>
References: <1593734826-14059-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593734826-14059-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This will flush all multipath devices.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c  |  7 +++++--
 libmultipath/devmapper.h  |  2 +-
 multipath/main.c          |  2 +-
 multipathd/cli.c          |  1 +
 multipathd/cli_handlers.c | 19 +++++++++++++++++++
 multipathd/cli_handlers.h |  1 +
 multipathd/main.c         |  3 ++-
 multipathd/main.h         |  1 +
 8 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 4c86b6d4..f597ff8b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1005,7 +1005,7 @@ dm_flush_map_nopaths(const char * mapname, int deferred_remove)
 
 #endif
 
-int dm_flush_maps (int retries)
+int dm_flush_maps (int need_suspend, int retries)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -1028,7 +1028,10 @@ int dm_flush_maps (int retries)
 
 	r = 0;
 	do {
-		r |= dm_suspend_and_flush_map(names->name, retries);
+		if (need_suspend)
+			r |= dm_suspend_and_flush_map(names->name, retries);
+		else
+			r |= dm_flush_map(names->name);
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index b2108638..6dd178c8 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -57,7 +57,7 @@ int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 #define dm_suspend_and_flush_map(mapname, retries) \
 	_dm_flush_map(mapname, 1, 0, 1, retries)
 int dm_cancel_deferred_remove(struct multipath *mpp);
-int dm_flush_maps (int retries);
+int dm_flush_maps (int need_suspend, int retries);
 int dm_fail_path(const char * mapname, char * path);
 int dm_reinstate_path(const char * mapname, char * path);
 int dm_queue_if_no_path(const char *mapname, int enable);
diff --git a/multipath/main.c b/multipath/main.c
index c4740fab..d89f0a91 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1096,7 +1096,7 @@ main (int argc, char *argv[])
 		goto out;
 	}
 	else if (conf->remove == FLUSH_ALL) {
-		r = dm_flush_maps(retries) ? RTVL_FAIL : RTVL_OK;
+		r = dm_flush_maps(1, retries) ? RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
 	while ((r = configure(conf, cmd, dev_type, dev)) == RTVL_RETRY)
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 800c0fbe..bdc9fb10 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -568,6 +568,7 @@ cli_init (void) {
 	add_handler(DEL+PATH, NULL);
 	add_handler(ADD+MAP, NULL);
 	add_handler(DEL+MAP, NULL);
+	add_handler(DEL+MAPS, NULL);
 	add_handler(SWITCH+MAP+GROUP, NULL);
 	add_handler(RECONFIGURE, NULL);
 	add_handler(SUSPEND+MAP, NULL);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 31c3d9fd..782bb003 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -852,6 +852,25 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 	return rc;
 }
 
+int
+cli_del_maps (void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	struct multipath *mpp;
+	int i, ret = 0;
+
+	condlog(2, "remove maps (operator)");
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		if (flush_map(mpp, vecs, 0))
+			ret++;
+		else
+			i--;
+	}
+	/* flush any multipath maps that aren't currently known by multipathd */
+	ret |= dm_flush_maps(0, 0);
+	return ret;
+}
+
 int
 cli_reload(void *v, char **reply, int *len, void *data)
 {
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 0f451064..6f57b429 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -26,6 +26,7 @@ int cli_add_path (void * v, char ** reply, int * len, void * data);
 int cli_del_path (void * v, char ** reply, int * len, void * data);
 int cli_add_map (void * v, char ** reply, int * len, void * data);
 int cli_del_map (void * v, char ** reply, int * len, void * data);
+int cli_del_maps (void * v, char ** reply, int * len, void * data);
 int cli_switch_group(void * v, char ** reply, int * len, void * data);
 int cli_reconfigure(void * v, char ** reply, int * len, void * data);
 int cli_resize(void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index daf19a4e..f014d2a1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -635,7 +635,7 @@ sync_maps_state(vector mpvec)
 		sync_map_state(mpp);
 }
 
-static int
+int
 flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 {
 	int r;
@@ -1555,6 +1555,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(DEL+PATH, cli_del_path);
 	set_handler_callback(ADD+MAP, cli_add_map);
 	set_handler_callback(DEL+MAP, cli_del_map);
+	set_handler_callback(DEL+MAPS, cli_del_maps);
 	set_handler_callback(SWITCH+MAP+GROUP, cli_switch_group);
 	set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
 	set_handler_callback(SUSPEND+MAP, cli_suspend);
diff --git a/multipathd/main.h b/multipathd/main.h
index 7bb8463f..5dff17e5 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -28,6 +28,7 @@ int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
+int flush_map(struct multipath *, struct vectors *, int);
 int set_config_state(enum daemon_status);
 void * mpath_alloc_prin_response(int prin_sa);
 int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
-- 
2.17.2
