From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/39] libmultipath: fixup string copy and
	comparison
Date: Thu, 16 Jun 2016 11:47:08 +0200
Message-ID: <1466070465-1021-3-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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

When doing a strncpy or strncmp we need to omit the trailing
NULL in the length to avoid any possible overflow.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c | 11 +++++++----
 libmultipath/configure.c        | 10 +++++-----
 libmultipath/dmparser.c         | 16 ++++++++++------
 libmultipath/prio.c             |  2 +-
 libmultipath/structs_vec.c      |  4 ++--
 libmultipath/waiter.c           |  2 +-
 6 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index b23e116..d2c3e53 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -375,7 +375,8 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 		/*
 		 * discard out of scope maps
 		 */
-		if (mpp->alias && refwwid && strncmp (mpp->alias, refwwid, WWID_SIZE)){
+		if (mpp->alias && refwwid &&
+		    strncmp (mpp->alias, refwwid, WWID_SIZE - 1)){
 			free_multipath (mpp, KEEP_PATHS);
 			vector_del_slot (curmp, i);
 			i--;
@@ -485,7 +486,8 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 				condlog (1, "%s: %s path not up. Skip.", mpp->wwid, pp->dev);
 				continue;
 			}
-			strncpy(thread[count].param.dev, pp->dev, FILE_NAME_SIZE);
+			strncpy(thread[count].param.dev, pp->dev,
+				FILE_NAME_SIZE - 1);
 
 			if (count && (thread[count].param.paramp->sa_flags & MPATH_F_SPEC_I_PT_MASK)){
 				/*
@@ -602,7 +604,7 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
 	int rc;
 
 	memset(&thread, 0, sizeof(thread));
-	strncpy(param.dev, dev, FILE_NAME_SIZE);
+	strncpy(param.dev, dev, FILE_NAME_SIZE - 1);
 	/* Initialize and set thread joinable attribute */
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
@@ -670,7 +672,8 @@ int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 				continue;
 			}
 
-			strncpy(thread[count].param.dev, pp->dev, FILE_NAME_SIZE);
+			strncpy(thread[count].param.dev, pp->dev,
+				FILE_NAME_SIZE - 1);
 			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
 			rc = pthread_create (&thread[count].id, &attr, mpath_prout_pthread_fn,
 					(void *) (&thread[count].param));
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a4a2c44..8e938c0 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -65,7 +65,7 @@ int group_by_host_adapter(struct pathgroup *pgp, vector adapters)
 			goto out;
 		agp->pgp = pgp;
 
-		strncpy(agp->adapter_name, adapter_name1, SLOT_NAME_SIZE);
+		strncpy(agp->adapter_name, adapter_name1, SLOT_NAME_SIZE - 1);
 		store_adaptergroup(adapters, agp);
 
 		/* create a new host port group
@@ -395,7 +395,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		if (cmpp) {
 			condlog(2, "%s: rename %s to %s", mpp->wwid,
 				cmpp->alias, mpp->alias);
-			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
+			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE - 1);
 			mpp->action = ACT_RENAME;
 			if (force_reload)
 				mpp->action = ACT_FORCERENAME;
@@ -410,7 +410,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	if (!cmpp) {
 		condlog(2, "%s: remove (wwid changed)", mpp->alias);
 		dm_flush_map(mpp->alias);
-		strncpy(cmpp_by_name->wwid, mpp->wwid, WWID_SIZE);
+		strncpy(cmpp_by_name->wwid, mpp->wwid, WWID_SIZE - 1);
 		drop_multipath(curmp, cmpp_by_name->wwid, KEEP_PATHS);
 		mpp->action = ACT_CREATE;
 		condlog(3, "%s: set ACT_CREATE (map wwid change)",
@@ -770,7 +770,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		}
 
 		/* 4. path is out of scope */
-		if (refwwid && strncmp(pp1->wwid, refwwid, WWID_SIZE))
+		if (refwwid && strncmp(pp1->wwid, refwwid, WWID_SIZE - 1))
 			continue;
 
 		/* If find_multipaths was selected check if the path is valid */
@@ -896,7 +896,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			if (!deadmap(mpp))
 				continue;
 
-			strncpy(alias, mpp->alias, WWID_SIZE);
+			strncpy(alias, mpp->alias, WWID_SIZE - 1);
 
 			if ((j = find_slot(newmp, (void *)mpp)) != -1)
 				vector_del_slot(newmp, j);
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 289be89..98fb559 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -344,10 +344,11 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 				if (!pp)
 					goto out1;
 
-				strncpy(pp->dev_t, word, BLK_DEV_SIZE);
-				strncpy(pp->dev, devname, FILE_NAME_SIZE);
+				strncpy(pp->dev_t, word, BLK_DEV_SIZE - 1);
+				strncpy(pp->dev, devname, FILE_NAME_SIZE - 1);
 				if (strlen(mpp->wwid)) {
-					strncpy(pp->wwid, mpp->wwid, WWID_SIZE);
+					strncpy(pp->wwid, mpp->wwid,
+						WWID_SIZE - 1);
 				}
 				/* Only call this in multipath client mode */
 				if (!conf->daemon && store_path(pathvec, pp))
@@ -355,7 +356,8 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 			} else {
 				if (!strlen(pp->wwid) &&
 				    strlen(mpp->wwid))
-					strncpy(pp->wwid, mpp->wwid, WWID_SIZE);
+					strncpy(pp->wwid, mpp->wwid,
+						WWID_SIZE - 1);
 			}
 			FREE(word);
 
@@ -367,14 +369,16 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 			 * in the get_dm_mpvec() code path
 			 */
 			if (!strlen(mpp->wwid))
-				strncpy(mpp->wwid, pp->wwid, WWID_SIZE);
+				strncpy(mpp->wwid, pp->wwid,
+					WWID_SIZE - 1);
 
 			/*
 			 * Update wwid for paths which may not have been
 			 * active at the time the getuid callout was run
 			 */
 			else if (!strlen(pp->wwid))
-				strncpy(pp->wwid, mpp->wwid, WWID_SIZE);
+				strncpy(pp->wwid, mpp->wwid,
+					WWID_SIZE - 1);
 
 			pgp->id ^= (long)pp;
 			pp->pgindex = i + 1;
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index ab8eca9..fbf3190 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -158,7 +158,7 @@ void prio_get (struct prio * dst, char * name, char * args)
 
 	strncpy(dst->name, src->name, PRIO_NAME_LEN);
 	if (args)
-		strncpy(dst->args, args, PRIO_ARGS_LEN);
+		strncpy(dst->args, args, PRIO_ARGS_LEN - 1);
 	dst->getprio = src->getprio;
 	dst->handle = NULL;
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7d46d42..e992b54 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -447,8 +447,8 @@ find_existing_alias (struct multipath * mpp,
 	int i;
 
 	vector_foreach_slot (vecs->mpvec, mp, i)
-		if (strcmp(mp->wwid, mpp->wwid) == 0) {
-			strncpy(mpp->alias_old, mp->alias, WWID_SIZE);
+		if (strncmp(mp->wwid, mpp->wwid, WWID_SIZE - 1) == 0) {
+			strncpy(mpp->alias_old, mp->alias, WWID_SIZE - 1);
 			return;
 		}
 }
diff --git a/libmultipath/waiter.c b/libmultipath/waiter.c
index 7cedd4b..6937034 100644
--- a/libmultipath/waiter.c
+++ b/libmultipath/waiter.c
@@ -191,7 +191,7 @@ int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 	if (!wp)
 		goto out;
 
-	strncpy(wp->mapname, mpp->alias, WWID_SIZE);
+	strncpy(wp->mapname, mpp->alias, WWID_SIZE - 1);
 	wp->vecs = vecs;
 
 	if (pthread_create(&wp->thread, &waiter_attr, waitevent, wp)) {
-- 
2.6.6
