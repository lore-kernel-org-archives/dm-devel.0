Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE5FC43219
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164157;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/3LZB8nEX308KJ9mVztKt+32oKUcigI0n25tu07Xwfg=;
	b=AeQoDCm4+7yoZYsLDqXrjAITXKYA1RdHHh+McvENXrnzE9/KlN6U0wXbllBFQdkVRxtsl0
	CvH+myj43WI1lasBdFddzZpjo+bdwYQdhJjq1rklY8N0TkOa/b9mCxXCLDrUvmwmRnnO1y
	YUUYCkgvVCAr7sNF4SgYESHxUTSVQDw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-IdDPax2rOGiTCRZv2xUGLQ-1; Fri, 07 Oct 2022 13:35:56 -0400
X-MC-Unique: IdDPax2rOGiTCRZv2xUGLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDC7986EB21;
	Fri,  7 Oct 2022 17:35:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC3272166B4D;
	Fri,  7 Oct 2022 17:35:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9BC741946A49;
	Fri,  7 Oct 2022 17:35:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 411451946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2868440F9D40; Fri,  7 Oct 2022 17:35:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07B3640EFB3F;
 Fri,  7 Oct 2022 17:35:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZolT006776;
 Fri, 7 Oct 2022 12:35:51 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZoGq006775;
 Fri, 7 Oct 2022 12:35:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:41 -0500
Message-Id: <1665164144-6716-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 5/8] multipath tests: tests for
 reconcile_features_with_queue_mode
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/Makefile   |   2 +
 tests/features.c | 232 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 233 insertions(+), 1 deletion(-)

diff --git a/tests/Makefile b/tests/Makefile
index ccdfbd15..bc9380f8 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -36,6 +36,7 @@ ifneq ($(DIO_TEST_DEV),)
 directio-test_FLAGS := -DDIO_TEST_DEV=\"$(DIO_TEST_DEV)\"
 endif
 mpathvalid-test_FLAGS := -I$(mpathvaliddir)
+features-test_FLAGS := -I$(multipathdir)/nvme
 
 # test-specific linker flags
 # XYZ-test_TESTDEPS: test libraries containing __wrap_xyz functions
@@ -73,6 +74,7 @@ strbuf-test_OBJDEPS := $(mpathutildir)/strbuf.o
 sysfs-test_TESTDEPS := test-log.o
 sysfs-test_OBJDEPS := $(multipathdir)/sysfs.o $(mpathutildir)/util.o
 sysfs-test_LIBDEPS := -ludev -lpthread -ldl
+features-test_LIBDEPS := -ludev -lpthread
 
 %.o: %.c
 	$(CC) $(CPPFLAGS) $(CFLAGS) $($*-test_FLAGS) -c -o $@ $<
diff --git a/tests/features.c b/tests/features.c
index 4d8f0860..31f978fd 100644
--- a/tests/features.c
+++ b/tests/features.c
@@ -1,9 +1,10 @@
+#define _GNU_SOURCE
 #include <stddef.h>
 #include <stdarg.h>
 #include <setjmp.h>
 #include <cmocka.h>
 
-#include "structs.h"
+#include "../libmultipath/propsel.c"
 #include "globals.c"
 
 static void test_af_null_features_ptr(void **state)
@@ -307,6 +308,234 @@ static int test_remove_features(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+static void test_cf_null_features(void **state)
+{
+	struct multipath mp = {
+			.alias = "test",
+	};
+	reconcile_features_with_queue_mode(&mp);
+	assert_null(mp.features);
+}
+
+static void cf_helper(const char *features_start, const char *features_end,
+		      int queue_mode_start, int queue_mode_end)
+{
+	struct multipath mp = {
+			.alias = "test",
+			.features = strdup(features_start),
+			.queue_mode = queue_mode_start,
+	};
+	char *orig = mp.features;
+
+	assert_non_null(orig);
+	reconcile_features_with_queue_mode(&mp);
+	if (!features_end)
+		assert_ptr_equal(orig, mp.features);
+	else
+		assert_string_equal(mp.features, features_end);
+	free(mp.features);
+	assert_int_equal(mp.queue_mode, queue_mode_end);
+}
+
+static void test_cf_unset_unset1(void **state)
+{
+	cf_helper("0", NULL, QUEUE_MODE_UNDEF, QUEUE_MODE_UNDEF);
+}
+
+static void test_cf_unset_unset2(void **state)
+{
+	cf_helper("1 queue_mode", NULL, QUEUE_MODE_UNDEF, QUEUE_MODE_UNDEF);
+}
+
+static void test_cf_unset_unset3(void **state)
+{
+	cf_helper("queue_mode", NULL, QUEUE_MODE_UNDEF, QUEUE_MODE_UNDEF);
+}
+
+static void test_cf_unset_unset4(void **state)
+{
+	cf_helper("2 queue_model bio", NULL, QUEUE_MODE_UNDEF,
+		  QUEUE_MODE_UNDEF);
+}
+
+static void test_cf_unset_unset5(void **state)
+{
+	cf_helper("1 queue_if_no_path", NULL, QUEUE_MODE_UNDEF,
+		  QUEUE_MODE_UNDEF);
+}
+
+static void test_cf_invalid_unset1(void **state)
+{
+	cf_helper("2 queue_mode biop", "0", QUEUE_MODE_UNDEF, QUEUE_MODE_UNDEF);
+}
+
+static void test_cf_invalid_unset2(void **state)
+{
+	cf_helper("3 queue_mode rqs queue_if_no_path", "1 queue_if_no_path",
+		  QUEUE_MODE_UNDEF, QUEUE_MODE_UNDEF);
+}
+
+static void test_cf_rq_unset1(void **state)
+{
+	cf_helper("2 queue_mode rq", NULL, QUEUE_MODE_UNDEF, QUEUE_MODE_RQ);
+}
+
+static void test_cf_rq_unset2(void **state)
+{
+	cf_helper("2 queue_mode mq", NULL, QUEUE_MODE_UNDEF, QUEUE_MODE_RQ);
+}
+
+static void test_cf_bio_unset(void **state)
+{
+	cf_helper("2 queue_mode bio", NULL, QUEUE_MODE_UNDEF, QUEUE_MODE_BIO);
+}
+
+static void test_cf_unset_bio1(void **state)
+{
+	cf_helper("1 queue_if_no_path", "3 queue_if_no_path queue_mode bio",
+		  QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_unset_bio2(void **state)
+{
+	cf_helper("0", "2 queue_mode bio", QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_unset_bio3(void **state)
+{
+	cf_helper("2 pg_init_retries 50", "4 pg_init_retries 50 queue_mode bio",
+		  QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_invalid_bio1(void **state)
+{
+	cf_helper("2 queue_mode bad", "2 queue_mode bio",
+		  QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_invalid_bio2(void **state)
+{
+	cf_helper("3 queue_if_no_path queue_mode\tbad", "3 queue_if_no_path queue_mode bio",
+		  QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_bio_bio1(void **state)
+{
+	cf_helper("2 queue_mode bio", NULL, QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_bio_bio2(void **state)
+{
+	cf_helper("3 queue_if_no_path queue_mode bio", NULL, QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_bio_bio3(void **state)
+{
+	cf_helper("3 queue_mode\nbio queue_if_no_path", NULL, QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_bio_rq1(void **state)
+{
+	cf_helper("2\nqueue_mode\tbio", "0", QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_bio_rq2(void **state)
+{
+	cf_helper("3 queue_if_no_path\nqueue_mode bio", "1 queue_if_no_path",
+		  QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_bio_rq3(void **state)
+{
+	cf_helper("4 queue_mode bio pg_init_retries 20", "2 pg_init_retries 20",
+		  QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_unset_rq1(void **state)
+{
+	cf_helper("0", NULL, QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_unset_rq2(void **state)
+{
+	cf_helper("2 pg_init_retries 15", NULL, QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_invalid_rq1(void **state)
+{
+	cf_helper("2 queue_mode bionic", "0", QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_invalid_rq2(void **state)
+{
+	cf_helper("3 queue_mode b\nqueue_if_no_path", "1 queue_if_no_path",
+		  QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_rq_rq1(void **state)
+{
+	cf_helper("2 queue_mode rq", NULL, QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_rq_rq2(void **state)
+{
+	cf_helper("3 queue_mode\t \trq\nqueue_if_no_path", NULL, QUEUE_MODE_RQ, QUEUE_MODE_RQ);
+}
+
+static void test_cf_rq_bio1(void **state)
+{
+	cf_helper("2 queue_mode rq", "2 queue_mode bio", QUEUE_MODE_BIO,
+		  QUEUE_MODE_BIO);
+}
+
+static void test_cf_rq_bio2(void **state)
+{
+	cf_helper("3 queue_if_no_path\nqueue_mode rq", "3 queue_if_no_path queue_mode bio", QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static void test_cf_rq_bio3(void **state)
+{
+	cf_helper("3 queue_mode rq\nqueue_if_no_path", "3 queue_if_no_path queue_mode bio", QUEUE_MODE_BIO, QUEUE_MODE_BIO);
+}
+
+static int test_reconcile_features(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_cf_null_features),
+		cmocka_unit_test(test_cf_unset_unset1),
+		cmocka_unit_test(test_cf_unset_unset2),
+		cmocka_unit_test(test_cf_unset_unset3),
+		cmocka_unit_test(test_cf_unset_unset4),
+		cmocka_unit_test(test_cf_unset_unset5),
+		cmocka_unit_test(test_cf_invalid_unset1),
+		cmocka_unit_test(test_cf_invalid_unset2),
+		cmocka_unit_test(test_cf_rq_unset1),
+		cmocka_unit_test(test_cf_rq_unset2),
+		cmocka_unit_test(test_cf_bio_unset),
+		cmocka_unit_test(test_cf_unset_bio1),
+		cmocka_unit_test(test_cf_unset_bio2),
+		cmocka_unit_test(test_cf_unset_bio3),
+		cmocka_unit_test(test_cf_invalid_bio1),
+		cmocka_unit_test(test_cf_invalid_bio2),
+		cmocka_unit_test(test_cf_bio_bio1),
+		cmocka_unit_test(test_cf_bio_bio2),
+		cmocka_unit_test(test_cf_bio_bio3),
+		cmocka_unit_test(test_cf_bio_rq1),
+		cmocka_unit_test(test_cf_bio_rq2),
+		cmocka_unit_test(test_cf_bio_rq3),
+		cmocka_unit_test(test_cf_unset_rq1),
+		cmocka_unit_test(test_cf_unset_rq2),
+		cmocka_unit_test(test_cf_invalid_rq1),
+		cmocka_unit_test(test_cf_invalid_rq2),
+		cmocka_unit_test(test_cf_rq_rq1),
+		cmocka_unit_test(test_cf_rq_rq2),
+		cmocka_unit_test(test_cf_rq_bio1),
+		cmocka_unit_test(test_cf_rq_bio2),
+		cmocka_unit_test(test_cf_rq_bio3),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
 int main(void)
 {
 	int ret = 0;
@@ -314,6 +543,7 @@ int main(void)
 	init_test_verbosity(-1);
 	ret += test_add_features();
 	ret += test_remove_features();
+	ret += test_reconcile_features();
 
 	return ret;
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

