From: Anup Limbu <anuplimbu14@gmail.com>
Subject: [PATCH] md: dm-bufio: Use BUG_ON instead of if BUG
Date: Wed, 25 Nov 2015 15:46:05 +0530
Message-ID: <1448446565-15805-1-git-send-email-anuplimbu14@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anup Limbu <anuplimbu14@gmail.com>
List-Id: dm-devel.ids

Use BUG_ON instead of if BUG

Signed-off-by: Anup Limbu <anuplimbu14@gmail.com>
---
 drivers/md/dm-bufio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 2dd3308..788a905 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1891,8 +1891,7 @@ static void __exit dm_bufio_exit(void)
 		bug = 1;
 	}
 
-	if (bug)
-		BUG();
+	BUG_ON(bug);
 }
 
 module_init(dm_bufio_init)
-- 
1.9.1
