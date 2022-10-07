Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8A4C43217
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164157;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2Cu1IFmtDqMBH089pGnr1s6DBcR+Nrhx8BfE1iCyuF0=;
	b=ilgGc/nlcJlLlHcEe3wvISzs9zvrIsot3Iu0Iwhlj/a8/Uf5vUnYD72XB6ZajNK7jWx6Q5
	MyCD4qsTjrj1Ja65zylI/PDlhNAZEq88iRi/QteDbEmnKecrpYk8HPZsWtVUNFQsVSlPJB
	pvY/y9NYf9GP3SiSqYFlhC5aGNTMR3s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-iBQLCJ1jNQiZE8ZjPyN65A-1; Fri, 07 Oct 2022 13:35:53 -0400
X-MC-Unique: iBQLCJ1jNQiZE8ZjPyN65A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC1F01C08982;
	Fri,  7 Oct 2022 17:35:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB03553594D;
	Fri,  7 Oct 2022 17:35:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B57301946A49;
	Fri,  7 Oct 2022 17:35:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E6B51946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42F2020290A2; Fri,  7 Oct 2022 17:35:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2476920290AE;
 Fri,  7 Oct 2022 17:35:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZnbc006768;
 Fri, 7 Oct 2022 12:35:49 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZm03006767;
 Fri, 7 Oct 2022 12:35:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:39 -0500
Message-Id: <1665164144-6716-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 3/8] multipath tests: tests for adding and
 removing features
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/Makefile   |   2 +-
 tests/features.c | 319 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 320 insertions(+), 1 deletion(-)
 create mode 100644 tests/features.c

diff --git a/tests/Makefile b/tests/Makefile
index 109ea75b..ccdfbd15 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -16,7 +16,7 @@ CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter $(W_MISSING_INITIALIZERS)
 LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid devt mpathvalid strbuf sysfs
+	 alias directio valid devt mpathvalid strbuf sysfs features
 HELPERS := test-lib.o test-log.o
 
 .SILENT: $(TESTS:%=%.o)
diff --git a/tests/features.c b/tests/features.c
new file mode 100644
index 00000000..4d8f0860
--- /dev/null
+++ b/tests/features.c
@@ -0,0 +1,319 @@
+#include <stddef.h>
+#include <stdarg.h>
+#include <setjmp.h>
+#include <cmocka.h>
+
+#include "structs.h"
+#include "globals.c"
+
+static void test_af_null_features_ptr(void **state)
+{
+	assert_int_equal(add_feature(NULL, "test"), 1);
+}
+
+static void af_helper(const char *features_start, const char *addition,
+		      const char *features_end, int result)
+{
+	char *f = NULL, *orig = NULL;
+
+	if (features_start) {
+		f = strdup(features_start);
+		assert_non_null(f);
+		orig = f;
+	}
+	assert_int_equal(add_feature(&f, addition), result);
+	if (result != 0 || features_end == NULL)
+		assert_ptr_equal(orig, f);
+	else
+		assert_string_equal(f, features_end);
+	free(f);
+}
+
+static void test_af_null_addition1(void **state)
+{
+	af_helper("0", NULL, NULL, 0);
+}
+
+static void test_af_null_addition2(void **state)
+{
+	af_helper("1 queue_if_no_path", NULL, NULL, 0);
+}
+
+static void test_af_empty_addition(void **state)
+{
+	af_helper("2 pg_init_retries 5", "", NULL, 0);
+}
+
+static void test_af_invalid_addition1(void **state)
+{
+	af_helper("2 pg_init_retries 5", " ", NULL, 1);
+}
+
+static void test_af_invalid_addition2(void **state)
+{
+	af_helper("2 pg_init_retries 5", "\tbad", NULL, 1);
+}
+
+static void test_af_invalid_addition3(void **state)
+{
+	af_helper("2 pg_init_retries 5", "bad ", NULL, 1);
+}
+ 
+static void test_af_invalid_addition4(void **state)
+{
+	af_helper("2 pg_init_retries 5", " bad ", NULL, 1);
+}
+ 
+static void test_af_null_features1(void **state)
+{
+	af_helper(NULL, "test", "1 test", 0);
+}
+
+static void test_af_null_features2(void **state)
+{
+	af_helper(NULL, "test\t  more", "2 test\t  more", 0);
+}
+
+static void test_af_null_features3(void **state)
+{
+	af_helper(NULL, "test\neven\tmore", "3 test\neven\tmore", 0);
+}
+
+static void test_af_already_exists1(void **state)
+{
+	af_helper("4 this is a test", "test", NULL, 0);
+}
+
+static void test_af_already_exists2(void **state)
+{
+	af_helper("5 contest testy intestine test retest", "test", NULL, 0);
+}
+
+static void test_af_almost_exists(void **state)
+{
+	af_helper("3 contest testy intestine", "test",
+		  "4 contest testy intestine test", 0);
+}
+
+static void test_af_bad_features1(void **state)
+{
+	af_helper("bad", "test", NULL, 1);
+}
+
+static void test_af_bad_features2(void **state)
+{
+	af_helper("1bad", "test", NULL, 1);
+}
+
+static void test_af_add1(void **state)
+{
+	af_helper("0", "test", "1 test", 0);
+}
+
+static void test_af_add2(void **state)
+{
+	af_helper("0", "this is a test", "4 this is a test", 0);
+}
+
+static void test_af_add3(void **state)
+{
+	af_helper("1 features", "more values", "3 features more values", 0);
+}
+
+static void test_af_add4(void **state)
+{
+	af_helper("2 one\ttwo", "three\t four", "4 one\ttwo three\t four", 0);
+}
+
+static int test_add_features(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_af_null_features_ptr),
+		cmocka_unit_test(test_af_null_addition1),
+		cmocka_unit_test(test_af_null_addition2),
+		cmocka_unit_test(test_af_empty_addition),
+		cmocka_unit_test(test_af_invalid_addition1),
+		cmocka_unit_test(test_af_invalid_addition2),
+		cmocka_unit_test(test_af_invalid_addition3),
+		cmocka_unit_test(test_af_invalid_addition4),
+		cmocka_unit_test(test_af_null_features1),
+		cmocka_unit_test(test_af_null_features2),
+		cmocka_unit_test(test_af_null_features3),
+		cmocka_unit_test(test_af_already_exists1),
+		cmocka_unit_test(test_af_already_exists2),
+		cmocka_unit_test(test_af_almost_exists),
+		cmocka_unit_test(test_af_bad_features1),
+		cmocka_unit_test(test_af_bad_features2),
+		cmocka_unit_test(test_af_add1),
+		cmocka_unit_test(test_af_add2),
+		cmocka_unit_test(test_af_add3),
+		cmocka_unit_test(test_af_add4),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
+static void test_rf_null_features_ptr(void **state)
+{
+	assert_int_equal(remove_feature(NULL, "test"), 1);
+}
+
+static void test_rf_null_features(void **state)
+{
+	char *f = NULL;
+	assert_int_equal(remove_feature(&f, "test"), 1);
+}
+
+static void rf_helper(const char *features_start, const char *removal,
+		      const char *features_end, int result)
+{
+	char *f = strdup(features_start);
+	char *orig = f;
+
+	assert_non_null(f);
+	assert_int_equal(remove_feature(&f, removal), result);
+	if (result != 0 || features_end == NULL)
+		assert_ptr_equal(orig, f);
+	else
+		assert_string_equal(f, features_end);
+	free(f);
+}
+
+static void test_rf_null_removal(void **state)
+{
+	rf_helper("1 feature", NULL, NULL, 0);
+}
+
+static void test_rf_empty_removal(void **state)
+{
+	rf_helper("1 feature", "", NULL, 0);
+}
+
+static void test_rf_invalid_removal1(void **state)
+{
+	rf_helper("1 feature", " ", NULL, 1);
+}
+
+static void test_rf_invalid_removal2(void **state)
+{
+	rf_helper("1 feature", " bad", NULL, 1);
+}
+
+static void test_rf_invalid_removal3(void **state)
+{
+	rf_helper("1 feature", "bad\n", NULL, 1);
+}
+
+static void test_rf_invalid_removal4(void **state)
+{
+	rf_helper("1 feature", "\tbad  \n", NULL, 1);
+}
+
+static void test_rf_bad_features1(void **state)
+{
+	rf_helper("invalid feature test string", "test", NULL, 1);
+}
+
+static void test_rf_bad_features2(void **state)
+{
+	rf_helper("2no space test", "test", NULL, 1);
+}
+
+static void test_rf_missing_removal1(void **state)
+{
+	rf_helper("0", "test", NULL, 0);
+}
+
+static void test_rf_missing_removal2(void **state)
+{
+	rf_helper("1 detest", "test", NULL, 0);
+}
+
+static void test_rf_missing_removal3(void **state)
+{
+	rf_helper("4 testing one two three", "test", NULL, 0);
+}
+
+static void test_rf_missing_removal4(void **state)
+{
+	rf_helper("1 contestant", "test", NULL, 0);
+}
+
+static void test_rf_missing_removal5(void **state)
+{
+	rf_helper("3 testament protest detestable", "test", NULL, 0);
+}
+
+static void test_rf_remove_all_features1(void **state)
+{
+	rf_helper("1 test", "test", "0", 0);
+}
+
+static void test_rf_remove_all_features2(void **state)
+{
+	rf_helper("2 another\t test", "another\t test", "0", 0);
+}
+
+static void test_rf_remove1(void **state)
+{
+	rf_helper("2 feature1 feature2", "feature2", "1 feature1", 0);
+}
+
+static void test_rf_remove2(void **state)
+{
+	rf_helper("2 feature1 feature2", "feature1", "1 feature2", 0);
+}
+
+static void test_rf_remove3(void **state)
+{
+	rf_helper("3 test1 test\ttest2", "test", "2 test1 test2", 0);
+}
+
+static void test_rf_remove4(void **state)
+{
+	rf_helper("4 this\t is a test", "is a", "2 this\t test", 0);
+}
+
+static void test_rf_remove5(void **state)
+{
+	rf_helper("3 one more test", "more test", "1 one", 0);
+}
+
+static int test_remove_features(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_rf_null_features_ptr),
+		cmocka_unit_test(test_rf_null_features),
+		cmocka_unit_test(test_rf_null_removal),
+		cmocka_unit_test(test_rf_empty_removal),
+		cmocka_unit_test(test_rf_invalid_removal1),
+		cmocka_unit_test(test_rf_invalid_removal2),
+		cmocka_unit_test(test_rf_invalid_removal3),
+		cmocka_unit_test(test_rf_invalid_removal4),
+		cmocka_unit_test(test_rf_bad_features1),
+		cmocka_unit_test(test_rf_bad_features2),
+		cmocka_unit_test(test_rf_missing_removal1),
+		cmocka_unit_test(test_rf_missing_removal2),
+		cmocka_unit_test(test_rf_missing_removal3),
+		cmocka_unit_test(test_rf_missing_removal4),
+		cmocka_unit_test(test_rf_missing_removal5),
+		cmocka_unit_test(test_rf_remove_all_features1),
+		cmocka_unit_test(test_rf_remove_all_features2),
+		cmocka_unit_test(test_rf_remove1),
+		cmocka_unit_test(test_rf_remove2),
+		cmocka_unit_test(test_rf_remove3),
+		cmocka_unit_test(test_rf_remove4),
+		cmocka_unit_test(test_rf_remove5),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	init_test_verbosity(-1);
+	ret += test_add_features();
+	ret += test_remove_features();
+
+	return ret;
+}
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

