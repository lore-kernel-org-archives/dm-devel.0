Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A6D20A5F3
	for <dm-devel@lists.linux.dev>; Mon, 13 Apr 2026 02:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776046124; cv=none; b=SjQw4Zw1HLRLKm5s24vyOYGSmK9K2FGdV6o0Du7aSD+6qyKa5Ie3/mYI3fZQID0DtJYajy7yTDbCVOv+2N6hpWXRrmFKj59WbPEGJz0eiGV7Iq1FX3sB2RTVtj7jgemy5IfFVWIcHhUAjrEwbVE0TV3008/1MxtMPydXS0JWQFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776046124; c=relaxed/simple;
	bh=Y3eM2lcm3Qi4EKp4Z9dkRRzdlntkIX6d3E8qTRqCieQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nuL1EXjdeFKKFVXDl4V42gervvrYzFYmpnRPvWw9aCkkdCFs+eITTESFhygJ5pLT2NqsgJDwjqZkQQBcLfkxTl/KBNoraoJMGphP6flGtBCIealeCldSondKUQ6m46cyr2UbmlxnR3fEY8eFU2T7S28UWhB1EaVj5YPUtJWR0NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SZheHiqr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SZheHiqr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776046122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YXF4lFTNzXI2wX3fCrQMRRC0JVo5TQW0rDUxyJ5U8+A=;
	b=SZheHiqrNtc3v+EnX28AutkkP5HezansXEbJVBn7RrW5n2Dv50jXTI8YqCNeuKdMMg2htS
	W2QBsu9drrMeLneDhSHbZnPX0M7YTUpowoYo2Ni6IrAxuMXSEcZyDgUgknmHQ48ZBQYUNy
	5U6RqPYi2x6xzCf/TpjT9yMlbAsi3pk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-jHt3pdAxNuGfRyJmKErUow-1; Sun, 12 Apr 2026 22:08:40 -0400
X-MC-Unique: jHt3pdAxNuGfRyJmKErUow-1
X-Mimecast-MFC-AGG-ID: jHt3pdAxNuGfRyJmKErUow_1776046119
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a118530219so2532842e87.1
        for <dm-devel@lists.linux.dev>; Sun, 12 Apr 2026 19:08:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776046119; x=1776650919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YXF4lFTNzXI2wX3fCrQMRRC0JVo5TQW0rDUxyJ5U8+A=;
        b=mJnxGvSmiD8u1Qmrt/ysIhQMmPp7je4Pkpcm0H3Auz41t4O8kE0gasQ835/8KqCqv5
         1IBsmrEdo6BUFVyyR4Ty8y5t4TuR+DU4x4sBNnRXhrhUq86v9Apr5PQZfHlEppYXJzBh
         D7rfygKrxjfJ79/lbtexmR1d2SDoPpm/cNZYG61uqFTgUvAvQRLl9z4+GzLy8Hu/UhWs
         9oiV2+KpH1s5LS8D1dhdYgK3xMY/wWbrOeGBy3zPGLpf+A4MNDvKVN52yhqxKq/LW06x
         bNza9cd4E2jY5Prijm6/iIJ8Ep12OwZrv0Ys0wul2oFtsdaLSM/E82UxxHJiq5bkLa2f
         MkWQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Z8917nYSj8jNIY2JlGE0PVmzcvw321/ap+UNkdbDtNrF44aodpqUXsOnr86ISRpiNmzP8Y3EWpg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/WrL9dtwTkCPf7NGi7R6bqG65dVxPfdmPd77QQZw9Zk8ABGIj
	VofirtL7KJVUaxAaZGBwMe46YbHNQCdrz4C4RGpUUbnKrbhD4ebGXUn6C/xaYeu8Z41/JnggbC+
	oRJrHMCw51SjFo7cK4YYvU9dmnjHGG7Q/JK87QABdhoCKejocalioITEGvGRkC8LkSW3KS+nSf9
	qShkg/TMzTCcxVnQ88PAtybg6LeeM0YHmY4w0=
X-Gm-Gg: AeBDieuo3YBv35XPTCw6Sl719F0VHRjblgLZrApE6/jly4jD4+jm8p3LelCIcDd/s2F
	18MMcxNTA8a6VIetWqO/lXl7p10gViP9b22A15z/Dz7WQQ2hbC+s/ifSNuZlDBpp3GGTPeFeJYS
	sbw7TfqcZsCAS+lIWYZWTnendpbAnBjFzyGApRosrEVz9ZbfAtzp8MN9D88jG5I1GSajx5djG8d
	Wrku0fylihTN2AFNj4BI0S3nab47DG+IDNv6ST/aD+gqP0zwZTkj1bxf7U+bgk5z+9u5A0GiQpo
	NTHlbw==
X-Received: by 2002:a05:6512:3f12:b0:5a2:7d1a:4043 with SMTP id 2adb3069b0e04-5a3efb8bd53mr3376758e87.20.1776046119026;
        Sun, 12 Apr 2026 19:08:39 -0700 (PDT)
X-Received: by 2002:a05:6512:3f12:b0:5a2:7d1a:4043 with SMTP id
 2adb3069b0e04-5a3efb8bd53mr3376745e87.20.1776046118451; Sun, 12 Apr 2026
 19:08:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260408043548.1695157-1-bmarzins@redhat.com> <CALTww28H_Qs_Oh0WkDFvVynvbyUhgUK9u0cuU7bpoF+jOg1mYA@mail.gmail.com>
 <adazQdvXjE1RlMid@redhat.com> <CALTww2_EE5ZZKEUjxONrkfsAQJE0qp7H=S-RJTXSBGNiCHgraw@mail.gmail.com>
In-Reply-To: <CALTww2_EE5ZZKEUjxONrkfsAQJE0qp7H=S-RJTXSBGNiCHgraw@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 13 Apr 2026 10:08:26 +0800
X-Gm-Features: AQROBzAqmaJZmyN0GPxWa8Un-uAJHSH3qntCqzHRVcU9ml83HHuwmzOgEVamq7o
Message-ID: <CALTww28PsYD5UJWzDj8vC6GL4VGNw2_1i3cAppg=k4utQkffpQ@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -5HwLkZxmYbztXt3BpsLoIzTIdNLOsz1W06w9ytNSxg_1776046119
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 10:31=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> On Thu, Apr 9, 2026 at 3:58=E2=80=AFAM Benjamin Marzinski <bmarzins@redha=
t.com> wrote:
> >
> > On Wed, Apr 08, 2026 at 07:22:38PM +0800, Xiao Ni wrote:
> > > On Wed, Apr 8, 2026 at 12:35=E2=80=AFPM Benjamin Marzinski <bmarzins@=
redhat.com> wrote:
> > > >
> > > > If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> > > > raid5_make_request() will free the cloned bio. But raid5_make_reque=
st()
> > > > can call make_stripe_request() multiple times, writing to the vario=
us
> > > > stripes. If that bio got added to the toread or towrite lists of a
> > > > stripe disk in an earlier call to make_stripe_request(), then it's =
not
> > > > safe to just free the bio if a later part of it is found to cross t=
he
> > > > reshape position. Doing so can lead to a UAF error, when bio_endio(=
)
> > > > is called on the bio for the earlier stripes.
> > > >
> > > > Instead, raid5_make_request() needs to wait until all parts of the =
bio
> > > > have called bio_endio(). To do this, bios that cross the reshape
> > > > position while the reshape can't make progress are flagged as needi=
ng to
> > > > wait for all parts to complete. When raid5_make_request() has a bio=
 that
> > > > failed make_stripe_request() with STRIPE_WAIT_RESHAPE, it sets
> > > > bi->bi_private to a completion struct and waits for completion afte=
r
> > > > ending the bio.  When the bio_endio() is called for the last time o=
n a
> > > > clone bio with bi->bi_private set, it wakes up the waiter. This
> > > > guarantees that raid5_make_request() doesn't return until the clone=
d bio
> > > > needing a retry for io across the reshape boundary is safely cleane=
d up.
> > > >
> > > > There is a simple reproducer available at [1]. Compile the kernel w=
ith
> > > > KASAN for more useful reporting when the error is triggered (this i=
s not
> > > > necessary to see the bug).
> > > >
> > > > [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241f=
a5
> > > >
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > >
> > > > Changes from v1:
> > > > - Removed mddev->pending_retry_bios, mddev->retry_bios_wait, and
> > > >   md_io_clone->must_retry. Instead, use a completion struct
> > > >   pointed to by bi->bi_private, as suggested by Xiao Ni and Yu Kuai=
.
> > > >
> > > >  drivers/md/md.c    | 31 ++++++++-----------------------
> > > >  drivers/md/md.h    |  1 -
> > > >  drivers/md/raid5.c |  7 ++++++-
> > > >  3 files changed, 14 insertions(+), 25 deletions(-)
> > > >
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index 3ce6f9e9d38e..4318d875a5f6 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -9215,9 +9215,11 @@ static void md_bitmap_end(struct mddev *mdde=
v, struct md_io_clone *md_io_clone)
> > > >
> > > >  static void md_end_clone_io(struct bio *bio)
> > > >  {
> > > > -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> > > > +       struct md_io_clone *md_io_clone =3D container_of(bio, struc=
t md_io_clone,
> > > > +                                                      bio_clone);
> > > >         struct bio *orig_bio =3D md_io_clone->orig_bio;
> > > >         struct mddev *mddev =3D md_io_clone->mddev;
> > > > +       struct completion *reshape_completion =3D bio->bi_private;
> > > >
> > > >         if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enable=
d(mddev, false))
> > > >                 md_bitmap_end(mddev, md_io_clone);
> > > > @@ -9229,7 +9231,10 @@ static void md_end_clone_io(struct bio *bio)
> > > >                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
> > > >
> > > >         bio_put(bio);
> > > > -       bio_endio(orig_bio);
> > > > +       if (unlikely(reshape_completion))
> > > > +               complete(reshape_completion);
> > > > +       else
> > > > +               bio_endio(orig_bio);
> > > >         percpu_ref_put(&mddev->active_io);
> > > >  }
> > > >
> > > > @@ -9254,7 +9259,7 @@ static void md_clone_bio(struct mddev *mddev,=
 struct bio **bio)
> > > >         }
> > > >
> > > >         clone->bi_end_io =3D md_end_clone_io;
> > > > -       clone->bi_private =3D md_io_clone;
> > > > +       clone->bi_private =3D NULL;
> > > >         *bio =3D clone;
> > > >  }
> > > >
> > > > @@ -9265,26 +9270,6 @@ void md_account_bio(struct mddev *mddev, str=
uct bio **bio)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(md_account_bio);
> > > >
> > > > -void md_free_cloned_bio(struct bio *bio)
> > > > -{
> > > > -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> > > > -       struct bio *orig_bio =3D md_io_clone->orig_bio;
> > > > -       struct mddev *mddev =3D md_io_clone->mddev;
> > > > -
> > > > -       if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enable=
d(mddev, false))
> > > > -               md_bitmap_end(mddev, md_io_clone);
> > > > -
> > > > -       if (bio->bi_status && !orig_bio->bi_status)
> > > > -               orig_bio->bi_status =3D bio->bi_status;
> > > > -
> > > > -       if (md_io_clone->start_time)
> > > > -               bio_end_io_acct(orig_bio, md_io_clone->start_time);
> > > > -
> > > > -       bio_put(bio);
> > > > -       percpu_ref_put(&mddev->active_io);
> > > > -}
> > > > -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> > > > -
> > > >  /* md_allow_write(mddev)
> > > >   * Calling this ensures that the array is marked 'active' so that =
writes
> > > >   * may proceed without blocking.  It is important to call this bef=
ore
> > > > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > > > index ac84289664cd..5d57fee22901 100644
> > > > --- a/drivers/md/md.h
> > > > +++ b/drivers/md/md.h
> > > > @@ -917,7 +917,6 @@ extern void md_finish_reshape(struct mddev *mdd=
ev);
> > > >  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rd=
ev,
> > > >                         struct bio *bio, sector_t start, sector_t s=
ize);
> > > >  void md_account_bio(struct mddev *mddev, struct bio **bio);
> > > > -void md_free_cloned_bio(struct bio *bio);
> > > >
> > > >  extern bool __must_check md_flush_request(struct mddev *mddev, str=
uct bio *bio);
> > > >  void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> > > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > index a8e8d431071b..dc0c680ca199 100644
> > > > --- a/drivers/md/raid5.c
> > > > +++ b/drivers/md/raid5.c
> > > > @@ -6217,7 +6217,12 @@ static bool raid5_make_request(struct mddev =
*mddev, struct bio * bi)
> > > >
> > > >         mempool_free(ctx, conf->ctx_pool);
> > > >         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> > > > -               md_free_cloned_bio(bi);
> > > > +               DECLARE_COMPLETION_ONSTACK(done);
> > > > +               WRITE_ONCE(bi->bi_private, &done);
> > > > +
> > > > +               bio_endio(bi);
> > >
> > > Hi Ben
> > >
> > > You gave an explanation why it doesn't need WRITE_ONCE. As you said,
> > > bio_endio uses atomic_dec_and_test, so it guarantees a full memory
> > > barrier. Why do you use WRITE_ONCE here?
> >
> > You're correct. I don't believe it's necessary. The compiler has to
> > update bi->bi_private before calling bio_endio(bi), which can free bi,
> > and either the bio was never chained, and bi->bi_private will be read b=
y
> > the same process that set it, or it was chained, and the
> > atomic_dec_and_test() in bio_remaining_done() will guarantee a memory
> > barrier.
> >
> > I just patterned my updated fix off your idea, and left the WRITE_ONCE
> > there because it doesn't really hurt anything, since this is already th=
e
> > slow (and unlikely) path. I can pull it out if you'd like.
>
> Thanks for the explanation. It's good to me to keep it.
>
> >
> > I actually have another question about this code. My patch doesn't mess
> > with the code at the end of make_stripe_request() to return
> > STRIPE_WAIT_RESHAPE, but I'm not sure that it's right. That code
> > includes:
> >
> >                 bi->bi_status =3D BLK_STS_RESOURCE;
> >
> > This will update the orig_bio's bi_status in md_end_clone_io():
> >
> >         if (bio->bi_status && !orig_bio->bi_status)
> >                 orig_bio->bi_status =3D bio->bi_status;
> >
> > For dm-raid, that orig_bio is itself a clone, and will eventually
> > get ended with DM_MAPIO_REQUEUE, which will requeue the actual
> > original bio (assuming that this happens when the device is
> > in a noflush suspend).
> >
> > But for md, md_handle_request() can just loop and retry it. If the
> > mddev->pers->make_request() call succeeds on retry, the orig_bio will
> > still have the BLK_STS_RESOURCE status that got set when the earlier
> > call to make_stripe_request() returned STRIPE_WAIT_RESHAPE.
> >
> > Perhaps make_stripe_request() shouldn't set bi->bi_status if
> > it's going to return STRIPE_WAIT_RESHAPE. The only thing I can see that
> > it does is set orig_bio->bi_status, which I don't think we want it to
> > do. Am I missing something here?
>
> It's good to me to remove the line of setting BLK_STS_RESOURCE.

Hi Ben

Could you send this in a seperate patch?

Best Regards
Xiao

