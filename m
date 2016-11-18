From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 06/14] dm-ioctl: Use offsetof() instead of
	open-coding it
Date: Fri, 18 Nov 2016 14:28:00 -0800
Message-ID: <ce25e742-be89-b445-9322-ef6c514dba4f@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Subtracting sizes is a fragile approach because the result is only
correct if the compiler has not added any padding at the end of the
structure. Hence use offsetof() instead of size subtraction. An
additional advantage of offsetof() is that it makes the intent more
clear.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 966eb4b..c72a770 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1697,7 +1697,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 {
 	struct dm_ioctl *dmi;
 	int secure_data;
-	const size_t minimum_data_size = sizeof(*param_kernel) - sizeof(param_kernel->data);
+	const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
 
 	if (copy_from_user(param_kernel, user, minimum_data_size))
 		return -EFAULT;
-- 
2.10.1
