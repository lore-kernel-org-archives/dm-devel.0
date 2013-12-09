From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-multipath: Accept failed paths for multipath
	maps
Date: Mon,  9 Dec 2013 10:15:32 +0100
Message-ID: <1386580532-103264-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Sean Stewart <sean.stewart@netapp.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The multipath kernel module is rejecting any map with an invalid
device. However, as the multipathd is processing the events serially
it will try to push a map with invalid devices if more than one
device failed at the same time.
So we can as well accept those maps and make sure to mark the
paths as down.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 74 ++++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/dm-mpath.h |  1 +
 drivers/md/dm-table.c |  7 +++--
 3 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6eb9dc9..e4a992e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -166,7 +166,7 @@ static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
 
 	list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
 		list_del(&pgpath->list);
-		if (m->hw_handler_name)
+		if (m->hw_handler_name && pgpath->path.dev)
 			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
 		dm_put_device(ti, pgpath->path.dev);
 		free_pgpath(pgpath);
@@ -303,6 +303,11 @@ static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
 
 	m->current_pgpath = path_to_pgpath(path);
 
+	if (!m->current_pgpath->path.dev) {
+		m->current_pgpath = NULL;
+		return -ENODEV;
+	}
+
 	if (m->current_pg != pg)
 		__switch_pg(m, m->current_pgpath);
 
@@ -573,6 +578,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 {
 	int r;
 	struct pgpath *p;
+	const char *path;
 	struct multipath *m = ti->private;
 	struct request_queue *q = NULL;
 	const char *attached_handler_name;
@@ -587,17 +593,40 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
-	r = dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
+	path = dm_shift_arg(as);
+	r = dm_get_device(ti, path, dm_table_get_mode(ti->table),
 			  &p->path.dev);
 	if (r) {
-		ti->error = "error getting device";
-		goto bad;
+		unsigned major, minor;
+
+		/* Try to add a failed device */
+		if (r == -ENXIO && sscanf(path, "%u:%u", &major, &minor) == 2) {
+			dev_t dev;
+
+			/* Extract the major/minor numbers */
+			dev = MKDEV(major, minor);
+			if (MAJOR(dev) != major || MINOR(dev) != minor) {
+				/* Nice try, didn't work */
+				DMWARN("Invalid device path %s", path);
+				ti->error = "error converting devnum";
+				goto bad;
+			}
+			DMWARN("adding disabled device %d:%d", major, minor);
+			p->path.dev = NULL;
+			format_dev_t(p->path.pdev, dev);
+			p->is_active = 0;
+		} else {
+			ti->error = "error getting device";
+			goto bad;
+		}
+	} else {
+		memcpy(p->path.pdev, p->path.dev->name, 16);
 	}
 
-	if (m->retain_attached_hw_handler || m->hw_handler_name)
+	if (p->path.dev)
 		q = bdev_get_queue(p->path.dev->bdev);
 
-	if (m->retain_attached_hw_handler) {
+	if (q && (m->retain_attached_hw_handler || m->hw_handler_name)) {
 		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
 			/*
@@ -616,7 +645,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		}
 	}
 
-	if (m->hw_handler_name) {
+	if (q && m->hw_handler_name) {
 		/*
 		 * Increments scsi_dh reference, even when using an
 		 * already-attached handler.
@@ -655,6 +684,11 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
+	if (!p->is_active) {
+		ps->type->fail_path(ps, &p->path);
+		p->fail_count++;
+		m->nr_valid_paths--;
+	}
 	return p;
 
  bad:
@@ -1005,7 +1039,7 @@ static int fail_path(struct pgpath *pgpath)
 	if (!pgpath->is_active)
 		goto out;
 
-	DMWARN("Failing path %s.", pgpath->path.dev->name);
+	DMWARN("Failing path %s.", pgpath->path.pdev);
 
 	pgpath->pg->ps.type->fail_path(&pgpath->pg->ps, &pgpath->path);
 	pgpath->is_active = 0;
@@ -1017,7 +1051,7 @@ static int fail_path(struct pgpath *pgpath)
 		m->current_pgpath = NULL;
 
 	dm_path_uevent(DM_UEVENT_PATH_FAILED, m->ti,
-		      pgpath->path.dev->name, m->nr_valid_paths);
+		       pgpath->path.pdev, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
 
@@ -1041,6 +1075,12 @@ static int reinstate_path(struct pgpath *pgpath)
 	if (pgpath->is_active)
 		goto out;
 
+	if (!pgpath->path.dev) {
+		DMWARN("Cannot reinstate disabled path %s", pgpath->path.pdev);
+		r = -ENODEV;
+		goto out;
+	}
+
 	if (!pgpath->pg->ps.type->reinstate_path) {
 		DMWARN("Reinstate path not supported by path selector %s",
 		       pgpath->pg->ps.type->name);
@@ -1063,7 +1103,7 @@ static int reinstate_path(struct pgpath *pgpath)
 	}
 
 	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti,
-		      pgpath->path.dev->name, m->nr_valid_paths);
+		       pgpath->path.pdev, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
 
@@ -1083,6 +1123,9 @@ static int action_dev(struct multipath *m, struct dm_dev *dev,
 	struct pgpath *pgpath;
 	struct priority_group *pg;
 
+	if (!dev)
+		return 0;
+
 	list_for_each_entry(pg, &m->priority_groups, list) {
 		list_for_each_entry(pgpath, &pg->pgpaths, list) {
 			if (pgpath->path.dev == dev)
@@ -1272,8 +1315,9 @@ static void activate_path(struct work_struct *work)
 	struct pgpath *pgpath =
 		container_of(work, struct pgpath, activate_path.work);
 
-	scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
-				pg_init_done, pgpath);
+	if (pgpath->path.dev && pgpath->is_active)
+		scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
+				 pg_init_done, pgpath);
 }
 
 static int noretry_error(int error)
@@ -1488,7 +1532,7 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			       pg->ps.type->info_args);
 
 			list_for_each_entry(p, &pg->pgpaths, list) {
-				DMEMIT("%s %s %u ", p->path.dev->name,
+				DMEMIT("%s %s %u ", p->path.pdev,
 				       p->is_active ? "A" : "F",
 				       p->fail_count);
 				if (pg->ps.type->status)
@@ -1514,7 +1558,7 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			       pg->ps.type->table_args);
 
 			list_for_each_entry(p, &pg->pgpaths, list) {
-				DMEMIT("%s ", p->path.dev->name);
+				DMEMIT("%s ", p->path.pdev);
 				if (pg->ps.type->status)
 					sz += pg->ps.type->status(&pg->ps,
 					      &p->path, type, result + sz,
@@ -1611,7 +1655,7 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 
 	pgpath = m->current_pgpath;
 
-	if (pgpath) {
+	if (pgpath && pgpath->path.dev) {
 		bdev = pgpath->path.dev->bdev;
 		mode = pgpath->path.dev->mode;
 	}
diff --git a/drivers/md/dm-mpath.h b/drivers/md/dm-mpath.h
index e230f71..f97388d 100644
--- a/drivers/md/dm-mpath.h
+++ b/drivers/md/dm-mpath.h
@@ -12,6 +12,7 @@
 struct dm_dev;
 
 struct dm_path {
+	char pdev[16];		/* Requested physical device */
 	struct dm_dev *dev;	/* Read-only */
 	void *pscontext;	/* For path-selector use */
 };
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 465f08c..253c908 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -518,9 +518,12 @@ EXPORT_SYMBOL_GPL(dm_set_device_limits);
  */
 void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
-	struct dm_dev_internal *dd = container_of(d, struct dm_dev_internal,
-						  dm_dev);
+	struct dm_dev_internal *dd;
+
+	if (!d)
+		return;
 
+	dd = container_of(d, struct dm_dev_internal, dm_dev);
 	if (atomic_dec_and_test(&dd->count)) {
 		close_dev(dd, ti->table->md);
 		list_del(&dd->list);
-- 
1.7.12.4
