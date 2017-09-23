From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 5/5] multipath-tools: add AccelStor/NeoSapphire
	to hardware table
Date: Sun, 24 Sep 2017 01:39:03 +0200
Message-ID: <20170923233903.24792-6-xose.vazquez@gmail.com>
References: <20170923233903.24792-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170923233903.24792-1-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bd06d08..efa81ba 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1170,6 +1170,16 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	/*
+	 * AccelStor
+	 */
+	{
+		/* NeoSapphire */
+		.vendor        = "AStor",
+		.product       = "NeoSapphire",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
+	/*
 	 * EOL
 	 */
 	{
-- 
2.13.5
