From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] dm ioctl: bugfix for kvfree() in free_params()
Date: Thu,  8 Oct 2015 04:46:48 -0700
Message-ID: <bff7add3978af84f7d33822a3079309ecc904dfa.1444333391.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The ioctl parameter block consists of two parts, a dm_ioctl struct
followed by a data buffer. Don't free the parameter block when the
data buffer is empty.

Fixes: 30c2a1f('dm ioctl: use kvfree() in free_params()')
Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/md/dm-ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index dbb5588..3f93787 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1673,10 +1673,13 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 
 static void free_params(struct dm_ioctl *param, size_t param_size, int param_flags)
 {
+	const size_t minimum_data_size = sizeof(*param) - sizeof(param->data);
+
 	if (param_flags & DM_WIPE_BUFFER)
 		memset(param, 0, param_size);
 
-	kvfree(param);
+	if (param_size > minimum_data_size)
+		kvfree(param);
 }
 
 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
-- 
1.9.1
