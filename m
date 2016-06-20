From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/26] libmultipath: Do not access 'conf->cmd' in
	domap()
Date: Mon, 20 Jun 2016 10:08:55 +0200
Message-ID: <1466410153-23896-9-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

'conf->cmd' is only ever set if we're called from multipath, so
we can combine the 'is_daemon' argument and the 'conf->cmd' check
in domap() and avoid accessing 'conf->cmd' in domap().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/config.h    | 1 +
 libmultipath/configure.c | 7 +++++--
 libmultipath/configure.h | 3 ++-
 multipath/main.c         | 5 +++--
 multipathd/main.c        | 4 ++--
 5 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 51afd22..715b887 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -24,6 +24,7 @@ enum devtypes {
 };
 
 enum mpath_cmds {
+	CMD_NONE,
 	CMD_CREATE,
 	CMD_DRY_RUN,
 	CMD_LIST_SHORT,
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d15d898..44b2d2b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -586,7 +586,7 @@ domap (struct multipath * mpp, char * params, int is_daemon)
 	/*
 	 * last chance to quit before touching the devmaps
 	 */
-	if (conf->cmd == CMD_DRY_RUN && mpp->action != ACT_NOTHING) {
+	if (mpp->action == ACT_DRY_RUN) {
 		print_multipath_topology(mpp, conf->verbosity);
 		return DOMAP_DRY;
 	}
@@ -731,10 +731,11 @@ out:
 }
 
 extern int
-coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_reload, int is_daemon)
+coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_reload, enum mpath_cmds cmd)
 {
 	int r = 1;
 	int k, i;
+	int is_daemon = (cmd == CMD_NONE) ? 1 : 0;
 	char params[PARAMS_SIZE];
 	struct multipath * mpp;
 	struct path * pp1;
@@ -827,6 +828,8 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			continue;
 		}
 
+		if (cmd == CMD_DRY_RUN)
+			mpp->action = ACT_DRY_RUN;
 		if (mpp->action == ACT_UNDEF)
 			select_action(mpp, curmp, force_reload);
 
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index c0338bf..8d474ea 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -19,6 +19,7 @@ enum actions {
 	ACT_CREATE,
 	ACT_RESIZE,
 	ACT_FORCERENAME,
+	ACT_DRY_RUN,
 };
 
 #define FLUSH_ONE 1
@@ -27,7 +28,7 @@ enum actions {
 int setup_map (struct multipath * mpp, char * params, int params_size );
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
-int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, int is_daemon);
+int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
 int get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid);
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
 int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name);
diff --git a/multipath/main.c b/multipath/main.c
index 7c35ce1..e16c6cc 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -381,7 +381,7 @@ configure (void)
 	 * core logic entry point
 	 */
 	r = coalesce_paths(&vecs, NULL, refwwid,
-			   conf->force_reload, 0);
+			   conf->force_reload, conf->cmd);
 
 out:
 	if (refwwid)
@@ -484,7 +484,8 @@ main (int argc, char *argv[])
 	logsink = 0;
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
-
+	/* Default to CMD_CREATE */
+	conf->cmd = CMD_CREATE;
 	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
diff --git a/multipathd/main.c b/multipathd/main.c
index 9568ae9..036872c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -487,7 +487,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 	r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
 
 	if (refwwid) {
-		r = coalesce_paths(vecs, NULL, refwwid, 0, 1);
+		r = coalesce_paths(vecs, NULL, refwwid, 0, CMD_NONE);
 		dm_lib_release();
 	}
 
@@ -1798,7 +1798,7 @@ configure (struct vectors * vecs, int start_waiters)
 	/*
 	 * create new set of maps & push changed ones into dm
 	 */
-	if (coalesce_paths(vecs, mpvec, NULL, 1, 1))
+	if (coalesce_paths(vecs, mpvec, NULL, 1, CMD_NONE))
 		return 1;
 
 	/*
-- 
2.6.6
