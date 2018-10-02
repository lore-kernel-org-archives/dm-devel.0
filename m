From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] multipath-tools: tests/hwtable: test hidden
	devices
Date: Tue,  2 Oct 2018 20:47:01 +0200
Message-ID: <20181002184701.18956-3-mwilck@suse.com>
References: <20181002184701.18956-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181002184701.18956-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Add a test for skipping "hidden" devices.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 42127adf..9146ecc3 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -1661,6 +1661,24 @@ static int setup_multipath_config_3(void **state)
 	return 0;
 }
 
+/*
+ * Test for device with "hidden" attribute
+ */
+static void test_hidden(const struct hwt_state *hwt)
+{
+	mock_path_flags("NVME", "NoName", DEV_HIDDEN|BL_MASK);
+}
+
+static int setup_hidden(void **state)
+{
+	struct hwt_state *hwt = CHECK_STATE(state);
+
+	WRITE_EMPTY_CONF(hwt);
+	SET_TEST_FUNC(hwt, test_hidden);
+
+	return 0;
+}
+
 /*
  * Create wrapper functions around test_driver() to avoid that cmocka
  * always uses the same test name. That makes it easier to read test results.
@@ -1703,6 +1721,7 @@ define_test(product_blacklist_matching)
 define_test(multipath_config)
 define_test(multipath_config_2)
 define_test(multipath_config_3)
+define_test(hidden)
 
 #define test_entry(x) \
 	cmocka_unit_test_setup(run_##x, setup_##x)
@@ -1742,6 +1761,7 @@ static int test_hwtable(void)
 		test_entry(multipath_config),
 		test_entry(multipath_config_2),
 		test_entry(multipath_config_3),
+		test_entry(hidden),
 	};
 
 	return cmocka_run_group_tests(tests, setup, teardown);
-- 
2.19.0
