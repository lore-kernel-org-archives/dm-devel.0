From: Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH] dm-ioctl: Remove useless __dev_status call for
 "device geometry" and "target message" ioctl
Date: Tue, 18 May 2010 15:51:41 +0200
Message-ID: <4BF29B6D.4040308@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Remove useless __dev_status call while processing an ioctl that sets up
device geometry and target message.

Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>
---
 drivers/md/dm-ioctl.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f67ec28..afb641c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -818,8 +818,6 @@ static int dev_set_geometry(struct dm_ioctl *param, size_t param_size)
 	geometry.start = indata[3];
 
 	r = dm_set_geometry(md, &geometry);
-	if (!r)
-		r = __dev_status(md, param);
 
 	param->data_size = 0;
 
@@ -1333,10 +1331,6 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
 	if (!md)
 		return -ENXIO;
 
-	r = __dev_status(md, param);
-	if (r)
-		goto out;
-
 	if (tmsg < (struct dm_target_msg *) param->data ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMWARN("Invalid target message parameters.");
