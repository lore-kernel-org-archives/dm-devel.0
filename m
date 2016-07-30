From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: Pillar/Axiom supports
	failback=immediate
Date: Sat, 30 Jul 2016 23:15:48 +0200
Message-ID: <1469913348-9350-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

ALUA device with support for preferred_path. Confirmed by
the vendor's utils and docs:
https://docs.oracle.com/cd/E35311_02/E28846_08/E41503_01/conPathSelection.html

Auto-generated template from Oracle FS Path Manager 4.0:
        vendor                "^Pillar(  )?$"
        product               "^Axiom"
        path_grouping_policy  group_by_prio
        prio                  oraclefspm
        path_checker          oraclefspm
        failback              immediate
        path_selector         "round-robin 0"

Template from Axiom Path Manager 3.1 for RHEL-6.1:
        vendor               "Pillar"
        product              "*"
        path_grouping_policy group_by_prio
        prio                 pillarapm
        path_checker         pillarapm
        failback             immediate
        no_path_retry        60
        dev_loss_tmo         60
        fast_io_fail_tmo     30

Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fe4a51f..ed23c92 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -635,7 +635,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "Pillar",
 		.product       = "Axiom.*",
 		.prio_name     = PRIO_ALUA,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		.vendor        = "^Oracle",
-- 
2.7.4
