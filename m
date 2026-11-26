Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795660664;
	b=FLnt+c5WuK559aL5w9SzhKSnHX9KMgUgu0+A6w4oAJwQ2rzxfjQWhQ0MJZU/N707P2C5
	 yWYOwzdSlKkJEArwnvNMFVC7weXq4crBfQVVGw6OLeso3zeE4chROzPM2kXE2kil7O3VT
	 ECSM93VilcbHX8M/2V8t0aDVm6tPuNKf57v6wu0SfzlvUUDo3OYDIHudrQUam5bli/qfX
	 4ddzj3dY/NOgZBeecqNcc02MbwxDWNwNUCMliXhrBGxfc48TnBbqoXcGuk0gNX++JObV+
	 qTRsGizXe+yVC0ITaG+6D0X5d0KuKftr0odkHP8nSrZcErjMopeHc64zV+64WQBEuow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795660664;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=RZCvtCpBQTwzTPj93Oiy8qbxhXrLbrBIt1jl3I4qtj4=;
	b=m4cxEUrMCNkbj2tOmbMmvDEhz6AiIchgEX4k+hZEcf+uUupyQQXQKw4hzaPcOl+wUeam
	 gfMQ/NzoJgXr4Xqfqg7+ETE2EbLk/56gALXGYR1TFpAg9I+TlXl+VLKGxaIV+hVah03WK
	 Nxe0H0gnL/y/dAt2BtzjJJAmVqOVLNYbXuMnKv+JY9lPd2dvNGDK0k+A3Z9bxube/WPNp
	 kMbIgP3ExOPdYTTq5+38/kTCvC3njKSm8Yxy7xHVMs6nXTXpC6iRODOvIU53WLMSJyVC0
	 xbjAp00WiqqggFBGd/wTEXH8EqWPhpfZ79AEsjrfRCL06PSg9sXDlNxHsaVhgZBuRsw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WhmYFZPy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.49
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA023606A31E
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 02:37:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA023606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WhmYFZPy
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-67990a45e02so6609212d50.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 18:37:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795660663; cv=none;
        d=google.com; s=arc-20260327;
        b=aGvRHfpV9l0bPr81VWPYnRQbGC2HrqnbWUmILwMp+erVEvn6s+OnweO6wk4IW02QBr
         vJ6Q1xP3duw94LK//zRQJCse57r6pAcM7H+SUIoHjN+FB/A0tIPLL5fNhQbChivN1mxT
         uIWfZJ3zlTVXQPKKVNwrqnFe5+I9bHqDzARzKNKxB7NkBBmfk87xxR4L0dlJ5FmsEejx
         Xjs+ezD50gUztZ4Q2wGi0aKPeOc0plhgVKszqZbQ+uLWVr7MeKAoovsG3x3+Qw6H7Pg9
         ldiVziH18FFSxBcDXCbeORiENIzMC9XyYzJKcNp0AntB0eYes0J4qbemGkDb40j0kX2E
         KvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RZCvtCpBQTwzTPj93Oiy8qbxhXrLbrBIt1jl3I4qtj4=;
        fh=cu1mrLmRqZ7GT07/GOzDHESE+JVEAIKq0yGJUF/W7XQ=;
        b=aHbSRBH2oFj90BMsEpjwT9VtiISzZC3xDbnoRO77BKDqOBi8/y9CiFjHuseX/W7und
         ARxL3hNbJQ6qRd9ldCslqN9i5PZgLLLhymzqxp0X6lMo6Afde4ABkFFgnlo8WJDPa/cZ
         DBR0IYgb0sB0DQYDy0d3P8PWquj9Zu+8P5DrowIkwUMJzvuMVvRfK84KynqTTE/RdssM
         OAwRhzb6lB4S2wW4ag0yMJxhdVHJ2EIymeHVLpXKG5D4XJ6JV2QBGcZn1rhZSunlOxHv
         ym68TrBOtlfyiAunJRwZgr5Xt1y+f+r5iJQaKRQU6CnOqTCEIE60tPbsUSIk1k6yJOSe
         HuFQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795660663; x=1796265463; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RZCvtCpBQTwzTPj93Oiy8qbxhXrLbrBIt1jl3I4qtj4=;
        b=WhmYFZPycvYCmutqWYjw6fNsinp9EpcZlhUHIIL594PtSybvsdSBJVJt8araySp0rk
         Q0kMMd4ZR1l/wXaCS/CDZtWxKuZKxi9WSFdlV5JDbCqnAEGSi0ZDwqcVp7bKcY2Dwev5
         s3GV4RAL5cguNroEy3+r8OrNV61F4L9RRytirhk8y4oT9fYu2DePndhQ16jKOMcuSRsd
         cu34QquoBhg9Pu3hEHnFLO1nKnpGLDpM8Rwtodc0oiR7GO9k6oICn1NA52sL92N2nT8o
         aeG82pwc4xfsBQeQ929apiIB9VjnKtOAgPu/h3IDOsKq9Ij8Pte/s1NcnFhSN28Mugp3
         9MRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795660663; x=1796265463;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RZCvtCpBQTwzTPj93Oiy8qbxhXrLbrBIt1jl3I4qtj4=;
        b=BgCmzt0MVSJwxpVJUBbIllQAcMjqcPjH44BGHzN6/lPzsXwq00dnpxsCl116sBsw/P
         FJCOC6VTb6tG0iua1KU8XtkVwd9IG2gZDJAtz3851hSWs28H1u8jJmPj34F/23eFkfFB
         IfUMCCppy+0YHTpa0NFHavhtjj3T4LEXUX1SkWPMXBvZUMaEgHA5qyaxVjLcuxcLb3Yf
         P6zeZP7lqboHTiqit5Lz3EEX7dUyvfNA+vaD5W6W07n4xQ4hZnRP/GsQ7y3+hWAWXOBX
         G4vdKMa4WgAvZE7JHqV4XZAWJZRi8+6dxzv8gF4nyNo2ydTGaAS/8QPj5ILZYEOE/Eif
         U+VA==
X-Gm-Message-State: APuU4Z8AY1YMZBuZGFHgR6P/KUbGysNK4AD5Jh5di5Ca0B1O43nIwi/Q
	gpstpZ3YyvPLr5WjNmh3BdqU1jRW5xP0ho3sy7kqYy+RZbe1JxGDdsisj3j3lGkvjjYzitcPICz
	PUApJj+5fzLL8488DLOdY3wRnEABWqxQ=
X-Gm-Gg: AZFdTZe9xXCCXgOrrSlyS2WP1CtGQWxZVH1fsKeISjGpFyRS6bOcnR7nYOq1D5e5Ory
	EY9Nz7Vx+r8n3xUABl69Y0qmwvnsAdXIJznOFWxnY2G5TWoCw7R4MZMmWBrMqF1UfapWRxQyYho
	KNJoF/nXYP+XRWBgrRl8zSbeXiqWBJyLYZUTj2a7Cwn40G47q8Vw+qahoQ5mEjWdauHKokwTtUs
	AH+FEIPVnWaqk+ET7K0Q1vgAJz/LGKB4EtytnZmwWUM4mFhJyliYlEPOViBv13w93W6Cno67/51
	/4s5nlJSUbMnTrk1q17YOhUc7WOrCNPod3MFwd2sWIm86qkCCiFA8UW+GTOlBCgBYrsPVXAxTV2
	GgAxJkHakojTAcsUcRlQeoC994RqLAe0tN9xivwwjvb0IvrQvZq0sHwT26RKl9EQcbd51PgFM5r
	Tbpg6A2ASSZ2uAjVoM+cuQNqOfqpm9vDDysO+MIKBWw6Y=
X-Received: by 2002:a05:690e:150a:b0:67d:ba55:4be2 with SMTP id
 956f58d0204a3-67df448c8acmr8960272d50.84.1795660662739; Wed, 25 Nov 2026
 18:37:42 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261126020123.655988-1-ronniesahlberg@gmail.com> <sashiko-outbox-234635@kernel.org>
In-Reply-To: <sashiko-outbox-234635@kernel.org>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 26 Nov 2026 12:37:31 +1000
X-Gm-Features: Aa3M54qk46md5Z6HrozKy32RlJWNl0cqkuhMLD8lZQhCJJGxSrEU8bgQtIxG7Gc
Message-ID: <CAN05THQffU=vr5EGWJbkM4XxyrK1tnbE1T-vPSPwTmYdXAzuVw@mail.gmail.com>
Subject: Re: [PATCH] dm era: read the metadata again at the first resume
To: sashiko-reviews@lists.linux.dev
Cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org, 
	mpatocka@redhat.com, bmarzins@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please disregard this version.  The Sashiko review is right about the
space map index being lost when freshly formatted metadata is reopened,
and the patch overlaps with Denis V. Lunev's series "dm era: a metadata
device that never comes back".  I will send a v2 based on top of that
series.

On Thu, 26 Nov 2026 at 12:22, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential
> issues to consider:
> - [High] dm era: missing activation check in era_message() causes NULL
>   deref
> - [High] dm era: era_activate() reopen loses uncommitted space map index
> - [Medium] dm era: era_preresume() starts digest before rollover and
>   leaks worker
> - [Low] dm era: unused nr_blocks field in struct era after activation
>   refactor
> --
>
> commit a2950a4dea8dcd63e94b69dde9b3323092c96aec
> Author: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>
> dm era: read the metadata again at the first resume
>
> This commit re-reads and resizes the era metadata in the worker at the
> first preresume, and suppresses metadata writes and writeset digestion
> until the target has been activated.
>
> > diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> > index ea499adca4ce2..801ca632581b4 100644
> > --- a/drivers/md/dm-era-target.c
> > +++ b/drivers/md/dm-era-target.c
> [ ... ]
> > @@ -1611,30 +1618,64 @@ static void era_postsuspend(struct dm_target *t=
i)
> >       }
> >  }
> >
> > -static int era_preresume(struct dm_target *ti)
> > +/*
> > + * The metadata was opened by the constructor, but if this table repla=
ces
> > + * another one then that table kept changing the metadata until it was
> > + * suspended.  So read it again now that we are the only user.
> > + *
> > + * Runs in the worker, and commits by itself so that nothing is writte=
n if
> > + * the metadata can't be read.
> > + */
> > +static int era_activate(struct era *era)
> >  {
> >       int r;
> > -     struct era *era =3D ti->private;
> > +     struct era_metadata *md;
> >       dm_block_t new_size =3D calc_nr_blocks(era);
> >
> > -     if (era->nr_blocks !=3D new_size) {
> > -             r =3D metadata_resize(era->md, &new_size);
> > -             if (r) {
> > -                     DMERR("%s: metadata_resize failed", __func__);
> > -                     return r;
> > -             }
> > +     md =3D metadata_open(era->metadata_dev->bdev, era->sectors_per_bl=
ock,
> > +                        false);
> > +     if (IS_ERR(md)) {
> > +             DMERR("%s: couldn't reopen metadata", __func__);
> > +             return PTR_ERR(md);
> > +     }
> >
> > -             r =3D metadata_commit(era->md);
> > -             if (r) {
> > -                     DMERR("%s: metadata_commit failed", __func__);
> > -                     return r;
> > -             }
> > +     metadata_close(era->md);
> > +     era->md =3D md;
>
> [Severity: High]
> When a fresh metadata device is formatted during era_ctr(), does closing
> era->md and reopening it from disk here discard uncommitted in-memory
> space map index updates?
>
> In create_fresh_metadata(), dm_tm_create_with_sm() commits the initial
> space map, and then dm_btree_empty() and dm_array_empty() allocate two
> blocks for writeset_tree_root and era_array_root.  Those allocations
> update smm->ll.mi_le.index[0] in memory, but write_superblock() calls
> save_sm_root() and dm_tm_commit() without calling dm_tm_pre_commit() firs=
t:
>
> drivers/md/dm-era-target.c:create_fresh_metadata() {
>         ...
>         r =3D dm_btree_empty(&md->writeset_tree_info, &md->writeset_tree_=
root);
>         ...
>         r =3D dm_array_empty(&md->era_array_info, &md->era_array_root);
>         ...
>         r =3D write_superblock(md);
> }
>
> Because dm_tm_pre_commit() was not called, sm_metadata_commit() never
> wrote the updated smm->ll.mi_le to the on-disk bitmap_root block.
> Previously the first metadata_commit() in preresume flushed the in-memory
> era->md created by era_ctr(); now metadata_close(era->md) discards it and
> metadata_open() loads the stale bitmap_root from disk, leaving index[0]'s
> nr_free count permanently off by 2 blocks.
>
> > +     memset(&era->digest, 0, sizeof(era->digest));
> > +
> > +     r =3D metadata_resize(md, &new_size);
> > +     if (r) {
> > +             DMERR("%s: metadata_resize failed", __func__);
> > +             return r;
> > +     }
> >
> > -             era->nr_blocks =3D new_size;
> > +     r =3D metadata_commit(md);
> > +     if (r) {
> > +             DMERR("%s: metadata_commit failed", __func__);
> > +             return r;
> >       }
> >
> > +     era->nr_blocks =3D new_size;
>
> [Severity: Low]
> With the era->nr_blocks !=3D new_size check removed from era_preresume(),
> era->nr_blocks is now only ever written to and never read (all other
> places use era->md->nr_blocks).  Can nr_blocks be removed from struct era=
?
>
> > +     WRITE_ONCE(era->activated, true);
> > +
> > +     return 0;
> > +}
> > +
> > +static int era_preresume(struct dm_target *ti)
> > +{
> > +     int r;
> > +     struct era *era =3D ti->private;
> > +
> >       start_worker(era);
> >
> > +     if (!era->activated) {
> > +             struct rpc rpc =3D { .fn_era =3D era_activate, .no_commit=
 =3D true };
> > +
> > +             r =3D perform_rpc(era, &rpc);
> > +             if (r)
> > +                     return r;
> > +     }
> > +
> >       r =3D in_worker0(era, metadata_era_rollover);
> >       if (r) {
> >               DMERR("%s: metadata_era_rollover failed", __func__);
> >               return r;
> >       }
>
> [Severity: Medium]
> If in_worker0(era, metadata_era_rollover) fails here (or a later target i=
n
> the table fails preresume), does era_preresume() leave the worker running
> and digesting writesets on a still-suspended device?
>
> era_activate() sets era->activated =3D true before the rollover RPC is
> queued, and open_metadata() sets md->archived_writesets =3D true.  When
> in_worker0() wakes do_work() for the rollover RPC, do_work() sees
> era->activated =3D=3D true and runs kick_off_digest() and process_old_era=
s()
> before process_rpc_calls(), which re-queues era->worker via wake_worker()=
.
> Because the error paths in era_preresume() do not call stop_worker(era),
> the worker continues running and mutating era->md in the background while
> the device remains suspended, and era_dtr() can later destroy the failed
> table without era_postsuspend() having stopped the worker.
>
> >
> >       return 0;
> >  }
> > @@ -1658,10 +1699,16 @@ static void era_status(struct dm_target *ti, st=
atus_type_t type,
> >       ssize_t sz =3D 0;
> >       struct metadata_stats stats;
> >       char buf[BDEVNAME_SIZE];
> > +     struct rpc rpc =3D { .fn1 =3D metadata_get_stats, .arg =3D &stats=
 };
> >
> >       switch (type) {
> >       case STATUSTYPE_INFO:
> > -             r =3D in_worker1(era, metadata_get_stats, &stats);
> > +             /*
> > +              * Before the first resume our view of the metadata may b=
e
> > +              * stale and must not be written.
> > +              */
> > +             rpc.no_commit =3D !READ_ONCE(era->activated);
> > +             r =3D perform_rpc(era, &rpc);
> >               if (r)
> >                       goto err;
>
> [Severity: High]
> Should era_message() also reject messages while !READ_ONCE(era->activated=
)?
>
> In do_resume(), dm_swap_table() installs the new table as live and drops
> md->suspend_lock before dm_resume() calls era_preresume().  If
> era_activate() fails (or a message arrives after dm_swap_table() before
> era_activate() completes), the table is live with era->activated =3D=3D f=
alse,
> era->suspended =3D=3D 0, and era->md->writesets[0..1].bits =3D=3D NULL (s=
ince
> writeset bitmaps are only allocated by metadata_resize() in
> era_activate()).  A "checkpoint" or "take_metadata_snap" message then run=
s
> metadata_new_era() -> writeset_init() in the worker and dereferences a
> NULL ws->bits pointer when md->nr_blocks > 0, while "drop_metadata_snap"
> commits the stale era->md to disk via in_worker0().
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126020123.65=
5988-1-ronniesahlberg@gmail.com?part=3D1
