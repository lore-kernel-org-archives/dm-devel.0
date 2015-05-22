From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH dm] dm thin: __blkdev_issue_discard_async() can be static
Date: Sat, 23 May 2015 05:37:23 +0800
Message-ID: <20150522213723.GA89951@lkp-sb04>
References: <201505230502.WN0Nq7Zv%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201505230502.WN0Nq7Zv%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Thornber <ejt@redhat.com>
Cc: kbuild-all@01.org, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c2634a5..ef47420 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -335,7 +335,7 @@ struct thin_c {
  *    that is being kept local to DM thinp until the block changes to allow
  *    late bio splitting land upstream.
  */
-int __blkdev_issue_discard_async(struct block_device *bdev, sector_t sector,
+static int __blkdev_issue_discard_async(struct block_device *bdev, sector_t sector,
 				 sector_t nr_sects, gfp_t gfp_mask, unsigned long flags,
 				 struct bio *parent_bio)
 {
