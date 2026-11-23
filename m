Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795400668;
	b=ouL48XleJkFfqcHjBcVOgbhHpY28RYaa3+ChdMVIzJZqIiHVHF6kDwmjHXUtd/rdo/6L
	 q83u3QLkLNLhKSb8gxo3aFFKMPkABctAhHNY0dZNV5FD1R7/5mPoQNElU743A05W1M2b7
	 0rflwRhwNGThXMz6bYM++EiyMFeLKGfvSyqc3DARqE9YtwQeJPm/6Mt7A/euJUnVxm5Vs
	 tVouzgPT2/6GXYqcccVH31TBwowdwaLmE9iPr6CoSwQBkXD9tin5Sp9T9I4gB/RV3ez/2
	 DrXFtS+lpkRPGzNoKatFcaTToPv7W0ZqWWHM/8l9XO9mYAOhYGwpGMTNbiqi0vNtiKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795400668;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i26t64vMmgA47cJAZenWvCeTkmRknveyBFx3MgxbOzo=;
	b=FHITZgzkoWwbvtfDO0qDJWfiba/mxz9hClZfpaFCWWH7qr0uvBW2AOGBNqfPhlrLNiBW
	 0Oh8Z/lNT2hx+ZEQ4WdwBzk9kcylkMA4nfcXf3NdOxunXsOkpKoT4NqwgjkFjkVQ3/FTQ
	 ac5NVEbhWLHTBYB8vq/zcl1EWkIxVndLlOltj1eN8ReCPexyWdgYqq2pp3xCwbLbEBrkR
	 Jv5MyxueViO5rQs83t4aEGx6LIBK8kqYpICQsQk4q/WUOR5lYJ2jkAghaTzDdVPW1T87t
	 kYF+WNEXNoRfCLXUNegoPnaxPiWK+rMs3Mkq57D4mzE7XMJpt2v3VxTImVpOzXtzxGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JWIwaICH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC5D606A31A
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 02:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JWIwaICH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C3C1F000C4;
	Mon, 23 Nov 2026 02:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795400667;
	bh=i26t64vMmgA47cJAZenWvCeTkmRknveyBFx3MgxbOzo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JWIwaICH7OpdJelMqsY3XE32X0Rph3yGp3oxYsM3GtmDpz5dbSrjIKfcuEFRwaMBk
	 MycAALKHYE6yX6BH94jrJjf32hitfSIvjubU/vAdBvkpvZeIkKB26W8TPNEU5CoKLZ
	 ti9t82ZWGyUVgfE/vcq45ELKCoQuet/A3tpBXCVfaH82KFia94wodwuKrdSF1nW90s
	 wbO8T7fQk2GMt0SMOj9HOL4yL1tcRr5DH5jaf80BrTajmmvY4THdlCVTZ3WO6Swi9T
	 tDR19Su7ne/6cysdQRUE+9nkrZ/h0ORqhK55N3rWeh6XOq629xgOFQSLBkn52ZZHGl
	 VmrOrZFB0rOqg==
Message-ID: <sashiko-outbox-228549@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] dm-integrity: reject recalculation when recalc_wq
 was never allocated
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Luohan" <ylh440104@gmail.com>, "Mikulas Patocka" <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, "Mike Snitzer" <snitzer@kernel.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
In-Reply-To: <179540012414.2174.4959926607245086522@gmail.com>
References: <179540012414.2174.4959926607245086522@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 02:24:26 +0000
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
- [Low] dm-integrity: duplicate recalculation check block in
  dm_integrity_resume()
--

commit 7fbe3dddd5b741b0cbacdf50c00c5c1e5e6e0bc0
Author: Yang Luohan <ylh440104@gmail.com>

dm-integrity: reject recalculation when recalc_wq was never allocated

This commit rejects a re-read superblock in dm_integrity_resume() when
SB_FLAG_RECALCULATING is set but ic->recalc_wq was not allocated, restoring
ic->sb from ic->sb_copy.

> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 6968e38888db9..da8d15aa414ed 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -3941,6 +3941,22 @@ static void dm_integrity_resume(struct dm_target *=
ti)
>  		goto skip_writes;
>  	}
> =20
> +	if (unlikely(!ic->recalc_wq &&
> +		     (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)))) {
> +		memcpy(ic->sb, ic->sb_copy, sizeof(struct superblock));
> +		DMERR("Recalculate requested, but internal_hash is not used");
> +		dm_integrity_io_error(ic, "inconsistent superblock", -EINVAL);
> +		goto skip_writes;
> +	}
> +
> +	if (unlikely(!ic->recalc_wq &&
> +		     (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING)))) {
> +		memcpy(ic->sb, ic->sb_copy, sizeof(struct superblock));
> +		DMERR("Recalculate requested, but internal_hash is not used");
> +		dm_integrity_io_error(ic, "inconsistent superblock", -EINVAL);
> +		goto skip_writes;
> +	}

[Severity: Low]
Was this check pasted twice by mistake?  The first block jumps to
skip_writes when the condition holds, so the second copy is dead code.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179540012414.2174.4=
959926607245086522@gmail.com?part=3D1
