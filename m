From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: add memory barrier before waitqueue_active
Date: Tue, 5 Feb 2019 05:09:00 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1902050506470.12231@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Please submit patch this to Linus before 5.0 is released.

Mikulas



waitqueue_active without preceding barrier is unsafe, see the comment
before waitqueue_active definition in include/linux/wait.h.

This patch changes it to wq_has_sleeper.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 6f75723190d8 ("dm: remove the pending IO accounting")

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2019-02-04 20:18:03.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2019-02-04 20:18:03.000000000 +0100
@@ -699,7 +699,7 @@ static void end_io_acct(struct dm_io *io
 				    true, duration, &io->stats_aux);
 
 	/* nudge anyone waiting on suspend queue */
-	if (unlikely(waitqueue_active(&md->wait)))
+	if (unlikely(wq_has_sleeper(&md->wait)))
 		wake_up(&md->wait);
 }
 
