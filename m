Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795468533;
	b=S+R0QSu3jsSPfiG71QHsH8kRX59bh6x+14RRpJcStPTTN4Wk4MMR+zHtWKGBV99BBBwY
	 ZvXT3W02Cw8Ops7nLDkyvNdhnllb0oAw/MfSPcLvGYSvzXnZYYh6DvIgrS/RDS8Em4UBQ
	 G4xzQsXsKIe2GLSszzyB5sJI9uTVxsNgJUimaXktSbq3iSYiRcmL7zN/aoKSQqhbPnPuD
	 HrODqJP8mY7S7D5hqQGFTg3I1+6+9KpG33NMOPADknvxUSo1HaRnrsbVmCmoXmSeD4fbc
	 52UXmmc+I56EZSq38JSFvaeuNP77MyU5gguduKGkNsVcqKm5+gGCU23ystw8iNS21Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795468533;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=P43OzURkHb2x/16P8mW5X0rA2FpLZGl3KWvvZDihI/0=;
	b=OCmo9GRP3DJ8IEgZXa+mBcW8vAu0SUEhpXaIOTzy8EV55FmKNNtikY3C3DthXv2MU2wV
	 uFafhzP9vmHdk5r6F+obisgrVvMNPwsOZEnz0loCHd549BkmNHNoitKBHWaLq7Whi/0LU
	 gAI+q4/v1jzUXjcYK9CaEhsdpys7YGWwkg6yyjbrrD//1qUAUmqhbCu+u/i2+NoaWcikq
	 QAXne0iYiCqI1RdaKbLhOPkWaLoHB0yKWcsr/trwVsMYvoo4HBs8XMRDjfnqHsdAJuCzT
	 ODLRsLYzMY+ITC9iQZPA0i2RXa+9zZvZ7NwUtBL8nNCIPSvsPPcid6tNfzzAqrNgMwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="e/c6x998";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF3D606A326
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 21:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e/c6x998
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128CC1F000CA;
	Mon, 23 Nov 2026 21:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795468532;
	bh=P43OzURkHb2x/16P8mW5X0rA2FpLZGl3KWvvZDihI/0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=e/c6x998ydmXk3m2+AbIegtuFc1cc1pp7qm6i8JBoMUYA28m+oTmUNESlra0NZars
	 beF74+UkqEkcxZMXnoOLlDieqHH2Wqn+QSXmFdu8CmdQKx66n6GRarryKQXuP+3MBz
	 q0crMlhMs+RAjU+im4VpqTZz2eSp7SkLrDiNntHlpm9MpRWUY9EtDNMAGpI7WCIKDy
	 MzJ69H0+shq0y3pHme+4lHHU2E3CWYySxq2xZqGvMgWXTGJSeQOf3TAp2MiAczaHJ3
	 oUTrCGs2CwodP0C78rC9HDAcahtIFAf2H2YjFRdQGA8K1Ciu1LsKKbG51tog17laLg
	 X42ly6Vg6nSWg==
Message-ID: <sashiko-outbox-230071@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm persistent data: assign new_root only when removal
 succeeds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Ming-Hung
 Tsai" <mtsai@redhat.com>, dm-devel@lists.linux.dev
In-Reply-To: <66133e69-7c3f-74bf-32b0-fdc9f0fd836c@redhat.com>
References: <66133e69-7c3f-74bf-32b0-fdc9f0fd836c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 21:15:31 +0000
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
- [High] dm persistent data: lost shadow root on -ENODATA in
  remove_one()
--

commit 4eeca185df6005174039047dc72433972f6d625f
Author: Mikulas Patocka <mpatocka@redhat.com>

dm persistent data: assign new_root only when removal succeeds

This commit changes remove_one() to update *new_root only when r is 0, so
that uninitialized spine.root is not read on error.

> diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/pe=
rsistent-data/dm-btree-remove.c
> index 18f53c6722027..cdcaf36bbc9e9 100644
> --- a/drivers/md/persistent-data/dm-btree-remove.c
> +++ b/drivers/md/persistent-data/dm-btree-remove.c
> @@ -755,7 +755,8 @@ static int remove_one(struct dm_btree_info *info, dm_=
block_t root,
>  		r =3D -ENODATA;
> =20
>  out:
> -	*new_root =3D shadow_root(&spine);
> +	if (!r)
> +		*new_root =3D shadow_root(&spine);
>  	exit_shadow_spine(&spine);
> =20
>  	return r;

[Severity: High]
Does skipping *new_root =3D shadow_root(&spine) when r =3D=3D -ENODATA leak=
 the
new shadow root block and leave *new_root pointing to a freed block?

remove_one() only sets r =3D -ENODATA after remove_raw() and
remove_nearest() have already called shadow_step() on root.  If root was
not already in the transaction manager's shadow table (for example, on the
first iteration of dm_btree_remove_leaves() when no key lies in the target
range, or after insert_shadow() silently drops a GFP_NOIO allocation),
__shadow_block() allocates a new block for spine.root and decrements the
old root block's reference count.

Because dm_btree_remove_leaves() treats -ENODATA as normal completion:

drivers/md/persistent-data/dm-btree-remove.c:dm_btree_remove_leaves() {
	do {
		r =3D remove_one(info, root, first_key, end_key, &root, nr_removed);
		if (!r)
			(*nr_removed)++;
	} while (!r);

	*new_root =3D root;
	return r =3D=3D -ENODATA ? 0 : r;
}

not updating *new_root on -ENODATA discards the newly allocated shadow
root and returns 0 with *new_root still referencing the old root block
whose space-map reference count was already decremented.  Checking
if (!r || r =3D=3D -ENODATA) would avoid reading an uninitialized spine.root
on I/O errors while preserving the shadowed root on -ENODATA.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/66133e69-7c3f-74bf-=
32b0-fdc9f0fd836c@redhat.com?part=3D1
