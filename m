From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 14/28] libmultipath: don't merge hwentries by
	regex
Date: Fri,  8 Jun 2018 12:20:27 +0200
Message-ID: <20180608102041.22904-15-mwilck@suse.com>
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

Merging by regular expression is wrong, because regular expressions can't be
matched against each other. Unexpected results for hardware properties may
result. Don't do it any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 8 +-------
 tests/hwtable.c       | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 89aad15a..713ac7f3 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -470,18 +470,12 @@ restart:
 				free_hwe(hwe2);
 				continue;
 			}
-			if (hwe_regmatch(hwe1, hwe2->vendor,
-					 hwe2->product, hwe2->revision))
-				continue;
-			/* dup */
-			log_match(hwe1, hwe2->vendor,
-				  hwe2->product, hwe2->revision);
-			merge_hwe(hwe2, hwe1);
 			if (hwe_strmatch(hwe2, hwe1) == 0) {
 				condlog(4, "%s: removing hwentry %s:%s:%s",
 					__func__, hwe1->vendor, hwe1->product,
 					hwe1->revision);
 				vector_del_slot(hw, i);
+				merge_hwe(hwe2, hwe1);
 				free_hwe(hwe1);
 				n -= 1;
 				/*
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 8b2ed95d..15f364e4 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -1138,15 +1138,10 @@ static int setup_2_ident_not_self_matching_re_hwe_dir(void **state)
  * Two different non-trivial regexes kv1, kv2. The 1st one matches the 2nd, but
  * it doesn't match all possible strings matching the second.
  * ("ba[zy]" matches regex "ba[[rxy]", but "baz" does not).
- * This causes the first entry to be merged into the second, but both entries
- * to be kept.
  *
  * Expected: Devices matching both regexes get properties from both, kv2
  * taking precedence. Devices matching just one regex get properties from
  * that one regex only.
- *
- * Current: behaves as expected, except for devices that match only kv2.
- * Those get properties from kv1, too.
  */
 static void test_2_matching_res_hwe_dir(const struct hwt_state *hwt)
 {
@@ -1168,8 +1163,7 @@ static void test_2_matching_res_hwe_dir(const struct hwt_state *hwt)
 	pp = mock_path_flags(vnd_foo.value, prd_baz.value, USE_GETUID);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
 	TEST_PROP(pp->getuid, gui_foo.value);
-	TEST_PROP_BROKEN(_checker, pp->checker.name,
-			 chk_hp.value, DEFAULT_CHECKER);
+	TEST_PROP(pp->checker.name, DEFAULT_CHECKER);
 }
 
 static int setup_2_matching_res_hwe_dir(void **state)
-- 
2.17.0
