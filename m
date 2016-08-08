From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 4/4] multipath-tools: Add rbd to the hwtable
Date: Mon,  8 Aug 2016 07:01:50 -0500
Message-ID: <1470657710-28081-5-git-send-email-mchristi@redhat.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
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

Changes since v1:
1. Drop settings that were defaults and follow template.
2. Drop ID_UID use.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/hwtable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8c074f9..c307477 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -839,6 +839,21 @@ static struct hwentry default_hw[] = {
 		.flush_on_last_del = FLUSH_ENABLED,
 		.dev_loss      = 30,
 	},
+	{
+	/*
+	 * Red Hat
+	 *
+	 * Maintainer: Mike Christie
+	 * Mail: mchristi@redhat.com
+	 */
+		.vendor        = "Ceph",
+		.product       = "RBD",
+		.pgpolicy      = FAILOVER,
+		.no_path_retry = NO_PATH_RETRY_FAIL,
+		.checker_name  = RBD,
+		.deferred_remove = DEFERRED_REMOVE_ON,
+	},
+
 	/*
 	 * Tegile Systems
 	 */
-- 
2.7.2
