Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795498565;
	b=o9a7hlBJbuJVv06XwunZYdzogYl29GjBloJ0nvB1ZQ903XA0sVUPetcYYXcPnRmVbvUb
	 g4PhbFjLcu9VXLu3dB2IDPFnLYrd9FyaZQ6c2BebI1Z+rtA0gpQapkwKzxmoXEHs4FEm+
	 muXwsyEhXljar+I7+bcYbjitsmMDYn5fgVcBQBpK/zpGhfiQCS4cV2SstApBmz7GFUR/j
	 YMdA047/6BH180IK1OW+pihA/JQB59/SX3IB/2q2r9AG6OZW7DpZr14oBuYGDMMSyfmkq
	 xIF3JHMbCAbBunYOXHJij5f9Qtw9zlpLsjb7xGXoW52iTU6/sgNMnd3TpFxajVrRdsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795498565;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1TagTSUh8rwnyHIqD3JB1/2eNf7VbpsOxJsY/K2w/Wo=;
	b=0D6MR2C49yyZ1aXcw7Azhob9KLibdXLBhPGSbFHCgiIUTNHUQB/6g/wkSKvV5+WHY/J7
	 6v0LaR1RgfU4DDmzn5V3ush+M3qU19sGzE/YqmFFA/HIrhY3s5B6d8fhVz6Vv8MA2sUlK
	 Mh7otnzV9SIZE+u9347oRPJ3k0VW+t9oDNCw/hkzqW22Ma6D6x3b8sb+PbpnonU0oEl5t
	 y+qm1m4v5iHlf20ZR3zM0i4NFVFiRi4TrISxBWtFfAL4/Tps1WeCZaryx0CmZYDDXfbq5
	 YnE0LLzF+fanM2VaVjKvaSZ+Sm7/UQQm+RtvxCTuO2NmwJNMBu630JJs7aB4m8CX8pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="CO/5zoxw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2E0606A31E
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 05:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CO/5zoxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288561F000D0;
	Tue, 24 Nov 2026 05:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795498564;
	bh=1TagTSUh8rwnyHIqD3JB1/2eNf7VbpsOxJsY/K2w/Wo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CO/5zoxw0JWCx3EllqN6YylQzNeSxyWSRZ2YKt2Iny2vECyPkWedg7hwLLghoL0to
	 s2k/0eTvr36lqcpJD+2DRHyIU+GFf064cPF2n+PHjV+fnkFQR6VPnU165gpTEU071Q
	 hAtoLF/xdJG2PWFHELc5+9V8drsXAGYS6Ale6w/kAoLVXxBZYQq0xu4v5GUHWsJfE+
	 rWiG4z2PTFdQxm/UfREDZdFO/jM9PFkkq4AOJcdtBlWPxvRqvnTRSjPj1YbeksOSjE
	 congv3rVssxJG1CE4plZYzpHBJQieLiFi9ENenOU3W8RUtT2VqSuijg6rgGuVwqwRy
	 NPu0JhPQ9r4Dg==
Message-ID: <sashiko-outbox-230557@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm era: add lazy mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ronnie Sahlberg" <ronniesahlberg@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com, ejt@redhat.com
In-Reply-To: <20261124051653.346631-1-ronniesahlberg@gmail.com>
References: <20261124051653.346631-1-ronniesahlberg@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 05:36:03 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [High] dm era: premature dirty flag clear on resize commit in
  era_preresume()
- [High] dm era: lost write tracking on live rollover after archive
  failure
- [Medium] dm era: tracking_lost cleared after rollover commit in
  era_preresume()
- [Medium] dm era: on-disk bitset leak on archive failure in
  metadata_era_rollover_lazy()
- [Medium] dm era: stalled writeset digestion after process_rpc_calls()
  in do_work()
- [Low] dm era: unconditional atomic_set() in metadata_lazy_mark()
  dirties shared line
--

commit 2dc3d476acb2e69fd1c049996bc8d1fd635e17e8
Author: Ronnie Sahlberg <ronniesahlberg@gmail.com>

dm era: add lazy mode

This commit adds an optional lazy mode to dm-era that tracks newly written
blocks in memory and defers on-disk writeset updates to periodic or
suspend-time metadata commits, using a version 2 dirty superblock flag to
force full invalidation after an unclean shutdown.

> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> index ea499adca4ce2..fcf466f2e760f 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
[ ... ]
> @@ -505,11 +548,17 @@ static void copy_sm_root(struct era_metadata *md, s=
truct superblock_disk *disk)
>  static void prepare_superblock(struct era_metadata *md, struct superbloc=
k_disk *disk)
>  {
>  	disk->magic =3D cpu_to_le64(SUPERBLOCK_MAGIC);
> -	disk->flags =3D cpu_to_le32(0ul);
> +
> +	if (md->lazy_dirty || md->tracking_lost) {
> +		disk->flags =3D cpu_to_le32(SUPERBLOCK_FLAG_LAZY_DIRTY);
> +		disk->version =3D cpu_to_le32(ERA_VERSION_LAZY_DIRTY);
> +	} else {
> +		disk->flags =3D cpu_to_le32(0ul);
> +		disk->version =3D cpu_to_le32(MIN_ERA_VERSION);
> +	}
> =20
>  	/* FIXME: can't keep blanking the uuid (uuid is currently unused though=
) */
>  	memset(disk->uuid, 0, sizeof(disk->uuid));
> -	disk->version =3D cpu_to_le32(MAX_ERA_VERSION);
> =20
>  	copy_sm_root(md, disk);
> =20
> @@ -609,6 +658,12 @@ static int open_metadata(struct era_metadata *md)
>  	md->metadata_snap =3D le64_to_cpu(disk->metadata_snap);
>  	md->archived_writesets =3D true;
> =20
> +	if (le32_to_cpu(disk->version) >=3D ERA_VERSION_LAZY_DIRTY ||
> +	    (le32_to_cpu(disk->flags) & SUPERBLOCK_FLAG_LAZY_DIRTY)) {
> +		DMWARN("metadata was not shut down cleanly, all blocks will be marked =
as written");
> +		md->needs_invalidate =3D true;
> +	}
> +
>  	dm_bm_unlock(sblock);
> =20
>  	return 0;

[Severity: High]
Does prepare_superblock() also need to keep SUPERBLOCK_FLAG_LAZY_DIRTY set
while md->needs_invalidate is true?

When open_metadata() finds dirty metadata on disk, it sets
md->needs_invalidate =3D true while md->lazy_dirty and md->tracking_lost are
still false.  On initial activation era->nr_blocks is 0, so era_preresume()
always enters the resize branch and commits the superblock before rolling
over to the new all-ones era:

drivers/md/dm-era-target.c:era_preresume() {
	if (era->nr_blocks !=3D new_size) {
		r =3D metadata_resize(era->md, &new_size);
		...
		r =3D metadata_commit(era->md);
		...
	}

	start_worker(era);
	...
	r =3D in_worker0(era, metadata_era_rollover);
}

That resize commit writes a clean version 1 superblock before
metadata_era_rollover() creates the invalidated writeset (and
process_rpc_calls() also commits even if metadata_era_rollover() fails).
If a crash or rollover failure happens after the resize commit, the next
activation will see clean metadata and trust the incomplete pre-crash
writesets.

[ ... ]

> @@ -892,22 +949,60 @@ static int metadata_resize(struct era_metadata *md,=
 void *arg)
[ ... ]
> +static int __metadata_era_archive(struct era_metadata *md,
> +				  struct writeset *ws, uint32_t era)
>  {
>  	int r;
>  	uint64_t keys[1];
>  	struct writeset_disk value;
> =20
> -	r =3D dm_bitset_flush(&md->bitset_info, md->current_writeset->md.root,
> -			    &md->current_writeset->md.root);
> +	r =3D dm_bitset_flush(&md->bitset_info, ws->md.root, &ws->md.root);
>  	if (r) {
>  		DMERR("%s: dm_bitset_flush failed", __func__);
>  		return r;
>  	}
> =20
> -	ws_pack(&md->current_writeset->md, &value);
> +	ws_pack(&ws->md, &value);
> =20
> -	keys[0] =3D md->current_era;
> +	keys[0] =3D era;
>  	__dm_bless_for_disk(&value);
>  	r =3D dm_btree_insert(&md->writeset_tree_info, md->writeset_tree_root,
>  			    keys, &value, &md->writeset_tree_root);
> @@ -917,12 +1012,23 @@ static int metadata_era_archive(struct era_metadat=
a *md)
>  		return r;
>  	}
> =20
> -	md->current_writeset->md.root =3D INVALID_WRITESET_ROOT;
> +	ws->md.root =3D INVALID_WRITESET_ROOT;
>  	md->archived_writesets =3D true;
> =20
>  	return 0;
>  }

[Severity: Medium]
Can archived writesets remain undigested in lazy mode after an RPC
rollover?

do_work() runs kick_off_digest() and process_old_eras() before
process_rpc_calls():

drivers/md/dm-era-target.c:do_work() {
	kick_off_digest(era);
	process_old_eras(era);
	process_deferred_bios(era);
	process_rpc_calls(era);
}

When metadata_era_rollover(), metadata_checkpoint(), or
metadata_take_snap() runs via process_rpc_calls(), __metadata_era_archive()
sets md->archived_writesets =3D true after kick_off_digest() has already ru=
n,
without re-arming era->worker.  In non-lazy mode the first write in the new
era called defer_bio() and woke the worker, but in lazy mode when
md->lazy_gate_open is already true (or when md->needs_invalidate filled the
new writeset with all ones), era_map() never defers bios and do_clean()
runs on era->clean_work, so digestion is never started to fold the archived
writesets into the era array and free their on-disk bitset blocks.

[ ... ]

> @@ -934,13 +1040,51 @@ static int metadata_new_era(struct era_metadata *m=
d)
[ ... ]
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
> +			return r;
> +		}
> +	}

[Severity: Medium]
If archiving old_writeset fails here after swap_writeset() has already made
new_writeset current, does this leak the on-disk bitset blocks rooted at
old_writeset->md.root?

old_writeset->md.root is never inserted into md->writeset_tree_root or
freed with dm_bitset_del(), and process_rpc_calls() then commits
new_writeset as disk->current_writeset.  The next rollover overwrites
old_writeset->md.root in writeset_init(), permanently orphaning those
blocks in md->sm.

> +
> +	md->current_era++;
> +
> +	return 0;
> +}

[Severity: High]
Can a live rollover after an archive failure here wipe unarchived write
tracking without invalidating all blocks?

When archiving old_writeset fails during a checkpoint or
take_metadata_snap message, swap_writeset() has already switched
md->current_writeset to an all-zero new_writeset and set
md->tracking_lost =3D true.  Because md->tracking_lost is only converted in=
to
md->needs_invalidate =3D true in era_preresume(), a second checkpoint or
take_metadata_snap message before a suspend/resume cycle will pick
old_writeset as next_writeset(), reinitialize it with
md->needs_invalidate =3D=3D false, and archive the uninvalidated writeset i=
nto
the btree and metadata snapshot, silently losing the blocks written before
the failed rollover.

[ ... ]

> @@ -982,12 +1129,41 @@ static bool metadata_current_marked(struct era_met=
adata *md, dm_block_t block)
>  	return r;
>  }
> =20
> +/*
> + * Returns false if the bio must wait for the metadata to be marked dirt=
y.
> + */
> +static bool metadata_lazy_mark(struct era_metadata *md, dm_block_t block)
> +{
> +	bool r =3D true;
> +	struct writeset *ws;
> +
> +	rcu_read_lock();
> +	ws =3D rcu_dereference(md->current_writeset);
> +	if (!test_bit(block, ws->bits)) {
> +		if (!READ_ONCE(md->lazy_gate_open))
> +			r =3D false;
> +		else if (!test_and_set_bit(block, ws->bits)) {
> +			set_bit(block, ws->pending);
> +			atomic_set(&md->lazy_activity, 1);
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return r;
> +}

[Severity: Low]
md->lazy_activity shares a cacheline in struct era_metadata with md->lazy
(read on every write bio in era_map()) and md->lazy_gate_open.  Could this
check !atomic_read(&md->lazy_activity) before calling atomic_set() so that
marking new blocks across different bitmap regions does not repeatedly
dirty that shared cacheline while md->lazy_activity is already set?

[ ... ]

> @@ -1635,12 +1981,19 @@ static int era_preresume(struct dm_target *ti)
> =20
>  	start_worker(era);
> =20
> +	/* Writes may have been lost, so mark every block in the new era. */
> +	if (era->md->tracking_lost)
> +		era->md->needs_invalidate =3D true;
> +
>  	r =3D in_worker0(era, metadata_era_rollover);
>  	if (r) {
>  		DMERR("%s: metadata_era_rollover failed", __func__);
>  		return r;
>  	}
> =20
> +	era->md->needs_invalidate =3D false;
> +	era->md->tracking_lost =3D false;
> +
>  	return 0;
>  }

[Severity: Medium]
Is era->md->tracking_lost cleared too late here for the rollover commit to
clear the on-disk dirty flag?

in_worker0(era, metadata_era_rollover) runs process_rpc_calls(), which
calls metadata_commit(era->md) before completing the RPC and returning to
era_preresume().  During that commit era->md->tracking_lost is still true,
so prepare_superblock() writes SUPERBLOCK_FLAG_LAZY_DIRTY and
ERA_VERSION_LAZY_DIRTY to disk even though the new era was just initialized
with every block marked.  Because all bits in ws->bits are now set, later
writes in this era will not defer to the worker or schedule do_clean(),
leaving the on-disk superblock marked dirty while clean and idle.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124051653.3466=
31-1-ronniesahlberg@gmail.com?part=3D1
