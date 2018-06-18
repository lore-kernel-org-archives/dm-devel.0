From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 29/30] tests/hwtable: add test for broken hwentry
	filtering
Date: Mon, 18 Jun 2018 11:54:35 +0200
Message-ID: <20180618095436.22352-1-mwilck@suse.com>
References: <20180615180332.GL3103@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180615180332.GL3103@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Broken hwentries weren't correctly filtered after patch
"libmultipath: merge hwentries inside a conf file". Add a test
case for that.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 9db79391..3488640d 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -651,6 +651,52 @@ static int setup_string_hwe(void **state)
 	return 0;
 }
 
+/*
+ * Device section with a broken entry (no product)
+ * It should be ignored.
+ */
+static void test_broken_hwe(const struct hwt_state *hwt)
+{
+	struct path *pp;
+
+	/* foo:bar doesn't match, as hwentry is ignored */
+	pp = mock_path(vnd_foo.value, prd_bar.value);
+	TEST_PROP_BROKEN("prio", prio_name(&pp->prio), prio_emc.value,
+			 DEFAULT_PRIO);
+
+	/* boo:bar doesn't match */
+	pp = mock_path(vnd_boo.value, prd_bar.value);
+	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
+}
+
+static int setup_broken_hwe(void **state)
+{
+	struct hwt_state *hwt = CHECK_STATE(state);
+	const struct key_value kv[] = { vnd_foo, prio_emc };
+
+	WRITE_ONE_DEVICE(hwt, kv);
+	SET_TEST_FUNC(hwt, test_broken_hwe);
+	return 0;
+}
+
+/*
+ * Like test_broken_hwe, but in config_dir file.
+ */
+static int setup_broken_hwe_dir(void **state)
+{
+	struct hwt_state *hwt = CHECK_STATE(state);
+	const struct key_value kv[] = { vnd_foo, prio_emc };
+
+	begin_config(hwt);
+	begin_section_all(hwt, "devices");
+	write_device(hwt->conf_dir_file[0], ARRAY_SIZE(kv), kv);
+	end_section_all(hwt);
+	finish_config(hwt);
+	hwt->test = test_broken_hwe;
+	hwt->test_name = "test_broken_hwe_dir";
+	return 0;
+}
+
 /*
  * Device section with a single regex entry ("^.foo:(bar|baz|ba\.)$")
  */
@@ -1628,6 +1674,8 @@ static int setup_multipath_config_3(void **state)
 	}
 
 define_test(string_hwe)
+define_test(broken_hwe)
+define_test(broken_hwe_dir)
 define_test(quoted_hwe)
 define_test(internal_nvme)
 define_test(regex_hwe)
@@ -1666,6 +1714,8 @@ static int test_hwtable(void)
 		cmocka_unit_test(test_sanity_globals),
 		test_entry(internal_nvme),
 		test_entry(string_hwe),
+		test_entry(broken_hwe),
+		test_entry(broken_hwe_dir),
 		test_entry(quoted_hwe),
 		test_entry(regex_hwe),
 		test_entry(regex_string_hwe),
-- 
2.17.1
