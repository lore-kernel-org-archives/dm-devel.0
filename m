From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] dm: ioctl: prevent double freeing
Date: Fri,  4 Sep 2015 16:52:39 +0530
Message-ID: <1441365759-7247-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: dm-devel.ids

DM_PARAMS_KMALLOC and DM_PARAMS_VMALLOC should never be set together in
param_flags. We are setting these flags while allocating so we know that
there is almost no chance of having these two set together but still we
can have some additional safety.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 80a4395..aaad74e 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1680,7 +1680,7 @@ static void free_params(struct dm_ioctl *param, size_t param_size, int param_fla
 
 	if (param_flags & DM_PARAMS_KMALLOC)
 		kfree(param);
-	if (param_flags & DM_PARAMS_VMALLOC)
+	else if (param_flags & DM_PARAMS_VMALLOC)
 		vfree(param);
 }
 
-- 
1.9.1

