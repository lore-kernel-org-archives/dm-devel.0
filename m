Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EF41C862F
	for <dm-devel@lists.linux.dev>; Thu,  9 Apr 2026 02:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775701922; cv=none; b=p2sGjLjJupNgx5+7O+kBdGUKY9QQRfnO8Sf4vbGyA/ezmO/eTxjNeOG5UuFRUvekHh4cHM71XluZPdxg6XC7iipmwtm9Nc2RsIF2xiSgIjlwfzHwZa9/YLVpX3Yy5e/pT5Ay1qlQfs00pwHsS+1etUGqanAGHG+uEKyxuROht4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775701922; c=relaxed/simple;
	bh=HuTkQcMSnTdWdzJiZnv58KvdOWhs+6qeCppNZi4Trxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nN/f/dD+doUuSWiFammlg7hGTP1MJxYJNmRA9M6iMBuAVxFb1+iy4uA0yUYR7d46c9aOf/NxZdqcrEPPOHu02MVRSHTlc4QCzsCm9iUfUHLESkhZsGut3WdR+f1TSIqgjYuNTLiuZLPJxcds/iIENV27h9mKPs7uYyXqB3U0AJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fxw737RP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fxw737RP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775701919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6DAwRwjUB6mVh6wBFSHONXTHG5mUAPiZqK2kyLUtcc=;
	b=Fxw737RPXbShhZj4h5jmgJyMAInRM9uytAfNI26dKZQwqmSLq0Jr9CoIqlKZh52rchCI9B
	HiXJGC5lLMbjRT9d4wKoj0M00dg2vt4bP0ozVG+XRoWimd7Hf7ue9vpFn2bj4y9V9h1sDr
	nFa0iqvAFfo6qeqZTmZm2rTfffKA22o=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-EzeyfinUNAm0B4zdKogeAA-1; Wed, 08 Apr 2026 22:31:58 -0400
X-MC-Unique: EzeyfinUNAm0B4zdKogeAA-1
X-Mimecast-MFC-AGG-ID: EzeyfinUNAm0B4zdKogeAA_1775701917
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b6cbd5493so329857e87.0
        for <dm-devel@lists.linux.dev>; Wed, 08 Apr 2026 19:31:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775701917; x=1776306717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z6DAwRwjUB6mVh6wBFSHONXTHG5mUAPiZqK2kyLUtcc=;
        b=NnEsEmaZrJCGXdkwMIvsMOje3RxA8sLHx+RYZe9PDYaUHw1xm0cqBMdjWVvhxhDyW6
         Jeq/wAkQrAWGNtrZVH9aXmDWF+qFfNscQf8wrlS7qmfQ1z6VoyAxEX3xTMAGoplUE6Jw
         ITluZKMTB8IkzOc/lqpV3PUvSNd4Hzloh88/ALers4X1Q9jVaSUwf8M3dw1+cvRTayhU
         T/ff4JLuDFl/VBt9Ug8uDAkJzJCah71TxQcBvJkfZx0km3ZUIu0NRzA+lplqTGdnxwMm
         eBPhgNiisKiR5CBht5ePdsNhrZhKAn+QeMGZD9SpXbjI6ObrVYAyp+P83Ua/qfVFF1+q
         VBFw==
X-Forwarded-Encrypted: i=1; AJvYcCX7dTl7KqbKXRcj2oX/s76dXgMZIfUpIJl2zPx+s2LQjKvizDYSTTmXBLZYJArd9kzNff2tXdg7Cg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzQBYrJ9zRcK3t+j3nzZVGlWbpBxMNz5mf0K4sG6gg8A7cJ8qlG
	6pPb5wPqy6dW3UvBlmWAv5JuyZwQ9tBhg2bpvKp1EjizNO/eNADmaftWU9VSCEEmOUau/AkanAz
	xBBvFB11ggie7gHiO5O859dryP3hqKi+HWTzPuLW/E3FQgEucd72aMB+MfRR7RLdHYvnpeXtuiQ
	OaUBDBjZkJmfw6Bkxl9EeCS2+jc4qoYmtocxU=
X-Gm-Gg: AeBDietNOQIXm1Z7q4pC8jomsvjd9HxJ1HBu7SYAEUow67NJimVUi3FE9rkgK8OqQyQ
	JmJCK2r9wdG02HitqWW8Febb8Gz74lSXxCq7xLFlnzyUMiUVtt+qr8aTkT2HUrzDiWqsP8UMpdP
	ogVE1ao+bpxevMyZKvPq2e8ufHG/LLqdxz8pScF2jzNaWkGlaFE2sSPePykBPJxj4ZtQPj5Oj5w
	V0HaiRolWieo0wm8nmX4kk8bf2VlaYDbLPsYv69N2NHhq402a3zuZvd2EmAZ7ejjLoALCzc0QaR
	JDBdAA==
X-Received: by 2002:a05:6512:159f:b0:59e:6296:80ef with SMTP id 2adb3069b0e04-5a337515c84mr7283048e87.0.1775701916371;
        Wed, 08 Apr 2026 19:31:56 -0700 (PDT)
X-Received: by 2002:a05:6512:159f:b0:59e:6296:80ef with SMTP id
 2adb3069b0e04-5a337515c84mr7283031e87.0.1775701915690; Wed, 08 Apr 2026
 19:31:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260408043548.1695157-1-bmarzins@redhat.com> <CALTww28H_Qs_Oh0WkDFvVynvbyUhgUK9u0cuU7bpoF+jOg1mYA@mail.gmail.com>
 <adazQdvXjE1RlMid@redhat.com>
In-Reply-To: <adazQdvXjE1RlMid@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 9 Apr 2026 10:31:43 +0800
X-Gm-Features: AQROBzCbW2whcDPrvxF_fdRhk4uZD1cfpp3BYHGSaHp8p7JoZ7T9FwE1DKEISJA
Message-ID: <CALTww2_EE5ZZKEUjxONrkfsAQJE0qp7H=S-RJTXSBGNiCHgraw@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4YoeGtqo9eHWTMYOLvGQKnkBv598Vw3i75TJ-DN0Nd8_1775701917
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 3:58=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat.=
com> wrote:
>
> On Wed, Apr 08, 2026 at 07:22:38PM +0800, Xiao Ni wrote:
> > On Wed, Apr 8, 2026 at 12:35=E2=80=AFPM Benjamin Marzinski <bmarzins@re=
dhat.com> wrote:
> > >
> > > If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> > > raid5_make_request() will free the cloned bio. But raid5_make_request=
()
> > > can call make_stripe_request() multiple times, writing to the various
> > > stripes. If that bio got added to the toread or towrite lists of a
> > > stripe disk in an earlier call to make_stripe_request(), then it's no=
t
> > > safe to just free the bio if a later part of it is found to cross the
> > > reshape position. Doing so can lead to a UAF error, when bio_endio()
> > > is called on the bio for the earlier stripes.
> > >
> > > Instead, raid5_make_request() needs to wait until all parts of the bi=
o
> > > have called bio_endio(). To do this, bios that cross the reshape
> > > position while the reshape can't make progress are flagged as needing=
 to
> > > wait for all parts to complete. When raid5_make_request() has a bio t=
hat
> > > failed make_stripe_request() with STRIPE_WAIT_RESHAPE, it sets
> > > bi->bi_private to a completion struct and waits for completion after
> > > ending the bio.  When the bio_endio() is called for the last time on =
a
> > > clone bio with bi->bi_private set, it wakes up the waiter. This
> > > guarantees that raid5_make_request() doesn't return until the cloned =
bio
> > > needing a retry for io across the reshape boundary is safely cleaned =
up.
> > >
> > > There is a simple reproducer available at [1]. Compile the kernel wit=
h
> > > KASAN for more useful reporting when the error is triggered (this is =
not
> > > necessary to see the bug).
> > >
> > > [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5
> > >
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >
> > > Changes from v1:
> > > - Removed mddev->pending_retry_bios, mddev->retry_bios_wait, and
> > >   md_io_clone->must_retry. Instead, use a completion struct
> > >   pointed to by bi->bi_private, as suggested by Xiao Ni and Yu Kuai.
> > >
> > >  drivers/md/md.c    | 31 ++++++++-----------------------
> > >  drivers/md/md.h    |  1 -
> > >  drivers/md/raid5.c |  7 ++++++-
> > >  3 files changed, 14 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 3ce6f9e9d38e..4318d875a5f6 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -9215,9 +9215,11 @@ static void md_bitmap_end(struct mddev *mddev,=
 struct md_io_clone *md_io_clone)
> > >
> > >  static void md_end_clone_io(struct bio *bio)
> > >  {
> > > -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> > > +       struct md_io_clone *md_io_clone =3D container_of(bio, struct =
md_io_clone,
> > > +                                                      bio_clone);
> > >         struct bio *orig_bio =3D md_io_clone->orig_bio;
> > >         struct mddev *mddev =3D md_io_clone->mddev;
> > > +       struct completion *reshape_completion =3D bio->bi_private;
> > >
> > >         if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(=
mddev, false))
> > >                 md_bitmap_end(mddev, md_io_clone);
> > > @@ -9229,7 +9231,10 @@ static void md_end_clone_io(struct bio *bio)
> > >                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
> > >
> > >         bio_put(bio);
> > > -       bio_endio(orig_bio);
> > > +       if (unlikely(reshape_completion))
> > > +               complete(reshape_completion);
> > > +       else
> > > +               bio_endio(orig_bio);
> > >         percpu_ref_put(&mddev->active_io);
> > >  }
> > >
> > > @@ -9254,7 +9259,7 @@ static void md_clone_bio(struct mddev *mddev, s=
truct bio **bio)
> > >         }
> > >
> > >         clone->bi_end_io =3D md_end_clone_io;
> > > -       clone->bi_private =3D md_io_clone;
> > > +       clone->bi_private =3D NULL;
> > >         *bio =3D clone;
> > >  }
> > >
> > > @@ -9265,26 +9270,6 @@ void md_account_bio(struct mddev *mddev, struc=
t bio **bio)
> > >  }
> > >  EXPORT_SYMBOL_GPL(md_account_bio);
> > >
> > > -void md_free_cloned_bio(struct bio *bio)
> > > -{
> > > -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> > > -       struct bio *orig_bio =3D md_io_clone->orig_bio;
> > > -       struct mddev *mddev =3D md_io_clone->mddev;
> > > -
> > > -       if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(=
mddev, false))
> > > -               md_bitmap_end(mddev, md_io_clone);
> > > -
> > > -       if (bio->bi_status && !orig_bio->bi_status)
> > > -               orig_bio->bi_status =3D bio->bi_status;
> > > -
> > > -       if (md_io_clone->start_time)
> > > -               bio_end_io_acct(orig_bio, md_io_clone->start_time);
> > > -
> > > -       bio_put(bio);
> > > -       percpu_ref_put(&mddev->active_io);
> > > -}
> > > -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> > > -
> > >  /* md_allow_write(mddev)
> > >   * Calling this ensures that the array is marked 'active' so that wr=
ites
> > >   * may proceed without blocking.  It is important to call this befor=
e
> > > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > > index ac84289664cd..5d57fee22901 100644
> > > --- a/drivers/md/md.h
> > > +++ b/drivers/md/md.h
> > > @@ -917,7 +917,6 @@ extern void md_finish_reshape(struct mddev *mddev=
);
> > >  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev=
,
> > >                         struct bio *bio, sector_t start, sector_t siz=
e);
> > >  void md_account_bio(struct mddev *mddev, struct bio **bio);
> > > -void md_free_cloned_bio(struct bio *bio);
> > >
> > >  extern bool __must_check md_flush_request(struct mddev *mddev, struc=
t bio *bio);
> > >  void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index a8e8d431071b..dc0c680ca199 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -6217,7 +6217,12 @@ static bool raid5_make_request(struct mddev *m=
ddev, struct bio * bi)
> > >
> > >         mempool_free(ctx, conf->ctx_pool);
> > >         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> > > -               md_free_cloned_bio(bi);
> > > +               DECLARE_COMPLETION_ONSTACK(done);
> > > +               WRITE_ONCE(bi->bi_private, &done);
> > > +
> > > +               bio_endio(bi);
> >
> > Hi Ben
> >
> > You gave an explanation why it doesn't need WRITE_ONCE. As you said,
> > bio_endio uses atomic_dec_and_test, so it guarantees a full memory
> > barrier. Why do you use WRITE_ONCE here?
>
> You're correct. I don't believe it's necessary. The compiler has to
> update bi->bi_private before calling bio_endio(bi), which can free bi,
> and either the bio was never chained, and bi->bi_private will be read by
> the same process that set it, or it was chained, and the
> atomic_dec_and_test() in bio_remaining_done() will guarantee a memory
> barrier.
>
> I just patterned my updated fix off your idea, and left the WRITE_ONCE
> there because it doesn't really hurt anything, since this is already the
> slow (and unlikely) path. I can pull it out if you'd like.

Thanks for the explanation. It's good to me to keep it.

>
> I actually have another question about this code. My patch doesn't mess
> with the code at the end of make_stripe_request() to return
> STRIPE_WAIT_RESHAPE, but I'm not sure that it's right. That code
> includes:
>
>                 bi->bi_status =3D BLK_STS_RESOURCE;
>
> This will update the orig_bio's bi_status in md_end_clone_io():
>
>         if (bio->bi_status && !orig_bio->bi_status)
>                 orig_bio->bi_status =3D bio->bi_status;
>
> For dm-raid, that orig_bio is itself a clone, and will eventually
> get ended with DM_MAPIO_REQUEUE, which will requeue the actual
> original bio (assuming that this happens when the device is
> in a noflush suspend).
>
> But for md, md_handle_request() can just loop and retry it. If the
> mddev->pers->make_request() call succeeds on retry, the orig_bio will
> still have the BLK_STS_RESOURCE status that got set when the earlier
> call to make_stripe_request() returned STRIPE_WAIT_RESHAPE.
>
> Perhaps make_stripe_request() shouldn't set bi->bi_status if
> it's going to return STRIPE_WAIT_RESHAPE. The only thing I can see that
> it does is set orig_bio->bi_status, which I don't think we want it to
> do. Am I missing something here?

It's good to me to remove the line of setting BLK_STS_RESOURCE.

Regards
Xiao
>
> -Ben
>
> >
> > Regards
> > Xiao
> >
> >
> > > +
> > > +               wait_for_completion(&done);
> > >                 return false;
> > >         }
> > >
> > > --
> > > 2.53.0
> > >
>

