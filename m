From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add Pure Storage device to
	hardware table
Date: Mon, 13 Jun 2016 18:30:37 +0200
Message-ID: <1465835437-18350-1-git-send-email-xose.vazquez@gmail.com>
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

based on documentation provided by the manufacturer:
https://support.purestorage.com/@api/deki/files/1733/=Pure_Storage_Oracle_DB_Best_Practices.pdf?revision=2

vendor                  "PURE"
product                 "FlashArray"	(extracted from outputs)
path_selector           "round-robin 0"
path_grouping_policy    multibus
rr_min_io               1
path_checker            tur
fast_io_fail_tmo        10
dev_loss_tmo            30

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a126b7c..c4258e1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1195,6 +1195,22 @@ static struct hwentry default_hw[] = {
 		.minio         = 128,
 	},
 	/*
+	 * Pure Storage, Inc.
+	 *
+	 * Maintainer : Christophe Varoqui
+	 * Mail : christophe.varoqui@opensvc.com
+	 */
+	{
+		.vendor        = "PURE",
+		.product       = "FlashArray",
+		.selector      = "round-robin 0",
+		.pgpolicy      = MULTIBUS,
+		.minio         = 1,
+		.checker_name  = TUR,
+		.fast_io_fail  = 10,
+		.dev_loss      = 30,
+	},
+	/*
 	 * EOL
 	 */
 	{
-- 
2.5.5
