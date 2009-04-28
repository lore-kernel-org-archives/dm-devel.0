From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Handle multipath paths in a path group properly
	during pg_init
Date: Tue, 28 Apr 2009 12:31:57 -0700
Message-ID: <1240947117.13184.8.camel@chandra-ubuntu>
References: <1238436452.5858.2.camel@chandra-ubuntu>
	<1240872495.22154.7.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1240872495.22154.7.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alasdair G Kergon <agk@redhat.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

Fixed a problem while reinstating passive paths. 
----------
There is a problem which was caused due to the architectural change made
when we moved from dm hardware handler to SCSI hardware handler.

  In dm, handler was called to do a pg_init for a path group, and there
  was no state maintained in hardware handler code for each path.

  In SCSI dh, "state" is maintanined per path, as we wanted to fail I/O
  early on that path if it is not the active path.

  All of the hardware handlers, do have a state now, and they are set to
   active and (some form of) inactive. All of them have prep_fn(), which use
  this "state" to fail the I/O without it ever being sent to the device.

So, in effect when dm-multipath calls scsi_dh_activate(), activate is
sent to only one path and the "state" of that path is changed appropriately
to "active" while other paths in the same path group are never changed
as they never got an "activate".

In order make sure all the paths in a path group gets their state set
properly when a pg_init happens, we need to call scsi_dh_activate() on
all paths in a path group.

Doing this at the hardware handler layer is not a good option as we
want the multipath layer to define the relationship between path and path
groups and not the hardware handler.

Attached patch sends an "activate" on each path in a path group when a
path group is switched. It also sends an activate when a path is reinstated.

Patch is applied and tested on 2.6.30-rc3.

----------

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
Index: linux-2.6.30-rc3/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.30-rc3.orig/drivers/md/dm-mpath.c
+++ linux-2.6.30-rc3/drivers/md/dm-mpath.c
@@ -35,6 +35,7 @@ struct pgpath {
 
 	struct dm_path path;
 	struct work_struct deactivate_path;
+	struct work_struct activate_path;
 };
 
 #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, path)
@@ -64,8 +65,6 @@ struct multipath {
 	spinlock_t lock;
 
 	const char *hw_handler_name;
-	struct work_struct activate_path;
-	struct pgpath *pgpath_to_activate;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
@@ -128,6 +127,7 @@ static struct pgpath *alloc_pgpath(void)
 	if (pgpath) {
 		pgpath->is_active = 1;
 		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
+		INIT_WORK(&pgpath->activate_path, activate_path);
 	}
 
 	return pgpath;
@@ -160,7 +160,6 @@ static struct priority_group *alloc_prio
 
 static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
 {
-	unsigned long flags;
 	struct pgpath *pgpath, *tmp;
 	struct multipath *m = ti->private;
 
@@ -169,10 +168,6 @@ static void free_pgpaths(struct list_hea
 		if (m->hw_handler_name)
 			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
 		dm_put_device(ti, pgpath->path.dev);
-		spin_lock_irqsave(&m->lock, flags);
-		if (m->pgpath_to_activate == pgpath)
-			m->pgpath_to_activate = NULL;
-		spin_unlock_irqrestore(&m->lock, flags);
 		free_pgpath(pgpath);
 	}
 }
@@ -202,7 +197,6 @@ static struct multipath *alloc_multipath
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
-		INIT_WORK(&m->activate_path, activate_path);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
@@ -427,8 +421,8 @@ static void process_queued_ios(struct wo
 {
 	struct multipath *m =
 		container_of(work, struct multipath, process_queued_ios);
-	struct pgpath *pgpath = NULL;
-	unsigned init_required = 0, must_queue = 1;
+	struct pgpath *pgpath = NULL, *tmp;
+	unsigned must_queue = 1;
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
@@ -446,19 +440,15 @@ static void process_queued_ios(struct wo
 		must_queue = 0;
 
 	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
-		m->pgpath_to_activate = pgpath;
 		m->pg_init_count++;
 		m->pg_init_required = 0;
-		m->pg_init_in_progress = 1;
-		init_required = 1;
+		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
+			queue_work(kmpath_handlerd, &tmp->activate_path);
+			m->pg_init_in_progress++;
+		}
 	}
-
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
-
-	if (init_required)
-		queue_work(kmpath_handlerd, &m->activate_path);
-
 	if (!must_queue)
 		dispatch_queued_ios(m);
 }
@@ -924,9 +914,13 @@ static int reinstate_path(struct pgpath 
 
 	pgpath->is_active = 1;
 
-	m->current_pgpath = NULL;
-	if (!m->nr_valid_paths++ && m->queue_size)
+	if (!m->nr_valid_paths++ && m->queue_size) {
+		m->current_pgpath = NULL;
 		queue_work(kmultipathd, &m->process_queued_ios);
+	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
+ 		m->pg_init_in_progress++;
+		queue_work(kmpath_handlerd, &pgpath->activate_path);
+	}
 
 	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti,
 		      pgpath->path.dev->name, m->nr_valid_paths);
@@ -1102,35 +1096,30 @@ static void pg_init_done(struct dm_path 
 
 	spin_lock_irqsave(&m->lock, flags);
 	if (errors) {
-		DMERR("Could not failover device. Error %d.", errors);
-		m->current_pgpath = NULL;
-		m->current_pg = NULL;
+		if (pgpath == m->current_pgpath) {
+			DMERR("Could not failover device. Error %d.", errors);
+			m->current_pgpath = NULL;
+			m->current_pg = NULL;
+		}
 	} else if (!m->pg_init_required) {
 		m->queue_io = 0;
 		pg->bypassed = 0;
 	}
 
-	m->pg_init_in_progress = 0;
-	queue_work(kmultipathd, &m->process_queued_ios);
+	m->pg_init_in_progress--;
+	if (!m->pg_init_in_progress)
+		queue_work(kmultipathd, &m->process_queued_ios);
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
 static void activate_path(struct work_struct *work)
 {
 	int ret;
-	struct multipath *m =
-		container_of(work, struct multipath, activate_path);
-	struct dm_path *path;
-	unsigned long flags;
+	struct pgpath *pgpath =
+		container_of(work, struct pgpath, activate_path);
 
-	spin_lock_irqsave(&m->lock, flags);
-	path = &m->pgpath_to_activate->path;
-	m->pgpath_to_activate = NULL;
-	spin_unlock_irqrestore(&m->lock, flags);
-	if (!path)
-		return;
-	ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev));
-	pg_init_done(path, ret);
+	ret = scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev));
+	pg_init_done(&pgpath->path, ret);
 }
 
 /*
