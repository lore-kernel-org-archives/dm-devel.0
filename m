From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Re: DM configuration
Date: Tue, 11 Oct 2005 20:17:45 -0400 (EDT)
Message-ID: <20051011.201745.115903307.k-ueda@ct.jp.nec.com>
References: <20051005134505.GB6195@free.fr>
	<20051006.131418.71083514.k-ueda@ct.jp.nec.com>
	<1128718450.18441.21.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1128718450.18441.21.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

Thank you for your comments.

On Fri, 07 Oct 2005 22:54:09 +0200, Christophe Varoqui <christophe.varoqui@free.fr> wrote:
> > This patch adds 'no_path_retry' option to multipathd.
> > 
> >    o no_path_retry = "fail" is equal to 'fail_if_no_path'.
> >      (i.e. I/O to the no-path map will immediately fail.)
> > 
> >    o no_path_retry = "queue" is equal to 'queue_if_no_path'.
> >      (i.e. I/O to the no-path map will be queued until any path comes up.)
> > 
> >    o If no_path_retry = <n> where n is positive number,
> >      then multipathd will set queue_if_no_path to the map,
> >      and if the all paths are down, multipathd will turn the feature
> >      off to fail_if_no_path after the checker tries <n> times for each
> >      paths in the map.
> > 
> > Multipathd re-writes queue_if_no_path feature parameter in the map,
> > if this option is specified.  But by default, this patch doesn't
> > change current multipathd behaviour.
> > So this patch don't break any existing configuration.
> > 
> Interesting. Is this patched reviewed (besides me) and agreed on ?
> Does the "no_path_retry" option name raise consensus ?

The patch has gotten internal review only.
I hope to get further review from people in dm-devel including
the naming of the option.
 
> > # Multipathd has "features" option, with which user can directly specify
> > # a feature parameter of the table (e.g. features="1 queue_if_no_path").
> > # However, no_path_retry could be considered as smarter replacement for it.
> > 
> I have no objection phasing out the "features" option, in favor of a
> more "deterministic" solution. If you care to submit a patch.

OK.
I extended the scope of the "no_path_retry" option to the multipath
command so that we can phase out the "features" option, because
the multipath command also sees the "features" option.

And fixed some bugs of the patch.
  o Initialization issue of retry_tick.
  o Missing status update of retry_tick in waiteventloop and reconfigure.

The new patch is below.
This patch doesn't change current behavior of multipath command by default.
The "no_path_option" option overrides the "features" option.


diff -rup git/libmultipath/config.h retry/libmultipath/config.h
--- git/libmultipath/config.h	2005-09-28 12:32:02.000000000 -0400
+++ retry/libmultipath/config.h	2005-10-10 10:41:27.000000000 -0400
@@ -33,6 +33,7 @@ struct mpentry {
 	int pgpolicy;
 	int pgfailback;
 	int rr_weight;
+	int no_path_retry;
 
 	char * wwid;
 	char * selector;
@@ -56,6 +57,7 @@ struct config {
 	int pgfailback;
 	int remove;
 	int rr_weight;
+	int no_path_retry;
 
 	char * dev;
 	char * udev_dir;
diff -rup git/libmultipath/devmapper.c retry/libmultipath/devmapper.c
--- git/libmultipath/devmapper.c	2005-10-04 12:20:03.000000000 -0400
+++ retry/libmultipath/devmapper.c	2005-10-10 12:04:24.000000000 -0400
@@ -490,6 +490,41 @@ out:
 	return r;
 }
 
+int
+dm_queue_if_no_path(char *mapname, int enable)
+{
+	int r = 1;
+	struct dm_task *dmt;
+	char *str;
+
+	if (enable)
+		str = "queue_if_no_path\n";
+	else
+		str = "fail_if_no_path\n";
+
+	if (!(dmt = dm_task_create(DM_DEVICE_TARGET_MSG)))
+		return 1;
+
+	if (!dm_task_set_name(dmt, mapname))
+		goto out;
+
+	if (!dm_task_set_sector(dmt, 0))
+		goto out;
+
+	if (!dm_task_set_message(dmt, str))
+		goto out;
+
+	dm_task_no_open_count(dmt);
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	r = 0;
+out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
 static int
 dm_groupmsg (char * msg, char * mapname, int index)
 {
diff -rup git/libmultipath/devmapper.h retry/libmultipath/devmapper.h
--- git/libmultipath/devmapper.h	2005-09-30 14:13:49.000000000 -0400
+++ retry/libmultipath/devmapper.h	2005-10-05 18:39:58.000000000 -0400
@@ -10,6 +10,7 @@ int dm_flush_map (char *, char *);
 int dm_flush_maps (char *);
 int dm_fail_path(char * mapname, char * path);
 int dm_reinstate(char * mapname, char * path);
+int dm_queue_if_no_path(char *mapname, int enable);
 int dm_switchgroup(char * mapname, int index);
 int dm_enablegroup(char * mapname, int index);
 int dm_disablegroup(char * mapname, int index);
diff -rup git/libmultipath/dict.c retry/libmultipath/dict.c
--- git/libmultipath/dict.c	2005-09-28 12:32:02.000000000 -0400
+++ retry/libmultipath/dict.c	2005-10-10 10:52:18.000000000 -0400
@@ -171,6 +171,26 @@ default_failback_handler(vector strvec)
 	return 0;
 }
 
+static int
+def_no_path_retry_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (!strncmp(buff, "fail", 4) || !strncmp(buff, "0", 1))
+		conf->no_path_retry = NO_PATH_RETRY_FAIL;
+	else if (!strncmp(buff, "queue", 5))
+		conf->no_path_retry = NO_PATH_RETRY_QUEUE;
+	else if ((conf->no_path_retry = atoi(buff)) < 1)
+		conf->no_path_retry = NO_PATH_RETRY_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -579,6 +599,30 @@ mp_weight_handler(vector strvec)
 	return 0;
 }
 
+static int
+mp_no_path_retry_handler(vector strvec)
+{
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+	char *buff;
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (!strncmp(buff, "fail", 4) || !strncmp(buff, "0", 1))
+		mpe->no_path_retry = NO_PATH_RETRY_FAIL;
+	else if (!strncmp(buff, "queue", 5))
+		mpe->no_path_retry = NO_PATH_RETRY_QUEUE;
+	else if ((mpe->no_path_retry = atoi(buff)) < 1)
+		mpe->no_path_retry = NO_PATH_RETRY_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 vector
 init_keywords(void)
 {
@@ -596,6 +640,7 @@ init_keywords(void)
 	install_keyword("failback", &default_failback_handler);
 	install_keyword("rr_min_io", &def_minio_handler);
 	install_keyword("rr_weight", &def_weight_handler);
+	install_keyword("no_path_retry", &def_no_path_retry_handler);
 	
 	install_keyword_root("devnode_blacklist", &blacklist_handler);
 	install_keyword("devnode", &ble_handler);
@@ -626,6 +671,7 @@ init_keywords(void)
 	install_keyword("path_selector", &mp_selector_handler);
 	install_keyword("failback", &mp_failback_handler);
 	install_keyword("rr_weight", &mp_weight_handler);
+	install_keyword("no_path_retry", &mp_no_path_retry_handler);
 	install_sublevel_end();
 
 	return keywords;
diff -rup git/libmultipath/propsel.c retry/libmultipath/propsel.c
--- git/libmultipath/propsel.c	2005-09-28 12:32:02.000000000 -0400
+++ retry/libmultipath/propsel.c	2005-10-10 10:52:42.000000000 -0400
@@ -201,3 +201,22 @@ select_getprio (struct path * pp)
 	return 0;
 }
 
+extern int
+select_no_path_retry(struct multipath *mp)
+{
+	if (mp->mpe && mp->mpe->no_path_retry != NO_PATH_RETRY_UNDEF) {
+		mp->no_path_retry = mp->mpe->no_path_retry;
+		condlog(3, "no_path_retry = %i (controler setting)",
+			mp->no_path_retry);
+		return 0;
+	}
+	if (conf->no_path_retry != NO_PATH_RETRY_UNDEF) {
+		mp->no_path_retry = conf->no_path_retry;
+		condlog(3, "no_path_retry = %i (config file default)",
+			mp->no_path_retry);
+		return 0;
+	}
+	mp->no_path_retry = NO_PATH_RETRY_UNDEF;
+	condlog(3, "no_path_retry = NONE (internal default)");
+	return 0;
+}
diff -rup git/libmultipath/propsel.h retry/libmultipath/propsel.h
--- git/libmultipath/propsel.h	2005-08-29 09:41:06.000000000 -0400
+++ retry/libmultipath/propsel.h	2005-10-05 18:46:21.000000000 -0400
@@ -8,4 +8,4 @@ int select_hwhandler (struct multipath *
 int select_checkfn(struct path *pp);
 int select_getuid (struct path * pp);
 int select_getprio (struct path * pp);
-
+int select_no_path_retry(struct multipath *mp);
diff -rup git/libmultipath/structs.h retry/libmultipath/structs.h
--- git/libmultipath/structs.h	2005-10-04 12:20:03.000000000 -0400
+++ retry/libmultipath/structs.h	2005-10-05 18:51:01.000000000 -0400
@@ -14,6 +14,10 @@
 #define SCSI_PRODUCT_SIZE	17
 #define SCSI_REV_SIZE		5
 
+#define NO_PATH_RETRY_UNDEF	0
+#define NO_PATH_RETRY_FAIL	-1
+#define NO_PATH_RETRY_QUEUE	-2
+
 enum free_path_switch {
 	KEEP_PATHS,
 	FREE_PATHS
@@ -115,6 +119,9 @@ struct multipath {
 	int pgfailback;
 	int failback_tick;
 	int rr_weight;
+	int nr_active;     /* current available(= not known as failed) paths */
+	int no_path_retry; /* number of retries after all paths are down */
+	int retry_tick;    /* remaining times for retries */
 	unsigned long long size;
 	vector paths;
 	vector pg;
diff -rup git/multipath/main.c retry/multipath/main.c
--- git/multipath/main.c	2005-10-04 12:20:03.000000000 -0400
+++ retry/multipath/main.c	2005-10-11 19:09:33.000000000 -0400
@@ -393,6 +393,7 @@ setup_map (struct multipath * mpp)
 	select_features(mpp);
 	select_hwhandler(mpp);
 	select_rr_weight(mpp);
+	select_no_path_retry(mpp);
 
 	/*
 	 * apply selected grouping policy to valid paths
@@ -577,6 +578,12 @@ reinstate_paths (struct multipath * mpp)
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
@@ -592,7 +599,7 @@ domap (struct multipath * mpp)
 
 	switch (mpp->action) {
 	case ACT_NOTHING:
-		return 0;
+		return 2;
 
 	case ACT_SWITCHPG:
 		dm_switchgroup(mpp->alias, mpp->nextpg);
@@ -602,7 +609,7 @@ domap (struct multipath * mpp)
 		 * retry.
 		 */
 		reinstate_paths(mpp);
-		return 0;
+		return 2;
 
 	case ACT_CREATE:
 		r = dm_addmap(DM_DEVICE_CREATE, mpp->alias, DEFAULT_TARGET,
@@ -726,7 +733,12 @@ coalesce_paths (vector curmp, vector pat
 
 		condlog(3, "action set to %i", mpp->action);
 
-		domap(mpp);
+		if (domap(mpp) && mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
+			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
+				dm_queue_if_no_path(mpp->alias, 0);
+			else
+				dm_queue_if_no_path(mpp->alias, 1);
+		}
 		drop_multipath(curmp, mpp->wwid, KEEP_PATHS);
 		free_multipath(mpp, KEEP_PATHS);
 	}
diff -rup git/multipath.conf.annotated retry/multipath.conf.annotated
--- git/multipath.conf.annotated	2005-09-28 12:32:02.000000000 -0400
+++ retry/multipath.conf.annotated	2005-10-10 10:55:58.000000000 -0400
@@ -99,6 +99,17 @@
 #	# default : immediate
 #	#
 #	failback	manual
+#
+#	#
+#	# name    : no_path_retry
+#	# scope   : multipath & multipathd
+#	# desc    : tell the number of retries until disable queueing, or
+#	#           "fail" means immediate failure (no queueing),
+#	#           "queue" means never stop queueing
+#	# values  : queue|fail|n (>0)
+#	# default : (null)
+#	#
+#	#no_path_retry	queue
 #}
 #	
 ##
@@ -177,6 +188,17 @@
 #		# default : immediate
 #		#
 #		failback		manual
+#
+#		#
+#		# name    : no_path_retry
+#		# scope   : multipath & multipathd
+#		# desc    : tell the number of retries until disable queueing, or
+#		#           "fail" means immediate failure (no queueing),
+#		#           "queue" means never stop queueing
+#		# values  : queue|fail|n (>0)
+#		# default : (null)
+#		#
+#		#no_path_retry	queue
 #	}
 #	multipath {
 #		wwid	1DEC_____321816758474
diff -rup git/multipathd/main.c retry/multipathd/main.c
--- git/multipathd/main.c	2005-09-28 12:32:02.000000000 -0400
+++ retry/multipathd/main.c	2005-10-11 19:39:39.000000000 -0400
@@ -209,6 +209,85 @@ set_multipath_wwid (struct multipath * m
 }
 
 static int
+pathcount (struct multipath *mpp, int state)
+{
+	struct pathgroup *pgp;
+	struct path *pp;
+	int i, j;
+	int count = 0;
+
+	vector_foreach_slot (mpp->pg, pgp, i)
+		vector_foreach_slot (pgp->paths, pp, j)
+			if (pp->state == state)
+				count++;
+	return count;
+}
+
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
+static int
 setup_multipath (struct vectors * vecs, struct multipath * mpp)
 {
 	int i;
@@ -222,6 +301,7 @@ setup_multipath (struct vectors * vecs, 
 
 	set_paths_owner(vecs, mpp);
 	select_pgfailback(mpp);
+	set_no_path_retry(mpp);
 
 	return 0;
 out:
@@ -308,6 +388,7 @@ update_multipath (struct vectors *vecs, 
 			if (pp->state != PATH_DOWN) {
 				condlog(2, "%s: mark as failed", pp->dev_t);
 				pp->state = PATH_DOWN;
+				update_queue_mode_del_path(pp->mpp);
 
 				/*
 				 * if opportune,
@@ -690,6 +771,10 @@ uev_remove_path (char * devname, struct 
 		condlog(3, "%s: not in pathvec");
 		return 1;
 	}
+
+	if (pp->mpp && pp->state == PATH_UP)
+		update_queue_mode_del_path(pp->mpp);
+
 	condlog(2, "remove %s path checker", devname);
 	i = find_slot(vecs->pathvec, (void *)pp);
 	vector_del_slot(vecs->pathvec, i);
@@ -817,6 +902,7 @@ reconfigure (struct vectors * vecs)
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
 		mpp->mpe = find_mpe(mpp->wwid);
 		set_paths_owner(vecs, mpp);
+		set_no_path_retry(mpp);
 	}
 	vector_foreach_slot (vecs->pathvec, pp, i) {
 		select_checkfn(pp);
@@ -983,6 +1069,7 @@ fail_path (struct path * pp)
 		 pp->dev_t, pp->mpp->alias);
 
 	dm_fail_path(pp->mpp->alias, pp->dev_t);
+	update_queue_mode_del_path(pp->mpp);
 }
 
 /*
@@ -991,11 +1078,14 @@ fail_path (struct path * pp)
 static void
 reinstate_path (struct path * pp)
 {
-	if (pp->mpp) {
-		if (dm_reinstate(pp->mpp->alias, pp->dev_t))
-			condlog(0, "%s: reinstate failed", pp->dev_t);
-		else
-			condlog(2, "%s: reinstated", pp->dev_t);
+	if (!pp->mpp)
+		return;
+
+	if (dm_reinstate(pp->mpp->alias, pp->dev_t))
+		condlog(0, "%s: reinstate failed", pp->dev_t);
+	else {
+		condlog(2, "%s: reinstated", pp->dev_t);
+		update_queue_mode_add_path(pp->mpp);
 	}
 }
 
@@ -1056,6 +1146,23 @@ defered_failback_tick (vector mpvec)
 	}
 }
 
+static void
+retry_count_tick(vector mpvec)
+{
+	struct multipath *mpp;
+	int i;
+
+	vector_foreach_slot (mpvec, mpp, i) {
+		if (mpp->retry_tick) {
+			condlog(4, "%s: Retrying.. No active path", mpp->alias);
+			if(--mpp->retry_tick == 0) {
+				dm_queue_if_no_path(mpp->alias, 0);
+				condlog(2, "%s: Disable queueing", mpp->alias);
+			}
+		}
+	}
+}
+
 static void *
 checkerloop (void *ap)
 {
@@ -1201,6 +1308,7 @@ checkerloop (void *ap)
 			}
 		}
 		defered_failback_tick(vecs->mpvec);
+		retry_count_tick(vecs->mpvec);
 
 		if (count)
 			count--;

Regards,
Kiyoshi Ueda
