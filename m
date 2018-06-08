From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 27/28] libmultipath: escape '"' chars while
	dumping config
Date: Fri,  8 Jun 2018 12:20:40 +0200
Message-ID: <20180608102041.22904-28-mwilck@suse.com>
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

Since 044c5d6b "libmultipath: config parser: Allow '"' in strings",
double quotes can be part of string values in multipath.conf by escaping
them as double-double quotes ('""'). When dumping the configuration,
the un-escaping done during config file parsing must be reverted by replacing
'"' with '""' again.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 40 ++++++++++++++++++++++++++++++++++++++--
 tests/hwtable.c     | 18 ------------------
 2 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 3e7c5d6d..b5958980 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -109,9 +109,45 @@ print_nonzero (char *buff, int len, long v)
 static int
 print_str (char *buff, int len, const char *ptr)
 {
-	if (!ptr)
+	char *p;
+	char *last;
+	const char *q;
+
+	if (!ptr || len <= 0)
 		return 0;
-	return snprintf(buff, len, "\"%s\"", ptr);
+
+	q = strchr(ptr, '"');
+	if (q == NULL)
+		return snprintf(buff, len, "\"%s\"", ptr);
+
+	last = buff + len - 1;
+	p = buff;
+	if (p >= last)
+		goto out;
+	*p++ = '"';
+	if (p >= last)
+		goto out;
+	for (; q; q = strchr(ptr, '"')) {
+		if (q + 1 - ptr < last - p)
+			p = mempcpy(p, ptr, q + 1 - ptr);
+		else {
+			p = mempcpy(p, ptr, last - p);
+			goto out;
+		}
+		*p++ = '"';
+		if (p >= last)
+			goto out;
+		ptr = q + 1;
+	}
+	p += strlcpy(p, ptr, last - p);
+	if (p >= last)
+		goto out;
+	*p++ = '"';
+	*p = '\0';
+	return p - buff;
+out:
+	*p = '\0';
+	return len;
 }
 
 static int
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 7daf71eb..9db79391 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -598,18 +598,10 @@ static int setup_internal_nvme(void **state)
 /*
  * Device section with a simple entry qith double quotes ('foo:"bar"')
  */
-#if BROKEN
-static void test_quoted_hwe(void **state)
-#else
 static void test_quoted_hwe(const struct hwt_state *hwt)
-#endif
 {
 	struct path *pp;
-#if BROKEN
-       struct hwt_state *hwt = CHECK_STATE(state);
 
-       _conf = LOAD_CONFIG(hwt);
-#endif
 	/* foo:"bar" matches */
 	pp = mock_path(vnd_foo.value, prd_baq.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
@@ -625,11 +617,7 @@ static int setup_quoted_hwe(void **state)
 	const struct key_value kv[] = { vnd_foo, prd_baqq, prio_emc };
 
 	WRITE_ONE_DEVICE(hwt, kv);
-#if BROKEN
-       condlog(0, "%s: WARNING: skipping conf reload test", __func__);
-#else
 	SET_TEST_FUNC(hwt, test_quoted_hwe);
-#endif
 	return 0;
 }
 
@@ -1640,9 +1628,7 @@ static int setup_multipath_config_3(void **state)
 	}
 
 define_test(string_hwe)
-#if !BROKEN
 define_test(quoted_hwe)
-#endif
 define_test(internal_nvme)
 define_test(regex_hwe)
 define_test(regex_string_hwe)
@@ -1680,11 +1666,7 @@ static int test_hwtable(void)
 		cmocka_unit_test(test_sanity_globals),
 		test_entry(internal_nvme),
 		test_entry(string_hwe),
-#if BROKEN
-		cmocka_unit_test_setup(test_quoted_hwe, setup_quoted_hwe),
-#else
 		test_entry(quoted_hwe),
-#endif
 		test_entry(regex_hwe),
 		test_entry(regex_string_hwe),
 		test_entry(regex_string_hwe_dir),
-- 
2.17.0
