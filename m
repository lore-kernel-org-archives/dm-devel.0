From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 07/17] libmultipath: add missing hwe mpe
	variable merges
Date: Wed,  5 Feb 2020 12:58:10 -0600
Message-ID: <1580929100-32572-8-git-send-email-bmarzins@redhat.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

There were some variables in the hwe and mpe structs that weren't being
merged by merge_hwe() and merge_mpe().

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 20e3b8bf..85626e96 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -372,6 +372,10 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(san_path_err_threshold);
 	merge_num(san_path_err_forget_rate);
 	merge_num(san_path_err_recovery_time);
+	merge_num(marginal_path_err_sample_time);
+	merge_num(marginal_path_err_rate_threshold);
+	merge_num(marginal_path_err_recheck_gap_time);
+	merge_num(marginal_path_double_failed_time);
 
 	snprintf(id, sizeof(id), "%s/%s", dst->vendor, dst->product);
 	reconcile_features_with_options(id, &dst->features,
@@ -397,6 +401,7 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 	if (dst->prkey_source == PRKEY_SOURCE_NONE &&
 	    src->prkey_source != PRKEY_SOURCE_NONE) {
 		dst->prkey_source = src->prkey_source;
+		dst->sa_flags = src->sa_flags;
 		memcpy(&dst->reservation_key, &src->reservation_key,
 		       sizeof(dst->reservation_key));
 	}
@@ -413,6 +418,9 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 	merge_num(deferred_remove);
 	merge_num(delay_watch_checks);
 	merge_num(delay_wait_checks);
+	merge_num(san_path_err_threshold);
+	merge_num(san_path_err_forget_rate);
+	merge_num(san_path_err_recovery_time);
 	merge_num(marginal_path_err_sample_time);
 	merge_num(marginal_path_err_rate_threshold);
 	merge_num(marginal_path_err_recheck_gap_time);
-- 
2.17.2
