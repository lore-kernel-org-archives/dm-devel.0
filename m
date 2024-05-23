Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601CA10A22
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716477788; cv=none; b=U3wIi+AvYKyZgjsT5z47MDC+tV48smdCqoQ0zyloWFtucqwj44hSHJK3znoTB1bkW81piWn8AlF8aDeT7vpXt9LFJdZr4WLltXCyJdm8L6Xata2zuE8bU9UDKqR4bNWARVb8B2OYOz8VIt7uC3BDkiwRk27ymtBeHyYzJu9OEI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716477788; c=relaxed/simple;
	bh=tPUeEnU5cjG3i0yzJnK9h4CPPvHzW2y3ucRopOeOZR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mGMCgF9GHRR2Izx+rv0pxLkx8pWiSwbR6ugeK741jsFyfivZBF7hNeyMBsBOPLIMqYnJ9idc4tvFkaZBm5gZDvqptsqxMDT5U2D8GpMWn8JN2uQlkjvV2m/pynL1qcCGeLoXfUhf0FE66JByK6BkHW8NNiwDOukYczxPrSLs9x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQM/Iw5L; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQM/Iw5L"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4e12478c3f8so764479e0c.3
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 08:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716477786; x=1717082586; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8tCGD+B/90fiwr0wHpk4PrsZCbhBjOEiTIub+soBMc=;
        b=XQM/Iw5Lc9icJycqc/z91DEEZL0XGx8PZlxlaAlTybLHa2YMIDhZn+jujvrEtfebEC
         c8B2GdcvLEZCu3Or3+XqYuCOVuSKUhhXL1ZqI1YztcWFupUTLxTxUEfWWvFL1ozk0A8S
         HfarqqCEf27eAho9dlq0qkQ13CoNyHHekR1sZAp1Meg/LZpLKCmcLM72ZrVW5JfE3NDK
         ofxxs2T+NzzBjR9qHgaUaAH/KFTlRGKLMvi6PTNbJ9LX8ufCz8jhvWEF59MTLFdiXq0K
         g+oaNPQJSpSYKxpAqrU0n3cDKeC0wOTv6kWuY1KixT0fklGFUPOITTXWPK/baFNeK4/L
         MRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716477786; x=1717082586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8tCGD+B/90fiwr0wHpk4PrsZCbhBjOEiTIub+soBMc=;
        b=fjUgO657dVE8SYXkV6j02FDzL3JLqwKxNjQ97Tgjmk5Ne+1n030lgrhzwfA8JRkPzs
         G2Kv+oUMWSjOLmblB4HUkZ7eGAUvOloj+TY2xToSTfHOQINgnsMnIe+rEdHDqQpW+ecs
         AntBi9HmfOrf53pvQkl/xD/coAwjuJ/Pa6GED6/OJNMorfVpP2XKoVz1eZmiUvMINDQu
         1wY1RAgbmsBKTB/nntp2jS9/47jlBq4IxXurUjvpkAz0YpCuLrKQixZLe561fg9YbrFc
         zY5BDgUeP6TTz3zojYibaSsjNUJq/YXrEU9BsJRVuIhYUG6/d1HQ5dtbkUjn383YTlTD
         z6fw==
X-Forwarded-Encrypted: i=1; AJvYcCXCFFQ5QIKvM5aokm716FO35Z9MQ1HfQNnb9jrwn1MFXT+4+8XOEAOyrUEAh8FS7ML64zi7XvLczUeotHp6djShQlDVNve5VN8=
X-Gm-Message-State: AOJu0Yy2Iaww58tHPN6u+TgUo5gqDNWLb3+sun/YIDQVjgRt9Q582Jvt
	/kSISV7i2a3PBPFtq9dyZcmZ8BLXjvdHhW8E3nQqbc+GF2GZeB24C1HXodrw8ef9GvSBAXsDCUy
	whxmCEximT1oSI4Sio1ZfjW6EPQ==
X-Google-Smtp-Source: AGHT+IHf+AmqHylb4UCzV6cCGGq50XriQJFqc3S13bgCKMdOxy9ZuTsPeUtcuE77AHyQWp9HPWeABRGMmoFgFZvcQWY=
X-Received: by 2002:a05:6122:208a:b0:4bd:32c9:acb with SMTP id
 71dfb90a1353d-4e218524df6mr5691819e0c.7.1716477786039; Thu, 23 May 2024
 08:23:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com>
 <c366231-e146-5a2b-1d8a-5936fb2047ca@redhat.com> <8522af2f-fb97-4d0b-9e38-868c572da18a@kernel.dk>
 <7060a917-6537-4334-4961-601a182bca54@redhat.com> <b1ca89ae-1500-4c3c-bd8a-74e081aa8dd3@kernel.dk>
 <798720bc-bc69-1e1c-8436-474e8a9fb0e8@redhat.com>
In-Reply-To: <798720bc-bc69-1e1c-8436-474e8a9fb0e8@redhat.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 23 May 2024 20:52:28 +0530
Message-ID: <CACzX3As928NhtJdNGii16Jeuix3RfzRZbgr4ZSv9p+Pi6FiNvA@mail.gmail.com>
Subject: Re: [PATCH v2] block: change rq_integrity_vec to respect the iterator
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 8:41=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Thu, 23 May 2024, Jens Axboe wrote:
>
> > On 5/23/24 8:58 AM, Mikulas Patocka wrote:
>
> > > Here I'm resending the patch with the function rq_integrity_vec remov=
ed if
> > > CONFIG_BLK_DEV_INTEGRITY is not defined.
> >
> > That looks better - but can you please just post a full new series,
> > that's a lot easier to deal with and look at than adding a v2 of one
> > patch in the thread.
>
> OK, I'll post both patches.
>
> > > @@ -853,16 +855,20 @@ static blk_status_t nvme_prep_rq(struct
> > >                     goto out_free_cmd;
> > >     }
> > >
> > > +#ifdef CONFIG_BLK_DEV_INTEGRITY
> > >     if (blk_integrity_rq(req)) {
> > >             ret =3D nvme_map_metadata(dev, req, &iod->cmd);
> > >             if (ret)
> > >                     goto out_unmap_data;
> > >     }
> > > +#endif
> >
> >       if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) && blk_integrity_rq(req)=
) {
> >
> > ?
>
> That wouldn't work, because the calls to rq_integrity_vec need to be
> eliminated by the preprocessor.
>
> Should I change rq_integrity_vec to this? Then, we could get rid of the
> ifdefs and let the optimizer remove all calls to rq_integrity_vec.
> static inline struct bio_vec rq_integrity_vec(struct request *rq)
> {
>         struct bio_vec bv =3D { };
>         return bv;
> }

This can be reduced to
return (struct bio_vec){ };

>
> > > @@ -962,12 +968,14 @@ static __always_inline void nvme_pci_unm
> > >     struct nvme_queue *nvmeq =3D req->mq_hctx->driver_data;
> > >     struct nvme_dev *dev =3D nvmeq->dev;
> > >
> > > +#ifdef CONFIG_BLK_DEV_INTEGRITY
> > >     if (blk_integrity_rq(req)) {
> > >             struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> >
> > Ditto
> >
> > > Index: linux-2.6/include/linux/blk-integrity.h
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux-2.6.orig/include/linux/blk-integrity.h
> > > +++ linux-2.6/include/linux/blk-integrity.h
> > > @@ -109,11 +109,11 @@ static inline bool blk_integrity_rq(stru
> > >   * Return the first bvec that contains integrity data.  Only drivers=
 that are
> > >   * limited to a single integrity segment should use this helper.
> > >   */
> > > -static inline struct bio_vec *rq_integrity_vec(struct request *rq)
> > > +static inline struct bio_vec rq_integrity_vec(struct request *rq)
> > >  {
> > > -   if (WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1))
> > > -           return NULL;
> > > -   return rq->bio->bi_integrity->bip_vec;
> > > +   WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1);
> > > +   return mp_bvec_iter_bvec(rq->bio->bi_integrity->bip_vec,
> > > +                            rq->bio->bi_integrity->bip_iter);
> > >  }
> >
> > Not clear why the return on integrity segments > 1 is removed?
>
> Because we can't return NULL. But I can leave it there, print a warning
> and return the first vector.
>
> Mikulas
>
> > --
> > Jens Axboe
> >
>
>

--
Anuj Gupta
