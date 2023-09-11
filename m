Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4209EE57DF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450371;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5rSyM40fPUjiNwK17h4GLuW3m/zO/oypEBQwepguco8=;
	b=LvYNM7/XIc3UH21tToB2Fv7yYgTiuhsHk2M5Ceh/4kncDBqGP1DYCgSbcRx37fmwfg/qYV
	+HZIH1b7/ARJJzr5KpwkkblFEXTXN6Nq59k8Puk/Gvc8yuBipPimwd0otXcZS8YvyNNLOU
	+iUmAEt0jVO1IQgnRbkltoDYdBYKrfs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-1gra6GjFPsWVxOdN09hUpA-1; Mon, 11 Sep 2023 12:39:25 -0400
X-MC-Unique: 1gra6GjFPsWVxOdN09hUpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 641661C05ECE;
	Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FBF02156702;
	Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C74A419465A4;
	Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2340D19465A3
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 020ED568FF; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EDC0E4404C
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C840E38117E6
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:19 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-BpDAypoWMGGNhWykVMF6QQ-1; Mon,
 11 Sep 2023 12:39:18 -0400
X-MC-Unique: BpDAypoWMGGNhWykVMF6QQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 96F8A21882;
 Mon, 11 Sep 2023 16:39:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67F1513AD1;
 Mon, 11 Sep 2023 16:39:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id EAC1F7RC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:16 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:17 +0200
Message-ID: <20230911163846.27197-9-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 08/37] multipath-tools test: consistent use of
 macros in alias test
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Use the macros introduced with the tests for get_user_friendly_alias()
also in the previously existing tests.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/alias.c | 80 ++++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 42 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index 7e443b0..427b281 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -490,7 +490,7 @@ static void lb_empty(void **state)
 	char *alias;
 
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, NULL, 0);
 	assert_int_equal(rc, 1);
 	assert_ptr_equal(alias, NULL);
@@ -503,7 +503,7 @@ static void lb_empty_unused(void **state)
 
 	will_return(__wrap_fgets, NULL);
 	mock_unused_alias("MPATHa");
-	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
 	assert_int_equal(rc, 1);
 	assert_ptr_equal(alias, NULL);
@@ -518,7 +518,7 @@ static void lb_empty_failed(void **state)
 	will_return(__wrap_fgets, NULL);
 	mock_failed_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
 	mock_unused_alias("MPATHb");
-	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -533,7 +533,7 @@ static void lb_empty_1_used(void **state)
 	will_return(__wrap_fgets, NULL);
 	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
 	mock_unused_alias("MPATHb");
-	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -548,7 +548,7 @@ static void lb_empty_1_used_self(void **state)
 	will_return(__wrap_fgets, NULL);
 	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
 	mock_self_alias("MPATHb", "WWID0");
-	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -561,8 +561,7 @@ static void lb_match_a(void **state)
 	char *alias;
 
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
-	expect_condlog(3, "Found matching wwid [WWID0] in bindings file."
-		       " Setting alias to MPATHa\n");
+	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 0);
 	assert_int_equal(rc, 0);
 	assert_ptr_not_equal(alias, NULL);
@@ -577,7 +576,7 @@ static void lb_nomatch_a(void **state)
 
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching wwid [WWID1] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
 	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 0);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -590,7 +589,7 @@ static void lb_nomatch_a_bad_check(void **state)
 
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(0, "no more available user_friendly_names\n");
+	expect_condlog(0, NOMORE_STR);
 	rc = lookup_binding(NULL, "WWID1", &alias, NULL, 1);
 	assert_int_equal(rc, -1);
 	assert_ptr_equal(alias, NULL);
@@ -604,7 +603,7 @@ static void lb_nomatch_a_unused(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	mock_unused_alias("MPATHb");
-	expect_condlog(3, "No matching wwid [WWID1] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
 	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -622,7 +621,7 @@ static void lb_nomatch_a_3_used_failed_self(void **state)
 	mock_used_alias("MPATHd", USED_STR("MPATHd", "WWID1"));
 	mock_failed_alias("MPATHe", USED_STR("MPATHe", "WWID1"));
 	mock_self_alias("MPATHf", "WWID1");
-	expect_condlog(3, "No matching wwid [WWID1] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
 	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
 	assert_int_equal(rc, 6);
 	assert_ptr_equal(alias, NULL);
@@ -635,8 +634,7 @@ static void do_lb_match_c(void **state, int check_if_taken)
 
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, "MPATHc WWID1\n");
-	expect_condlog(3, "Found matching wwid [WWID1] in bindings file."
-		       " Setting alias to MPATHc\n");
+	expect_condlog(3, FOUND_STR("MPATHc", "WWID1"));
 	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", check_if_taken);
 	assert_int_equal(rc, 0);
 	assert_ptr_not_equal(alias, NULL);
@@ -662,7 +660,7 @@ static void lb_nomatch_a_c(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, "MPATHc WWID1\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -677,7 +675,7 @@ static void lb_nomatch_a_d_unused(void **state)
 	will_return(__wrap_fgets, "MPATHd WWID1\n");
 	will_return(__wrap_fgets, NULL);
 	mock_unused_alias("MPATHb");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -693,7 +691,7 @@ static void lb_nomatch_a_d_1_used(void **state)
 	will_return(__wrap_fgets, NULL);
 	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
 	mock_unused_alias("MPATHc");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, 3);
 	assert_ptr_equal(alias, NULL);
@@ -710,7 +708,7 @@ static void lb_nomatch_a_d_2_used(void **state)
 	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
 	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID2"));
 	mock_unused_alias("MPATHe");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, 5);
 	assert_ptr_equal(alias, NULL);
@@ -728,7 +726,7 @@ static void lb_nomatch_a_d_3_used(void **state)
 	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID2"));
 	mock_used_alias("MPATHe", USED_STR("MPATHe", "WWID2"));
 	mock_unused_alias("MPATHf");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, 6);
 	assert_ptr_equal(alias, NULL);
@@ -742,7 +740,7 @@ static void lb_nomatch_c_a(void **state)
 	will_return(__wrap_fgets, "MPATHc WWID1\n");
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -758,7 +756,7 @@ static void lb_nomatch_d_a_unused(void **state)
 	will_return(__wrap_fgets, "MPATHd WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	mock_unused_alias("MPATHb");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
@@ -775,7 +773,7 @@ static void lb_nomatch_d_a_1_used(void **state)
 	will_return(__wrap_fgets, NULL);
 	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
 	mock_unused_alias("MPATHe");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, 5);
 	assert_ptr_equal(alias, NULL);
@@ -790,7 +788,7 @@ static void lb_nomatch_a_b(void **state)
 	will_return(__wrap_fgets, "MPATHz WWID26\n");
 	will_return(__wrap_fgets, "MPATHb WWID1\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 3);
 	assert_ptr_equal(alias, NULL);
@@ -806,7 +804,7 @@ static void lb_nomatch_a_b_bad(void **state)
 	will_return(__wrap_fgets, "MPATHb\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "Ignoring malformed line 3 in bindings file\n");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 3);
 	assert_ptr_equal(alias, NULL);
@@ -823,7 +821,7 @@ static void lb_nomatch_a_b_bad_self(void **state)
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "Ignoring malformed line 3 in bindings file\n");
 	mock_self_alias("MPATHc", "WWID2");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, 3);
 	assert_ptr_equal(alias, NULL);
@@ -838,7 +836,7 @@ static void lb_nomatch_b_a(void **state)
 	will_return(__wrap_fgets, "MPATHz WWID26\n");
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 27);
 	assert_ptr_equal(alias, NULL);
@@ -857,7 +855,7 @@ static void lb_nomatch_b_a_3_used(void **state)
 	mock_used_alias("MPATHab", USED_STR("MPATHab", "WWID2"));
 	mock_used_alias("MPATHac", USED_STR("MPATHac", "WWID2"));
 	mock_unused_alias("MPATHad");
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, 30);
 	assert_ptr_equal(alias, NULL);
@@ -873,7 +871,7 @@ static void do_lb_nomatch_int_max(void **state, int check_if_taken)
 	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n");
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(0, "no more available user_friendly_names\n");
+	expect_condlog(0, NOMORE_STR);
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", check_if_taken);
 	assert_int_equal(rc, -1);
 	assert_ptr_equal(alias, NULL);
@@ -898,7 +896,7 @@ static void lb_nomatch_int_max_used(void **state)
 	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n");
 	will_return(__wrap_fgets, NULL);
 	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
-	expect_condlog(0, "no more available user_friendly_names\n");
+	expect_condlog(0, NOMORE_STR);
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, -1);
 	assert_ptr_equal(alias, NULL);
@@ -913,7 +911,7 @@ static void lb_nomatch_int_max_m1(void **state)
 	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, INT_MAX);
 	assert_ptr_equal(alias, NULL);
@@ -929,7 +927,7 @@ static void lb_nomatch_int_max_m1_used(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	mock_used_alias("MPATH" MPATH_ID_INT_MAX, USED_STR("MPATH" MPATH_ID_INT_MAX, "WWID2"));
-	expect_condlog(0, "no more available user_friendly_names\n");
+	expect_condlog(0, NOMORE_STR);
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, -1);
 	assert_ptr_equal(alias, NULL);
@@ -945,7 +943,7 @@ static void lb_nomatch_int_max_m1_1_used(void **state)
 	will_return(__wrap_fgets, NULL);
 	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
 	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
-	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, INT_MAX);
 	assert_ptr_equal(alias, NULL);
@@ -961,7 +959,7 @@ static void lb_nomatch_int_max_m1_2_used(void **state)
 	will_return(__wrap_fgets, NULL);
 	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
 	mock_used_alias("MPATH" MPATH_ID_INT_MAX, USED_STR("MPATH" MPATH_ID_INT_MAX, "WWID2"));
-	expect_condlog(0, "no more available user_friendly_names\n");
+	expect_condlog(0, NOMORE_STR);
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, -1);
 	assert_ptr_equal(alias, NULL);
@@ -1017,7 +1015,7 @@ static void rl_empty(void **state)
 
 	buf[0] = '\0';
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching alias [MPATHa] in bindings file.\n");
+	expect_condlog(3, NOMATCH_STR("MPATHa"));
 	rc = rlookup_binding(NULL, buf, "MPATHa");
 	assert_int_equal(rc, -1);
 	assert_string_equal(buf, "");
@@ -1030,8 +1028,7 @@ static void rl_match_a(void **state)
 
 	buf[0] = '\0';
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
-	expect_condlog(3, "Found matching alias [MPATHa] in bindings file. "
-		       "Setting wwid to WWID0\n");
+	expect_condlog(3, FOUND_ALIAS_STR("MPATHa", "WWID0"));
 	rc = rlookup_binding(NULL, buf, "MPATHa");
 	assert_int_equal(rc, 0);
 	assert_string_equal(buf, "WWID0");
@@ -1045,7 +1042,7 @@ static void rl_nomatch_a(void **state)
 	buf[0] = '\0';
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	expect_condlog(3, "No matching alias [MPATHb] in bindings file.\n");
+	expect_condlog(3, NOMATCH_STR("MPATHb"));
 	rc = rlookup_binding(NULL, buf, "MPATHb");
 	assert_int_equal(rc, -1);
 	assert_string_equal(buf, "");
@@ -1060,7 +1057,7 @@ static void rl_malformed_a(void **state)
 	will_return(__wrap_fgets, "MPATHa     \n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "Ignoring malformed line 1 in bindings file\n");
-	expect_condlog(3, "No matching alias [MPATHa] in bindings file.\n");
+	expect_condlog(3, NOMATCH_STR("MPATHa"));
 	rc = rlookup_binding(NULL, buf, "MPATHa");
 	assert_int_equal(rc, -1);
 	assert_string_equal(buf, "");
@@ -1080,7 +1077,7 @@ static void rl_overlong_a(void **state)
 	will_return(__wrap_fgets, line);
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "Ignoring too large wwid at 1 in bindings file\n");
-	expect_condlog(3, "No matching alias [MPATHa] in bindings file.\n");
+	expect_condlog(3, NOMATCH_STR("MPATHa"));
 	rc = rlookup_binding(NULL, buf, "MPATHa");
 	assert_int_equal(rc, -1);
 	assert_string_equal(buf, "");
@@ -1095,8 +1092,7 @@ static void rl_match_b(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, "MPATHz WWID26\n");
 	will_return(__wrap_fgets, "MPATHb WWID2\n");
-	expect_condlog(3, "Found matching alias [MPATHb] in bindings file. "
-		       "Setting wwid to WWID2\n");
+	expect_condlog(3, FOUND_ALIAS_STR("MPATHb", "WWID2"));
 	rc = rlookup_binding(NULL, buf, "MPATHb");
 	assert_int_equal(rc, 0);
 	assert_string_equal(buf, "WWID2");
@@ -1125,7 +1121,7 @@ static void al_a(void **state)
 	expect_value(__wrap_write, count, strlen(ln));
 	expect_string(__wrap_write, buf, ln);
 	will_return(__wrap_write, strlen(ln));
-	expect_condlog(3, "Created new binding [MPATHa] for WWID [WWIDa]\n");
+	expect_condlog(3, NEW_STR("MPATHa", "WWIDa"));
 
 	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
 	assert_ptr_not_equal(alias, NULL);
@@ -1142,7 +1138,7 @@ static void al_zz(void **state)
 	expect_value(__wrap_write, count, strlen(ln));
 	expect_string(__wrap_write, buf, ln);
 	will_return(__wrap_write, strlen(ln));
-	expect_condlog(3, "Created new binding [MPATHzz] for WWID [WWIDzz]\n");
+	expect_condlog(3, NEW_STR("MPATHzz", "WWIDzz"));
 
 	alias = allocate_binding(0, "WWIDzz", 26*26 + 26, "MPATH");
 	assert_ptr_not_equal(alias, NULL);
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

