Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4825B3890EC
	for <dm-devel@lists.linux.dev>; Wed,  8 Apr 2026 11:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647376; cv=none; b=OTw1LvVR3+npokEfVLXQZSbyBsPYD4tHv7PVuec7fevjfg8hrbAdr/o0vcnh2sqBS7Iz+0R5a8kbABLnJUTG+rajPV358d9XpgHXNiMBaLlWJAR4a5gKsrhCsvNS185sDdvWh9eXhzMnZe2ZkM86osxd7uznUlx5F3ah2qU9ms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647376; c=relaxed/simple;
	bh=0VuHqHHpyW+7Ubv1yMXWzlWnTsewZQjIdtzyFEq/Ncs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mPu0AitBKYNL6J4KhwsEvg9A50xeJh2qHjW9xnQTydWfK3ASwaAWkQCVjz2yo/hfjUVLAgwcqiTgbBZIg8dM4klxMoWs0AhWt6+JV0JRwSwT6wTjt2v523+RDQUWPOa/rD1nTeATKtBQE+NFnLKVWEcfrlW+olyMvp8PxONILy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U42mv9+N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U42mv9+N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775647373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TNKMWuYgUc5fzKKqw/32Wp+3lRPes9FnP7bh6GZ+Vio=;
	b=U42mv9+NW5P/6PLw69SBqZfRhlf6JDlOHZKuLxxydpv6husLRXH1Xf3qxNRGb91nmWShrM
	D1eJeNB4aNAvVVuKM/b1qvexbMaw7YxSkKSUN8TP1QWzMbpmGfiVKCbujWVdKrbx2eFLFr
	iVZby+LU7BRp5MZQMq6sOBskCY9ZuFg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-BMGZMCP9MAq3y5jAlIbF_A-1; Wed, 08 Apr 2026 07:22:52 -0400
X-MC-Unique: BMGZMCP9MAq3y5jAlIbF_A-1
X-Mimecast-MFC-AGG-ID: BMGZMCP9MAq3y5jAlIbF_A_1775647371
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a2c98f8b69so4747592e87.3
        for <dm-devel@lists.linux.dev>; Wed, 08 Apr 2026 04:22:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775647370; x=1776252170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TNKMWuYgUc5fzKKqw/32Wp+3lRPes9FnP7bh6GZ+Vio=;
        b=ODJU26yxJNFPPFFZH7D/+Y7bSDmGm/l8bk8fqxunYOTqDem1TeohcoAoxwzmNLhvGM
         ANwW8o9P/7PJWrBXTUIqBTwEPKw/2PlP8TC3Dn/U29dHZE+18wJH+cdnSaBYOY+DlpU9
         VRl+rzVo2wHzbNBMAVhUlEwYVaiZ9pr+KSg36ePx4Fbu/RYtRb3t7+PVwpRAigJ6tqMK
         mWWkBw4zHN30YnPetrTQgK/0GXIzDe/Yin4OQ3Mn8qDYU1D6ezJzWfiRbMZhAsqjnRsU
         XpoGxs1njbYIQCRXoGObs9R/L7U/aJ5iEx8eLXdYPuXD0/ixYHZgcUw6G4kzOjaorKUQ
         kmhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVscjcjBOHa98aWHr7Zl04YmWvKq5MWg02ogJx934+Ud2X91nVlGg95cel2wDNvR9T/WM9pjJ3RlQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxTrKFvQU8U4V1btZLmRnT+9sEkxXr/LxJQiWs1UuOLnlvPR/v9
	pvylEFrx6QI+rLtQ5cDGev/tYizaiTteORQWiMUUSA3Go2XLl3I/DUyC35dHv/vwHjfXPdnJALP
	k5YRJ9d7tzQ98DfW/ZAzg3qO19npTHVFr/gWv1gx6BL4j9dNayXIQbiQu/sUUntiJGLvtQP2H58
	LFlAI85VavzD4HArXgi5CxatK2lMSp03F37vA=
X-Gm-Gg: AeBDietuQ2K7iVxTYQyLgoj9vUatpO5ilcRKQdiR5p362VarS36LljbNkWkaaqOWbvo
	XWRqKJGbRsdmEL8ceHMuVFbsNWI8nNQVVl2P+5bPkeWKTyAkUHqxNvT5yQawmEmMCfpw927xRjg
	O53pG/A/wnEQ1EdhbXzvYYKcAb3hcAsGrHGjJm6LMwZLeprrmB4h+Y70lr3aO57QPf60WWcC+nQ
	LvVRYJZWuIFUcPXb8lFq3RWl83PJvMCKhXPfivsMApxYUXgdCYBGOUXawPqLEi/vYiDp3J4EUH1
	1/lvfw==
X-Received: by 2002:a05:6512:1151:b0:5a1:448b:317b with SMTP id 2adb3069b0e04-5a337591959mr8247518e87.42.1775647370297;
        Wed, 08 Apr 2026 04:22:50 -0700 (PDT)
X-Received: by 2002:a05:6512:1151:b0:5a1:448b:317b with SMTP id
 2adb3069b0e04-5a337591959mr8247500e87.42.1775647369709; Wed, 08 Apr 2026
 04:22:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260408043548.1695157-1-bmarzins@redhat.com>
In-Reply-To: <20260408043548.1695157-1-bmarzins@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 8 Apr 2026 19:22:38 +0800
X-Gm-Features: AQROBzCf6Y1kVpCeNIdFbfFk6n__k5koH8VEiLhimoVQ-nWfueuWBkFtItAN2Ik
Message-ID: <CALTww28H_Qs_Oh0WkDFvVynvbyUhgUK9u0cuU7bpoF+jOg1mYA@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G1zGUi4RG-T3jjKux_BE_1P_5RaRopLSWhm-xdhNbNY_1775647371
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 8, 2026 at 12:35=E2=80=AFPM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> raid5_make_request() will free the cloned bio. But raid5_make_request()
> can call make_stripe_request() multiple times, writing to the various
> stripes. If that bio got added to the toread or towrite lists of a
> stripe disk in an earlier call to make_stripe_request(), then it's not
> safe to just free the bio if a later part of it is found to cross the
> reshape position. Doing so can lead to a UAF error, when bio_endio()
> is called on the bio for the earlier stripes.
>
> Instead, raid5_make_request() needs to wait until all parts of the bio
> have called bio_endio(). To do this, bios that cross the reshape
> position while the reshape can't make progress are flagged as needing to
> wait for all parts to complete. When raid5_make_request() has a bio that
> failed make_stripe_request() with STRIPE_WAIT_RESHAPE, it sets
> bi->bi_private to a completion struct and waits for completion after
> ending the bio.  When the bio_endio() is called for the last time on a
> clone bio with bi->bi_private set, it wakes up the waiter. This
> guarantees that raid5_make_request() doesn't return until the cloned bio
> needing a retry for io across the reshape boundary is safely cleaned up.
>
> There is a simple reproducer available at [1]. Compile the kernel with
> KASAN for more useful reporting when the error is triggered (this is not
> necessary to see the bug).
>
> [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>
> Changes from v1:
> - Removed mddev->pending_retry_bios, mddev->retry_bios_wait, and
>   md_io_clone->must_retry. Instead, use a completion struct
>   pointed to by bi->bi_private, as suggested by Xiao Ni and Yu Kuai.
>
>  drivers/md/md.c    | 31 ++++++++-----------------------
>  drivers/md/md.h    |  1 -
>  drivers/md/raid5.c |  7 ++++++-
>  3 files changed, 14 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e..4318d875a5f6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9215,9 +9215,11 @@ static void md_bitmap_end(struct mddev *mddev, str=
uct md_io_clone *md_io_clone)
>
>  static void md_end_clone_io(struct bio *bio)
>  {
> -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> +       struct md_io_clone *md_io_clone =3D container_of(bio, struct md_i=
o_clone,
> +                                                      bio_clone);
>         struct bio *orig_bio =3D md_io_clone->orig_bio;
>         struct mddev *mddev =3D md_io_clone->mddev;
> +       struct completion *reshape_completion =3D bio->bi_private;
>
>         if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mdde=
v, false))
>                 md_bitmap_end(mddev, md_io_clone);
> @@ -9229,7 +9231,10 @@ static void md_end_clone_io(struct bio *bio)
>                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
>
>         bio_put(bio);
> -       bio_endio(orig_bio);
> +       if (unlikely(reshape_completion))
> +               complete(reshape_completion);
> +       else
> +               bio_endio(orig_bio);
>         percpu_ref_put(&mddev->active_io);
>  }
>
> @@ -9254,7 +9259,7 @@ static void md_clone_bio(struct mddev *mddev, struc=
t bio **bio)
>         }
>
>         clone->bi_end_io =3D md_end_clone_io;
> -       clone->bi_private =3D md_io_clone;
> +       clone->bi_private =3D NULL;
>         *bio =3D clone;
>  }
>
> @@ -9265,26 +9270,6 @@ void md_account_bio(struct mddev *mddev, struct bi=
o **bio)
>  }
>  EXPORT_SYMBOL_GPL(md_account_bio);
>
> -void md_free_cloned_bio(struct bio *bio)
> -{
> -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> -       struct bio *orig_bio =3D md_io_clone->orig_bio;
> -       struct mddev *mddev =3D md_io_clone->mddev;
> -
> -       if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mdde=
v, false))
> -               md_bitmap_end(mddev, md_io_clone);
> -
> -       if (bio->bi_status && !orig_bio->bi_status)
> -               orig_bio->bi_status =3D bio->bi_status;
> -
> -       if (md_io_clone->start_time)
> -               bio_end_io_acct(orig_bio, md_io_clone->start_time);
> -
> -       bio_put(bio);
> -       percpu_ref_put(&mddev->active_io);
> -}
> -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> -
>  /* md_allow_write(mddev)
>   * Calling this ensures that the array is marked 'active' so that writes
>   * may proceed without blocking.  It is important to call this before
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..5d57fee22901 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -917,7 +917,6 @@ extern void md_finish_reshape(struct mddev *mddev);
>  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>                         struct bio *bio, sector_t start, sector_t size);
>  void md_account_bio(struct mddev *mddev, struct bio **bio);
> -void md_free_cloned_bio(struct bio *bio);
>
>  extern bool __must_check md_flush_request(struct mddev *mddev, struct bi=
o *bio);
>  void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..dc0c680ca199 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6217,7 +6217,12 @@ static bool raid5_make_request(struct mddev *mddev=
, struct bio * bi)
>
>         mempool_free(ctx, conf->ctx_pool);
>         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> -               md_free_cloned_bio(bi);
> +               DECLARE_COMPLETION_ONSTACK(done);
> +               WRITE_ONCE(bi->bi_private, &done);
> +
> +               bio_endio(bi);

Hi Ben

You gave an explanation why it doesn't need WRITE_ONCE. As you said,
bio_endio uses atomic_dec_and_test, so it guarantees a full memory
barrier. Why do you use WRITE_ONCE here?

Regards
Xiao


> +
> +               wait_for_completion(&done);
>                 return false;
>         }
>
> --
> 2.53.0
>

