From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v3] multipath-tools: Add Dell SC name and
	maintainer
Date: Tue, 16 Aug 2016 16:08:39 +0200
Message-ID: <1471356519-8882-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean McGinnis <sean_mcginnis@dell.com>
List-Id: dm-devel.ids

from: Sean McGinnis <sean_mcginnis@dell.com>

Compellent Storage Center is now Dell SC Series storage. Added
contact name for maintenance.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Sean McGinnis <sean_mcginnis@dell.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2 had spaces instead tabs

 libmultipath/hwtable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 11cf498..57be385 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -205,6 +205,12 @@ static struct hwentry default_hw[] = {
 	 * DELL
 	 */
 	{
+		/*
+		 * Dell SC Series, formerly Compellent
+		 *
+		 * Maintainer : Sean McGinnis
+		 * Mail : sean_mcginnis@dell.com
+		 */
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = MULTIBUS,
-- 
2.7.4
