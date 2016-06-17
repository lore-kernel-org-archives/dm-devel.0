From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 01/10] multipath-tools: add VIOLIN/CONCERTO
	ARRAY to hardware table
Date: Fri, 17 Jun 2016 16:52:39 +0200
Message-ID: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

based on documentation provided by manufacturer:
https://drive.google.com/open?id=0B_B6YmEmO7cDQlMzc1BsaUxZRVU

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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 66b5123..726ee3b 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1176,6 +1176,22 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	/*
+	 * Violin Memory, Inc.
+	 */
+	{
+		.vendor        = "VIOLIN",
+		.product       = "CONCERTO ARRAY",
+		.selector      = "round-robin 0",
+		.pgpolicy      = MULTIBUS,
+		.prio_name     = PRIO_ALUA,
+		.checker_name  = TUR,
+		.minio         = 100,
+		.rr_weight     = RR_WEIGHT_PRIO,
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
