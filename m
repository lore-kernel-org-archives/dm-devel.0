From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 9/9] multipath-tools: minor edit in hwtable
Date: Tue, 21 Jun 2016 02:36:04 +0200
Message-ID: <1466469364-14446-9-git-send-email-xose.vazquez@gmail.com>
References: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
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

delete empty lines and correct a NEC product.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 47a2e61..fb334ab 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -189,7 +189,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
-
 	{
 		/* HP SVSP */
 		.vendor        = "HP",
@@ -205,7 +204,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
-
 	{
 		/* HP Smart Array */
 		.vendor        = "HP",
@@ -861,7 +859,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
-
 	/*
 	 * SGI
 	 */
@@ -910,7 +907,7 @@ static struct hwentry default_hw[] = {
 	 * NEC
 	 */
 	{
-		/* Storage M Series */
+		/* M-Series */
 		.vendor        = "NEC",
 		.product       = "DISK ARRAY",
 		.features      = DEFAULT_FEATURES,
-- 
2.5.5
