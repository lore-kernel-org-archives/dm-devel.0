From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/2] libmultipath: fix false removes in dmevents
	polling code
Date: Wed, 28 Nov 2018 00:13:24 -0600
Message-ID: <1543385604-25453-2-git-send-email-bmarzins@redhat.com>
References: <1543385604-25453-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1543385604-25453-1-git-send-email-bmarzins@redhat.com>
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

dm_is_mpath() would return 0 if either a device was not a multipath
device or if the libdevmapper command failed. Because dm_is_mpath()
didn't distinguish between these situations, dm_get_events() could
assume that a device was not really a multipath device, when in fact it
was, and the libdevmapper command simply failed. This would cause the
dmevents polling waiter to stop monitoring the device.

In reality, the call to dm_is_mpath() isn't necessary, because
dm_get_events() will already verify that the device name is on the list
of devices to wait for. However, if there are a large number of
non-multipath devices on the system, ignoring them can be useful.  Thus,
if dm_is_mpath() successfully runs the libdevmapper command and verifies
that the device is not a multipath device, dm_get_events() should skip
it. But if the libdevmapper command fails, dm_get_events() should still
check the device list, to see if the device should be monitored.

This commit makes dm_is_mpath() return -1 for situations where
the libdevmapper command failed, and makes dm_get_events() only ignore
the device on a return of 0.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c |  4 ++--
 libmultipath/devmapper.c        | 26 ++++++++++++++++++++------
 multipath/main.c                |  2 +-
 multipathd/dmevents.c           |  4 +++-
 multipathd/main.c               |  2 +-
 5 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 2ffe56e..7e8a676 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -188,7 +188,7 @@ int mpath_persistent_reserve_in (int fd, int rq_servact,
 
 	condlog(3, "alias = %s", alias);
 	map_present = dm_map_present(alias);
-	if (map_present && !dm_is_mpath(alias)){
+	if (map_present && dm_is_mpath(alias) != 1){
 		condlog( 0, "%s: not a multipath device.", alias);
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out;
@@ -283,7 +283,7 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	condlog(3, "alias = %s", alias);
 	map_present = dm_map_present(alias);
 
-	if (map_present && !dm_is_mpath(alias)){
+	if (map_present && dm_is_mpath(alias) != 1){
 		condlog(3, "%s: not a multipath device.", alias);
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0433b49..0e98923 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -692,9 +692,15 @@ out:
 	return r;
 }
 
+/*
+ * returns:
+ * 1  : is multipath device
+ * 0  : is not multipath device
+ * -1 : error
+ */
 int dm_is_mpath(const char *name)
 {
-	int r = 0;
+	int r = -1;
 	struct dm_task *dmt;
 	struct dm_info info;
 	uint64_t start, length;
@@ -703,7 +709,7 @@ int dm_is_mpath(const char *name)
 	const char *uuid;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		return 0;
+		return -1;
 
 	if (!dm_task_set_name(dmt, name))
 		goto out;
@@ -713,7 +719,12 @@ int dm_is_mpath(const char *name)
 	if (!dm_task_run(dmt))
 		goto out;
 
-	if (!dm_task_get_info(dmt, &info) || !info.exists)
+	if (!dm_task_get_info(dmt, &info))
+		goto out;
+
+	r = 0;
+
+	if (!info.exists)
 		goto out;
 
 	uuid = dm_task_get_uuid(dmt);
@@ -722,7 +733,10 @@ int dm_is_mpath(const char *name)
 		goto out;
 
 	/* Fetch 1st target */
-	dm_get_next_target(dmt, NULL, &start, &length, &target_type, &params);
+	if (dm_get_next_target(dmt, NULL, &start, &length, &target_type,
+			       &params) != NULL)
+		/* multiple targets */
+		goto out;
 
 	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
 		goto out;
@@ -823,7 +837,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	unsigned long long mapsize;
 	char params[PARAMS_SIZE] = {0};
 
-	if (!dm_is_mpath(mapname))
+	if (dm_is_mpath(mapname) != 1)
 		return 0; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
@@ -1087,7 +1101,7 @@ dm_get_maps (vector mp)
 	}
 
 	do {
-		if (!dm_is_mpath(names->name))
+		if (dm_is_mpath(names->name) != 1)
 			goto next;
 
 		mpp = dm_get_multipath(names->name);
diff --git a/multipath/main.c b/multipath/main.c
index 05b7bf0..98fee1c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -319,7 +319,7 @@ static int check_usable_paths(struct config *conf,
 		goto out;
 	}
 
-	if (!dm_is_mpath(mapname)) {
+	if (dm_is_mpath(mapname) != 1) {
 		condlog(1, "%s is not a multipath map", devpath);
 		goto free;
 	}
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 31e64a7..aae7a09 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -168,7 +168,9 @@ static int dm_get_events(void)
 	while (names->dev) {
 		uint32_t event_nr;
 
-		if (!dm_is_mpath(names->name))
+		/* Don't delete device if dm_is_mpath() fails without
+		 * checking the device type */
+		if (dm_is_mpath(names->name) == 0)
 			goto next;
 
 		event_nr = dm_event_nr(names);
diff --git a/multipathd/main.c b/multipathd/main.c
index 2e5f9ed..c781115 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -699,7 +699,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 	int delayed_reconfig, reassign_maps;
 	struct config *conf;
 
-	if (!dm_is_mpath(alias)) {
+	if (dm_is_mpath(alias) != 1) {
 		condlog(4, "%s: not a multipath map", alias);
 		return 0;
 	}
-- 
2.7.4
