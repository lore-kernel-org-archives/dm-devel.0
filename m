From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0314/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:59:15 +0800
Message-ID: <20160802105915.2474-1-baolex.ni@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, shli@kernel.org, dm-devel@redhat.com, hal.rosenstock@gmail.com, dledford@redhat.com, sean.hefty@intel.com, bp@alien8.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com
List-Id: dm-devel.ids

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5253274..b01f1e9 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1754,7 +1754,7 @@ static void __exit dm_raid_exit(void)
 module_init(dm_raid_init);
 module_exit(dm_raid_exit);
 
-module_param(devices_handle_discard_safely, bool, 0644);
+module_param(devices_handle_discard_safely, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(devices_handle_discard_safely,
 		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");
 
-- 
2.9.2

