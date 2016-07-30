From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 10/18] multipath-tools: add Nexsan E-Series and
	SATABeast/SATABoy to hwtable
Date: Sat, 30 Jul 2016 02:28:18 +0200
Message-ID: <1469838506-15689-10-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Based on documentation provided by the manufacturer:
https://drive.google.com/file/d/0B_B6YmEmO7cDeGRXeG85MXFVMEU

Redhat 6:
vendor                  "NEXSAN "
product                 "NXS-B0.*|SATAB.*"
getuid_callout          "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
path_grouping_policy    group_by_prio
prio                    alua
path_checker            directio
path_selector           "round-robin 0"
hardware_handler        "0"
rr_weight               priorities
no_path_retry           15
failback                immediate

SUSE 11 (including OpenSUSE):
vendor                  "NEXSAN "
product                 "NXS-B0.*|SATAB.*"
getuid_callout          "/lib/udev/scsi_id --whitelisted -g -u -d /dev/%n"
path_grouping_policy    group_by_prio
prio                    alua
path_checker            directio
path_selector           "round-robin 0"
hardware_handler        "0"
rr_weight               priorities
no_path_retry           15
failback                immediate

Debian Wheezy:
vendor                  "NEXSAN "
product                 "NXS-B0.*|SATAB.*"
path_grouping_policy    group_by_prio
prio                    alua
path_checker            directio
path_selector           "round-robin 0"
hardware_handler        "1 alua"
rr_weight               priorities
no_path_retry           5
failback                immediate

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 4d5717a..45a6332 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -841,6 +841,18 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.fast_io_fail  = 1,
 	},
+	/*
+	 * Nexsan
+	 */
+	{
+		.vendor        = "NEXSAN",
+		.product       = "(NXS-B0.*|SATAB.*)",
+		.selector      = "round-robin 0",
+		.prio_name     = PRIO_ALUA,
+		.hwhandler     = "1 alua",
+		.rr_weight     = RR_WEIGHT_PRIO,
+		.no_path_retry = 15,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.7.4
