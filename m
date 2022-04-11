Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB691C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 16:58:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-llL7yqZyM6-q7jbFh6PcKQ-1; Mon, 11 Apr 2022 12:58:27 -0400
X-MC-Unique: llL7yqZyM6-q7jbFh6PcKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9426F85A5A8;
	Mon, 11 Apr 2022 16:58:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC5001121314;
	Mon, 11 Apr 2022 16:58:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C51351947BBC;
	Mon, 11 Apr 2022 16:58:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D464A19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 16:58:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A69414029A6; Mon, 11 Apr 2022 16:58:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2B2D4029A3
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 16:58:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80F1E185A7BA
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 16:58:22 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-L6pn_frFPzSlsSD-aTLdCw-1; Mon, 11 Apr 2022 12:58:20 -0400
X-MC-Unique: L6pn_frFPzSlsSD-aTLdCw-1
Received: by mail-qk1-f169.google.com with SMTP id j6so11145514qkp.9
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 09:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Q9NaM/bqnDmwmZW9IjiKDhdbhCbXASVz0XNirNdhkOw=;
 b=YQm1Zev7st1dYj4TzBgG86PmXuy1RXTrihUg5rBq0HdxqYNOeLCL/GO+jS+PvCQI2G
 TbIdASg0iln0o/MSE5cJtNhQqyy00EmfKM5njtdxfk4fB4ft4mob6FuwgYXq19kvp/rF
 ROBAkxp0Ju4M7JLSB6u8esEXgsEOQrGJgNgp7YnWkcT6CaFiNfILp4p2CeINKIZJmqIF
 9carX+u2O16jUqp06iCYVqjtFanswi6WQz08TRyxykyJGvNb0RTVUOoKwWrl//JAhKs1
 hk7WZTzy4deq8Pkc0Jrelq0PpkXzQ8jsjHX2fzcugQ5aaKsSPY+tIKDMD20zNxhZbJjj
 r5wg==
X-Gm-Message-State: AOAM531TD7bG2Vpg46cadFfAFDRJ2/G/WeAzJuBoD7D4w+5SXWC2vHn2
 G7xgQeuc95prqIpzULijS8WB4gg=
X-Google-Smtp-Source: ABdhPJzneUy68CPhWIxGkvWUcDlTbElnOZi5WfODKQ97gn0Po+Vl0ctS1z0DBoq/zxAjz93pxGyBcQ==
X-Received: by 2002:a05:620a:404f:b0:69a:5ca1:32fc with SMTP id
 i15-20020a05620a404f00b0069a5ca132fcmr230560qko.676.1649696300198; 
 Mon, 11 Apr 2022 09:58:20 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 h186-20020a376cc3000000b00699c789a757sm14602815qkc.132.2022.04.11.09.58.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 11 Apr 2022 09:58:19 -0700 (PDT)
Date: Mon, 11 Apr 2022 12:58:18 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YlReKjjWhvTZjfg/@redhat.com>
References: <YkSK6mU1fja2OykG@redhat.com> <YkRM7Iyp8m6A1BCl@fedora>
 <YkUwmyrIqnRGIOHm@infradead.org> <YkVBjUy9GeSMbh5Q@fedora>
 <YkVxLN9p0t6DI5ie@infradead.org> <YlBX+ytxxeSj2neQ@redhat.com>
 <YlEWfc39+H+esrQm@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YlEWfc39+H+esrQm@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
Cc: tj@kernel.org, Dennis Zhou <dennis@kernel.org>, dm-devel@redhat.com,
 linux-block@vger.kernel.org, axboe@kernel.dk
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Apr 09 2022 at  1:15P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Apr 08, 2022 at 11:42:51AM -0400, Mike Snitzer wrote:
> > I think we can achieve the goal of efficient cloning/remapping for
> > both usecases simply by splitting out the bio_set_dev() and leaving it
> > to the caller to pick which interface to use (e.g. clone vs
> > clone_and_remap).
> 
> You can just pass a NULL bdev to bio_alloc_clone/bio_init_clone.
> I've been hoping to get rid of that, but if we have a clear use case
> it will have to stay.

DM core is just using bio_alloc_clone. And bio_alloc_bioset() allows
bdev to be NULL -- so you're likely referring to that (which will skip
bio_init's bio_associate_blkg).

Circling back to earlier in this thread, Dennis and you agreed that it
doesn't make sense to have __bio_clone() do blkcg work if the clone
bio will be remapped (via bio_set_dev).  Given that, and the fact that
bio_clone_blkg_association() assumes both bios are from same bdev,
this change makes sense:

diff --git a/block/bio.c b/block/bio.c
index 7892f1108ca6..0340acc283a0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -772,14 +772,16 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
	bio_set_flag(bio, BIO_CLONED);
	if (bio_flagged(bio_src, BIO_THROTTLED))
		bio_set_flag(bio, BIO_THROTTLED);
-	if (bio->bi_bdev == bio_src->bi_bdev &&
-	    bio_flagged(bio_src, BIO_REMAPPED))
-		bio_set_flag(bio, BIO_REMAPPED);
	bio->bi_ioprio = bio_src->bi_ioprio;
	bio->bi_iter = bio_src->bi_iter;

-	bio_clone_blkg_association(bio, bio_src);
-	blkcg_bio_issue_init(bio);
+	if (bio->bi_bdev == bio_src->bi_bdev) {
+		if (bio_flagged(bio_src, BIO_REMAPPED))
+			bio_set_flag(bio, BIO_REMAPPED);
+
+		bio_clone_blkg_association(bio, bio_src);
+		blkcg_bio_issue_init(bio);
+	}

	if (bio_crypt_clone(bio, bio_src, gfp) < 0)
		return -ENOMEM;

Think this will fix some of the performance penalty of redundant blkcg
initialization that I reported (though like was also discussed: more
work likely needed to further optimize bio_associate_blkg).

I'll audit DM targets and test to verify my changes and will post
proper patch(es) once done.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

