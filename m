From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add VIOLIN arrays to hardware
	table
Date: Sat, 15 Oct 2016 13:50:23 +0200
Message-ID: <20161015115023.6773-1-xose.vazquez@gmail.com>
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

Based on documentation provided by the manufacturer:
https://drive.google.com/open?id=0B_B6YmEmO7cDQlMzc1BsaUxZRVU

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index aca46ab..e34032d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -944,6 +944,32 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 12,
 	},
+	/*
+	 * Violin Memory
+	 */
+	{
+		/* V3000 / V6000 Series */
+		.vendor        = "VIOLIN",
+		.product       = "SAN ARRAY$",
+		.pgpolicy      = GROUP_BY_SERIAL,
+		.no_path_retry = 30,
+	},
+	{
+		.vendor        = "VIOLIN",
+		.product       = "SAN ARRAY ALUA",
+		.hwhandler     = "1 alua",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
+	{
+		/* FSP 7000 family */
+		.vendor        = "VIOLIN",
+		.product       = "CONCERTO ARRAY",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.10.1
