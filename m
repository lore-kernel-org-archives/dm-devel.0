From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Re: DM configuration
Date: Wed, 12 Oct 2005 13:25:30 -0400 (EDT)
Message-ID: <20051012.132530.41627610.k-ueda@ct.jp.nec.com>
References: <1128718450.18441.21.camel@zezette>
	<20051011.201745.115903307.k-ueda@ct.jp.nec.com>
	<1129094172.20114.53.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1129094172.20114.53.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

On Wed, 12 Oct 2005 07:16:12 +0200, Christophe Varoqui <christophe.varoqui@free.fr> wrote:
> > OK.
> > I extended the scope of the "no_path_retry" option to the multipath
> > command so that we can phase out the "features" option, because
> > the multipath command also sees the "features" option.
> > 
> > And fixed some bugs of the patch.
> >   o Initialization issue of retry_tick.
> >   o Missing status update of retry_tick in waiteventloop and reconfigure.
> > 
> > The new patch is below.
> > This patch doesn't change current behavior of multipath command by default.
> > The "no_path_option" option overrides the "features" option.
> > 
> Thanks,
> 
> I already merged the previous patch, with a little renaming.
> Can you rebase this one on korg git tree ?

Sure.  I attach 2 patches.

1). Extend the scope of the "no_path_retry" option to the multipath.
2). Fix some bugs of missing retry_tick initialization/update in multipathd.
    o Initialization by wrong value in update_queue_mode_del_path.
    o Missing status update in update_multipath for events from kernel.
    o Missing re-initialization in reconfigure.

====== 1). Extension of the "no_path_retry" scope to the multipath ======
diff -rup git/multipath/main.c no_path_retry_multipath/multipath/main.c
--- git/multipath/main.c	2005-10-12 10:08:28.000000000 -0400
+++ no_path_retry_multipath/multipath/main.c	2005-10-12 10:39:20.000000000 -0400
@@ -393,6 +393,7 @@ setup_map (struct multipath * mpp)
 	select_features(mpp);
 	select_hwhandler(mpp);
 	select_rr_weight(mpp);
+	select_no_path_retry(mpp);
 
 	/*
 	 * apply selected grouping policy to valid paths
@@ -592,6 +593,12 @@ reinstate_paths (struct multipath * mpp)
 	return 0;
 }
 
+/*
+ * Return value:
+ *   0: DM_DEVICE_CREATE or DM_DEVICE_RELOAD failed, or dry_run mode.
+ *   1: DM_DEVICE_CREATE or DM_DEVICE_RELOAD succeeded.
+ *   2: Map is already existing.
+ */
 static int
 domap (struct multipath * mpp)
 {
@@ -607,7 +614,7 @@ domap (struct multipath * mpp)
 
 	switch (mpp->action) {
 	case ACT_NOTHING:
-		return 0;
+		return 2;
 
 	case ACT_SWITCHPG:
 		dm_switchgroup(mpp->alias, mpp->nextpg);
@@ -617,7 +624,7 @@ domap (struct multipath * mpp)
 		 * retry.
 		 */
 		reinstate_paths(mpp);
-		return 0;
+		return 2;
 
 	case ACT_CREATE:
 		r = dm_addmap(DM_DEVICE_CREATE, mpp->alias, DEFAULT_TARGET,
@@ -746,7 +753,13 @@ coalesce_paths (vector curmp, vector pat
 
 		condlog(3, "action set to %i", mpp->action);
 
-		domap(mpp);
+		if (domap(mpp) && mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
+			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
+				dm_queue_if_no_path(mpp->alias, 0);
+			else
+				dm_queue_if_no_path(mpp->alias, 1);
+		}
+
 next:
 		drop_multipath(curmp, mpp->wwid, KEEP_PATHS);
 		free_multipath(mpp, KEEP_PATHS);
diff -rup git/multipath.conf.annotated no_path_retry_multipath/multipath.conf.annotated
--- git/multipath.conf.annotated	2005-10-12 10:08:28.000000000 -0400
+++ no_path_retry_multipath/multipath.conf.annotated	2005-10-12 10:40:19.000000000 -0400
@@ -102,7 +102,7 @@
 #
 #	#
 #	# name    : no_path_retry
-#	# scope   : multipathd
+#	# scope   : multipath & multipathd
 #	# desc    : tell the number of retries until disable queueing, or
 #	#           "fail" means immediate failure (no queueing),
 #	#           "queue" means never stop queueing
@@ -191,7 +191,7 @@
 #
 #		#
 #		# name    : no_path_retry
-#		# scope   : multipathd
+#		# scope   : multipath & multipathd
 #		# desc    : tell the number of retries until disable queueing, or
 #		#           "fail" means immediate failure (no queueing),
 #		#           "queue" means never stop queueing
==========================================================================



====== 2). retry_tick bug fix for multipathd =============================
diff -rup git/multipathd/main.c no_path_retry_fix/multipathd/main.c
--- git/multipathd/main.c	2005-10-12 10:08:28.000000000 -0400
+++ no_path_retry_fix/multipathd/main.c	2005-10-12 11:09:11.000000000 -0400
@@ -223,6 +223,70 @@ pathcount (struct multipath *mpp, int st
 	return count;
 }
 
+/*
+ * mpp->no_path_retry:
+ *   -2 (QUEUE) : queue_if_no_path enabled, never turned off
+ *   -1 (FAIL)  : fail_if_no_path
+ *    0 (UNDEF) : nothing
+ *   >0         : queue_if_no_path enabled, turned off after polling n times
+ */
+static void
+update_queue_mode_del_path(struct multipath *mpp)
+{
+	if (--mpp->nr_active == 0 && mpp->no_path_retry > 0) {
+		/*
+		 * Enter retry mode.
+		 * meaning of +1: retry_tick may be decremented in
+		 *                checkerloop before starting retry.
+		 */
+		mpp->retry_tick = mpp->no_path_retry * conf->checkint + 1;
+		condlog(1, "%s: Entering recovery mode: max_retries=%d",
+			mpp->alias, mpp->no_path_retry);
+	}
+	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
+}
+
+static void
+update_queue_mode_add_path(struct multipath *mpp)
+{
+	if (mpp->nr_active++ == 0 && mpp->no_path_retry > 0) {
+		/* come back to normal mode from retry mode */
+		mpp->retry_tick = 0;
+		dm_queue_if_no_path(mpp->alias, 1);
+		condlog(2, "%s: queue_if_no_path enabled", mpp->alias);
+		condlog(1, "%s: Recovered to normal mode", mpp->alias);
+	}
+	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
+}
+
+static void
+set_no_path_retry(struct multipath *mpp)
+{
+	mpp->retry_tick = 0;
+	mpp->nr_active = pathcount(mpp, PATH_UP);
+	select_no_path_retry(mpp);
+
+	switch (mpp->no_path_retry) {
+	case NO_PATH_RETRY_UNDEF:
+		break;
+	case NO_PATH_RETRY_FAIL:
+		dm_queue_if_no_path(mpp->alias, 0);
+		break;
+	case NO_PATH_RETRY_QUEUE:
+		dm_queue_if_no_path(mpp->alias, 1);
+		break;
+	default:
+		dm_queue_if_no_path(mpp->alias, 1);
+		if (mpp->nr_active == 0) {
+			/* Enter retry mode */
+			mpp->retry_tick = mpp->no_path_retry * conf->checkint;
+			condlog(1, "%s: Entering recovery mode: max_retries=%d",
+				mpp->alias, mpp->no_path_retry);
+		}
+		break;
+	}
+}
+
 static int
 setup_multipath (struct vectors * vecs, struct multipath * mpp)
 {
@@ -237,14 +301,7 @@ setup_multipath (struct vectors * vecs, 
 
 	set_paths_owner(vecs, mpp);
 	select_pgfailback(mpp);
-	mpp->nr_active = pathcount(mpp, PATH_UP);
-	select_no_path_retry(mpp);
-	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
-		if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
-			dm_queue_if_no_path(mpp->alias, 0);
-		else
-			dm_queue_if_no_path(mpp->alias, 1);
-	}
+	set_no_path_retry(mpp);
 
 	return 0;
 out:
@@ -331,6 +388,7 @@ update_multipath (struct vectors *vecs, 
 			if (pp->state != PATH_DOWN) {
 				condlog(2, "%s: mark as failed", pp->dev_t);
 				pp->state = PATH_DOWN;
+				update_queue_mode_del_path(pp->mpp);
 
 				/*
 				 * if opportune,
@@ -370,38 +428,6 @@ static sigset_t unblock_sighup(void)
 }
 
 /*
- * mpp->no_path_retry:
- *   -2 : queue_if_no_path enabled, never turned off
- *   -1 : fail_if_no_path
- *    0 : nothing
- *   >0 : queue_if_no_path enabled, turned off after polling n times
- */
-static void
-update_queue_mode_del_path(struct multipath *mpp)
-{
-	if (--mpp->nr_active == 0 && mpp->no_path_retry > 0) {
-		/* Enter retry mode */
-		mpp->retry_tick = mpp->no_path_retry * conf->checkint;
-		condlog(1, "%s: Entering recovery mode: max_retries=%d",
-			mpp->alias, mpp->no_path_retry);
-	}
-	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
-}
-
-static void
-update_queue_mode_add_path(struct multipath *mpp)
-{
-	if (mpp->nr_active++ == 0 && mpp->no_path_retry > 0) {
-		/* come back to normal mode from retry mode */
-		mpp->retry_tick = 0;
-		dm_queue_if_no_path(mpp->alias, 1);
-		condlog(2, "%s: queue_if_no_path enabled", mpp->alias);
-		condlog(1, "%s: Recovered to normal mode", mpp->alias);
-	}
-	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
-}
-
-/*
  * returns the reschedule delay
  * negative means *stop*
  */
@@ -876,13 +902,7 @@ reconfigure (struct vectors * vecs)
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
 		mpp->mpe = find_mpe(mpp->wwid);
 		set_paths_owner(vecs, mpp);
-		select_no_path_retry(mpp);
-		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
-			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
-				dm_queue_if_no_path(mpp->alias, 0);
-			else
-				dm_queue_if_no_path(mpp->alias, 1);
-		}
+		set_no_path_retry(mpp);
 	}
 	vector_foreach_slot (vecs->pathvec, pp, i) {
 		select_checkfn(pp);
==========================================================================

Regards,
Kiyoshi Ueda
