Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1162F6931
	for <dm-devel@lists.linux.dev>; Tue, 31 Mar 2026 02:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774923906; cv=none; b=rr9LGZegGwIsTKT9od2EwaUy7Vx5kUzPM2d8sfiBMbZ6uQO+5a3HvzoC4pzBf13dK0R3d1hHwhPTuMM+Iq7WnlCMh1QuGv7hBh2fQqFUFoUJQCGUZ8VDACfkVGdGHV1oMTzd2Df569fgZ0t4tCqtnoaQIta28q/RsANKvQvZ38I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774923906; c=relaxed/simple;
	bh=53waOxUAU8GIqETOQkUAx2zTki5kVHzmbzSTUC/qWTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jn9TpBwWbH35agCUGYXz7JGL086qPySBp3t+Bbga+f/htaTuW4egPtqbPuk5E+VserRxRJ8wVWaGp5Y4XMuCqj+jgp5+IOvFu0R0LdPc10xnO07EYGv7etIMj4lk+qZ8F2f2PVeEYUnf8N2/qfyB09bBOfrG+U3mU8chElwW6S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O5N3CKvs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O5N3CKvs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774923903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lzqRMsrsPMa4VNMQGbFosoNwmkTRdKsCUylOoUrvuG8=;
	b=O5N3CKvsrXhtbB2rzVjWHs3w2+WYbJ07H/BmSJXeMIfn7yvoi9ReSbwxzV5xWVjBMvHSmi
	mnWNBMlqVEiymsYh9/5xRU95Cra4K91hp8zDzjgMSP2bfRiHSudMy6eTp6yT+cv2+OOUPu
	zvDdXOIyNmn5KTtsd9Yk2HM/8MIKA2g=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-1rFTFxtKNr6TeL2IXNEGzA-1; Mon, 30 Mar 2026 22:25:02 -0400
X-MC-Unique: 1rFTFxtKNr6TeL2IXNEGzA-1
X-Mimecast-MFC-AGG-ID: 1rFTFxtKNr6TeL2IXNEGzA_1774923901
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a2a203916cso3949996e87.3
        for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 19:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774923901; x=1775528701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lzqRMsrsPMa4VNMQGbFosoNwmkTRdKsCUylOoUrvuG8=;
        b=UaTUi3flBlN5wssf2vF2AGqVmufGUFwDSIlRFkLIA4TWCQIJSbvLyCJn3tUka3/dSu
         62QUkwGdamw5U99pi+ZIk14mmZGe32m1Y70kFi/Mlfsrj0xCgB/12Uto4aZzhFYHVP4S
         OB+iAU4jOOM+9QZjKI7iNFDm4bLJvqWsQs2M7PPjvPMC3g+mWPkrd9vw2jl61vfucMFR
         RoE6tz/V1qLikASQ9sLYDuevL7xa9JNJjk0P7ZvEZYSdZ/LPlBx9jRXrYSxYeZhQ8tY2
         Er3YXYOQbv71DTIb3E4cJDzyFvwvFvXdq1kXSop9B3OLaM0XfKdQ7bxUB5y3nLxxKb0W
         jHiA==
X-Forwarded-Encrypted: i=1; AJvYcCW37SNAF+RIO18dqqhfntAZeQzT0lrNQnKDsWChXTv/fhy7Xwe3J870myTZytxtJvIjeLgiBiQ69Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0ODMpFfvUM35jkSZPyp95C8p+xhN8XI2eVyUguSKb2kXqNvFm
	vi4BKiE7zKBpptVcalzvPSSOWwNCPhuegNBWe2UCTARrKY0VLNLBtVhJXFS3cKDUj9EEiPkUIxz
	ylrQsWXHpvAiXSf+XE7Y3X21TEizHE9gj3u2PGGERQNYiZbD7Thjd7BfKBkLohcnVRj9zd4YCxq
	gud3YNw1YyB9hKMs1OTbMCS3OVFTSehCg9xRA=
X-Gm-Gg: ATEYQzz6flU7N29g+ovOlmvL2tNEuadR6e0oC7G1hFGxf7c9kx52ieF0aNkxpMig1Jp
	ekvSpYSJw7pEHn3VaFrW/r/R3Jobxz1EjayBmmwvlhjvxMqMu1qXDFVeZvxiQD6fNG1mpj1KoDS
	Ymen0S9sLC7wVpaJv9RPZ/9Hba51amUekfcC+us1kewpUikdoFqM5V+CzSELRkm0qWRQW7U1tZ3
	c2C/cD9l+zlqplRF2AELtGmvsS+VbbSjAJJ2bijqETd4KY889UCAQ1Yd9M59Qrr8CPwp9E8hFHe
	6ts8Qw==
X-Received: by 2002:a05:6512:3d1c:b0:5a2:b842:6850 with SMTP id 2adb3069b0e04-5a2b842695cmr1489750e87.15.1774923900571;
        Mon, 30 Mar 2026 19:25:00 -0700 (PDT)
X-Received: by 2002:a05:6512:3d1c:b0:5a2:b842:6850 with SMTP id
 2adb3069b0e04-5a2b842695cmr1489732e87.15.1774923900001; Mon, 30 Mar 2026
 19:25:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260323225836.1037060-1-bmarzins@redhat.com> <CALTww29P_jZ-n9GMgFG0EW_N22vUsGAPJ5OGn5Lw8yfEpEoGOw@mail.gmail.com>
 <acrMIhAjB-HKszbs@redhat.com>
In-Reply-To: <acrMIhAjB-HKszbs@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 31 Mar 2026 10:24:48 +0800
X-Gm-Features: AQROBzAoNeL_79_n60BBdgTQ5ZkqBekFQ4T4471TwNRsR_066n-TnL_fljoedq8
Message-ID: <CALTww2-SE6b7bQ93ZbJ3N_Xxgrm4b8rv6Sukjt5cUVNHScPFRg@mail.gmail.com>
Subject: Re: [RFC PATCH] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>, Yu Kuai <yukuai@fnnas.com>
Cc: Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R4kI2y5dvH3YQ71QNr_mJy56qgT9GWtt21b5oK4uikA_1774923901
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2026 at 3:16=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> On Mon, Mar 30, 2026 at 11:44:54PM +0800, Xiao Ni wrote:
> > On Tue, Mar 24, 2026 at 6:58=E2=80=AFAM Benjamin Marzinski <bmarzins@re=
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
 a
> > > retry, and mddev tracks the number of bios needing a retry which have
> > > not yet completed. When raid5_make_request() has a bio that failed
> > > make_stripe_request() with STRIPE_WAIT_RESHAPE, it waits for this
> > > counter to reach zero. When the bio_endio() is called for the last ti=
me
> > > on a bio needing a retry, it decrements mddev's count of outstanding
> > > bios needing a retry. This guarantees that raid5_make_request() doesn=
't
> > > return until the cloned bio needing a retry for io across the reshape
> > > boundary is safely cleaned up.
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
> > > I've tested this for regressions with the lvm2-testsuite raid tests. =
I
> > > have not run any md-specific tests on it.
> > >
> > >
> > >  drivers/md/md.c    | 30 +++++++++---------------------
> > >  drivers/md/md.h    |  5 ++++-
> > >  drivers/md/raid5.c |  8 +++++++-
> > >  3 files changed, 20 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 3ce6f9e9d38e..5ec116b9da32 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -776,9 +776,11 @@ int mddev_init(struct mddev *mddev)
> > >         atomic_set(&mddev->active, 1);
> > >         atomic_set(&mddev->openers, 0);
> > >         atomic_set(&mddev->sync_seq, 0);
> > > +       atomic_set(&mddev->pending_retry_bios, 0);
> > >         spin_lock_init(&mddev->lock);
> > >         init_waitqueue_head(&mddev->sb_wait);
> > >         init_waitqueue_head(&mddev->recovery_wait);
> > > +       init_waitqueue_head(&mddev->retry_bios_wait);
> > >         mddev->reshape_position =3D MaxSector;
> > >         mddev->reshape_backwards =3D 0;
> > >         mddev->last_sync_action =3D ACTION_IDLE;
> > > @@ -9218,6 +9220,7 @@ static void md_end_clone_io(struct bio *bio)
> > >         struct md_io_clone *md_io_clone =3D bio->bi_private;
> > >         struct bio *orig_bio =3D md_io_clone->orig_bio;
> > >         struct mddev *mddev =3D md_io_clone->mddev;
> > > +       unsigned int must_retry =3D md_io_clone->must_retry;
> > >
> > >         if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(=
mddev, false))
> > >                 md_bitmap_end(mddev, md_io_clone);
> > > @@ -9229,7 +9232,11 @@ static void md_end_clone_io(struct bio *bio)
> > >                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
> > >
> > >         bio_put(bio);
> > > -       bio_endio(orig_bio);
> > > +       if (unlikely(must_retry)) {
> > > +               if (atomic_dec_and_test(&mddev->pending_retry_bios))
> > > +                       wake_up(&mddev->retry_bios_wait);
> > > +       } else
> > > +               bio_endio(orig_bio);
> > >         percpu_ref_put(&mddev->active_io);
> > >  }
> > >
> > > @@ -9243,6 +9250,7 @@ static void md_clone_bio(struct mddev *mddev, s=
truct bio **bio)
> > >         md_io_clone =3D container_of(clone, struct md_io_clone, bio_c=
lone);
> > >         md_io_clone->orig_bio =3D *bio;
> > >         md_io_clone->mddev =3D mddev;
> > > +       md_io_clone->must_retry =3D 0;
> > >         if (blk_queue_io_stat(bdev->bd_disk->queue))
> > >                 md_io_clone->start_time =3D bio_start_io_acct(*bio);
> > >
> > > @@ -9265,26 +9273,6 @@ void md_account_bio(struct mddev *mddev, struc=
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
> > > index ac84289664cd..49a231f11676 100644
> > > --- a/drivers/md/md.h
> > > +++ b/drivers/md/md.h
> > > @@ -626,6 +626,9 @@ struct mddev {
> > >
> > >         /* The sequence number for sync thread */
> > >         atomic_t sync_seq;
> > > +
> > > +       wait_queue_head_t               retry_bios_wait;
> > > +       atomic_t                        pending_retry_bios;
> > >  };
> > >
> > >  enum recovery_flags {
> > > @@ -877,6 +880,7 @@ struct md_io_clone {
> > >         sector_t        offset;
> > >         unsigned long   sectors;
> > >         enum stat_group rw;
> > > +       unsigned int    must_retry;
> > >         struct bio      bio_clone;
> > >  };
> > >
> > > @@ -917,7 +921,6 @@ extern void md_finish_reshape(struct mddev *mddev=
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
> > > index a8e8d431071b..fb78a757f2fd 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -6217,7 +6217,13 @@ static bool raid5_make_request(struct mddev *m=
ddev, struct bio * bi)
> > >
> > >         mempool_free(ctx, conf->ctx_pool);
> > >         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> > > -               md_free_cloned_bio(bi);
> > > +               struct md_io_clone *md_io_clone =3D bi->bi_private;
> > > +
> > > +               md_io_clone->must_retry =3D 1;
> > > +               atomic_inc(&mddev->pending_retry_bios);
> > > +               bio_endio(bi);
> > > +               wait_event(mddev->retry_bios_wait,
> > > +                          atomic_read(&mddev->pending_retry_bios)=3D=
=3D0);
> >
> > Hi Ben
> >
> > There is a problem here. The new counter pending_retry_bios above
> > doesn't represent the bios which have been added to stripes. So uaf
> > still can happen.
>
> I don't think it can. That counter won't be zero until there are no bios
> that need to get retried. So we way end up waiting too long, but we
> shouldn't ever end up not waiting long enough.

Ah, yes, you're right. I thought wrongly. The counter tracks multiple
threads that encounter BLK_STS_RESOURCE. For each thread,
md_end_clone_bio is called only when all bios return. But why do
different threads need to sync at raid5_make_request?


>
> > Do we need to add a new counter?
>
> I did it that way because I wanted to avoid growing md_io_clone
> ("must_retry" fit nicely in a hole in the structure, so it didn't take
> up any extra space). But if you are fine with adding the extra

Nice design.

> reshape_completion pointer to md_io_clone, then your way avoids the
> chance that we might wait when we don't need to.

If you mention the threads sync here, yes.

>
> > Because
> > md_end_clone_io is only called when all bios return. How about
> > something like:
> >
> > md_end_clone_io
> > +       if (unlikely(READ_ONCE(md_io_clone->waiting_reshape))) {
> > +               complete(md_io_clone->reshape_completion);
> > +       } else {
> > +               bio_endio(orig_bio);
> > +       }
> >
> > raid5_make_request:
> >
> >         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> > -               md_free_cloned_bio(bi);
> > +               struct md_io_clone *md_io_clone =3D bi->bi_private;
> > +               struct completion done;
> > +
> > +               init_completion(&done);
> > +               md_io_clone->reshape_completion =3D &done;
> > +               WRITE_ONCE(md_io_clone->waiting_reshape, 1);
> > +
> > +               bio_endio(bi);
> > +
> > +               wait_for_completion(&done);
>
> This looks fine.
>
> I'm pretty sure that the READ_ONCE() and WRITE_ONCE() are unnecessary.
> First, theres no chance that these operations will ever happen at the
> same time and we're just writing a 1, so there's no chance of tearing.

For the first point, I have a question. They can't happen
simultaneously. But the cache of different CPUs may contain different
values.

>
> The compiler can't reorder setting md_io_clone->waiting_reshape to afer
> bio_endio(), since bio_endio can free md_io_clone. Also the compiler
> can't reorder reading it to before calling md_end_clone_io() from
> bio_endio(), obviously.

Thanks very much for pointing this out.

>
> If the bio was never chained, then there can't be a race, since only
> raid5_make_request() will be calling bio_endio(). waiting_reshape will
> be read by the same process that sets it.
>
> If the bio was chained, then like you said, md_end_clone_io() will only
> get called by the final caller of bio_endio(). This is determined by
> bio_remaining_done(), which guarantees a full memory barrier for
> atomic_dec_and_test(&bio->__bi_remaining).

Nice analysis! Thanks.

>
> Since we know the compiler will keep these instructions on the proper
> size of a full memory barrier, I'm pretty sure that this is concurrency
> race free, even without the READ_ONCE() and WRITE_ONCE(). Like with
> trying to avoid growing md_io_clone, I was trying to keep
> md_end_clone_io() as fast as possible (at least on architectures where
> READ_ONCE can have more of a performance impact) Again, if I'm
> overthinking this (or if my concurrency argument is flawed) feel free to
> ignore me.

Thanks for your patience in explaining the concurrency problem. I
agree with you. And it's better to add comments that describe the
reason and it will help people understand it better.

By the way, the md raid maintainer's email has changed. I fixed the
email address in to list.

Regards
Xiao

>
> -Ben
>
> > Best Regards
> > Xiao
> >
> >
> > >                 return false;
> > >         }
> >
> > >
> > > --
> > > 2.53.0
> > >
>

