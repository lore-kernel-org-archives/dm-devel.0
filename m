From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 18/20] dm-crypt: offload writes to thread
Date: Tue, 21 Aug 2012 11:09:29 +0200
Message-ID: <2dfded24967491510b67b3fd85974c49ef5f200f.1345477953.git.mbroz@redhat.com>
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

Submitting write bios directly in the encryption thread caused serious
performance degradation. On multiprocessor machine encryption requests
finish in a different order than they were submitted in. Consequently, write
requests would be submitted in a different order and it could cause severe
performance degradation.

This patch moves submitting write requests to a separate thread so that
the requests can be sorted before submitting.

Sorting in implemented in the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 80 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9316630..0e31454 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -49,6 +49,8 @@ struct dm_crypt_io {
 
 	int error;
 	sector_t sector;
+
+	struct list_head list;
 };
 
 struct dm_crypt_request {
@@ -120,6 +122,10 @@ struct crypt_config {
 	wait_queue_head_t crypt_thread_wait;
 	struct list_head crypt_thread_list;
 
+	struct task_struct *write_thread;
+	wait_queue_head_t write_thread_wait;
+	struct list_head write_thread_list;
+
 	char *cipher;
 	char *cipher_string;
 
@@ -1069,9 +1075,8 @@ static int kcryptd_io_read(struct dm_crypt_io *io)
 	return 0;
 }
 
-static void kcryptd_io_write(struct work_struct *work)
+static void kcryptd_io_write(struct dm_crypt_io *io)
 {
-	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
 	struct crypt_config *cc = io->cc;
 	struct bio *clone = io->bio_out;
 
@@ -1087,12 +1092,68 @@ static void kcryptd_io_write(struct work_struct *work)
 	generic_make_request(clone);
 }
 
+static int dmcrypt_write(void *data)
+{
+	struct crypt_config *cc = data;
+	while (1) {
+		struct list_head local_list;
+		struct blk_plug plug;
+
+		DECLARE_WAITQUEUE(wait, current);
+
+		spin_lock_irq(&cc->write_thread_wait.lock);
+continue_locked:
+
+		if (!list_empty(&cc->write_thread_list))
+			goto pop_from_list;
+
+		__set_current_state(TASK_INTERRUPTIBLE);
+		__add_wait_queue(&cc->write_thread_wait, &wait);
+
+		spin_unlock_irq(&cc->write_thread_wait.lock);
+
+		if (unlikely(kthread_should_stop())) {
+			set_task_state(current, TASK_RUNNING);
+			remove_wait_queue(&cc->write_thread_wait, &wait);
+			break;
+		}
+
+		schedule();
+
+		set_task_state(current, TASK_RUNNING);
+		spin_lock_irq(&cc->write_thread_wait.lock);
+		__remove_wait_queue(&cc->write_thread_wait, &wait);
+		goto continue_locked;
+
+pop_from_list:
+		local_list = cc->write_thread_list;
+		local_list.next->prev = &local_list;
+		local_list.prev->next = &local_list;
+		INIT_LIST_HEAD(&cc->write_thread_list);
+
+		spin_unlock_irq(&cc->write_thread_wait.lock);
+
+		blk_start_plug(&plug);
+		do {
+			struct dm_crypt_io *io = container_of(local_list.next,
+						struct dm_crypt_io, list);
+			list_del(&io->list);
+			kcryptd_io_write(io);
+		} while (!list_empty(&local_list));
+		blk_finish_plug(&plug);
+	}
+	return 0;
+}
+
 static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
+	unsigned long flags;
 
-	INIT_WORK(&io->work, kcryptd_io_write);
-	queue_work(cc->io_queue, &io->work);
+	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
+	list_add_tail(&io->list, &cc->write_thread_list);
+	wake_up_locked(&cc->write_thread_wait);
+	spin_unlock_irqrestore(&cc->write_thread_wait.lock, flags);
 }
 
 static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
@@ -1299,6 +1360,9 @@ static void crypt_dtr(struct dm_target *ti)
 		kfree(cc->crypt_threads);
 	}
 
+	if (cc->write_thread)
+		kthread_stop(cc->write_thread);
+
 	if (cc->io_queue)
 		destroy_workqueue(cc->io_queue);
 
@@ -1669,6 +1733,18 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		}
 	}
 
+	init_waitqueue_head(&cc->write_thread_wait);
+	INIT_LIST_HEAD(&cc->write_thread_list);
+
+	cc->write_thread = kthread_create(dmcrypt_write, cc, "dmcrypt_write");
+	if (IS_ERR(cc->write_thread)) {
+		ret = PTR_ERR(cc->write_thread);
+		cc->write_thread = NULL;
+		ti->error = "Couldn't spawn write thread";
+		goto bad;
+	}
+	wake_up_process(cc->write_thread);
+
 	ti->num_flush_requests = 1;
 	ti->discard_zeroes_data_unsupported = true;
 
-- 
1.7.10.4
