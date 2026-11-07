Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794021954;
	b=Szaw+CvR0NhGLftBcaJqa0DSrLZywNPOrvvws5TS84WLoHKnBDU+JaUMk51T02k+1sdU
	 JGUYpOgRg0mHOaWeN3WWSU8VDHe+TZlouNW2astW/7S2GtfsWEqIZeopnLslFXNUv3awY
	 rUYesTQaorfBbrGua5SG/1ybjnU6qDny46rSafla52mE/brCAtu2s975LH+ibqG1Zhg7T
	 2xhed/VJi4os1xjR2ZfKwoSlbvA7QtX9TAqsnzgGvtHX3z9jDRHP5/ieyJ7RwDdbhvdT6
	 jzOO0qYX0n1GQ68kdrC2ZcuZXkQnR3rlh0VervsfnND6QI3prLITTIiMOd1xmHVv7Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794021954;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=mxiid2hy6pGN9sHLzXHLOnDequd95SafDDGiZTsr7dg=;
	b=C0JEKT4X6BLJQ6Doi84hmzpbXcH3OzfOu6dp+ZhIe6LMh+LF9mvpVIVAkpa3iA3/a1uS
	 xOAhRZLL2ptouO2TliVTqK4Ei6zCTnzRLuwFunMUIvh8UL1eSVYV3W2NuNj8wYmhs9CJh
	 QnZtsEDrgwM04tQbu58lld90B8B9ZIECCqSc6n+NkSHyOieCh8R5Cl+v3/49XQwWyRIl7
	 v9F/vjAEFcfMdqho/k95AnfkGFS37JGbpRj4flxUUVjGMy+4/370CHbjs7VqkoA8Nlveg
	 KGnUIP7WF8hBuyxtXTZt6llAagde5y8ZOEbvSFLvMkfYwIaTXmwxLwgBY+Lmh+9ggKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WTV0w40J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C39606A326;
	Sat,  7 Nov 2026 03:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WTV0w40J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026E51F008A1;
	Sat,  7 Nov 2026 03:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794021954;
	bh=mxiid2hy6pGN9sHLzXHLOnDequd95SafDDGiZTsr7dg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WTV0w40JxOBYdPzpa4f7DZkdspPxJBrVgTAa2OuCLgZcV/4Is1JOIsvWQHgSMTG3N
	 yAx7GXtZEyPCSzTK3upClUnUturM7qpNFJ0wGrZc/lRaHpvWCEu89O8ezuyM8AOQyz
	 tQkDJJ/XXrUhR304CiG20Oa/KQYRie9eRYY1+BNJqxpfsCqEkMR46yB/iGnIyjZSo0
	 oiZxSpMuEdK5nA3WicHMzdCsjuULm9JDM2uH/D5M0B01EP2oqVB0jFWwpPGCBBcVBn
	 f0+UWuYKYGVnHACBvulPRgJuLqPquUHyDT925XPpJRdwbxPFGS9VKMqtf0yKfKUZum
	 cMIhensA1gW7Q==
Date: Fri, 6 Nov 2026 19:25:51 -0800
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
Subject: Re: [PATCH v5 2/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <20261107032551.GA1990@sol>
References: <20261105031401.956609-1-jarkko@kernel.org>
 <20261105031401.956609-3-jarkko@kernel.org>
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
In-Reply-To: <20261105031401.956609-3-jarkko@kernel.org>

On Thu, Nov 05, 2026 at 05:14:00AM +0200, Jarkko Sakkinen wrote:
> The keyrings subsystem is the sole user of assoc_array. It has over 1700
> lines of code, no test suite, and a long history of bugs, with LLMs now
> finding more.
> 
> This unfortunate outcome has evolved over time by large from the shortage
> of in-kernel callers, time bandwidth and 3rd party contributors.
> 
> What the keyrings needs is just a generic key-value store, which performs
> well with sparse key sets.
> 
> Replace struct assoc_array in struct key with struct keyring_index:
> 
> - keyring_index: holds an rhashtable for direct lookups, an RCU-protected
>   list of keyring_link entries for stable walks, the active link count, and
>   an rcu_work item for deferred teardown.
> - keyring_link: links a key into a keyring's hash table and list, caching
>   its 32-bit SipHash digest rehashed with jhash by rhashtable.
> 
> Correspondingly, struct assoc_array_edit is replaced by struct keyring_edit
> for delivering transient state across link operations.
> 
> Other behavioral changes:
> 
> - KEYCTL_READ and sibling-keyring searches follow list order instead of
>   hash order: keyrings are prepended, other keys are appended, and
>   replacing a matching key retains its position.
> - key_unlink(), keyring_clear(), keyring_revoke(), and keyring_gc() no
>   longer allocate memory.
> - keyring_index_free() uses queue_rcu_work() instead of call_rcu() because
>   rhashtable_destroy() may sleep.
> 
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

But one comment below.

> +		do {
> +			ret = rhashtable_insert_fast(&links->ht, &link->node,
> +						     keyring_link_params);
> +			if (ret == -EBUSY)
> +				fsleep(100);
> +		} while (ret == -EBUSY);
> +		if (ret < 0) {
> +			key_payload_reserve(keyring,
> +					    keyring->datalen - KEYQUOTA_LINK_BYTES);
> +			goto error;
> +		}

I don't think the retry loop is actually sufficient or desirable here
(though it would be very rare for it to be reached).  It gets reached
when there are too many elements in one rhashtable chain.  However,
we're already pre-hashing with SipHash, and the rhashtable level hash is
passed only the 32-bit SipHash.  Suppose we reach this case because the
SipHash values collided: then rhashtable's rehashing would never reduce
the chain length, and the -EBUSY would last forever.

I think the right solution is to just set '.insecure_elasticity = true'
in the rhashtable_params, to disable the chain length checks.  Those
checks make no sense when we're using SipHash anyway.

Then the retry loop would not be needed.

(And even for rhashtable users who aren't using SipHash, like
fs/verity/, hard-failing insertions if the hash chains gets too long
seems wrong.  I mean, imagine if the kernel started refusing to do file
operations if one of the hash chains in the VFS hash tables happened to
get too long...  But I guess rhashtable was designed for towards
networking users who are able to just drop the data without much issue.
Plus it predates SipHash existing.)

- Eric
