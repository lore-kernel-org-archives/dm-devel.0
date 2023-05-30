Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65AEC7EE2F
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 15:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685461829;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O+D42ncAsYUKJVXozRFHYPXZllow14AR4KlLyttqn0o=;
	b=OKUFTpq0jWLf24WTclHoj6GdYhHxcwuP6WkM8tvv21S8DfH/BynbmThUpEazjuVPFuLlmS
	APffrU1WLNYQ0oJ55zKHoNchHrtD9wWYM56xJ4HYEIy2A6JGP1tjy9x2drpEB9X+BbkddH
	ZVpWcjqlYkFJZBPpG5vl0SI+P1q/msA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-jQe3HXKEPIGz7_Oy1RmC9w-1; Tue, 30 May 2023 11:50:26 -0400
X-MC-Unique: jQe3HXKEPIGz7_Oy1RmC9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0C2E8039AD;
	Tue, 30 May 2023 15:50:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4644C154D1;
	Tue, 30 May 2023 15:50:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 904B319452D3;
	Tue, 30 May 2023 15:50:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8FF1719465A2
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 15:49:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 72446400DFF; Tue, 30 May 2023 15:49:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AAD3492B00
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:49:57 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A3063C11A23
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:49:57 +0000 (UTC)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com
 [209.85.222.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-ZD3XMMWyPYiYPMqWA1QGNw-1; Tue, 30 May 2023 11:49:55 -0400
X-MC-Unique: ZD3XMMWyPYiYPMqWA1QGNw-1
Received: by mail-qk1-f173.google.com with SMTP id
 af79cd13be357-75b0b5c9eb8so263362285a.1
 for <dm-devel@redhat.com>; Tue, 30 May 2023 08:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685461795; x=1688053795;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ef9UXKlo6HOEzGKOWoRQOx3X1Mv/S3dqqbfR/aqcj1E=;
 b=S3tcJ9o7F+UwaBCNEUzs0YpKVR4X5F4Nz8H5BUg9suEn1IZyxL4SWoiv3ykOcWrIUw
 l1PACo19st0BOuJYJU2o1GTSd6xzwUVbsxdFxif1Y6nAQQY9o6Z1HTwaCANVlD6chnB6
 mcJPkFJNH3lM1w5U+tDlE1j9gF2Wn84wYdAaNVTtKCevcF92/A9zXXFg06y1cReeT/jO
 xVMZcTrg+hAP6XoVcjFsJg4ANq2qwSIkVIyg1z80Jdfl7IdYrxCs8LnPMEptf+DsTnvU
 fS69Cxi0f7m1qL8rs+vfrVtXMWTotLNjw/ytoFKuwt/tzlSnipGOYrcaLfCLLQFW0Hpw
 FxBA==
X-Gm-Message-State: AC+VfDwA4GrDf2nWH7VPcsyx/fKFwrH9boUaSe8C3u93AJKMCH5ht6qT
 4UKsU23mJDc/9va7M4C0+xttX+E=
X-Google-Smtp-Source: ACHHUZ7pliMoFycu95ZOXiwcTabY+u351+caH9+LwJwAEUbICb4vYuE61O+IVefjdSw8mai/KPkDog==
X-Received: by 2002:a05:620a:8084:b0:75c:c99d:e416 with SMTP id
 ef4-20020a05620a808400b0075cc99de416mr2289656qkb.49.1685461794842; 
 Tue, 30 May 2023 08:49:54 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 a23-20020a05620a16d700b0075b053ab66bsm4135656qkn.50.2023.05.30.08.49.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 May 2023 08:49:54 -0700 (PDT)
Date: Tue, 30 May 2023 11:49:53 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZHYbIYxGbcXbpvIK@redhat.com>
References: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
 <20230502101934.24901-17-johannes.thumshirn@wdc.com>
 <alpine.LRH.2.21.2305301045220.3943@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2305301045220.3943@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v5 16/20] dm-crypt: check if adding pages to
 clone bio fails
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
Cc: "axboe @ kernel . dk" <axboe@kernel.dk>, shaggy@kernel.org,
 damien.lemoal@wdc.com, kch@nvidia.com, agruenba@redhat.com, song@kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-raid@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, willy@infradead.org, ming.lei@redhat.com,
 cluster-devel@redhat.com, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-block@vger.kernel.org, rpeterso@redhat.com,
 linux-fsdevel@vger.kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 30 2023 at 11:13P -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 2 May 2023, Johannes Thumshirn wrote:
> 
> > Check if adding pages to clone bio fails and if it does retry with
> > reclaim. This mirrors the behaviour of page allocation in
> > crypt_alloc_buffer().
> > 
> > This way we can mark bio_add_pages as __must_check.
> > 
> > Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > ---
> >  drivers/md/dm-crypt.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 8b47b913ee83..b234dc089cee 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -1693,7 +1693,14 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
> >  
> >  		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
> >  
> > -		bio_add_page(clone, page, len, 0);
> > +		if (!bio_add_page(clone, page, len, 0)) {
> > +			mempool_free(page, &cc->page_pool);
> > +			crypt_free_buffer_pages(cc, clone);
> > +			bio_put(clone);
> > +			gfp_mask |= __GFP_DIRECT_RECLAIM;
> > +			goto retry;
> > +
> > +		}
> >  
> >  		remaining_size -= len;
> >  	}
> 
> Hi
> 
> I nack this. This just adds code that can't ever be executed.
> 
> dm-crypt already allocates enough entries in the vector (see "unsigned int 
> nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;"), so bio_add_page can't 
> fail.
> 
> If you want to add __must_check to bio_add_page, you should change the 
> dm-crypt code to:
> if (!bio_add_page(clone, page, len, 0)) {
> 	WARN(1, "this can't happen");
> 	return NULL;
> }
> and not write recovery code for a can't-happen case.

Thanks for the review Mikulas. But the proper way forward, in the
context of this patchset, is to simply change bio_add_page() to
__bio_add_page()

Subject becomes: "dm crypt: use __bio_add_page to add single page to clone bio"

And header can explain that "crypt_alloc_buffer() already allocates
enough entries in the clone bio's vector, so bio_add_page can't fail".

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

