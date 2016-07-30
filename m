From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 07/18] multipath-tools: add EMC/Celerra to hwtable
Date: Sat, 30 Jul 2016 02:28:15 +0200
Message-ID: <1469838506-15689-7-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids

Based on documentation of the manufacturer:
http://www.emc.com/collateral/TechnicalDocument/docu5128.pdf

vendor "EMC"
product "Celerra"
path_grouping_policy "multibus"
path_checker "tur"
no_path_retry "30"

Cc: Edward Goggin <egoggin@emc.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6ea20b2..d1e9c81 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -186,6 +186,12 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
+	{
+		.vendor        = "EMC",
+		.product       = "Celerra",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
 	/*
 	 * DELL
 	 */
-- 
2.7.4
