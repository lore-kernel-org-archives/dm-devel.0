From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/5] multipath-tools: add XIOtech/Magnitude to
	hardware table
Date: Sun, 24 Sep 2017 01:38:59 +0200
Message-ID: <20170923233903.24792-2-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b018ddf..2400473 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1063,6 +1063,13 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
 	},
+	{
+		/* Magnitude family */
+		.vendor        = "(XIOTECH|XIOtech)",
+		.product       = "Magnitude",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Violin Memory
 	 */
-- 
2.13.5
