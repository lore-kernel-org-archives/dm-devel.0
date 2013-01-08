From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/42] Remove newline from condlog()
Date: Tue,  8 Jan 2013 14:53:40 +0100
Message-ID: <1357653259-62650-3-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

condlog() already adds a newline to each message.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c   |    8 ++++----
 libmultipath/dmparser.c    |    4 ++--
 libmultipath/structs_vec.c |    2 +-
 libmultipath/sysfs.c       |    2 +-
 libmultipath/uevent.c      |    4 ++--
 libmultipath/util.c        |   12 ++++++------
 multipath/main.c           |    2 +-
 multipathd/main.c          |   27 ++++++++++++++-------------
 8 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5132399..051ecb2 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -284,7 +284,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 	if (use_uuid && strlen(mpp->wwid) > 0){
 		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(mpp->wwid) + 1);
 		if (!prefixed_uuid) {
-			condlog(0, "cannot create prefixed uuid : %s\n",
+			condlog(0, "cannot create prefixed uuid : %s",
 				strerror(errno));
 			goto addout;
 		}
@@ -302,7 +302,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 	if (mpp->attribute_flags & (1 << ATTR_GID) &&
 	    !dm_task_set_gid(dmt, mpp->gid))
 		goto freeout;
-	condlog(4, "%s: addmap [0 %llu %s %s]\n", mpp->alias, mpp->size,
+	condlog(4, "%s: addmap [0 %llu %s %s]", mpp->alias, mpp->size,
 		target, params);
 
 	dm_task_no_open_count(dmt);
@@ -931,7 +931,7 @@ dm_get_name(char *uuid)
 
 	prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
 	if (!prefixed_uuid) {
-		condlog(0, "cannot create prefixed uuid : %s\n",
+		condlog(0, "cannot create prefixed uuid : %s",
 			strerror(errno));
 		goto freeout;
 	}
@@ -1366,7 +1366,7 @@ int dm_reassign(const char *mapname)
 	int r = 0, i;
 
 	if (dm_dev_t(mapname, &dev_t[0], 32)) {
-		condlog(3, "%s: failed to get device number\n", mapname);
+		condlog(3, "%s: failed to get device number", mapname);
 		return 1;
 	}
 
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 5848ec5..b3c52fc 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -100,7 +100,7 @@ assemble_map (struct multipath * mp, char * params, int len)
 		shift = snprintf(p, freechar, " %s %i 1", mp->selector,
 				 VECTOR_SIZE(pgp->paths));
 		if (shift >= freechar) {
-			condlog(0, "%s: params too small\n", mp->alias);
+			condlog(0, "%s: params too small", mp->alias);
 			return 1;
 		}
 		p += shift;
@@ -113,7 +113,7 @@ assemble_map (struct multipath * mp, char * params, int len)
 			    && pp->priority > 0)
 				tmp_minio = minio * pp->priority;
 			if (!strlen(pp->dev_t) ) {
-				condlog(0, "dev_t not set for '%s'\n", pp->dev);
+				condlog(0, "dev_t not set for '%s'", pp->dev);
 				return 1;
 			}
 			shift = snprintf(p, freechar, " %s %d",
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6e70d63..f998708 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -483,7 +483,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 	mpp = find_mp_by_alias(vecs->mpvec, mapname);
 
 	if (!mpp) {
-		condlog(3, "%s: multipath map not found\n", mapname);
+		condlog(3, "%s: multipath map not found", mapname);
 		return 2;
 	}
 
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 8e986e8..9c554dd 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -77,7 +77,7 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 		condlog(4, "write to %s failed: %s", devpath, strerror(errno));
 		size = 0;
 	} else if (size < value_len) {
-		condlog(4, "tried to write %ld to %s. Wrote %ld\n",
+		condlog(4, "tried to write %ld to %s. Wrote %ld",
 			(long)value_len, devpath, (long)size);
 		size = 0;
 	}
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 0b7eb7a..b74fb08 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -422,10 +422,10 @@ int uevent_listen(void)
 	err = udev_monitor_filter_add_match_subsystem_devtype(monitor, "block",
 							      NULL);
 	if (err)
-		condlog(2, "failed to create filter : %s\n", strerror(-err));
+		condlog(2, "failed to create filter : %s", strerror(-err));
 	err = udev_monitor_enable_receiving(monitor);
 	if (err) {
-		condlog(2, "failed to enable receiving : %s\n", strerror(-err));
+		condlog(2, "failed to enable receiving : %s", strerror(-err));
 		goto out;
 	}
 	while (1) {
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 70735e6..7cdfd28 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -86,7 +86,7 @@ get_word (char * sentence, char ** word)
 	*word = MALLOC(len + 1);
 
 	if (!*word) {
-		condlog(0, "get_word : oom\n");
+		condlog(0, "get_word : oom");
 		return 0;
 	}
 	strncpy(*word, sentence, len);
@@ -178,7 +178,7 @@ devt2devname (char *devname, int devname_len, char *devt)
 				char *p = strrchr(dev, '/');
 
 				if (!p) {
-					condlog(0, "No sysfs entry for %s\n",
+					condlog(0, "No sysfs entry for %s",
 						block_path);
 					return 1;
 				}
@@ -208,7 +208,7 @@ devt2devname (char *devname, int devname_len, char *devt)
 		if ((major == tmpmaj) && (minor == tmpmin)) {
 			if (snprintf(block_path, sizeof(block_path),
 				     "/sys/block/%s", dev) >= sizeof(block_path)) {
-				condlog(0, "device name %s is too long\n", dev);
+				condlog(0, "device name %s is too long", dev);
 				fclose(fd);
 				return 1;
 			}
@@ -218,17 +218,17 @@ devt2devname (char *devname, int devname_len, char *devt)
 	fclose(fd);
 skip_proc:
 	if (strncmp(block_path,"/sys/block", 10)) {
-		condlog(3, "No device found for %u:%u\n", major, minor);
+		condlog(3, "No device found for %u:%u", major, minor);
 		return 1;
 	}
 
 	if (stat(block_path, &statbuf) < 0) {
-		condlog(0, "No sysfs entry for %s\n", block_path);
+		condlog(0, "No sysfs entry for %s", block_path);
 		return 1;
 	}
 
 	if (S_ISDIR(statbuf.st_mode) == 0) {
-		condlog(0, "sysfs entry %s is not a directory\n", block_path);
+		condlog(0, "sysfs entry %s is not a directory", block_path);
 		return 1;
 	}
 	basenamecpy((const char *)block_path, devname, devname_len);
diff --git a/multipath/main.c b/multipath/main.c
index 92e852b..6208995 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -535,7 +535,7 @@ main (int argc, char *argv[])
 		fd_limit.rlim_cur = conf->max_fds;
 		fd_limit.rlim_max = conf->max_fds;
 		if (setrlimit(RLIMIT_NOFILE, &fd_limit) < 0)
-			condlog(0, "can't set open fds limit to %d : %s\n",
+			condlog(0, "can't set open fds limit to %d : %s",
 				conf->max_fds, strerror(errno));
 	}
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 64c1a0c..84574b2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1154,7 +1154,7 @@ check_path (struct vectors * vecs, struct path * pp)
 	 * Synchronize with kernel state
 	 */
 	if (update_multipath_strings(pp->mpp, vecs->pathvec)) {
-		condlog(1, "%s: Could not synchronize with kernel state\n",
+		condlog(1, "%s: Could not synchronize with kernel state",
 			pp->dev);
 		pp->dmstate = PSTATE_UNDEF;
 	}
@@ -1611,7 +1611,7 @@ child (void * param)
 		struct rlimit fd_limit;
 
 		if (getrlimit(RLIMIT_NOFILE, &fd_limit) < 0) {
-			condlog(0, "can't get open fds limit: %s\n",
+			condlog(0, "can't get open fds limit: %s",
 				strerror(errno));
 			fd_limit.rlim_cur = 0;
 			fd_limit.rlim_max = 0;
@@ -1622,11 +1622,11 @@ child (void * param)
 				fd_limit.rlim_max = conf->max_fds;
 			if (setrlimit(RLIMIT_NOFILE, &fd_limit) < 0) {
 				condlog(0, "can't set open fds limit to "
-					"%lu/%lu : %s\n",
+					"%lu/%lu : %s",
 					fd_limit.rlim_cur, fd_limit.rlim_max,
 					strerror(errno));
 			} else {
-				condlog(3, "set open fds limit to %lu/%lu\n",
+				condlog(3, "set open fds limit to %lu/%lu",
 					fd_limit.rlim_cur, fd_limit.rlim_max);
 			}
 		}
@@ -1713,7 +1713,8 @@ child (void * param)
 	/* Now all the waitevent threads will start rushing in. */
 	while (vecs->lock.depth > 0) {
 		sleep (1); /* This is weak. */
-		condlog(3,"Have %d wait event checkers threads to de-alloc, waiting..\n", vecs->lock.depth);
+		condlog(3, "Have %d wait event checkers threads to de-alloc,"
+			" waiting...", vecs->lock.depth);
 	}
 	pthread_mutex_destroy(vecs->lock.mutex);
 	FREE(vecs->lock.mutex);
@@ -1900,18 +1901,18 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 
 	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
 	if (!resp){
-		condlog(0,"%s Alloc failed for prin response \n", pp->dev);
+		condlog(0,"%s Alloc failed for prin response", pp->dev);
 		return NULL;
 	}
 
 	ret = prin_do_scsi_ioctl(pp->dev, MPATH_PRIN_RKEY_SA, resp, 0);
 	if (ret != MPATH_PR_SUCCESS )
 	{
-		condlog(0,"%s : pr in read keys service action failed. Error=%d\n", pp->dev, ret);
+		condlog(0,"%s : pr in read keys service action failed. Error=%d", pp->dev, ret);
 		goto out;
 	}
 
-	condlog(3, " event pr=%d addlen=%d\n",resp->prin_descriptor.prin_readkeys.prgeneration,
+	condlog(3, " event pr=%d addlen=%d",resp->prin_descriptor.prin_readkeys.prgeneration,
 			resp->prin_descriptor.prin_readkeys.additional_length );
 
 	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
@@ -1933,7 +1934,7 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 	isFound =0;
 	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
 	{
-		condlog(2, "PR IN READKEYS[%d]  reservation key:\n",i);
+		condlog(2, "PR IN READKEYS[%d]  reservation key:",i);
 		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , -1);
 		if (!memcmp(mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
 		{
@@ -1945,7 +1946,7 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 	if (!isFound)
 	{
 		condlog(0, "%s: Either device not registered or ", pp->dev);
-		condlog(0, "host is not authorised for registration. Skip path\n");
+		condlog(0, "host is not authorised for registration. Skip path");
 		ret = MPATH_PR_OTHER;
 		goto out;
 	}
@@ -1959,12 +1960,12 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 	}
 	param->num_transportid = 0;
 
-	condlog(3, "device %s:%s \n", pp->dev, pp->mpp->wwid);
+	condlog(3, "device %s:%s", pp->dev, pp->mpp->wwid);
 
 	ret = prout_do_scsi_ioctl(pp->dev, MPATH_PROUT_REG_IGN_SA, 0, 0, param, 0);
 	if (ret != MPATH_PR_SUCCESS )
 	{
-		condlog(0,"%s: Reservation registration failed. Error: %d\n", pp->dev, ret);
+		condlog(0,"%s: Reservation registration failed. Error: %d", pp->dev, ret);
 	}
 	mpp->prflag = 1;
 
@@ -1991,7 +1992,7 @@ int mpath_pr_event_handle(struct path *pp)
 
 	rc = pthread_create(&thread, NULL , mpath_pr_event_handler_fn, pp);
 	if (rc) {
-		condlog(0, "%s: ERROR; return code from pthread_create() is %d\n", pp->dev, rc);
+		condlog(0, "%s: ERROR; return code from pthread_create() is %d", pp->dev, rc);
 		return -1;
 	}
 	pthread_attr_destroy(&attr);
-- 
1.7.4.2
