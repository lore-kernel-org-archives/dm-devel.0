From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: document why dev_loss_tmo is
	set to infinity for HPE 3PAR
Date: Wed, 12 Dec 2018 17:58:33 +0100
Message-ID: <20181212165833.12407-1-xose.vazquez@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

It's needed by Peer Persistence, documented in SLES and RHEL guides:
https://support.hpe.com/hpsc/doc/public/display?docId=a00053835
https://support.hpe.com/hpsc/doc/public/display?docId=c04448818

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d3a8d9b..543bacd 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -116,6 +116,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 18,
 		.fast_io_fail  = 10,
+		/* infinity is needed by Peer Persistence */
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 	},
 	{
-- 
2.19.2
