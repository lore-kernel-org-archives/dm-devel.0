From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] multipathd: Whitespace cleanup
Date: Tue, 24 Jul 2007 08:40:28 +0200
Message-ID: <20070725111705.62DB773175@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: dm-devel.ids

multipathd/main.c has quite some 'interesting' whitespace usage.
Better stick to established coding rules.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/multipathd/main.c b/multipathd/main.c
index 5f98c33..b1620b5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -146,7 +146,7 @@ static void
 sync_map_state(struct multipath *mpp)
 {
 	struct pathgroup *pgp;
-        struct path *pp;
+	struct path *pp;
 	unsigned int i, j;
 
 	vector_foreach_slot (mpp->pg, pgp, i){
@@ -172,7 +172,7 @@ sync_maps_state(vector mpvec)
 	unsigned int i;
 	struct multipath *mpp;
 
-	vector_foreach_slot (mpvec, mpp, i) 
+	vector_foreach_slot (mpvec, mpp, i)
 		sync_map_state(mpp);
 }
 
@@ -226,10 +226,10 @@ ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 		return 1;
 
 	alias = dm_mapname(major, minor);
-		
+
 	if (!alias)
 		return 1;
-	
+
 	map_present = dm_map_present(alias);
 
 	if (map_present && dm_type(alias, DEFAULT_TARGET) <= 0) {
@@ -240,7 +240,7 @@ ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 	mpp = find_mp_by_alias(vecs->mpvec, alias);
 
 	if (mpp) {
-                /*
+		/*
 		 * Not really an error -- we generate our own uevent
 		 * if we create a multipath mapped device as a result
 		 * of uev_add_path
@@ -265,7 +265,7 @@ ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 		r = coalesce_paths(vecs, NULL, refwwid);
 		dm_lib_release();
 	}
-	
+
 	if (!r)
 		condlog(3, "%s: devmap %s added", alias, dev->kernel);
 	else
@@ -319,7 +319,7 @@ uev_umount_map (struct sysfs_device * dev, struct vectors * vecs)
 
 	return 0;
 }
-	
+
 static int
 uev_add_path (struct sysfs_device * dev, struct vectors * vecs)
 {
@@ -374,7 +374,7 @@ ev_add_path (char * devname, struct vectors * vecs)
 			vector_del_slot(vecs->pathvec, i);
 		free_path(pp);
 		return 2;
-	}	
+	}
 	mpp = pp->mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
 rescan:
 	if (mpp) {
@@ -406,8 +406,8 @@ rescan:
 		condlog(0, "%s: failed in domap for addition of new "
 			"path %s", mpp->alias, devname);
 		/*
- 		 * deal with asynchronous uevents :((
- 		 */
+		 * deal with asynchronous uevents :((
+		 */
 		if (mpp->action == ACT_RELOAD) {
 			condlog(0, "%s: uev_add_path sleep", mpp->alias);
 			sleep(1);
@@ -473,9 +473,9 @@ ev_remove_path (char * devname, struct vectors * vecs)
 			vector rpvec = vector_alloc();
 
 			/*
-	 	 	 * transform the mp->pg vector of vectors of paths
-	 	 	 * into a mp->params string to feed the device-mapper
-	 	 	 */
+			 * transform the mp->pg vector of vectors of paths
+			 * into a mp->params string to feed the device-mapper
+			 */
 			update_mpp_paths(mpp, vecs->pathvec);
 			if ((i = find_slot(mpp->paths, (void *)pp)) != -1)
 				vector_del_slot(mpp->paths, i);
@@ -501,8 +501,8 @@ ev_remove_path (char * devname, struct vectors * vecs)
 					goto out;
 				}
 				/*
-	 	 	 	 * reload the map
-	 	 	 	 */
+				 * reload the map
+				 */
 				mpp->action = ACT_RELOAD;
 				if (domap(mpp) <= 0) {
 					condlog(0, "%s: failed in domap for "
@@ -580,7 +580,7 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 {
 	struct vectors * vecs;
 	int r;
-	
+
 	*reply = NULL;
 	*len = 0;
 	vecs = (struct vectors *)trigger_data;
@@ -622,7 +622,7 @@ uev_discard(char * devpath)
 	return 0;
 }
 
-int 
+int
 uev_trigger (struct uevent * uev, void * trigger_data)
 {
 	int r = 0;
@@ -636,7 +636,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 
 	sysdev = sysfs_device_get(uev->devpath);
 	if(!sysdev)
-		return 0;	
+		return 0;
 
 	lock(vecs->lock);
 
@@ -660,12 +660,12 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 		}
 		goto out;
 	}
-	
+
 	/*
 	 * path add/remove event
 	 */
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-		 	   sysdev->kernel) > 0)
+			   sysdev->kernel) > 0)
 		goto out;
 
 	if (!strncmp(uev->action, "add", 3)) {
@@ -687,7 +687,7 @@ ueventloop (void * ap)
 {
 	if (uevent_listen(&uev_trigger, ap))
 		fprintf(stderr, "error starting uevent listener");
-		
+
 	return NULL;
 }
 
@@ -782,12 +782,12 @@ enable_group(struct path * pp)
 	 *
 	 * we can safely return here, because upon map reload, all
 	 * PG will be enabled.
- 	 */
+	 */
 	if (!pp->mpp->pg || !pp->pgindex)
 		return;
 
 	pgp = VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);
-	
+
 	if (pgp->status == PGSTATE_DISABLED) {
 		condlog(2, "%s: enable group #%i", pp->mpp->alias, pp->pgindex);
 		dm_enablegroup(pp->mpp->alias, pp->pgindex);
@@ -883,7 +883,7 @@ checkerloop (void *ap)
 			 * in case we exit abnormaly from here
 			 */
 			pp->tick = conf->checkint;
-			
+
 			if (!checker_selected(&pp->checker)) {
 				pathinfo(pp, conf->hwtable, DI_SYSFS);
 				select_checker(pp);
@@ -899,7 +899,7 @@ checkerloop (void *ap)
 			checker_set_async(&pp->checker);
 
 			newstate = checker_check(&pp->checker);
-			
+
 			if (newstate < 0) {
 				condlog(2, "%s: unusable path", pp->dev);
 				pathinfo(pp, conf->hwtable, 0);
@@ -927,7 +927,7 @@ checkerloop (void *ap)
 				if (newstate == PATH_DOWN ||
 				    newstate == PATH_SHAKY ||
 				    update_multipath_strings(pp->mpp,
-					    		     vecs->pathvec)) {
+							     vecs->pathvec)) {
 					/*
 					 * proactively fail path in the DM
 					 */
@@ -1018,7 +1018,7 @@ checkerloop (void *ap)
 			mpvec_garbage_collector(vecs);
 			count = MAPGCINT;
 		}
-		
+
 		lock_cleanup_pop(vecs->lock);
 		sleep(1);
 	}
@@ -1035,10 +1035,10 @@ configure (struct vectors * vecs, int start_waiters)
 
 	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc()))
 		return 1;
-	
+
 	if (!vecs->mpvec && !(vecs->mpvec = vector_alloc()))
 		return 1;
-	
+
 	if (!(mpvec = vector_alloc()))
 		return 1;
 
@@ -1052,7 +1052,7 @@ configure (struct vectors * vecs, int start_waiters)
 			vector_del_slot(vecs->pathvec, i);
 			free_path(pp);
 			i--;
-		}	
+		}
 		else
 			pp->checkint = conf->checkint;
 	}
@@ -1141,7 +1141,7 @@ init_vecs (void)
 	if (!vecs)
 		return NULL;
 
-	vecs->lock = 
+	vecs->lock =
 		(pthread_mutex_t *)MALLOC(sizeof(pthread_mutex_t));
 
 	if (!vecs->lock)
@@ -1215,15 +1215,15 @@ signal_init(void)
 static void
 setscheduler (void)
 {
-        int res;
+	int res;
 	static struct sched_param sched_param = {
 		.sched_priority = 99
 	};
 
-        res = sched_setscheduler (0, SCHED_RR, &sched_param);
+	res = sched_setscheduler (0, SCHED_RR, &sched_param);
 
-        if (res == -1)
-                condlog(LOG_WARNING, "Could not set SCHED_RR at priority 99");
+	if (res == -1)
+		condlog(LOG_WARNING, "Could not set SCHED_RR at priority 99");
 	return;
 }
 
@@ -1240,7 +1240,7 @@ set_oom_adj (int val)
 	fprintf(fp, "%i", val);
 	fclose(fp);
 }
-	
+
 static int
 child (void * param)
 {
@@ -1302,7 +1302,7 @@ child (void * param)
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, 64 * 1024);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
-	
+
 	pthread_create(&check_thr, &attr, checkerloop, vecs);
 	pthread_create(&uevent_thr, &attr, ueventloop, vecs);
 	pthread_create(&uxlsnr_thr, &attr, uxlsnrloop, vecs);
@@ -1338,7 +1338,7 @@ child (void * param)
 	conf = NULL;
 
 	condlog(2, "--------shut down-------");
-	
+
 	if (logsink)
 		log_thread_stop();
 
@@ -1406,7 +1406,7 @@ main (int argc, char *argv[])
 	extern int optind;
 	int arg;
 	int err;
-	
+
 	logsink = 1;
 	dm_init();
 
@@ -1449,7 +1449,7 @@ main (int argc, char *argv[])
 		err = 0;
 	else
 		err = daemonize();
-	
+
 	if (err < 0)
 		/* error */
 		exit(1);

--------------070905020208000808010408--
