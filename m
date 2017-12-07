From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 04/12] libmultipath: cleanup features handling
	code
Date: Thu,  7 Dec 2017 12:48:58 -0600
Message-ID: <1512672546-12785-5-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Right now multipath does some extra work to set the values for
no_path_retry and retain_hwhandler on existing maps it reads in from the
kernel.  This is so that select_action() can use these values to see if
it needs to reload the devices. However, the way it works, the
queue_if_no_path feature isn't always set correctly, and multipath has
to go back afterwards and reset the value anyways.

It's simpler for select_action to just look at the values in the
features line it read in from the kernel and the features line it would
like the new map to have.  By comparing these, it also avoids the
problem where the no_path_retry values match, so it doesn't reload, but
the actual queue_if_no_path feature value is incorrect, so it has to go
back and reset it. It can also skip calling setup_feature() entirely.

To do this, assemble_map() needs to update mp->features. This would
otherwise partially happen when it had to reset the queue_if_no_path
value.  retain_attached_hw_handler was never getting updated before, so
the output when you created a map was incorrect.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 21 ++++-----------------
 libmultipath/dmparser.c  | 35 ++++++-----------------------------
 libmultipath/structs.c   | 17 -----------------
 libmultipath/structs.h   |  1 -
 4 files changed, 10 insertions(+), 64 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 0dfa250..7ca84b8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -557,7 +557,8 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	}
 
 	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
-	    mpp->no_path_retry != cmpp->no_path_retry) {
+	    !!strstr(mpp->features, "queue_if_no_path") !=
+	    !!strstr(cmpp->features, "queue_if_no_path")) {
 		mpp->action =  ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (no_path_retry change)",
 			mpp->alias);
@@ -575,7 +576,8 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	}
 
 	if (mpp->retain_hwhandler != RETAIN_HWHANDLER_UNDEF &&
-	    mpp->retain_hwhandler != cmpp->retain_hwhandler &&
+	    !!strstr(mpp->features, "retain_attached_hw_handler") !=
+	    !!strstr(cmpp->features, "retain_attached_hw_handler") &&
 	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0)) {
 		mpp->action = ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (retain_hwhandler change)",
@@ -1060,21 +1062,6 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				remove_feature(&mpp->features,
 					       "queue_if_no_path");
 		}
-		else if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
-			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL) {
-				condlog(3, "%s: unset queue_if_no_path feature",
-					mpp->alias);
-				if (!dm_queue_if_no_path(mpp->alias, 0))
-					remove_feature(&mpp->features,
-						       "queue_if_no_path");
-			} else {
-				condlog(3, "%s: set queue_if_no_path feature",
-					mpp->alias);
-				if (!dm_queue_if_no_path(mpp->alias, 1))
-					add_feature(&mpp->features,
-						    "queue_if_no_path");
-			}
-		}
 
 		if (!is_daemon && mpp->action != ACT_NOTHING) {
 			conf = get_multipath_config();
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index b647c25..642f44f 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -83,23 +83,15 @@ assemble_map (struct multipath * mp, char * params, int len)
 	nr_priority_groups = VECTOR_SIZE(mp->pg);
 	initial_pg_nr = (nr_priority_groups ? mp->bestpg : 0);
 
-	f = STRDUP(mp->features);
-
-	/*
-	 * We have to set 'queue_if_no_path' here even
-	 * to avoid path failures during map reload.
-	 */
-	if (mp->no_path_retry == NO_PATH_RETRY_FAIL) {
-		/* remove queue_if_no_path settings */
-		condlog(3, "%s: remove queue_if_no_path from '%s'",
-			mp->alias, mp->features);
-		remove_feature(&f, no_path_retry);
-	} else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF) {
-		add_feature(&f, no_path_retry);
+	if (mp->no_path_retry != NO_PATH_RETRY_UNDEF  &&
+	    mp->no_path_retry != NO_PATH_RETRY_FAIL) {
+		add_feature(&mp->features, no_path_retry);
 	}
 	if (mp->retain_hwhandler == RETAIN_HWHANDLER_ON &&
 	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
-		add_feature(&f, retain_hwhandler);
+		add_feature(&mp->features, retain_hwhandler);
+
+	f = STRDUP(mp->features);
 
 	APPEND(p, end, "%s %s %i %i", f, mp->hwhandler, nr_priority_groups,
 	       initial_pg_nr);
@@ -148,7 +140,6 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 	int num_paths = 0;
 	int num_paths_args = 0;
 	int def_minio = 0;
-	int no_path_retry = NO_PATH_RETRY_UNDEF;
 	struct path * pp;
 	struct pathgroup * pgp;
 
@@ -165,8 +156,6 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 		return 1;
 
 	num_features = atoi(mpp->features);
-	no_path_retry = mpp->no_path_retry;
-	mpp->no_path_retry = NO_PATH_RETRY_UNDEF;
 
 	for (i = 0; i < num_features; i++) {
 		p += get_word(p, &word);
@@ -178,23 +167,11 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 			FREE(word);
 			return 1;
 		}
-		setup_feature(mpp, word);
 
 		FREE(word);
 	}
 
 	/*
-	 * Reset no_path_retry.
-	 * - if not set from features
-	 * - if queue_if_no_path is set from features but
-	 *   no_path_retry > 0 is selected.
-	 */
-	if ((mpp->no_path_retry == NO_PATH_RETRY_UNDEF ||
-	     mpp->no_path_retry == NO_PATH_RETRY_QUEUE) &&
-	    mpp->no_path_retry != no_path_retry)
-		mpp->no_path_retry = no_path_retry;
-
-	/*
 	 * hwhandler
 	 */
 	p += get_word(p, &mpp->hwhandler);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 3e057f5..c42d765 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -497,23 +497,6 @@ first_path (struct multipath * mpp)
 	return pgp?VECTOR_SLOT(pgp->paths, 0):NULL;
 }
 
-void setup_feature(struct multipath *mpp, char *feature)
-{
-	if (!strncmp(feature, "queue_if_no_path", 16)) {
-		if (mpp->no_path_retry <= NO_PATH_RETRY_UNDEF)
-			mpp->no_path_retry = NO_PATH_RETRY_QUEUE;
-		else
-			condlog(1, "%s: ignoring feature queue_if_no_path because no_path_retry = %d",
-				mpp->alias, mpp->no_path_retry);
-	} else if (!strcmp(feature, "retain_attached_hw_handler")) {
-		if (mpp->retain_hwhandler != RETAIN_HWHANDLER_OFF)
-			mpp->retain_hwhandler = RETAIN_HWHANDLER_ON;
-		else
-			condlog(1, "%s: ignoring feature 'retain_attached_hw_handler'",
-				mpp->alias);
-	}
-}
-
 int add_feature(char **f, const char *n)
 {
 	int c = 0, d, l;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 4d738d2..effa52f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -386,7 +386,6 @@ struct path * first_path (struct multipath * mpp);
 int pathcountgr (struct pathgroup *, int);
 int pathcount (struct multipath *, int);
 int pathcmp (struct pathgroup *, struct pathgroup *);
-void setup_feature(struct multipath *, char *);
 int add_feature (char **, const char *);
 int remove_feature (char **, const char *);
 
-- 
2.7.4
