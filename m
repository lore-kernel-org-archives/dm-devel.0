From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 19/28] tests/hwtable: implement configuration
	dump + reload test
Date: Fri,  8 Jun 2018 12:20:32 +0200
Message-ID: <20180608102041.22904-20-mwilck@suse.com>
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

In order to test dumping and re-reading the configuration, we modify the
test_driver() function so that runs the same test three twice:

 1) with "user-supplied" configuration,
 2) using the config dump from 1) (equivalent with "multipath -t" output) as input
 configuration.

The expectation is that actual paths and maps have same options applied.
Furthermore, the "multipath -T" output from 2) should be the same as from 1),
IOW, "multipath -T" in 2) reproduces its input config file exactly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 2 deletions(-)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 85215946..85924fb7 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -23,6 +23,7 @@
 #include "defaults.h"
 #include "pgpolicies.h"
 #include "test-lib.h"
+#include "print.h"
 
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
 #define N_CONF_FILES 2
@@ -358,6 +359,16 @@ static void write_device(FILE *ff, int nkv, const struct key_value *kv)
 		conf = NULL;			\
 	} while (0)
 
+static void replace_config(const struct hwt_state *hwt,
+			   const char *conf_str)
+{
+	FREE_CONFIG(_conf);
+	reset_configs(hwt);
+	fprintf(hwt->config_file, "%s", conf_str);
+	fflush(hwt->config_file);
+	_conf = LOAD_CONFIG(hwt);
+}
+
 #define TEST_PROP(prop, val) do {				\
 		if (val == NULL)				\
 			assert_ptr_equal(prop, NULL);		\
@@ -432,8 +443,58 @@ static const struct key_value npr_queue = { _no_path_retry, "queue" };
 /***** BEGIN TESTS SECTION *****/
 
 /*
- * Run the given test case. This will later be extended
- * to run the test several times in a row.
+ * Dump the configuration, subistitute the dumped configuration
+ * for the current one, and verify that the result is identical.
+ */
+static void replicate_config(const struct hwt_state *hwt)
+{
+	char *cfg1, *cfg2;
+	struct config *conf;
+
+	condlog(1, "--- %s: replicating configuration", __func__);
+
+	conf = get_multipath_config();
+	cfg1 = snprint_config(conf, NULL);
+
+	assert_non_null(cfg1);
+	put_multipath_config(conf);
+
+	replace_config(hwt, cfg1);
+
+	conf = get_multipath_config();
+	cfg2 = snprint_config(conf, NULL);
+	assert_non_null(cfg2);
+	put_multipath_config(conf);
+
+// #define DBG_CONFIG 1
+#ifdef DBG_CONFIG
+#define DUMP_CFG_STR(x) do {						\
+		FILE *tmp = fopen("/tmp/hwtable-" #x ".txt", "w");	\
+		fprintf(tmp, "%s", x);					\
+		fclose(tmp);						\
+	} while (0)
+
+	DUMP_CFG_STR(cfg1);
+	DUMP_CFG_STR(cfg2);
+#endif
+
+#if BROKEN
+	condlog(1, "%s: WARNING: skipping tests for same configuration after dump/reload on %d",
+		__func__, __LINE__);
+#else
+	assert_int_equal(strlen(cfg2), strlen(cfg1));
+	assert_string_equal(cfg2, cfg1);
+#endif
+	free(cfg1);
+	free(cfg2);
+}
+
+/*
+ * Run hwt->test three times; once with the constructed configuration,
+ * once after re-reading the full dumped configuration, and once with the
+ * dumped local configuration.
+ *
+ * Expected: test passes every time.
  */
 static void test_driver(void **state)
 {
@@ -443,6 +504,10 @@ static void test_driver(void **state)
 	_conf = LOAD_CONFIG(hwt);
 	hwt->test(hwt);
 
+	replicate_config(hwt);
+	reset_vecs(hwt->vecs);
+	hwt->test(hwt);
+
 	reset_vecs(hwt->vecs);
 	FREE_CONFIG(_conf);
 }
@@ -513,9 +578,18 @@ static int setup_internal_nvme(void **state)
 /*
  * Device section with a simple entry qith double quotes ('foo:"bar"')
  */
+#if BROKEN
+static void test_quoted_hwe(void **state)
+#else
 static void test_quoted_hwe(const struct hwt_state *hwt)
+#endif
 {
 	struct path *pp;
+#if BROKEN
+       struct hwt_state *hwt = CHECK_STATE(state);
+
+       _conf = LOAD_CONFIG(hwt);
+#endif
 	/* foo:"bar" matches */
 	pp = mock_path(vnd_foo.value, prd_baq.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
@@ -531,7 +605,11 @@ static int setup_quoted_hwe(void **state)
 	const struct key_value kv[] = { vnd_foo, prd_baqq, prio_emc };
 
 	WRITE_ONE_DEVICE(hwt, kv);
+#if BROKEN
+       condlog(0, "%s: WARNING: skipping conf reload test", __func__);
+#else
 	SET_TEST_FUNC(hwt, test_quoted_hwe);
+#endif
 	return 0;
 }
 
@@ -1558,7 +1636,9 @@ static int setup_multipath_config_3(void **state)
 	}
 
 define_test(string_hwe)
+#if !BROKEN
 define_test(quoted_hwe)
+#endif
 define_test(internal_nvme)
 define_test(regex_hwe)
 define_test(regex_string_hwe)
@@ -1596,7 +1676,11 @@ static int test_hwtable(void)
 		cmocka_unit_test(test_sanity_globals),
 		test_entry(internal_nvme),
 		test_entry(string_hwe),
+#if BROKEN
+		cmocka_unit_test_setup(test_quoted_hwe, setup_quoted_hwe),
+#else
 		test_entry(quoted_hwe),
+#endif
 		test_entry(regex_hwe),
 		test_entry(regex_string_hwe),
 		test_entry(regex_string_hwe_dir),
-- 
2.17.0
