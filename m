From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
Date: Mon, 21 Sep 2009 15:43:19 -0400
Message-ID: <yq1iqfc3wyw.fsf@sermon.lab.mkp.net>
References: <4AB3B43D.9000802@ce.jp.nec.com>
	<yq1eiq46ohz.fsf@sermon.lab.mkp.net> <4AB4F74E.7000908@ce.jp.nec.com>
	<yq1k4zt5o2f.fsf@sermon.lab.mkp.net> <4AB7AAE2.8000404@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AB7AAE2.8000404@ce.jp.nec.com> (Jun'ichi Nomura's message of
	"Tue, 22 Sep 2009 01:33:38 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:

Jun'ichi> If we aren't sure, shouldn't we set its default to -1 or
Jun'ichi> putting comments in blk_set_default_limits() at least to avoid
Jun'ichi> possible confusion in future?

Jens, what do you think about this?  Goes on top of what you have
queued...


block: Do not clamp max_hw_sectors for stacking devices

Stacking devices do not have an inherent max_hw_sector limit.  Set the
default to INT_MAX so we are bounded only by capabilities of the
underlying storage.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/block/blk-settings.c b/block/blk-settings.c
index cd9b730..eaf122f 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -111,7 +111,8 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_hw_segments = MAX_HW_SEGMENTS;
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = MAX_SEGMENT_SIZE;
-	lim->max_sectors = lim->max_hw_sectors = BLK_DEF_MAX_SECTORS;
+	lim->max_sectors = BLK_DEF_MAX_SECTORS;
+	lim->max_hw_sectors = INT_MAX;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
