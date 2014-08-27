From: Liuhua Wang <lwang@suse.com>
Subject: [PATCH] fix mirror device creation with lvcreate failed
Date: Wed, 27 Aug 2014 16:18:25 +0800
Message-ID: <1409127505-5246-1-git-send-email-lwang@suse.com>
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
Cc: nfbrown@suse.com
List-Id: dm-devel.ids

 On some devices, when create mirror device with lvcreate, it fails.
 device-mapper: reload ioctl on  failed: Invalid argument
 Failed to activate new LV.

 We can use read size 4096 since md always use 4096.

Signed-off-by: Liuhua Wang <lwang@suse.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69..621afbb 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -860,7 +860,7 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 	rdev->sb_start = 0;
 	rdev->sb_size = sizeof(*sb);
 
-	ret = read_disk_sb(rdev, rdev->sb_size);
+	ret = read_disk_sb(rdev, 4096);
 	if (ret)
 		return ret;
 
-- 
1.9.0
