Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001129;
	b=xIX6YcdG6/iyoxUEDRTK9LDAvd1nKHfwdN1eC/vXMkygFRykNnGjcQwpprYrKvPgNO73
	 vR2ID8EyybfD2tezqUWbVifI1W7Sh5knaU4+YN4sYZO0Rdrz3VfSayCfkFrDw767bLDT3
	 +DR9IXRpewbeoSGDwNvCnlJ86ULTbBGHtVpueg9v2q8NDcfNPfJ2dCQKZZSqjIORCCRJn
	 MXVDq7jpnSwzq9sXO2RbJbuGb0z9lKq2G9/VzQZy3qI+X5Lf4S+39xucOmGhNRyLPUwP9
	 hiDf2OTzaPxd/GTcCAbH1qTqtAMqVCC0RdEr22zfhu7dTa0UETO2dUJIm4Nn5NQrtzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001129;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FjK7gTpOa1gQAwwu83TL9TJ5qYruXRzfkIPcVwvf4RE=;
	b=Ab5/jeDI/F+S7BO5tGFDxin+deGLUZ/rirwN1Ktl0ygMfFnWTFsg+u/dxYVOCm9OBrwZ
	 AVvoC1DYaJbOpAF/m+PYMUdh38LWL2QjZ2KUsuSGEopeQSHIDofda/2sC7FQ3HZmBl/Bh
	 DnZDTvaSN2QGK75ZCmXWw5je15kAPb++3P6ereXhPalnOK5TULNys0fyZCcGsgrohjI2B
	 2SjmOOF8IUs9a9PPI285xx9fd7fz54MFXN//Rn7IHJIjsVN3veuB0hJ5sm8if1k1Qes1H
	 WGwTAMajtdrs5EmfM2t/G4F+0OImkyH6U/D8K+LWS5ft1De5Vbz9lMbYFiWzglsJrcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XjRANpu9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372BA606A320
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 11:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XjRANpu9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BDE1F000C4;
	Wed, 18 Nov 2026 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795001128;
	bh=FjK7gTpOa1gQAwwu83TL9TJ5qYruXRzfkIPcVwvf4RE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XjRANpu9MeAYUzOCobTMN9QfSS7XEgqlXp9807tF2L+ALFbZvBcmCmlP92k66up/P
	 mr/x8apyicFwEDfsp5fLc+ejfb1HChg3f63NBsfH1PaY2+38XAdsNPecahJzNtrnuv
	 9MQOTmsXrNHhocxU+4uKpP7m95Ogm9ipTbOFTPqhwd9k1eHMcIGOIy0ezBqFc7mniO
	 br2KwybMiAJ+mpmNOXjXlGET24GynP6yQBd7KGFLp81Vj3oYg8aoKzfKGhyiMVhao2
	 +Z3lbxAfKM7Wc18CZ8MBorIZI4B4YYWn832uTv/JjiQnR9eEOMWCArlw+4lijhyPyb
	 Y5oMfH0tpFK/w==
Message-ID: <sashiko-outbox-220821@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] dm persistent data: drop the original block only
 once it is copied
Reply-To: sashiko-reviews@lists.linux.dev
To: "Denis V. Lunev" <den@openvz.org>, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, thornber@redhat.com
In-Reply-To: <20261118110239.2910290-2-den@openvz.org>
References: <20261118110239.2910290-1-den@openvz.org>
 <20261118110239.2910290-2-den@openvz.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:25:25 +0000
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
- [High] dm persistent data: __shadow_block() exceeds max concurrent
  locks
- [Medium] dm persistent data: space map block leak on error in
  __shadow_block()
--

commit f51a9340a7ed4ff57bea163d1f75e930e3c7038c
Author: Denis V. Lunev <den@openvz.org>

dm persistent data: drop the original block only once it is copied

This commit moves the dm_sm_dec_block() call in __shadow_block() after
the original block is read, copied into the newly allocated block, and
unlocked.

> diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/driver=
s/md/persistent-data/dm-transaction-manager.c
> index 7401add01d12e..159aac9da07ae 100644
> --- a/drivers/md/persistent-data/dm-transaction-manager.c
> +++ b/drivers/md/persistent-data/dm-transaction-manager.c
> @@ -297,10 +297,6 @@ static int __shadow_block(struct dm_transaction_mana=
ger *tm, dm_block_t orig,
>  	if (r < 0)
>  		return r;
> =20
> -	r =3D dm_sm_dec_block(tm->sm, orig);
> -	if (r < 0)
> -		return r;
> -
>  	r =3D dm_bm_read_lock(tm->bm, orig, v, &orig_block);
>  	if (r < 0)
>  		return r;
> @@ -322,7 +318,14 @@ static int __shadow_block(struct dm_transaction_mana=
ger *tm, dm_block_t orig,
>  	       dm_bm_block_size(tm->bm));
> =20
>  	dm_bm_unlock(orig_block);
> -	return r;
> +
> +	r =3D dm_sm_dec_block(tm->sm, orig);
> +	if (r < 0) {
> +		dm_bm_unlock(*result);
> +		return r;
> +	}
> +
> +	return 0;
>  }

[Severity: High]
Can calling dm_sm_dec_block() while *result is still write-locked exceed
the maximum concurrent block locks reserved by dm-bufio and deadlock under
memory pressure?

Previously, __shadow_block() ran in three sequential phases that each held
at most two locks internally: dm_sm_new_block(), dm_sm_dec_block(), and
dm_bm_read_lock(orig) + dm_bm_write_lock_zero(new).  Commit 490ae017f54e
("dm thin metadata: THIN_MAX_CONCURRENT_LOCKS should be 6") sized
THIN_MAX_CONCURRENT_LOCKS to 6 for rebalance3(), which holds 4 locks (2 in
the shadow spine plus left and center children) when init_child() calls
dm_tm_shadow_block() for the right child (4 + 2 =3D 6).

With dm_sm_dec_block(tm->sm, orig) moved after dm_bm_write_lock_zero(),
*result is already held when dm_sm_dec_block() runs.  When
smm->recursion_count is 0 and orig's bitmap block has not been shadowed yet
in the current transaction, sm_metadata_dec_blocks() -> sm_ll_dec() ->
__sm_ll_dec() -> shadow_bitmap() recursively enters __shadow_block() for
the bitmap block and takes dm_bm_read_lock() and dm_bm_write_lock_zero().
That brings the peak lock count to caller_locks + 3, reaching 7 concurrent
locks in rebalance3() (exceeding THIN_MAX_CONCURRENT_LOCKS =3D 6) and 6 in
rebalance2() (exceeding ERA_MAX_CONCURRENT_LOCKS =3D 5,
CACHE_MAX_CONCURRENT_LOCKS =3D 5, and DM_CLONE_MAX_CONCURRENT_LOCKS =3D 5).
When dm-bufio falls back to its reserved_buffers pool under memory
pressure, a single metadata thread holding all reserved buffers cannot
evict its own held buffers and blocks forever in
__alloc_buffer_wait_no_callback() -> __wait_for_free_buffer().

[Severity: Medium]
Does __shadow_block() also leak the newly allocated block new in the space
map when dm_bm_read_lock(), dm_bm_write_lock_zero(), or dm_sm_dec_block()
fails?

At the start of __shadow_block(), dm_sm_new_block(tm->sm, &new) allocates
new with a reference count of 1.  If a transient read error in
dm_bm_read_lock() (or a failure in dm_bm_write_lock_zero() or
dm_sm_dec_block(tm->sm, orig)) aborts the shadow and a subsequent commit
succeeds, new is never released with dm_sm_dec_block(tm->sm, new) (unlike
dm_tm_new_block() right above, which decrements new_block on error) and
remains permanently allocated in the space map with no metadata pointing to
it.  On the dm_sm_dec_block(tm->sm, orig) failure path,
dm_bm_unlock(*result) also marks the buffer for new dirty in dm-bufio.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118110239.2910=
290-1-den@openvz.org?part=3D1
