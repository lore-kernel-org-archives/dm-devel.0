From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 28/30] multipath-tools tests: add test for
	uid_attrs parsing
Date: Fri,  7 Jun 2019 15:05:50 +0200
Message-ID: <20190607130552.13203-29-mwilck@suse.com>
References: <20190607130552.13203-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190607130552.13203-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/uevent.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tests/uevent.c b/tests/uevent.c
index 215d97ad..f4afd9b4 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -95,6 +95,23 @@ static void test_ro_good(void **state)
 	assert_int_equal(uevent_get_disk_ro(uev), DISK_RO);
 }
 
+static void test_uid_attrs(void **state)
+{
+	/* see test_uid_attrs above */
+	struct config *conf = get_multipath_config();
+	vector attrs = &conf->uid_attrs;
+
+	assert_int_equal(VECTOR_SIZE(attrs), 3);
+	assert_null(get_uid_attribute_by_attrs(conf, "hda"));
+	assert_string_equal("ID_BOGUS",
+			    get_uid_attribute_by_attrs(conf, "sdaw"));
+	assert_string_equal("ID_SPAM",
+			    get_uid_attribute_by_attrs(conf, "dasdu"));
+	assert_string_equal("ID_EGGS",
+			    get_uid_attribute_by_attrs(conf, "nvme2n4"));
+	put_multipath_config(conf);
+}
+
 static void test_wwid(void **state)
 {
 	struct uevent *uev = *state;
@@ -280,6 +297,7 @@ int test_uevent_get_XXX(void)
 		cmocka_unit_test(test_minor_good),
 		cmocka_unit_test(test_ro_good),
 		cmocka_unit_test(test_dm_name_good),
+		cmocka_unit_test(test_uid_attrs),
 		cmocka_unit_test(test_wwid),
 		cmocka_unit_test(test_major_bad_0),
 		cmocka_unit_test(test_major_bad_1),
-- 
2.21.0
