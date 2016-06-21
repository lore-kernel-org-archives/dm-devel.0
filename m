From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/9] multipath-tools: remove spaces in S390
	devices
Date: Tue, 21 Jun 2016 02:35:57 +0200
Message-ID: <1466469364-14446-2-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fb38320..206d1fd 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -611,7 +611,7 @@ static struct hwentry default_hw[] = {
 		/* IBM S/390 ECKD DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
-		.bl_product       = "S/390.*",
+		.bl_product    = "S/390.*",
 		.uid_attribute = "ID_UID",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
@@ -627,7 +627,7 @@ static struct hwentry default_hw[] = {
 		/* IBM S/390 FBA DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
-		.bl_product       = "S/390.*",
+		.bl_product    = "S/390.*",
 		.uid_attribute = "ID_UID",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
-- 
2.5.5
