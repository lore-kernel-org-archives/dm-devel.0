From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] dm: ioctl: use kvfree
Date: Mon, 11 Apr 2016 20:44:37 +0530
Message-ID: <1460387677-19948-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: dm-devel.ids

We can use kvfree() instead of calling kfree() and vfree() based on
if-else and param_flags. kvfree() will check the type of address and
will call the respective function to free it.
Additionally we can also remove the use of DM_PARAMS_KMALLOC and
DM_PARAMS_VMALLOC.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/md/dm-ioctl.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2adf81d..d5df3a5 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1670,8 +1670,6 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 	return r;
 }
 
-#define DM_PARAMS_KMALLOC	0x0001	/* Params alloced with kmalloc */
-#define DM_PARAMS_VMALLOC	0x0002	/* Params alloced with vmalloc */
 #define DM_WIPE_BUFFER		0x0010	/* Wipe input buffer before returning from ioctl */
 
 static void free_params(struct dm_ioctl *param, size_t param_size, int param_flags)
@@ -1679,10 +1677,7 @@ static void free_params(struct dm_ioctl *param, size_t param_size, int param_fla
 	if (param_flags & DM_WIPE_BUFFER)
 		memset(param, 0, param_size);
 
-	if (param_flags & DM_PARAMS_KMALLOC)
-		kfree(param);
-	if (param_flags & DM_PARAMS_VMALLOC)
-		vfree(param);
+	kvfree(param);
 }
 
 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
@@ -1716,8 +1711,6 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 	dmi = NULL;
 	if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
 		dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
-		if (dmi)
-			*param_flags |= DM_PARAMS_KMALLOC;
 	}
 
 	if (!dmi) {
@@ -1725,8 +1718,6 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 		noio_flag = memalloc_noio_save();
 		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_REPEAT | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
 		memalloc_noio_restore(noio_flag);
-		if (dmi)
-			*param_flags |= DM_PARAMS_VMALLOC;
 	}
 
 	if (!dmi) {
-- 
1.9.1

