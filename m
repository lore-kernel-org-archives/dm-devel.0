Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794283900;
	b=RRuh7EkRTKz8bCb3uNHifMIVLMI+yC1m1wDy2wJxFnwYNzBHynBaMgPC8JcLALI2FsL0
	 cGDqnc/qcs+sn2E7HhCLCQzrm4e7hQ9Lvmla3cWFwrNbjQ/sPUedNtVp3GEVV7GFZe+Sh
	 8zjvvdpi8T/oe2CqOdg5kzKcBlYrHahQhFV1cpT/42nbEngdlrjUaIRCQNNfkXDsmZ7Io
	 ISmQ/RISbl3TO2e7GwQT0663O4oAsi2EGqcnRCF2gzTPnN4oD0AlRG/pdFZ2ltEtmdtwu
	 JyTs9hRwKbHguXLzzsZo73OQka+P63N2pCNOON7PUq3zvfTq0cBREabFY/YNOzoQb/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283900;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YHXidAFNXoaiLO002WziYhPSP8qLeOfv4lUIVNDDdBI=;
	b=zZbfNqsCbS71AXew91uoTA487l739649zCR7omzUKOwV+CcmXxbhTDDawl8t73bVW8Lx
	 n0yMUWfytHRVYJGVZjItdlSTxkpBRy9BwpcKEw9uXDHj7DwpL7eQkdTiV5Nz9iefd06Qe
	 bcd3VBshPYFK8mgzu1A2Mv6ZHVLVG2YafsZctmkYjuMKNevn/MZ+AYX9oOsZFIESA6zlB
	 /HHIuKN6jGEuckVfBUm1u5XqL2FjKKQVCgnJi6YUK9kRbhm+6oNhIHMXo63CXaI/0iRQg
	 z6XRO7ojgOquAhkL+w/6mdDpYnLxkYtFFdgNUx+Yddu7JGRtykiAP/RTMftz5BYypEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XDQgoYhz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6AC2C606AA08;
	Tue, 10 Nov 2026 04:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XDQgoYhz
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 482C61F0092B;
	Tue, 10 Nov 2026 04:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283900;
	bh=YHXidAFNXoaiLO002WziYhPSP8qLeOfv4lUIVNDDdBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XDQgoYhzLB1XsKLafILGmqd0YGsnN0nbPJHcJvNgo0e9h6urfd8eONU8I1fRsk9vZ
	 t8KRELDKpo0U/YkqQ15tASfqFXYWezQ/kFtwjshV5bXG8s7NS2s5frdw26wLdn0wri
	 4L+4v7faS0/1zWMMF/aqzaT5dam9UzUGCRp8jFyiEn1ylnSW5dmpsOvV4arI3xm6qe
	 jQHfiWibd4x2jh6cEbk1ATEYt0rgydieaU4aAfuqaeLFt/BAPaL5JwFuKCK3txZdZf
	 a8besfPzisZ9qNerp1H29SsSAYGosVacDRo9Hf7G6ThpnCs31+2XF6GYd397dPVLOq
	 NGI0Dd2AU2CdQ==
Date: Tue, 10 Nov 2026 06:11:36 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>, bpf@vger.kernel.org,
	dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Biggers <ebiggers@kernel.org>,
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
	Yonghong Song <yonghong.song@linux.dev>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <avKZeB9VH0cavfr4@kernel.org>
References: <20261110033738.2495880-1-jarkko@kernel.org>
 <20261110033738.2495880-3-jarkko@kernel.org>
 <sashiko-outbox-206155@kernel.org>
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
In-Reply-To: <sashiko-outbox-206155@kernel.org>

On Tue, Nov 10, 2026 at 03:56:03AM +0000, sashiko-bot@kernel.org wrote:
> [Severity: Medium]
> As reported by Eric Biggers on v5 [1], should keyring_link_params set
> .insecure_elasticity = true instead of looping on -EBUSY here?
> 
> Without .insecure_elasticity, rhashtable_insert_fast() enforces the
> 16-entry bucket chain limit (RHT_ELASTICITY) and returns -EBUSY to trigger
> a rehash.  Because keyring_obj_hashfn() only hashes the 32-bit link->hash
> via jhash_1word(), entries with colliding 32-bit SipHash digests cannot be
> split by rehashing with a new seed, so __key_link_begin() can spin
> indefinitely in this loop while holding keyring->sem.  This was fixed in
> v6 by setting .insecure_elasticity = true and dropping the retry loop, but
> appears to have been lost in v7.

Ugh, I fixed this already.

Clearly something went wrong with the rebase :-/

I'll manually apply v6 patches and send v8.

I honestly don't know what happened (likely the branch was not up to
date in the first place). Sorry.

Br, Jarkko
