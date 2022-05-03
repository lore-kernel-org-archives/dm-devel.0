Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 292A6C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 22:10:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-18m0ShnxP0aH25JvD4IE-A-1; Tue, 03 May 2022 18:10:26 -0400
X-MC-Unique: 18m0ShnxP0aH25JvD4IE-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25F9A8E4847;
	Tue,  3 May 2022 22:10:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D931111E3FD;
	Tue,  3 May 2022 22:10:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA4FA1947040;
	Tue,  3 May 2022 22:10:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02B5819466DF
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 22:10:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC377554314; Tue,  3 May 2022 22:10:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C7BF755430C
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:10:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7529D8E4843
 for <dm-devel@redhat.com>; Tue,  3 May 2022 22:10:22 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-ERGyiqLPOwC4evxDIsHOsw-1; Tue, 03 May 2022 18:07:23 -0400
X-MC-Unique: ERGyiqLPOwC4evxDIsHOsw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id C352C210EC;
 Tue,  3 May 2022 22:07:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8ED1513ABE;
 Tue,  3 May 2022 22:07:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 2HxDIZSncWLfFgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 03 May 2022 22:07:16 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  4 May 2022 00:06:42 +0200
Message-Id: <20220503220646.16925-4-mwilck@suse.com>
In-Reply-To: <20220503220646.16925-1-mwilck@suse.com>
References: <20220503220646.16925-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 3/7] multipath-tools tests: hwtable: adapt after
 removal of getuid
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The "getuid_callout" runtime option has been removed and can thus
not be used in the hwtable test any more. The test was just using it
as a sample path property, not for any real WWID determination.
We need to use another path property replacement. I decided to
use "vpd_vendor". This is only initialized from scsi_ioctl_pathinfo().
Therefore test-lib.c must now support DI_SERIAL, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c  | 142 +++++++++++++++++++++++------------------------
 tests/test-lib.c |  89 ++++++++++++++++++++++-------
 tests/test-lib.h |   2 +-
 3 files changed, 140 insertions(+), 93 deletions(-)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 400e114..b8e73a6 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -403,7 +403,7 @@ static const char _vendor[] = "vendor";
 static const char _product[] = "product";
 static const char _prio[] = "prio";
 static const char _checker[] = "path_checker";
-static const char _getuid[] = "getuid_callout";
+static const char _vpd_vnd[] = "vpd_vendor";
 static const char _uid_attr[] = "uid_attribute";
 static const char _bl_product[] = "product_blacklist";
 static const char _minio[] = "rr_min_io_rq";
@@ -435,7 +435,7 @@ static const struct key_value prio_emc = { _prio, "emc" };
 static const struct key_value prio_hds = { _prio, "hds" };
 static const struct key_value prio_rdac = { _prio, "rdac" };
 static const struct key_value chk_hp = { _checker, "hp_sw" };
-static const struct key_value gui_foo = { _getuid, "/tmp/foo" };
+static const struct key_value vpd_hp3par = { _vpd_vnd, "hp3par" };
 static const struct key_value uid_baz = { _uid_attr, "BAZ_ATTR" };
 static const struct key_value bl_bar = { _bl_product, "bar" };
 static const struct key_value bl_baz = { _bl_product, "baz" };
@@ -755,31 +755,31 @@ static void test_regex_string_hwe(const struct hwt_state *hwt)
 	/* foo:baz matches kv1 */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* boo:baz matches kv1 */
 	pp = mock_path(vnd_boo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:ba. matches kv1 */
 	pp = mock_path(vnd__oo.value, prd_ba_.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .foo:(bar|baz|ba\.) doesn't match */
 	pp = mock_path(vnd__oo.value, prd_ba_s.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches kv2 and kv1 */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
@@ -787,7 +787,7 @@ static int setup_regex_string_hwe(void **state)
 {
 	struct hwt_state *hwt = CHECK_STATE(state);
 	const struct key_value kv1[] = { vnd_t_oo, prd_ba_s, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, vpd_hp3par };
 
 	WRITE_TWO_DEVICES(hwt, kv1, kv2);
 	SET_TEST_FUNC(hwt, test_regex_string_hwe);
@@ -812,39 +812,39 @@ static void test_regex_string_hwe_dir(const struct hwt_state *hwt)
 	/* foo:baz matches kv1 */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* boo:baz matches kv1 */
 	pp = mock_path(vnd_boo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:ba. matches kv1 */
 	pp = mock_path(vnd__oo.value, prd_ba_.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:(bar|baz|ba\.)$ doesn't match */
 	pp = mock_path(vnd__oo.value, prd_ba_s.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches kv2 */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	/* Later match takes prio */
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_regex_string_hwe_dir(void **state)
 {
 	const struct key_value kv1[] = { vnd_t_oo, prd_ba_s, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES_W_DIR(hwt, kv1, kv2);
@@ -867,29 +867,29 @@ static void test_regex_2_strings_hwe_dir(const struct hwt_state *hwt)
 	/* foo:baz matches kv1 */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* boo:baz doesn't match */
 	pp = mock_path(vnd_boo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches kv2 and kv1 */
 	pp = mock_path(vnd_foo.value, prd_bar.value);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(pp->uid_attribute, uid_baz.value);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* foo:barz matches kv3 and kv2 and kv1 */
-	pp = mock_path_flags(vnd_foo.value, prd_barz.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_barz.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_rdac.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
 	TEST_PROP(pp->uid_attribute, NULL);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
@@ -898,7 +898,7 @@ static int setup_regex_2_strings_hwe_dir(void **state)
 	const struct key_value kv1[] = { vnd_foo, prd_ba_, prio_emc, chk_hp };
 	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, uid_baz };
 	const struct key_value kv3[] = { vnd_foo, prd_barz,
-					 prio_rdac, gui_foo };
+					 prio_rdac, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	begin_config(hwt);
@@ -924,40 +924,40 @@ static void test_string_regex_hwe_dir(const struct hwt_state *hwt)
 	struct path *pp;
 
 	/* foo:bar matches kv2 and kv1 */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* foo:baz matches kv1 */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* boo:baz matches kv1 */
 	pp = mock_path(vnd_boo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:ba. matches kv1 */
 	pp = mock_path(vnd__oo.value, prd_ba_.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* .oo:(bar|baz|ba\.)$ doesn't match */
 	pp = mock_path(vnd__oo.value, prd_ba_s.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 }
 
 static int setup_string_regex_hwe_dir(void **state)
 {
 	const struct key_value kv1[] = { vnd_t_oo, prd_ba_s, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES_W_DIR(hwt, kv2, kv1);
@@ -980,20 +980,20 @@ static void test_2_ident_strings_hwe(const struct hwt_state *hwt)
 	/* foo:baz doesn't match */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_strings_hwe(void **state)
 {
 	const struct key_value kv1[] = { vnd_foo, prd_bar, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES(hwt, kv1, kv2);
@@ -1015,20 +1015,20 @@ static void test_2_ident_strings_both_dir(const struct hwt_state *hwt)
 	/* foo:baz doesn't match */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_strings_both_dir(void **state)
 {
 	const struct key_value kv1[] = { vnd_foo, prd_bar, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	begin_config(hwt);
@@ -1055,13 +1055,13 @@ static void test_2_ident_strings_both_dir_w_prev(const struct hwt_state *hwt)
 	/* foo:baz doesn't match */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
@@ -1071,7 +1071,7 @@ static int setup_2_ident_strings_both_dir_w_prev(void **state)
 
 	const struct key_value kv0[] = { vnd_foo, prd_bar };
 	const struct key_value kv1[] = { vnd_foo, prd_bar, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, vpd_hp3par };
 
 	begin_config(hwt);
 	begin_section_all(hwt, "devices");
@@ -1100,20 +1100,20 @@ static void test_2_ident_strings_hwe_dir(const struct hwt_state *hwt)
 	/* foo:baz doesn't match */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_strings_hwe_dir(void **state)
 {
 	const struct key_value kv1[] = { vnd_foo, prd_bar, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES_W_DIR(hwt, kv1, kv2);
@@ -1134,13 +1134,13 @@ static void test_3_ident_strings_hwe_dir(const struct hwt_state *hwt)
 	/* foo:baz doesn't match */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
@@ -1148,7 +1148,7 @@ static int setup_3_ident_strings_hwe_dir(void **state)
 {
 	const struct key_value kv0[] = { vnd_foo, prd_bar };
 	const struct key_value kv1[] = { vnd_foo, prd_bar, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	begin_config(hwt);
@@ -1178,20 +1178,20 @@ static void test_2_ident_self_matching_re_hwe_dir(const struct hwt_state *hwt)
 	/* foo:baz doesn't match */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_self_matching_re_hwe_dir(void **state)
 {
 	const struct key_value kv1[] = { vnd__oo, prd_bar, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd__oo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd__oo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES_W_DIR(hwt, kv1, kv2);
@@ -1213,20 +1213,20 @@ static void test_2_ident_self_matching_re_hwe(const struct hwt_state *hwt)
 	/* foo:baz doesn't match */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_self_matching_re_hwe(void **state)
 {
 	const struct key_value kv1[] = { vnd__oo, prd_bar, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd__oo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd__oo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES(hwt, kv1, kv2);
@@ -1250,20 +1250,20 @@ test_2_ident_not_self_matching_re_hwe_dir(const struct hwt_state *hwt)
 	/* foo:baz doesn't match */
 	pp = mock_path(vnd_foo.value, prd_baz.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
 	/* foo:bar matches both */
-	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_bar.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
 static int setup_2_ident_not_self_matching_re_hwe_dir(void **state)
 {
 	const struct key_value kv1[] = { vnd_t_oo, prd_bar, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_t_oo, prd_bar, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_t_oo, prd_bar, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES_W_DIR(hwt, kv1, kv2);
@@ -1287,26 +1287,26 @@ static void test_2_matching_res_hwe_dir(const struct hwt_state *hwt)
 	/* foo:bar matches k1 only */
 	pp = mock_path(vnd_foo.value, prd_bar.value);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* foo:bay matches k1 and k2 */
-	pp = mock_path_flags(vnd_foo.value, "bay", USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, "bay", USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 
 	/* foo:baz matches k2 only. */
-	pp = mock_path_flags(vnd_foo.value, prd_baz.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_baz.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 }
 
 static int setup_2_matching_res_hwe_dir(void **state)
 {
 	const struct key_value kv1[] = { vnd_foo, prd_barx, prio_emc, chk_hp };
-	const struct key_value kv2[] = { vnd_foo, prd_bazy, prio_hds, gui_foo };
+	const struct key_value kv2[] = { vnd_foo, prd_bazy, prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES_W_DIR(hwt, kv1, kv2);
@@ -1328,12 +1328,12 @@ static void test_2_nonmatching_res_hwe_dir(const struct hwt_state *hwt)
 	/* foo:bar doesn't match */
 	pp = mock_path(vnd_foo.value, prd_bar.value);
 	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
-	TEST_PROP(pp->getuid, NULL);
+	assert_int_equal(pp->vpd_vendor_id, 0);
 	TEST_PROP(checker_name(&pp->checker), DEFAULT_CHECKER);
 
-	pp = mock_path_flags(vnd_foo.value, prd_baz.value, USE_GETUID);
+	pp = mock_path_flags(vnd_foo.value, prd_baz.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_hds.value);
-	TEST_PROP(pp->getuid, gui_foo.value);
+	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
@@ -1341,7 +1341,7 @@ static int setup_2_nonmatching_res_hwe_dir(void **state)
 {
 	const struct key_value kv1[] = { vnd_foo, prd_bazy, prio_emc, chk_hp };
 	const struct key_value kv2[] = { vnd_foo, prd_bazy1,
-					 prio_hds, gui_foo };
+					 prio_hds, vpd_hp3par };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	WRITE_TWO_DEVICES_W_DIR(hwt, kv1, kv2);
diff --git a/tests/test-lib.c b/tests/test-lib.c
index f5542ed..68e0dd8 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -4,6 +4,8 @@
 #include <cmocka.h>
 #include <libudev.h>
 #include <sys/sysmacros.h>
+#include <linux/hdreg.h>
+#include <scsi/sg.h>
 #include "debug.h"
 #include "util.h"
 #include "vector.h"
@@ -12,9 +14,10 @@
 #include "config.h"
 #include "discovery.h"
 #include "propsel.h"
+#include "unaligned.h"
 #include "test-lib.h"
 
-const int default_mask = (DI_SYSFS|DI_BLACKLIST|DI_WWID|DI_CHECKER|DI_PRIO);
+const int default_mask = (DI_SYSFS|DI_BLACKLIST|DI_WWID|DI_CHECKER|DI_PRIO|DI_SERIAL);
 const char default_devnode[] = "sdxTEST";
 const char default_wwid[] = "TEST-WWID";
 /* default_wwid should be a substring of default_wwid_1! */
@@ -47,15 +50,6 @@ int __wrap_open(const char *path, int flags, int mode)
 	return __real_open(path, flags, mode);
 }
 
-int __wrap_execute_program(char *path, char *value, int len)
-{
-	char *val = mock_ptr_type(char *);
-
-	condlog(5, "%s: %s", __func__, val);
-	strlcpy(value, val, len);
-	return 0;
-}
-
 int __wrap_libmp_get_version(int which, unsigned int version[3])
 {
 	unsigned int *vers = mock_ptr_type(unsigned int *);
@@ -181,6 +175,23 @@ ssize_t __wrap_sysfs_attr_get_value(struct udev_device *dev,
 	return strlen(value);
 }
 
+/* mock vpd_pg80 */
+ssize_t __wrap_sysfs_bin_attr_get_value(struct udev_device *dev,
+					const char *attr_name,
+					char *buf, size_t sz)
+{
+	static const char serial[] = "mptest_serial";
+
+	assert_string_equal(attr_name, "vpd_pg80");
+	assert_in_range(sz, sizeof(serial) + 3, INT_MAX);
+	memset(buf, 0, sizeof(serial) + 3);
+	buf[1] = 0x80;
+	put_unaligned_be16(sizeof(serial) - 1, &buf[2]);
+	memcpy(&buf[4], serial, sizeof(serial) - 1);
+
+	return sizeof(serial) + 3;
+}
+
 int __wrap_checker_check(struct checker *c, int st)
 {
 	condlog(5, "%s: %d", __func__, st);
@@ -195,6 +206,41 @@ int __wrap_prio_getprio(struct prio *p, struct path *pp, unsigned int tmo)
 	return pr;
 }
 
+int __real_ioctl(int fd, unsigned long request, void *param);
+
+int __wrap_ioctl(int fd, unsigned long request, void *param)
+{
+	condlog(5, "%s: %lu", __func__, request);
+
+	if (request == HDIO_GETGEO) {
+		static const struct hd_geometry geom = {
+			.heads = 4, .sectors = 31, .cylinders = 64, .start = 0
+		};
+		memcpy(param, &geom, sizeof(geom));
+		return 0;
+	} else if (request == SG_IO) {
+		/* mock hp3par special VPD */
+		struct sg_io_hdr *hdr = param;
+		static const char vpd_data[] = "VPD DATA";
+		unsigned char *buf = hdr->dxferp;
+		/* see vpd_vendor_pages in discovery.c */
+		const int HP3PAR_VPD = 0xc0;
+
+		if (hdr->interface_id == 'S' && hdr->cmdp[0] == 0x12
+		    && (hdr->cmdp[1] & 1) == 1 && hdr->cmdp[2] == HP3PAR_VPD) {
+			assert_in_range(hdr->dxfer_len,
+					sizeof(vpd_data + 3), INT_MAX);
+			memset(buf, 0, hdr->dxfer_len);
+			buf[1] = HP3PAR_VPD;
+			put_unaligned_be16(sizeof(vpd_data), &buf[2]);
+			memcpy(&buf[4], vpd_data, sizeof(vpd_data));
+			hdr->status = 0;
+			return 0;
+		}
+	}
+	return __real_ioctl(fd, request, param);
+}
+
 struct mocked_path *fill_mocked_path(struct mocked_path *mp,
 				     const char *vendor, const char *product,
 				     const char *rev, const char *wwid,
@@ -219,14 +265,13 @@ struct mocked_path *mocked_path_from_path(struct mocked_path *mp,
 	mp->devnode = pp->dev;
 	mp->flags = (prio_selected(&pp->prio) ? 0 : NEED_SELECT_PRIO) |
 		(pp->fd < 0 ? NEED_FD : 0) |
-		(pp->getuid ? USE_GETUID : 0);
+		(pp->vpd_vendor_id != 0 ? USE_VPD_VND : 0);
 	return mp;
 }
 
+static const char hbtl[] = "4:0:3:1";
 static void mock_sysfs_pathinfo(const struct mocked_path *mp)
 {
-	static const char hbtl[] = "4:0:3:1";
-
 	will_return(__wrap_udev_device_get_subsystem, "scsi");
 	will_return(__wrap_udev_device_get_sysname, hbtl);
 	will_return(__wrap_udev_device_get_sysname, hbtl);
@@ -284,16 +329,18 @@ void mock_pathinfo(int mask, const struct mocked_path *mp)
 	/* fake open() in pathinfo() */
 	if (mp->flags & NEED_FD)
 		will_return(__wrap_udev_device_get_devnode, _mocked_filename);
-	/* DI_SERIAL is unsupported */
-	assert_false(mask & DI_SERIAL);
+
+	/* scsi_ioctl_pathinfo() */
+	if (mask & DI_SERIAL) {
+		will_return(__wrap_udev_device_get_subsystem, "scsi");
+		will_return(__wrap_udev_device_get_sysname, hbtl);
+		will_return(__wrap_udev_device_get_sysname, hbtl);
+	}
 
 	if (mask & DI_WWID) {
-		if (mp->flags & USE_GETUID)
-			will_return(__wrap_execute_program, mp->wwid);
-		else
-			/* get_udev_uid() */
-			will_return(__wrap_udev_device_get_property_value,
-				    mp->wwid);
+		/* get_udev_uid() */
+		will_return(__wrap_udev_device_get_property_value,
+			    mp->wwid);
 	}
 
 	if (mask & DI_CHECKER) {
diff --git a/tests/test-lib.h b/tests/test-lib.h
index 7643ab6..efd03a7 100644
--- a/tests/test-lib.h
+++ b/tests/test-lib.h
@@ -14,7 +14,7 @@ enum {
 	BL_MASK = BL_BY_DEVNODE|BL_BY_DEVICE|BL_BY_WWID|BL_BY_PROPERTY,
 	NEED_SELECT_PRIO = (1 << 8),
 	NEED_FD		= (1 << 9),
-	USE_GETUID	= (1 << 10),
+	USE_VPD_VND	= (1 << 10),
 	DEV_HIDDEN	= (1 << 11),
 };
 
-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

