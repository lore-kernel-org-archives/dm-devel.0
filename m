From: heinzm@redhat.com
Subject: [PATCH] dm raid: bump version to 1.12.1
Date: Thu, 13 Jul 2017 17:52:18 +0200
Message-ID: <20170713155218.24921-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Now that MD deadlock fixes got merged with
commit 026d15f6b9878794fae1f794cae881ccd65052e5
(fix commit cc27b0c78c79680d128dbac79de0d40556d041bb),
bump the target version.

This fix avoids hangs with reshaping and the version
change allows userspace to detect that it is available.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt | 1 +
 drivers/md/dm-raid.c                    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 7e06e65..4a0a746 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -343,3 +343,4 @@ Version History
 1.11.0  Fix table line argument order
 	(wrong raid10_copies/raid10_format sequence)
 1.11.1  Add raid4/5/6 journal write-back support via journal_mode option
+1.12.1  fix for MD deadlock between mddev_suspend() and md_write_start() available
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 757355b..5bfe285 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3892,7 +3892,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 11, 1},
+	.version = {1, 12, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.9.4
