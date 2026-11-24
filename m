Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795562963;
	b=ZQHLjNyxNJ1zW8fe08c+gnyi1pAYble61670ctSmsVZxKM4McF4x1D/j9Mu+huJXvk0H
	 M1buZ2aaSS7nijyMgS9gewMAL2iJ9hhho3vJ7jBIvK8sinf7fMxc0hXQfH2Vt0ChCsZOf
	 jgpY3J/gYAM1PMWIB+dS6T7sJfIR4kOMClF0BGq9+t9XPOJsZoL4E7ASetUnhCo1rfuhP
	 4uMv/GwQ3iVR9DA9d/1NPgojSQLXTbVGIY5YboNVVWvuXPdVm/snJJO4J+o5hDIoYa6/U
	 1RUbwspdonXxaa6e1rk7nWNS2UzgXl/m9Fupofv0XFDUm8BhumPBAgnT03T0DnOh61A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795562963;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5de2y9f3Or4nDvnChY7AZR91CsjEcbpNaS2qDqXcxwk=;
	b=QafAGAVRJH6vadvPj9Wlg6h7V2wfOL9djFJwUAdzvO9g362diBC7BKdqm9wkqgQdc/MG
	 Hw0mZ4r87M+lz2j2htNvqFUnybdm4fXy/iau8kcfzLW9b7xC9q3vtn1PI+2rY6z+q5ip9
	 mr0IemjcPSed+a1g5ZTL+D1hN28yG+eLjajLb6bR3Ch89p+T0Ez46yU3jh5LrNlSvFCkM
	 /vUpYCLvygtn1hUUoBvaOL9bEV2tjfAtc8eLed+36djL7ww3uLtGmNzKhod6/zNwfwFrq
	 DP0kHP6g5/rohAPvyQjiw91gIhXNACKW/HfRFcLfMocm4QWnrZi8BOTITjauRI3h0dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ml2k39dI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18F2606A31E
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 23:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ml2k39dI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9701F01569;
	Tue, 24 Nov 2026 23:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795562963;
	bh=5de2y9f3Or4nDvnChY7AZR91CsjEcbpNaS2qDqXcxwk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ml2k39dI/Ce5yn9GuEyf4tm79nY8vwtz8j6NHHWvkDRLWiTwCebvjyirE8qdzLQih
	 q71l9Hvh6TvfOHxleCwep837mDKwGAEaKolIQ1nkWa+DUl+ddK21ucIiHD0zbAA8S+
	 6r9ALPcLChhahAeT0JJfDYIJduRrGaeDAnpumSl/Z0iNyEqkIi5etTG7oG6SCAhb5v
	 BJlEExx7nDkm8+k27aUvbMauUz1FgvZLrEaQRyXC3vmML00e7dvCb9vClnMW+iuKro
	 ESkDMT2pSNhXkiNQO3r5Lb2xQQ9F7HFdpVsNNuX4UEUKF2JOKk/upqqzijQgi2x+Vq
	 dPPofvgQDW6FQ==
Message-ID: <sashiko-outbox-232230@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] dm era: add lazy mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ronnie Sahlberg" <ronniesahlberg@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com, ejt@redhat.com
In-Reply-To: <20261124230651.494303-1-ronniesahlberg@gmail.com>
References: <20261124230651.494303-1-ronniesahlberg@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 23:29:22 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] dm era: incomplete metadata snapshot in metadata_take_snap()
- [Medium] dm era: premature clearing of invalidation flags in
  metadata_era_rollover()
--

commit c7e0d839221a7af599bacfffe68cbee06cb7fae0
Author: Ronnie Sahlberg <ronniesahlberg@gmail.com>

dm era: add lazy mode

This commit adds an optional "lazy" feature mode to dm-era that records new=
ly
written blocks in memory and flushes them on later metadata commits while
marking the on-disk superblock dirty until all pending bits are persisted.

> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> index ea499adca4ce2..298b376ff785b 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c

[ ... ]

> @@ -946,7 +1053,47 @@ static int metadata_new_era(struct era_metadata *md)
>  	return 0;
>  }
> =20
> -static int metadata_era_rollover(struct era_metadata *md)
> +/*
> + * era_map() sets bits without the worker in lazy mode, so switch it to =
the
> + * new writeset before archiving the old one.
> + */
> +static int metadata_era_rollover_lazy(struct era_metadata *md)
> +{
> +	int r;
> +	struct writeset *old_writeset =3D md->current_writeset;
> +	struct writeset *new_writeset =3D next_writeset(md);
> +
> +	r =3D writeset_init(&md->bitset_info, new_writeset, md->nr_blocks,
> +			  md->needs_invalidate);
> +	if (r) {
> +		DMERR("%s: writeset_init failed", __func__);
> +		return r;
> +	}
> +
> +	swap_writeset(md, new_writeset);
> +
> +	if (old_writeset->md.root !=3D INVALID_WRITESET_ROOT) {
> +		r =3D writeset_sync_pending(md, old_writeset);
> +		if (!r)
> +			r =3D __metadata_era_archive(md, old_writeset,
> +						   md->current_era);
> +		if (r) {
> +			DMERR("%s: couldn't archive era %u", __func__,
> +			      md->current_era);
> +			md->tracking_lost =3D true;
> +			dm_disk_bitset_init(md->tm, &md->bitset_info);
> +			dm_bitset_del(&md->bitset_info, old_writeset->md.root);
> +			old_writeset->md.root =3D INVALID_WRITESET_ROOT;
> +			return r;
> +		}
> +	}
> +
> +	md->current_era++;
> +
> +	return 0;
> +}

[Severity: Medium]
Can metadata_take_snap() capture an incomplete metadata snapshot after an
archive failure here?

When archiving old_writeset fails, new_writeset (initialized with all bits
clear) has already been swapped into md->current_writeset and old_writeset =
is
deleted.  If the next rollover is triggered by take_metadata_snap,
metadata_era_rollover() sets md->needs_invalidate =3D true and calls
metadata_era_rollover_lazy(), which archives that incomplete writeset into
md->writeset_tree_root and puts the all-ones invalidation writeset into the
new md->current_writeset.

Because a metadata snapshot only includes writeset_tree_root and
era_array_root (and not current_writeset), the snapshot misses both the wri=
tes
from the failed archive and the all-ones invalidation writeset, while
metadata_era_rollover() clears needs_invalidate and tracking_lost before the
snapshot commit.

[ ... ]

> @@ -969,6 +1116,28 @@ static int metadata_era_rollover(struct era_metadat=
a *md)
>  	return 0;
>  }
> =20
> +static int metadata_era_rollover(struct era_metadata *md)
> +{
> +	int r;
> +
> +	/* Writes may have been lost, so mark every block in the new era. */
> +	if (md->tracking_lost)
> +		md->needs_invalidate =3D true;
> +
> +	if (md->lazy)
> +		r =3D metadata_era_rollover_lazy(md);
> +	else
> +		r =3D __metadata_era_rollover(md);
> +
> +	/* Cleared before the commit, which marks the metadata clean. */
> +	if (!r && md->needs_invalidate) {
> +		md->needs_invalidate =3D false;
> +		md->tracking_lost =3D false;
> +	}
> +
> +	return r;
> +}

[Severity: Medium]
If the caller's metadata_commit() fails after metadata_era_rollover() clears
md->needs_invalidate and md->tracking_lost, is the invalidation state lost?

process_rpc_calls() and metadata_take_snap() call metadata_commit() after
metadata_era_rollover() returns, without restoring needs_invalidate or
tracking_lost on commit failure.  In addition, when a non-lazy target opens
dirty metadata (setting needs_invalidate) and rolls over on preresume, a la=
ter
metadata_era_archive() failure in era_postsuspend() only sets tracking_lost=
 if
era->md->lazy is true, so the following metadata_commit() writes a clean
version 1 superblock even though the invalidated era was not archived.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124230651.4943=
03-1-ronniesahlberg@gmail.com?part=3D1
