From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove NO_PATH_RETRY_FAIL from
	hwtable
Date: Mon, 21 Nov 2016 12:39:31 +0100
Message-ID: <20161121113931.4255-1-xose.vazquez@gmail.com>
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

It's the default value.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7619994..c46b072 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -544,7 +544,6 @@ static struct hwentry default_hw[] = {
 		/* FlashSystem 710/720/810/820/840/900 */
 		.vendor        = "IBM",
 		.product       = "FlashSystem",
-		.no_path_retry = NO_PATH_RETRY_FAIL,
 		.pgpolicy      = MULTIBUS,
 	},
 	{
@@ -918,7 +917,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "Ceph",
 		.product       = "RBD",
-		.no_path_retry = NO_PATH_RETRY_FAIL,
 		.checker_name  = RBD,
 		.deferred_remove = DEFERRED_REMOVE_ON,
 	},
-- 
2.10.2
