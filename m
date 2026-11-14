Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675698;
	b=gbJG25ZmPgGzxdyT5pPWFhA87jFWKkFmnqKMP32NAc1JhEswZQFrN0kjrSB+T8cpGxXA
	 DOzZVmgTKhdvoCM7S46OfBsCyJjT3MLCrR33mazbXutRhaMWZL550VBfF2Y6A9xuysBa9
	 pY1/YqVIFTe3OGobj5hyOx3umhSbFhH8FaO5CpB9T0kP3zqB4OPKUG9Ld8vR9C5Wqapj+
	 Ttg+U0jZ4HKlY1C65MzkPLzLYANJ6uL5Yoj5qy1G89KBKyks0aUKfwNAcRi9cAVs1S+iC
	 ajH8BzyY1thGR5jabavQe3VSTT1hCD1JWKbK8b0Z5Ew+ZapgulqcR9hXapxwXSA2+rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675698;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bm80fs2NeC70k7e6B2ZN8qEEqza+vKslbAZ0gAfzt7U=;
	b=ngImPP9LmXAz+U8xI4gsAefeycEm9ffQp5/J7PzNrzNLpkXoAZQLRi1gmtnd2F9psYp9
	 iu+jpN9Rtlij35s9KKtV6cvBWz2T5p0aU/zmX56wQAru2B0Y8yYIdeBNfUaZ20PIEL/MD
	 dZXc7ykvhi4/r75ytYb/uGzVcIs636qgnvxMm6yHD6fFLkBstkopvCNwVGAqQuOGnUUqv
	 bC8jA7eIBq2Fg8F4iPgZzALArVtAQqZl1IlgHLhIb3AYKIqLOBtCq7Gay7fhkMe3EolCF
	 nXDW2li1p2vlVcs5ePpmqYF4eRdXEqJOvCFz+fOd3GGMibN6Uvb6ElXM6K/7y9Gqv9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CtChy+Gk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D89A606A323;
	Sat, 14 Nov 2026 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CtChy+Gk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60901F000C8;
	Sat, 14 Nov 2026 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794675698;
	bh=bm80fs2NeC70k7e6B2ZN8qEEqza+vKslbAZ0gAfzt7U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CtChy+GkcKyQoOyaTV5M0d3dJ8crDGkKs0cvnZErF1XGLS2mw/OtrKo+ztrI6ZsQE
	 aViwIOZdq65SOeyLvb9DlfPgjRCkM1ZIC5Cr9Md0XwVgD/hxwx7T27tD05NAPzHyIT
	 1LbTKUd3ALnVTGvAtBWKLWb1YCkDABLNompgZJDVCj/Idpphp5bAlEaxsjnAMlOk/0
	 GCHlH+4JeyRn2clECzKFkG3+3be65TRXiZX8Y+poGwYCwJ+QPayho5GlFAjemjxeFr
	 IuIrJi2FhBJjJRqHpJN/T8W3Ztsj95UlkbfzhpjyK98r7qtgOZ/7PfyWykeO6duIID
	 p1Mu7+Cr23cFg==
Message-ID: <sashiko-outbox-214809@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 3/6] s390/cert_store: Skip keys that disappeared
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
In-Reply-To: <20261114164139.429814-4-jarkko@kernel.org>
References: <20261114164139.429814-1-jarkko@kernel.org>
 <20261114164139.429814-4-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 17:01:34 +0000
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
- [Medium] s390/cert_store: incomplete handling of unlinked keys in
  invalidate_keyring_keys()
- [Low] s390/cert_store: commit message claims key_lookup() returns NULL
--

commit 725043b976271178c0635971476e80ff473d9670
Author: Jarkko Sakkinen <jarkko@kernel.org>

s390/cert_store: Skip keys that disappeared during invalidation

This commit updates invalidate_keyring_keys() to initialize rc to 0 and
skip keys when key_lookup() returns an error pointer during keyring
invalidation.

> key_lookup() can return NULL for an unlinked key. Skip such keys instead.

[Severity: Low]
Is this commit message description accurate?  CONFIG_CERT_STORE depends on
CONFIG_KEYS, and when CONFIG_KEYS is enabled, key_lookup() returns
ERR_PTR(-ENOKEY) rather than NULL (which matches the IS_ERR(current_key)
check in the diff).

> diff --git a/arch/s390/kernel/cert_store.c b/arch/s390/kernel/cert_store.c
> index 0a10b31d68af3..03391b379dad3 100644
> --- a/arch/s390/kernel/cert_store.c
> +++ b/arch/s390/kernel/cert_store.c
> @@ -331,8 +331,13 @@ static int invalidate_keyring_keys(struct key *keyri=
ng)
>  		goto out;
>  	}
> =20
> +	rc =3D 0;
> +
>  	for (key_index =3D 0; key_index < num_keys; key_index++) {
>  		current_key =3D key_lookup(key_array[key_index]);
> +		if (IS_ERR(current_key))
> +			continue;
> +
>  		pr_dbf_msg("Invalidating key %08x", current_key->serial);
> =20
>  		key_invalidate(current_key);

[Severity: Medium]
Does skipping only key_lookup() failures still leave unlinked keys unhandled
later in invalidate_keyring_keys()?

When a key is unlinked from a keyring, dropping its reference is deferred to
an RCU callback (or another reference may exist), so key_lookup() still
succeeds; key_invalidate(current_key) also schedules keyring_gc(), which can
unlink current_key before key_unlink() runs:

arch/s390/kernel/cert_store.c:invalidate_keyring_keys() {
	...
		key_invalidate(current_key);
		key_put(current_key);
		rc =3D key_unlink(keyring, current_key);
		if (rc) {
			pr_dbf_msg("Couldn't unlink key %08x: %d", current_key->serial, rc);
			break;
		}
}

In either case, key_unlink() returns -ENOENT, aborting the loop before the
remaining keys in key_array are invalidated and causing cleanup_cs_keys() to
fall back to unregister_key_type(&key_type_cert_store_key).  Note also that
key_put(current_key) drops the caller's reference before key_unlink() and
current_key->serial are used.

Similarly, if a key is unlinked between the two key_type_keyring.read() cal=
ls
earlier in invalidate_keyring_keys(), the second call returns a smaller byte
count than keyring_payload_len and jumps to out without invalidating the
remaining keys, returning 0 if the last key was unlinked or a positive byte
count otherwise.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114164139.4298=
14-1-jarkko@kernel.org?part=3D3
