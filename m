Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794673500;
	b=PtrELGZFOXQJrHTb88hC3F29s6lpoum13kiBTTE/P69Ud6+6yp6WYZ6apxp9FMda3H2d
	 JNS+3MP9wFJjetp73EcxTu7id5wqNE93s0YrSWOocpyK1dKF51gtcRKMd1/+c54Ur2P5O
	 TyFCFnO4oIYJd35ZruO1sa97OsT2XNZ2xKu5Xqj8A1AfZ1xf+UBd5l9q3aqFk8zuvFbRl
	 UIgWT0jQic1xauSOFsWw92bR5SKvDW3TSVssKu6nCQeN/mUHXtgXOIKxHVF1M3jHlySwx
	 dZlBa5mEtFqRKVrSLEWDfogJe/ShVLUdt86u4K/brvXCWwNxfhYABQfdsbkjaUcZtVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794673500;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jz87ZYAGYqcJoQ2kmgOqlDTLnLIOTXTc1pDphy7g1RE=;
	b=Pxd4Ue6B+fpEeqktT3tqbnMJ7YhPwtxJA20LA9D2MeiOP8oXtpTF/1lJplVmlw5jmwqR
	 UOGJx2E3U0ac3MbvQsGMpvRwXDlSuat496dPaoi1LCnYyCY0wDP2Nin0a7fp7Glc9PFwe
	 d6ekZDf0hzYTbUeh0K0mJPJ0yo7JVZorsEoClXnjXyiT2HhlxD8pSt43Qy7AwWfTYtjQk
	 Ldb1v5abeW8mFuG8xfZIUrlXJ49LY4TE1XIivf0vY9dpVUO7jYhHY9x3GXtVAJMPzhoyv
	 RvqXGvkZdL+RJebWf1/KIxrUC15iYTX9saxOkBhSmUPumeXUziUHsmpgAgbVxMUcBKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcS8h9k0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278BD606A323;
	Sat, 14 Nov 2026 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcS8h9k0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E621F000C4;
	Sat, 14 Nov 2026 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794673499;
	bh=jz87ZYAGYqcJoQ2kmgOqlDTLnLIOTXTc1pDphy7g1RE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IcS8h9k0FWz9/wTqT70Mz4pNudlz9lkzQ6zC1Y+N34DwysCH3QUfXZ6yKhUf5sJkW
	 L5h5NG1HmwxIgl71NruyEWRsRQZYsJY+zum3Z0lrM8pwjnQVS3ZvBYwjZDZX+dqSH3
	 msgnLxRYbaEoCtEOrZneKnHmDqTCpZ2TOVJ4dC8haUXi6oYS37tJ2EEG01Cl93BsSh
	 vUhTU8o242TJicB7zgMrhzbCyDj8yI1OuHLdZA0rvCsguf84GF/JnaTdqhs+E/XyFo
	 W6hp+ZivzxMBd9opbRsvGaECQQMvLgwJzlfiK2DEaoEMlkEAXJauxN625rgVeakEGw
	 BODbGLc8j73OA==
Message-ID: <sashiko-outbox-214746@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 3/6] s390/cert_store: Skip keys that disappeared
 during invalidation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "David Howells" <dhowells@redhat.com>
Cc: bpf@vger.kernel.org, dm-devel@lists.linux.dev, fsverity@lists.linux.dev, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, "Alasdair
 Kergon" <agk@redhat.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Alexei
 Starovoitov" <ast@kernel.org>, "Alex Shi" <alexs@kernel.org>, "Anastasia
 Eskova" <anastasia.eskova@ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Daniel Borkmann" <daniel@iogearbox.net>, "Dongliang
 Mu" <dzm91@hust.edu.cn>, "Eduard Zingerman" <eddyz87@gmail.com>, "Emil
 Tsalapatis" <emil@etsalapatis.com>, "Eric Biggers" <ebiggers@kernel.org>, "Ignat
 Korchagin" <ignat@linux.win>, "Heiko Carstens" <hca@linux.ibm.com>, "Ihor
 Solodrai" <ihor.solodrai@linux.dev>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "James
 Morris" <jmorris@namei.org>, "Jiri Olsa" <jolsa@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Linus
 Torvalds" <torvalds@linux-foundation.org>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Mike
 Snitzer" <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Paul Moore" <paul@paul-moore.com>, "Peter
 Oberparleiter" <oberpar@linux.ibm.com>, "Randy Dunlap" <rdunlap@infradead.org>, "Roberto
 Sassu" <roberto.sassu@huawei.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Song Liu" <song@kernel.org>, "Sven
 Schnelle" <svens@linux.ibm.com>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Yanteng Si" <si.yanteng@linux.dev>, "Yonghong
 Song" <yonghong.song@linux.dev>
In-Reply-To: <20261114161211.376859-4-jarkko@kernel.org>
References: <20261114161211.376859-1-jarkko@kernel.org>
 <20261114161211.376859-4-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 16:24:57 +0000
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
- [High] s390/cert_store: error pointer dereference in
  invalidate_keyring_keys()
- [Medium] s390/cert_store: stale positive return value in
  invalidate_keyring_keys()
--

commit ec7f40e3c2123cec6e6be32d5977d8c112a6da55
Author: Jarkko Sakkinen <jarkko@kernel.org>

s390/cert_store: Skip keys that disappeared during invalidation

This commit adds a NULL check after key_lookup() in
invalidate_keyring_keys() to skip keys that were unlinked before lookup.

> diff --git a/arch/s390/kernel/cert_store.c b/arch/s390/kernel/cert_store.c
> index 0a10b31d68af3..bc682216fa7fd 100644
> --- a/arch/s390/kernel/cert_store.c
> +++ b/arch/s390/kernel/cert_store.c
> @@ -333,6 +333,9 @@ static int invalidate_keyring_keys(struct key *keyrin=
g)
> =20
>  	for (key_index =3D 0; key_index < num_keys; key_index++) {
>  		current_key =3D key_lookup(key_array[key_index]);
> +		if (!current_key)
> +			continue;
> +
>  		pr_dbf_msg("Invalidating key %08x", current_key->serial);
> =20
>  		key_invalidate(current_key);

[Severity: High]
Should this check IS_ERR(current_key) instead of !current_key?  When a key
is not found or its usage count has dropped to zero, key_lookup() returns
ERR_PTR(-ENOKEY) rather than NULL, so current_key->serial and
key_invalidate(current_key) will still dereference an error pointer.

[Severity: Medium]
Can skipping keys via continue cause invalidate_keyring_keys() to return a
positive byte count on success?  Before the loop, rc is set to
keyring_payload_len by key_type_keyring.read() and is only updated by
key_unlink():

arch/s390/kernel/cert_store.c:invalidate_keyring_keys() {
	...
	rc =3D key_type_keyring.read(keyring, (char *)key_array, keyring_payload_l=
en);
	if (rc !=3D keyring_payload_len) {
		pr_dbf_msg("Couldn't read keyring payload");
		goto out;
	}

	for (key_index =3D 0; key_index < num_keys; key_index++) {
		...
		rc =3D key_unlink(keyring, current_key);
	...
out:
	kfree(key_array);
	return rc;
}

If all keys in key_array have disappeared and are skipped, rc remains
keyring_payload_len, causing cleanup_cs_keys() to treat the call as a
failure and unregister key_type_cert_store_key.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114161211.3768=
59-1-jarkko@kernel.org?part=3D3
