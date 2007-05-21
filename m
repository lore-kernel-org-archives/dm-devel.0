From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 12/21] [hwtable] Update SGI entries
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.89C61D44CC@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Add new entry for SGI Infinite Storage machines; and we should also
use the 'RDAC' path checker for SGI storage.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9354a8e..5e04d95 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -511,9 +511,24 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = TUR,
+		.checker_name  = RDAC,
+	},
+	{
+		.vendor        = "SGI",
+		.product       = "IS.*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
 	},
 	/*
 	 * STK arrays
-- 
1.4.3.4
