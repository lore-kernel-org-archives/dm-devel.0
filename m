From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 12/72] multipath tests: alias: add format/scan
	test
Date: Sat, 12 Oct 2019 21:27:52 +0000
Message-ID: <20191012212703.12989-13-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Test scan_devname(format_devname(id)) == id.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/alias.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tests/alias.c b/tests/alias.c
index 170ebbeb..30414db0 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -297,6 +297,34 @@ static void sd_max_p1(void **state)
 }
 #endif
 
+static void sd_fd_many(void **state)
+{
+	char buf[32];
+	int rc, i;
+
+	for (i = 1; i < 5000; i++) {
+		rc = format_devname(buf, i, sizeof(buf), "MPATH");
+		assert_in_range(rc, 6, 8);
+		rc = scan_devname(buf, "MPATH");
+		assert_int_equal(rc, i);
+	}
+}
+
+static void sd_fd_random(void **state)
+{
+	char buf[32];
+	int rc, i, n;
+
+	srandom(1);
+	for (i = 1; i < 1000; i++) {
+		n = random() & 0xffff;
+		rc = format_devname(buf, n, sizeof(buf), "MPATH");
+		assert_in_range(rc, 6, 9);
+		rc = scan_devname(buf, "MPATH");
+		assert_int_equal(rc, n);
+	}
+}
+
 static int test_scan_devname(void)
 {
 	const struct CMUnitTest tests[] = {
@@ -314,6 +342,8 @@ static int test_scan_devname(void)
 		cmocka_unit_test(sd_max),
 		cmocka_unit_test(sd_max_p1),
 #endif
+		cmocka_unit_test(sd_fd_many),
+		cmocka_unit_test(sd_fd_random),
 	};
 
 	return cmocka_run_group_tests(tests, NULL, NULL);
-- 
2.23.0
