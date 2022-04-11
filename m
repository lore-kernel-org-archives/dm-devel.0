Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BF3C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 17:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649697371;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PLzFU7gw9bPKrs/w9kFw80pthsLEUHaMGpYpjdGZiog=;
	b=LjkiW3DifVKG0AiO8g3g7wAxxFCvsncgFIVbzKKZVqbjnQPJuzJANa91tkv2gWOfYy8q0u
	ba4IQRdGuQtGao8PE+hT7HEwXV7TySBpxmlRF3mI2fu5Q/P7FTSutok8Ord8F/UROo0TTI
	j1XercbcEdKa7inswvOV9Ol+9bM49i0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-3JRqwllwNi2nzQm0HHNWYg-1; Mon, 11 Apr 2022 13:16:09 -0400
X-MC-Unique: 3JRqwllwNi2nzQm0HHNWYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88F4B1066566;
	Mon, 11 Apr 2022 17:16:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A0BAC15D76;
	Mon, 11 Apr 2022 17:16:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D2D5A1947BBD;
	Mon, 11 Apr 2022 17:16:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B23E919466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 17:16:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92887141DC5E; Mon, 11 Apr 2022 17:16:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8ED3314171FF
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 17:16:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7364C280B09B
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 17:16:05 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-XBu5yXMBP9q-x_nCkBRcgg-1; Mon, 11 Apr 2022 13:16:03 -0400
X-MC-Unique: XBu5yXMBP9q-x_nCkBRcgg-1
Received: by mail-qv1-f70.google.com with SMTP id
 kd20-20020a056214401400b00443c252b315so16169658qvb.23
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 10:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DrLtcPmwGcrIqCcNfbaH7A6AhGFi5Av5dx06PW0cZzY=;
 b=gN3bLdjOpkiRS/4qAbx2NwdxYYu8BmFF8f2xxS4Z26n+fb0i4KtL7K2nxSFOTwV1YJ
 f3CeRw56tLcgPpNdn0EUAjZ5H6de2mMbXuPdGipIDXuWV5YNzyAK+f/irxurrrWkG6Vr
 k/EwD7HslpBJoTSIA8o5SaPqJeGsCwi1HE1DuGv4m7quoNFVvZ3x6oGBWbzaNa6Z4DuK
 2swv1fm/CeI+op36ZERXOC3lWLy9otywN4qU60ESrYcD83i/uI7MTRz5O4cnkIrNtHY5
 RWfn9dwyC5khuYG2TXl17eS/j96zm3r6frLk6Bw5zI5Dxow9QuZMvmng3OcdF6QlnfVs
 t2yg==
X-Gm-Message-State: AOAM532ezzuyOE5QwGg5h9omZ0SV8CiHTIcv/71LDyyWbyfuspa1uOlW
 ewY2Vnw5OtlZbBrY8m7c3zsXc5oXd5tdZghAFPvWkzgO83VoxkcHEu0qn99kZJKs7Ie209FTvZT
 2zf6n6WlvyT3gTw==
X-Received: by 2002:ac8:7d88:0:b0:2e1:cd8d:3dda with SMTP id
 c8-20020ac87d88000000b002e1cd8d3ddamr276892qtd.351.1649697362649; 
 Mon, 11 Apr 2022 10:16:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyx9YRN19sGQAWmu6437r4Zhh/5vkMYh+H+zxQ4tgPbWv84LGnK+bGBDSJIkc/rmX2AFrWkHw==
X-Received: by 2002:ac8:7d88:0:b0:2e1:cd8d:3dda with SMTP id
 c8-20020ac87d88000000b002e1cd8d3ddamr276879qtd.351.1649697362384; 
 Mon, 11 Apr 2022 10:16:02 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 br35-20020a05620a462300b0067e890073cbsm21822458qkb.6.2022.04.11.10.16.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 11 Apr 2022 10:16:02 -0700 (PDT)
Date: Mon, 11 Apr 2022 13:16:01 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <YlRiUVFK+a0DwQhu@redhat.com>
References: <YkSK6mU1fja2OykG@redhat.com> <YkRM7Iyp8m6A1BCl@fedora>
 <YkUwmyrIqnRGIOHm@infradead.org> <YkVBjUy9GeSMbh5Q@fedora>
 <YkVxLN9p0t6DI5ie@infradead.org> <YlBX+ytxxeSj2neQ@redhat.com>
 <YlEWfc39+H+esrQm@infradead.org> <YlReKjjWhvTZjfg/@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YlReKjjWhvTZjfg/@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] can we reduce bio_set_dev overhead due to
 bio_associate_blkg?
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, tj@kernel.org,
 Dennis Zhou <dennis@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 11 2022 at 12:58P -0400,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Sat, Apr 09 2022 at  1:15P -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Fri, Apr 08, 2022 at 11:42:51AM -0400, Mike Snitzer wrote:
> > > I think we can achieve the goal of efficient cloning/remapping for
> > > both usecases simply by splitting out the bio_set_dev() and leaving it
> > > to the caller to pick which interface to use (e.g. clone vs
> > > clone_and_remap).
> > 
> > You can just pass a NULL bdev to bio_alloc_clone/bio_init_clone.
> > I've been hoping to get rid of that, but if we have a clear use case
> > it will have to stay.
> 
> DM core is just using bio_alloc_clone. And bio_alloc_bioset() allows
> bdev to be NULL -- so you're likely referring to that (which will skip
> bio_init's bio_associate_blkg).
...

> diff --git a/block/bio.c b/block/bio.c
> index 7892f1108ca6..0340acc283a0 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -772,14 +772,16 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
> 	bio_set_flag(bio, BIO_CLONED);
> 	if (bio_flagged(bio_src, BIO_THROTTLED))
> 		bio_set_flag(bio, BIO_THROTTLED);
> -	if (bio->bi_bdev == bio_src->bi_bdev &&
> -	    bio_flagged(bio_src, BIO_REMAPPED))
> -		bio_set_flag(bio, BIO_REMAPPED);
> 	bio->bi_ioprio = bio_src->bi_ioprio;
> 	bio->bi_iter = bio_src->bi_iter;
> 
> -	bio_clone_blkg_association(bio, bio_src);
> -	blkcg_bio_issue_init(bio);
> +	if (bio->bi_bdev == bio_src->bi_bdev) {
> +		if (bio_flagged(bio_src, BIO_REMAPPED))
> +			bio_set_flag(bio, BIO_REMAPPED);
> +
> +		bio_clone_blkg_association(bio, bio_src);
> +		blkcg_bio_issue_init(bio);
> +	}
> 
> 	if (bio_crypt_clone(bio, bio_src, gfp) < 0)
> 		return -ENOMEM;
> 
> Think this will fix some of the performance penalty of redundant blkcg
> initialization that I reported (though like was also discussed: more
> work likely needed to further optimize bio_associate_blkg).

Looking closer at the case where bio_{alloc,init}_clone are passed a
bdev, bio_init() will call bio_associate_blkg() so the __bio_clone()
work to do anything with blkbg isn't needed at all. So this patch is
best:

diff --git a/block/bio.c b/block/bio.c
index 7892f1108ca6..6980f1b4b0f4 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -778,9 +778,6 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
	bio->bi_ioprio = bio_src->bi_ioprio;
	bio->bi_iter = bio_src->bi_iter;

-	bio_clone_blkg_association(bio, bio_src);
-	blkcg_bio_issue_init(bio);
-
	if (bio_crypt_clone(bio, bio_src, gfp) < 0)
		return -ENOMEM;
	if (bio_integrity(bio_src) &&

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

