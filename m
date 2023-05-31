Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE328C7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 22:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685572634;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HibZZGEycNRwbSg5YYCgHkC1cCOz9XdyuIWrHQVxX9M=;
	b=WEy+4NKRSOLzgqv88+3k1EPljxvJPKrUgpcmn81AviIXp7OhROI68+4+xH1M6II5IvMuxP
	a50boB6Jr8crFt9hOvYp00VXlB7irQ9Jx15Qs685E4sXyudjOctgRYrOEHyBerbuFQRMUv
	xAvxKn8whmHau292gstGL5XaPvjMpS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-FgrA5M-ZOxKyD1_mRGxioQ-1; Wed, 31 May 2023 18:37:11 -0400
X-MC-Unique: FgrA5M-ZOxKyD1_mRGxioQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 038D08038E8;
	Wed, 31 May 2023 22:37:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5968220296C6;
	Wed, 31 May 2023 22:37:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6EA0619465B7;
	Wed, 31 May 2023 22:37:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADAE319465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 22:37:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9A46E492B0B; Wed, 31 May 2023 22:37:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 930FF492B0C
 for <dm-devel@redhat.com>; Wed, 31 May 2023 22:37:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78C2285A5AA
 for <dm-devel@redhat.com>; Wed, 31 May 2023 22:37:04 +0000 (UTC)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-sUPsYy0aPeCHuD6_LzxuLg-1; Wed, 31 May 2023 18:37:02 -0400
X-MC-Unique: sUPsYy0aPeCHuD6_LzxuLg-1
Received: by mail-oi1-f169.google.com with SMTP id
 5614622812f47-3982f09df74so54377b6e.0
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:37:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685572622; x=1688164622;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=n3rg9Z09BIl1aIQXz+8gKGwERErjA3Juhruo9wqB2U8=;
 b=XNSvsgFwjaaqKA+fhK5NLR/v2i/xI2h7mw0liVFJQVilOobng1mJIFBueCo5+3cjbe
 mDk2pfOggQ+uvueBuNC3Z6q9TzKOwclqV47SYOWMXnRBddImnVfNZt27c2IYR6kSu26X
 LPQOv2I241l1yPrq8DvhszvSTE+AxtLe7Tu/Yd71UYr6avc7yUqS0/O3iJeUUFRSk8Ax
 Oa8aeU0iS4KT4j6InGjl66ZdIU2BbJjyuRM1rDRoa0BUJ0IcJdnadFWUQJ+0uCL/+PT4
 YOm5Bz2RFoKk4n1dIfcalOk4QMR9ACTM6iIcx8AW5PjBzMLkP1zOsE68YC5D+rEq47ic
 8qvQ==
X-Gm-Message-State: AC+VfDy3ZJDtKoaD5VpxiaypsFalezm9hiiUGEzn+SgL4BDrELu4dqe4
 IcnjgP1Kbbw/c+knPjm/94m4qg==
X-Google-Smtp-Source: ACHHUZ7R3wjvNkmWSbL60I9ylavOeUTJY88g1+p1PDiLJE+SHWNaI13IUYsVS+xjUDM8kOkAj2iUNQ==
X-Received: by 2002:a05:6808:1496:b0:398:2f85:ff7f with SMTP id
 e22-20020a056808149600b003982f85ff7fmr6512900oiw.50.1685572621938; 
 Wed, 31 May 2023 15:37:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au.
 [49.179.0.188]) by smtp.gmail.com with ESMTPSA id
 e12-20020a170902784c00b001b034fafaefsm1948337pln.38.2023.05.31.15.37.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 May 2023 15:37:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q4UR9-006HGI-0M;
 Thu, 01 Jun 2023 08:36:59 +1000
Date: Thu, 1 Jun 2023 08:36:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Message-ID: <ZHfMC86ktyLtIxNb@dread.disaster.area>
References: <cover.1685532726.git.johannes.thumshirn@wdc.com>
 <58fa893c24c67340a63323f09a179fefdca07f2a.1685532726.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
In-Reply-To: <58fa893c24c67340a63323f09a179fefdca07f2a.1685532726.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v7 19/20] fs: iomap: use bio_add_folio_nofail
 where possible
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Song Liu <song@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-fsdevel@vger.kernel.org,
 gouha7@uniontech.com, Christoph Hellwig <hch@lst.de>,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 31, 2023 at 04:50:42AM -0700, Johannes Thumshirn wrote:
> When the iomap buffered-io code can't add a folio to a bio, it allocates a
> new bio and adds the folio to that one. This is done using bio_add_folio(),
> but doesn't check for errors.
> 
> As adding a folio to a newly created bio can't fail, use the newly
> introduced bio_add_folio_nofail() function.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/iomap/buffered-io.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 063133ec77f4..0edab9deae2a 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -312,7 +312,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>  			ctx->bio->bi_opf |= REQ_RAHEAD;
>  		ctx->bio->bi_iter.bi_sector = sector;
>  		ctx->bio->bi_end_io = iomap_read_end_io;
> -		bio_add_folio(ctx->bio, folio, plen, poff);
> +		bio_add_folio_nofail(ctx->bio, folio, plen, poff);
>  	}
>  
>  done:
> @@ -539,7 +539,7 @@ static int iomap_read_folio_sync(loff_t block_start, struct folio *folio,
>  
>  	bio_init(&bio, iomap->bdev, &bvec, 1, REQ_OP_READ);
>  	bio.bi_iter.bi_sector = iomap_sector(iomap, block_start);
> -	bio_add_folio(&bio, folio, plen, poff);
> +	bio_add_folio_nofail(&bio, folio, plen, poff);
>  	return submit_bio_wait(&bio);
>  }
>  
> @@ -1582,7 +1582,7 @@ iomap_add_to_ioend(struct inode *inode, loff_t pos, struct folio *folio,
>  
>  	if (!bio_add_folio(wpc->ioend->io_bio, folio, len, poff)) {
>  		wpc->ioend->io_bio = iomap_chain_bio(wpc->ioend->io_bio);
> -		bio_add_folio(wpc->ioend->io_bio, folio, len, poff);
> +		bio_add_folio_nofail(wpc->ioend->io_bio, folio, len, poff);
>  	}

We lose adjacent page merging with this change.

We've had performance regressions in the past that have been
attributed to either the page allocator not handing out sequential
adjacent pages for sequential writes and/or bios not merging
adjacent pages. Some hardware is much more performant when it only
has to do a single large DMA instead of (potentially) hundreds of
single page DMAs for the same amount of data...

What performance regression testing has been done on this change?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

