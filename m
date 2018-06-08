From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 13/28] libmultipath: allow more than one hwentry
Date: Fri,  8 Jun 2018 12:20:26 +0200
Message-ID: <20180608102041.22904-14-mwilck@suse.com>
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

The previous patch "use vector for for pp->hwe and mp->hwe" changed the
data structure for hwentries. This patch changes actual behavior by
allowing more than one hwentry to match a given path (or multipath).

This fixes several currently broken test cases. The test code is adapted
accordingly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c |  1 -
 tests/hwtable.c       | 64 ++++++++-----------------------------------
 2 files changed, 12 insertions(+), 53 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 95a71447..89aad15a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -136,7 +136,6 @@ find_hwe (const struct _vector *hwtable,
 			n++;
 		}
 		log_match(tmp, vendor, product, revision);
-		break;
 	}
 	condlog(n > 1 ? 3 : 4, "%s: found %d hwtable matches for %s:%s:%s",
 		__func__, n, vendor, product, revision);
diff --git a/tests/hwtable.c b/tests/hwtable.c
index b2a0511a..8b2ed95d 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -610,9 +610,6 @@ static int setup_regex_hwe(void **state)
  *
  * Expected: Devices matching both get properties from both, kv2 taking
  * precedence. Devices matching kv1 only just get props from kv1.
- *
- * Current: These entries are currently _NOT_ merged, therefore getuid is
- * default for kv1 matches, and checker is default on kv2 matches.
  */
 static void test_regex_string_hwe(const struct hwt_state *hwt)
 {
@@ -646,12 +643,7 @@ static void test_regex_string_hwe(const struct hwt_state *hwt)
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	/*
-	 * You'd expect that the two entries above be merged,
-	 * but that isn't the case if they're in the same input file.
-	 */
-	TEST_PROP_BROKEN(_checker, pp->checker.name,
-			 DEFAULT_CHECKER, chk_hp.value);
+	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
 static int setup_regex_string_hwe(void **state)
@@ -675,8 +667,6 @@ static int setup_regex_string_hwe(void **state)
  * Expected: Devices matching kv2 (and thus, both) get properties
  * from both, kv2 taking precedence.
  * Devices matching kv1 only just get props from kv1.
- *
- * Current: behaves as expected.
  */
 static void test_regex_string_hwe_dir(const struct hwt_state *hwt)
 {
@@ -711,7 +701,6 @@ static void test_regex_string_hwe_dir(const struct hwt_state *hwt)
 	/* Later match takes prio */
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	/* This time it's merged */
 	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
@@ -792,19 +781,15 @@ static int setup_regex_2_strings_hwe_dir(void **state)
  * Expected: Devices matching kv1 (and thus, both) get properties
  * from both, kv1 taking precedence.
  * Devices matching kv1 only just get props from kv1.
- *
- * Current: kv2 never matches, because kv1 is more generic and encountered
- * first; thus properties from kv2 aren't used.
  */
 static void test_string_regex_hwe_dir(const struct hwt_state *hwt)
 {
 	struct path *pp;
 
 	/* foo:bar matches kv2 and kv1 */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value,
-			     BROKEN == 1 ? 0 : USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP_BROKEN(_getuid, pp->getuid, (char *)NULL, gui_foo.value);
+	TEST_PROP(pp->getuid, gui_foo.value);
 	TEST_PROP(pp->checker.name, chk_hp.value);
 
 	/* foo:baz matches kv1 */
@@ -850,8 +835,6 @@ static int setup_string_regex_hwe_dir(void **state)
  * This could happen in a large multipath.conf file.
  *
  * Expected: matching devices get props from both, kv2 taking precedence.
- *
- * Current: devices get props from kv2 only.
  */
 static void test_2_ident_strings_hwe(const struct hwt_state *hwt)
 {
@@ -863,12 +846,11 @@ static void test_2_ident_strings_hwe(const struct hwt_state *hwt)
 	TEST_PROP(pp->getuid, NULL);
 	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
 
-	/* foo:bar matches both, but only kv2 is seen */
+	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP_BROKEN(_checker, pp->checker.name, DEFAULT_CHECKER,
-			 chk_hp.value);
+	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
 static int setup_2_ident_strings_hwe(void **state)
@@ -903,8 +885,7 @@ static void test_2_ident_strings_both_dir(const struct hwt_state *hwt)
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP_BROKEN(_checker, pp->checker.name, DEFAULT_CHECKER,
-			 chk_hp.value);
+	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
 static int setup_2_ident_strings_both_dir(void **state)
@@ -944,8 +925,7 @@ static void test_2_ident_strings_both_dir_w_prev(const struct hwt_state *hwt)
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP_BROKEN(_checker, pp->checker.name, DEFAULT_CHECKER,
-			 chk_hp.value);
+	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
 static int setup_2_ident_strings_both_dir_w_prev(void **state)
@@ -975,8 +955,6 @@ static int setup_2_ident_strings_both_dir_w_prev(void **state)
  * to kv1 being in the built-in hwtable and kv2 in multipath.conf.
  *
  * Expected: matching devices get props from both, kv2 taking precedence.
- *
- * Current: behaves as expected.
  */
 static void test_2_ident_strings_hwe_dir(const struct hwt_state *hwt)
 {
@@ -1011,9 +989,6 @@ static int setup_2_ident_strings_hwe_dir(void **state)
  * contains an additional, empty entry (kv0).
  *
  * Expected: matching devices get props from kv1 and kv2, kv2 taking precedence.
- *
- * Current: kv0 and kv1 are merged into kv0, and then ignored because kv2 takes
- * precedence. Thus the presence of the empty kv0 changes how kv1 is treated.
  */
 static void test_3_ident_strings_hwe_dir(const struct hwt_state *hwt)
 {
@@ -1029,8 +1004,7 @@ static void test_3_ident_strings_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP_BROKEN(_checker, pp->checker.name, DEFAULT_CHECKER,
-			 chk_hp.value);
+	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
 static int setup_3_ident_strings_hwe_dir(void **state)
@@ -1059,8 +1033,6 @@ static int setup_3_ident_strings_hwe_dir(void **state)
  * to kv1 being in the built-in hwtable and kv2 in multipath.conf.
  *
  * Expected: matching devices get props from both, kv2 taking precedence.
- *
- * Current: behaves as expected.
  */
 static void test_2_ident_self_matching_re_hwe_dir(const struct hwt_state *hwt)
 {
@@ -1096,8 +1068,6 @@ static int setup_2_ident_self_matching_re_hwe_dir(void **state)
  * kv1 and kv2 are added to the main config file.
  *
  * Expected: matching devices get props from both, kv2 taking precedence.
- *
- * Current: Devices get properties from kv2 only (kv1 and kv2 are not merged).
  */
 static void test_2_ident_self_matching_re_hwe(const struct hwt_state *hwt)
 {
@@ -1113,8 +1083,7 @@ static void test_2_ident_self_matching_re_hwe(const struct hwt_state *hwt)
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP_BROKEN(_checker, pp->checker.name,
-			 DEFAULT_CHECKER, chk_hp.value);
+	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
 static int setup_2_ident_self_matching_re_hwe(void **state)
@@ -1135,8 +1104,6 @@ static int setup_2_ident_self_matching_re_hwe(void **state)
  * This case is more important as you may think, see above.
  *
  * Expected: matching devices get props from both, kv2 taking precedence.
- *
- * Current: devices get props from kv2 only.
  */
 static void
 test_2_ident_not_self_matching_re_hwe_dir(const struct hwt_state *hwt)
@@ -1149,12 +1116,11 @@ test_2_ident_not_self_matching_re_hwe_dir(const struct hwt_state *hwt)
 	TEST_PROP(pp->getuid, NULL);
 	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
 
-	/* foo:bar matches both, but only kv2 is seen */
+	/* foo:bar matches both */
 	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP_BROKEN(_checker, pp->checker.name,
-			 DEFAULT_CHECKER, chk_hp.value);
+	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
 static int setup_2_ident_not_self_matching_re_hwe_dir(void **state)
@@ -1223,8 +1189,6 @@ static int setup_2_matching_res_hwe_dir(void **state)
  * "baz" matches both regex "ba[zy]" and "ba(z|y)"
  *
  * Expected: matching devices get properties from both, kv2 taking precedence.
- *
- * Current: matching devices get properties from kv2 only.
  */
 static void test_2_nonmatching_res_hwe_dir(const struct hwt_state *hwt)
 {
@@ -1236,14 +1200,10 @@ static void test_2_nonmatching_res_hwe_dir(const struct hwt_state *hwt)
 	TEST_PROP(pp->getuid, NULL);
 	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
 
-	/*
-	 * foo:baz matches k2 and k1. Yet it sees the value from k2 only.
-	 */
 	pp = mock_path_flags(vnd_foo.value, prd_baz.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP_BROKEN(_checker, pp->checker.name,
-			 DEFAULT_CHECKER, chk_hp.value);
+	TEST_PROP(pp->checker.name, chk_hp.value);
 }
 
 static int setup_2_nonmatching_res_hwe_dir(void **state)
-- 
2.17.0
