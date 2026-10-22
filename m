Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792686956;
	b=ZF5tqki7eEB8ClzDpKsBZ9jG67FOExe4zmEdNKIHekxIcbWIgNHekeX91BM3yAkW58OG
	 0pY7X2oHODYi/yK5dq2aURDyIZma1gCDNGCcIzTlyGAzOUFeGyLGZyNJZH1q50UncTntZ
	 VgoQUtekv+9ADyol7Y+KgLp4b3soor+BGzkLxpcxbrEtg+CYka9hfmY1CTgF0D7rqoCL5
	 SQr6Cgy87vxkH2ZahyZYVkJKGSStN3R/qmzMrMUnxck1Ghdf0TiQZpRjtwLdO0PDT/9Qu
	 HRnAOX8zX4H80bqd03mRXGQqQGYQqtEhCzd3jCa78xHMJ312pXgnZzT56mWHDgN0zuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792686956;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h5ueT8RGilJosUK1SW6gHhuohUCkndBTcqtWqzRxyLk=;
	b=XaPp0ymzdBWgxyYA04Cc7xsaX6lnMd1HzUu/WYwKtJA/CKkQ/wWPkudw5G66MQk3vzbA
	 h21jlcRl/PhaXsAwFJ1u03IadV+9xwxwHnLNTjI3N8kgkFJzo95PIp0mAlQY+ZFUoolfI
	 fqDPD8vmu9b90ql1euKO1N8EAxDMSjFmmX7VPlHK6o6CGo+7EJcOWcZk+P5rTnLuHF41K
	 sjRksuDA4vZFTXGNMl2UOOutJtudwAE6oAgPzcF/Vb8a1tFuacK4Do2EtKwZ2+0W1WNP2
	 FLk3L9FJuoF/xFeYqoWR4/2PM5SPmzbGt8eLFWMXbFjssZg59+jrAc8r4y8Su4wwndg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpReE7Va;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601BA606A319
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 16:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpReE7Va
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B731F01825;
	Thu, 22 Oct 2026 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792686956;
	bh=h5ueT8RGilJosUK1SW6gHhuohUCkndBTcqtWqzRxyLk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jpReE7VaIuMFgQmjkczXiNNzzkgnOAiOozpr0DeQSmsb/aZoA3ssUad4wY12NnuHW
	 8Y2SgKxCeMYcqocO1t0wFPpfoLnSKopV2SqbHzsvbMxGpI+baD1JxgdlwbgoCKS+bv
	 oM1V7eg3jnA1tCLLxdjSq0my8UNcUtMlfekuwWRBjogw0lfrrrxa5Gk60kXxS3cbUM
	 8gsVLpPECwxGcvzBL+HgCGGAYtjXLU0XNLYN1FkD+Ev1TnnaMVQb4EIYn0azrurOG8
	 DYiWx6Umjr/IZrvmAWLMLLhU8q2cal7eW0wdlaglmiMoBK43toa3WP856z6Bh+P3Z/
	 t+57+3hCvIDVg==
Message-ID: <sashiko-outbox-181810@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: Patch "dm array: validate array block headers on read" has been
 added to the 6.6-stable tree
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>, hexlabsecurity@proton.me
Cc: "Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, dm-devel@lists.linux.dev
In-Reply-To: <20261016180222.4058164-1-sashal@kernel.org>
References: <20261016180222.4058164-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 16:35:55 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dm array: array_block_check() fails to validate value_size against=
 info
--

commit 3c810b656c43751de89392b584e21daeb9a84fcd
Author: Sasha Levin <sashal@kernel.org>

Patch "dm array: validate array block headers on read" has been added to th=
e 6.6-stable tree

This commit backports upstream commit 296578772308 to validate on-disk
array_block headers in array_block_check() by checking that value_size is
non-zero, max_entries matches calc_max_entries(), and nr_entries does not
exceed max_entries.

> diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persisten=
t-data/dm-array.c
> index 798c9c53a3435..fb65e82dab890 100644
> --- a/drivers/md/persistent-data/dm-array.c
> +++ b/drivers/md/persistent-data/dm-array.c
[ ... ]
> @@ -74,6 +83,26 @@ static int array_block_check(struct dm_block_validator=
 *v,
>  		return -EILSEQ;
>  	}
> =20
> +	nr_entries =3D le32_to_cpu(bh_le->nr_entries);
> +	max_entries =3D le32_to_cpu(bh_le->max_entries);
> +	value_size =3D le32_to_cpu(bh_le->value_size);
> +
> +	if (!value_size) {
> +		DMERR_LIMIT("%s failed: value_size is zero", __func__);
> +		return -EILSEQ;
> +	}
> +
> +	if (max_entries !=3D calc_max_entries(value_size, size_of_block)) {
> +		DMERR_LIMIT("%s failed: max_entries %u invalid for value_size %u",
> +			    __func__, max_entries, value_size);
> +		return -EILSEQ;
> +	}
> +
> +	if (nr_entries > max_entries) {
> +		DMERR_LIMIT("%s failed: too many entries", __func__);
> +		return -EILSEQ;
> +	}
> +
>  	return 0;
>  }

[Severity: High]
Does validating max_entries and nr_entries only against the on-disk
bh_le->value_size in array_block_check() still allow out-of-bounds reads
in element_at() and trigger the BUG_ON() checks in fill_ablock() and
trim_ablock() when bh_le->value_size does not match info->value_type.size?

In drivers/md/persistent-data/dm-array.c, neither get_ablock() nor
__shadow_ablock() checks that the on-disk ab->value_size matches
info->value_type.size after dm_tm_read_lock() or dm_tm_shadow_block()
validates the block:

drivers/md/persistent-data/dm-array.c:get_ablock() {
	r =3D dm_tm_read_lock(info->btree_info.tm, b, &array_validator, block);
	if (r)
		return r;

	*ab =3D dm_block_data(*block);
	return 0;
}

However, element_at() computes entry offsets using info->value_type.size
rather than ab->value_size:

drivers/md/persistent-data/dm-array.c:element_at() {
	unsigned char *entry =3D (unsigned char *) (ab + 1);

	entry +=3D index * info->value_type.size;

	return entry;
}

If a corrupted or crafted on-disk array_block header has a smaller
value_size than info->value_type.size (for example, value_size =3D 1,
max_entries =3D 4072, and nr_entries =3D 4072 in a 4096-byte block when
info->value_type.size is 8 in dm-cache or dm-bitset), array_block_check()
succeeds. Callers that iterate up to le32_to_cpu(ab->nr_entries), such as
dm_array_cursor_next() and dm_array_cursor_get_value() (via
dm_cache_load_mappings()), walk_ablock(), on_entries() (via
inc_ablock_entries() and dec_ablock_entries()), and trim_ablock(), will
still advance index up to 4071 while element_at() strides by
info->value_type.size, reading past the end of the dm-bufio block buffer.

Conversely, if on-disk bh_le->value_size is larger than
info->value_type.size, array_block_check() accepts a smaller
ab->max_entries than the capacity computed from info->value_type.size in
dm_array_resize() -> array_resize(). When array_resize() passes new_nr up
to resize->max_entries into fill_ablock() or trim_ablock(), it can still
trigger BUG_ON(new_nr > le32_to_cpu(ab->max_entries)):

drivers/md/persistent-data/dm-array.c:fill_ablock() {
	uint32_t nr_entries, delta, i;
	struct dm_btree_value_type *vt =3D &info->value_type;

	BUG_ON(new_nr > le32_to_cpu(ab->max_entries));
	BUG_ON(new_nr < le32_to_cpu(ab->nr_entries));
	...
}

Should get_ablock() and __shadow_ablock() also verify that
le32_to_cpu((*ab)->value_size) =3D=3D info->value_type.size before using or
incrementing the block entries?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016180222.4058=
164-1-sashal@kernel.org?part=3D1
