From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix up Apple controller family
Date: Tue,  7 Jun 2016 19:54:23 +0200
Message-ID: <1465322063-21705-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Fix regex and delete space.

Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 66b5123..bcc9973 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -43,8 +43,8 @@ static struct hwentry default_hw[] = {
 	 * Mail : g.shyamsundar@yahoo.co.in
 	 */
 	{
-		.vendor        = "APPLE*",
-		.product       = "Xserve RAID ",
+		.vendor        = "APPLE.*",
+		.product       = "Xserve RAID",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
-- 
2.5.5
