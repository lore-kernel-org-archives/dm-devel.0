From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 08/11] multipath-tools: add KOVE/XPD to hwtable
Date: Thu, 11 Aug 2016 20:32:24 +0200
Message-ID: <1470940345-4441-8-git-send-email-xose.vazquez@gmail.com>
References: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Nick Russo <nick.russo@kove.net>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Info provided directly by the manufacturer: http://kove.net/xpd

Cc: Nick Russo <nick.russo@kove.net>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 063535c..8114d3e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -839,6 +839,15 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RBD,
 		.deferred_remove = DEFERRED_REMOVE_ON,
 	},
+	/*
+	 * Kove
+	 */
+	{
+		.vendor        = "KOVE",
+		.product       = "XPD",
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.7.4
