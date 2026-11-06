Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989815;
	b=mjOm4bvKHhQZ0ba4XNaQU5Q5snp0vNhUnt3fCHVAJq3gnWjUWNInGeOdAc1sYc9FTNY1
	 PyG5iPfIHScXgqtViVtrWKK/4+I6aloxlul8hBUlDYYOP3vvr3ENCcmXymmHRgEbkM8y+
	 JVo6gGq8cyLvxvCZIwlQ7O/Vd+AQ0Vb4E4T2cdJLybWt4Ee0er1RTd2TTbZI9/JSU60Ra
	 v80csOySxnswe/tp63c5uvEFDy+oo+IKBZ+WXFRiYIej02rwVA6OdkW3LPk+CPm2j98wL
	 gTec/EjAgVqZaK9BtTVQokPFIPLqtwZBQXbbjLeIJoLuIhihXzbNVCNi/khyBraBtnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989815;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UliTkuKSwijkprFnPvplR6mcOQUjgocutB6yCvWNZyo=;
	b=Th6I/Pb+hYw6OrfzUw5Tv0SAs+gJcF916KklXap8jaNXuh4erF2s2DNMur560etHTBFA
	 21N/KvpXpjGxB7mZczj7JTMzoqojPoUme8dSWgEu0a2/DhMP39RpPzHsDpoUP2kcv7dfL
	 stRwxiMzJRqjPv3NLeKQj2yH50Yc+f0hxQAez4MIilkH1Ano1mfDFxCWKZ9kXd968sGNJ
	 drqM5pmILct/4ll72eW+ayqfxm1Hm7oFMJdz5E57ZvkWMcmDzyTV8cT7rqQNdyoOMrofY
	 1Cs/0cz+wDv3QBYWjS7FMZ9EDoGhCg69z06/d1NEWDa9ZqnoRAemRrSqgHZaMsNkvPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux.win;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9DB606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:30:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB9DB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b6e7a05225so1089694a12.0
        for <dm-devel@lists.linux.dev>; Fri, 06 Nov 2026 10:30:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793989813; x=1794594613;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UliTkuKSwijkprFnPvplR6mcOQUjgocutB6yCvWNZyo=;
        b=Tix98C2s1h4n6OwcF8nFgss9AmgDH1cu0MOc9PYyxxDXIOibJ3gypGPgX2uRNoiq3v
         i7f7sunQR2Hbi4hcjM46GzfBwIoVe0uU8Cg+VVD/ESynZfMwTNU25XFrMOdZRd8UgzoD
         XFTpeREvje+Za7T34bSWdjwV1W3FFyXJrqBcVQ1THwLa2d5drZu0iAktlAuuhI8O6jMN
         Dih96NLhWKztPg6l1al8qNycHlQyfvTNr6UvrMZPpKCWo+6NfaAEp1MNDelMMcU17nfo
         Qpizc6b7M5Zzsp4pSC2InYiRJuHbN0orGyScRhhQeFB0rWXI+ScAeQ2A0ybIvh6FXxRY
         YpWg==
X-Forwarded-Encrypted: i=1; AL+hErHiiA0McGG+FMl89OQhgHqDbiwLxvFY7eAZBc8vvEZJgLNCFYCeQ9Q5UkGkTib10+EyCPJ27M/aPg==@lists.linux.dev
X-Gm-Message-State: APuU4Z9SzNgjyxBvqKd0+zgfgJ5Xkdm+yLifQXEc6otOKDHHiYvXy+G7
	hsT+YYD0T9pZklPCX2SVBVOkkqBNwsbfYB3GDNLyLV6xyPqxWL0KQ+W71kXb52lckOk=
X-Gm-Gg: AYBFou3b5Sxc54SSXbEVVee55eeyK0jpa2vqJkBrtHtHWR10IS3OmD6clOQGjtk7+FB
	p/yrMEkjZl/qZxhPNaVu6VoAKXgYTBtDij5PL7mb6Qf+Uooe2jZExqwPsKUOb/pVKy+bHMwFmXj
	Jbc771/kxHI+XA/myn3Ieg38RA5js2j6XkP+CnNnNadjz0uxGxkKg30JuRrkN9QuuiCEvKH0Gti
	NO+EIoXj8jtrF6aOp/Z2aNc2+9YzqS8opgrIpOwDZ5BiWgbq0zj5gTMt5d3318H0/36/xVFjTX4
	Tl/V+F1osi2rBpV1wHQIBGEoOhh3URYjoQX/Lcd00hUpkVNMAtjPeAhy42IHo54S+I9XO3w2GFG
	rdnnJmdLipvU2v2BgZxeqc8o1tLGDtKvBFDhO+UccKpYjBdM/XvKmdWLLRR/NIKYtiSkp/+eG2k
	EMlQ8XKEixQN5w4Bs5W5DN30x7jyotAaxE0nFZfjA7ZGl4u12AlL+pT0eeBjqgzEKYkbjlAdPRn
	enaZ/XViiEe6OKQ5DVI72b/jSZ3seBN1o6LJYs9UIgJtcJzJC/PbMqJLlE3a5Yy/wbPIWvKLQiD
	/SyzcNBtxV3YUBKmcYG1RmJL6sQo30ovoKEyT3bCPBY1g0nEEP0N0gpSwKA=
X-Received: by 2002:a05:6402:5d5:b0:6b5:660b:70dd with SMTP id 4fb4d7f45d1cf-6b5977dba8bmr2543328a12.21.1793989812978;
        Fri, 06 Nov 2026 10:30:12 -0800 (PST)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b664ad2d0bsm953045a12.10.2026.11.06.10.30.08
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 10:30:09 -0800 (PST)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so143820366b.2
        for <dm-devel@lists.linux.dev>; Fri, 06 Nov 2026 10:30:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHoxlV8Av7yfuCnyNxSwER9ITI+80kP5GKVkXUY6Usae7bbEKrLDOmfON3yeghYPuVohNxJw4z/SQ==@lists.linux.dev
X-Received: by 2002:a17:907:ea89:b0:c4c:bff4:200c with SMTP id
 a640c23a62f3a-c4d3531f031mr283547466b.32.1793989808075; Fri, 06 Nov 2026
 10:30:08 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029232437.2581640-1-jarkko@kernel.org> <20261029232437.2581640-2-jarkko@kernel.org>
In-Reply-To: <20261029232437.2581640-2-jarkko@kernel.org>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 6 Nov 2026 18:29:56 +0000
X-Gmail-Original-Message-ID: <CAOs+rJVNyJwqp4CR-d_T4GVjNMjgbaDL78_mZCVGGvN1xpd33w@mail.gmail.com>
X-Gm-Features: AclHuK8TGNjpH-aL7rdb3WJ8RwrdjoKcrJ52VddwbSIE-hld3YHoMNkMBO-NFbA
Message-ID: <CAOs+rJVNyJwqp4CR-d_T4GVjNMjgbaDL78_mZCVGGvN1xpd33w@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] KEYS: Introduce keyring_is_empty()
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, 
	"open list:ASYMMETRIC KEYS" <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, 
	"open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO..." <fsverity@lists.linux.dev>, 
	"open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)" <bpf@vger.kernel.org>, 
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 11:25=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org=
> wrote:
>
> Introduce keyring_is_empty() in order to decouple for BPF, dm-verity and
> fs-verity how keyring internally manages the keys.
>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Reviewed-by: Ignat Korchagin <ignat@linux.win>

> ---
>  drivers/md/dm-verity-verify-sig.c                      |  2 +-
>  fs/verity/signature.c                                  |  2 +-
>  include/linux/key.h                                    |  1 +
>  kernel/bpf/keys.c                                      |  2 +-
>  security/keys/keyring.c                                | 10 ++++++++++
>  .../selftests/dm-verity/test-dm-verity-keyring.sh      |  2 +-
>  6 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-ver=
ify-sig.c
> index aadcf5e4a47c..cad21e9144ed 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -153,7 +153,7 @@ int verity_verify_root_hash(const void *root_hash, si=
ze_t root_hash_len,
>         if (ret !=3D -ENOKEY && ret !=3D -EKEYREJECTED)
>                 return ret;
>
> -       if (dm_verity_keyring->keys.nr_leaves_on_tree &&
> +       if (!keyring_is_empty(dm_verity_keyring) &&
>             dm_verity_keyring->restrict_link)
>                 ret =3D verify_pkcs7_signature(root_hash, root_hash_len,
>                                              sig_data, sig_len,
> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> index 0302a4e506ec..890d33b9d812 100644
> --- a/fs/verity/signature.c
> +++ b/fs/verity/signature.c
> @@ -67,7 +67,7 @@ int fsverity_verify_signature(const struct fsverity_inf=
o *vi,
>                 return 0;
>         }
>
> -       if (fsverity_keyring->keys.nr_leaves_on_tree =3D=3D 0) {
> +       if (keyring_is_empty(fsverity_keyring)) {
>                 /*
>                  * The ".fs-verity" keyring is empty, due to builtin sign=
atures
>                  * being supported by the kernel but not actually being u=
sed.
> diff --git a/include/linux/key.h b/include/linux/key.h
> index c4486e938a06..20ca43f5eab1 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -439,6 +439,7 @@ extern int restrict_link_reject(struct key *keyring,
>                                 struct key *restriction_key);
>
>  extern int keyring_clear(struct key *keyring);
> +bool keyring_is_empty(const struct key *keyring);
>
>  extern key_ref_t keyring_search(key_ref_t keyring,
>                                 struct key_type *type,
> diff --git a/kernel/bpf/keys.c b/kernel/bpf/keys.c
> index bffc356839ac..24e0416abc99 100644
> --- a/kernel/bpf/keys.c
> +++ b/kernel/bpf/keys.c
> @@ -29,7 +29,7 @@ struct bpf_key *bpf_lookup_keyring(void)
>
>         if (!bpf_keyring)
>                 return NULL;
> -       if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
> +       if (keyring_is_empty(bpf_keyring) ||
>             !READ_ONCE(bpf_keyring->restrict_link))
>                 return NULL;
>
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index 5281da9d5bf7..ac48d6204915 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -443,6 +443,16 @@ static void keyring_destroy(struct key *keyring)
>         assoc_array_destroy(&keyring->keys, &keyring_assoc_array_ops);
>  }
>
> +/**
> + * keyring_is_empty - Check whether a keyring is empty
> + * @keyring: The keyring to check.
> + */
> +bool keyring_is_empty(const struct key *keyring)
> +{
> +       return READ_ONCE(keyring->keys.nr_leaves_on_tree) =3D=3D 0;
> +}
> +EXPORT_SYMBOL(keyring_is_empty);
> +
>  /*
>   * Describe a keyring for /proc.
>   */
> diff --git a/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh =
b/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
> index 1f9601ef22f8..792449d356cf 100755
> --- a/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
> +++ b/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
> @@ -746,7 +746,7 @@ test_keyring_inactive_when_empty() {
>      log_info "TEST: Verify dm-verity keyring is inactive when sealed emp=
ty"
>
>      # When keyring_unsealed=3D0, the keyring is sealed immediately while=
 empty
> -    # This means it should NOT be used for verification (nr_leaves_on_tr=
ee=3D0)
> +    # An empty keyring should NOT be used for verification.
>
>      log_info "Keyring state (should be empty and sealed):"
>      list_keyring_keys
> --
> 2.47.3
>
>
