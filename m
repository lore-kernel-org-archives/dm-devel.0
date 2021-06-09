Return-Path: <SRS0=zjfM=LD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158D0C47095
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 09:41:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C6E660FEB
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 09:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C6E660FEB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-EF9hKraOMKSDu6JWXwBRbw-1; Wed, 09 Jun 2021 05:41:42 -0400
X-MC-Unique: EF9hKraOMKSDu6JWXwBRbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F380780ED96;
	Wed,  9 Jun 2021 09:41:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ADB7A1001281;
	Wed,  9 Jun 2021 09:41:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6BCDF1809CAE;
	Wed,  9 Jun 2021 09:41:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1599bqNk030422 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Jun 2021 05:37:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7687821CAC7C; Wed,  9 Jun 2021 09:37:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7169B21CAC80
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 09:37:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D7CE1825064
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 09:37:49 +0000 (UTC)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
	[209.85.166.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-381-liXvqAihNRSn9xNWGnNJow-1; Wed, 09 Jun 2021 05:37:47 -0400
X-MC-Unique: liXvqAihNRSn9xNWGnNJow-1
Received: by mail-il1-f175.google.com with SMTP id h16so11916280ila.6;
	Wed, 09 Jun 2021 02:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=11paM/1lp22CavDEEN3A/olA+tOS+m0UgIjuNNPMc5c=;
	b=m0adVq3vMz3CNOU2t7nW5VOId7u81KJyL3Q8y2vmNh6h1yLt3fm0vs17RzS0EiWTwm
	DJZ6Njgf0inBRBpq1lXL2F3HpLV8H4jY2yeCfClZ4nkJgbZz22WzBstecHlzA1dxQHUT
	KXk1KL0qOJREaw5nc7c6a63n+kCXgN29P3kYANSIQ63BhLzJI+HBaI5/93i6aJVrU9P1
	u5hRJ+iFsagy1E+Sxp1sChL+PmtE2caDYXWLH210SSHWKqiheopsU0mRJMZroa6eYSse
	ky7a+G5vKUuQvVfvbhZV6Fn0NLTToqUxYOv4JsOVwk2Birx823jGvYD3BvHavjPjDb/B
	expA==
X-Gm-Message-State: AOAM532SVr21gUoPiY6a42Uu5Yuj6ncuJC/h27RJ2qd6EF6XXtZMdeVW
	hOFoaY+rng9Lmlj/iea8MsS9sKCMik991NOE8zUIT+YCOQa5s4G0
X-Google-Smtp-Source: ABdhPJy5AROZdbsU+O1Vh/bwrnsq7wRpZEor176YD0iLaHDJhsh5Ad6i076nqZiL2In6oQ6aCiJFsx/mBME7wo4cSUc=
X-Received: by 2002:a05:6638:267:: with SMTP id
	x7mr7028650jaq.51.1623231466755; 
	Wed, 09 Jun 2021 02:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-8-hch@lst.de>
In-Reply-To: <20210608160603.1535935-8-hch@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 9 Jun 2021 11:37:45 +0200
Message-ID: <CAOi1vP-zSAnx5z7EbPNVLoCHWdK5iGjXU7KKrRL8YZF1QfMf3A@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com,
	Ceph Development <ceph-devel@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 07/16] rbd: use memzero_bvec
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 8, 2021 at 6:06 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Use memzero_bvec instead of reimplementing it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rbd.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index bbb88eb009e0..eb243fc4d108 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1219,24 +1219,13 @@ static void rbd_dev_mapping_clear(struct rbd_device *rbd_dev)
>         rbd_dev->mapping.size = 0;
>  }
>
> -static void zero_bvec(struct bio_vec *bv)
> -{
> -       void *buf;
> -       unsigned long flags;
> -
> -       buf = bvec_kmap_irq(bv, &flags);
> -       memset(buf, 0, bv->bv_len);
> -       flush_dcache_page(bv->bv_page);
> -       bvec_kunmap_irq(buf, &flags);
> -}
> -
>  static void zero_bios(struct ceph_bio_iter *bio_pos, u32 off, u32 bytes)
>  {
>         struct ceph_bio_iter it = *bio_pos;
>
>         ceph_bio_iter_advance(&it, off);
>         ceph_bio_iter_advance_step(&it, bytes, ({
> -               zero_bvec(&bv);
> +               memzero_bvec(&bv);
>         }));
>  }
>
> @@ -1246,7 +1235,7 @@ static void zero_bvecs(struct ceph_bvec_iter *bvec_pos, u32 off, u32 bytes)
>
>         ceph_bvec_iter_advance(&it, off);
>         ceph_bvec_iter_advance_step(&it, bytes, ({
> -               zero_bvec(&bv);
> +               memzero_bvec(&bv);
>         }));
>  }
>

Ira already brought up the fact that this conversion drops
flush_dcache_page() calls throughout.  Other than that:

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

