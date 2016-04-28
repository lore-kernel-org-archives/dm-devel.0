From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 17/20] dm: get rid of superfluous gfp flags
Date: Thu, 28 Apr 2016 15:24:03 +0200
Message-ID: <1461849846-27209-18-git-send-email-mhocko@kernel.org>
References: <1461849846-27209-1-git-send-email-mhocko@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461849846-27209-1-git-send-email-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Shaohua Li <shli@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Michal Hocko <mhocko@suse.com>

copy_params seems to be little bit confused about which allocation flags
to use. It enforces GFP_NOIO even though it uses
memalloc_noio_{save,restore} which enforces GFP_NOIO at the page
allocator level automatically (via memalloc_noio_flags). It also
uses __GFP_REPEAT for the __vmalloc request which doesn't make much
sense either because vmalloc doesn't rely on costly high order
allocations. Let's just drop the __GFP_REPEAT and leave the further
cleanup to later changes.

Cc: Shaohua Li <shli@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2adf81d81fca..2c7ca258c4e4 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1723,7 +1723,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 	if (!dmi) {
 		unsigned noio_flag;
 		noio_flag = memalloc_noio_save();
-		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
+		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
 		memalloc_noio_restore(noio_flag);
 		if (dmi)
 			*param_flags |= DM_PARAMS_VMALLOC;
-- 
2.8.0.rc3
