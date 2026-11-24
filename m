Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523720;
	b=rOpM3pBOGfS6eddGxuoSFtDv3MLT6TpaEVyEl/bfOcvGygLwRONforOrLELHZYwVGogf
	 pRjLnnL+h197gvoso7hbY76SgQ/9Blid0x1jcY08KmNHrYtT9q7rJ5yDRl51GeOg1rf0e
	 BOCbR0tTUHE8RtalA2T2PwlPqBIMhcZ1j0lTJPiCbLGSVubRE6xTMNS+Ng32hemYX8SvJ
	 6jkkFDvOix9wqKQ8ZzLP0hvH9wei5xbohzUgoV3pLsCZJr69a5qHXJWPkZ1erY2GqMeYu
	 A8fdP+FhNa6YCHeg7hYHclrADogGAYkIEWAN0NvxE+83okyXQVgKUnQ43JmPbM+FweQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523720;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kmweTMZBzgzXbDeqq323Vxvj5oKHS564hSHQQblhjpo=;
	b=QrzImYbnzYtZkGKIX0HEOxK4VY7b6xehLvAzIG01YyK+2zqqzavMm1BlGp/fgh37z5BZ
	 ThnC789smM6X1TBybUEV88c7X/c0wAXKgHNbaNxowS+87ZSeLHuexYCM21W2zirNDiMof
	 gPY57GuQNBgm8jD/6V5FZUr2d0hrOMnr3a6TrL9b3NHP0a3sgbTq+Y5RZVTH4O4N84D4J
	 DGxpYbksPnTHmybB7CPYSHUWLqud3i9Mz0C8LdrgAYK2piDaeWqt94u5oEIBREACgzsBn
	 o7GJIKMmWwpN6ZRokqfVbmaMdV63oMlxpnThQ54CK2MeOUsmvyrJwolVcfRRMQGP+2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ioVjX2c5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CC8606A31E
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 12:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ioVjX2c5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14E31F000C0;
	Tue, 24 Nov 2026 12:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795523719;
	bh=kmweTMZBzgzXbDeqq323Vxvj5oKHS564hSHQQblhjpo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ioVjX2c5ahKT1Wn41aVZWz8P93xN4XOXoUwovqEubRmI4iGvHVizBSidDryRZ9fJ3
	 7SRfdqzosjljHLCgJOEsqpuw6TQJ+6reXIjRtQWtapOS97mdgLzDu3S4k55gPix3LH
	 Te4lWUfxDa6sFj0PEBg0eezgkE5lVpA3VKdr88meBf5KN1vDx4Zcp5Ifw2YhUyaHzt
	 mTCU1vhDBeZbXHiJ0vS2hkc55RvVkkorxUPFlIT25Zfw9xW8X1id2PFsmMjiVKDiP0
	 /+Gy7R9Oz00jF4ccJj319ivlA/evPt8UesnkJWsKfDUAAgOst1QbJsB7rMLlcnL7Ho
	 7CAS+vW8NqKMw==
Message-ID: <sashiko-outbox-231146@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] dm persistent data: put back the reference a
 failed shadow dropped
Reply-To: sashiko-reviews@lists.linux.dev
To: "Denis V. Lunev" <den@openvz.org>, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, thornber@redhat.com
In-Reply-To: <20261124122601.436965-2-den@openvz.org>
References: <20261124122601.436965-1-den@openvz.org>
 <20261124122601.436965-2-den@openvz.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 12:35:18 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] dm persistent data: leaked new block in __shadow_block() on
  error
--

commit 03aa675fd4998658022986a6e963e9c3d3429569
Author: Denis V. Lunev <den@openvz.org>

dm persistent data: put back the reference a failed shadow dropped

This commit restores the original block's reference count via
dm_sm_inc_block() when __shadow_block() fails to read the original block
or write-lock the new block.

> diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/driver=
s/md/persistent-data/dm-transaction-manager.c
> index 7401add01d12e..cf203ebb5110e 100644
> --- a/drivers/md/persistent-data/dm-transaction-manager.c
> +++ b/drivers/md/persistent-data/dm-transaction-manager.c
> @@ -303,7 +303,7 @@ static int __shadow_block(struct dm_transaction_manag=
er *tm, dm_block_t orig,
> =20
>  	r =3D dm_bm_read_lock(tm->bm, orig, v, &orig_block);
>  	if (r < 0)
> -		return r;
> +		goto out_put_orig;
> =20
>  	/*
>  	 * It would be tempting to use dm_bm_unlock_move here, but some
> @@ -315,13 +315,18 @@ static int __shadow_block(struct dm_transaction_man=
ager *tm, dm_block_t orig,
>  	r =3D dm_bm_write_lock_zero(tm->bm, new, v, result);
>  	if (r) {
>  		dm_bm_unlock(orig_block);
> -		return r;
> +		goto out_put_orig;
>  	}
> =20
>  	memcpy(dm_block_data(*result), dm_block_data(orig_block),
>  	       dm_bm_block_size(tm->bm));
> =20
>  	dm_bm_unlock(orig_block);
> +	return 0;
> +
> +out_put_orig:
> +	/* The caller goes on using orig when the shadow fails. */
> +	dm_sm_inc_block(tm->sm, orig);
>  	return r;
>  }

[Severity: Medium]
Does this leak the newly allocated block new in the space map when
__shadow_block() fails?

__shadow_block() allocates new via dm_sm_new_block(tm->sm, &new) with a
reference count of 1 before decrementing orig:

drivers/md/persistent-data/dm-transaction-manager.c:__shadow_block() {
	r =3D dm_sm_new_block(tm->sm, &new);
	if (r < 0)
		return r;

	r =3D dm_sm_dec_block(tm->sm, orig);
	if (r < 0)
		return r;
    ...
}

Unlike dm_tm_new_block(), which calls dm_sm_dec_block(tm->sm, new_block)
on failure, neither out_put_orig nor the dm_sm_dec_block(tm->sm, orig)
error path releases new.  Once the target recovers from the transient
failure and commits a later transaction, new remains permanently allocated
in the on-disk space map with nothing referencing it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124122601.4369=
65-1-den@openvz.org?part=3D1
