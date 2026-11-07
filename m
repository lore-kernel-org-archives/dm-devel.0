Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794084133;
	b=QhvuhvshrTL+oJqEwDjvFYoy5N5D1us+K6SlqIwUc3B8DA1f5JKM3gkVWCEn/Xlt7rcD
	 cLDdgmblvgFZNBbeMpdvu/hIJlElBxVz9kpxtZ7qlupzmASiBbG9bNU0wnCTpM/cVplSZ
	 ql4YCAEKVbgxVqQe4HJdRbySqRCzdBcHrVNlL2gRWq+Gt+nCt17NFdn7eL+P8yRTAFqk9
	 xaseRpi6wvcWzyDwwipxRvhwU0f8Cc0skFwaPStHXxeDCAyPR0xKIUu+uOyk485vsOO/I
	 ZIwTc+Qn52LaeyxC/ITTsfnVuKyqQoYYazJemTvRK/hpHhPlUTMFOTxNkyV0VjbGqHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794084133;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vt9E+5gU7NQ+Wi6z2HfmB+6KsnzMwitmxcnzRralzow=;
	b=K8Up2qhvAWN6iqi+8zLohCs0N7EStequwm2WhLeqCvRHIH3JFYOYXGLLlnwZehQc1ZnR
	 d/qAU2cOjltseNaiTE87mxguZdqoG1UMuM29rKYBFCoa70+MHTngX78+bCsGJdjqQtL4b
	 lWyeQRPyXF8BbrxjQ9CSYefsS+1YoiBKC3WkVW4EvkuqEBFobSP8W3WI2rW/xsQ+3N78q
	 JlELn9ECrvZqpMBw0RIgU9hU1u0SoFe8CKo2IJZQa9w3BgKkXHbehdlVwYrkgsoGb3HOA
	 zneznpffKSwauq4VivCLz941Tj/CQD5Gz7QGSBEE5xSHxfM3SYB0/PAmsv9Es8Gl9lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QdgeqcGm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A167606A32E;
	Sat,  7 Nov 2026 20:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QdgeqcGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10651F0089F;
	Sat,  7 Nov 2026 20:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794084133;
	bh=vt9E+5gU7NQ+Wi6z2HfmB+6KsnzMwitmxcnzRralzow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QdgeqcGm7aLjvMwhDXbnVrXyrjxTJoRQkqRIsDjcoduMOTEL8GCNOFQSiDbwYCCXA
	 bdiOlqUv4nmV7s8TUKhpFnqxqC6DSKCS1JUo3diwp71Rk0vlgv1Nh8kEE+kDsic1tz
	 A+Jb5V3672/95emWmClD9muYAGY/rWdyjIttmwrc+GYxS6MurZyD0azH7QdvjXiOYE
	 GXdd+qElL0kyHa09o4qK64HoO7MAQfsV8IpmBzQ6+Res9Ewlsf0DCXIDsQqqLpTLm2
	 O/+ktjWajqgRw+TV+MG2JVz5d1/6q6chhmKGj+4z5BEqZwVpkAS+1MglhWGlk1QczL
	 LwZyEhkdgqX/A==
Date: Sat, 7 Nov 2026 12:42:10 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, bpf@vger.kernel.org,
	dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
	keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ignat Korchagin <ignat@linux.win>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	James Morris <jmorris@namei.org>, Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>, Song Liu <song@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Yanteng Si <si.yanteng@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: Re: [PATCH v6 0/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <20261107204210.GG6049@quark>
References: <20261107195605.3929659-1-jarkko@kernel.org>
 <au-FkAtC4Gcw7Bkb@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au-FkAtC4Gcw7Bkb@kernel.org>

On Sat, Nov 07, 2026 at 10:09:52PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 07, 2026 at 09:56:01PM +0200, Jarkko Sakkinen wrote:
> > The keyrings subsystem is the sole user of assoc_array. It has over 1700
> > lines of code, no test suite, and a long history of bugs, with LLMs now
> > finding more.
> > 
> > This unfortunate outcome has evolved over time by large from the shortage
> > of in-kernel callers, time bandwidth and 3rd party contributors.
> > 
> > What the keyrings subsystem needs is just a generic key-value store, which
> > performs well with sparse key sets. Replace assoc_array with an
> > rhashtable-backed keyring index and remove assoc_array from the kernel.
> 
> Sashiko: https://sashiko.dev/#/patchset/20261107195605.3929659-1-jarkko%40kernel.org
> 
> Not addressing this as only one patch changed and the change was
> exactly:
> 
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index 772fa0e35f9d..6761c6801edc 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -12,7 +12,6 @@
>  #include <linux/security.h>
>  #include <linux/seq_file.h>
>  #include <linux/err.h>
> -#include <linux/delay.h>
>  #include <linux/jhash.h>
>  #include <linux/user_namespace.h>
>  #include <linux/nsproxy.h>
> @@ -101,6 +100,7 @@ static const struct rhashtable_params keyring_link_params = {
>         .min_size               = 4,
>         .nelem_hint             = 3,
>         .automatic_shrinking    = true,
> +       .insecure_elasticity    = true,
>  };
> 
>  static struct keyring_index *keyring_index_locked(const struct key *keyring)
> @@ -1225,12 +1225,8 @@ int __key_link_begin(struct key *keyring,
>                 if (ret < 0)
>                         goto error;
> 
> -               do {
> -                       ret = rhashtable_insert_fast(&links->ht, &link->node,
> -                                                    keyring_link_params);
> -                       if (ret == -EBUSY)
> -                               fsleep(100);
> -               } while (ret == -EBUSY);
> +               ret = rhashtable_insert_fast(&links->ht, &link->node,
> +                                            keyring_link_params);
>                 if (ret < 0) {
>                         key_payload_reserve(keyring,
>                                             keyring->datalen - KEYQUOTA_LINK_BYTES);
> 
> So I don't think there are any real issue with the patch set, except I
> will need to rebase the commits to the latest mainline.

It looks good to me now too, but it would be good to get a Sashiko run
on the latest version.  Sashiko hasn't run since v3, as it failed to
apply the series.  You should base the series on a commit in either
mainline or linux-next, and pass the '--base' option to 'git
format-patch' so it adds a 'base-commit' line.

(The only reason I've been able to apply it myself for review is that I
went out of my way to find your keys-rhashtable branch in git.)

- Eric
