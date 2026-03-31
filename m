Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFE23F7887
	for <dm-devel@lists.linux.dev>; Tue, 31 Mar 2026 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974989; cv=none; b=qxdFt/3+Hdc+l+graYhROijt4Bz87AlOuLpj23Dazn2+B3+h6K2/M9e/vMbwhqfomTEnEWWjrPtSGwk6LN3879//MJ/Y4ggzE0mJw8kiufMJobVA1/YK7ahn/eYfo7EZCH0qF1MTE1UTXw9ADj8IdVCoiiByklf0mQUil8AUakU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974989; c=relaxed/simple;
	bh=xYyrWRRgCERX8G+EYE6BmWxabxYhOY92TF/c6W7Gu9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=GRV6P+GwIFhAgHJwTs+01Y/qj0RMLSCvLEpZzDP1+gyhVvVrrLP5LFUpsyEkcIf34YR/nsYtj5wu1W/CZXO2lydYw9g+b75U/jFJTrIaogJiVIkFfOEAp/W84lk4KXjJ1Gu4cc3KbKGFz6zf90h73UTatUwGNq6wz95mb+IYv7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDLK1iHC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDLK1iHC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774974986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UV9IsA6UyjgICP43GKQgP+h4M2y6RZl8PrMu6pTgQbE=;
	b=UDLK1iHCvrUXNSKwoSOQaGaWfQvPt2yqNU0l9MRMg87qu1uSFialSYNBM01hPVqvhAiS3w
	vFNBjsrNh/ViooxxVYPVYC+31Yo3+q5PAehYMIq0L5nBuzaw33V779K9kvSWbEHv7TKnOg
	swKRhM9Q3Hw9aDfmDXuoS3iFWWdEsTw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-153-F53kqXz6OZCEzKP-ocGZBw-1; Tue,
 31 Mar 2026 12:36:23 -0400
X-MC-Unique: F53kqXz6OZCEzKP-ocGZBw-1
X-Mimecast-MFC-AGG-ID: F53kqXz6OZCEzKP-ocGZBw_1774974982
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71A771800344;
	Tue, 31 Mar 2026 16:36:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D79611954102;
	Tue, 31 Mar 2026 16:36:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62VGaJ731414972
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 12:36:19 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62VGaJKW1414971;
	Tue, 31 Mar 2026 12:36:19 -0400
Date: Tue, 31 Mar 2026 12:36:19 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xiao Ni <xni@redhat.com>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
        Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>,
        linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
        Nigel Croxon <ncroxon@redhat.com>
Subject: Re: [RFC PATCH] md/raid5: Fix UAF on IO across the reshape position
Message-ID: <acv4A6WayrNbQEax@redhat.com>
References: <20260323225836.1037060-1-bmarzins@redhat.com>
 <CALTww29P_jZ-n9GMgFG0EW_N22vUsGAPJ5OGn5Lw8yfEpEoGOw@mail.gmail.com>
 <acrMIhAjB-HKszbs@redhat.com>
 <CALTww2-SE6b7bQ93ZbJ3N_Xxgrm4b8rv6Sukjt5cUVNHScPFRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww2-SE6b7bQ93ZbJ3N_Xxgrm4b8rv6Sukjt5cUVNHScPFRg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: p5teDjci3YIpfa1fgw8Z7b8Ti2zK35SpNUmksF-lbcM_1774974982
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Mar 31, 2026 at 10:24:48AM +0800, Xiao Ni wrote:
> On Tue, Mar 31, 2026 at 3:16 AM Benjamin Marzinski <bmarzins@redhat.com> wrote:
> >
> > On Mon, Mar 30, 2026 at 11:44:54PM +0800, Xiao Ni wrote:
> > > On Tue, Mar 24, 2026 at 6:58 AM Benjamin Marzinski <bmarzins@redhat.com> wrote:
> > > >
> > > > If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> > > > raid5_make_request() will free the cloned bio. But raid5_make_request()
> > > > can call make_stripe_request() multiple times, writing to the various
> > > > stripes. If that bio got added to the toread or towrite lists of a
> > > > stripe disk in an earlier call to make_stripe_request(), then it's not
> > > > safe to just free the bio if a later part of it is found to cross the
> > > > reshape position. Doing so can lead to a UAF error, when bio_endio()
> > > > is called on the bio for the earlier stripes.
> > > >
> > > > Instead, raid5_make_request() needs to wait until all parts of the bio
> > > > have called bio_endio(). To do this, bios that cross the reshape
> > > > position while the reshape can't make progress are flagged as needing a
> > > > retry, and mddev tracks the number of bios needing a retry which have
> > > > not yet completed. When raid5_make_request() has a bio that failed
> > > > make_stripe_request() with STRIPE_WAIT_RESHAPE, it waits for this
> > > > counter to reach zero. When the bio_endio() is called for the last time
> > > > on a bio needing a retry, it decrements mddev's count of outstanding
> > > > bios needing a retry. This guarantees that raid5_make_request() doesn't
> > > > return until the cloned bio needing a retry for io across the reshape
> > > > boundary is safely cleaned up.
> > > >
> > > > There is a simple reproducer available at [1]. Compile the kernel with
> > > > KASAN for more useful reporting when the error is triggered (this is not
> > > > necessary to see the bug).
> > > >
> > > > [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5
> > > >
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > >
> > > > I've tested this for regressions with the lvm2-testsuite raid tests. I
> > > > have not run any md-specific tests on it.
> > > >
> > > >
> > > >  drivers/md/md.c    | 30 +++++++++---------------------
> > > >  drivers/md/md.h    |  5 ++++-
> > > >  drivers/md/raid5.c |  8 +++++++-
> > > >  3 files changed, 20 insertions(+), 23 deletions(-)
> > > >
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index 3ce6f9e9d38e..5ec116b9da32 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -776,9 +776,11 @@ int mddev_init(struct mddev *mddev)
> > > >         atomic_set(&mddev->active, 1);
> > > >         atomic_set(&mddev->openers, 0);
> > > >         atomic_set(&mddev->sync_seq, 0);
> > > > +       atomic_set(&mddev->pending_retry_bios, 0);
> > > >         spin_lock_init(&mddev->lock);
> > > >         init_waitqueue_head(&mddev->sb_wait);
> > > >         init_waitqueue_head(&mddev->recovery_wait);
> > > > +       init_waitqueue_head(&mddev->retry_bios_wait);
> > > >         mddev->reshape_position = MaxSector;
> > > >         mddev->reshape_backwards = 0;
> > > >         mddev->last_sync_action = ACTION_IDLE;
> > > > @@ -9218,6 +9220,7 @@ static void md_end_clone_io(struct bio *bio)
> > > >         struct md_io_clone *md_io_clone = bio->bi_private;
> > > >         struct bio *orig_bio = md_io_clone->orig_bio;
> > > >         struct mddev *mddev = md_io_clone->mddev;
> > > > +       unsigned int must_retry = md_io_clone->must_retry;
> > > >
> > > >         if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
> > > >                 md_bitmap_end(mddev, md_io_clone);
> > > > @@ -9229,7 +9232,11 @@ static void md_end_clone_io(struct bio *bio)
> > > >                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
> > > >
> > > >         bio_put(bio);
> > > > -       bio_endio(orig_bio);
> > > > +       if (unlikely(must_retry)) {
> > > > +               if (atomic_dec_and_test(&mddev->pending_retry_bios))
> > > > +                       wake_up(&mddev->retry_bios_wait);
> > > > +       } else
> > > > +               bio_endio(orig_bio);
> > > >         percpu_ref_put(&mddev->active_io);
> > > >  }
> > > >
> > > > @@ -9243,6 +9250,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
> > > >         md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
> > > >         md_io_clone->orig_bio = *bio;
> > > >         md_io_clone->mddev = mddev;
> > > > +       md_io_clone->must_retry = 0;
> > > >         if (blk_queue_io_stat(bdev->bd_disk->queue))
> > > >                 md_io_clone->start_time = bio_start_io_acct(*bio);
> > > >
> > > > @@ -9265,26 +9273,6 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(md_account_bio);
> > > >
> > > > -void md_free_cloned_bio(struct bio *bio)
> > > > -{
> > > > -       struct md_io_clone *md_io_clone = bio->bi_private;
> > > > -       struct bio *orig_bio = md_io_clone->orig_bio;
> > > > -       struct mddev *mddev = md_io_clone->mddev;
> > > > -
> > > > -       if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
> > > > -               md_bitmap_end(mddev, md_io_clone);
> > > > -
> > > > -       if (bio->bi_status && !orig_bio->bi_status)
> > > > -               orig_bio->bi_status = bio->bi_status;
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
> > > >   * Calling this ensures that the array is marked 'active' so that writes
> > > >   * may proceed without blocking.  It is important to call this before
> > > > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > > > index ac84289664cd..49a231f11676 100644
> > > > --- a/drivers/md/md.h
> > > > +++ b/drivers/md/md.h
> > > > @@ -626,6 +626,9 @@ struct mddev {
> > > >
> > > >         /* The sequence number for sync thread */
> > > >         atomic_t sync_seq;
> > > > +
> > > > +       wait_queue_head_t               retry_bios_wait;
> > > > +       atomic_t                        pending_retry_bios;
> > > >  };
> > > >
> > > >  enum recovery_flags {
> > > > @@ -877,6 +880,7 @@ struct md_io_clone {
> > > >         sector_t        offset;
> > > >         unsigned long   sectors;
> > > >         enum stat_group rw;
> > > > +       unsigned int    must_retry;
> > > >         struct bio      bio_clone;
> > > >  };
> > > >
> > > > @@ -917,7 +921,6 @@ extern void md_finish_reshape(struct mddev *mddev);
> > > >  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
> > > >                         struct bio *bio, sector_t start, sector_t size);
> > > >  void md_account_bio(struct mddev *mddev, struct bio **bio);
> > > > -void md_free_cloned_bio(struct bio *bio);
> > > >
> > > >  extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
> > > >  void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> > > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > index a8e8d431071b..fb78a757f2fd 100644
> > > > --- a/drivers/md/raid5.c
> > > > +++ b/drivers/md/raid5.c
> > > > @@ -6217,7 +6217,13 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
> > > >
> > > >         mempool_free(ctx, conf->ctx_pool);
> > > >         if (res == STRIPE_WAIT_RESHAPE) {
> > > > -               md_free_cloned_bio(bi);
> > > > +               struct md_io_clone *md_io_clone = bi->bi_private;
> > > > +
> > > > +               md_io_clone->must_retry = 1;
> > > > +               atomic_inc(&mddev->pending_retry_bios);
> > > > +               bio_endio(bi);
> > > > +               wait_event(mddev->retry_bios_wait,
> > > > +                          atomic_read(&mddev->pending_retry_bios)==0);
> > >
> > > Hi Ben
> > >
> > > There is a problem here. The new counter pending_retry_bios above
> > > doesn't represent the bios which have been added to stripes. So uaf
> > > still can happen.
> >
> > I don't think it can. That counter won't be zero until there are no bios
> > that need to get retried. So we way end up waiting too long, but we
> > shouldn't ever end up not waiting long enough.
> 
> Ah, yes, you're right. I thought wrongly. The counter tracks multiple
> threads that encounter BLK_STS_RESOURCE. For each thread,
> md_end_clone_bio is called only when all bios return. But why do
> different threads need to sync at raid5_make_request?
> 
> 
> >
> > > Do we need to add a new counter?
> >
> > I did it that way because I wanted to avoid growing md_io_clone
> > ("must_retry" fit nicely in a hole in the structure, so it didn't take
> > up any extra space). But if you are fine with adding the extra
> 
> Nice design.
> 
> > reshape_completion pointer to md_io_clone, then your way avoids the
> > chance that we might wait when we don't need to.
> 
> If you mention the threads sync here, yes.

I can certainly add comments explaining why I left off the READ_ONCE(),
WRITE_ONCE() (actually, there's no real reason not to keep the
WRITE_ONCE, since that's not in the fast path) if you think it makes
sense to leave them off.

I'm fine with either my or your code for to deal with the waiting,
whichever you think makes more sense. Since this is a very hard bug to
hit, and the fix involves adding extra data to every bio and extra code
in the end_io function that all the raid bios call, I wanted to make the
impact as small as possible. But md_io_clone is still 8 bytes away from
filling up 3 cachelines (at 64 bytes a cacheline), so there's space to
add the reshape_completion pointer without increaseing the number of
cachelines, which means that your solution for waiting is probably the
way to go, unless you think something else might end up needing that
space.

-Ben
 
> >
> > > Because
> > > md_end_clone_io is only called when all bios return. How about
> > > something like:
> > >
> > > md_end_clone_io
> > > +       if (unlikely(READ_ONCE(md_io_clone->waiting_reshape))) {
> > > +               complete(md_io_clone->reshape_completion);
> > > +       } else {
> > > +               bio_endio(orig_bio);
> > > +       }
> > >
> > > raid5_make_request:
> > >
> > >         if (res == STRIPE_WAIT_RESHAPE) {
> > > -               md_free_cloned_bio(bi);
> > > +               struct md_io_clone *md_io_clone = bi->bi_private;
> > > +               struct completion done;
> > > +
> > > +               init_completion(&done);
> > > +               md_io_clone->reshape_completion = &done;
> > > +               WRITE_ONCE(md_io_clone->waiting_reshape, 1);
> > > +
> > > +               bio_endio(bi);
> > > +
> > > +               wait_for_completion(&done);
> >
> > This looks fine.
> >
> > I'm pretty sure that the READ_ONCE() and WRITE_ONCE() are unnecessary.
> > First, theres no chance that these operations will ever happen at the
> > same time and we're just writing a 1, so there's no chance of tearing.
> 
> For the first point, I have a question. They can't happen
> simultaneously. But the cache of different CPUs may contain different
> values.
> 
> >
> > The compiler can't reorder setting md_io_clone->waiting_reshape to afer
> > bio_endio(), since bio_endio can free md_io_clone. Also the compiler
> > can't reorder reading it to before calling md_end_clone_io() from
> > bio_endio(), obviously.
> 
> Thanks very much for pointing this out.
> 
> >
> > If the bio was never chained, then there can't be a race, since only
> > raid5_make_request() will be calling bio_endio(). waiting_reshape will
> > be read by the same process that sets it.
> >
> > If the bio was chained, then like you said, md_end_clone_io() will only
> > get called by the final caller of bio_endio(). This is determined by
> > bio_remaining_done(), which guarantees a full memory barrier for
> > atomic_dec_and_test(&bio->__bi_remaining).
> 
> Nice analysis! Thanks.
> 
> >
> > Since we know the compiler will keep these instructions on the proper
> > size of a full memory barrier, I'm pretty sure that this is concurrency
> > race free, even without the READ_ONCE() and WRITE_ONCE(). Like with
> > trying to avoid growing md_io_clone, I was trying to keep
> > md_end_clone_io() as fast as possible (at least on architectures where
> > READ_ONCE can have more of a performance impact) Again, if I'm
> > overthinking this (or if my concurrency argument is flawed) feel free to
> > ignore me.
> 
> Thanks for your patience in explaining the concurrency problem. I
> agree with you. And it's better to add comments that describe the
> reason and it will help people understand it better.
> 
> By the way, the md raid maintainer's email has changed. I fixed the
> email address in to list.
> 
> Regards
> Xiao
> 
> >
> > -Ben
> >
> > > Best Regards
> > > Xiao
> > >
> > >
> > > >                 return false;
> > > >         }
> > >
> > > >
> > > > --
> > > > 2.53.0
> > > >
> >

