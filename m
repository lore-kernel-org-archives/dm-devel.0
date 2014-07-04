From: "xinhui.pan" <xinhuix.pan@intel.com>
Subject: [PATCH] md/dm-ioctl.c: optimize memory allocation in copy_params
Date: Fri, 04 Jul 2014 18:22:32 +0800
Message-ID: <53B68068.2060102@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: yanmin_zhang@linux.intel.com, "Liu, ShuoX" <shuox.liu@intel.com>
List-Id: dm-devel.ids

KMALLOC_MAX_SIZE is too big, it easily cause memory fragmented and low memory when param_kernel->data_size
is also big. That's not nice. So use vmalloc instead of kmalloc when size is larger than (PAGE_SIZE << 2).
There are other drivers using kmalloc to gain a big size memory. And that cause our devices to hit hang and
many worse issues. We don't benefit much when using kmalloc in such scenario.

Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
Signed-off-by: yanmin.zhang <yanmin_zhang@linux.intel.com>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5152142..31c3af9 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1709,7 +1709,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
         * Use kmalloc() rather than vmalloc() when we can.
         */
        dmi = NULL;
-       if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
+       if (param_kernel->data_size <= (PAGE_SIZE << 2)) {
                dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
                if (dmi)
                        *param_flags |= DM_PARAMS_KMALLOC;
-- 
1.7.9.5
