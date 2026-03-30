Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0427C36E487
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774885512; cv=none; b=kyxwlhNZeniq11/RbXy45Ul9xnowVVWX5qVjH8vuOOgTMDrD8QipFIlm+jviMnz/9Fw2DgA0incYzPlEHaJ7kX7a0qtCm9JUqS3GcaYuB7iWISG9he/Z2M+O4ly/lVxVLCNGmXYspzxFQXqfR3beP40RPWqgjs+tPkiUsKPGN9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774885512; c=relaxed/simple;
	bh=clMFn6LeqeExwLBSMwZg3FNUW8BmcLV/fu6N7kWmEho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i4Z3WGdrO4O5NHpnBlh6KLgTecgUNK+bkKUx7FQ2qo/+5BtMGi3u9o63D6DSNFTYyidBWYy9stGxwYIvmMAjDAiXxzIQ385zT9HnnKbjHSkX+ZYKg+fagGrINgCQRUx7KGR60OnxYQKoMzlsyu5xsFSlthjpO/zy5/pGIxlHfJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRoUW4nr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRoUW4nr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774885510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2fpwV21eEfYg1bRyhm2N0jS6bpZE9oTFvRhGC6h12M=;
	b=VRoUW4nrdljp4jrS2R7jpEDYicDDkEMsX0KMtz1mColfBxl6oMLKZS+AxvW6NXuJKaxdyq
	rMxS/m2W1/HQ0bgltb9ZFFI/1SBm9Wb+pkksEkF5jc/Rot/nRz+BJ/0k2ow01qHqtp8fN8
	HX48hgzeLsIzQCyV0Lm+P+yqdTH6GuM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-XEU8DE_ePu6WkzHPulMUUw-1; Mon, 30 Mar 2026 11:45:08 -0400
X-MC-Unique: XEU8DE_ePu6WkzHPulMUUw-1
X-Mimecast-MFC-AGG-ID: XEU8DE_ePu6WkzHPulMUUw_1774885507
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a2a203916cso3642332e87.3
        for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 08:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774885507; x=1775490307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q2fpwV21eEfYg1bRyhm2N0jS6bpZE9oTFvRhGC6h12M=;
        b=ndE5fU3YCG9eW1Et6A+kD80s3JCDjnnXQS/zgYbjHNIwlkFeOlR0cqiIAvHBlJv5O7
         1ZA2tfyHqY9chxQ03Ta1wXMUD8UE0/h634nMHOWaQbhohLjJomNUrU3n+dLNPRcvVv6C
         tAm06f3Jth8Hy/gm147hrshzZpiid9BUnzJ8Emg45k3Ifx0YyADvRrSmHD6lgdM7Dw0t
         mrZAJe6BZjB3IeDzzdb0vsNnwzrkeLxaXkFSJSzPUwf8/ElHFC86QbchQSSThZG0msYe
         0WIQuJZlXop+jPw5r+yGnsykoSRYwIImRw1Xd+eGmSqsSlVghrOUdwzWWi/eVr7LACGX
         VZlw==
X-Forwarded-Encrypted: i=1; AJvYcCW+juRdblLb+kUGqlNyuW/rE3LPewEQ8/gW1bPU+KRDHP5HGzpYV3n/WsDRH9paEPjs5+UAzYKzTA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzHTRaq8qFcBib08rSapKzMuOtqY3p5DdwfFzEId4GF2rtGmucl
	X7txWDpTTh6XZh9sBycGCw9O4a7/UNZ5UMEAnRDhsSyhbovm36A4UTplKJhL5oIoyP+Ongy+Ql6
	wvTqG5TgzEF8JHbd4lZpoecNzQMBICsQrVYFhAtRbl+CpfmPIixBm39lfw721HnOV1oW43By8/I
	41i7nZNMCrZIngM9bmYsKQHLBsJL9O4YJbcO4=
X-Gm-Gg: ATEYQzxnP1cegDDScTVVXSqeictBfXuDn2fhARsFPn7SR8u0xq6C9UxA16phpQE4v8i
	jfAG1H5cDB292cuOAvTvgoXj5m3Ij1U855LgWCY9U71bTfjoGANg3qGdKWW5gjOS0kDlTcJ0rug
	bmIcPG4CA4UJ9MrMbOdl25M9Qyj/vkNCN/P/lYLrc/doHGNDp2M5xfXzC+RLqGDicK4O8y09h56
	Uw+6wiIEHCe94bSmg5LnB7M8E+rrGrTwdXKKKmwS71X1kczb59GqEopqOeciz3L8HhK8+EiFhFD
	c4N9vA==
X-Received: by 2002:ac2:5d68:0:b0:5a2:afe8:78b9 with SMTP id 2adb3069b0e04-5a2afe87992mr2267606e87.13.1774885506653;
        Mon, 30 Mar 2026 08:45:06 -0700 (PDT)
X-Received: by 2002:ac2:5d68:0:b0:5a2:afe8:78b9 with SMTP id
 2adb3069b0e04-5a2afe87992mr2267594e87.13.1774885505976; Mon, 30 Mar 2026
 08:45:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260323225836.1037060-1-bmarzins@redhat.com>
In-Reply-To: <20260323225836.1037060-1-bmarzins@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 30 Mar 2026 23:44:54 +0800
X-Gm-Features: AQROBzAusW0h_JAHf1ndCyc4ClNsKn5fTH_vR62bKIDn10uFapGpXm-4FYxhVvg
Message-ID: <CALTww29P_jZ-n9GMgFG0EW_N22vUsGAPJ5OGn5Lw8yfEpEoGOw@mail.gmail.com>
Subject: Re: [RFC PATCH] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	Nigel Croxon <ncroxon@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hepZNr9fAOnpQ1cUr649Ye0GTeuP9IFEE-QtMd9b89g_1774885507
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 6:58=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
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
> position while the reshape can't make progress are flagged as needing a
> retry, and mddev tracks the number of bios needing a retry which have
> not yet completed. When raid5_make_request() has a bio that failed
> make_stripe_request() with STRIPE_WAIT_RESHAPE, it waits for this
> counter to reach zero. When the bio_endio() is called for the last time
> on a bio needing a retry, it decrements mddev's count of outstanding
> bios needing a retry. This guarantees that raid5_make_request() doesn't
> return until the cloned bio needing a retry for io across the reshape
> boundary is safely cleaned up.
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
> I've tested this for regressions with the lvm2-testsuite raid tests. I
> have not run any md-specific tests on it.
>
>
>  drivers/md/md.c    | 30 +++++++++---------------------
>  drivers/md/md.h    |  5 ++++-
>  drivers/md/raid5.c |  8 +++++++-
>  3 files changed, 20 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ce6f9e9d38e..5ec116b9da32 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -776,9 +776,11 @@ int mddev_init(struct mddev *mddev)
>         atomic_set(&mddev->active, 1);
>         atomic_set(&mddev->openers, 0);
>         atomic_set(&mddev->sync_seq, 0);
> +       atomic_set(&mddev->pending_retry_bios, 0);
>         spin_lock_init(&mddev->lock);
>         init_waitqueue_head(&mddev->sb_wait);
>         init_waitqueue_head(&mddev->recovery_wait);
> +       init_waitqueue_head(&mddev->retry_bios_wait);
>         mddev->reshape_position =3D MaxSector;
>         mddev->reshape_backwards =3D 0;
>         mddev->last_sync_action =3D ACTION_IDLE;
> @@ -9218,6 +9220,7 @@ static void md_end_clone_io(struct bio *bio)
>         struct md_io_clone *md_io_clone =3D bio->bi_private;
>         struct bio *orig_bio =3D md_io_clone->orig_bio;
>         struct mddev *mddev =3D md_io_clone->mddev;
> +       unsigned int must_retry =3D md_io_clone->must_retry;
>
>         if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mdde=
v, false))
>                 md_bitmap_end(mddev, md_io_clone);
> @@ -9229,7 +9232,11 @@ static void md_end_clone_io(struct bio *bio)
>                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
>
>         bio_put(bio);
> -       bio_endio(orig_bio);
> +       if (unlikely(must_retry)) {
> +               if (atomic_dec_and_test(&mddev->pending_retry_bios))
> +                       wake_up(&mddev->retry_bios_wait);
> +       } else
> +               bio_endio(orig_bio);
>         percpu_ref_put(&mddev->active_io);
>  }
>
> @@ -9243,6 +9250,7 @@ static void md_clone_bio(struct mddev *mddev, struc=
t bio **bio)
>         md_io_clone =3D container_of(clone, struct md_io_clone, bio_clone=
);
>         md_io_clone->orig_bio =3D *bio;
>         md_io_clone->mddev =3D mddev;
> +       md_io_clone->must_retry =3D 0;
>         if (blk_queue_io_stat(bdev->bd_disk->queue))
>                 md_io_clone->start_time =3D bio_start_io_acct(*bio);
>
> @@ -9265,26 +9273,6 @@ void md_account_bio(struct mddev *mddev, struct bi=
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
> index ac84289664cd..49a231f11676 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -626,6 +626,9 @@ struct mddev {
>
>         /* The sequence number for sync thread */
>         atomic_t sync_seq;
> +
> +       wait_queue_head_t               retry_bios_wait;
> +       atomic_t                        pending_retry_bios;
>  };
>
>  enum recovery_flags {
> @@ -877,6 +880,7 @@ struct md_io_clone {
>         sector_t        offset;
>         unsigned long   sectors;
>         enum stat_group rw;
> +       unsigned int    must_retry;
>         struct bio      bio_clone;
>  };
>
> @@ -917,7 +921,6 @@ extern void md_finish_reshape(struct mddev *mddev);
>  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>                         struct bio *bio, sector_t start, sector_t size);
>  void md_account_bio(struct mddev *mddev, struct bio **bio);
> -void md_free_cloned_bio(struct bio *bio);
>
>  extern bool __must_check md_flush_request(struct mddev *mddev, struct bi=
o *bio);
>  void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a8e8d431071b..fb78a757f2fd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6217,7 +6217,13 @@ static bool raid5_make_request(struct mddev *mddev=
, struct bio * bi)
>
>         mempool_free(ctx, conf->ctx_pool);
>         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> -               md_free_cloned_bio(bi);
> +               struct md_io_clone *md_io_clone =3D bi->bi_private;
> +
> +               md_io_clone->must_retry =3D 1;
> +               atomic_inc(&mddev->pending_retry_bios);
> +               bio_endio(bi);
> +               wait_event(mddev->retry_bios_wait,
> +                          atomic_read(&mddev->pending_retry_bios)=3D=3D0=
);

Hi Ben

There is a problem here. The new counter pending_retry_bios above
doesn't represent the bios which have been added to stripes. So uaf
still can happen. Do we need to add a new counter? Because
md_end_clone_io is only called when all bios return. How about
something like:

md_end_clone_io
+       if (unlikely(READ_ONCE(md_io_clone->waiting_reshape))) {
+               complete(md_io_clone->reshape_completion);
+       } else {
+               bio_endio(orig_bio);
+       }

raid5_make_request:

        if (res =3D=3D STRIPE_WAIT_RESHAPE) {
-               md_free_cloned_bio(bi);
+               struct md_io_clone *md_io_clone =3D bi->bi_private;
+               struct completion done;
+
+               init_completion(&done);
+               md_io_clone->reshape_completion =3D &done;
+               WRITE_ONCE(md_io_clone->waiting_reshape, 1);
+
+               bio_endio(bi);
+
+               wait_for_completion(&done);

Best Regards
Xiao


>                 return false;
>         }

>
> --
> 2.53.0
>

