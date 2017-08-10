From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add Xiotech iglu blaze arrays
	to hwtable
Date: Thu, 10 Aug 2017 21:18:24 +0200
Message-ID: <20170810191824.9181-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bcd24b3..9d3df11 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1045,6 +1045,13 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 12,
 	},
+	{
+		/* iglu blaze family */
+		.vendor        = "(XIOTECH|XIOtech)",
+		.product       = "IGLU DISK",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Violin Memory
 	 */
-- 
2.13.4
