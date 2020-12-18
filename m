Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC3CC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 22:27:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3AD2123B88
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 22:27:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AD2123B88
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-6uiySrKcOLK95PTA1rODVw-1; Fri, 18 Dec 2020 17:27:41 -0500
X-MC-Unique: 6uiySrKcOLK95PTA1rODVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0CBB801FAE;
	Fri, 18 Dec 2020 22:27:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CEE1C299B0;
	Fri, 18 Dec 2020 22:27:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 93C251809C9F;
	Fri, 18 Dec 2020 22:27:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIMRZvd023715 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 17:27:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0A3E9F4EBA; Fri, 18 Dec 2020 22:27:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0469AF4EB4
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 22:27:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5826858284
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 22:27:28 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-136-BrI4cDnFPU-ZVzYrV6nhPQ-1;
	Fri, 18 Dec 2020 17:27:24 -0500
X-MC-Unique: BrI4cDnFPU-ZVzYrV6nhPQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 13CF6ACA5;
	Fri, 18 Dec 2020 22:27:23 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 18 Dec 2020 23:27:14 +0100
Message-Id: <20201218222714.16209-2-mwilck@suse.com>
In-Reply-To: <20201218222714.16209-1-mwilck@suse.com>
References: <20201218222714.16209-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BIMRZvd023715
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/2] multipath-tools unit tests: fix memory leaks
	in mpathvalid tests
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

They break "make valgrind-test".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/mpathvalid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/mpathvalid.c b/tests/mpathvalid.c
index 5ffabb9..cfe4bae 100644
--- a/tests/mpathvalid.c
+++ b/tests/mpathvalid.c
@@ -381,6 +381,7 @@ static void test_mpathvalid_is_path_good2(void **state)
 	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
 					    wwids, 4), MPATH_IS_VALID);
 	assert_string_equal(wwid, TEST_WWID);
+	free(wwid);
 }
 
 static void test_mpathvalid_is_path_good3(void **state)
@@ -395,6 +396,7 @@ static void test_mpathvalid_is_path_good3(void **state)
 	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_SMART, &wwid,
 					    wwids, 4), MPATH_IS_VALID);
 	assert_string_equal(wwid, TEST_WWID);
+	free(wwid);
 }
 
 /* mabybe valid with no matching paths */
@@ -410,6 +412,7 @@ static void test_mpathvalid_is_path_good4(void **state)
 	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
 					    wwids, 4), MPATH_IS_MAYBE_VALID);
 	assert_string_equal(wwid, TEST_WWID);
+	free(wwid);
 }
 
 /* maybe valid with matching paths */
@@ -425,6 +428,7 @@ static void test_mpathvalid_is_path_good5(void **state)
 	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
 					    wwids, 4), MPATH_IS_VALID);
 	assert_string_equal(wwid, TEST_WWID);
+	free(wwid);
 }
 
 #define setup_test(name) \
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

