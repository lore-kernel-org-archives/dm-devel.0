From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] dm ioctl: use kvfree() in free_params()
Date: Fri,  2 Oct 2015 21:32:19 +0800
Message-ID: <598a723c600e93d40744113d302d902c03d8fd5e.1443792260.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

There is no need to make a flag to tell that this memory is allocated by
kmalloc or vmalloc. Just use kvfree to free the memory.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/md/dm-ioctl.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 80a4395..dbb5588 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1669,8 +1669,6 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 	return r;
 }
 
-#define DM_PARAMS_KMALLOC	0x0001	/* Params alloced with kmalloc */
-#define DM_PARAMS_VMALLOC	0x0002	/* Params alloced with vmalloc */
 #define DM_WIPE_BUFFER		0x0010	/* Wipe input buffer before returning from ioctl */
 
 static void free_params(struct dm_ioctl *param, size_t param_size, int param_flags)
@@ -1678,10 +1676,7 @@ static void free_params(struct dm_ioctl *param, size_t param_size, int param_fla
 	if (param_flags & DM_WIPE_BUFFER)
 		memset(param, 0, param_size);
 
-	if (param_flags & DM_PARAMS_KMALLOC)
-		kfree(param);
-	if (param_flags & DM_PARAMS_VMALLOC)
-		vfree(param);
+	kvfree(param);
 }
 
 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
@@ -1715,8 +1710,6 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 	dmi = NULL;
 	if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
 		dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
-		if (dmi)
-			*param_flags |= DM_PARAMS_KMALLOC;
 	}
 
 	if (!dmi) {
@@ -1724,8 +1717,6 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 		noio_flag = memalloc_noio_save();
 		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
 		memalloc_noio_restore(noio_flag);
-		if (dmi)
-			*param_flags |= DM_PARAMS_VMALLOC;
 	}
 
 	if (!dmi) {
-- 
2.5.0
