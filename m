From: Coly Li <colyli@suse.de>
Subject: [PATCH] dax: fix for do not print error message for
	non-persistent memory block device
Date: Thu,  3 Sep 2020 19:55:49 +0800
Message-ID: <20200903115549.17845-1-colyli@suse.de>
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
To: linux-nvdimm@lists.01.org
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>, Coly Li <colyli@suse.de>, dm-devel@redhat.com, Adrian Huang <ahuang12@lenovo.com>, Jan Kara <jack@suse.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: dm-devel.ids

When calling __generic_fsdax_supported(), a dax-unsupported device may
not have dax_dev as NULL, e.g. the dax related code block is not enabled
by Kconfig.

Therefore in __generic_fsdax_supported(), to check whether a device
supports DAX or not, the following order should be performed,
- If dax_dev pointer is NULL, it means the device driver explicitly
  announce it doesn't support DAX. Then it is OK to directly return
  false from __generic_fsdax_supported().
- If dax_dev pointer is NOT NULL, it might be because the driver doesn't
  support DAX and not explicitly initialize related data structure. Then
  bdev_dax_supported() should be called for further check.

IMHO if device driver desn't explicitly set its dax_dev pointer to NULL,
this is not a bug. Calling bdev_dax_supported() makes sure they can be
recognized as dax-unsupported eventually.

This patch does the following change for the above purpose,
    -       if (!dax_dev && !bdev_dax_supported(bdev, blocksize)) {
    +       if (!dax_dev || !bdev_dax_supported(bdev, blocksize)) {


Fixes: c2affe920b0e ("dax: do not print error message for non-persistent memory block device")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Adrian Huang <ahuang12@lenovo.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 32642634c1bb..e5767c83ea23 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -100,7 +100,7 @@ bool __generic_fsdax_supported(struct dax_device *dax_dev,
 		return false;
 	}
 
-	if (!dax_dev && !bdev_dax_supported(bdev, blocksize)) {
+	if (!dax_dev || !bdev_dax_supported(bdev, blocksize)) {
 		pr_debug("%s: error: dax unsupported by block device\n",
 				bdevname(bdev, buf));
 		return false;
-- 
2.26.2
