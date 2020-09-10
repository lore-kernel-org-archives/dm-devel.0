From: mwilck@suse.com
Subject: [PATCH] libmultipath: setup_map(): don't break multipath
	attributes
Date: Thu, 10 Sep 2020 21:50:50 +0200
Message-ID: <20200910195050.7538-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng@huawei.com
Cc: linfeilong@huawei.com, dm-devel@redhat.com, Zhiqiang Liu <liuzhiqiang26@huawei.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

setup_map() is called both for new maps (e.g. from coalesce_paths())
and existing maps (e.g. from reload_map(), resize_map()). In the former
case, the map will be removed from global data structures, so incomplete
initialization is not an issue. But In the latter case, removal isn't
generally possible. We expect that mpp->features, mpp->hwhandler,
mpp->selector have been initialized and are are non-NULL. We must make sure
not to break this assumption because of an error in this setup_map()
invocation. As these properties aren't likely to change during an update
operation, saving and restoring them is better than leaving the map
improperly initialized.
---

This is supposed to be applied on top of lixiaokeng's patch
"libmultipath: check whether mpp->features is NUll in setup_map".

 libmultipath/configure.c | 28 +++++++++++++++++++++++++---
 libmultipath/util.h      |  7 +++++++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 5d5d941..03db587 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -298,6 +298,7 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	struct pathgroup * pgp;
 	struct config *conf;
 	int i, n_paths, marginal_pathgroups;
+	char *save_attr;
 
 	/*
 	 * don't bother if devmap size is unknown
@@ -307,9 +308,6 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 		return 1;
 	}
 
-	/*
-	 * free features, selector, and hwhandler properties if they are being reused
-	 */
 	free_multipath_attributes(mpp);
 	if (mpp->disable_queueing && VECTOR_SIZE(mpp->paths) != 0)
 		mpp->disable_queueing = 0;
@@ -328,11 +326,35 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 
 	select_pgfailback(conf, mpp);
 	select_pgpolicy(conf, mpp);
+
+	/*
+	 * If setup_map() is called from e.g. from reload_map() or resize_map(),
+	 * make sure that we don't corrupt attributes.
+	 */
+	save_attr = steal_ptr(mpp->selector);
 	select_selector(conf, mpp);
+	if (!mpp->selector)
+		mpp->selector = save_attr;
+	else
+		free(save_attr);
+
 	select_no_path_retry(conf, mpp);
 	select_retain_hwhandler(conf, mpp);
+
+	save_attr = steal_ptr(mpp->features);
 	select_features(conf, mpp);
+	if (!mpp->features)
+		mpp->features = save_attr;
+	else
+		free(save_attr);
+
+	save_attr = steal_ptr(mpp->hwhandler);
 	select_hwhandler(conf, mpp);
+	if (!mpp->hwhandler)
+		mpp->hwhandler = save_attr;
+	else
+		free(save_attr);
+
 	select_rr_weight(conf, mpp);
 	select_minio(conf, mpp);
 	select_mode(conf, mpp);
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 52aa559..045bbee 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -110,4 +110,11 @@ static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 	bf->bits[bit / bits_per_slot] &= ~(1ULL << (bit % bits_per_slot));
 }
 
+#define steal_ptr(x)		       \
+	({			       \
+		void *___p = x;	       \
+		x = NULL;	       \
+		___p;		       \
+	})
+
 #endif /* _UTIL_H */
-- 
2.28.0
