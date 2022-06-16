Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84563C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655400623;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5/AfsuxFEhoLfFSpOP/3Osmp12lXjyss7ylbCXIEoZI=;
	b=TtA3NAEIDyMufq2mkg/E0XkxFY9eh3jcocuymFCbyGZ2mGc5wmT8VrHYG+VO9w2mZpIjG6
	XKiepTJvvTyfV8B8T6jX//Ej9qmrmqVFQru/hEeJsvqzbu2RT7aCPk8da97ndh8//eJiEG
	3JUcp9Htl3EHnzgoMPCqn/fWUx5Gr14=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-WCRq2-koNYKf3TyKeNsU9A-1; Thu, 16 Jun 2022 13:30:21 -0400
X-MC-Unique: WCRq2-koNYKf3TyKeNsU9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47D21380117C;
	Thu, 16 Jun 2022 17:30:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31DB12024CB8;
	Thu, 16 Jun 2022 17:30:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF19F194705D;
	Thu, 16 Jun 2022 17:30:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3AFC194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 17:28:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C515018EAE; Thu, 16 Jun 2022 17:28:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB009111F5;
 Thu, 16 Jun 2022 17:28:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 25GHSvmO025081; Thu, 16 Jun 2022 13:28:57 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 25GHSvPO025077; Thu, 16 Jun 2022 13:28:57 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 16 Jun 2022 13:28:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2206161327190.22594@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH] dm-mirror: round up region bitmap size to
 BITS_PER_LONG
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The code in dm-long rounds up bitset_size to 32 bits. It then uses
find_next_zero_bit_le on the allocated region. find_next_zero_bit_le
accesses the bitmap using unsigned long pointers. So, on 64-bit
architectures, it may access 4 bytes beyond the allocated size.

This bug was found by running the lvm testsuite with kasan.

This patch fixes the bug by rounding up bitset_size to BITS_PER_LONG.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-log.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-log.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log.c	2022-05-16 13:41:44.000000000 +0200
+++ linux-2.6/drivers/md/dm-log.c	2022-06-16 08:57:46.000000000 +0200
@@ -415,8 +415,7 @@ static int create_log_context(struct dm_
 	/*
 	 * Work out how many "unsigned long"s we need to hold the bitset.
 	 */
-	bitset_size = dm_round_up(region_count,
-				  sizeof(*lc->clean_bits) << BYTE_SHIFT);
+	bitset_size = dm_round_up(region_count, BITS_PER_LONG);
 	bitset_size >>= BYTE_SHIFT;
 
 	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

