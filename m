Return-Path: <SRS0=IV6L=OF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6270FC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 11:15:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDE3661279
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 11:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CDE3661279
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-ufi7PC6zPAWlEevvo32eyQ-1; Wed, 15 Sep 2021 07:15:48 -0400
X-MC-Unique: ufi7PC6zPAWlEevvo32eyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 429D71023F53;
	Wed, 15 Sep 2021 11:15:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05F63196E6;
	Wed, 15 Sep 2021 11:15:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF52E4EA2F;
	Wed, 15 Sep 2021 11:15:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18FBEnK0030310 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 07:14:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8B5C11112C13; Wed, 15 Sep 2021 11:14:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8588A100CA52
	for <dm-devel@redhat.com>; Wed, 15 Sep 2021 11:14:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E179E800C00
	for <dm-devel@redhat.com>; Wed, 15 Sep 2021 11:14:46 +0000 (UTC)
Received: from smtp-relay-canonical-0.canonical.com
	(smtp-relay-canonical-0.canonical.com [185.125.188.120]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-212-YF6R6ECsPUGKuFA6kK-ptA-1;
	Wed, 15 Sep 2021 07:14:42 -0400
X-MC-Unique: YF6R6ECsPUGKuFA6kK-ptA-1
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
	server-digest SHA256) (No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id
	7BFE94017C; Wed, 15 Sep 2021 11:14:40 +0000 (UTC)
From: Colin King <colin.king@canonical.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com
Date: Wed, 15 Sep 2021 12:14:40 +0100
Message-Id: <20210915111440.12011-1-colin.king@canonical.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18FBEnK0030310
X-loop: dm-devel@redhat.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm-clone: make array descs static
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Colin Ian King <colin.king@canonical.com>

Don't populate the read-only array descs on the stack but instead it
static and add extra const. Also makes the object code smaller by 66
bytes:

Before:
   text    data     bss     dec     hex filename
  42382   11140     512   54034    d312 ./drivers/md/dm-clone-target.o

After:
   text    data     bss     dec     hex filename
  42220   11236     512   53968    d2d0 ./drivers/md/dm-clone-target.o

(gcc version 11.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/dm-clone-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 84dbe08ad205..29f74b2a5cd2 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -161,7 +161,7 @@ static const char *clone_device_name(struct clone *clone)
 
 static void __set_clone_mode(struct clone *clone, enum clone_metadata_mode new_mode)
 {
-	const char *descs[] = {
+	static const char * const descs[] = {
 		"read-write",
 		"read-only",
 		"fail"
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

