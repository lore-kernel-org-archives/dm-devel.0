Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA73EEB58C
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450373;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TIM6poLFIdYWvG/RRdv1jXPix8RyUDQYKD5JyFaMtyU=;
	b=hVvNJpPa0YUAL6yYSvDytrsLOWf7Xd6K7e1ZX7avz4gFNnwmu7k40OiYFKng6P1kYwtx18
	ulkj7wF3od4hF3v8S4mFZWyZGjOIIrO5+kc5B0XMc+KYIgGwfh6ROUZzhojmmYV97zk0hi
	VCi9cymFj06omhPGBZXbYvSWIfSm6QU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-4b9SrG59OduduYD6fkyojQ-1; Mon, 11 Sep 2023 12:39:31 -0400
X-MC-Unique: 4b9SrG59OduduYD6fkyojQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31BD3101FAA4;
	Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 18D9020235BE;
	Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB18D1946A44;
	Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 37B9619465A4
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A7FB21B2413; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 237FE21B2414
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0431C181A6E6
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-6jqm7lbzPY-HYAE33eVG3Q-1; Mon,
 11 Sep 2023 12:39:18 -0400
X-MC-Unique: 6jqm7lbzPY-HYAE33eVG3Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id DB3541F8BB;
 Mon, 11 Sep 2023 16:39:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A508E139CC;
 Mon, 11 Sep 2023 16:39:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id MHuSJrRC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:16 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:18 +0200
Message-ID: <20230911163846.27197-10-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 09/37] multipath-tools tests: convert
 mock_{failed, used}_alias to macros
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

This way we can further improve readability of the individual test
cases.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/alias.c | 92 +++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index 427b281..a32b43e 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -445,26 +445,26 @@ static void mock_self_alias(const char *alias, const char *wwid)
 #define REUSE_STR(alias_str, wwid_str) ("alias " alias_str " already bound to wwid " wwid_str ", cannot reuse\n")
 #define NOMORE_STR "no more available user_friendly_names\n"
 
-static void mock_failed_alias(const char *alias, char *msg)
-{
-	expect_string(__wrap_dm_map_present, str, alias);
-	will_return(__wrap_dm_map_present, 1);
-	expect_string(__wrap_dm_get_uuid, name, alias);
-	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
-	will_return(__wrap_dm_get_uuid, 1);
-	expect_condlog(3, msg);
-}
+#define mock_failed_alias(alias, wwid)					\
+	do {								\
+		expect_string(__wrap_dm_map_present, str, alias);	\
+		will_return(__wrap_dm_map_present, 1);			\
+		expect_string(__wrap_dm_get_uuid, name, alias);		\
+		expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);	\
+		will_return(__wrap_dm_get_uuid, 1);			\
+		expect_condlog(3, USED_STR(alias, wwid));		\
+	} while (0)
 
-static void mock_used_alias(const char *alias, char *msg)
-{
-	expect_string(__wrap_dm_map_present, str, alias);
-	will_return(__wrap_dm_map_present, 1);
-	expect_string(__wrap_dm_get_uuid, name, alias);
-	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
-	will_return(__wrap_dm_get_uuid, 0);
-	will_return(__wrap_dm_get_uuid, "WWID_USED");
-	expect_condlog(3, msg);
-}
+#define mock_used_alias(alias, wwid)					\
+	do {								\
+		expect_string(__wrap_dm_map_present, str, alias);	\
+		will_return(__wrap_dm_map_present, 1);			\
+		expect_string(__wrap_dm_get_uuid, name, alias);		\
+		expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);	\
+		will_return(__wrap_dm_get_uuid, 0);			\
+		will_return(__wrap_dm_get_uuid, "WWID_USED");		\
+		expect_condlog(3, USED_STR(alias, wwid));		\
+	} while(0)
 
 static void mock_bindings_file(const char *content, int match_line)
 {
@@ -516,7 +516,7 @@ static void lb_empty_failed(void **state)
 	char *alias;
 
 	will_return(__wrap_fgets, NULL);
-	mock_failed_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_failed_alias("MPATHa", "WWID0");
 	mock_unused_alias("MPATHb");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
@@ -531,7 +531,7 @@ static void lb_empty_1_used(void **state)
 	char *alias;
 
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_used_alias("MPATHa", "WWID0");
 	mock_unused_alias("MPATHb");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
@@ -546,7 +546,7 @@ static void lb_empty_1_used_self(void **state)
 	char *alias;
 
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_used_alias("MPATHa", "WWID0");
 	mock_self_alias("MPATHb", "WWID0");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
@@ -616,10 +616,10 @@ static void lb_nomatch_a_3_used_failed_self(void **state)
 
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID1"));
-	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID1"));
-	mock_used_alias("MPATHd", USED_STR("MPATHd", "WWID1"));
-	mock_failed_alias("MPATHe", USED_STR("MPATHe", "WWID1"));
+	mock_used_alias("MPATHb", "WWID1");
+	mock_used_alias("MPATHc", "WWID1");
+	mock_used_alias("MPATHd", "WWID1");
+	mock_failed_alias("MPATHe", "WWID1");
 	mock_self_alias("MPATHf", "WWID1");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
 	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
@@ -689,7 +689,7 @@ static void lb_nomatch_a_d_1_used(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, "MPATHd WWID1\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
+	mock_used_alias("MPATHb", "WWID2");
 	mock_unused_alias("MPATHc");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
@@ -705,8 +705,8 @@ static void lb_nomatch_a_d_2_used(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, "MPATHd WWID1\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
-	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID2"));
+	mock_used_alias("MPATHb", "WWID2");
+	mock_used_alias("MPATHc", "WWID2");
 	mock_unused_alias("MPATHe");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
@@ -722,9 +722,9 @@ static void lb_nomatch_a_d_3_used(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, "MPATHd WWID1\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
-	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID2"));
-	mock_used_alias("MPATHe", USED_STR("MPATHe", "WWID2"));
+	mock_used_alias("MPATHb", "WWID2");
+	mock_used_alias("MPATHc", "WWID2");
+	mock_used_alias("MPATHe", "WWID2");
 	mock_unused_alias("MPATHf");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
@@ -771,7 +771,7 @@ static void lb_nomatch_d_a_1_used(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, "MPATHd WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
+	mock_used_alias("MPATHb", "WWID2");
 	mock_unused_alias("MPATHe");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
@@ -851,9 +851,9 @@ static void lb_nomatch_b_a_3_used(void **state)
 	will_return(__wrap_fgets, "MPATHz WWID26\n");
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHaa", USED_STR("MPATHaa", "WWID2"));
-	mock_used_alias("MPATHab", USED_STR("MPATHab", "WWID2"));
-	mock_used_alias("MPATHac", USED_STR("MPATHac", "WWID2"));
+	mock_used_alias("MPATHaa", "WWID2");
+	mock_used_alias("MPATHab", "WWID2");
+	mock_used_alias("MPATHac", "WWID2");
 	mock_unused_alias("MPATHad");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
@@ -895,7 +895,7 @@ static void lb_nomatch_int_max_used(void **state)
 	will_return(__wrap_fgets, "MPATHb WWID1\n");
 	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
+	mock_used_alias("MPATHa", "WWID2");
 	expect_condlog(0, NOMORE_STR);
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, -1);
@@ -926,7 +926,7 @@ static void lb_nomatch_int_max_m1_used(void **state)
 	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATH" MPATH_ID_INT_MAX, USED_STR("MPATH" MPATH_ID_INT_MAX, "WWID2"));
+	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWID2");
 	expect_condlog(0, NOMORE_STR);
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, -1);
@@ -941,7 +941,7 @@ static void lb_nomatch_int_max_m1_1_used(void **state)
 	will_return(__wrap_fgets, "MPATHb WWID1\n");
 	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
+	mock_used_alias("MPATHa", "WWID2");
 	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
 	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
@@ -957,8 +957,8 @@ static void lb_nomatch_int_max_m1_2_used(void **state)
 	will_return(__wrap_fgets, "MPATHb WWID1\n");
 	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
 	will_return(__wrap_fgets, NULL);
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
-	mock_used_alias("MPATH" MPATH_ID_INT_MAX, USED_STR("MPATH" MPATH_ID_INT_MAX, "WWID2"));
+	mock_used_alias("MPATHa", "WWID2");
+	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWID2");
 	expect_condlog(0, NOMORE_STR);
 	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, -1);
@@ -1291,7 +1291,7 @@ static void gufa_match_a_used(void **state) {
 
 	will_return(__wrap_fgets, BINDING_STR("MPATHa", "WWID0"));
 	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_used_alias("MPATHa", "WWID0");
 
 	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
 	assert_ptr_equal(alias, NULL);
@@ -1355,7 +1355,7 @@ static void gufa_nomatch_c_b_used(void **state) {
 	mock_bindings_file("MPATHc WWID2\n"
 			   "MPATHb WWID1",
 			   -1);
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID4"));
+	mock_used_alias("MPATHa", "WWID4");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID4"));
 	mock_unused_alias("MPATHd");
 
@@ -1450,7 +1450,7 @@ static void gufa_old_match_other_used(void **state) {
 	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
 
 	mock_bindings_file(bindings, -1);
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_used_alias("MPATHa", "WWID0");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	mock_unused_alias("MPATHb");
 
@@ -1493,7 +1493,7 @@ static void gufa_old_match_other_wwidmatch_used(void **state) {
 
 	mock_bindings_file(bindings, 1);
 	expect_condlog(3, FOUND_STR("MPATHc", "WWID2"));
-	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID2"));
+	mock_used_alias("MPATHc", "WWID2");
 
 	alias = get_user_friendly_alias("WWID2", "x", "MPATHz", "MPATH", false);
 	assert_ptr_equal(alias, NULL);
@@ -1528,7 +1528,7 @@ static void gufa_old_nomatch_wwidmatch_used(void **state) {
 
 	mock_bindings_file(bindings, 0);
 	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
-	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_used_alias("MPATHa", "WWID0");
 
 	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
 	assert_ptr_equal(alias, NULL);
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

