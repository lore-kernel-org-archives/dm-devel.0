From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 02/24] tests/hwtable: adjust to new checker API
Date: Mon, 10 Dec 2018 10:49:37 +0100
Message-ID: <20181210094959.11338-3-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

checker.name doesn't exist any more.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 84 ++++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 1cd788ac..789481ff 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -570,7 +570,7 @@ static void test_internal_nvme(const struct hwt_state *hwt)
 	pp = mock_path("NVME", "NoName");
 	mp = mock_multipath(pp);
 	assert_ptr_not_equal(mp, NULL);
-	TEST_PROP(pp->checker.name, NONE);
+	TEST_PROP(checker_name(&pp->checker), NONE);
 	TEST_PROP(pp->uid_attribute, "ID_WWN");
 	assert_int_equal(mp->pgpolicy, DEFAULT_PGPOLICY);
 	assert_int_equal(mp->no_path_retry, DEFAULT_NO_PATH_RETRY);
@@ -583,7 +583,7 @@ static void test_internal_nvme(const struct hwt_state *hwt)
 			    default_wwid_1);
 	mp = mock_multipath(pp);
 	assert_ptr_not_equal(mp, NULL);
-	TEST_PROP(pp->checker.name, NONE);
+	TEST_PROP(checker_name(&pp->checker), NONE);
 	TEST_PROP(pp->uid_attribute, "ID_WWN");
 	assert_int_equal(mp->pgpolicy, MULTIBUS);
 	assert_int_equal(mp->no_path_retry, NO_PATH_RETRY_QUEUE);
@@ -755,31 +755,31 @@ static void test_regex_string_hwe(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* boo:baz matches kv1 */
 	pp = mock_path(vnd_boo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:ba. matches kv1 */
 	pp = mock_path(vnd__oo.value, prd_ba_.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .foo:(bar|baz|ba\.) doesn't match */
 	pp = mock_path(vnd__oo.value, prd_ba_s.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches kv2 and kv1 */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_regex_string_hwe(void **state)
@@ -812,32 +812,32 @@ static void test_regex_string_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* boo:baz matches kv1 */
 	pp = mock_path(vnd_boo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:ba. matches kv1 */
 	pp = mock_path(vnd__oo.value, prd_ba_.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:(bar|baz|ba\.)$ doesn't match */
 	pp = mock_path(vnd__oo.value, prd_ba_s.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches kv2 */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	/* Later match takes prio */
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_regex_string_hwe_dir(void **state)
@@ -868,28 +868,28 @@ static void test_regex_2_strings_hwe_dir(const struct hwt_state *hwt)
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
 	TEST_PROP(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* boo:baz doesn't match */
 	pp = mock_path(vnd_boo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
 	TEST_PROP(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches kv2 and kv1 */
 	pp = mock_path(vnd_foo.value, prd_bar.value);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, NULL);
 	TEST_PROP(pp->uid_attribute, uid_baz.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* foo:barz matches kv3 and kv2 and kv1 */
 	pp = mock_path_flags(vnd_foo.value, prd_barz.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_rdac.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
 	TEST_PROP(pp->uid_attribute, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_regex_2_strings_hwe_dir(void **state)
@@ -926,31 +926,31 @@ static void test_string_regex_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* foo:baz matches kv1 */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* boo:baz matches kv1 */
 	pp = mock_path(vnd_boo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:ba. matches kv1 */
 	pp = mock_path(vnd__oo.value, prd_ba_.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:(bar|baz|ba\.)$ doesn't match */
 	pp = mock_path(vnd__oo.value, prd_ba_s.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 }
 
 static int setup_string_regex_hwe_dir(void **state)
@@ -980,13 +980,13 @@ static void test_2_ident_strings_hwe(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_strings_hwe(void **state)
@@ -1015,13 +1015,13 @@ static void test_2_ident_strings_both_dir(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_strings_both_dir(void **state)
@@ -1055,13 +1055,13 @@ static void test_2_ident_strings_both_dir_w_prev(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_strings_both_dir_w_prev(void **state)
@@ -1100,13 +1100,13 @@ static void test_2_ident_strings_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_strings_hwe_dir(void **state)
@@ -1134,13 +1134,13 @@ static void test_3_ident_strings_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_3_ident_strings_hwe_dir(void **state)
@@ -1178,13 +1178,13 @@ static void test_2_ident_self_matching_re_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_self_matching_re_hwe_dir(void **state)
@@ -1213,13 +1213,13 @@ static void test_2_ident_self_matching_re_hwe(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_self_matching_re_hwe(void **state)
@@ -1250,13 +1250,13 @@ test_2_ident_not_self_matching_re_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_not_self_matching_re_hwe_dir(void **state)
@@ -1287,19 +1287,19 @@ static void test_2_matching_res_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_bar.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* foo:bay matches k1 and k2 */
 	pp = mock_path_flags(vnd_foo.value, "bay", USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* foo:baz matches k2 only. */
 	pp = mock_path_flags(vnd_foo.value, prd_baz.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 }
 
 static int setup_2_matching_res_hwe_dir(void **state)
@@ -1328,12 +1328,12 @@ static void test_2_nonmatching_res_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path(vnd_foo.value, prd_bar.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 	TEST_PROP(pp->getuid, NULL);
-	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
+	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	pp = mock_path_flags(vnd_foo.value, prd_baz.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP(pp->checker.name, chk_hp.value);
+	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_nonmatching_res_hwe_dir(void **state)
-- 
2.19.2
