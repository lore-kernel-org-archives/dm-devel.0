From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 4/4] multipath-tools: Add rbd to the hwtable
Date: Tue,  5 Jul 2016 03:12:33 -0500
Message-ID: <1467706353-16878-5-git-send-email-mchristi@redhat.com>
References: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Add rbd to hwtable. These defaults are for the HA type of setup
supported by the checker. We do no support features like multibus
at the dm-multipath level yet.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/hwtable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6116124..27a6ff1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1206,6 +1206,21 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = 30,
 		.minio         = 128,
 	},
+	{
+		.vendor        = "Ceph",
+		.product       = "RBD",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.pgpolicy      = FAILOVER,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = NO_PATH_RETRY_FAIL,
+		.checker_name  = RBD,
+		.user_friendly_names = USER_FRIENDLY_NAMES_ON,
+		.uid_attribute = "ID_UID",
+		.prio_name     = PRIO_CONST,
+		.deferred_remove = DEFERRED_REMOVE_ON,
+	},
+
 	/*
 	 * EOL
 	 */
-- 
2.5.5
