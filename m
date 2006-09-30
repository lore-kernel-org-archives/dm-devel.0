From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/4] dm-userspace: use kernel threads for
	do_map_bio
Date: Sat, 30 Sep 2006 19:44:32 +0900
Message-ID: <200609301044.k8UAic8Y013343@r-dd.iij4u.or.jp>
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

No need to care about I/O reordering, so kernel threads can performs
do_map_bio (that might provide the better performance).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-userspace-chardev.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-userspace-chardev.c b/drivers/md/dm-userspace-chardev.c
index 869e359..1853d0d 100644
--- a/drivers/md/dm-userspace-chardev.c
+++ b/drivers/md/dm-userspace-chardev.c
@@ -358,17 +358,8 @@ static void do_map_bio(struct dmu_device
 
 	memcpy(&req->response, msg, sizeof(req->response));
 
-#if 0
-	/* I think it would be nice to farm this out to a worker
-	 * thread, so that userspace does not have to do all the work,
-	 * but I wonder about the correctness of possibly reordering
-	 * requests to a single block
-	 */
 	INIT_WORK(&req->task, map_worker, req);
 	schedule_work(&req->task);
-#else
-	map_worker(req);
-#endif
 }
 
 static void do_map_done(struct dmu_device *dev, uint64_t id_of_op, int fail)
-- 
1.4.1
