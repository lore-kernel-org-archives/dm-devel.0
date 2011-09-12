From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-block-manager: use spinlocks that don't
	disable interrupts
Date: Mon, 12 Sep 2011 07:24:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109120723560.15190@hs20-bc2-1.build.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-block-manager: use spinlocks that don't disable interrupts

This will never be called in an interrupt context, so we don't have to use
spinlocks that disable interrupts.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/persistent-data/dm-block-manager.c |   35 ++++++++++----------------
 1 file changed, 14 insertions(+), 21 deletions(-)

Index: linux-3.1-rc3-fast/drivers/md/persistent-data/dm-block-manager.c
===================================================================
--- linux-3.1-rc3-fast.orig/drivers/md/persistent-data/dm-block-manager.c	2011-09-12 13:17:44.000000000 +0200
+++ linux-3.1-rc3-fast/drivers/md/persistent-data/dm-block-manager.c	2011-09-12 13:20:01.000000000 +0200
@@ -200,19 +200,18 @@ static int bl_down_read(struct block_loc
 {
 	int r;
 	struct waiter w;
-	unsigned long flags;
 
-	spin_lock_irqsave(&lock->lock, flags);
+	spin_lock(&lock->lock);
 	r = __check_holder(lock);
 	if (r) {
-		spin_unlock_irqrestore(&lock->lock, flags);
+		spin_unlock(&lock->lock);
 		return r;
 	}
 
 	if (__available_for_read(lock)) {
 		lock->count++;
 		__add_holder(lock, current);
-		spin_unlock_irqrestore(&lock->lock, flags);
+		spin_unlock(&lock->lock);
 		return 0;
 	}
 
@@ -221,7 +220,7 @@ static int bl_down_read(struct block_loc
 	w.task = current;
 	w.wants_write = 0;
 	list_add_tail(&w.list, &lock->waiters);
-	spin_unlock_irqrestore(&lock->lock, flags);
+	spin_unlock(&lock->lock);
 
 	__wait(&w);
 	put_task_struct(current);
@@ -231,9 +230,8 @@ static int bl_down_read(struct block_loc
 static int bl_down_read_nonblock(struct block_lock *lock)
 {
 	int r;
-	unsigned long flags;
 
-	spin_lock_irqsave(&lock->lock, flags);
+	spin_lock(&lock->lock);
 	r = __check_holder(lock);
 	if (r)
 		goto out;
@@ -246,40 +244,37 @@ static int bl_down_read_nonblock(struct 
 		r = -EWOULDBLOCK;
 
 out:
-	spin_unlock_irqrestore(&lock->lock, flags);
+	spin_unlock(&lock->lock);
 	return r;
 }
 
 static void bl_up_read(struct block_lock *lock)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&lock->lock, flags);
+	spin_lock(&lock->lock);
 	BUG_ON(lock->count <= 0);
 	__del_holder(lock, current);
 	--lock->count;
 	if (!list_empty(&lock->waiters))
 		__wake_many(lock);
-	spin_unlock_irqrestore(&lock->lock, flags);
+	spin_unlock(&lock->lock);
 }
 
 static int bl_down_write(struct block_lock *lock)
 {
 	int r;
 	struct waiter w;
-	unsigned long flags;
 
-	spin_lock_irqsave(&lock->lock, flags);
+	spin_lock(&lock->lock);
 	r = __check_holder(lock);
 	if (r) {
-		spin_unlock_irqrestore(&lock->lock, flags);
+		spin_unlock(&lock->lock);
 		return r;
 	}
 
 	if (lock->count == 0 && list_empty(&lock->waiters)) {
 		lock->count = -1;
 		__add_holder(lock, current);
-		spin_unlock_irqrestore(&lock->lock, flags);
+		spin_unlock(&lock->lock);
 		return 0;
 	}
 
@@ -289,7 +284,7 @@ static int bl_down_write(struct block_lo
 
 	/* writers given priority, we know there's only one mutator in the system, so ignoring the ordering reversal */
 	list_add(&w.list, &lock->waiters);
-	spin_unlock_irqrestore(&lock->lock, flags);
+	spin_unlock(&lock->lock);
 
 	__wait(&w);
 	put_task_struct(current);
@@ -299,14 +294,12 @@ static int bl_down_write(struct block_lo
 
 static void bl_up_write(struct block_lock *lock)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&lock->lock, flags);
+	spin_lock(&lock->lock);
 	__del_holder(lock, current);
 	lock->count = 0;
 	if (!list_empty(&lock->waiters))
 		__wake_many(lock);
-	spin_unlock_irqrestore(&lock->lock, flags);
+	spin_unlock(&lock->lock);
 }
 
 static void report_recursive_bug(dm_block_t b, int r)
