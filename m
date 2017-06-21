From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 04/11] libmultipath: merge_hwe: fix
	queue_if_no_path logic
Date: Wed, 21 Jun 2017 17:06:23 +0200
Message-ID: <20170621150630.25773-5-mwilck@suse.com>
References: <20170621150630.25773-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170621150630.25773-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

The logic applied here should match the logic in select_features().
This is achieved by calling reconcile_features_with_options().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 60e345b3..a9b3eda2 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -25,6 +25,7 @@
 #include "prio.h"
 #include "devmapper.h"
 #include "mpath_cmd.h"
+#include "propsel.h"
 
 static int
 hwe_strmatch (struct hwentry *hwe1, struct hwentry *hwe2)
@@ -318,6 +319,8 @@ set_param_str(char * str)
 static int
 merge_hwe (struct hwentry * dst, struct hwentry * src)
 {
+	int id_len;
+	char *id;
 	merge_str(vendor);
 	merge_str(product);
 	merge_str(revision);
@@ -353,15 +356,14 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(san_path_err_forget_rate);
 	merge_num(san_path_err_recovery_time);
 
-	/*
-	 * Make sure features is consistent with
-	 * no_path_retry
-	 */
-	if (dst->no_path_retry == NO_PATH_RETRY_FAIL)
-		remove_feature(&dst->features, "queue_if_no_path");
-	else if (dst->no_path_retry != NO_PATH_RETRY_UNDEF)
-		add_feature(&dst->features, "queue_if_no_path");
-
+	id_len = strlen(dst->vendor) + strlen(dst->product) + 2;
+	id = MALLOC(id_len);
+	if (id != NULL)
+		snprintf(id, id_len, "%s/%s", dst->vendor, dst->product);
+	reconcile_features_with_options(id, &dst->features,
+					&dst->no_path_retry,
+					&dst->retain_hwhandler);
+	FREE(id);
 	return 0;
 }
 
-- 
2.13.1
