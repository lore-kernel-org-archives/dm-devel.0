From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 24/33] libmultipath: select_action: check special
	features separately
Date: Tue, 28 Feb 2017 17:23:20 +0100
Message-ID: <20170228162329.14517-25-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

The features queue_if_no_path and retain_attached_hw_handler are
treated separately in libmultipath. Compare these features by looking
at the respective flags, and ignore them when comparing the "features"
string. assemble_map() does the ssame thing when constructing the
features string for device mapper.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index f164801b..fb5a5a92 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -395,6 +395,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 {
 	struct multipath * cmpp;
 	struct multipath * cmpp_by_name;
+	char * mpp_feat, * cmpp_feat;
 
 	cmpp = find_mp_by_wwid(curmp, mpp->wwid);
 	cmpp_by_name = find_mp_by_alias(curmp, mpp->alias);
@@ -455,11 +456,11 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			mpp->alias);
 		return;
 	}
-	if (!mpp->no_path_retry &&
-	    (strlen(cmpp->features) != strlen(mpp->features) ||
-	     strcmp(cmpp->features, mpp->features))) {
+
+	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
+	    mpp->no_path_retry != cmpp->no_path_retry) {
 		mpp->action =  ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (features change)",
+		condlog(3, "%s: set ACT_RELOAD (no_path_retry change)",
 			mpp->alias);
 		return;
 	}
@@ -472,6 +473,31 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			mpp->alias);
 		return;
 	}
+
+	if (mpp->retain_hwhandler != RETAIN_HWHANDLER_UNDEF &&
+	    mpp->retain_hwhandler != cmpp->retain_hwhandler) {
+		mpp->action = ACT_RELOAD;
+		condlog(3, "%s: set ACT_RELOAD (retain_hwhandler change)",
+			mpp->alias);
+		return;
+	}
+
+	cmpp_feat = STRDUP(cmpp->features);
+	mpp_feat = STRDUP(mpp->features);
+	if (cmpp_feat && mpp_feat) {
+		remove_feature(&mpp_feat, "queue_if_no_path");
+		remove_feature(&mpp_feat, "retain_attached_hw_handler");
+		remove_feature(&cmpp_feat, "queue_if_no_path");
+		remove_feature(&cmpp_feat, "retain_attached_hw_handler");
+		if (strncmp(mpp_feat, cmpp_feat, PARAMS_SIZE)) {
+			mpp->action =  ACT_RELOAD;
+			condlog(3, "%s: set ACT_RELOAD (features change)",
+				mpp->alias);
+		}
+	}
+	FREE(cmpp_feat);
+	FREE(mpp_feat);
+
 	if (!cmpp->selector || strncmp(cmpp->selector, mpp->selector,
 		    strlen(mpp->selector))) {
 		mpp->action = ACT_RELOAD;
-- 
2.11.0
