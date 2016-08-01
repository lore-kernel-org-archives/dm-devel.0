From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: Pillar/Axiom supports
	failback=immediate
Date: Mon,  1 Aug 2016 16:18:56 +0200
Message-ID: <1470061136-7367-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

ALUA device with support for preferred_path. Confirmed by
the vendor's utils and docs: https://docs.oracle.com/cd/E35311_02/E28846_08/E41503_01/conPathSelection.html
and also the vendor: https://marc.info/?l=dm-devel&m=147004019524938

Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d53cd34..6655c98 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -597,7 +597,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "Pillar",
 		.product       = "Axiom.*",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-- 
2.7.4
