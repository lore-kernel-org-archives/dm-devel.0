From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add VIOLIN/CONCERTO ARRAY to
	hardware table
Date: Fri, 10 Jun 2016 15:56:07 +0200
Message-ID: <1465566967-8417-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

based on documentation provided by manufacturer:
https://drive.google.com/open?id=0B_B6YmEmO7cDQlMzc1BsaUxZRVU

- Red Hat Enterprise Linux 5.x for Concerto 7x00
vendor "VIOLIN"
product "CONCERTO ARRAY"
path_grouping_policy group_by_prio
getuid_callout "/sbin/scsi_id -p 0x80 -g -u -s /block/%n"
prio_callout "/sbin/mpath_prio_alua /dev/%n"
path_checker tur
path_selector "round-robin 0"
hardware_handler "1 alua"
failback immediate
rr_weight uniform
no_path_retry 300
rr_min_io 4
features "1 queue_if_no_path"

- Red Hat Enterprise Linux 6.x for Concerto 7100/7200
vendor "VIOLIN"
product "CONCERTO ARRAY"
path_grouping_policy multibus
getuid_callout "/lib/udev/scsi_id -g -u /dev/%n"
path_checker tur
path_selector "round-robin 0"
prio alua
rr_min_io 100
rr_weight priorities
failback immediate
features "1 queue_if_no_path"

- Red Hat Enterprise Linux 6.x for Violin 7300
vendor "VIOLIN"
product "CONCERTO ARRAY"
path_selector "round-robin 0"
path_grouping_policy multibus
getuid_callout "/lib/udev/scsi_id -p 0x80 -g -u /dev/%n"
prio alua
path_checker tur
rr_min_io 100
rr_weight priorities
failback immediate
features "1 queue_if_no_path"
no_path_retry 300

- Red Hat Enterprise Linux 7.x for Violin 7300
vendor "VIOLIN"
product "CONCERTO ARRAY"
path_selector "round-robin 0"
path_grouping_policy multibus
prio alua
path_checker tur
rr_min_io 100
rr_weight priorities
failback immediate
features "1 queue_if_no_path"
no_path_retry 300

- SUSE Enterprise Linux 11 SP3 for Violin 7300
vendor "VIOLIN"
product "CONCERTO ARRAY"
path_selector "round-robin 0"
path_grouping_policy multibus
getuid_callout "/lib/udev/scsi_id -p 0x80 -g -u /dev/%n"
prio "alua"
path_checker "tur"
rr_min_io 100
rr_weight priorities
failback immediate
features "1 queue_if_no_path"
no_path_retry 300

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 66b5123..a9cd080 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1176,6 +1176,25 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	/*
+	 * Violin Memory, Inc.
+	 *
+	 * Maintainer : Christophe Varoqui
+	 * Mail : christophe.varoqui@opensvc.com
+	 */
+	{
+		.vendor        = "VIOLIN",
+		.product       = "CONCERTO ARRAY",
+		.selector      = "round-robin 0",
+		.pgpolicy      = MULTIBUS,
+		.prio_name     = PRIO_ALUA,
+		.checker_name  = TUR,
+		.minio         = 100,
+		.rr_weight     = priorities,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.features      = "1 queue_if_no_path",
+		.no_path_retry = 300,
+	},
+	/*
 	 * EOL
 	 */
 	{
-- 
2.5.5
