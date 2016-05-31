From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 6/7] libmultipath: add Huawei Storage default
	config
Date: Tue, 31 May 2016 18:16:49 -0500
Message-ID: <1464736610-20027-7-git-send-email-bmarzins@redhat.com>
References: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Add a default device config for the Huawei XSG1 arrary. This config
comes from Huawei.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 883cd98..66b5123 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1166,6 +1166,15 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = 60,
 		.prio_args     = NULL,
 	},
+	{
+		.vendor        = "HUAWEI",
+		.product       = "XSG1",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.checker_name  = TUR,
+	},
 	/*
 	 * EOL
 	 */
-- 
1.8.3.1
