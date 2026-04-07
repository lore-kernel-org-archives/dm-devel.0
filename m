Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB543B38AB
	for <dm-devel@lists.linux.dev>; Tue,  7 Apr 2026 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775564628; cv=none; b=aeGNt9g+BF0cF237+UOFRpH8y/zYnmekMvX8j1u1SC5Po0PkH0rL2ajbmW/yFD116CLN9Tlr5Wc6UUeXsLOsTOgj2kvCLO7x62Laxi/TYOnbVI+H6BL6tC/D+Y7TfRAGDGlfwnPhgSHr/xp2bX/r6pltuTGdad+F+b/PeunTiOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775564628; c=relaxed/simple;
	bh=6D86sy9WePtc+OSZox6c+/FVvPsL1Z8aYrYJ4rtjmHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I74YWo9wYYjjqJvUXbLR93PcaZ1A9y50vDn/rVnV/3/USSXJOkJnt0EnE0O+w1OO3ShqIUFkIaymr7rzFMSgSwzW9LwAxSKZaHgUUziWshrcH/WUC5i9PvayvItlZN0st2EkJyhqO0gDc8Nkhgq2o2nsIS75dZQZuiY9Sormj+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bU8Vxl49; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bU8Vxl49"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775564626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TC5PRAGD04xpgIgUmlvLgovUN1STWMt/VgKtsrgDa04=;
	b=bU8Vxl490mLsaJeGsfBIFpXvpy7sEzAjIzBS0JjqfD4ohNJBJ2TnfCkDUSC1SpFzXoyPeE
	XCU7gu42JPie7Yu9vUWhKKkmCSWCVXhiPe1PjfCzlHkuyHLWovb8P/6e/6ACAsi1dBTMzA
	gmLSl/e/9GJPMRGh7T8IWjrAMBzUmdE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-LJjnNectNyyGoSm6fTo2PQ-1; Tue, 07 Apr 2026 08:23:42 -0400
X-MC-Unique: LJjnNectNyyGoSm6fTo2PQ-1
X-Mimecast-MFC-AGG-ID: LJjnNectNyyGoSm6fTo2PQ_1775564621
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a2c9141ed4so3016543e87.0
        for <dm-devel@lists.linux.dev>; Tue, 07 Apr 2026 05:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775564621; x=1776169421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TC5PRAGD04xpgIgUmlvLgovUN1STWMt/VgKtsrgDa04=;
        b=FBrEBQgOE2LVrjL6QjooecZJjae6lzpGGTZH2h7u65OE/6TaQc6m15zJuoOavkGgRk
         apLkDyS+zRpSYqGb9ympGlC4q0ivwvqq/tOshxBwWHtOrsxP3jQaJrLLgG8tZdQojR1L
         Vqb42Bo0O53R9da4OJ9LIwxpz+v0rLGP18EDwzn1Zyq281RgdK71w8xUmr6q4SkudTWv
         IPtJooZ+xl3twa6Oqi7MmWHj5O2LUwV5oo1OtiKIHdJQJxljZNpbXqAqANwtaGUiu4pq
         dUZuQ9XefEbazKfv7AxI4COkuNQ1LBSAs4UkNvZ4yEApxMQrfGS5w6XEFOEM/eaWXYX4
         vHnQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+zDq+TIl+StAHerWH4/bFyszfL6Jc5cbQtmjAK2IcgZiR75w+ezcGAFo5mu0kJbJkQds2Hgxrug==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy98HdNKJSTolWkbjDrxWnca4YRBAlUUcbyiqzmpi9Z1Fx4k00D
	sbYt+yNMnOL9hUGms/TyQwVFxSWA0v2zEUTiXOS1qGFSGxhjU7w/dGPcWyFoqfD6NTTw5beuYJF
	S1mXJip5HcjPb6od7i465+m+C9fFNDaL2EB/fdYw5/VOQr0w0wVIRjeeEw0Bx8niGvsMMWdj+Ld
	r2XgNqwTu0gUhYOuZ9gN28GGbpnZtZBWxnaG0=
X-Gm-Gg: AeBDiesie+nvZ7vVVr4OwNnaT5VgZDqt20ddyRsOKEnoljiiUTQWiJa8KD3D0ZoR2oF
	4IxufmqPm3FY1AWLUbenPVZOQQ06zi7T0HKqYL8QvajynjzXg+YefWXG7y5ddnQnP3LUGnegCs1
	wTlE5EKOLut1VNlB2i0yaUzEDC0wRYzbtDQXIFh6V80dq9NOa1L6mZsOzV2RB37daNuXgCKw700
	E6BxlHbZ4xL+/ad/f40hseVcGD5NttmoocndVMayd5WcvwMUiNSb09L2SzGuH/R5u53SlJ/tHk5
	xsNXDA==
X-Received: by 2002:a05:6512:1087:b0:5a2:7d1a:4043 with SMTP id 2adb3069b0e04-5a3375809bdmr4896992e87.20.1775564620799;
        Tue, 07 Apr 2026 05:23:40 -0700 (PDT)
X-Received: by 2002:a05:6512:1087:b0:5a2:7d1a:4043 with SMTP id
 2adb3069b0e04-5a3375809bdmr4896984e87.20.1775564620061; Tue, 07 Apr 2026
 05:23:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260323225836.1037060-1-bmarzins@redhat.com> <CALTww29P_jZ-n9GMgFG0EW_N22vUsGAPJ5OGn5Lw8yfEpEoGOw@mail.gmail.com>
 <acrMIhAjB-HKszbs@redhat.com> <CALTww2-SE6b7bQ93ZbJ3N_Xxgrm4b8rv6Sukjt5cUVNHScPFRg@mail.gmail.com>
 <acv4A6WayrNbQEax@redhat.com> <CALTww29gvZBft7-WGwY_-hZCnrxbAK3AAZf-AmGKn7M1t0-0rw@mail.gmail.com>
 <f510f801-ae2c-4fe1-b3c2-0346d4237a9c@fnnas.com>
In-Reply-To: <f510f801-ae2c-4fe1-b3c2-0346d4237a9c@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 7 Apr 2026 20:23:28 +0800
X-Gm-Features: AQROBzCiuGU_ofFDMat7SJx0VNocaG-_4QtvBm88Eoe3TOak76QJ46oOJG6txvs
Message-ID: <CALTww29Q-7W3Bs9oAbJJFxyTOohBa2sN=zTV17X8Wu=8POZiJA@mail.gmail.com>
Subject: Re: [RFC PATCH] md/raid5: Fix UAF on IO across the reshape position
To: yukuai@fnnas.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>, 
	Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qn0XZKGWfa8coujfwvlcOvaviYt2SF2EJdSMW5dam0s_1775564621
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 2:25=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/4/1 8:22, Xiao Ni =E5=86=99=E9=81=93:
> > On Wed, Apr 1, 2026 at 12:36=E2=80=AFAM Benjamin Marzinski <bmarzins@re=
dhat.com> wrote:
> >> On Tue, Mar 31, 2026 at 10:24:48AM +0800, Xiao Ni wrote:
> >>> On Tue, Mar 31, 2026 at 3:16=E2=80=AFAM Benjamin Marzinski <bmarzins@=
redhat.com> wrote:
> >>>> On Mon, Mar 30, 2026 at 11:44:54PM +0800, Xiao Ni wrote:
> >>>>> On Tue, Mar 24, 2026 at 6:58=E2=80=AFAM Benjamin Marzinski <bmarzin=
s@redhat.com> wrote:
> >>>>>> If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> >>>>>> raid5_make_request() will free the cloned bio. But raid5_make_requ=
est()
> >>>>>> can call make_stripe_request() multiple times, writing to the vari=
ous
> >>>>>> stripes. If that bio got added to the toread or towrite lists of a
> >>>>>> stripe disk in an earlier call to make_stripe_request(), then it's=
 not
> >>>>>> safe to just free the bio if a later part of it is found to cross =
the
> >>>>>> reshape position. Doing so can lead to a UAF error, when bio_endio=
()
> >>>>>> is called on the bio for the earlier stripes.
> >>>>>>
> >>>>>> Instead, raid5_make_request() needs to wait until all parts of the=
 bio
> >>>>>> have called bio_endio(). To do this, bios that cross the reshape
> >>>>>> position while the reshape can't make progress are flagged as need=
ing a
> >>>>>> retry, and mddev tracks the number of bios needing a retry which h=
ave
> >>>>>> not yet completed. When raid5_make_request() has a bio that failed
> >>>>>> make_stripe_request() with STRIPE_WAIT_RESHAPE, it waits for this
> >>>>>> counter to reach zero. When the bio_endio() is called for the last=
 time
> >>>>>> on a bio needing a retry, it decrements mddev's count of outstandi=
ng
> >>>>>> bios needing a retry. This guarantees that raid5_make_request() do=
esn't
> >>>>>> return until the cloned bio needing a retry for io across the resh=
ape
> >>>>>> boundary is safely cleaned up.
> >>>>>>
> >>>>>> There is a simple reproducer available at [1]. Compile the kernel =
with
> >>>>>> KASAN for more useful reporting when the error is triggered (this =
is not
> >>>>>> necessary to see the bug).
> >>>>>>
> >>>>>> [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241=
fa5
> >>>>>>
> >>>>>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >>>>>> ---
> >>>>>>
> >>>>>> I've tested this for regressions with the lvm2-testsuite raid test=
s. I
> >>>>>> have not run any md-specific tests on it.
> >>>>>>
> >>>>>>
> >>>>>>   drivers/md/md.c    | 30 +++++++++---------------------
> >>>>>>   drivers/md/md.h    |  5 ++++-
> >>>>>>   drivers/md/raid5.c |  8 +++++++-
> >>>>>>   3 files changed, 20 insertions(+), 23 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>>>>> index 3ce6f9e9d38e..5ec116b9da32 100644
> >>>>>> --- a/drivers/md/md.c
> >>>>>> +++ b/drivers/md/md.c
> >>>>>> @@ -776,9 +776,11 @@ int mddev_init(struct mddev *mddev)
> >>>>>>          atomic_set(&mddev->active, 1);
> >>>>>>          atomic_set(&mddev->openers, 0);
> >>>>>>          atomic_set(&mddev->sync_seq, 0);
> >>>>>> +       atomic_set(&mddev->pending_retry_bios, 0);
> >>>>>>          spin_lock_init(&mddev->lock);
> >>>>>>          init_waitqueue_head(&mddev->sb_wait);
> >>>>>>          init_waitqueue_head(&mddev->recovery_wait);
> >>>>>> +       init_waitqueue_head(&mddev->retry_bios_wait);
> >>>>>>          mddev->reshape_position =3D MaxSector;
> >>>>>>          mddev->reshape_backwards =3D 0;
> >>>>>>          mddev->last_sync_action =3D ACTION_IDLE;
> >>>>>> @@ -9218,6 +9220,7 @@ static void md_end_clone_io(struct bio *bio)
> >>>>>>          struct md_io_clone *md_io_clone =3D bio->bi_private;
> >>>>>>          struct bio *orig_bio =3D md_io_clone->orig_bio;
> >>>>>>          struct mddev *mddev =3D md_io_clone->mddev;
> >>>>>> +       unsigned int must_retry =3D md_io_clone->must_retry;
> >>>>>>
> >>>>>>          if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enab=
led(mddev, false))
> >>>>>>                  md_bitmap_end(mddev, md_io_clone);
> >>>>>> @@ -9229,7 +9232,11 @@ static void md_end_clone_io(struct bio *bio=
)
> >>>>>>                  bio_end_io_acct(orig_bio, md_io_clone->start_time=
);
> >>>>>>
> >>>>>>          bio_put(bio);
> >>>>>> -       bio_endio(orig_bio);
> >>>>>> +       if (unlikely(must_retry)) {
> >>>>>> +               if (atomic_dec_and_test(&mddev->pending_retry_bios=
))
> >>>>>> +                       wake_up(&mddev->retry_bios_wait);
> >>>>>> +       } else
> >>>>>> +               bio_endio(orig_bio);
> >>>>>>          percpu_ref_put(&mddev->active_io);
> >>>>>>   }
> >>>>>>
> >>>>>> @@ -9243,6 +9250,7 @@ static void md_clone_bio(struct mddev *mddev=
, struct bio **bio)
> >>>>>>          md_io_clone =3D container_of(clone, struct md_io_clone, b=
io_clone);
> >>>>>>          md_io_clone->orig_bio =3D *bio;
> >>>>>>          md_io_clone->mddev =3D mddev;
> >>>>>> +       md_io_clone->must_retry =3D 0;
> >>>>>>          if (blk_queue_io_stat(bdev->bd_disk->queue))
> >>>>>>                  md_io_clone->start_time =3D bio_start_io_acct(*bi=
o);
> >>>>>>
> >>>>>> @@ -9265,26 +9273,6 @@ void md_account_bio(struct mddev *mddev, st=
ruct bio **bio)
> >>>>>>   }
> >>>>>>   EXPORT_SYMBOL_GPL(md_account_bio);
> >>>>>>
> >>>>>> -void md_free_cloned_bio(struct bio *bio)
> >>>>>> -{
> >>>>>> -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> >>>>>> -       struct bio *orig_bio =3D md_io_clone->orig_bio;
> >>>>>> -       struct mddev *mddev =3D md_io_clone->mddev;
> >>>>>> -
> >>>>>> -       if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabl=
ed(mddev, false))
> >>>>>> -               md_bitmap_end(mddev, md_io_clone);
> >>>>>> -
> >>>>>> -       if (bio->bi_status && !orig_bio->bi_status)
> >>>>>> -               orig_bio->bi_status =3D bio->bi_status;
> >>>>>> -
> >>>>>> -       if (md_io_clone->start_time)
> >>>>>> -               bio_end_io_acct(orig_bio, md_io_clone->start_time)=
;
> >>>>>> -
> >>>>>> -       bio_put(bio);
> >>>>>> -       percpu_ref_put(&mddev->active_io);
> >>>>>> -}
> >>>>>> -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> >>>>>> -
> >>>>>>   /* md_allow_write(mddev)
> >>>>>>    * Calling this ensures that the array is marked 'active' so tha=
t writes
> >>>>>>    * may proceed without blocking.  It is important to call this b=
efore
> >>>>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >>>>>> index ac84289664cd..49a231f11676 100644
> >>>>>> --- a/drivers/md/md.h
> >>>>>> +++ b/drivers/md/md.h
> >>>>>> @@ -626,6 +626,9 @@ struct mddev {
> >>>>>>
> >>>>>>          /* The sequence number for sync thread */
> >>>>>>          atomic_t sync_seq;
> >>>>>> +
> >>>>>> +       wait_queue_head_t               retry_bios_wait;
> >>>>>> +       atomic_t                        pending_retry_bios;
> >>>>>>   };
> >>>>>>
> >>>>>>   enum recovery_flags {
> >>>>>> @@ -877,6 +880,7 @@ struct md_io_clone {
> >>>>>>          sector_t        offset;
> >>>>>>          unsigned long   sectors;
> >>>>>>          enum stat_group rw;
> >>>>>> +       unsigned int    must_retry;
> >>>>>>          struct bio      bio_clone;
> >>>>>>   };
> >>>>>>
> >>>>>> @@ -917,7 +921,6 @@ extern void md_finish_reshape(struct mddev *md=
dev);
> >>>>>>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *=
rdev,
> >>>>>>                          struct bio *bio, sector_t start, sector_t=
 size);
> >>>>>>   void md_account_bio(struct mddev *mddev, struct bio **bio);
> >>>>>> -void md_free_cloned_bio(struct bio *bio);
> >>>>>>
> >>>>>>   extern bool __must_check md_flush_request(struct mddev *mddev, s=
truct bio *bio);
> >>>>>>   void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev=
,
> >>>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >>>>>> index a8e8d431071b..fb78a757f2fd 100644
> >>>>>> --- a/drivers/md/raid5.c
> >>>>>> +++ b/drivers/md/raid5.c
> >>>>>> @@ -6217,7 +6217,13 @@ static bool raid5_make_request(struct mddev=
 *mddev, struct bio * bi)
> >>>>>>
> >>>>>>          mempool_free(ctx, conf->ctx_pool);
> >>>>>>          if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> >>>>>> -               md_free_cloned_bio(bi);
> >>>>>> +               struct md_io_clone *md_io_clone =3D bi->bi_private=
;
> >>>>>> +
> >>>>>> +               md_io_clone->must_retry =3D 1;
> >>>>>> +               atomic_inc(&mddev->pending_retry_bios);
> >>>>>> +               bio_endio(bi);
> >>>>>> +               wait_event(mddev->retry_bios_wait,
> >>>>>> +                          atomic_read(&mddev->pending_retry_bios)=
=3D=3D0);
> >>>>> Hi Ben
> >>>>>
> >>>>> There is a problem here. The new counter pending_retry_bios above
> >>>>> doesn't represent the bios which have been added to stripes. So uaf
> >>>>> still can happen.
> >>>> I don't think it can. That counter won't be zero until there are no =
bios
> >>>> that need to get retried. So we way end up waiting too long, but we
> >>>> shouldn't ever end up not waiting long enough.
> >>> Ah, yes, you're right. I thought wrongly. The counter tracks multiple
> >>> threads that encounter BLK_STS_RESOURCE. For each thread,
> >>> md_end_clone_bio is called only when all bios return. But why do
> >>> different threads need to sync at raid5_make_request?
> >>>
> >>>
> >>>>> Do we need to add a new counter?
> >>>> I did it that way because I wanted to avoid growing md_io_clone
> >>>> ("must_retry" fit nicely in a hole in the structure, so it didn't ta=
ke
> >>>> up any extra space). But if you are fine with adding the extra
> >>> Nice design.
> >>>
> >>>> reshape_completion pointer to md_io_clone, then your way avoids the
> >>>> chance that we might wait when we don't need to.
> >>> If you mention the threads sync here, yes.
> >> I can certainly add comments explaining why I left off the READ_ONCE()=
,
> >> WRITE_ONCE() (actually, there's no real reason not to keep the
> >> WRITE_ONCE, since that's not in the fast path) if you think it makes
> >> sense to leave them off.
> >>
> >> I'm fine with either my or your code for to deal with the waiting,
> >> whichever you think makes more sense. Since this is a very hard bug to
> >> hit, and the fix involves adding extra data to every bio and extra cod=
e
> >> in the end_io function that all the raid bios call, I wanted to make t=
he
> >> impact as small as possible. But md_io_clone is still 8 bytes away fro=
m
> >> filling up 3 cachelines (at 64 bytes a cacheline), so there's space to
> >> add the reshape_completion pointer without increaseing the number of
> >> cachelines, which means that your solution for waiting is probably the
> >> way to go, unless you think something else might end up needing that
> >> space.
>
> I think it's not good to add a global counter in mddev, and I agree it's
> not good to increase md_io_clone for this corner case.
>
> How about we remove the use of bi_private filed, and replace it with
> container_of() to get md_clone_io from md_end_clone_io. And then we can u=
se
> this field to record the completion without adding new field.

This is a nice design. Ben, will you send V2?

Regards
Xiao

>
> > Thanks. After thinking, as you said, this is a corner case. So both
> > ways are fine with me also. Let's wait for Kuai's decision.
> >
> > Regards
> > Xiao
> >> -Ben
> >>
> >>>>> Because
> >>>>> md_end_clone_io is only called when all bios return. How about
> >>>>> something like:
> >>>>>
> >>>>> md_end_clone_io
> >>>>> +       if (unlikely(READ_ONCE(md_io_clone->waiting_reshape))) {
> >>>>> +               complete(md_io_clone->reshape_completion);
> >>>>> +       } else {
> >>>>> +               bio_endio(orig_bio);
> >>>>> +       }
> >>>>>
> >>>>> raid5_make_request:
> >>>>>
> >>>>>          if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> >>>>> -               md_free_cloned_bio(bi);
> >>>>> +               struct md_io_clone *md_io_clone =3D bi->bi_private;
> >>>>> +               struct completion done;
> >>>>> +
> >>>>> +               init_completion(&done);
> >>>>> +               md_io_clone->reshape_completion =3D &done;
> >>>>> +               WRITE_ONCE(md_io_clone->waiting_reshape, 1);
> >>>>> +
> >>>>> +               bio_endio(bi);
> >>>>> +
> >>>>> +               wait_for_completion(&done);
> >>>> This looks fine.
> >>>>
> >>>> I'm pretty sure that the READ_ONCE() and WRITE_ONCE() are unnecessar=
y.
> >>>> First, theres no chance that these operations will ever happen at th=
e
> >>>> same time and we're just writing a 1, so there's no chance of tearin=
g.
> >>> For the first point, I have a question. They can't happen
> >>> simultaneously. But the cache of different CPUs may contain different
> >>> values.
> >>>
> >>>> The compiler can't reorder setting md_io_clone->waiting_reshape to a=
fer
> >>>> bio_endio(), since bio_endio can free md_io_clone. Also the compiler
> >>>> can't reorder reading it to before calling md_end_clone_io() from
> >>>> bio_endio(), obviously.
> >>> Thanks very much for pointing this out.
> >>>
> >>>> If the bio was never chained, then there can't be a race, since only
> >>>> raid5_make_request() will be calling bio_endio(). waiting_reshape wi=
ll
> >>>> be read by the same process that sets it.
> >>>>
> >>>> If the bio was chained, then like you said, md_end_clone_io() will o=
nly
> >>>> get called by the final caller of bio_endio(). This is determined by
> >>>> bio_remaining_done(), which guarantees a full memory barrier for
> >>>> atomic_dec_and_test(&bio->__bi_remaining).
> >>> Nice analysis! Thanks.
> >>>
> >>>> Since we know the compiler will keep these instructions on the prope=
r
> >>>> size of a full memory barrier, I'm pretty sure that this is concurre=
ncy
> >>>> race free, even without the READ_ONCE() and WRITE_ONCE(). Like with
> >>>> trying to avoid growing md_io_clone, I was trying to keep
> >>>> md_end_clone_io() as fast as possible (at least on architectures whe=
re
> >>>> READ_ONCE can have more of a performance impact) Again, if I'm
> >>>> overthinking this (or if my concurrency argument is flawed) feel fre=
e to
> >>>> ignore me.
> >>> Thanks for your patience in explaining the concurrency problem. I
> >>> agree with you. And it's better to add comments that describe the
> >>> reason and it will help people understand it better.
> >>>
> >>> By the way, the md raid maintainer's email has changed. I fixed the
> >>> email address in to list.
> >>>
> >>> Regards
> >>> Xiao
> >>>
> >>>> -Ben
> >>>>
> >>>>> Best Regards
> >>>>> Xiao
> >>>>>
> >>>>>
> >>>>>>                  return false;
> >>>>>>          }
> >>>>>> --
> >>>>>> 2.53.0
> >>>>>>
> >
> --
> Thansk,
> Kuai
>

