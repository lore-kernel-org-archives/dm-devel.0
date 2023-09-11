Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3902DEE7FF4
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6F4ZH4rHmHcIzfQFlDMJkwxNY/QIWTLU96N/Xjiwm6M=;
	b=R5B4aWlgCLDbIyKrU06GYLCK+7dVaOR0HSN4Qn6+O9U29yBu1o8Bpm19H6Wwc6rlSMNzmS
	//L8R/Jo+ALDGKrNWjs8hWCXPUhYfU8PJEBaTxmg9n7VMlk0ayEhGvvH7Jpw5GCoJHJ1DW
	0CQ3jcTlQ9xGtGJsc2da+c0wNGLfs94=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-FYhy5gWjNv668WVEEhAyDQ-1; Mon, 11 Sep 2023 12:39:35 -0400
X-MC-Unique: FYhy5gWjNv668WVEEhAyDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E92393374A;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2AD511054FC2;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B52D119465BC;
	Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 561AA19465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2941A2027019; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2039F2027045
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05753101FAA9
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-EHyR-5zNNOOp9-mUqwf6-g-1; Mon,
 11 Sep 2023 12:39:21 -0400
X-MC-Unique: EHyR-5zNNOOp9-mUqwf6-g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 1D4E21F8BB;
 Mon, 11 Sep 2023 16:39:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDE7F139CC;
 Mon, 11 Sep 2023 16:39:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id +BZsNLdC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:19 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:30 +0200
Message-ID: <20230911163846.27197-22-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v2 21/37] libmultipath: adapt to new semantics of
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 23 ++++++++++++-----------
 tests/alias.c        | 32 +++++++-------------------------
 2 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index d656374..58436ec 100644
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
index 50a21ec..d1cc487 100644
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
 
@@ -940,7 +926,7 @@ static void lb_nomatch_b_a_aa(void **state)
 
 static void lb_nomatch_b_a_aa_zz(void **state)
 {
-	int rc, i;
+	int rc;
 	char *alias;
 	STRBUF_ON_STACK(buf);
 
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
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

