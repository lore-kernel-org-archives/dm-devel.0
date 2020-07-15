From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 6/8] dm raid: Remove empty if statement
Date: Wed, 15 Jul 2020 18:52:15 +0900
Message-ID: <20200715095217.441885-7-damien.lemoal@wdc.com>
References: <20200715095217.441885-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200715095217.441885-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

In super_init_validation(), remove a body-less if statement testing only
variables to avoid a compilation warning when compiling with W=1.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-raid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 10e8b2fe787b..08023c50aaa0 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2345,8 +2345,6 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 
 	if (new_devs == rs->raid_disks || !rebuilds) {
 		/* Replace a broken device */
-		if (new_devs == 1 && !rs->delta_disks)
-			;
 		if (new_devs == rs->raid_disks) {
 			DMINFO("Superblocks created for new raid set");
 			set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
-- 
2.26.2
