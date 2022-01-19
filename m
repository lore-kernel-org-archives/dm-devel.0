Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DBC3C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jan 2022 08:17:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-RPLvR8voM5aQABOnivCirQ-1; Thu, 20 Jan 2022 03:16:58 -0500
X-MC-Unique: RPLvR8voM5aQABOnivCirQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA9C4814406;
	Thu, 20 Jan 2022 08:16:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8E287D718;
	Thu, 20 Jan 2022 08:16:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 98AC8180065D;
	Thu, 20 Jan 2022 08:16:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20J0mQTb008310 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 19:48:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9ED38C15E73; Wed, 19 Jan 2022 00:48:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AE9FC15E71
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 00:48:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7652985A5B5
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 00:48:26 +0000 (UTC)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com
	[209.85.208.49]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-330-Q0zOIuuSMqi-Hug5FZnwOw-1; Tue, 18 Jan 2022 19:48:24 -0500
X-MC-Unique: Q0zOIuuSMqi-Hug5FZnwOw-1
Received: by mail-ed1-f49.google.com with SMTP id c24so815183edy.4
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 16:48:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=PAK4mW8hYoqrJ21zjz/l0DR61Bn1u+hWmA/ygwKpR6A=;
	b=NzOFjEdVUpbzRESTxYvnoR8rkrBMeLF3PgzwodhlNXmwypu2FCXlDQwx0UHzlfsMrG
	bBHRcX63hgizb1DaHNiOxDvOTwfRUzKnuhpMwMDvUCsO4fVM2tDJ/rxSUgZZYTd9Zp3P
	9VSM1ObxRPoKbJO1RhO58mi7HBXVRkEtT/KmEJkLsVGpaKfJDcKID+ISn4CAt3hr1haK
	4VVmUCautqbNoWQn0Oa6BcoON74f8sioSf1oXioHDGF8LMnbelIXvXiW4vjrY9iP1CH7
	FDljDLQMwsILlEqlByvbaw0TDlZ5IqbLnqA2jg5fytSs6LRt8aVnLwo3K6H5PBTezLJo
	P7dQ==
X-Gm-Message-State: AOAM531hDRo5YmVaRo9HKuwcPgxsIKePi8dKn/f+HPJzlKjELNZUX538
	holvZgUiyyxJYafCKjyvByKOlnfgdRRw4NW3xQpFHw==
X-Google-Smtp-Source: ABdhPJwQjghAznMK411R8b9/ZDbYdnQBr2j4+YDtGVUTaFkxr/2dQA+aeV/q08/V3OevBldMGzoi+KYmS0TVluHMgAk=
X-Received: by 2002:a17:906:1f15:: with SMTP id
	w21mr18364838ejj.205.1642553303188; 
	Tue, 18 Jan 2022 16:48:23 -0800 (PST)
MIME-Version: 1.0
References: <20220118071952.1243143-1-hch@lst.de>
	<20220118071952.1243143-11-hch@lst.de>
	<CAMGffEmFZB1PPE09bfxQjKw-tJhdprEkF-OWrVF4Kjsf1OwQ_g@mail.gmail.com>
In-Reply-To: <CAMGffEmFZB1PPE09bfxQjKw-tJhdprEkF-OWrVF4Kjsf1OwQ_g@mail.gmail.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 19 Jan 2022 01:48:12 +0100
Message-ID: <CAMGffEnZT_uU-CdACiW7cPQ_fRtUasMOHzr0VUrG4QmkJHF76g@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 20 Jan 2022 03:16:10 -0500
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal" <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH 10/19] rnbd-srv: simplify bio mapping in
	process_rdma
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 19, 2022 at 1:20 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>
> Hi Christoph,
>
> Thanks for the patch.
>
> On Tue, Jan 18, 2022 at 8:20 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > The memory mapped in process_rdma is contiguous, so there is no need
> > to loop over bio_add_page.  Remove rnbd_bio_map_kern and just open code
> > the bio allocation and mapping in the caller.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/block/rnbd/rnbd-srv-dev.c | 57 -------------------------------
> >  drivers/block/rnbd/rnbd-srv-dev.h |  5 ---
> >  drivers/block/rnbd/rnbd-srv.c     | 20 ++++++++---
> >  3 files changed, 15 insertions(+), 67 deletions(-)
> >
> > diff --git a/drivers/block/rnbd/rnbd-srv-dev.c b/drivers/block/rnbd/rnbd-srv-dev.c
> > index b241a099aeae2..98d3e591a0885 100644
> > --- a/drivers/block/rnbd/rnbd-srv-dev.c
> > +++ b/drivers/block/rnbd/rnbd-srv-dev.c
> > @@ -44,60 +44,3 @@ void rnbd_dev_close(struct rnbd_dev *dev)
> >         blkdev_put(dev->bdev, dev->blk_open_flags);
> >         kfree(dev);
> >  }
> > -
> > -void rnbd_dev_bi_end_io(struct bio *bio)
> > -{
> > -       struct rnbd_dev_blk_io *io = bio->bi_private;
> > -
> > -       rnbd_endio(io->priv, blk_status_to_errno(bio->bi_status));
> > -       bio_put(bio);
> > -}
> > -
> > -/**
> > - *     rnbd_bio_map_kern       -       map kernel address into bio
> > - *     @data: pointer to buffer to map
> > - *     @bs: bio_set to use.
> > - *     @len: length in bytes
> > - *     @gfp_mask: allocation flags for bio allocation
> > - *
> > - *     Map the kernel address into a bio suitable for io to a block
> > - *     device. Returns an error pointer in case of error.
> > - */
> > -struct bio *rnbd_bio_map_kern(void *data, struct bio_set *bs,
> > -                             unsigned int len, gfp_t gfp_mask)
> > -{
> > -       unsigned long kaddr = (unsigned long)data;
> > -       unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > -       unsigned long start = kaddr >> PAGE_SHIFT;
> > -       const int nr_pages = end - start;
> > -       int offset, i;
> > -       struct bio *bio;
> > -
> > -       bio = bio_alloc_bioset(gfp_mask, nr_pages, bs);
> > -       if (!bio)
> > -               return ERR_PTR(-ENOMEM);
> > -
> > -       offset = offset_in_page(kaddr);
> > -       for (i = 0; i < nr_pages; i++) {
> > -               unsigned int bytes = PAGE_SIZE - offset;
> > -
> > -               if (len <= 0)
> > -                       break;
> > -
> > -               if (bytes > len)
> > -                       bytes = len;
> > -
> > -               if (bio_add_page(bio, virt_to_page(data), bytes,
> > -                                   offset) < bytes) {
> > -                       /* we don't support partial mappings */
> > -                       bio_put(bio);
> > -                       return ERR_PTR(-EINVAL);
> > -               }
> > -
> > -               data += bytes;
> > -               len -= bytes;
> > -               offset = 0;
> > -       }
> > -
> > -       return bio;
> > -}
> > diff --git a/drivers/block/rnbd/rnbd-srv-dev.h b/drivers/block/rnbd/rnbd-srv-dev.h
> > index 0eb23850afb95..1a14ece0be726 100644
> > --- a/drivers/block/rnbd/rnbd-srv-dev.h
> > +++ b/drivers/block/rnbd/rnbd-srv-dev.h
> > @@ -41,11 +41,6 @@ void rnbd_dev_close(struct rnbd_dev *dev);
> >
> >  void rnbd_endio(void *priv, int error);
> >
> > -void rnbd_dev_bi_end_io(struct bio *bio);
> > -
> > -struct bio *rnbd_bio_map_kern(void *data, struct bio_set *bs,
> > -                             unsigned int len, gfp_t gfp_mask);
> > -
> >  static inline int rnbd_dev_get_max_segs(const struct rnbd_dev *dev)
> >  {
> >         return queue_max_segments(bdev_get_queue(dev->bdev));
> > diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
> > index 1ee808fc600cf..65c670e96075b 100644
> > --- a/drivers/block/rnbd/rnbd-srv.c
> > +++ b/drivers/block/rnbd/rnbd-srv.c
> > @@ -114,6 +114,14 @@ rnbd_get_sess_dev(int dev_id, struct rnbd_srv_session *srv_sess)
> >         return sess_dev;
> >  }
> >
> > +static void rnbd_dev_bi_end_io(struct bio *bio)
> > +{
> > +       struct rnbd_dev_blk_io *io = bio->bi_private;
> > +
> > +       rnbd_endio(io->priv, blk_status_to_errno(bio->bi_status));
> > +       bio_put(bio);
> > +}
> > +
> >  static int process_rdma(struct rnbd_srv_session *srv_sess,
> >                         struct rtrs_srv_op *id, void *data, u32 datalen,
> >                         const void *usr, size_t usrlen)
> > @@ -144,11 +152,11 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
> >         priv->sess_dev = sess_dev;
> >         priv->id = id;
> >
> > -       /* Generate bio with pages pointing to the rdma buffer */
> > -       bio = rnbd_bio_map_kern(data, sess_dev->rnbd_dev->ibd_bio_set, datalen, GFP_KERNEL);
> > -       if (IS_ERR(bio)) {
> > -               err = PTR_ERR(bio);
> > -               rnbd_srv_err(sess_dev, "Failed to generate bio, err: %d\n", err);
> > +       bio = bio_alloc_bioset(GFP_KERNEL, 1, sess_dev->rnbd_dev->ibd_bio_set);
> > +       if (bio_add_page(bio, virt_to_page(data), datalen,
> > +                       offset_in_page(data))) {
> this changes lead to IO error all the time, because bio_add_page return len.
> We need  if (bio_add_page(bio, virt_to_page(data), datalen,
>                      offset_in_page(data)) < datalen)
>
> Thanks!
> > +               rnbd_srv_err(sess_dev, "Failed to map data to bio\n");
> > +               err = -EINVAL;
> >                 goto sess_dev_put;
> >         }
> >
> > @@ -170,6 +178,8 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
> >
> >         return 0;
> >
> > +bio_put:
> > +       bio_put(bio);
and bio_put is not used, should move bio_put(bio); below, no need for
bio_put: label.
> >  sess_dev_put:
> >         rnbd_put_sess_dev(sess_dev);
> >  err:
> > --
> > 2.30.2
> >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

