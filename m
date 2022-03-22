Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9C1C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 20:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647980227;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TOgYsOo4w4KFGN1ZTJ896kL5X3wr6ShHZy9LEBHobQI=;
	b=U5oHL7ZasglzhVWpbXWFy32EY8RiA099k0djpjV1BdW2CvSX9P6VyO+QirrSBWNao/cI2F
	zWDF7Ik2PnzNK/FlHrf6U9X+tvjd+hUquf1KpqK1K+gpzHQOMLb9QyaeTRUzhZ/XviqdbG
	VEY5CPi40KZrXningFF14UveIgmB8+U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-5QVxs5qpOXOI7ZM5rZgOfQ-1; Tue, 22 Mar 2022 16:17:04 -0400
X-MC-Unique: 5QVxs5qpOXOI7ZM5rZgOfQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF9C092FBFE;
	Tue, 22 Mar 2022 20:16:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47C8257B281;
	Tue, 22 Mar 2022 20:16:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04F811940340;
	Tue, 22 Mar 2022 20:16:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D609B1949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 20:16:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93E9D4AE6E4; Tue, 22 Mar 2022 20:16:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F645401E99
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 20:16:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6C02181359F
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 20:16:14 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-m6rVo90CNhe_7x9RBwL-7g-1; Tue, 22 Mar 2022 16:16:13 -0400
X-MC-Unique: m6rVo90CNhe_7x9RBwL-7g-1
Received: by mail-qt1-f199.google.com with SMTP id
 g22-20020ac870d6000000b002e20a1508ecso5802223qtp.19
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 13:16:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SMIp8B08FhcwythTG96yiDlyPxpSOrWGy+SCbNXTRzE=;
 b=Df12+i+LD73ju8zb74FgufJ39/s8YVwfD42dMvh/a3NoenHmDaf50prHaiFjHNipGN
 c2R9bfmIkjT9Hgm9W4XZfPNO7IuuV5oH1lAHinmXCIelnxWS8k0RigvF/d1DU4i5HR2c
 AvB0t9o7gp/r6I7KK6UtJMIrxFAZkvae0+ff8xAdPs5i2nHwF/lD3MWLTFctfT/QcxT5
 xw7ekf74GakadYg+LrGfSAQq5iEpI6aJKko4a8/8xZ2F6hgR2VpPVSKbtzd7CH+xYd6q
 ecX60Gbfzq4Pp3kpoPQh3Icm5RCtmmYuzgfOsR5VDzuLEHmzeLalSF/CQagpBZGIZsii
 XUQw==
X-Gm-Message-State: AOAM530N6WbHC40+HVullp2IhVEmQBjdv5FygYpBZkllMA7pJGdqSsy+
 PsTTo5gA2an3ZCXyPzjSYdpXYRyd5ybx4dWZjx/9cdSfK0g47hiyKAX+KQezlLU7w66iGjahQ7d
 JOVzfA/fvrCzQSQ==
X-Received: by 2002:a37:a709:0:b0:67b:2dcc:d5dd with SMTP id
 q9-20020a37a709000000b0067b2dccd5ddmr16435883qke.597.1647980169558; 
 Tue, 22 Mar 2022 13:16:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy4M1xgu67X23+CzQE3qXZ4axFIbR/sutU3hs8It5LtcZhX/53Fs9XBKlHWYcaLv5svtBBsQ==
X-Received: by 2002:a37:a709:0:b0:67b:2dcc:d5dd with SMTP id
 q9-20020a37a709000000b0067b2dccd5ddmr16435868qke.597.1647980169349; 
 Tue, 22 Mar 2022 13:16:09 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 bp31-20020a05622a1b9f00b002e21e80ecd8sm2736443qtb.45.2022.03.22.13.16.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 13:16:08 -0700 (PDT)
Date: Tue, 22 Mar 2022 16:16:07 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Yjouh9C7MaVrTnLh@redhat.com>
References: <20220322194927.42778-1-snitzer@kernel.org>
 <20220322194927.42778-2-snitzer@kernel.org>
 <20220322195414.GA8650@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220322195414.GA8650@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 1/3] block: allow BIOSET_PERCPU_CACHE use
 from bio_alloc_clone
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 22 2022 at  3:54P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Mar 22, 2022 at 03:49:25PM -0400, Mike Snitzer wrote:
> > -	bio = bio_alloc_bioset(bdev, 0, bio_src->bi_opf, gfp, bs);
> > +	if (bs->cache && bio_src->bi_opf & REQ_POLLED)
> > +		bio = bio_alloc_percpu_cache(bdev, 0, bio_src->bi_opf, gfp, bs);
> > +	else
> 
> I don't think we can just unconditionally do this based on REQ_POLLED.
> We'd either need a flag for bio_alloc_bioset or (probably better)
> a separate interface.
> 

I did initially think it worthwhile to push the use of
bio_alloc_percpu_cache() down to bio_alloc_bioset() rather than
bio_alloc_clone() -- but I started slower with more targetted change
for DM's needs.

And yeah, since there isn't a REQ_ flag equivalent for IOCB_ALLOC_CACHE
(other than just allowing all REQ_POLLED access) there isn't a
meaningful way to limit access to the bioset's percpu cache.

Curious: how do bio_alloc_kiocb() callers know when it appropriate to
set IOCB_ALLOC_CACHE or not?  Seems io_uring is only one and it
unilaterally does:
kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;

So like IOCB_HIPRI maps to REQ_POLL, should IOCB_ALLOC_CACHE map to
REQ_ALLOC_CACHE? Or better name?

Open to further suggestions on which way to go with these details.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

