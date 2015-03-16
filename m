From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/78] Update hwtable for EMC XtremIO
Date: Mon, 16 Mar 2015 13:36:17 +0100
Message-ID: <1426509425-15978-31-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ead4d48..13611fe 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -289,6 +289,19 @@ static struct hwentry default_hw[] = {
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
+	{
+		.vendor        = "XtremIO",
+		.product       = "XtremApp",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 5,
+		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
+		.prio_args     = NULL,
+	},
 	/*
 	 * Fujitsu controller family
 	 *
-- 
1.8.4.5
