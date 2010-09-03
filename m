From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 38/41] swap: do not send discards as barriers
Date: Fri,  3 Sep 2010 12:29:53 +0200
Message-ID: <1283509796-1510-39-git-send-email-tj__33208.6411923685$1283510079$gmane$org@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

From: Christoph Hellwig <hch@infradead.org>

The swap code already uses synchronous discards, no need to add I/O barriers.

tj: superflous newlines removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hugh Dickins <hughd@google.com>
Tested-by: Nigel Cunningham <nigel@tuxonice.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/swapfile.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1f3f9c5..68cda16 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -141,8 +141,7 @@ static int discard_swap(struct swap_info_struct *si)
 	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
 	if (nr_blocks) {
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			return err;
 		cond_resched();
@@ -153,8 +152,7 @@ static int discard_swap(struct swap_info_struct *si)
 		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			break;
 
@@ -193,8 +191,7 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT |
-							BLKDEV_IFL_BARRIER))
+				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT))
 				break;
 		}
 
-- 
1.7.1
