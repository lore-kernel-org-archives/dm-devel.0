From: Srinivas Ramani <srinivas.ramani@oracle.com>
Subject: Re: [PATCH] multipath-tools: Pillar/Axiom supports
	failback=immediate
Date: Sat, 30 Jul 2016 16:18:05 -0700 (PDT)
Message-ID: <e46f78fd-b5cd-4498-a96e-d30b6a58d0d3@default>
References: <<1469913348-9350-1-git-send-email-xose.vazquez@gmail.com>>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <<1469913348-9350-1-git-send-email-xose.vazquez@gmail.com>>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi;

The changes needed would be :


/*
         * Pillar Data controller family
         *
         * Maintainer : Srinivasan Ramani
         * Mail : srinivas.ramani@oracle.com
         */
        {
                .vendor        = "^Pillar(  )?$",
                .product       = "^Axiom"
                .getuid        = DEFAULT_GETUID,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = GROUP_BY_PRIO,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = TUR,
                .prio_name     = PRIO_ALUA,
        },
        /*
         * Oracle FS controller family
         *
         * Maintainer : Srinivasan Ramani
         * Mail : srinivas.ramani@oracle.com
         */
        {
                .vendor        = "^Oracle(  )?$",
                .product       = "^Oracle FS",
                .getuid        = DEFAULT_GETUID,
                .features      = DEFAULT_FEATURES,
                .hwhandler     = DEFAULT_HWHANDLER,
                .selector      = DEFAULT_SELECTOR,
                .pgpolicy      = GROUP_BY_PRIO,
                .pgfailback    = FAILBACK_UNDEF,
                .rr_weight     = RR_WEIGHT_NONE,
                .no_path_retry = NO_PATH_RETRY_UNDEF,
                .minio         = DEFAULT_MINIO,
                .checker_name  = TUR,
                .prio_name     = PRIO_ALUA,
        },



With Best Regards
Srini
-----Original Message-----
From: Xose Vazquez Perez [mailto:xose.vazquez@gmail.com] 
Sent: Saturday, July 30, 2016 2:16 PM
Cc: Xose Vazquez Perez; Srinivasan Ramani; Christophe Varoqui; device-mapper development
Subject: [PATCH] multipath-tools: Pillar/Axiom supports failback=immediate

ALUA device with support for preferred_path. Confirmed by the vendor's utils and docs:
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

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c index fe4a51f..ed23c92 100644
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
