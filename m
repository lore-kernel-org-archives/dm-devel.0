Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6EBEEB594
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jOCEPfTe5Zk4eWC766lSbAiOwPjfVfM0j6JQTZ2eFPk=;
	b=f2RjEQ45hvfMIC9o4mlYM8HpreQAHOfXVu8qJ3LO5tF4axSny92T1jsd+bIpzewfRhvqVr
	1N3G6ZKXz8eBfslZp4xQ9c+dH/AfiyNNolz1ZnAOAssZHRe1hnTYVKrL8HuM7z5pJYYouo
	vfh9yJk+qwF9B47u++C3IeWIkfQUi00=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-YV0jrDcrMzOJf5Eyrqw8TQ-1; Mon, 11 Sep 2023 12:39:45 -0400
X-MC-Unique: YV0jrDcrMzOJf5Eyrqw8TQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A250C181A707;
	Mon, 11 Sep 2023 16:39:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8C1E740C200A;
	Mon, 11 Sep 2023 16:39:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5595E19465B6;
	Mon, 11 Sep 2023 16:39:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1E021946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E33C740C2009; Mon, 11 Sep 2023 16:39:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DBA8740C200A
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:24 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE7D1381494E
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:24 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-rltqEK98N5OGy1OQhndMgw-1; Mon,
 11 Sep 2023 12:39:21 -0400
X-MC-Unique: rltqEK98N5OGy1OQhndMgw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 924CC1F8B3;
 Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 62596139CC;
 Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id EJ9iFrhC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:20 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:32 +0200
Message-ID: <20230911163846.27197-24-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 23/37] multipath-tools tests: fix alias test
 after sort order change
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/alias.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index d1cc487..8ed95d7 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -932,16 +932,15 @@ static void lb_nomatch_b_a_aa_zz(void **state)
 
 	/*
 	 * add_bindings() sorts alphabetically. ("a", "aa", "ab", "b", "c", ...)
-	 * lookup_binding finds MPATHaaa as next free entry, because MPATHaa is
-	 * found before MPATHb, and MPATHzz was in the bindings, too.
+	 * lookup_binding finds MPATHab as next free entry.
 	 */
 	fill_bindings(&buf, 0, 26);
 	print_strbuf(&buf, "MPATHzz WWID676\n");
 	mock_bindings_file(get_strbuf_str(&buf));
 	expect_condlog(3, NOMATCH_WWID_STR("WWID703"));
-	mock_unused_alias("MPATHaaa");
+	mock_unused_alias("MPATHab");
 	rc = lookup_binding(NULL, "WWID703", &alias, "MPATH", 1);
-	assert_int_equal(rc, 703);
+	assert_int_equal(rc, 28);
 	assert_ptr_equal(alias, NULL);
 }
 
@@ -998,13 +997,8 @@ static void lb_nomatch_b_a_3_used(void **state)
 
 #ifdef MPATH_ID_INT_MAX
 /*
- * The bindings will be sorted by alias, alphabetically, which is not
- * the same as the "numeric" sort order for user-friendly aliases.
- * get_free_id() selects the highest used ID + 1 if an unsorted entry
- * is encountered in the bindings table and it's id is equal to the
- * next "expected" id. This happens if all IDs from "a" to "aa" are
- * in the table. If the INT_MAX entry is in the table, too, it will
- * overflow.
+ * The bindings will be sorted by alias. Therefore we have no chance to
+ * simulate a "full" table.
  */
 static void lb_nomatch_int_max(void **state)
 {
@@ -1016,9 +1010,9 @@ static void lb_nomatch_int_max(void **state)
 	print_strbuf(&buf, "MPATH%s WWIDMAX\n", MPATH_ID_INT_MAX);
 	mock_bindings_file(get_strbuf_str(&buf));
 	expect_condlog(3, NOMATCH_WWID_STR("WWIDNOMORE"));
-	expect_condlog(0, NOMORE_STR);
+	mock_unused_alias("MPATHab");
 	rc = lookup_binding(NULL, "WWIDNOMORE", &alias, "MPATH", 1);
-	assert_int_equal(rc, -1);
+	assert_int_equal(rc, 28);
 	assert_ptr_equal(alias, NULL);
 }
 
@@ -1049,9 +1043,9 @@ static void lb_nomatch_int_max_m1(void **state)
 	print_strbuf(&buf, "MPATH%s WWIDMAXM1\n", MPATH_ID_INT_MAX_m1);
 	mock_bindings_file(get_strbuf_str(&buf));
 	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
-	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
+	mock_unused_alias("MPATHab");
 	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
-	assert_int_equal(rc, INT_MAX);
+	assert_int_equal(rc, 28);
 	assert_ptr_equal(alias, NULL);
 }
 
@@ -1065,10 +1059,10 @@ static void lb_nomatch_int_max_m1_used(void **state)
 	print_strbuf(&buf, "MPATH%s WWIDMAXM1\n", MPATH_ID_INT_MAX_m1);
 	mock_bindings_file(get_strbuf_str(&buf));
 	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
-	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWIDMAX");
-	expect_condlog(0, NOMORE_STR);
+	mock_used_alias("MPATHab", "WWIDMAX");
+	mock_unused_alias("MPATHac");
 	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
-	assert_int_equal(rc, -1);
+	assert_int_equal(rc, 29);
 	assert_ptr_equal(alias, NULL);
 }
 
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

