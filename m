Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3668C25B4E
	for <dm-devel@archiver.kernel.org>; Sun, 22 Jan 2023 19:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674414218;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/wYPJZJKfLhqJ8UKm/oATKNEActv7gcmm0072IsMZq8=;
	b=CDGNyEqLYxs2FcreS6+Pn4sgWACWZhcwXTbA1jEBt8oeRg9OnJ6tFI3GcycZ8tmL133t7r
	tJ3y38LIwCRmNcteon3Fs5+HbxGf4Bv/v+3YTri2DcLsKzkHrYb4EAt2LKLLt0WxH9p54q
	OPq1vARBxyxl9JSpInQI53dMsJsyang=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-qaCxZy3yNx2ELyO-XIC7Rg-1; Sun, 22 Jan 2023 14:03:35 -0500
X-MC-Unique: qaCxZy3yNx2ELyO-XIC7Rg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 403D81869B6C;
	Sun, 22 Jan 2023 19:03:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 30ABB40C1141;
	Sun, 22 Jan 2023 19:03:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D7171946587;
	Sun, 22 Jan 2023 19:03:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A1471946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 22 Jan 2023 19:03:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2518540C1141; Sun, 22 Jan 2023 19:03:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17099400D795;
 Sun, 22 Jan 2023 19:03:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 30MJ3VKr015446; Sun, 22 Jan 2023 14:03:31 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 30MJ3VGn015443; Sun, 22 Jan 2023 14:03:31 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Sun, 22 Jan 2023 14:03:31 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.21.2301221402580.15312@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 2/3] dm-flakey: fix a bug with 32-bit highmem
 systems
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The function page_address does not work with 32-bit systems with high
memory. Use bvec_kmap_local/kunmap_local instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-flakey.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: bcachefs/drivers/md/dm-flakey.c
===================================================================
--- bcachefs.orig/drivers/md/dm-flakey.c	2023-01-22 16:58:40.000000000 +0100
+++ bcachefs/drivers/md/dm-flakey.c	2023-01-22 17:13:53.000000000 +0100
@@ -307,8 +307,9 @@ static void corrupt_bio_data(struct bio
 			struct page *page = bio_iter_page(bio, iter);
 			if (unlikely(page == ZERO_PAGE(0)))
 				break;
-			segment = (page_address(page) + bio_iter_offset(bio, iter));
+			segment = bvec_kmap_local(&bvec);
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
+			kunmap_local(segment);
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
 				bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

