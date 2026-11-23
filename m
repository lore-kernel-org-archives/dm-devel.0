Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795462904;
	b=zm9L416H+/XuDKEKZ414d41bL2/Dt5WY0FQgARHpttIAMRGEG92tuBoUD3dpj25h6PuI
	 K/A5F0Jnu1O9y9ti/GNFNcUwfIOFqo7LOJfauKQNZ74BFhqneQLCMFScipysEbIENLRhh
	 4fYPwx/dqUvOq4KzqE3Rm7qJBPp3tc48fgrnl5vpcjf/9OdW8wH35uGDQcp0M5jsDyC/D
	 D/1x8tb/NS8J/DtU9umHKK+Plx4ujieeJUZ7u9/jzlO5hiaUFeHnA0mujiQAG+14J0OvG
	 X4fpNkkB1PRNZUzpz2jC845fWe61VWQaHz7y2nQeh8z0u/B0TbqhI1/+eNtnTSnjWuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795462904;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hCyT4RuOjcFEDeuoSNz7pGEmN664RVK/UuMDyyuRKok=;
	b=jZFdKSr8LtTROyLpSbLNxiCL6G3c86s6X8r9lZXScUnW6AsckRDXMm49TkNV2sS5vSWL
	 OKw/EQu3j+yUQWfRpKeCU+OHs7XOic60G1QO/RAt1SMz6DnVeTlTpbORRobitxbXpVXAS
	 3abYUrmXkwTb4Z8RyxYHrvddiONmMOBcwNIDVNPkfEEmlv+rKWyi16LUlBGOxdAq6oRkV
	 DrVLquonDZWbgsf7JE1S7uHAsZIB6jIIwU0b8pvIKzUcbalOeZBN1VvZqXwIYE9bauYvI
	 mJiUSy6UqflyGiqg4gSKt9ThEARgiCkrcbMlISxsV3McbL+F7pOT57xfqnXV6e5PbBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bWGFA9Q9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CE8606A31A
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bWGFA9Q9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A341F000CA;
	Mon, 23 Nov 2026 19:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795462903;
	bh=hCyT4RuOjcFEDeuoSNz7pGEmN664RVK/UuMDyyuRKok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bWGFA9Q9A5AkcAOir4xBj+pwcfMNGQQtsxorNxm6dmXLrp+9GIDeErMQmMHSVFyYf
	 lB0a7GjM99y7Jeu7t/6bSnZZOU6lXcZ4kRD3qNyIJLVWSHop+7l2fZx1jysShRFboY
	 Fw5vFEPwz630rvHZkMQP9cAZAGXABNfuXxhIwygHx3MqCa8If60ZRgjF3NAXtqPxGK
	 MzAGqmYAG4ns2WZIVUDAMRmDLKuyaF4sTjuSfv5sgC6g/b4gc0Cb3DO5ft3DvO7DvL
	 0Q0bcS4tcUvtIDhCyZxJEcdBSWa6/31aFzrRoUJ3G5GCjvQoEfurNS0V7anKL3R2qA
	 ph3B5/uisdngA==
Message-ID: <sashiko-outbox-229949@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 RESEND] block: stack max_hw_discard_sectors on bottom
 max_discard_sectors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Benjamin Marzinski" <bmarzins@redhat.com>, "Jens Axboe" <axboe@kernel.dk>, "Christoph
 Hellwig" <hch@lst.de>
Cc: "Hannes Reinecke" <hare@suse.de>, "Keith Busch" <kbusch@kernel.org>, "Martin
 K . Petersen" <mkp@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, dm-devel@lists.linux.dev
In-Reply-To: <20261123193000.3419445-1-bmarzins@redhat.com>
References: <20261123193000.3419445-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 19:41:43 +0000
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
- [Medium] dm: set_discard_limits() copies underlying
  max_hw_discard_sectors
--

commit 54b96a4a0a953173383ea0e1a1b7ffcb363bc984
Author: Benjamin Marzinski <bmarzins@redhat.com>

block: stack max_hw_discard_sectors on bottom max_discard_sectors

This commit stacks the upper device's max_hw_discard_sectors from the
bottom device's max_discard_sectors in blk_stack_limits() and updates
dm_calculate_queue_limits() to copy each target's max_hw_discard_sectors
into max_discard_sectors before stacking it into the table limits.

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 48f25ab6b7fa6..4cabe26450941 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1834,8 +1834,11 @@ int dm_calculate_queue_limits(struct dm_table *t,
>  combine_limits:
>  		/*
>  		 * Merge this target's queue limits into the overall limits
> -		 * for the table.
> +		 * for the table. In blk_stack_limits() the upper device's
> +		 * max_hw_discard_sectors is based on the lower device's
> +		 * max_discard_sectors, so copy this value over first.
>  		 */
> +		ti_limits.max_discard_sectors =3D ti_limits.max_hw_discard_sectors;
>  		if (blk_stack_limits(limits, &ti_limits, 0) < 0)
>  			DMWARN("%s: adding target device (start sect %llu len %llu) "
>  			       "caused an alignment inconsistency",

[Severity: Medium]
Should set_discard_limits() in dm-cache and dm-clone also use the
underlying device's max_discard_sectors instead of max_hw_discard_sectors?

When discard passdown is enabled, cache_io_hints() and clone_io_hints()
call set_discard_limits() to replace the target's stacked discard limits
with those of the origin or destination device alone:

drivers/md/dm-cache-target.c:set_discard_limits() {
    ...
	limits->max_hw_discard_sectors =3D origin_limits->max_hw_discard_sectors;
	limits->discard_granularity =3D origin_limits->discard_granularity;
	limits->discard_alignment =3D origin_limits->discard_alignment;
}

drivers/md/dm-clone-target.c:set_discard_limits() {
    ...
	limits->max_hw_discard_sectors =3D dest_limits->max_hw_discard_sectors;
	limits->discard_granularity =3D dest_limits->discard_granularity;
	limits->discard_alignment =3D dest_limits->discard_alignment;
	limits->max_discard_segments =3D dest_limits->max_discard_segments;
}

Copying ti_limits.max_hw_discard_sectors into ti_limits.max_discard_sectors
at combine_limits propagates origin_limits->max_hw_discard_sectors (or
dest_limits->max_hw_discard_sectors) into the table limits, bypassing any
smaller max_discard_sectors configured on the origin or destination device.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123193000.3419=
445-1-bmarzins@redhat.com?part=3D1
