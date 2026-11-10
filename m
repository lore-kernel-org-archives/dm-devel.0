Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794282966;
	b=nJ5c5SbnqARlbXeM2yS5CGRJmlUsB1D8sCOEgYun/Kdq6yvwKt76J+eGiBakXINr9wGk
	 R0VWjF6tkX6yNlqD8uehivvi7ehRv0MdLX57VxZg/fedzqzFGG0PGAElrhtoMWemREHIj
	 dLzvnf2igEiTqT9C219OOLsNvGLuZvbT9t+7uLl9XwR45Gv3Nr4RLfcgtRsJxYrfzpasJ
	 NFNec/dnSeIU7hU0tcZZwxKiezoZQoebrYVux5Jym56JQXu8F9y9ZV+D9Mkb0bD2BS3f9
	 FRi/ZE/ucbtUNy/PPdjT25eysm+0cX1gcwzd4QbAPV1mBrYWoDDT3+7iLtfO+b+Pt6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794282966;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ySFTRwQkHFGZeTgCE/dxbzfLMGvRiDMXvrnQKuznBws=;
	b=UAz0gOCNii43FKbExGW2uKBnwjykUfRP5ofEH6gKrTj7EgNm+5bQZkD6a4lLdOtDAbA5
	 wYDQJl3fj/Ag22fyAqJlaPtDG9vKK6mVHAT8I7kZMFxRZ1kJZSInfxfNc1HCHjtXYQQLl
	 uAj4OlB4i0t8CQ24PdTbIXVj58UiNvRo6fscnLwrscAodEnRkxkTFaym3b8acLLkyA23F
	 y49OrxfcxJEx3ScKSyFPifg0ILQtI2VO4We0J85Gg19MuJsLWyrlRQIu2onn/TvzuCWlJ
	 9QYiQFdSajwyFgGQKs0o1raRdPVlQE9Z/bALmc18NttXnZBkhxBOIbbGqYRYUx3pt1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TgEvl0+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802E860A2601;
	Tue, 10 Nov 2026 03:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TgEvl0+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407C91F0089F;
	Tue, 10 Nov 2026 03:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794282966;
	bh=ySFTRwQkHFGZeTgCE/dxbzfLMGvRiDMXvrnQKuznBws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TgEvl0+MjLfSmtJNlwoZw16t6z4bqYXcwrqk6WyDApsyr/uRpog50QOCYqcfaDbYZ
	 FCt9yyV5z7PwpqKgOBk29XEwDzsz4kcw/JgTipw7RdTeoyC9oV1Y2jGIRaEHONpA+F
	 d5tq+HqbwX1sC70wMHz6C9goeYR+VRkPpTKH0dSrtp3wkKudjrnK7KyxtIVBMVQqrV
	 rJP4GB9l4/9inBG3KTZYRiieqC1+Xdh8B7Ula0fZYpHIe7L9zGLd+7aHslL5Sb+TQL
	 KCbOit45g6hbD+2BBQavQ4NlZxDQ9dXl7rjkyUCnBAU0J8yaZvvMbt7SWITYfcJkwH
	 D4eUkRN6zGxMQ==
Message-ID: <sashiko-outbox-206155@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/3] KEYS: Replace assoc_array with rhashtable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "David Howells" <dhowells@redhat.com>
Cc: bpf@vger.kernel.org, dm-devel@lists.linux.dev, fsverity@lists.linux.dev, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, "Alasdair
 Kergon" <agk@redhat.com>, "Alexei Starovoitov" <ast@kernel.org>, "Alex Shi" <alexs@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Andrii Nakryiko" <andrii@kernel.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Daniel Borkmann" <daniel@iogearbox.net>, "Dongliang
 Mu" <dzm91@hust.edu.cn>, "Eduard Zingerman" <eddyz87@gmail.com>, "Emil
 Tsalapatis" <emil@etsalapatis.com>, "Eric Biggers" <ebiggers@kernel.org>, "Ignat
 Korchagin" <ignat@linux.win>, "Ihor Solodrai" <ihor.solodrai@linux.dev>, "James
 Morris" <jmorris@namei.org>, "Jiri Olsa" <jolsa@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Mike Snitzer" <snitzer@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Paul Moore" <paul@paul-moore.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Song Liu" <song@kernel.org>,
 =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Yanteng Si" <si.yanteng@linux.dev>, "Yonghong
 Song" <yonghong.song@linux.dev>, "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20261110033738.2495880-3-jarkko@kernel.org>
References: <20261110033738.2495880-1-jarkko@kernel.org>
 <20261110033738.2495880-3-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:56:03 +0000
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
- [Medium] keys: missing insecure_elasticity and unbounded -EBUSY loop
  in __key_link_begin()
- [Low] keys: mixed goto and delayed __free() initialization in
  __key_link_begin()
--

commit 2ac2cea452f12974dec0263462b3e701c718671c
Author: Jarkko Sakkinen <jarkko@kernel.org>

KEYS: Replace assoc_array with rhashtable

This commit replaces the associative array in struct key with a
keyring_index backed by an rhashtable for direct lookups and an
RCU-protected list of keyring_link entries for ordered traversal.

> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index ac48d6204915a..772fa0e35f9db 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -31,25 +33,152 @@

[ ... ]

> +static const struct rhashtable_params keyring_link_params =3D {
> +	.head_offset		=3D offsetof(struct keyring_link, node),
> +	.hashfn			=3D keyring_hashfn,
> +	.obj_hashfn		=3D keyring_obj_hashfn,
> +	.obj_cmpfn		=3D keyring_obj_cmpfn,
> +	.min_size		=3D 4,
> +	.nelem_hint		=3D 3,
> +	.automatic_shrinking	=3D true,
> +};

[ ... ]

> @@ -1317,56 +1155,94 @@ int __key_move_lock(struct key *l_keyring, struct=
 key *u_keyring,

[ ... ]

>  int __key_link_begin(struct key *keyring,
>  		     const struct keyring_index_key *index_key,
> -		     struct assoc_array_edit **_edit)
> +		     struct keyring_edit *edit)
>  {
> -	struct assoc_array_edit *edit;
> +	struct keyring_link *link __free(kfree) =3D NULL;
> +	struct keyring_link *replace;
> +	struct keyring_index *links;
>  	int ret;
> =20
>  	kenter("%d,%s,%s,",
>  	       keyring->serial, index_key->type->name, index_key->description);
> =20
> -	BUG_ON(index_key->desc_len =3D=3D 0);
> -	BUG_ON(*_edit !=3D NULL);
> +	if (WARN_ON(index_key->desc_len =3D=3D 0) || WARN_ON(edit->new))
> +		return -EINVAL;
> =20
> -	*_edit =3D NULL;
> +	edit->new =3D NULL;
> +	edit->old =3D NULL;
> =20
>  	ret =3D -EKEYREVOKED;
>  	if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
>  		goto error;
> =20
> -	/* Create an edit script that will insert/replace the key in the
> -	 * keyring tree.
> -	 */
> -	edit =3D assoc_array_insert(&keyring->keys,
> -				  &keyring_assoc_array_ops,
> -				  index_key,
> -				  NULL);
> -	if (IS_ERR(edit)) {
> -		ret =3D PTR_ERR(edit);
> +	links =3D keyring_get_index(keyring);
> +	if (IS_ERR(links)) {
> +		ret =3D PTR_ERR(links);
>  		goto error;
>  	}
> =20
> +	ret =3D -ENOMEM;
> +	link =3D kzalloc_obj(struct keyring_link);
> +	if (!link)
> +		goto error;

[Severity: Low]
This isn't a bug, but per the cleanup.h conventions, link should be
defined and initialized at its kzalloc_obj() allocation site rather than
declared as NULL at the top of __key_link_begin() and mixed with goto
error paths.

> +	link->hash =3D index_key->hash;
> +
> +	replace =3D keyring_find_link(links, index_key);
>  	/* If we're not replacing a link in-place then we're going to need some
>  	 * extra quota.
>  	 */
> -	if (!edit->dead_leaf) {
> +	if (!replace) {
>  		ret =3D key_payload_reserve(keyring,
>  					  keyring->datalen + KEYQUOTA_LINK_BYTES);
>  		if (ret < 0)
> -			goto error_cancel;
> +			goto error;
> +
> +		do {
> +			ret =3D rhashtable_insert_fast(&links->ht, &link->node,
> +						     keyring_link_params);
> +			if (ret =3D=3D -EBUSY)
> +				fsleep(100);
> +		} while (ret =3D=3D -EBUSY);

[Severity: Medium]
As reported by Eric Biggers on v5 [1], should keyring_link_params set
.insecure_elasticity =3D true instead of looping on -EBUSY here?

Without .insecure_elasticity, rhashtable_insert_fast() enforces the
16-entry bucket chain limit (RHT_ELASTICITY) and returns -EBUSY to trigger
a rehash.  Because keyring_obj_hashfn() only hashes the 32-bit link->hash
via jhash_1word(), entries with colliding 32-bit SipHash digests cannot be
split by rehashing with a new seed, so __key_link_begin() can spin
indefinitely in this loop while holding keyring->sem.  This was fixed in
v6 by setting .insecure_elasticity =3D true and dropping the retry loop, but
appears to have been lost in v7.

[1] https://lore.kernel.org/r/20261107032551.GA1990@sol

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110033738.2495=
880-1-jarkko@kernel.org?part=3D2
