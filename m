Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 173EDEEB580
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/ikEvEupXbD7p21e7Oli0g7sztZyYF3Yw71vogcRsXI=;
	b=dpL4WnKjtlorh2CZI/zz778kJwQJd93iqNCwndFaLl7pE79kNdEddBbDrKAu6wwV41H7LO
	u6ISFzZg2344CAzy404Xx6jHITOQFQ+0VzNVKogNrC75t12V9moK2nRizRpbZE8LhwEM99
	uafzJGheInk61hTPoFiXYyxxSMMW0k4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-S1YYLiV7NkufYCz-OeQ9BA-1; Mon, 11 Sep 2023 12:39:49 -0400
X-MC-Unique: S1YYLiV7NkufYCz-OeQ9BA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE128945E66;
	Mon, 11 Sep 2023 16:39:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AABFF2024CD6;
	Mon, 11 Sep 2023 16:39:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8BCE919465A2;
	Mon, 11 Sep 2023 16:39:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFBE91946A47
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1B9521CAC7A; Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CAEBA21CAC76
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD9C6101FAB0
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-304-4G_b7KPfNN2e6rTtuCVQOQ-1; Mon,
 11 Sep 2023 12:39:22 -0400
X-MC-Unique: 4G_b7KPfNN2e6rTtuCVQOQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 181941F8A6;
 Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D7869139CC;
 Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 8IL/MrhC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:20 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:34 +0200
Message-ID: <20230911163846.27197-26-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 25/37] multipath-tools tests: adapt alias
 tests for total ordering
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The "unsorted" test fail now, and are removed. The algorithm is now
better at finding "gaps".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/alias.c | 88 ++++++++-------------------------------------------
 1 file changed, 14 insertions(+), 74 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index 8ed95d7..dff5f93 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -439,27 +439,7 @@ static void mock_self_alias(const char *alias, const char *wwid)
 		expect_condlog(3, USED_STR(alias, wwid));		\
 	} while(0)
 
-static int add_binding_unsorted(Bindings *bindings,
-				const char *alias, const char *wwid)
-{
-	struct binding *bdg = calloc(1, sizeof(*bdg));
-
-	if (!bdg)
-		return -1;
-	bdg->wwid = strdup(wwid);
-	bdg->alias = strdup(alias);
-	if (!bdg->wwid || !bdg->alias || !vector_alloc_slot(bindings)) {
-		free(bdg->alias);
-		free(bdg->wwid);
-		free(bdg);
-		return BINDING_ERROR;
-	}
-	vector_set_slot(bindings, bdg);
-	return BINDING_ADDED;
-}
-
-static void __mock_bindings_file(const char *content,
-				 int (*add)(Bindings *, const char *, const char *))
+static void __mock_bindings_file(const char *content)
 {
 	char *cnt __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *token, *savep = NULL;
@@ -478,17 +458,13 @@ static void __mock_bindings_file(const char *content,
 		    == READ_BINDING_SKIP)
 			continue;
 
-		rc = add(&global_bindings, alias, wwid);
+		rc = add_binding(&global_bindings, alias, wwid);
 		assert_int_equal(rc, BINDING_ADDED);
 	}
 }
 
 static void mock_bindings_file(const char *content) {
-	return __mock_bindings_file(content, add_binding);
-}
-
-static void mock_bindings_file_unsorted(const char *content) {
-	return __mock_bindings_file(content, add_binding_unsorted);
+	return __mock_bindings_file(content);
 }
 
 static int teardown_bindings(void **state)
@@ -861,10 +837,6 @@ static void lb_nomatch_b_z_a(void **state)
 	int rc;
 	char *alias;
 
-	/*
-	 * add_bindings() sorts alphabetically. Therefore get_free_id()
-	 * finds MPATHc as a free entry.
-	 */
 	mock_bindings_file("MPATHb WWID1\n"
 			   "MPATHz WWID26\n"
 			   "MPATHa WWID0\n");
@@ -880,10 +852,6 @@ static void lb_nomatch_b_aa_a(void **state)
 	int rc;
 	char *alias;
 
-	/*
-	 * add_bindings() sorts alphabetically. ("a", "aa", b").
-	 * The get_free_id() algorithm finds the "hole" after "b".
-	 */
 	mock_bindings_file("MPATHb WWID1\n"
 			   "MPATHz WWID26\n"
 			   "MPATHa WWID0\n");
@@ -911,10 +879,6 @@ static void lb_nomatch_b_a_aa(void **state)
 	char *alias;
 	STRBUF_ON_STACK(buf);
 
-	/*
-	 * add_bindings() sorts alphabetically. ("a", "aa", "ab", "b", "c", ...)
-	 * lookup_binding finds MPATHac as next free entry.
-	 */
 	fill_bindings(&buf, 0, 26);
 	mock_bindings_file(get_strbuf_str(&buf));
 	expect_condlog(3, NOMATCH_WWID_STR("WWID28"));
@@ -930,10 +894,6 @@ static void lb_nomatch_b_a_aa_zz(void **state)
 	char *alias;
 	STRBUF_ON_STACK(buf);
 
-	/*
-	 * add_bindings() sorts alphabetically. ("a", "aa", "ab", "b", "c", ...)
-	 * lookup_binding finds MPATHab as next free entry.
-	 */
 	fill_bindings(&buf, 0, 26);
 	print_strbuf(&buf, "MPATHzz WWID676\n");
 	mock_bindings_file(get_strbuf_str(&buf));
@@ -944,25 +904,6 @@ static void lb_nomatch_b_a_aa_zz(void **state)
 	assert_ptr_equal(alias, NULL);
 }
 
-static void lb_nomatch_b_z_a_unsorted(void **state)
-{
-	int rc;
-	char *alias;
-
-	/*
-	 * With unsorted bindings (shouldn't happen normally), get_free_id()
-	 * plays safe and returns MPATHaa as first free entry.
-	 */
-	mock_bindings_file_unsorted("MPATHb WWID1\n"
-				    "MPATHz WWID26\n"
-				    "MPATHa WWID0\n");
-	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
-	mock_unused_alias("MPATHaa");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
-	assert_int_equal(rc, 27);
-	assert_ptr_equal(alias, NULL);
-}
-
 static void lb_nomatch_b_a(void **state)
 {
 	int rc;
@@ -1027,9 +968,9 @@ static void lb_nomatch_int_max_used(void **state)
 	mock_bindings_file(get_strbuf_str(&buf));
 	expect_condlog(3, NOMATCH_WWID_STR("WWIDNOMORE"));
 	mock_used_alias("MPATHa", "WWIDNOMORE");
-	expect_condlog(0, NOMORE_STR);
+	mock_unused_alias("MPATHab");
 	rc = lookup_binding(NULL, "WWIDNOMORE", &alias, "MPATH", 1);
-	assert_int_equal(rc, -1);
+	assert_int_equal(rc, 28);
 	assert_ptr_equal(alias, NULL);
 }
 
@@ -1077,9 +1018,9 @@ static void lb_nomatch_int_max_m1_1_used(void **state)
 	mock_bindings_file(get_strbuf_str(&buf));
 	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
 	mock_used_alias("MPATHa", "WWIDMAX");
-	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
+	mock_unused_alias("MPATHab");
 	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
-	assert_int_equal(rc, INT_MAX);
+	assert_int_equal(rc, 28);
 	assert_ptr_equal(alias, NULL);
 }
 
@@ -1095,10 +1036,10 @@ static void lb_nomatch_int_max_m1_2_used(void **state)
 
 	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
 	mock_used_alias("MPATHa", "WWIDMAX");
-	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWIDMAX");
-	expect_condlog(0, NOMORE_STR);
+	mock_used_alias("MPATHab", "WWIDMAX");
+	mock_unused_alias("MPATHac");
 	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
-	assert_int_equal(rc, -1);
+	assert_int_equal(rc, 29);
 	assert_ptr_equal(alias, NULL);
 }
 #endif
@@ -1133,7 +1074,6 @@ static int test_lookup_binding(void)
 		cmocka_unit_test_teardown(lb_nomatch_b_aa_a, teardown_bindings),
 		cmocka_unit_test_teardown(lb_nomatch_b_a_aa, teardown_bindings),
 		cmocka_unit_test_teardown(lb_nomatch_b_a_aa_zz, teardown_bindings),
-		cmocka_unit_test_teardown(lb_nomatch_b_z_a_unsorted, teardown_bindings),
 		cmocka_unit_test_teardown(lb_nomatch_b_a, teardown_bindings),
 		cmocka_unit_test_teardown(lb_nomatch_b_a_3_used, teardown_bindings),
 #ifdef MPATH_ID_INT_MAX
@@ -1593,14 +1533,14 @@ static void gufa_nomatch_b_f_a(void **state) {
 				 "MPATHf WWID6\n"
 				 "MPATHa WWID0\n");
 
-	mock_bindings_file_unsorted(bindings);
+	mock_bindings_file(bindings);
 	expect_condlog(3, NOMATCH_WWID_STR("WWID7"));
-	mock_unused_alias("MPATHg");
+	mock_unused_alias("MPATHc");
 
-	mock_allocate_binding_len("MPATHg", "WWID7", sizeof(bindings) - 1);
+	mock_allocate_binding_len("MPATHc", "WWID7", sizeof(bindings) - 1);
 
 	alias = get_user_friendly_alias("WWID7", "x", "", "MPATH", false);
-	assert_string_equal(alias, "MPATHg");
+	assert_string_equal(alias, "MPATHc");
 	free(alias);
 }
 
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

