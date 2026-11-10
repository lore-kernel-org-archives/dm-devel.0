Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794287041;
	b=mGzVL6vQteouWO6/F9W9qWxKVnSkSymDr/LiKU+2qryQPeHEWJpKBGus4uDp7i43FdGV
	 K1R0vsKnXBNXQ/+IrL6u+rybmiNIdw//hClSkoV17BW7MJRz2HiDEiFt9qudVbjw1PvSk
	 LW6IoFS3tXgJg3ypNN/0hSImulUS7TUZ2Vu6LxdfS9crOGAlhqivd/+9QDFI0UeSOCAcB
	 xMTeNocVcwy3H/n83g+yH/ebp2C3d3/65CErQsh7RLueAvJzRga2v2gFq377K1uupQ8/p
	 keMbt649Auu2/PnG53X99ocFGN7Z9KRVD72TzFAIfW+5EJ6xxpSf9YYowyIgOmtgQhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794287041;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KIPNC7TH3GLyr8c0vU8gxV031B3DMafeEFgVVJL094w=;
	b=UnTWIcvTvX02MnMNgPTQky/KomNXxnhg5eoIlG83k8nn+2jGtSMi7tpbNWo9e6ag18lF
	 tetF0JsCNJRBbm6+IHk9oPFNk4BZGkPtq9h4p/X6RbHsmOPuX9IKai/a7h3HE2zGdGMib
	 p7fKxZC6/MjUl5emHQT4T6wolVQ7dsLccFM9I9FFuFn1EUhOW8bWM+dzDB1AeEJLuZnpQ
	 8e3ss3UaWtR+OGCdMHYnViwv/iA9DZbciVGf/7sBfXj7l2wZcVJkSGoTaa3t2uLMUtEU4
	 65X7VDuqFni0e4cZe68ibzJRX1EfDLMYGmzlzZF2nbGmF8v3nXIJj0yGyAroQCq2wPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SOL+eZml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B4A606B883;
	Tue, 10 Nov 2026 05:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SOL+eZml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80E41F008A7;
	Tue, 10 Nov 2026 05:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794287040;
	bh=KIPNC7TH3GLyr8c0vU8gxV031B3DMafeEFgVVJL094w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SOL+eZmlKuD5XXNpRz8PMRHzQ3ijcV4J/Vv/QTZH4bNXdexXzMR0pmkDBHojHqUrD
	 RY1n0X+bkWs3oLNygGMot2m652WGOkdWybV18hhIAVQbsuraVSZXOVaD/yPiGLASyH
	 wqwFlZNtxy2Rj3Clqsj8mn4Gu+2Fw3qLU5HvT7nx2ZfDo2py9dXI8kvEA5EvqzUFMI
	 9JQ285vGMkNYJPSqHmJrXMwCevPem9HHmeAEy3OrsPl3fDGLHbZKORn68GXrjwK5hV
	 K2KQDAMxDncpZy1kQ7tnH99L/2tWhjSX9uNvluBT9fTtjlHlFSlg67sC6+OhP2Bror
	 D57chJnsoZoPw==
Message-ID: <sashiko-outbox-206254@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/3] KEYS: Replace assoc_array with rhashtable
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
In-Reply-To: <20261110044043.2608600-3-jarkko@kernel.org>
References: <20261110044043.2608600-1-jarkko@kernel.org>
 <20261110044043.2608600-3-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:03:58 +0000
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
- [Critical] keys: uninitialized return value in __key_link_begin() on
  link replacement
- [Critical] keys: goto jumps past __free(kfree) initialization in
  __key_link_begin()
--

commit 1bfb81a86d8ef725610c02d9a07de1a279485dd1
Author: Jarkko Sakkinen <jarkko@kernel.org>

KEYS: Replace assoc_array with rhashtable

This commit replaces struct assoc_array in struct key with a new
rhashtable- and list-backed struct keyring_index and struct keyring_link
implementation.

> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index ac48d6204915a..60309f18e3a56 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c

[ ... ]

> @@ -1317,57 +1155,94 @@ int __key_move_lock(struct key *l_keyring, struct=
 key *u_keyring,
>  int __key_link_begin(struct key *keyring,
>  		     const struct keyring_index_key *index_key,
> -		     struct assoc_array_edit **_edit)
> +		     struct keyring_edit *edit)
>  {
> -	struct assoc_array_edit *edit;
> +	struct keyring_link *replace;
> +	struct keyring_index *links;
>  	int ret;
> =20
>  	kenter("%d,%s,%s,",
>  	       keyring->serial, index_key->type->name, index_key->description);
> =20
> -	BUG_ON(index_key->desc_len =3D=3D 0);
> -	BUG_ON(*_edit !=3D NULL);
> +	if (WARN_ON(index_key->desc_len =3D=3D 0) || WARN_ON(edit->new)) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> =20
> -	*_edit =3D NULL;
> +	edit->new =3D NULL;
> +	edit->old =3D NULL;
> =20
> -	ret =3D -EKEYREVOKED;
> -	if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
> -		goto error;
> +	if (test_bit(KEY_FLAG_REVOKED, &keyring->flags)) {
> +		ret =3D -EKEYREVOKED;
> +		goto out;
> +	}
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
> -		goto error;
> +	links =3D keyring_get_index(keyring);
> +	if (IS_ERR(links)) {
> +		ret =3D PTR_ERR(links);
> +		goto out;
>  	}
> =20
> -	/* If we're not replacing a link in-place then we're going to need some
> +	struct keyring_link *link __free(kfree) =3D kzalloc_obj(struct keyring_=
link);

[Severity: Critical]
Do the three goto out statements above jump past the initialization of
link __free(kfree) into its scope?

This breaks the build with Clang (and GCC with -Werror=3Djump-misses-init),
and without stack auto-initialization, linking a key into a revoked
keyring jumps to out and runs kfree(link) on an uninitialized stack
pointer.  Returning early instead of jumping to out avoids entering the
cleanup scope before link is initialized.

> +	if (!link) {
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}
> +	link->hash =3D index_key->hash;
> +
> +	replace =3D keyring_find_link(links, index_key);
> +
> +	/*
> +	 * If we're not replacing a link in-place then we're going to need some
>  	 * extra quota.
>  	 */
> -	if (!edit->dead_leaf) {
> +	if (!replace) {
>  		ret =3D key_payload_reserve(keyring,
>  					  keyring->datalen + KEYQUOTA_LINK_BYTES);
>  		if (ret < 0)
> -			goto error_cancel;
> +			goto out;
> +
> +		ret =3D rhashtable_insert_fast(&links->ht, &link->node,
> +					     keyring_link_params);
> +		if (ret < 0) {
> +			key_payload_reserve(keyring,
> +					    keyring->datalen - KEYQUOTA_LINK_BYTES);
> +			goto out;
> +		}
>  	}
> =20
> -	*_edit =3D edit;
> -	kleave(" =3D 0");
> -	return 0;
> +	edit->new =3D no_free_ptr(link);
> +	edit->old =3D replace;
> =20
> -error_cancel:
> -	assoc_array_cancel_edit(edit);
> -error:
> +out:
>  	kleave(" =3D %d", ret);
>  	return ret;
>  }

[Severity: Critical]
Does __key_link_begin() return an uninitialized ret when replace is
non-NULL?

When a matching key already exists in the keyring, the if (!replace)
block is skipped without setting ret =3D 0.  In __key_create_or_update(), a
negative stack value below -MAX_ERRNO makes ERR_PTR(ret) return a
non-error pointer that add_key() dereferences and passes to
key_ref_put().  In key_reject_and_link(), a positive stack value skips
both the link_ret < 0 and link_ret =3D=3D 0 paths, leaking edit.new and
returning with keyring->sem write-locked.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110044043.2608=
600-1-jarkko@kernel.org?part=3D2
