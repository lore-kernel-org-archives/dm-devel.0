From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0315/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:59:20 +0800
Message-ID: <20160802105920.2540-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org, snitzer@redhat.com, dm-devel@redhat.com, hal.rosenstock@gmail.com, dledford@redhat.com, sean.hefty@intel.com, bp@alien8.de
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
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8959e6d..33562bf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -66,7 +66,7 @@
 #define ANY_GROUP NUMA_NO_NODE
 
 static bool devices_handle_discard_safely = false;
-module_param(devices_handle_discard_safely, bool, 0644);
+module_param(devices_handle_discard_safely, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(devices_handle_discard_safely,
 		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");
 static struct workqueue_struct *raid5_wq;
-- 
2.9.2
