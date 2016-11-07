From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] block: disallow changing max_sectors_kb on a request
 stacking device
Date: Mon, 7 Nov 2016 14:26:47 -0500
Message-ID: <20161107192646.GA11572@redhat.com>
References: <20161028194549.14556-1-snitzer@redhat.com>
 <20161107164029.GA27464@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161107164029.GA27464@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Otherwise users can easily shoot themselves in the foot by creating the
situation where the top-level stacked device (e.g. DM multipath) has a
larger max_sectors_kb than the underlying device(s).  Which will
certainly lead to IO errors due to the "over max size limit" check in
blk_cloned_rq_check_limits().

This is a crude, yet effective, solution that forces the use of system
software (e.g. udev rules or multipathd) to tweak max_sectors_kb of the
underlying devices _before_ a layer like DM multipath is layered ontop.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9cc8d7c..934f326 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -199,8 +199,12 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 	unsigned long max_sectors_kb,
 		max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1,
 			page_kb = 1 << (PAGE_SHIFT - 10);
-	ssize_t ret = queue_var_store(&max_sectors_kb, page, count);
+	ssize_t ret;
+
+	if (blk_queue_stackable(q))
+		return -EINVAL;
 
+	ret = queue_var_store(&max_sectors_kb, page, count);
 	if (ret < 0)
 		return ret;
 
-- 
2.9.3 (Apple Git-75)

