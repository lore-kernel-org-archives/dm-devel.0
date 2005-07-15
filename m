From: "goggin, edward" <egoggin@emc.com>
Subject: map removal and multipathd
Date: Fri, 15 Jul 2005 11:08:56 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB75@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

I've found the removal of a multipath map (or all of them for that matter)
to be troublesome
for multipathd, particularly its waitevent pthreads.  The dm driver in the
kernel was not waking
up the dm event waiters so they stayed in the kernel where each one held a
reference on the
mapped device and its table.  This held reference prevented the multipathd
from receiving either
a uevent or a hotplug event for the removal of the multipath block device --
since it is not removed
in this case.

--- drivers/md/dm-ioctl.c.orig	2005-07-14 13:33:56.000000000 -0500
+++ drivers/md/dm-ioctl.c	2005-07-14 22:01:04.000000000 -0500
@@ -226,10 +226,22 @@
 
 static void __hash_remove(struct hash_cell *hc)
 {
+	struct dm_table *table;
+
 	/* remove from the dev hash */
 	list_del(&hc->uuid_list);
 	list_del(&hc->name_list);
 	unregister_with_devfs(hc);
+
+	/*
+	 * Wakeup any dm event waiters.
+	 */
+	table = dm_get_table(hc->md);
+	if (table) {
+		dm_table_event(table);
+		dm_table_put(table);
+	}
+
 	dm_put(hc->md);
 	if (hc->new_map)
 		dm_table_put(hc->new_map);

With dm-ioctl.c patched to wake up waiting dm event threads when a mapped
device is removed,
multipathd has issues.  Fixed 3 bugs

	(1) update_multipath wasn't dealing with an error from
setup_multipath.  Setup_multipath
	error path involved the call chain
update_multipath_strings->update_multipath_table->
	dm_get_map->dm_task_run->ioctl.  Since the mpp structure for a block
device could be
	deallocated in setup_multipath, the multipathd could SIGSEGV when it
referenced the
	deallocated mpp memory in update_multipath.

	(2) The waitevent pthread's dm task structure memory was getting
destroyed twice if
	it ever broke out of its waitevent loop due to the call to
waiteventloop returning < 0.  I
	set wp->dmt to null after waiteventloop called dm_task_destroy to
prevent free_waiter
	from doing likewise.

	(3) setup_multipath was not removing the mpp ptr from the
allpaths->mpvec vector if it
	deallocated the mpp structure memory due to the error occurrence
mentioned in (1).
	This omission would cause multipathd mpvec_garbage_collector to
SIGSEGV.
	Fixed uev_add_map since it had the same issue.

diff --git a/multipathd/main.c b/multipathd/main.c
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -207,6 +207,7 @@ static int
 setup_multipath (struct paths * allpaths, struct multipath * mpp)
 {
 	char * wwid;
+	int i;
 
 	wwid = get_mpe_wwid(mpp->alias);
 
@@ -227,6 +228,12 @@ setup_multipath (struct paths * allpaths
 
 	return 0;
 out:
+	/*
+	 * purge the multipath vector
+	 */
+	if ((i = find_slot(allpaths->mpvec, (void *)mpp)) != -1)
+		vector_del_slot(allpaths->mpvec, i);
+
 	free_multipath(mpp, KEEP_PATHS);
 	condlog(0, "failed to setup multipath");
 	return 1;
@@ -275,7 +282,8 @@ update_multipath (struct paths *allpaths
 	free_pgvec(mpp->pg, KEEP_PATHS);
 	mpp->pg = NULL;
 
-	setup_multipath(allpaths, mpp);
+	if (setup_multipath(allpaths, mpp))
+		goto out; /* mpp freed in setup_multipath */
 
 	/*
 	 * compare checkers states with DM states
@@ -311,7 +319,8 @@ free_waiter (void * data)
 {
 	struct event_thread * wp = (struct event_thread *)data;
 
-	dm_task_destroy(wp->dmt);
+	if (wp->dmt)
+		dm_task_destroy(wp->dmt);
 	FREE(wp);
 }
 
@@ -344,6 +353,7 @@ waiteventloop (struct event_thread * wai
 	dm_task_run(waiter->dmt);
 	pthread_testcancel();
 	dm_task_destroy(waiter->dmt);
+	waiter->dmt = NULL;
 
 	waiter->event_nr++;
 
@@ -509,7 +519,7 @@ remove_maps (struct paths * allpaths)
 int
 uev_add_map (char * devname, struct paths * allpaths)
 {
-	int major, minor;
+	int major, minor, i;
 	char dev_t[BLK_DEV_SIZE];
 	char * alias;
 	struct multipath * mpp;
@@ -570,6 +580,12 @@ uev_add_map (char * devname, struct path
 	return 0;
 out:
 	condlog(2, "add %s devmap failed", mpp->alias);
+	/*
+	 * purge the multipath vector
+	 */
+	if ((i = find_slot(allpaths->mpvec, (void *)mpp)) != -1)
+		vector_del_slot(allpaths->mpvec, i);
+
 	free_multipath(mpp, KEEP_PATHS);
 	return 1;
 }
@@ -874,7 +890,8 @@ get_dm_mpvec (struct paths * allpaths)
 		return 1;
 
 	vector_foreach_slot (allpaths->mpvec, mpp, i) {
-		setup_multipath(allpaths, mpp);
+		if (setup_multipath(allpaths, mpp))
+			return 1;
 		mpp->minor = dm_get_minor(mpp->alias);
 		start_waiter_thread(mpp, allpaths);
 	}
