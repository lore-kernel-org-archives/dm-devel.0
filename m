Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F5E8C636D6
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 21:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676582383;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ef98xnkoROTj/yQTnTuobY93lqVXvhc4+SB4ZUJdBn8=;
	b=aQV9/K9BsF//Ps3DOEPBBN5zSblKifcKYh924tbUPuC5W7Dxi4WfaQekTss6uI6gKA8MXN
	qaW0gxPIwcUT3+lp4M9pP0QdYQehbrF+RJjJYmVi1mrocTavaIBLv7dMDTmcSIWaGez0TC
	NKBZTgGiNVMbThS8XS9sDDgkIGz3C24=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-2rM0PEfyND-tzEijqda7hw-1; Thu, 16 Feb 2023 16:19:39 -0500
X-MC-Unique: 2rM0PEfyND-tzEijqda7hw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A25A63C0E46C;
	Thu, 16 Feb 2023 21:19:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 916D2C15BA0;
	Thu, 16 Feb 2023 21:19:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65D86194658C;
	Thu, 16 Feb 2023 21:19:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A52F11946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 21:19:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7B68240C1074; Thu, 16 Feb 2023 21:19:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4649E40C10FA;
 Thu, 16 Feb 2023 21:19:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 31GLJXo0007124; Thu, 16 Feb 2023 16:19:33 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 31GLJWwh007120; Thu, 16 Feb 2023 16:19:32 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 16 Feb 2023 16:19:32 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Matthew Wilcox <willy@infradead.org>
In-Reply-To: <Y+5+OKbeTO2d9TsH@casper.infradead.org>
Message-ID: <alpine.LRH.2.21.2302161614540.5436@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2302161245210.18393@file01.intranet.prod.int.rdu2.redhat.com>
 <Y+5+OKbeTO2d9TsH@casper.infradead.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 16 Feb 2023, Matthew Wilcox wrote:

> > -		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
> > -
> > -		bio_add_page(clone, page, len, 0);
> > +have_pages:
> > +		page->compound_order = order;
> 
> No.  You'll corrupt the next page if page is order-0, which it is if it
> came from the mempool.  Also we've deleted page->compound_order in -next
> so you can't make this mistake.  Using __GFP_COMP will set this field
> for you, so you can just drop this line.

OK

> > -		remaining_size -= len;
> > +		for (o = 0; o < 1U << order; o++) {
> > +			unsigned len = min((unsigned)PAGE_SIZE, remaining_size);
> > +			bio_add_page(clone, page, len, 0);
> > +			remaining_size -= len;
> > +			page++;
> 
> You can add multiple pages at once, whether they're compound or not.  So
> replace this entire loop with:
> 
> 		bio_add_page(clone, page, remaining_size, 0);

This should be min((unsigned)PAGE_SIZE << order, remaining_size), because 
we may allocate less than remaining_size.

> > @@ -1711,10 +1732,23 @@ static void crypt_free_buffer_pages(stru
> >  {
> >  	struct bio_vec *bv;
> >  	struct bvec_iter_all iter_all;
> > +	unsigned skip_entries = 0;
> >  
> >  	bio_for_each_segment_all(bv, clone, iter_all) {
> > -		BUG_ON(!bv->bv_page);
> > -		mempool_free(bv->bv_page, &cc->page_pool);
> > +		unsigned order;
> > +		struct page *page = bv->bv_page;
> > +		BUG_ON(!page);
> > +		if (skip_entries) {
> > +			skip_entries--;
> > +			continue;
> > +		}
> > +		order = page->compound_order;
> > +		if (order) {
> > +			__free_pages(page, order);
> > +			skip_entries = (1U << order) - 1;
> > +		} else {
> > +			mempool_free(page, &cc->page_pool);
> > +		}
> 
> You can simplify this by using the folio code.
> 
> 	struct folio_iter fi;
> 
> 	bio_for_each_folio_all(fi, bio) {
> 		if (folio_test_large(folio))
> 			folio_put(folio);
> 		else
> 			mempool_free(&folio->page, &cc->page_pool);
> 	}

OK. I'm sending version 2 of the patch.

> (further work would actually convert this driver to use folios instead
> of pages)

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

