From: Malahal Naineni <malahal@us.ibm.com>
Subject: [PATCH] imported patch
	sync-no_cluster-with-cluster-flag.patch
Date: Sun, 29 Aug 2010 10:59:12 -0700
Message-ID: <5e7598cf7714083ffd84.1283104752@malahal>
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
To: jaxboe@fusionio.com, dm-devel@redhat.com
List-Id: dm-devel.ids

diff -r 8305d08f6ecf -r 5e7598cf7714 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Wed Aug 25 13:44:33 2010 -0700
+++ b/drivers/scsi/scsi_lib.c	Wed Aug 25 13:44:33 2010 -0700
@@ -1633,8 +1633,10 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
 
 	/* New queue, no concurrency on queue_flags */
-	if (!shost->use_clustering)
+	if (!shost->use_clustering) {
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
+		q->limits.no_cluster = 1;
+	}
 
 	/*
 	 * set a reasonable default alignment on word boundaries: the
