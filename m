From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] dm delay: use msecs_to_jiffies for time conversion
Date: Tue, 17 Mar 2015 07:47:58 -0400
Message-ID: <1426592878-3843-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: dm-devel.ids

Converting milliseconds to jiffies by "val * HZ / 1000" is technically
OK but msecs_to_jiffies(val) is the cleaner solution and handles all
corner cases correctly. This is a minor API consolidation only and
should make things more readable.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was compile tested with x86_64_defconfig + CONFIG_DM_DELAY=m

Patch is against 4.0-rc4 (localversion-next is -next-20150317)

 drivers/md/dm-delay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 42c3a27..57b6a19 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -236,7 +236,7 @@ static int delay_bio(struct delay_c *dc, int delay, struct bio *bio)
 	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
 
 	delayed->context = dc;
-	delayed->expires = expires = jiffies + (delay * HZ / 1000);
+	delayed->expires = expires = jiffies + msecs_to_jiffies(delay);
 
 	mutex_lock(&delayed_bios_lock);
 
-- 
1.7.10.4

