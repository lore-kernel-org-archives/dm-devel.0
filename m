From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 1/2] dm: Set safe default max_sectors for targets
 with no underlying device
Date: Sat, 19 Sep 2009 00:18:36 +0900
Message-ID: <4AB3A4CC.4010708@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This is a preparation for the next patch, which changes
blk_set_default_limits() to set 0 for max_sectors/max_hw_sectors.
With the next patch, for dm targets like 'zero', where there's no
underlying device, those values remain 0 and the dm device becomes
unusable.

So check the max_sectors and set to SAFE_MAX_SECTORS if 0.

Check this thread for further background:
https://www.redhat.com/archives/dm-devel/2009-September/msg00176.html


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: David Strand <dpstrand@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/md/dm-table.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.31.work/drivers/md/dm-table.c
===================================================================
--- linux-2.6.31.work.orig/drivers/md/dm-table.c
+++ linux-2.6.31.work/drivers/md/dm-table.c
@@ -707,6 +707,17 @@ static int validate_hardware_logical_blo
 		    device_logical_block_size_sects - next_target_start : 0;
 	}

+	/*
+	 * blk_set_default_limits() sets max_sectors/max_hw_sectors to 0.
+	 * When all targets have no underlying device, they are
+	 * left unchanged from the default values and cause problems.
+	 * Use SAFE_MAX_SECTORS for such cases.
+	 */
+	if (limits->max_hw_sectors == 0)
+		limits->max_hw_sectors = SAFE_MAX_SECTORS;
+	if (limits->max_sectors == 0)
+		limits->max_sectors = SAFE_MAX_SECTORS;
+
 	if (remaining) {
 		DMWARN("%s: table line %u (start sect %llu len %llu) "
 		       "not aligned to h/w logical block size %u",
