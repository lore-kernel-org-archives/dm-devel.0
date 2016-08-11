From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 11/11] multipath-tools: modify product regex in
	HDS devices
Date: Thu, 11 Aug 2016 20:33:38 +0200
Message-ID: <1470940418-4604-2-git-send-email-xose.vazquez@gmail.com>
References: <1470940418-4604-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470940418-4604-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Matthias Rudolph <Matthias.Rudolph@hds.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

regex for product="DF" is tooooo wide.
Also changed for VSP to "^OPEN-"

I asked Matthias before make this change.

Cc: Matthias Rudolph <Matthias.Rudolph@hds.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 62633b1..a69002f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -278,14 +278,14 @@ static struct hwentry default_hw[] = {
 	{
 		/* USP-V, HUS VM, VSP, VSP G1000 and VSP GX00 families */
 		.vendor        = "(HITACHI|HP)",
-		.product       = "OPEN-",
+		.product       = "^OPEN-",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		/* AMS 2000 and HUS 100 families */
 		.vendor        = "HITACHI",
-		.product       = "DF",
+		.product       = "^DF",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-- 
2.7.4
