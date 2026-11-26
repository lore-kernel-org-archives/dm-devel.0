Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795659779;
	b=qXsk7eh8E5WyBW/csahuzWAvJDlLzinwox5WGRiW91sj+U9GAHGYpHSXfGVbw8Hx3dCl
	 PwfP1XC2c6f1lLckRD/37exMnH4376YGYmi6C3JahpXSJv/8+S+cPgNaAE5GUqPDmEjrH
	 nJwACmuvj3Z4mAWdSSkUs8BjqlQf88fr3qv9xDR8oDDBHWQ3Y0y7UThT3cl2+ZoqnO+ON
	 Iga2TihWKoPjd3vBVal4/xQ5SjRk0JEa7DvcNxNht57Aiqu0AZMNZkGcS8pBLA2yRTzYk
	 pLMZ+N0ONQ9b2qTTMJ2kStPpat0UJf7cQ62DVYXntrNOJh2muVH9tmm+BeVKF2iPzCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795659779;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bPpzBa4CNvWWM9EGf6ZA+4CsKTyrhf2i3wNZVKmPEzM=;
	b=xcZAZixw3nUdL0Z75PwA32UJyGpj1aq1vwvE7u3UZDcKNBObFaDE12B4MoevpYHag4dN
	 ReIuEQkHORNsGqMhzynZ2mOVl0TsMSnAQekpQrJJeSwle6WXLAl5Md5d5FA9kZDclfUqc
	 VsSAkyiSnHasps2dnPpvYaHj3QY0HQCtpeiA8oHB1hTYFkr0NQrUrKwLrbZrgVfazAtdh
	 NeRZ68IiR1Miy/AuzFtPglvZ0wDfFPHwRWDRQ8BETUbIO5vpX/gUIB1vO7bOg/F8oQ9SD
	 K9sTYg1uWCnSQczwlr98UtLswtTBPZzno465bipEi7OUTmiFDpO4h2F0Z2jc942LObA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="dBpJ/D9X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6FB606A321
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 02:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dBpJ/D9X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A461F000CF;
	Thu, 26 Nov 2026 02:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795659778;
	bh=bPpzBa4CNvWWM9EGf6ZA+4CsKTyrhf2i3wNZVKmPEzM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dBpJ/D9XdPRkyE60HUudsOdA5meB/4yZdqi/R7v2MlMgcsdwD2sCkm7+nqnii1MVp
	 Qxf22sz79I9SRy0Gu1pDxR7SrdHAiOcxYaNGEEND0WkDlQcKZwN4bb8vXCt9foNKhe
	 Wz0K0XBazZHmKihApiX8z8oAfp2QIcYDIuR6agJHNjGBNR7GLbd0zgk8EvnPC23nI+
	 5+su9lceHfh8veehdbTzTo8pQvbZAsw6cUNKq79pb9zQUCDlxvDFb3zUYiTXbdSl/h
	 brRpZlefRD0oYDFGPcinLb3X690NFB1M59SOT9sA7KMBZBW4RVK8dcd6bmy/w0Wu5k
	 +pm8BwR919q7w==
Message-ID: <sashiko-outbox-234635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm era: read the metadata again at the first resume
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ronnie Sahlberg" <ronniesahlberg@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com
In-Reply-To: <20261126020123.655988-1-ronniesahlberg@gmail.com>
References: <20261126020123.655988-1-ronniesahlberg@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 02:22:57 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] dm era: missing activation check in era_message() causes NULL
  deref
- [High] dm era: era_activate() reopen loses uncommitted space map index
- [Medium] dm era: era_preresume() starts digest before rollover and
  leaks worker
- [Low] dm era: unused nr_blocks field in struct era after activation
  refactor
--

commit a2950a4dea8dcd63e94b69dde9b3323092c96aec
Author: Ronnie Sahlberg <ronniesahlberg@gmail.com>

dm era: read the metadata again at the first resume

This commit re-reads and resizes the era metadata in the worker at the
first preresume, and suppresses metadata writes and writeset digestion
until the target has been activated.

> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> index ea499adca4ce2..801ca632581b4 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
[ ... ]
> @@ -1611,30 +1618,64 @@ static void era_postsuspend(struct dm_target *ti)
>  	}
>  }
> =20
> -static int era_preresume(struct dm_target *ti)
> +/*
> + * The metadata was opened by the constructor, but if this table replaces
> + * another one then that table kept changing the metadata until it was
> + * suspended.  So read it again now that we are the only user.
> + *
> + * Runs in the worker, and commits by itself so that nothing is written =
if
> + * the metadata can't be read.
> + */
> +static int era_activate(struct era *era)
>  {
>  	int r;
> -	struct era *era =3D ti->private;
> +	struct era_metadata *md;
>  	dm_block_t new_size =3D calc_nr_blocks(era);
> =20
> -	if (era->nr_blocks !=3D new_size) {
> -		r =3D metadata_resize(era->md, &new_size);
> -		if (r) {
> -			DMERR("%s: metadata_resize failed", __func__);
> -			return r;
> -		}
> +	md =3D metadata_open(era->metadata_dev->bdev, era->sectors_per_block,
> +			   false);
> +	if (IS_ERR(md)) {
> +		DMERR("%s: couldn't reopen metadata", __func__);
> +		return PTR_ERR(md);
> +	}
> =20
> -		r =3D metadata_commit(era->md);
> -		if (r) {
> -			DMERR("%s: metadata_commit failed", __func__);
> -			return r;
> -		}
> +	metadata_close(era->md);
> +	era->md =3D md;

[Severity: High]
When a fresh metadata device is formatted during era_ctr(), does closing
era->md and reopening it from disk here discard uncommitted in-memory
space map index updates?

In create_fresh_metadata(), dm_tm_create_with_sm() commits the initial
space map, and then dm_btree_empty() and dm_array_empty() allocate two
blocks for writeset_tree_root and era_array_root.  Those allocations
update smm->ll.mi_le.index[0] in memory, but write_superblock() calls
save_sm_root() and dm_tm_commit() without calling dm_tm_pre_commit() first:

drivers/md/dm-era-target.c:create_fresh_metadata() {
	...
	r =3D dm_btree_empty(&md->writeset_tree_info, &md->writeset_tree_root);
	...
	r =3D dm_array_empty(&md->era_array_info, &md->era_array_root);
	...
	r =3D write_superblock(md);
}

Because dm_tm_pre_commit() was not called, sm_metadata_commit() never
wrote the updated smm->ll.mi_le to the on-disk bitmap_root block.
Previously the first metadata_commit() in preresume flushed the in-memory
era->md created by era_ctr(); now metadata_close(era->md) discards it and
metadata_open() loads the stale bitmap_root from disk, leaving index[0]'s
nr_free count permanently off by 2 blocks.

> +	memset(&era->digest, 0, sizeof(era->digest));
> +
> +	r =3D metadata_resize(md, &new_size);
> +	if (r) {
> +		DMERR("%s: metadata_resize failed", __func__);
> +		return r;
> +	}
> =20
> -		era->nr_blocks =3D new_size;
> +	r =3D metadata_commit(md);
> +	if (r) {
> +		DMERR("%s: metadata_commit failed", __func__);
> +		return r;
>  	}
> =20
> +	era->nr_blocks =3D new_size;

[Severity: Low]
With the era->nr_blocks !=3D new_size check removed from era_preresume(),
era->nr_blocks is now only ever written to and never read (all other
places use era->md->nr_blocks).  Can nr_blocks be removed from struct era?

> +	WRITE_ONCE(era->activated, true);
> +
> +	return 0;
> +}
> +
> +static int era_preresume(struct dm_target *ti)
> +{
> +	int r;
> +	struct era *era =3D ti->private;
> +
>  	start_worker(era);
> =20
> +	if (!era->activated) {
> +		struct rpc rpc =3D { .fn_era =3D era_activate, .no_commit =3D true };
> +
> +		r =3D perform_rpc(era, &rpc);
> +		if (r)
> +			return r;
> +	}
> +
>  	r =3D in_worker0(era, metadata_era_rollover);
>  	if (r) {
>  		DMERR("%s: metadata_era_rollover failed", __func__);
>  		return r;
>  	}

[Severity: Medium]
If in_worker0(era, metadata_era_rollover) fails here (or a later target in
the table fails preresume), does era_preresume() leave the worker running
and digesting writesets on a still-suspended device?

era_activate() sets era->activated =3D true before the rollover RPC is
queued, and open_metadata() sets md->archived_writesets =3D true.  When
in_worker0() wakes do_work() for the rollover RPC, do_work() sees
era->activated =3D=3D true and runs kick_off_digest() and process_old_eras()
before process_rpc_calls(), which re-queues era->worker via wake_worker().
Because the error paths in era_preresume() do not call stop_worker(era),
the worker continues running and mutating era->md in the background while
the device remains suspended, and era_dtr() can later destroy the failed
table without era_postsuspend() having stopped the worker.

> =20
>  	return 0;
>  }
> @@ -1658,10 +1699,16 @@ static void era_status(struct dm_target *ti, stat=
us_type_t type,
>  	ssize_t sz =3D 0;
>  	struct metadata_stats stats;
>  	char buf[BDEVNAME_SIZE];
> +	struct rpc rpc =3D { .fn1 =3D metadata_get_stats, .arg =3D &stats };
> =20
>  	switch (type) {
>  	case STATUSTYPE_INFO:
> -		r =3D in_worker1(era, metadata_get_stats, &stats);
> +		/*
> +		 * Before the first resume our view of the metadata may be
> +		 * stale and must not be written.
> +		 */
> +		rpc.no_commit =3D !READ_ONCE(era->activated);
> +		r =3D perform_rpc(era, &rpc);
>  		if (r)
>  			goto err;

[Severity: High]
Should era_message() also reject messages while !READ_ONCE(era->activated)?

In do_resume(), dm_swap_table() installs the new table as live and drops
md->suspend_lock before dm_resume() calls era_preresume().  If
era_activate() fails (or a message arrives after dm_swap_table() before
era_activate() completes), the table is live with era->activated =3D=3D fal=
se,
era->suspended =3D=3D 0, and era->md->writesets[0..1].bits =3D=3D NULL (sin=
ce
writeset bitmaps are only allocated by metadata_resize() in
era_activate()).  A "checkpoint" or "take_metadata_snap" message then runs
metadata_new_era() -> writeset_init() in the worker and dereferences a
NULL ws->bits pointer when md->nr_blocks > 0, while "drop_metadata_snap"
commits the stale era->md to disk via in_worker0().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126020123.6559=
88-1-ronniesahlberg@gmail.com?part=3D1
