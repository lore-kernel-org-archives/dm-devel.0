Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6329C43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 10:14:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-ounKnFPlMUOvcfgULKvnTg-1; Thu, 09 Jun 2022 06:14:06 -0400
X-MC-Unique: ounKnFPlMUOvcfgULKvnTg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E18C188144E;
	Thu,  9 Jun 2022 10:14:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D067C40EC002;
	Thu,  9 Jun 2022 10:14:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8DD52194704D;
	Thu,  9 Jun 2022 10:14:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B73F1947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 10:14:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1BD7B40EC003; Thu,  9 Jun 2022 10:14:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17F2140EC002
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 10:14:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3D29811E75
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 10:14:01 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-pwOjG28yN7aYN_C369v-dw-1; Thu, 09 Jun 2022 06:14:00 -0400
X-MC-Unique: pwOjG28yN7aYN_C369v-dw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 109F921E01;
 Thu,  9 Jun 2022 10:13:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D05FD13A8C;
 Thu,  9 Jun 2022 10:13:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id sWPSMObHoWKGfQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 09 Jun 2022 10:13:58 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  9 Jun 2022 12:13:55 +0200
Message-Id: <20220609101355.21365-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH] multipath-tools: tests: fix hwtable test
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

After "libmultipath: hwtable: new defaults for NVMe", we need to fix
the unit tests.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index e60e914..bfaf613 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -573,7 +573,7 @@ static void test_internal_nvme(const struct hwt_state *hwt)
 	assert_ptr_not_equal(mp, NULL);
 	TEST_PROP(checker_name(&pp->checker), NONE);
 	TEST_PROP(pp->uid_attribute, DEFAULT_NVME_UID_ATTRIBUTE);
-	assert_int_equal(mp->pgpolicy, DEFAULT_PGPOLICY);
+	assert_int_equal(mp->pgpolicy, GROUP_BY_PRIO);
 	assert_int_equal(mp->no_path_retry, DEFAULT_NO_PATH_RETRY);
 	assert_int_equal(mp->retain_hwhandler, RETAIN_HWHANDLER_OFF);
 
@@ -586,7 +586,7 @@ static void test_internal_nvme(const struct hwt_state *hwt)
 	assert_ptr_not_equal(mp, NULL);
 	TEST_PROP(checker_name(&pp->checker), NONE);
 	TEST_PROP(pp->uid_attribute, "ID_WWN");
-	assert_int_equal(mp->pgpolicy, MULTIBUS);
+	assert_int_equal(mp->pgpolicy, GROUP_BY_PRIO);
 	assert_int_equal(mp->no_path_retry, NO_PATH_RETRY_QUEUE);
 	assert_int_equal(mp->retain_hwhandler, RETAIN_HWHANDLER_OFF);
 }
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

