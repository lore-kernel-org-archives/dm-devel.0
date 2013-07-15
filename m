From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/29] multipath: Add 'Datacore Virtual Disk' to
	internal hardware table
Date: Mon, 15 Jul 2013 15:00:12 +0200
Message-ID: <1373893230-26077-12-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
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

Add 'Datacore Virtual Disk' to internal hardware table.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c317cde..ce12cbb 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1107,6 +1107,19 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
+	{
+		.vendor	       = "DataCore",
+		.product       = "Virtual Disk",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
+		.prio_args     = NULL,
+	},
 	/*
 	 * EOL
 	 */
-- 
1.7.10.4
