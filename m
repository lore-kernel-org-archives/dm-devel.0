From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix misspellings
Date: Fri,  9 Mar 2018 00:08:48 +0100
Message-ID: <20180308230848.3489-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Done with https://github.com/lucasdemarchi/codespell

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/devmapper.c                    |  2 +-
 kpartx/solaris.c                      |  2 +-
 kpartx/test-kpartx                    |  2 +-
 libdmmp/DEV_NOTES                     |  2 +-
 libdmmp/libdmmp.c                     |  2 +-
 libmpathpersist/mpath_persist.c       |  2 +-
 libmultipath/foreign.h                | 16 ++++++++--------
 libmultipath/memory.c                 |  2 +-
 libmultipath/parser.c                 |  2 +-
 libmultipath/prioritizers/alua_spc3.h |  4 ++--
 libmultipath/uevent.c                 |  2 +-
 multipathd/cli.c                      |  2 +-
 multipathd/main.c                     |  4 ++--
 13 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index eb9dac6..8f68a24 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -302,7 +302,7 @@ out:
 /*
  * dm_get_first_dep
  *
- * Return the device number of the first dependend device
+ * Return the device number of the first dependent device
  * for a given target.
  */
 dev_t dm_get_first_dep(char *devname)
diff --git a/kpartx/solaris.c b/kpartx/solaris.c
index 01da379..8c1a971 100644
--- a/kpartx/solaris.c
+++ b/kpartx/solaris.c
@@ -10,7 +10,7 @@
 
 struct solaris_x86_slice {
 	unsigned short	s_tag;		/* ID tag of partition */
-	unsigned short	s_flag;		/* permision flags */
+	unsigned short	s_flag;		/* permission flags */
 	long		s_start;	/* start sector no of partition */
 	long		s_size;		/* # of blocks in partition */
 };
diff --git a/kpartx/test-kpartx b/kpartx/test-kpartx
index 09d15a9..9cee20f 100755
--- a/kpartx/test-kpartx
+++ b/kpartx/test-kpartx
@@ -22,7 +22,7 @@
 # stale DM or loop devices may keep lurking around.
 
 # Set WORKDIR in environment to existing dir to for persistence
-# WARNING:  exisiting files will be truncated.
+# WARNING:  existing files will be truncated.
 # If empty, test will be done in temporary dir
 : ${WORKDIR:=}
 # Set this environment variable to test an alternative kpartx executable
diff --git a/libdmmp/DEV_NOTES b/libdmmp/DEV_NOTES
index 220a9f4..3460cdf 100644
--- a/libdmmp/DEV_NOTES
+++ b/libdmmp/DEV_NOTES
@@ -1,4 +1,4 @@
-== Planed features ==
+== Planned features ==
  * Expose all properties used by /usr/bin/multipath
 
 == Code style ==
diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 944cecd..aafd509 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -304,7 +304,7 @@ static int _process_cmd(struct dmmp_context *ctx, int fd, const char *cmd,
 		ipc_tmo = _DEFAULT_UXSOCK_TIMEOUT;
 
 invoke:
-	_debug(ctx, "Invoking IPC command '%s' with IPC tmo %u miliseconds",
+	_debug(ctx, "Invoking IPC command '%s' with IPC tmo %u milliseconds",
 	       cmd, ipc_tmo);
 	flag_check_tmo = false;
 	if (mpath_process_cmd(fd, cmd, output, ipc_tmo) != 0) {
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 84ab293..5199e42 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -493,7 +493,7 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 		thread[i].param.noisy = noisy;
 		thread[i].param.status = MPATH_PR_SKIP;
 
-		condlog (3, "THRED ID [%d] INFO]", i);
+		condlog (3, "THREAD ID [%d] INFO]", i);
 		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
 		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope);
 		condlog (3, "rq_type=%d ", thread[i].param.rq_type);
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index 0ade2d7..973f368 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -74,7 +74,7 @@ struct foreign {
 	 * @retval FOREIGN_CLAIMED: device newly claimed
 	 * @retval FOREIGN_OK: device already registered, no action taken
 	 * @retval FOREIGN_IGNORED: device is ignored, no action taken
-	 * @retval FOREIGN_ERR: an error occured (e.g. out-of-memory)
+	 * @retval FOREIGN_ERR: an error occurred (e.g. out-of-memory)
 	 */
 	int (*add)(struct context *, struct udev_device *);
 
@@ -87,7 +87,7 @@ struct foreign {
 	 * @returns status code
 	 * @retval FOREIGN_OK: event processed
 	 * @retval FOREIGN_IGNORED: the device is ignored
-	 * @retval FOREIGN_ERR: an error occured (e.g. out-of-memory)
+	 * @retval FOREIGN_ERR: an error occurred (e.g. out-of-memory)
 	 *
 	 * Note: theoretically it can happen that the status of a foreign device
 	 * (claimed vs. not claimed) changes in a change event.
@@ -107,7 +107,7 @@ struct foreign {
 	 * @returns status code
 	 * @retval FOREIGN_OK: processed correctly (device deleted)
 	 * @retval FOREIGN_IGNORED: device wasn't registered internally
-	 * @retval FOREIGN_ERR: error occured.
+	 * @retval FOREIGN_ERR: error occurred.
 	 */
 	int (*delete)(struct context *, struct udev_device *);
 
@@ -120,7 +120,7 @@ struct foreign {
 	 * @returns status code
 	 * @retval FOREIGN_OK: processed correctly
 	 * @retval FOREIGN_IGNORED: nothing to delete
-	 * @retval FOREIGN_ERR: error occured
+	 * @retval FOREIGN_ERR: error occurred
 	 */
 	int (*delete_all)(struct context*);
 
@@ -135,13 +135,13 @@ struct foreign {
 	void (*check)(struct context *);
 
 	/**
-	 * lock internal data stuctures.
+	 * lock internal data structures.
 	 * @param[in] ctx: foreign context
 	 */
 	void (*lock)(struct context *ctx);
 
 	/**
-	 * unlock internal data stuctures.
+	 * unlock internal data structures.
 	 * @param[in] ctx: foreign context (void* in order to use the function
 	 *	as argument to pthread_cleanup_push())
 	 */
@@ -217,7 +217,7 @@ void cleanup_foreign(void);
  * @retval FOREIGN_CLAIMED: newly claimed by a foreign lib
  * @retval FOREIGN_OK: already claimed by a foreign lib
  * @retval FOREIGN_IGNORED: ignored by all foreign libs
- * @retval FOREIGN_ERR: an error occured
+ * @retval FOREIGN_ERR: an error occurred
  */
 int add_foreign(struct udev_device *);
 
@@ -309,7 +309,7 @@ void print_foreign_topology(int verbosity);
 /**
  * is_claimed_by_foreign(ud)
  * @param udev: udev device
- * @returns: true iff device is (newly or already) claimed by a foreign lib
+ * @returns: true if device is (newly or already) claimed by a foreign lib
  */
 static inline bool
 is_claimed_by_foreign(struct udev_device *ud)
diff --git a/libmultipath/memory.c b/libmultipath/memory.c
index ff5a030..7514642 100644
--- a/libmultipath/memory.c
+++ b/libmultipath/memory.c
@@ -38,7 +38,7 @@
  * ! 9  ! Allocated             !
  * +----+-----------------------+
  *
- * global variabel debug bit 9 ( 512 ) used to
+ * global variable debug bit 9 ( 512 ) used to
  * flag some memory error.
  *
  */
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 5caa201..d3f6a91 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -550,7 +550,7 @@ process_file(struct config *conf, char *file)
 	FILE *stream;
 
 	if (!conf->keywords) {
-		condlog(0, "No keywords alocated");
+		condlog(0, "No keywords allocated");
 		return 1;
 	}
 	stream = fopen(file, "r");
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index 13a0924..6790db9 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -119,7 +119,7 @@ struct inquiry_data {
 	unsigned char	b0;		/* xxx..... = peripheral_qualifier   */
 					/* ...xxxxx = peripheral_device_type */
 	unsigned char	b1;             /* x....... = removable medium       */
-					/* .xxxxxxx = reserverd              */
+					/* .xxxxxxx = reserved              */
 	unsigned char	version;
 	unsigned char	b3;		/* xx...... = obsolete               */
 					/* ..x..... = normal aca supported   */
@@ -238,7 +238,7 @@ struct vpd83_data {
 		)
 
 /*=============================================================================
- * The following stuctures and macros are used to call the report target port
+ * The following structures and macros are used to call the report target port
  * groups command defined in SPC-3.
  * This command is used to get information about the target port groups (which
  * states are supported, which ports belong to this group, and so on) and the
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 685ef33..ac4fa0f 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -259,7 +259,7 @@ merge_need_stop(struct uevent *earlier, struct uevent *later)
 	if (!earlier->wwid || !later->wwid)
 		return true;
 	/*
-	 * uevents merging stoped
+	 * uevents merging stopped
 	 * when we meet an opposite action uevent from the same LUN to AVOID
 	 * "add path1 |remove path1 |add path2 |remove path2 |add path3"
 	 * to merge as "remove path1, path2" and "add path1, path2, path3"
diff --git a/multipathd/cli.c b/multipathd/cli.c
index f10f862..6d86e81 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -621,7 +621,7 @@ key_generator (const char * str, int state)
 		len = strlen(str);
 		int r = get_cmdvec(rl_line_buffer, &v);
 		/*
-		 * If a word completion is in progess, we don't want
+		 * If a word completion is in progress, we don't want
 		 * to take an exact keyword match in the fingerprint.
 		 * For ex "show map[tab]" would validate "map" and discard
 		 * "maps" as a valid candidate.
diff --git a/multipathd/main.c b/multipathd/main.c
index 327cc19..6c8df84 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -826,7 +826,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
 			vector_del_slot(mpp->paths, i);
 
 		/*
-		 * remove the map IFF removing the last path
+		 * remove the map IF removing the last path
 		 */
 		if (VECTOR_SIZE(mpp->paths) == 0) {
 			char alias[WWID_SIZE];
@@ -1435,7 +1435,7 @@ defered_failback_tick (vector mpvec)
 
 	vector_foreach_slot (mpvec, mpp, i) {
 		/*
-		 * defered failback getting sooner
+		 * deferred failback getting sooner
 		 */
 		if (mpp->pgfailback > 0 && mpp->failback_tick > 0) {
 			mpp->failback_tick--;
-- 
2.14.3
