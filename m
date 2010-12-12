From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] dm: use non-reentrant workqueues if
	equivalent
Date: Sun, 12 Dec 2010 20:10:54 +0100
Message-ID: <1292181055-25696-6-git-send-email-tj@kernel.org>
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

kmirrord_wq, kcopyd_work and md->wq are created per dm instance and
serves only single work item from the dm instance, so non-reentrant
workqueues would provide the same ordering guarantees as ordered ones
while allowing CPU affinity and use of the workqueues for other
purposes.  Switch them to non-reentrant workqueues.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-kcopyd.c |    3 ++-
 drivers/md/dm-raid1.c  |    3 ++-
 drivers/md/dm.c        |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 6d641e8..20c1a11 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -624,7 +624,8 @@ int dm_kcopyd_client_create(unsigned int nr_pages,
 		goto bad_slab;
 
 	INIT_WORK(&kc->kcopyd_work, do_work);
-	kc->kcopyd_wq = alloc_ordered_workqueue("kcopyd", WQ_MEM_RECLAIM);
+	kc->kcopyd_wq = alloc_workqueue("kcopyd",
+					WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
 	if (!kc->kcopyd_wq)
 		goto bad_workqueue;
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 5139091..32bc404 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1077,7 +1077,8 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->split_io = dm_rh_get_region_size(ms->rh);
 	ti->num_flush_requests = 1;
 
-	ms->kmirrord_wq = alloc_ordered_workqueue("kmirrord", WQ_MEM_RECLAIM);
+	ms->kmirrord_wq = alloc_workqueue("kmirrord",
+					  WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
 	if (!ms->kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		r = -ENOMEM;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 064b2dc..854409d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1884,7 +1884,8 @@ static struct mapped_device *alloc_dev(int minor)
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
-	md->wq = alloc_ordered_workqueue("kdmflush", WQ_MEM_RECLAIM);
+	md->wq = alloc_workqueue("kdmflush",
+				 WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
 	if (!md->wq)
 		goto bad_thread;
 
-- 
1.7.1
