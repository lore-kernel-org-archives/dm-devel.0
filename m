Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29372C61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 19:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676575359;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rv8JVKL7xDpkNfH0Ui5QrtVCqs79uvlerSKDD/EdwwA=;
	b=BuK3Ty40vX+P3GQCXIBY8JSakIDUbAQbk3ipzDckGminCNmRt3CCKP2K9oyKnylcj6U9Hv
	o0yl82gW18pFNFRGpff1D1EZgDl23qclJDBD1xzjxirUKqMMWVikeAGQeDnFfSQ6J1YQSj
	VAqvVfV9Obe7w3VvXpan5FZ5vRDnN/c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-iL2ocTwXMQ2UlBSeQNsXFw-1; Thu, 16 Feb 2023 14:22:35 -0500
X-MC-Unique: iL2ocTwXMQ2UlBSeQNsXFw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DF8388904B;
	Thu, 16 Feb 2023 19:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3847492B15;
	Thu, 16 Feb 2023 19:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 913E21946589;
	Thu, 16 Feb 2023 19:22:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E4D81946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 19:22:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4CA0940C10FA; Thu, 16 Feb 2023 19:22:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 441EA40C1423
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 19:22:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29AFC2A5954E
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 19:22:31 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-122-3FQpm56sOmywvNbbuG-OjQ-1; Thu,
 16 Feb 2023 14:22:29 -0500
X-MC-Unique: 3FQpm56sOmywvNbbuG-OjQ-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1pSjYO-008e70-Gb; Thu, 16 Feb 2023 19:04:24 +0000
Date: Thu, 16 Feb 2023 19:04:24 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <Y+5+OKbeTO2d9TsH@casper.infradead.org>
References: <alpine.LRH.2.21.2302161245210.18393@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2302161245210.18393@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] dm-crypt: allocate compound pages if possible
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
Cc: Yang Shi <shy828301@gmail.com>, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org,
 dm-devel@redhat.com, akpm@linux-foundation.org, mgorman@techsingularity.net,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 16, 2023 at 12:47:08PM -0500, Mikulas Patocka wrote:
> +		while (order > 0) {
> +			page = alloc_pages(gfp_mask
> +				| __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN, order);

... | __GFP_COMP

>  		page = mempool_alloc(&cc->page_pool, gfp_mask);
>  		if (!page) {
>  			crypt_free_buffer_pages(cc, clone);
>  			bio_put(clone);
>  			gfp_mask |= __GFP_DIRECT_RECLAIM;
> +			order = 0;
>  			goto retry;
>  		}
>  
> -		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
> -
> -		bio_add_page(clone, page, len, 0);
> +have_pages:
> +		page->compound_order = order;

No.  You'll corrupt the next page if page is order-0, which it is if it
came from the mempool.  Also we've deleted page->compound_order in -next
so you can't make this mistake.  Using __GFP_COMP will set this field
for you, so you can just drop this line.

> -		remaining_size -= len;
> +		for (o = 0; o < 1U << order; o++) {
> +			unsigned len = min((unsigned)PAGE_SIZE, remaining_size);
> +			bio_add_page(clone, page, len, 0);
> +			remaining_size -= len;
> +			page++;

You can add multiple pages at once, whether they're compound or not.  So
replace this entire loop with:

		bio_add_page(clone, page, remaining_size, 0);

> @@ -1711,10 +1732,23 @@ static void crypt_free_buffer_pages(stru
>  {
>  	struct bio_vec *bv;
>  	struct bvec_iter_all iter_all;
> +	unsigned skip_entries = 0;
>  
>  	bio_for_each_segment_all(bv, clone, iter_all) {
> -		BUG_ON(!bv->bv_page);
> -		mempool_free(bv->bv_page, &cc->page_pool);
> +		unsigned order;
> +		struct page *page = bv->bv_page;
> +		BUG_ON(!page);
> +		if (skip_entries) {
> +			skip_entries--;
> +			continue;
> +		}
> +		order = page->compound_order;
> +		if (order) {
> +			__free_pages(page, order);
> +			skip_entries = (1U << order) - 1;
> +		} else {
> +			mempool_free(page, &cc->page_pool);
> +		}

You can simplify this by using the folio code.

	struct folio_iter fi;

	bio_for_each_folio_all(fi, bio) {
		if (folio_test_large(folio))
			folio_put(folio);
		else
			mempool_free(&folio->page, &cc->page_pool);
	}

(further work would actually convert this driver to use folios instead
of pages)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

