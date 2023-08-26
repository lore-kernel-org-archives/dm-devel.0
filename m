Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB94C83F11
	for <dm-devel@archiver.kernel.org>; Sat, 26 Aug 2023 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693058571;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ysy3AfpOpuoSZu4va0ChGGDD5woIcYSRue4sD0Rzafg=;
	b=PN1LCLJM/p1ePehwh8JZlsOJecRYvkII+eFhzMaWS86/zzkU8a2GMIyShFFzHWcWjI+CjD
	T9mgUk1kNUEsYmV8rfJcDZES6KAizpwxeqisqj2fCZvQXmIxd7GwkKAA9THpr+JM1EkFhn
	ngtn/uEj1j+e1DkPeMVouSP55Ac9EC8=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-gF8-xWS4MCuDCiVgx2RsWg-1; Sat, 26 Aug 2023 10:02:49 -0400
X-MC-Unique: gF8-xWS4MCuDCiVgx2RsWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 092C91C05AB0;
	Sat, 26 Aug 2023 14:02:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA1092026D68;
	Sat, 26 Aug 2023 14:02:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BEF7D19465B2;
	Sat, 26 Aug 2023 14:02:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 54DD419465A8
 for <dm-devel@listman.corp.redhat.com>; Sat, 26 Aug 2023 14:02:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 035B26B2B3; Sat, 26 Aug 2023 14:02:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF22A63A63
 for <dm-devel@redhat.com>; Sat, 26 Aug 2023 14:02:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D196B101A528
 for <dm-devel@redhat.com>; Sat, 26 Aug 2023 14:02:46 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-3_vtX_DhPd6MlpVHyXOA3Q-1; Sat, 26 Aug 2023 10:02:40 -0400
X-MC-Unique: 3_vtX_DhPd6MlpVHyXOA3Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B573D61F4E;
 Sat, 26 Aug 2023 14:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C56C433C8;
 Sat, 26 Aug 2023 14:02:38 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Date: Sat, 26 Aug 2023 10:02:36 -0400
Message-Id: <20230826140236.3867166-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] Patch "dm integrity: increase RECALC_SECTORS to improve
 recalculate speed" has been added to the 5.4-stable tree
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm integrity: increase RECALC_SECTORS to improve recalculate speed

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-increase-recalc_sectors-to-improve-reca.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e3089981378618bc4dd6cc6810b00e8a18d8cfb2
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Tue Apr 27 11:57:43 2021 -0400

    dm integrity: increase RECALC_SECTORS to improve recalculate speed
    
    [ Upstream commit b1a2b9332050c7ae32a22c2c74bc443e39f37b23 ]
    
    Increase RECALC_SECTORS because it improves recalculate speed slightly
    (from 390kiB/s to 410kiB/s).
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Stable-dep-of: 6d50eb472593 ("dm integrity: reduce vmalloc space footprint on 32-bit architectures")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d7911c623edde..12b086b14cc4a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -35,7 +35,7 @@
 #define MIN_LOG2_INTERLEAVE_SECTORS	3
 #define MAX_LOG2_INTERLEAVE_SECTORS	31
 #define METADATA_WORKQUEUE_MAX_ACTIVE	16
-#define RECALC_SECTORS			8192
+#define RECALC_SECTORS			32768
 #define RECALC_WRITE_SUPER		16
 #define BITMAP_BLOCK_SIZE		4096	/* don't change it */
 #define BITMAP_FLUSH_INTERVAL		(10 * HZ)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

