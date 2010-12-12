From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] dm-snap: convert to
	alloc[_ordered]_workqueue()
Date: Sun, 12 Dec 2010 20:10:52 +0100
Message-ID: <1292181055-25696-4-git-send-email-tj@kernel.org>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1292181055-25696-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

Convert all create[_singlethread]_work() users to the new
alloc[_ordered]_workqueue().  This conversion is mechanical and
doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-crypt.c           |    4 ++--
 drivers/md/dm-delay.c           |    2 +-
 drivers/md/dm-kcopyd.c          |    2 +-
 drivers/md/dm-mpath.c           |    5 +++--
 drivers/md/dm-raid1.c           |    2 +-
 drivers/md/dm-snap-persistent.c |    2 +-
 drivers/md/dm.c                 |    2 +-
 7 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d5b0e4c..0ff5ae2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1252,13 +1252,13 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	cc->start = tmpll;
 
 	ret = -ENOMEM;
-	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
+	cc->io_queue = alloc_ordered_workqueue("kcryptd_io", WQ_MEM_RECLAIM);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
-	cc->crypt_queue = create_singlethread_workqueue("kcryptd");
+	cc->crypt_queue = alloc_ordered_workqueue("kcryptd", WQ_MEM_RECLAIM);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index baa1191..f18375d 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -352,7 +352,7 @@ static int __init dm_delay_init(void)
 {
 	int r = -ENOMEM;
 
-	kdelayd_wq = create_workqueue("kdelayd");
+	kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
 	if (!kdelayd_wq) {
 		DMERR("Couldn't start kdelayd");
 		goto bad_queue;
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index d8587ba..6d641e8 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -624,7 +624,7 @@ int dm_kcopyd_client_create(unsigned int nr_pages,
 		goto bad_slab;
 
 	INIT_WORK(&kc->kcopyd_work, do_work);
-	kc->kcopyd_wq = create_singlethread_workqueue("kcopyd");
+	kc->kcopyd_wq = alloc_ordered_workqueue("kcopyd", WQ_MEM_RECLAIM);
 	if (!kc->kcopyd_wq)
 		goto bad_workqueue;
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..5765eb7 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1687,7 +1687,7 @@ static int __init dm_multipath_init(void)
 		return -EINVAL;
 	}
 
-	kmultipathd = create_workqueue("kmpathd");
+	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM, 0);
 	if (!kmultipathd) {
 		DMERR("failed to create workqueue kmpathd");
 		dm_unregister_target(&multipath_target);
@@ -1701,7 +1701,8 @@ static int __init dm_multipath_init(void)
 	 * old workqueue would also create a bottleneck in the
 	 * path of the storage hardware device activation.
 	 */
-	kmpath_handlerd = create_singlethread_workqueue("kmpath_handlerd");
+	kmpath_handlerd = alloc_ordered_workqueue("kmpath_handlerd",
+						  WQ_MEM_RECLAIM);
 	if (!kmpath_handlerd) {
 		DMERR("failed to create workqueue kmpath_handlerd");
 		destroy_workqueue(kmultipathd);
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 19a59b0..dbd6af8 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1077,7 +1077,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->split_io = dm_rh_get_region_size(ms->rh);
 	ti->num_flush_requests = 1;
 
-	ms->kmirrord_wq = create_singlethread_workqueue("kmirrord");
+	ms->kmirrord_wq = alloc_ordered_workqueue("kmirrord", WQ_MEM_RECLAIM);
 	if (!ms->kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		r = -ENOMEM;
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 2129cdb..d3021a6 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -818,7 +818,7 @@ static int persistent_ctr(struct dm_exception_store *store,
 	atomic_set(&ps->pending_count, 0);
 	ps->callbacks = NULL;
 
-	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
+	ps->metadata_wq = alloc_ordered_workqueue("ksnaphd", WQ_MEM_RECLAIM);
 	if (!ps->metadata_wq) {
 		kfree(ps);
 		DMERR("couldn't start header metadata update thread");
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..064b2dc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1884,7 +1884,7 @@ static struct mapped_device *alloc_dev(int minor)
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
-	md->wq = create_singlethread_workqueue("kdmflush");
+	md->wq = alloc_ordered_workqueue("kdmflush", WQ_MEM_RECLAIM);
 	if (!md->wq)
 		goto bad_thread;
 
-- 
1.7.1
