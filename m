From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 6/7] libmultipath: add uevent_is_mpath
Date: Wed, 17 Jan 2018 08:49:38 +0100
Message-ID: <20180117074939.7795-7-mwilck@suse.com>
References: <20180117074939.7795-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117074939.7795-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Ritika Srivastava <ritika.srivastava@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This function can be used to test if an uevent belongs to valid
multipath device. Unit tests are also added.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 12 ++++++++++
 libmultipath/uevent.h |  1 +
 tests/uevent.c        | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 3d32e31c5c49..8f4129ca7fd0 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -52,6 +52,7 @@
 #include "util.h"
 #include "config.h"
 #include "blacklist.h"
+#include "devmapper.h"
 
 #define MAX_ACCUMULATION_COUNT 2048
 #define MAX_ACCUMULATION_TIME 30*1000
@@ -929,3 +930,14 @@ const char *uevent_get_dm_action(const struct uevent *uev)
 {
 	return uevent_get_dm_str(uev, "DM_ACTION");
 }
+
+bool uevent_is_mpath(const struct uevent *uev)
+{
+	const char *uuid = uevent_get_env_var(uev, "DM_UUID");
+
+	if (uuid == NULL)
+		return false;
+	if (strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+		return false;
+	return uuid[UUID_PREFIX_LEN] != '\0';
+}
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index bf7017090b1c..cb5347e45c2b 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -39,5 +39,6 @@ int uevent_get_disk_ro(const struct uevent *uev);
 const char *uevent_get_dm_name(const struct uevent *uev);
 const char *uevent_get_dm_path(const struct uevent *uev);
 const char *uevent_get_dm_action(const struct uevent *uev);
+bool uevent_is_mpath(const struct uevent *uev);
 
 #endif /* _UEVENT_H */
diff --git a/tests/uevent.c b/tests/uevent.c
index a8edd710f653..b7d6458710f4 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -16,6 +16,7 @@
  *
  */
 
+#include <stdbool.h>
 #include <stdarg.h>
 #include <stddef.h>
 #include <setjmp.h>
@@ -208,6 +209,61 @@ static void test_dm_name_good_1(void **state)
 	free((void*)name);
 }
 
+static void test_dm_uuid_false_0(void **state)
+{
+	struct uevent *uev = *state;
+
+	assert_false(uevent_is_mpath(uev));
+}
+
+static void test_dm_uuid_true_0(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[3] = "DM_UUID=mpath-foo";
+	assert_true(uevent_is_mpath(uev));
+}
+
+static void test_dm_uuid_false_1(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[3] = "DM_UUID.mpath-foo";
+	assert_false(uevent_is_mpath(uev));
+}
+
+static void test_dm_uuid_false_2(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[3] = "DM_UUID=mpath-";
+	assert_false(uevent_is_mpath(uev));
+}
+
+static void test_dm_uuid_false_3(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[3] = "DM_UU=mpath-foo";
+	assert_false(uevent_is_mpath(uev));
+}
+
+static void test_dm_uuid_false_4(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[3] = "DM_UUID=mpathfoo";
+	assert_false(uevent_is_mpath(uev));
+}
+
+static void test_dm_uuid_false_5(void **state)
+{
+	struct uevent *uev = *state;
+
+	uev->envp[3] = "DM_UUID=";
+	assert_false(uevent_is_mpath(uev));
+}
+
 int test_uevent_get_XXX(void)
 {
 	const struct CMUnitTest tests[] = {
@@ -228,6 +284,13 @@ int test_uevent_get_XXX(void)
 		cmocka_unit_test(test_dm_name_bad_0),
 		cmocka_unit_test(test_dm_name_bad_1),
 		cmocka_unit_test(test_dm_name_good_1),
+		cmocka_unit_test(test_dm_uuid_false_0),
+		cmocka_unit_test(test_dm_uuid_true_0),
+		cmocka_unit_test(test_dm_uuid_false_1),
+		cmocka_unit_test(test_dm_uuid_false_2),
+		cmocka_unit_test(test_dm_uuid_false_3),
+		cmocka_unit_test(test_dm_uuid_false_4),
+		cmocka_unit_test(test_dm_uuid_false_5),
 	};
 	return cmocka_run_group_tests(tests, setup_uev, teardown);
 }
-- 
2.15.1
