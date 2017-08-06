From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] dm integrity: make blk_integrity_profile structure const
Date: Sun,  6 Aug 2017 22:54:00 +0530
Message-ID: <1502040240-6867-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: julia.lawall@lip6.fr, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: dm-devel.ids

Make this structure const as it is only stored in the profile field of a
blk_integrity structure. This field is of type const, so make structure
as const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 293a196..e522a94 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -299,7 +299,7 @@ static void __DEBUG_bytes(__u8 *bytes, size_t len, const char *msg, ...)
 /*
  * DM Integrity profile, protection is performed layer above (dm-crypt)
  */
-static struct blk_integrity_profile dm_integrity_profile = {
+static const struct blk_integrity_profile dm_integrity_profile = {
 	.name			= "DM-DIF-EXT-TAG",
 	.generate_fn		= NULL,
 	.verify_fn		= NULL,
-- 
1.9.1

