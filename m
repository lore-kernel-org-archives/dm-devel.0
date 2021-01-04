Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35D8C43381
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5798A2068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5798A2068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-3EjACD8ZMH2M1u4sO-z31w-1; Mon, 04 Jan 2021 14:04:51 -0500
X-MC-Unique: 3EjACD8ZMH2M1u4sO-z31w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09B74107ACFE;
	Mon,  4 Jan 2021 19:04:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E01796F923;
	Mon,  4 Jan 2021 19:04:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B5C451809CA3;
	Mon,  4 Jan 2021 19:04:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104Ch0u0013174 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 07:43:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9A91D9E94; Mon,  4 Jan 2021 12:43:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90CEF10CE7
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 12:42:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1490C811E85
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 12:42:58 +0000 (UTC)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
	[209.85.218.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-277-TB0vzUysNcygN1KPPZGsUA-1; Mon, 04 Jan 2021 07:42:52 -0500
X-MC-Unique: TB0vzUysNcygN1KPPZGsUA-1
Received: by mail-ej1-f53.google.com with SMTP id w1so36550181ejf.11;
	Mon, 04 Jan 2021 04:42:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=rZ4LGlK8t6B2Ly3eEurbHpHQoNf2RZlRTogtRk6wi6I=;
	b=sTsYlrQwBJgRm4YZUTbDmuDlOAFmuZ7h7POGurcuaTvGRizSnlTprxjZtI+s9jieAY
	IeuWQyA+XhRy9kEn4NQabgbtLwxV/48L+vwRkZZynzPWqLvz0usNqt0riTLpwB1hEeuf
	WSRwvMclibg9K4lamEi/cIlgE+SQbG2fvBS93l/8LVQTvHhe+kpNlqbEJzIG2U08gJBP
	ExFGx/1KszubGLuEt+cA2vNRInQ8qVfl0TLXrRoSI/PlsPhNwh4OL+Jf0uCTViSW/s5B
	/HEf4ARfYDZbY0t2bqvnxcUpZbcKW95i76MNV6jhPYuRt8MiNf7ExUtaQyuzVvKv64aI
	gcBA==
X-Gm-Message-State: AOAM5309cgKaXuPlF6BsKUYzi1jGSMzkqVTcLg+djaDFEokuXtUNdDZQ
	IGv5GhKXoMP/vMpf/iU9sdyL/WUIkZehMiwXhlo=
X-Google-Smtp-Source: ABdhPJxwYB1Zb9l3tnKL6RKFyWxN5t6NeOfBATjkNz0+iOKlwVm8wlAvD0ezqYE3Ujva2bM13wJtSYbmW5Co7o5A/i4=
X-Received: by 2002:a17:906:68d1:: with SMTP id
	y17mr66905761ejr.447.1609764171043; 
	Mon, 04 Jan 2021 04:42:51 -0800 (PST)
MIME-Version: 1.0
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
	<CGME20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7@epcas5p2.samsung.com>
	<20210104104159.74236-2-selvakuma.s1@samsung.com>
	<BL0PR04MB6514554D569AC302850BA1DDE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
In-Reply-To: <BL0PR04MB6514554D569AC302850BA1DDE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
From: Selva Jove <selvajove@gmail.com>
Date: Mon, 4 Jan 2021 18:12:39 +0530
Message-ID: <CAHqX9vbuq=N0LwH25x6fHajy8Q65dyKyKJhJOksKYW1U3YGHZw@mail.gmail.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"hch@lst.de" <hch@lst.de>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v4 1/3] block: export bio_map_kern()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks Damien, Will update that.

On Mon, Jan 4, 2021 at 5:45 PM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2021/01/04 19:48, SelvaKumar S wrote:
> > Export bio_map_kern() so that copy offload emulation can use
> > it to add vmalloced memory to bio.
> >
> > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > ---
> >  block/blk-map.c        | 3 ++-
> >  include/linux/blkdev.h | 2 ++
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/block/blk-map.c b/block/blk-map.c
> > index 21630dccac62..50d61475bb68 100644
> > --- a/block/blk-map.c
> > +++ b/block/blk-map.c
> > @@ -378,7 +378,7 @@ static void bio_map_kern_endio(struct bio *bio)
> >   *   Map the kernel address into a bio suitable for io to a block
> >   *   device. Returns an error pointer in case of error.
> >   */
> > -static struct bio *bio_map_kern(struct request_queue *q, void *data,
> > +struct bio *bio_map_kern(struct request_queue *q, void *data,
> >               unsigned int len, gfp_t gfp_mask)
> >  {
> >       unsigned long kaddr = (unsigned long)data;
> > @@ -428,6 +428,7 @@ static struct bio *bio_map_kern(struct request_queue *q, void *data,
> >       bio->bi_end_io = bio_map_kern_endio;
> >       return bio;
> >  }
> > +EXPORT_SYMBOL(bio_map_kern);
>
> Simple copy support is a block layer code, so you I do not think you need this.
> You only need to remove the static declaration of the function.
>
> >
> >  static void bio_copy_kern_endio(struct bio *bio)
> >  {
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 070de09425ad..81f9e7bec16c 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -936,6 +936,8 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
> >                          struct rq_map_data *, void __user *, unsigned long,
> >                          gfp_t);
> >  extern int blk_rq_unmap_user(struct bio *);
> > +extern struct bio *bio_map_kern(struct request_queue *q, void *data,
> > +                             unsigned int len, gfp_t gfp_mask);
> >  extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
> >  extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
> >                              struct rq_map_data *, const struct iov_iter *,
> >
>
>
> --
> Damien Le Moal
> Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

