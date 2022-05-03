Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 412EFC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 23:15:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194--irc6z4wPQGNIbxk7CCv1g-1; Tue, 03 May 2022 19:15:44 -0400
X-MC-Unique: -irc6z4wPQGNIbxk7CCv1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22325185A7B2;
	Tue,  3 May 2022 23:15:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B38EC414A7E7;
	Tue,  3 May 2022 23:15:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 702FF1947040;
	Tue,  3 May 2022 23:15:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A9D619466DF
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 23:15:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4FF245553A2; Tue,  3 May 2022 23:15:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C2AD5553A0
 for <dm-devel@redhat.com>; Tue,  3 May 2022 23:15:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE4E2891F58
 for <dm-devel@redhat.com>; Tue,  3 May 2022 23:15:31 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-GflJoyBvM6iVOHHR1zjq3w-1; Tue, 03 May 2022 18:07:18 -0400
X-MC-Unique: GflJoyBvM6iVOHHR1zjq3w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 05CFB210ED;
 Tue,  3 May 2022 22:07:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC2B913ABE;
 Tue,  3 May 2022 22:07:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id INJBMJSncWLfFgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 03 May 2022 22:07:16 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  4 May 2022 00:06:43 +0200
Message-Id: <20220503220646.16925-5-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH 4/7] tests/hwtable: fix
 test_regex_2_strings_hwe_dir
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Unlike "getuid_callout", "vpd_vendor" doesn't invalidate "uid_attribute".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c  | 2 +-
 tests/test-lib.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index b8e73a6..e60e914 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -888,8 +888,8 @@ static void test_regex_2_strings_hwe_dir(const struct hwt_state *hwt)
 	/* foo:barz matches kv3 and kv2 and kv1 */
 	pp = mock_path_flags(vnd_foo.value, prd_barz.value, USE_VPD_VND);
 	TEST_PROP(prio_name(&pp->prio), prio_rdac.value);
-	TEST_PROP(pp->uid_attribute, NULL);
 	assert_int_equal(pp->vpd_vendor_id, VPD_VP_HP3PAR);
+	TEST_PROP(pp->uid_attribute, uid_baz.value);
 	TEST_PROP(checker_name(&pp->checker), chk_hp.value);
 }
 
diff --git a/tests/test-lib.c b/tests/test-lib.c
index 68e0dd8..6dd3ee8 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -229,7 +229,7 @@ int __wrap_ioctl(int fd, unsigned long request, void *param)
 		if (hdr->interface_id == 'S' && hdr->cmdp[0] == 0x12
 		    && (hdr->cmdp[1] & 1) == 1 && hdr->cmdp[2] == HP3PAR_VPD) {
 			assert_in_range(hdr->dxfer_len,
-					sizeof(vpd_data + 3), INT_MAX);
+					sizeof(vpd_data) + 3, INT_MAX);
 			memset(buf, 0, hdr->dxfer_len);
 			buf[1] = HP3PAR_VPD;
 			put_unaligned_be16(sizeof(vpd_data), &buf[2]);
-- 
2.36.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

