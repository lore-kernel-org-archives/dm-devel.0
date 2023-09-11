Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE11EEB57E
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450386;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FjUQLO3WYpbNTU34IKy1plm0822u9TuvJclrmLm3veU=;
	b=h4vrRilFpUYEMJwQ7huWV4Hv6Wch/s/07u5sPC7daBQkSb1jdnc+cEr0awYtjc9bBFICvP
	i9FNsbPmtdqNKGWJbP90uRe0w5y+KVUGxNca30aoYCcMcHEJ9rq+AfNXWPMtcH4gz6H6Rx
	Qi6hKNwa8dHquoA9NVJvvoXcDNZkrmo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-dXRVL37CMNC7Ur8FwHTRdw-1; Mon, 11 Sep 2023 12:39:38 -0400
X-MC-Unique: dXRVL37CMNC7Ur8FwHTRdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0141D928BAC;
	Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E15421006B56;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F5AF19465B5;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96D1919465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6753F2022EBE; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F4092023466
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40DB429DD991
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-SD0FEZ-_OGew-dtfscNXsA-1; Mon,
 11 Sep 2023 12:39:23 -0400
X-MC-Unique: SD0FEZ-_OGew-dtfscNXsA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id E12C321875;
 Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B2731139CC;
 Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id aN7kKblC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:21 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:37 +0200
Message-ID: <20230911163846.27197-29-mwilck@suse.com>
In-Reply-To: <20230911163846.27197-1-mwilck@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 28/37] multipath-tools tests: mock
 pthread_mutex_{lock, unlock}
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If some test fails with a lock held, cmocka doesn't deal well with
pthread_cleanup_pop(). Such tests can cause deadlock with the locking
primitives in the alias code, because locks don't get properly unlocked.  Just
mock the lock/unlock functions and generate an error if they weren't paired at
the end of the test.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile |  1 +
 tests/alias.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/tests/Makefile b/tests/Makefile
index c777d07..7dac8a8 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -52,6 +52,7 @@ blacklist-test_LIBDEPS := -ludev
 vpd-test_OBJDEPS :=  $(multipathdir)/discovery.o
 vpd-test_LIBDEPS := -ludev -lpthread -ldl
 alias-test_TESTDEPS := test-log.o
+alias-test_OBJDEPS := $(mpathutildir)/util.o
 alias-test_LIBDEPS := -lpthread -ldl
 valid-test_OBJDEPS := $(multipathdir)/valid.o $(multipathdir)/discovery.o
 valid-test_LIBDEPS := -lmount -ludev -lpthread -ldl
diff --git a/tests/alias.c b/tests/alias.c
index 872b1fc..962c158 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -89,6 +89,47 @@ int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
 	return ret;
 }
 
+static int lock_errors;
+static int bindings_locked;
+static int timestamp_locked;
+int __wrap_pthread_mutex_lock(pthread_mutex_t *mutex)
+{
+	if (mutex == &bindings_mutex) {
+		if (bindings_locked) {
+			fprintf(stderr, "%s: bindings_mutex LOCKED\n", __func__);
+			lock_errors++;
+		}
+		bindings_locked = 1;
+	}  else if (mutex == &timestamp_mutex) {
+		if (timestamp_locked) {
+			fprintf(stderr, "%s: timestamp_mutex LOCKED\n", __func__);
+			lock_errors++;
+		}
+		timestamp_locked = 1;
+	} else
+		  fprintf(stderr, "%s called for unknown mutex %p\n", __func__, mutex);
+	return 0;
+}
+
+int __wrap_pthread_mutex_unlock(pthread_mutex_t *mutex)
+{
+	if (mutex == &bindings_mutex) {
+		if (!bindings_locked) {
+			fprintf(stderr, "%s: bindings_mutex UNLOCKED\n", __func__);
+			lock_errors++;
+		}
+		bindings_locked = 0;
+	}  else if (mutex == &timestamp_mutex) {
+		if (!timestamp_locked) {
+			fprintf(stderr, "%s: timestamp_mutex UNLOCKED\n", __func__);
+			lock_errors++;
+		}
+		timestamp_locked = 0;
+	} else
+		  fprintf(stderr, "%s called for unknown mutex %p\n", __func__, mutex);
+	return 0;
+}
+
 #define TEST_FDNO 1234
 #define TEST_FPTR ((FILE *) 0xaffe)
 
@@ -1718,6 +1759,10 @@ static void gufa_old_nomatch_nowwidmatch(void **state) {
 	free(alias);
 }
 
+static void gufa_check_locking(void **state) {
+	assert_int_equal(lock_errors, 0);
+}
+
 static int test_get_user_friendly_alias()
 {
 	const struct CMUnitTest tests[] = {
@@ -1743,6 +1788,7 @@ static int test_get_user_friendly_alias()
 		cmocka_unit_test_teardown(gufa_old_nomatch_wwidmatch, teardown_bindings),
 		cmocka_unit_test_teardown(gufa_old_nomatch_wwidmatch_used, teardown_bindings),
 		cmocka_unit_test_teardown(gufa_old_nomatch_nowwidmatch, teardown_bindings),
+		cmocka_unit_test(gufa_check_locking),
 	};
 
 	return cmocka_run_group_tests(tests, NULL, NULL);
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

