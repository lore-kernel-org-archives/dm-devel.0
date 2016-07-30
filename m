From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 04/18] multipath-tools: add NetApp/SolidFir to
	hwtable
Date: Sat, 30 Jul 2016 02:28:12 +0200
Message-ID: <1469838506-15689-4-git-send-email-xose.vazquez@gmail.com>
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

Based on info provided directly by the manufacturer:
http://www.solidfire.com/
http://www.netapp.com/us/products/storage-systems/solidfire/

Redhat 7+:
vendor "SolidFir"
product "SSD SAN"
path_grouping_policy multibus
path_checker tur
hardware_handler "0"
failback immediate
rr_weight uniform
rr_min_io 10
rr_min_io_rq 10
features "0"
no_path_retry 24
prio const

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 3952b42..bd0bd8c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -526,6 +526,15 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
+	{
+		/* SolidFir */
+		.vendor        = "SolidFir",
+		.product       = "SSD SAN",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 24,
+		.minio         = 10,
+		.minio_rq      = 10,
+	},
 	/*
 	 * Nexenta
 	 *
-- 
2.7.4
