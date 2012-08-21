From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 19/20] dm-crypt: retain write ordering
Date: Tue, 21 Aug 2012 11:09:30 +0200
Message-ID: <045c0c46e56054ea547d430f2357ee90b0ede457.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

This patch implements reordering outgoing write requests.
The requests are submitted in the same order they were received in.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   47 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0e31454..ccd3380 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -51,6 +51,8 @@ struct dm_crypt_io {
 	sector_t sector;
 
 	struct list_head list;
+
+	u64 sequence;
 };
 
 struct dm_crypt_request {
@@ -126,6 +128,9 @@ struct crypt_config {
 	wait_queue_head_t write_thread_wait;
 	struct list_head write_thread_list;
 
+	u64 write_sequence;
+	atomic64_t alloc_sequence;
+
 	char *cipher;
 	char *cipher_string;
 
@@ -1097,6 +1102,7 @@ static int dmcrypt_write(void *data)
 	struct crypt_config *cc = data;
 	while (1) {
 		struct list_head local_list;
+		unsigned spinlock_breaker;
 		struct blk_plug plug;
 
 		DECLARE_WAITQUEUE(wait, current);
@@ -1126,20 +1132,35 @@ continue_locked:
 		goto continue_locked;
 
 pop_from_list:
-		local_list = cc->write_thread_list;
-		local_list.next->prev = &local_list;
-		local_list.prev->next = &local_list;
-		INIT_LIST_HEAD(&cc->write_thread_list);
+		INIT_LIST_HEAD(&local_list);
+		spinlock_breaker = 0;
+		do {
+			struct dm_crypt_io *io = container_of(
+						cc->write_thread_list.next,
+						struct dm_crypt_io, list);
+
+			BUG_ON(io->sequence < cc->write_sequence);
+			if (io->sequence != cc->write_sequence)
+				break;
+			cc->write_sequence++;
+
+			list_del(&io->list);
+			list_add_tail(&io->list, &local_list);
+			if (unlikely(!(++spinlock_breaker & 63))) {
+				spin_unlock_irq(&cc->write_thread_wait.lock);
+				spin_lock_irq(&cc->write_thread_wait.lock);
+			}
+		} while (!list_empty(&cc->write_thread_list));
 
 		spin_unlock_irq(&cc->write_thread_wait.lock);
 
 		blk_start_plug(&plug);
-		do {
+		while (!list_empty(&local_list)) {
 			struct dm_crypt_io *io = container_of(local_list.next,
 						struct dm_crypt_io, list);
 			list_del(&io->list);
 			kcryptd_io_write(io);
-		} while (!list_empty(&local_list));
+		}
 		blk_finish_plug(&plug);
 	}
 	return 0;
@@ -1149,10 +1170,18 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	unsigned long flags;
+	struct dm_crypt_io *io_list;
 
 	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
-	list_add_tail(&io->list, &cc->write_thread_list);
+	list_for_each_entry_reverse(io_list, &cc->write_thread_list, list) {
+		if (io_list->sequence < io->sequence) {
+			list_add(&io->list, &io_list->list);
+			goto added;
+		}
+	}
+	list_add(&io->list, &cc->write_thread_list);
 	wake_up_locked(&cc->write_thread_wait);
+added:
 	spin_unlock_irqrestore(&cc->write_thread_wait.lock, flags);
 }
 
@@ -1167,6 +1196,8 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		return;
 	}
 
+	io->sequence = atomic64_inc_return(&io->cc->alloc_sequence) - 1;
+
 	crypt_convert(io, clone);
 }
 
@@ -1735,6 +1766,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	init_waitqueue_head(&cc->write_thread_wait);
 	INIT_LIST_HEAD(&cc->write_thread_list);
+	cc->write_sequence = 0;
+	atomic64_set(&cc->alloc_sequence, 0);
 
 	cc->write_thread = kthread_create(dmcrypt_write, cc, "dmcrypt_write");
 	if (IS_ERR(cc->write_thread)) {
-- 
1.7.10.4
