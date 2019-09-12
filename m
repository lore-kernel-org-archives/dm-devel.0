From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/5] dm-bufio: introduce a global queue
Date: Thu, 12 Sep 2019 10:44:46 +0200
Message-ID: <20190912084547.836289000@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-bufio-global-queue.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martijn Coenen <maco@android.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dariofreni@google.com, jiyong@google.com, dm-devel@redhat.com, maco@google.com, Mikulas Patocka <mpatocka@redhat.com>, kernel-team@android.com
List-Id: dm-devel.ids

Rename param_spinlock to global_spinlock and introduce a global queue of
all used buffers. The queue will be used in the following patches.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2019-09-10 16:54:13.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2019-09-11 19:40:27.000000000 +0200
@@ -133,6 +133,7 @@ enum data_mode {
 struct dm_buffer {
 	struct rb_node node;
 	struct list_head lru_list;
+	struct list_head global_list;
 	sector_t block;
 	void *data;
 	unsigned char data_mode;		/* DATA_MODE_* */
@@ -193,7 +194,9 @@ static unsigned long dm_bufio_cache_size
  */
 static unsigned long dm_bufio_cache_size_latch;
 
-static DEFINE_SPINLOCK(param_spinlock);
+static DEFINE_SPINLOCK(global_spinlock);
+
+static LIST_HEAD(global_queue);
 
 /*
  * Buffers are freed after this timeout
@@ -302,7 +305,7 @@ static void adjust_total_allocated(struc
 	if (unlink)
 		diff = -diff;
 
-	spin_lock(&param_spinlock);
+	spin_lock(&global_spinlock);
 
 	*class_ptr[data_mode] += diff;
 
@@ -311,7 +314,13 @@ static void adjust_total_allocated(struc
 	if (dm_bufio_current_allocated > dm_bufio_peak_allocated)
 		dm_bufio_peak_allocated = dm_bufio_current_allocated;
 
-	spin_unlock(&param_spinlock);
+	if (!unlink) {
+		list_add(&b->global_list, &global_queue);
+	} else {
+		list_del(&b->global_list);
+	}
+
+	spin_unlock(&global_spinlock);
 }
 
 /*
