From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/4] dm-userspace: fix DMU_FLAG_SYNC
Date: Sat, 30 Sep 2006 19:44:35 +0900
Message-ID: <200609301044.k8UAifNn013346@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
Cc: danms@us.ibm.com
List-Id: dm-devel.ids

Seems that DMU_FLAG_SYNC flag is always set. Is this intentional?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-userspace-chardev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-userspace-chardev.c b/drivers/md/dm-userspace-chardev.c
index 1853d0d..ee55ca8 100644
--- a/drivers/md/dm-userspace-chardev.c
+++ b/drivers/md/dm-userspace-chardev.c
@@ -304,7 +304,7 @@ static void map_worker(void *data)
 	struct target_device *src_dev, *dst_dev;
 	int need_copy = dmu_get_flag(&msg->flags, DMU_FLAG_COPY_FIRST);
 
-	if (dmu_get_flag(&msg->flags, DMU_FLAG_COPY_FIRST)) {
+	if (need_copy) {
 		src_dev = find_target(dev, MKDEV(msg->src_maj, msg->src_min));
 		if (!src_dev) {
 			DMERR("Failed to find src device %i:%i\n",
@@ -327,7 +327,7 @@ static void map_worker(void *data)
 		msg->offset;
 	req->bio->bi_bdev = dst_dev->bdev;
 
-	dmu_set_flag(&req->flags, DMU_FLAG_SYNC);
+	dmu_cpy_flag(&req->flags, msg->flags, DMU_FLAG_SYNC);
 
 	if (!maybe_queue_dependent_request(req, need_copy)) {
 		if (need_copy)
-- 
1.4.1
