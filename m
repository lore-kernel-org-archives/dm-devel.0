From: heinzm@redhat.com
Subject: [PATCH] dm raid: don't allow "write behind" with
	raid4/5/6
Date: Thu, 24 Nov 2016 18:53:44 +0100
Message-ID: <1480010024-17941-1-git-send-email-heinzm@redhat.com>
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

Only the md raid1 personality supports setting a maximum number
of "write behind" write ios on any legs set "write mostly".
"write mostly" enhances throughput with slow links/disks.

Technically the "write behind" value is a write intent bitmap
property only being respected by the raid1 personality. It allows
a maximum number of "write behind" writes to any "write mostly"
raid1 mirror legs to be delayed and reads from such legs avoided.

No other MD personalities supported via dm-raid types make
use of "write behind", thus setting this property is superfluous;
it wouldn't cause harm but it is correct to reject it.

Patch removes CTR_FLAG_MAX_WRITE_BEHIND from
raid4/5/6 valid flags allowed.

No bz is related, I came across it during review.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 698b03e..9d5c6bb 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -160,7 +160,6 @@ struct raid_dev {
 				 CTR_FLAG_DAEMON_SLEEP | \
 				 CTR_FLAG_MIN_RECOVERY_RATE | \
 				 CTR_FLAG_MAX_RECOVERY_RATE | \
-				 CTR_FLAG_MAX_WRITE_BEHIND | \
 				 CTR_FLAG_STRIPE_CACHE | \
 				 CTR_FLAG_REGION_SIZE | \
 				 CTR_FLAG_DELTA_DISKS | \
@@ -171,7 +170,6 @@ struct raid_dev {
 				 CTR_FLAG_DAEMON_SLEEP | \
 				 CTR_FLAG_MIN_RECOVERY_RATE | \
 				 CTR_FLAG_MAX_RECOVERY_RATE | \
-				 CTR_FLAG_MAX_WRITE_BEHIND | \
 				 CTR_FLAG_STRIPE_CACHE | \
 				 CTR_FLAG_REGION_SIZE | \
 				 CTR_FLAG_DELTA_DISKS | \
-- 
2.7.4
