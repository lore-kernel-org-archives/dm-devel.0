Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63AF4C54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 07:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663659501;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9DxCX0cY9HdjXLOzZZ+JmK/EW79SsqM1P+r94gEtW9M=;
	b=eS6T0SFeTFv6KkVLmvLZvFlRVnrx35hv2CiFkY1tT66j/a3VrXgZL5gly52E8O6LG8a8aD
	cjWRs3cWrKBMsmwx31x5j1XIgkQxNzAM/K4tvFIPisgGh4sTKxpsYJIjMyWzCkyQnTz3j4
	F0SOcKqEM3Zir3N5/7fmW9BCxkXbkPI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-eZPYPMaIPEK7t3eRRMg59Q-1; Tue, 20 Sep 2022 03:38:18 -0400
X-MC-Unique: eZPYPMaIPEK7t3eRRMg59Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DF4F85A5B6;
	Tue, 20 Sep 2022 07:38:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3517E40E42E4;
	Tue, 20 Sep 2022 07:38:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E182A19465A3;
	Tue, 20 Sep 2022 07:38:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7919919465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 07:38:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 623332166B40; Tue, 20 Sep 2022 07:38:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B9332166B3F
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 07:38:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CB3D1C06EC0
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 07:38:14 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-56-gqTQJZ1fNhKJbhNVh2N2mw-1; Tue, 20 Sep 2022 03:38:10 -0400
X-MC-Unique: gqTQJZ1fNhKJbhNVh2N2mw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1oaXpY-001Q1v-Mo; Tue, 20 Sep 2022 07:38:08 +0000
Date: Tue, 20 Sep 2022 00:38:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <Yylt4A7B6dsn7+bu@infradead.org>
References: <alpine.LRH.2.02.2209151604410.13231@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209160459250.543@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2209160459250.543@file01.intranet.prod.int.rdu2.redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 2/4] brd: extend the rcu regions to cover
 read and write
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>   * Look up and return a brd's page for a given sector.
> + * This must be called with the rcu lock held.

Please ad a rcu_read_lock_held() check then.

> -	rcu_read_lock();
>  	idx = sector >> PAGE_SECTORS_SHIFT; /* sector to page index */
>  	page = radix_tree_lookup(&brd->brd_pages, idx);
> -	rcu_read_unlock();
> -
> -	BUG_ON(page && page->index != idx);
>  
>  	return page;

No need for the page variable now.  In fact there is no real need
for this helper now, as all the callers really should operate on
the sector on the index anyway.

>  }
> @@ -88,7 +74,9 @@ static bool brd_insert_page(struct brd_d
>  	struct page *page;
>  	gfp_t gfp_flags;
>  
> +	rcu_read_lock();
>  	page = brd_lookup_page(brd, sector);
> +	rcu_read_unlock();
>  	if (page)
>  		return true;

So this looks odd, as we drop the rcu lock without doing anything,
but it actually turns out to be correct as brd_do_bvec does yet
another lookup of it.  So we get an initial look, and optional
insert and then another lookup.  Not very efficient and it might be
worth to fix brd_do_bvec up to avoid these extra lookups given
that you touch it anyway (as would be an radix tree to xarray
conversion).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

