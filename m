From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 15/18] multipath-tools: add official name to
	Huawei devices
Date: Sat, 30 Jul 2016 02:28:23 +0200
Message-ID: <1469838506-15689-15-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
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

from http://www.t10.org/ftp/t10/vendorid.txt
Its official name is: "HUASY"

Just in case.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 728680a..a9e65fc 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -755,7 +755,7 @@ static struct hwentry default_hw[] = {
 	 * Huawei
 	 */
 	{
-		.vendor        = "HUAWEI",
+		.vendor        = "(HUAWEI|HUASY)",
 		.product       = "XSG1",
 		.pgpolicy      = MULTIBUS,
 	},
-- 
2.7.4
