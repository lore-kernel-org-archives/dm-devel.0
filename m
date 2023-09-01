Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAA4CA0FF1
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591420;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PYvA9zrj7IT7SetLVrX8l1FPO9/hu/I4w1vOmnKu9K4=;
	b=SPU9pJBIvADqyW3U3cZ+igoIFzirudg97nvntoqYYNp4es1yyDlwsSm/gAnmMQ7eZWcqy7
	UlJ3McSidHqnQOaC0WbztzKYFyXONYuDJlo7nupixxKU9Vg4t+WmfakrLhALQtIqN5xy9y
	N2L60AqVjEOK0CfYJ7aQWpRrQ8iM2yQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-0-eDhyaqMfKK1sUcPVFdZQ-1; Fri, 01 Sep 2023 14:03:36 -0400
X-MC-Unique: 0-eDhyaqMfKK1sUcPVFdZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11C7B1051066;
	Fri,  1 Sep 2023 18:03:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F12571460FE7;
	Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CECC119472AB;
	Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C3B6219472AC
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A3B1520C3B2A; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C5FA207A813
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81B653C0EABE
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-fFVdHvZwMAS2kzgJJ5g77A-1; Fri,
 01 Sep 2023 14:03:24 -0400
X-MC-Unique: fFVdHvZwMAS2kzgJJ5g77A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id DC1741F45E;
 Fri,  1 Sep 2023 18:03:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9DFE413582;
 Fri,  1 Sep 2023 18:03:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id UD+1JGon8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:22 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:34 +0200
Message-ID: <20230901180235.23980-22-mwilck@suse.com>
In-Reply-To: <20230901180235.23980-1-mwilck@suse.com>
References: <20230901180235.23980-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 21/21] libmultipath: adapt to new semantics of
 dm_get_uuid()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

dm_get_uuid() will return 1 for non-existing maps. Thus we don't need
to call dm_map_present() any more in alias_already_taken(). This changes
our semantics: previously we'd avoid using an alias for which dm_get_uuid()
had failed. Now we treat failure in dm_get_uuid() as indication that the
map doesn't exist. This is not dangerous because dm_task_get_uuid() cannot
fail, and thus the modified dm_get_uuid() will fail if and only if
dm_map_present() would return false.

This makes the "failed alias" test mostly obsolete, as "failed" is now
treated as "unused".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 23 ++++++++++++-----------
 tests/alias.c        | 30 ++++++------------------------
 2 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 6003df0..0f5af17 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -295,18 +295,19 @@ scan_devname(const char *alias, const char *prefix)
 static bool alias_already_taken(const char *alias, const char *map_wwid)
 {
 
-	if (dm_map_present(alias)) {
-		char wwid[WWID_SIZE];
+	char wwid[WWID_SIZE];
 
-		/* If both the name and the wwid match, then it's fine.*/
-		if (dm_get_uuid(alias, wwid, sizeof(wwid)) == 0 &&
-		    strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
-			return false;
-		condlog(3, "%s: alias '%s' already taken, reselecting alias",
-			map_wwid, alias);
-		return true;
-	}
-	return false;
+	/* If the map doesn't exist, it's fine */
+	if (dm_get_uuid(alias, wwid, sizeof(wwid)) != 0)
+		return false;
+
+	/* If both the name and the wwid match, it's fine.*/
+	if (strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
+		return false;
+
+	condlog(3, "%s: alias '%s' already taken, reselecting alias",
+		map_wwid, alias);
+	return true;
 }
 
 static bool id_already_taken(int id, const char *prefix, const char *map_wwid)
diff --git a/tests/alias.c b/tests/alias.c
index 4ac6425..4f54031 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -73,12 +73,6 @@ int __wrap_mkstemp(char *template)
 	return 10;
 }
 
-int __wrap_dm_map_present(const char * str)
-{
-	check_expected(str);
-	return mock_type(int);
-}
-
 int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
 {
 	int ret;
@@ -398,14 +392,13 @@ static int test_scan_devname(void)
 
 static void mock_unused_alias(const char *alias)
 {
-	expect_string(__wrap_dm_map_present, str, alias);
-	will_return(__wrap_dm_map_present, 0);
+	expect_string(__wrap_dm_get_uuid, name, alias);
+	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
+	will_return(__wrap_dm_get_uuid, 1);
 }
 
 static void mock_self_alias(const char *alias, const char *wwid)
 {
-	expect_string(__wrap_dm_map_present, str, alias);
-	will_return(__wrap_dm_map_present, 1);
 	expect_string(__wrap_dm_get_uuid, name, alias);
 	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
 	will_return(__wrap_dm_get_uuid, 0);
@@ -432,18 +425,13 @@ static void mock_self_alias(const char *alias, const char *wwid)
 
 #define mock_failed_alias(alias, wwid)					\
 	do {								\
-		expect_string(__wrap_dm_map_present, str, alias);	\
-		will_return(__wrap_dm_map_present, 1);			\
 		expect_string(__wrap_dm_get_uuid, name, alias);		\
 		expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);	\
 		will_return(__wrap_dm_get_uuid, 1);			\
-		expect_condlog(3, USED_STR(alias, wwid));		\
 	} while (0)
 
 #define mock_used_alias(alias, wwid)					\
 	do {								\
-		expect_string(__wrap_dm_map_present, str, alias);	\
-		will_return(__wrap_dm_map_present, 1);			\
 		expect_string(__wrap_dm_get_uuid, name, alias);		\
 		expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);	\
 		will_return(__wrap_dm_get_uuid, 0);			\
@@ -566,9 +554,8 @@ static void lb_empty_failed(void **state)
 	mock_bindings_file("");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	mock_failed_alias("MPATHa", "WWID0");
-	mock_unused_alias("MPATHb");
 	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
-	assert_int_equal(rc, 2);
+	assert_int_equal(rc, 1);
 	assert_ptr_equal(alias, NULL);
 	free(alias);
 }
@@ -666,9 +653,8 @@ static void lb_nomatch_a_3_used_failed_self(void **state)
 	mock_used_alias("MPATHc", "WWID1");
 	mock_used_alias("MPATHd", "WWID1");
 	mock_failed_alias("MPATHe", "WWID1");
-	mock_self_alias("MPATHf", "WWID1");
 	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
-	assert_int_equal(rc, 6);
+	assert_int_equal(rc, 5);
 	assert_ptr_equal(alias, NULL);
 }
 
@@ -949,11 +935,7 @@ static void lb_nomatch_b_a_aa_zz(void **state)
 	 * lookup_binding finds MPATHaaa as next free entry, because MPATHaa is
 	 * found before MPATHb, and MPATHzz was in the bindings, too.
 	 */
-	for (i = 0; i <= 26; i++) {
-		print_strbuf(&buf,  "MPATH");
-		format_devname(&buf, i + 1);
-		print_strbuf(&buf,  " WWID%d\n", i);
-	}
+	fill_bindings(&buf, 0, 26);
 	print_strbuf(&buf, "MPATHzz WWID676\n");
 	mock_bindings_file(get_strbuf_str(&buf));
 	expect_condlog(3, NOMATCH_WWID_STR("WWID703"));
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

