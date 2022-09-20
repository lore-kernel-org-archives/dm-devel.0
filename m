Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCB5C54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 07:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663659577;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N0HLSgxkr4UXiYKKPAGYqVlBfsUTH/SFqvVGd9LrFg8=;
	b=bGFOPWJLuZ2Sl+xPcTni5X4qrWasYU5g0EoMQ5Qwl7XnuNPROBRYRW0vdX9Yn/yJno+mTh
	DmhRFhVA3uOGQAvvNPbnul8ZHQRuJWDTVPg5peT6xWtEROf6BH7sGt6lXj+hO+UUM7XN7a
	51iX7iMMGuD521mdt41dZacINIYcJ2Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-tBoy1VkANxS_QR-0EPeSsA-1; Tue, 20 Sep 2022 03:39:33 -0400
X-MC-Unique: tBoy1VkANxS_QR-0EPeSsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E1F8862FEB;
	Tue, 20 Sep 2022 07:39:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 695EDC15995;
	Tue, 20 Sep 2022 07:39:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 41BC319465A3;
	Tue, 20 Sep 2022 07:39:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32DBA19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 07:39:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 10A83492CA5; Tue, 20 Sep 2022 07:39:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09750492CA2
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 07:39:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E374A185A78B
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 07:39:29 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-192-ZgepqP4wNomNmWrmmFD6Hw-1; Tue, 20 Sep 2022 03:39:26 -0400
X-MC-Unique: ZgepqP4wNomNmWrmmFD6Hw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1oaXqk-001Qp0-Kk; Tue, 20 Sep 2022 07:39:22 +0000
Date: Tue, 20 Sep 2022 00:39:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YyluKtwOaLSPvNmI@infradead.org>
References: <alpine.LRH.2.02.2209151604410.13231@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209160459470.543@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2209160459470.543@file01.intranet.prod.int.rdu2.redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 3/4] brd: enable discard
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> @@ -289,6 +308,23 @@ static void brd_submit_bio(struct bio *b
>  	struct bio_vec bvec;
>  	struct bvec_iter iter;
>  
> +	if (bio_op(bio) == REQ_OP_DISCARD) {
> +		sector_t len = bio_sectors(bio);
> +		sector_t front_pad = -sector & (PAGE_SECTORS - 1);
> +		sector += front_pad;
> +		if (unlikely(len <= front_pad))
> +			goto endio;
> +		len -= front_pad;
> +		len = round_down(len, PAGE_SECTORS);
> +		while (len) {
> +			brd_free_page(brd, sector);
> +			sector += PAGE_SECTORS;
> +			len -= PAGE_SECTORS;
> +			cond_resched();
> +		}
> +		goto endio;
> +	}
> +
>  	bio_for_each_segment(bvec, bio, iter) {

Please add separate helpers to each type of IO and just make the
main submit_bio method a dispatch on the types instead of this
spaghetti code.

> +	disk->queue->limits.discard_granularity = PAGE_SIZE;
> +	blk_queue_max_discard_sectors(disk->queue, UINT_MAX);

We'll probably want an opt in for this new feature.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

