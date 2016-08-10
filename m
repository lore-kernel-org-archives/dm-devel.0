From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 14/15] multipath-tools: replace queue-length by
	default selector
Date: Wed, 10 Aug 2016 18:20:37 +0200
Message-ID: <1470846038-6590-14-git-send-email-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

service-time is more advanced, and it works better in asymmetric and
asymmetric environments.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bc2d407..edfd8fe 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -198,7 +198,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "XtremIO",
 		.product       = "XtremApp",
-		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
@@ -823,7 +822,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "PURE",
 		.product       = "FlashArray",
-		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.fast_io_fail  = 10,
-- 
2.7.4
