From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] dm zoned: Avoid 64-bit division error in dmz_fixup_devices
Date: Wed, 13 May 2020 01:45:22 -0700
Message-ID: <20200513084521.461116-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>
List-Id: dm-devel.ids

When building arm32 allyesconfig:

ld.lld: error: undefined symbol: __aeabi_uldivmod
>>> referenced by dm-zoned-target.c
>>>               md/dm-zoned-target.o:(dmz_ctr) in archive drivers/built-in.a

dmz_fixup_devices uses DIV_ROUND_UP with variables of type sector_t. As
such, it should be using DIV_ROUND_UP_SECTOR_T, which handles this
automatically.

Fixes: 70978208ec91 ("dm zoned: metadata version 2")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/md/dm-zoned-target.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index ea43f6892ced..9c4fd4b04878 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -803,8 +803,9 @@ static int dmz_fixup_devices(struct dm_target *ti)
 
 	if (reg_dev) {
 		reg_dev->zone_nr_sectors = zoned_dev->zone_nr_sectors;
-		reg_dev->nr_zones = DIV_ROUND_UP(reg_dev->capacity,
-						 reg_dev->zone_nr_sectors);
+		reg_dev->nr_zones =
+			DIV_ROUND_UP_SECTOR_T(reg_dev->capacity,
+					      reg_dev->zone_nr_sectors);
 		zoned_dev->zone_offset = reg_dev->nr_zones;
 	}
 	return 0;

base-commit: e098d7762d602be640c53565ceca342f81e55ad2
-- 
2.26.2
