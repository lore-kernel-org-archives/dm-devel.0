From: heinzm@redhat.com
Subject: [PATCH 17/26] dm raid: fix typo in write_mostly flag
Date: Wed,  6 Jul 2016 19:24:48 +0200
Message-ID: <1467825897-26058-18-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7a33af9..109d698 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -300,7 +300,7 @@ static struct arg_name_flag {
 	{ CTR_FLAG_MIN_RECOVERY_RATE, "min_recovery_rate"},
 	{ CTR_FLAG_MAX_RECOVERY_RATE, "max_recovery_rate"},
 	{ CTR_FLAG_MAX_WRITE_BEHIND, "max_write_behind"},
-	{ CTR_FLAG_WRITE_MOSTLY, "writemostly"},
+	{ CTR_FLAG_WRITE_MOSTLY, "write_mostly"},
 	{ CTR_FLAG_STRIPE_CACHE, "stripe_cache"},
 	{ CTR_FLAG_REGION_SIZE, "region_size"},
 	{ CTR_FLAG_RAID10_COPIES, "raid10_copies"},
-- 
2.5.5
