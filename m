Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66F4C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 19:06:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8612C64F2F
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 19:06:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8612C64F2F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614711972;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AF4RJfo/2Sh5YfOw9ECcEr5Vi8EjUT7p3Uvr0IIWaBs=;
	b=L+nWaen+4OxchHV8tgL8xy3i+ht88WxaBMveUHqZUir1cMmejLd83GCT9e51Yj6pSQ/Zjr
	kPoNqj5XkA7DcP1Sd/A85fg96ZW3/ORW+X3hJDFUYw62Rxx1eent5g+dC8zTOLF+u20Jta
	Kk7mLHjEcmQF9YY0GOGRZ7UPrOCIVns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-a8jDLwcHPb-W3JBv4oYtPQ-1; Tue, 02 Mar 2021 14:06:10 -0500
X-MC-Unique: a8jDLwcHPb-W3JBv4oYtPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC48A193578E;
	Tue,  2 Mar 2021 19:06:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CB315C8B3;
	Tue,  2 Mar 2021 19:06:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5CA2B1809C8F;
	Tue,  2 Mar 2021 19:06:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122J60XQ011088 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 14:06:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 664FC6268E; Tue,  2 Mar 2021 19:06:00 +0000 (UTC)
Received: from leontynka.twibright.com (ovpn-116-252.ams2.redhat.com
	[10.36.116.252])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63EEC61F20;
	Tue,  2 Mar 2021 19:05:56 +0000 (UTC)
Received: from debian-a64.vm ([192.168.208.2])
	by leontynka.twibright.com with smtp (Exim 4.92)
	(envelope-from <mpatocka@redhat.com>)
	id 1lHALB-0003kD-WF; Tue, 02 Mar 2021 20:05:55 +0100
Received: by debian-a64.vm (sSMTP sendmail emulation);
	Tue, 02 Mar 2021 20:05:52 +0100
Message-Id: <20210302190552.715551440@debian-a64.vm>
User-Agent: quilt/0.65
Date: Tue, 02 Mar 2021 20:05:15 +0100
From: Mikulas Patocka <mpatocka@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>, Mike Snitzer <msnitzer@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
	caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, hch@lst.de
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
Subject: [dm-devel] [PATCH 2/4] block: dont clear REQ_HIPRI for bio-based
	drivers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline; filename=block-allow-bio-hipri.patch
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Don't clear REQ_HIPRI for bio-based drivers. Device mapper will need to
see this flag in order to support polling.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2021-03-02 10:43:28.000000000 +0100
+++ linux-2.6/block/blk-core.c	2021-03-02 10:53:50.000000000 +0100
@@ -836,7 +836,7 @@ static noinline_for_stack bool submit_bi
 		}
 	}
 
-	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && !bdev->bd_disk->fops->submit_bio)
 		bio->bi_opf &= ~REQ_HIPRI;
 
 	switch (bio_op(bio)) {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

