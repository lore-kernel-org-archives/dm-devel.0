Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD70C77B72
	for <dm-devel@archiver.kernel.org>; Mon, 17 Apr 2023 19:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681761375;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/rpSkssCkzPJuop45azYTuY74e8eUJ81krHYEu1OOo0=;
	b=Z8lpAXWSClv9c4Oy9K3eZNipkj1gg3TdU0sjOw56VKysnl0E8C6LmCIfam60OREehGS8p2
	XhwYABOO1GZAg+KMT7EYrtjqWQqacWCsePOCTqTZPXP0FaBHvNlTRlbLF1U6PbeMY4oZIY
	uJnHF1gA8u1rLSqVne8LCTOedKmvV8g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-n3-xRPboPyCCZDOVdPMTiA-1; Mon, 17 Apr 2023 15:56:12 -0400
X-MC-Unique: n3-xRPboPyCCZDOVdPMTiA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11CD31C0515B;
	Mon, 17 Apr 2023 19:56:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ABCA647CD0;
	Mon, 17 Apr 2023 19:56:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77F5C194658C;
	Mon, 17 Apr 2023 19:56:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 51C341946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Apr 2023 19:56:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 16B8140C6E70; Mon, 17 Apr 2023 19:56:08 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D7AA040C6E6E;
 Mon, 17 Apr 2023 19:56:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 33HJu7gX004333; Mon, 17 Apr 2023 15:56:07 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 33HJu7dI004329; Mon, 17 Apr 2023 15:56:07 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 17 Apr 2023 15:56:07 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Matthew Wilcox <willy@infradead.org>
In-Reply-To: <ZD2e5lw5CqueygSA@casper.infradead.org>
Message-ID: <alpine.LRH.2.21.2304171533510.20290@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2304171433370.17217@file01.intranet.prod.int.rdu2.redhat.com>
 <ZD2e5lw5CqueygSA@casper.infradead.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] block: fix a crash when
 bio_for_each_folio_all iterates over an empty bio
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 17 Apr 2023, Matthew Wilcox wrote:

> On Mon, Apr 17, 2023 at 03:11:57PM -0400, Mikulas Patocka wrote:
> > If we use bio_for_each_folio_all on an empty bio, it will access the first
> > bio vector unconditionally (it is uninitialized) and it may crash
> > depending on the uninitialized data.
> 
> Wait, how do we have an empty bio in the first place?

dm-crypt (with the patch that you suggested here: 
https://www.spinics.net/lists/kernel/msg4691572.html
https://lore.kernel.org/linux-mm/alpine.LRH.2.21.2302161619430.5436@file01.intranet.prod.int.rdu2.redhat.com/T/
) calls:

gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
...
pages = mempool_alloc(&cc->page_pool, gfp_mask);
if (!pages) {
	crypt_free_buffer_pages(cc, clone);
	bio_put(clone);
	gfp_mask |= __GFP_DIRECT_RECLAIM;
	order = 0;
	goto retry;
}

If the mempool_alloc of the first page fails (it may happen because it 
uses GFP_NOWAIT), crypt_free_buffer_pages will be called with an empty 
bio.


I also hit this bug when fixing a dm-flakey target - it is triggered by 
this: 
https://people.redhat.com/~mpatocka/patches/kernel/dm-flakey/dm-flakey-02-clone-pages.patch


I think that this patch doesn't have to be backported to the stable 
kernels (because there is currently no user that calls 
bio_for_each_folio_all on an empty bio), but for the next merge window, 
dm-crypt and dm-flakey is going to use it.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

