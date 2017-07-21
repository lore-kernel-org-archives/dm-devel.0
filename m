From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add/change fujitsu arrays
Date: Fri, 21 Jul 2017 21:06:31 +0200
Message-ID: <20170721190631.6665-1-xose.vazquez@gmail.com>
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

E[234]000 are a/a asymmetric with alua support
E[68]000  are a/a symmetric

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8a0ebd2..c2ed171 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -310,12 +310,18 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		.vendor        = "FUJITSU",
-		.product       = "E[248]000",
+		.product       = "E[234]000",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 10,
 		.prio_name     = PRIO_ALUA,
 	},
+	{
+		.vendor        = "FUJITSU",
+		.product       = "E[68]000",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 10,
+	},
 	/*
 	 * Hitachi
 	 *
-- 
2.13.3
