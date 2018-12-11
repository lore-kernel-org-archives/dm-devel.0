From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/1] libmultipath: dm_is_mpath cleanup
Date: Tue, 11 Dec 2018 15:23:04 -0600
Message-ID: <1544563384-9721-2-git-send-email-bmarzins@redhat.com>
References: <1544563384-9721-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1544563384-9721-1-git-send-email-bmarzins@redhat.com>
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

Add condlog() message in dm_is_mpath() fails and change the
dm_is_mpath() call in watch_dmevents() to check the return value with
the same syntax as all the other callers.

Fixes: 9050cd5a "libmultipath: fix false removes in dmevents polling code"
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 21 ++++++++++++---------
 multipathd/dmevents.c    |  4 +++-
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0e98923..3294bd4 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -709,41 +709,44 @@ int dm_is_mpath(const char *name)
 	const char *uuid;
 
 	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
-		return -1;
+		goto out;
 
 	if (!dm_task_set_name(dmt, name))
-		goto out;
+		goto out_task;
 
 	dm_task_no_open_count(dmt);
 
 	if (!dm_task_run(dmt))
-		goto out;
+		goto out_task;
 
 	if (!dm_task_get_info(dmt, &info))
-		goto out;
+		goto out_task;
 
 	r = 0;
 
 	if (!info.exists)
-		goto out;
+		goto out_task;
 
 	uuid = dm_task_get_uuid(dmt);
 
 	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN) != 0)
-		goto out;
+		goto out_task;
 
 	/* Fetch 1st target */
 	if (dm_get_next_target(dmt, NULL, &start, &length, &target_type,
 			       &params) != NULL)
 		/* multiple targets */
-		goto out;
+		goto out_task;
 
 	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
-		goto out;
+		goto out_task;
 
 	r = 1;
-out:
+out_task:
 	dm_task_destroy(dmt);
+out:
+	if (r < 0)
+		condlog(2, "%s: dm command failed in %s", name, __FUNCTION__);
 	return r;
 }
 
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index aae7a09..0034892 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -206,7 +206,9 @@ int watch_dmevents(char *name)
 	struct dev_event *dev_evt, *old_dev_evt;
 	int i;
 
-	if (!dm_is_mpath(name)) {
+	/* We know that this is a multipath device, so only fail if
+	 * device-mapper tells us that we're wrong */
+	if (dm_is_mpath(name) == 0) {
 		condlog(0, "%s: not a multipath device. can't watch events",
 			name);
 		return -1;
-- 
2.7.4
