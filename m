From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 25/28] libmultipath: merge "multipath" config
	sections by wwid
Date: Fri,  8 Jun 2018 12:20:38 +0200
Message-ID: <20180608102041.22904-26-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If more than one "multipath" section exists for a given wwid,
only the properties from the first section are applied, and
those of the later ones are silently discarded.

Fix this by merging mpentries in the same way we do it for hwentries.
Actually, later entries should take precedence, for consistency with
hwentry handling.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 70 +++++++++++++++++++++++++++++++++++++++++++
 tests/hwtable.c       | 16 ----------
 2 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index fb41d620..c8378f87 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -376,6 +376,74 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	return 0;
 }
 
+static int
+merge_mpe(struct mpentry *dst, struct mpentry *src)
+{
+	if (!dst || !src)
+		return 1;
+
+	merge_str(alias);
+	merge_str(uid_attribute);
+	merge_str(getuid);
+	merge_str(selector);
+	merge_str(features);
+	merge_str(prio_name);
+	merge_str(prio_args);
+
+	if (dst->prkey_source == PRKEY_SOURCE_NONE &&
+	    src->prkey_source != PRKEY_SOURCE_NONE) {
+		dst->prkey_source = src->prkey_source;
+		memcpy(&dst->reservation_key, &src->reservation_key,
+		       sizeof(dst->reservation_key));
+	}
+
+	merge_num(pgpolicy);
+	merge_num(pgfailback);
+	merge_num(rr_weight);
+	merge_num(no_path_retry);
+	merge_num(minio);
+	merge_num(minio_rq);
+	merge_num(flush_on_last_del);
+	merge_num(attribute_flags);
+	merge_num(user_friendly_names);
+	merge_num(deferred_remove);
+	merge_num(delay_watch_checks);
+	merge_num(delay_wait_checks);
+	merge_num(marginal_path_err_sample_time);
+	merge_num(marginal_path_err_rate_threshold);
+	merge_num(marginal_path_err_recheck_gap_time);
+	merge_num(marginal_path_double_failed_time);
+	merge_num(skip_kpartx);
+	merge_num(max_sectors_kb);
+	merge_num(ghost_delay);
+	merge_num(uid);
+	merge_num(gid);
+	merge_num(mode);
+
+	return 0;
+}
+
+void merge_mptable(vector mptable)
+{
+	struct mpentry *mp1, *mp2;
+	int i, j;
+
+	vector_foreach_slot(mptable, mp1, i) {
+		j = i + 1;
+		vector_foreach_slot_after(mptable, mp2, j) {
+			if (strcmp(mp1->wwid, mp2->wwid))
+				continue;
+			condlog(1, "%s: duplicate multipath config section for %s",
+				__func__, mp1->wwid);
+			merge_mpe(mp2, mp1);
+			free_mpe(mp1);
+			vector_del_slot(mptable, i);
+			i--;
+			break;
+		}
+	}
+}
+
 int
 store_hwe (vector hwtable, struct hwentry * dhwe)
 {
@@ -747,6 +815,8 @@ load_config (char * file)
 		if (!conf->mptable)
 			goto out;
 	}
+
+	merge_mptable(conf->mptable);
 	if (conf->bindings_file == NULL)
 		conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
 
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 1a6b3188..f6fba14d 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -1567,8 +1567,6 @@ static int setup_multipath_config(void **state)
  *
  * Expected: properties are taken from both multipath sections, later taking
  * precedence
- *
- * Current: gets properties from first entry only.
  */
 static void test_multipath_config_2(const struct hwt_state *hwt)
 {
@@ -1580,15 +1578,8 @@ static void test_multipath_config_2(const struct hwt_state *hwt)
 	assert_ptr_not_equal(mp, NULL);
 	assert_ptr_not_equal(mp->mpe, NULL);
 	TEST_PROP(prio_name(&pp->prio), prio_rdac.value);
-#if BROKEN
-	condlog(1, "%s: WARNING: broken test on %d", __func__, __LINE__ + 1);
-	assert_int_equal(mp->minio, DEFAULT_MINIO_RQ);
-	condlog(1, "%s: WARNING: broken test on %d", __func__, __LINE__ + 1);
-	assert_int_equal(mp->no_path_retry, NO_PATH_RETRY_QUEUE);
-#else
 	assert_int_equal(mp->minio, atoi(minio_99.value));
 	assert_int_equal(mp->no_path_retry, atoi(npr_37.value));
-#endif
 }
 
 static int setup_multipath_config_2(void **state)
@@ -1622,15 +1613,8 @@ static void test_multipath_config_3(const struct hwt_state *hwt)
 	assert_ptr_not_equal(mp, NULL);
 	assert_ptr_not_equal(mp->mpe, NULL);
 	TEST_PROP(prio_name(&pp->prio), prio_rdac.value);
-#if BROKEN
-	condlog(1, "%s: WARNING: broken test on %d", __func__, __LINE__ + 1);
-	assert_int_equal(mp->minio, DEFAULT_MINIO_RQ);
-	condlog(1, "%s: WARNING: broken test on %d", __func__, __LINE__ + 1);
-	assert_int_equal(mp->no_path_retry, NO_PATH_RETRY_QUEUE);
-#else
 	assert_int_equal(mp->minio, atoi(minio_99.value));
 	assert_int_equal(mp->no_path_retry, atoi(npr_37.value));
-#endif
 }
 
 static int setup_multipath_config_3(void **state)
-- 
2.17.0
