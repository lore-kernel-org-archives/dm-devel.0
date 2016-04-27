From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/57] Add LIO-ORG/SUSE RBD backend hardware
	defaults
Date: Wed, 27 Apr 2016 13:10:08 +0200
Message-ID: <1461755458-29225-8-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

The LIO-ORG RBD backend always supports ALUA, and should be assigned
the correct values for multipathing.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 4549268..e57a69a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1156,6 +1156,20 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
+		.vendor	       = "(LIO-ORG|SUSE)",
+		.product       = "RBD",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 alua",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 12,
+		.checker_name  = TUR,
+		.minio         = 100,
+		.prio_name     = PRIO_ALUA,
+		.prio_args     = NULL,
+	},
+	{
 		.vendor	       = "DataCore",
 		.product       = "SANmelody",
 		.features      = DEFAULT_FEATURES,
-- 
2.6.6
