From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 03/15] multipath-tools: replace (|) with [] when
	there is one element
Date: Wed, 10 Aug 2016 18:20:26 +0200
Message-ID: <1470846038-6590-3-git-send-email-xose.vazquez@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 90c9b5b..ba87ed2 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -122,7 +122,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* MSA 1040/2040 family */
 		.vendor        = "HP",
-		.product       = "MSA (1|2)040 SA(N|S)",
+		.product       = "MSA [12]040 SA[NS]",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 18,
-- 
2.7.4
