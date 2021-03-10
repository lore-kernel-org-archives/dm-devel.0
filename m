Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE83C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 21:15:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 88DEB64FCA
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 21:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88DEB64FCA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615410952;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uAzG+At81bPBt0l8TrJ1mowJ7MgBOcrnL/OhDqbxj1g=;
	b=YkIAzewL4Hf8xJQoW35+cd0iEnXadNsvJaOJ9MBA/UPbvEgynFR+9lFivlN9gmBPvis5hV
	ohT/L2iD4EyfLyrr2I4+isAxDDsfd8wzcgwIaeSSBCpq6/AqmXRAzJCtk1JNGcKds6W1Vf
	LG02Qs6804D7mhxg69m0t51QurcrQnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-cgqj-bXqNeiXl5fcIVbPjQ-1; Wed, 10 Mar 2021 16:15:49 -0500
X-MC-Unique: cgqj-bXqNeiXl5fcIVbPjQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AF1B100CEC0;
	Wed, 10 Mar 2021 21:15:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C56E694CA;
	Wed, 10 Mar 2021 21:15:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 102391C99;
	Wed, 10 Mar 2021 21:15:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12ALFUev016655 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Mar 2021 16:15:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6DC835F708; Wed, 10 Mar 2021 21:15:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E14925C1A1;
	Wed, 10 Mar 2021 21:15:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12ALFHik012601; 
	Wed, 10 Mar 2021 15:15:17 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12ALFHh3012600;
	Wed, 10 Mar 2021 15:15:17 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 10 Mar 2021 15:15:15 -0600
Message-Id: <1615410915-12555-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1615410915-12555-1-git-send-email-bmarzins@redhat.com>
References: <1615410915-12555-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 2/2] tests: add tests for checking if alias is in
	use
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/alias.c | 409 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 405 insertions(+), 4 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index 344aba73..ebe1209e 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -62,6 +62,25 @@ int __wrap_ftruncate(int fd, off_t length)
 	return __set_errno(mock_type(int));
 }
 
+int __wrap_dm_map_present(const char * str)
+{
+	check_expected(str);
+	return mock_type(int);
+}
+
+int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
+{
+	int ret;
+
+	check_expected(name);
+	check_expected(uuid_len);
+	assert_non_null(uuid);
+	ret = mock_type(int);
+	if (ret == 0)
+		strcpy(uuid, mock_ptr_type(char *));
+	return ret;
+}
+
 static void fd_mpatha(void **state)
 {
 	char buf[32];
@@ -350,6 +369,45 @@ static int test_scan_devname(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+static void mock_unused_alias(const char *alias)
+{
+	expect_string(__wrap_dm_map_present, str, alias);
+	will_return(__wrap_dm_map_present, 0);
+}
+
+static void mock_self_alias(const char *alias, const char *wwid)
+{
+	expect_string(__wrap_dm_map_present, str, alias);
+	will_return(__wrap_dm_map_present, 1);
+	expect_string(__wrap_dm_get_uuid, name, alias);
+	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
+	will_return(__wrap_dm_get_uuid, 0);
+	will_return(__wrap_dm_get_uuid, wwid);
+}
+
+#define USED_STR(alias_str, wwid_str) wwid_str ": alias '" alias_str "' already taken, but not in bindings file. reselecting alias\n"
+
+static void mock_failed_alias(const char *alias, char *msg)
+{
+	expect_string(__wrap_dm_map_present, str, alias);
+	will_return(__wrap_dm_map_present, 1);
+	expect_string(__wrap_dm_get_uuid, name, alias);
+	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
+	will_return(__wrap_dm_get_uuid, 1);
+	expect_condlog(3, msg);
+}
+
+static void mock_used_alias(const char *alias, char *msg)
+{
+	expect_string(__wrap_dm_map_present, str, alias);
+	will_return(__wrap_dm_map_present, 1);
+	expect_string(__wrap_dm_get_uuid, name, alias);
+	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
+	will_return(__wrap_dm_get_uuid, 0);
+	will_return(__wrap_dm_get_uuid, "WWID_USED");
+	expect_condlog(3, msg);
+}
+
 static void lb_empty(void **state)
 {
 	int rc;
@@ -362,6 +420,65 @@ static void lb_empty(void **state)
 	assert_ptr_equal(alias, NULL);
 }
 
+static void lb_empty_unused(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, NULL);
+	mock_unused_alias("MPATHa");
+	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
+	assert_int_equal(rc, 1);
+	assert_ptr_equal(alias, NULL);
+	free(alias);
+}
+
+static void lb_empty_failed(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, NULL);
+	mock_failed_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_unused_alias("MPATHb");
+	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
+	assert_int_equal(rc, 2);
+	assert_ptr_equal(alias, NULL);
+	free(alias);
+}
+
+static void lb_empty_1_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_unused_alias("MPATHb");
+	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
+	assert_int_equal(rc, 2);
+	assert_ptr_equal(alias, NULL);
+	free(alias);
+}
+
+static void lb_empty_1_used_self(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
+	mock_self_alias("MPATHb", "WWID0");
+	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
+	assert_int_equal(rc, 2);
+	assert_ptr_equal(alias, NULL);
+	free(alias);
+}
+
 static void lb_match_a(void **state)
 {
 	int rc;
@@ -390,7 +507,52 @@ static void lb_nomatch_a(void **state)
 	assert_ptr_equal(alias, NULL);
 }
 
-static void lb_match_c(void **state)
+static void lb_nomatch_a_bad_check(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, NULL);
+	expect_condlog(0, "no more available user_friendly_names\n");
+	rc = lookup_binding(NULL, "WWID1", &alias, NULL, 1);
+	assert_int_equal(rc, -1);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_a_unused(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, NULL);
+	mock_unused_alias("MPATHb");
+	expect_condlog(3, "No matching wwid [WWID1] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
+	assert_int_equal(rc, 2);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_a_3_used_failed_self(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID1"));
+	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID1"));
+	mock_used_alias("MPATHd", USED_STR("MPATHd", "WWID1"));
+	mock_failed_alias("MPATHe", USED_STR("MPATHe", "WWID1"));
+	mock_self_alias("MPATHf", "WWID1");
+	expect_condlog(3, "No matching wwid [WWID1] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
+	assert_int_equal(rc, 6);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void do_lb_match_c(void **state, int check_if_taken)
 {
 	int rc;
 	char *alias;
@@ -399,13 +561,23 @@ static void lb_match_c(void **state)
 	will_return(__wrap_fgets, "MPATHc WWID1\n");
 	expect_condlog(3, "Found matching wwid [WWID1] in bindings file."
 		       " Setting alias to MPATHc\n");
-	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 0);
+	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", check_if_taken);
 	assert_int_equal(rc, 0);
 	assert_ptr_not_equal(alias, NULL);
 	assert_string_equal(alias, "MPATHc");
 	free(alias);
 }
 
+static void lb_match_c(void **state)
+{
+	do_lb_match_c(state, 0);
+}
+
+static void lb_match_c_check(void **state)
+{
+	do_lb_match_c(state, 1);
+}
+
 static void lb_nomatch_a_c(void **state)
 {
 	int rc;
@@ -420,6 +592,72 @@ static void lb_nomatch_a_c(void **state)
 	assert_ptr_equal(alias, NULL);
 }
 
+static void lb_nomatch_a_d_unused(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, "MPATHd WWID1\n");
+	will_return(__wrap_fgets, NULL);
+	mock_unused_alias("MPATHb");
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, 2);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_a_d_1_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, "MPATHd WWID1\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
+	mock_unused_alias("MPATHc");
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, 3);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_a_d_2_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, "MPATHd WWID1\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
+	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID2"));
+	mock_unused_alias("MPATHe");
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, 5);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_a_d_3_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, "MPATHd WWID1\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
+	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID2"));
+	mock_used_alias("MPATHe", USED_STR("MPATHe", "WWID2"));
+	mock_unused_alias("MPATHf");
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, 6);
+	assert_ptr_equal(alias, NULL);
+}
+
 static void lb_nomatch_c_a(void **state)
 {
 	int rc;
@@ -434,6 +672,39 @@ static void lb_nomatch_c_a(void **state)
 	assert_ptr_equal(alias, NULL);
 }
 
+static void lb_nomatch_d_a_unused(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHc WWID1\n");
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, "MPATHd WWID0\n");
+	will_return(__wrap_fgets, NULL);
+	mock_unused_alias("MPATHb");
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, 2);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_d_a_1_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHc WWID1\n");
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, "MPATHd WWID0\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHb", USED_STR("MPATHb", "WWID2"));
+	mock_unused_alias("MPATHe");
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, 5);
+	assert_ptr_equal(alias, NULL);
+}
+
 static void lb_nomatch_a_b(void **state)
 {
 	int rc;
@@ -465,6 +736,23 @@ static void lb_nomatch_a_b_bad(void **state)
 	assert_ptr_equal(alias, NULL);
 }
 
+static void lb_nomatch_a_b_bad_self(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, "MPATHz WWID26\n");
+	will_return(__wrap_fgets, "MPATHb\n");
+	will_return(__wrap_fgets, NULL);
+	expect_condlog(3, "Ignoring malformed line 3 in bindings file\n");
+	mock_self_alias("MPATHc", "WWID2");
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, 3);
+	assert_ptr_equal(alias, NULL);
+}
+
 static void lb_nomatch_b_a(void **state)
 {
 	int rc;
@@ -480,8 +768,27 @@ static void lb_nomatch_b_a(void **state)
 	assert_ptr_equal(alias, NULL);
 }
 
+static void lb_nomatch_b_a_3_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHb WWID1\n");
+	will_return(__wrap_fgets, "MPATHz WWID26\n");
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHaa", USED_STR("MPATHaa", "WWID2"));
+	mock_used_alias("MPATHab", USED_STR("MPATHab", "WWID2"));
+	mock_used_alias("MPATHac", USED_STR("MPATHac", "WWID2"));
+	mock_unused_alias("MPATHad");
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, 30);
+	assert_ptr_equal(alias, NULL);
+}
+
 #ifdef MPATH_ID_INT_MAX
-static void lb_nomatch_int_max(void **state)
+static void do_lb_nomatch_int_max(void **state, int check_if_taken)
 {
 	int rc;
 	char *alias;
@@ -491,7 +798,32 @@ static void lb_nomatch_int_max(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(0, "no more available user_friendly_names\n");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", check_if_taken);
+	assert_int_equal(rc, -1);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_int_max(void **state)
+{
+	do_lb_nomatch_int_max(state, 0);
+}
+
+static void lb_nomatch_int_max_check(void **state)
+{
+	do_lb_nomatch_int_max(state, 1);
+}
+
+static void lb_nomatch_int_max_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHb WWID1\n");
+	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
+	expect_condlog(0, "no more available user_friendly_names\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
 	assert_int_equal(rc, -1);
 	assert_ptr_equal(alias, NULL);
 }
@@ -510,23 +842,92 @@ static void lb_nomatch_int_max_m1(void **state)
 	assert_int_equal(rc, INT_MAX);
 	assert_ptr_equal(alias, NULL);
 }
+
+static void lb_nomatch_int_max_m1_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHb WWID1\n");
+	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
+	will_return(__wrap_fgets, "MPATHa WWID0\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATH" MPATH_ID_INT_MAX, USED_STR("MPATH" MPATH_ID_INT_MAX, "WWID2"));
+	expect_condlog(0, "no more available user_friendly_names\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, -1);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_int_max_m1_1_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHb WWID1\n");
+	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
+	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
+	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, INT_MAX);
+	assert_ptr_equal(alias, NULL);
+}
+
+static void lb_nomatch_int_max_m1_2_used(void **state)
+{
+	int rc;
+	char *alias;
+
+	will_return(__wrap_fgets, "MPATHb WWID1\n");
+	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
+	will_return(__wrap_fgets, NULL);
+	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID2"));
+	mock_used_alias("MPATH" MPATH_ID_INT_MAX, USED_STR("MPATH" MPATH_ID_INT_MAX, "WWID2"));
+	expect_condlog(0, "no more available user_friendly_names\n");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
+	assert_int_equal(rc, -1);
+	assert_ptr_equal(alias, NULL);
+}
 #endif
 
 static int test_lookup_binding(void)
 {
 	const struct CMUnitTest tests[] = {
 		cmocka_unit_test(lb_empty),
+		cmocka_unit_test(lb_empty_unused),
+		cmocka_unit_test(lb_empty_failed),
+		cmocka_unit_test(lb_empty_1_used),
+		cmocka_unit_test(lb_empty_1_used_self),
 		cmocka_unit_test(lb_match_a),
 		cmocka_unit_test(lb_nomatch_a),
+		cmocka_unit_test(lb_nomatch_a_bad_check),
+		cmocka_unit_test(lb_nomatch_a_unused),
+		cmocka_unit_test(lb_nomatch_a_3_used_failed_self),
 		cmocka_unit_test(lb_match_c),
+		cmocka_unit_test(lb_match_c_check),
 		cmocka_unit_test(lb_nomatch_a_c),
+		cmocka_unit_test(lb_nomatch_a_d_unused),
+		cmocka_unit_test(lb_nomatch_a_d_1_used),
+		cmocka_unit_test(lb_nomatch_a_d_2_used),
+		cmocka_unit_test(lb_nomatch_a_d_3_used),
 		cmocka_unit_test(lb_nomatch_c_a),
+		cmocka_unit_test(lb_nomatch_d_a_unused),
+		cmocka_unit_test(lb_nomatch_d_a_1_used),
 		cmocka_unit_test(lb_nomatch_a_b),
 		cmocka_unit_test(lb_nomatch_a_b_bad),
+		cmocka_unit_test(lb_nomatch_a_b_bad_self),
 		cmocka_unit_test(lb_nomatch_b_a),
+		cmocka_unit_test(lb_nomatch_b_a_3_used),
 #ifdef MPATH_ID_INT_MAX
 		cmocka_unit_test(lb_nomatch_int_max),
+		cmocka_unit_test(lb_nomatch_int_max_check),
+		cmocka_unit_test(lb_nomatch_int_max_used),
 		cmocka_unit_test(lb_nomatch_int_max_m1),
+		cmocka_unit_test(lb_nomatch_int_max_m1_used),
+		cmocka_unit_test(lb_nomatch_int_max_m1_1_used),
+		cmocka_unit_test(lb_nomatch_int_max_m1_2_used),
 #endif
 	};
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

