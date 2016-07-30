From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 09/18] multipath-tools: add VIOLIN/ "SAN ARRAY"
	and "SAN ARRAY ALUA" to hwtable
Date: Sat, 30 Jul 2016 02:28:17 +0200
Message-ID: <1469838506-15689-9-git-send-email-xose.vazquez@gmail.com>
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
https://drive.google.com/open?id=0B_B6YmEmO7cDQlMzc1BsaUxZRVU

* For "SAN ARRAY ALUA":

- Red Hat Enterprise Linux 6.x:
vendor "VIOLIN"
product "SAN ARRAY ALUA"
path_grouping_policy group_by_prio
getuid_callout "/lib/udev/scsi_id --whitelisted --replace- whitespace --page=0x80 --device=/dev/%n"
prio "alua"
path_checker tur
path_selector "round-robin 0"
hardware_handler "1 alua"
failback immediate
rr_weight uniform
no_path_retry fail
rr_min_io_rq 4

- SUSE Enterprise Linux 11 SP3:
vendor "VIOLIN"
product "SAN ARRAY ALUA"
path_grouping_policy group_by_prio
prio "alua"
path_checker tur
path_selector "round-robin 0"
hardware_handler "0"
failback immediate
no_path_retry 100
detect_prio yes

* For "SAN ARRAY":

- Red Hat Enterprise Linux 6.x:
vendor "VIOLIN"
product "SAN ARRAY"
path_grouping_policy group_by_serial
getuid_callout "/lib/udev/scsi_id --whitelisted -- replace-whitespace --page=0x80 --device=/dev/%n"
path_checker tur
path_selector "round-robin 0"
hardware_handler "0"
failback immediate
rr_weight uniform
no_path_retry fail
rr_min_io_rq 4

- SUSE Enterprise Linux 11 SP3:
vendor "VIOLIN"
product "SAN ARRAY"
path_grouping_policy group_by_serial
path_checker tur
path_selector "round-robin 0"
hardware_handler "0"
failback immediate
rr_weight uniform
no_path_retry 100

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1845881..4d5717a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -772,6 +772,21 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.no_path_retry = 300,
 	},
+	{
+		.vendor        = "VIOLIN",
+		.product       = "SAN ARRAY",
+		.pgpolicy      = GROUP_BY_SERIAL,
+		.selector      = "round-robin 0",
+		.no_path_retry = 100,
+	},
+	{
+		.vendor        = "VIOLIN",
+		.product       = "SAN ARRAY ALUA",
+		.prio_name     = PRIO_ALUA,
+		.selector      = "round-robin 0",
+		.hwhandler     = "1 alua",
+		.no_path_retry = 100,
+	},
 	/*
 	 * Infinidat
 	 */
-- 
2.7.4
