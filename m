From: Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH] dm-ioctl: Return data to userspace after rename
 ioctl is processed
Date: Tue, 13 Apr 2010 17:10:02 +0200
Message-ID: <4BC4894A.2090306@redhat.com>
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
List-Id: dm-devel.ids

Allow data to be returned to userspace after a rename ioctl is processed.
It carries important information for userspace code to react properly,
now checking new DM_UEVENT_GENERATED_FLAG that has been added recently.

Signed-off-by: Peter Rajnoha
---

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..d33f171 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -774,8 +774,6 @@ static int dev_rename(struct dm_ioctl *param, size_t param_size)
 	if (r)
 		return r;
 
-	param->data_size = 0;
-
 	return dm_hash_rename(param->event_nr, &param->flags, param->name,
 			      new_name);
 }
