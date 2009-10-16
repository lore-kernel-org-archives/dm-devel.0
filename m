From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/9] dm core: clean up in-flight checking
Date: Fri, 16 Oct 2009 13:55:29 +0900
Message-ID: <4AD7FCC1.6040100@ct.jp.nec.com>
References: <4AD7FC11.7030009@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AD7FC11.7030009@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch adds md_in_flight() to get the number of in_flight I/Os.
No functional change.

This patch is a preparation for PATCH 6, which changes I/O counter
to md->pending from q->in_flight in request-based dm.

This patch depends on:
  http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=a9327cac440be4d8333bba975cbbf76045096275
  (Seperate read and write statistics of in_flight requests)

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: 2.6.32-rc4/drivers/md/dm.c
===================================================================
--- 2.6.32-rc4.orig/drivers/md/dm.c
+++ 2.6.32-rc4/drivers/md/dm.c
@@ -450,6 +450,12 @@ static void free_bio_info(struct dm_rq_c
 	mempool_free(info, info->tio->md->io_pool);
 }
 
+static int md_in_flight(struct mapped_device *md)
+{
+	return atomic_read(&md->pending[READ]) +
+	       atomic_read(&md->pending[WRITE]);
+}
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
@@ -2100,8 +2106,7 @@ static int dm_wait_for_completion(struct
 				break;
 			}
 			spin_unlock_irqrestore(q->queue_lock, flags);
-		} else if (!atomic_read(&md->pending[0]) &&
-					!atomic_read(&md->pending[1]))
+		} else if (!md_in_flight(md))
 			break;
 
 		if (interruptible == TASK_INTERRUPTIBLE &&
