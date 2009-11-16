From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 1/2] dm-mpath: Add mutex to synchronize adding
	and flushing work
Date: Sun, 15 Nov 2009 23:38:24 -0800
Message-ID: <20091116073824.4070.71075.stgit@localhost.localdomain>
References: <20091116073819.4070.40173.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091116073819.4070.40173.stgit@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Add a mutex to allow possible creators of new work to synchronize with
flushing work queues.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm-mpath.c |   59 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6ffffad..b102959 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -93,6 +93,8 @@ struct multipath {
 	 * can resubmit bios on error.
 	 */
 	mempool_t *mpio_pool;
+
+	struct mutex work_mutex;
 };
 
 /*
@@ -198,6 +200,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
+		mutex_init(&m->work_mutex);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
@@ -1268,7 +1271,11 @@ static void multipath_presuspend(struct dm_target *ti)
 
 static void multipath_postsuspend(struct dm_target *ti)
 {
+	struct multipath *m = (struct multipath *) ti->private;
+
+	mutex_lock(&m->work_mutex);
 	flush_multipath_work();
+	mutex_unlock(&m->work_mutex);
 }
 
 /*
@@ -1407,51 +1414,61 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 
 static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 {
-	int r;
+	int r = -EINVAL;
 	struct dm_dev *dev;
 	struct multipath *m = (struct multipath *) ti->private;
 	action_fn action;
 
+	mutex_lock(&m->work_mutex);
+
 	if (argc == 1) {
-		if (!strnicmp(argv[0], MESG_STR("queue_if_no_path")))
-			return queue_if_no_path(m, 1, 0);
-		else if (!strnicmp(argv[0], MESG_STR("fail_if_no_path")))
-			return queue_if_no_path(m, 0, 0);
+		if (!strnicmp(argv[0], MESG_STR("queue_if_no_path"))) {
+			r = queue_if_no_path(m, 1, 0);
+			goto out;
+		} else if (!strnicmp(argv[0], MESG_STR("fail_if_no_path"))) {
+			r = queue_if_no_path(m, 0, 0);
+			goto out;
+		}
 	}
 
-	if (argc != 2)
-		goto error;
+	if (argc != 2) {
+		DMWARN("Unrecognised multipath message received.");
+		goto out;
+	}
 
-	if (!strnicmp(argv[0], MESG_STR("disable_group")))
-		return bypass_pg_num(m, argv[1], 1);
-	else if (!strnicmp(argv[0], MESG_STR("enable_group")))
-		return bypass_pg_num(m, argv[1], 0);
-	else if (!strnicmp(argv[0], MESG_STR("switch_group")))
-		return switch_pg_num(m, argv[1]);
-	else if (!strnicmp(argv[0], MESG_STR("reinstate_path")))
+	if (!strnicmp(argv[0], MESG_STR("disable_group"))) {
+		r = bypass_pg_num(m, argv[1], 1);
+		goto out;
+	} else if (!strnicmp(argv[0], MESG_STR("enable_group"))) {
+		r = bypass_pg_num(m, argv[1], 0);
+		goto out;
+	} else if (!strnicmp(argv[0], MESG_STR("switch_group"))) {
+		r = switch_pg_num(m, argv[1]);
+		goto out;
+	} else if (!strnicmp(argv[0], MESG_STR("reinstate_path")))
 		action = reinstate_path;
 	else if (!strnicmp(argv[0], MESG_STR("fail_path")))
 		action = fail_path;
-	else
-		goto error;
+	else {
+		DMWARN("Unrecognised multipath message received.");
+		goto out;
+	}
 
 	r = dm_get_device(ti, argv[1], ti->begin, ti->len,
 			  dm_table_get_mode(ti->table), &dev);
 	if (r) {
 		DMWARN("message: error getting device %s",
 		       argv[1]);
-		return -EINVAL;
+		goto out;
 	}
 
 	r = action_dev(m, dev, action);
 
 	dm_put_device(ti, dev);
 
+out:
+	mutex_unlock(&m->work_mutex);
 	return r;
-
-error:
-	DMWARN("Unrecognised multipath message received.");
-	return -EINVAL;
 }
 
 static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
