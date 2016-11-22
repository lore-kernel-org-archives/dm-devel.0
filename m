From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: identify DataCore SANsymphony
	in hwtable
Date: Tue, 22 Nov 2016 21:05:16 +0100
Message-ID: <20161122200516.5854-1-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index eb7a5a0..c0bfa75 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -884,6 +884,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
+		/* SANsymphony */
 		.vendor	       = "DataCore",
 		.product       = "Virtual Disk",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.10.2
