Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D20C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:35:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146--a146_WnOJaQWzWDP07EJg-1; Thu, 24 Mar 2022 11:35:06 -0400
X-MC-Unique: -a146_WnOJaQWzWDP07EJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B08E110665AE;
	Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94F7DC26EA0;
	Thu, 24 Mar 2022 15:34:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E1421940364;
	Thu, 24 Mar 2022 15:34:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F15871940347
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 09:29:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A7C640D2824; Wed, 23 Mar 2022 09:29:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 864EC40D2823
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 09:29:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66884101AA42
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 09:29:40 +0000 (UTC)
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com
 [209.85.128.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-w3tDjGKAMLeyBNf7gYK7GQ-1; Wed, 23 Mar 2022 05:29:35 -0400
X-MC-Unique: w3tDjGKAMLeyBNf7gYK7GQ-1
Received: by mail-yw1-f172.google.com with SMTP id
 00721157ae682-2e5e31c34bfso9897337b3.10; 
 Wed, 23 Mar 2022 02:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RTdntLwWP7UcoqdxIbtO2gBEwkCYFZ/lgUjrNqmrzxY=;
 b=DNV0ooTA7N0R26y3vqIreGlEh1owXCSWe0Cf03ANIV11D07IRJD9C4ScnezsZVt9Ch
 NHHu6AzKRoZYGbgIOgiDrRCjo6WtWDXCZz4uV7ZzuZ8mrdy22rRBwMoxCVuFOOpZAX5H
 bQC7jnhUGBuq/D4+4BtnSgOLrqlJFW2KR7baj/QTac+s34ppqZhAeQQ0eaWWQ9mfU767
 ynqiYJv4W27jwviqBDWns4KqFCV4lNLMZoJauWnwlQ2PngKOvcvV1DVOz7PWqL9X4j6E
 NRKdY1whuReX4WDI/GzhdAajgcolYdV2NPXqXuOlN7K8obRUyftlwVrAYpiC1QEyr52s
 +WSw==
X-Gm-Message-State: AOAM532pQVRLimnu7T0AvO8dZVvWov+oMnBTJjuVE5mbCAzKdGnfbfHW
 LML4F1UAvL4ieqWDH4pm3NBy74uR1yx63BoZKeE=
X-Google-Smtp-Source: ABdhPJxsStnlEm2/XrSzPGOBMOTw5PlnKDFjWTj/c9kKouVbhUo8itraPrOCZBSFmdgor+QYZSqQ1SYIOcVDz/aGNlE=
X-Received: by 2002:a0d:c284:0:b0:2dc:37ec:f02c with SMTP id
 e126-20020a0dc284000000b002dc37ecf02cmr33701891ywd.503.1648027774854; Wed, 23
 Mar 2022 02:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220124091107.642561-1-hch@lst.de>
 <20220124091107.642561-2-hch@lst.de>
 <20220322211915.GA2413063@roeck-us.net>
 <CAKFNMonRd5QQMzLoH3T=M=C=2Q_j9d86EYzZeY4DU2HQAE3E8w@mail.gmail.com>
 <20220323064248.GA24874@lst.de>
In-Reply-To: <20220323064248.GA24874@lst.de>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 23 Mar 2022 18:29:23 +0900
Message-ID: <CAKFNMonANUN7_99oVBOq=iCJpt6jQs3qhu1ez5SwMm2g7sZUyw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Thu, 24 Mar 2022 15:34:43 +0000
Subject: Re: [dm-devel] [PATCH 01/19] fs: remove mpage_alloc
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
Cc: Jens Axboe <axboe@kernel.dk>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 linux-nfs@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>,
 Mike Snitzer <snitzer@redhat.com>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.co>,
 device-mapper development <dm-devel@redhat.com>,
 "Md . Haris Iqbal" <haris.iqbal@ionos.com>, linux-fsdevel@vger.kernel.org,
 xen-devel@lists.xenproject.org, Lars Ellenberg <lars.ellenberg@linbit.com>,
 ntfs3@lists.linux.dev, Jack Wang <jinpu.wang@ionos.com>,
 Andrew Morton <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 23, 2022 at 3:42 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Mar 23, 2022 at 06:38:22AM +0900, Ryusuke Konishi wrote:
> > This looks because the mask of GFP_KERNEL is removed along with
> > the removal of mpage_alloc().
> >
>
> > The default value of the gfp flag is set to GFP_HIGHUSER_MOVABLE by
> > inode_init_always().
> > So, __GFP_HIGHMEM hits the gfp warning at bio_alloc() that
> > do_mpage_readpage() calls.
>
> Yeah.  Let's try this to match the iomap code:
>
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 9ed1e58e8d70b..d465883edf719 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -148,13 +148,11 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
>         int op = REQ_OP_READ;
>         unsigned nblocks;
>         unsigned relative_block;
> -       gfp_t gfp;
> +       gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
>
>         if (args->is_readahead) {
>                 op |= REQ_RAHEAD;
> -               gfp = readahead_gfp_mask(page->mapping);
> -       } else {
> -               gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
> +               gfp |= __GFP_NORETRY | __GFP_NOWARN;
>         }
>
>         if (page_has_buffers(page))

I did not test for iomap, but this patch has fixed the same regression on the
latest mainline at least for ext2, exfat, vfat and nilfs2.  Thanks!

Ryusuke Konishi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

