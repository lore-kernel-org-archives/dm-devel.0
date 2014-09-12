From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/6] Add support for EMC XtremIO
Date: Fri, 12 Sep 2014 12:44:48 -0500
Message-ID: <1410543892-29826-3-git-send-email-bmarzins@redhat.com>
References: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
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
Cc: Vincent Chen <vincent.y.chen@emc.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This is a built-in configuration I got from EMC for the XtremIO storage
array.

Signed-off-by: Vincent Chen <vincent.y.chen@emc.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b774453..a9dde7f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1121,6 +1121,19 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
+	{
+		.vendor        = "XtremIO",
+		.product       = "XtremApp",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = "queue-length 0",
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.checker_name  = DIRECTIO,
+		.fast_io_fail  = 15,
+		.prio_name     = DEFAULT_PRIO,
+		.prio_args     = NULL,
+	},
 	/*
 	 * EOL
 	 */
-- 
1.8.3.1
