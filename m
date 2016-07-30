From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 14/18] multipath-tools: change path grouping
	policy for EUROLOGC/FC2502
Date: Sat, 30 Jul 2016 02:28:22 +0200
Message-ID: <1469838506-15689-14-git-send-email-xose.vazquez@gmail.com>
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

No prio defined and .pgpolicy=GROUP_BY_PRIO are an impossible combination.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ebad919..728680a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -256,6 +256,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "EUROLOGC",
 		.product       = "FC2502",
 		.pgfailback    = FAILBACK_UNDEF,
+		.pgpolicy      = MULTIBUS,
 	},
 	{
 		.vendor        = "FUJITSU",
-- 
2.7.4
