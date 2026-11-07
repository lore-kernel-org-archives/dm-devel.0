Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055457;
	b=AbnIDA58KFwxpR2O7rbp+q6JGQfh86T58qC+iCWj0D7FwX5UPYBU1YJEUhHLRHNETSnx
	 RejsgBStFOfLFq8v6eMynwCs+eQ6wM6cRC9T6S9hF0C6u6Qzc+oHgP3w3VF5Ze4mq/xtx
	 0gMotb79vJVo9BXy5GjjJsJgQ9AV5HuzuGlQIrS7SsGKeILpP5fFWg3HYH83Y03BfIU+H
	 s9w6XwxrOCa3fCI3hwXnJ/ui/WC1y5FVV+JAK6VzPYSq0kGmew6aafLgckif6+ssjg5uL
	 TeVjH9UidYcH4F67yVM1ARu8t5Zhf7BJLQ0gT6gU7VrdckSIpPw1JWEsaFC0GtSRdug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055457;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dzBwFs2TljpOP5elYmUhvLnbOuXM3QGLPguMHu8Knu4=;
	b=G0YdbdlyaxA2aKdszaI1WsBtao1QelFu9QxsAUm+ai9es+iXtjzkD1Vtd2f4lz+z8HKt
	 N75f7OU6EYiIUSoAjiSa0M7QbmrQObkVniLDKvNP4ohMH6gY8jyCAToXDtMnrvVqJrznS
	 ReUR58xvrXOnYFPmu5hAk2BmsmkepgDUaf9kaO9xOANBL7au8gkB7uL/zbQJ10Z/sAoSb
	 VLfEd3GZkivRxURstoZcNoq+KDwQBPhaKVNlJgNbDqLd+97uWNFZpm76zGoo2GflbyAG2
	 VaMEAsSpzJyQ0D9MMfdBRNq2/MM78A8Ju3Xp5+t5/bhRw9XLaQlWd65trugMxmz4uRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=egCKZgvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2E64D606A32C;
	Sat,  7 Nov 2026 12:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=egCKZgvR
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 076321F0089F;
	Sat,  7 Nov 2026 12:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055456;
	bh=dzBwFs2TljpOP5elYmUhvLnbOuXM3QGLPguMHu8Knu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=egCKZgvR+uM5AdIYnxZkn5qTtOFRr/D3N+7/N7RqicbOfSHrHL2dAv65ZHdA46cvx
	 H8Aju+BdzWVMfOnqof3bfkSW/intUk7fd7I5A+IhhLXuhZM296Pxee0SYLQ13Ljivm
	 K4B2f7/mN5ZO7OdxLMTCLSdZHpB9AiwG02mU5KZUvzE21CFWbQ5GYBn2SQCTfKJA/z
	 Ykpgc4X8/HTtlJ8M3qUB4wDiITeiFk2tMFC2NSwRpGI5uzZOb9Ws0T0UgPYBdAoJWh
	 0zfw15CJ8okfY7ZIxpgcJ4vg46Zh0SNJrTZdSWnmXTnp9TXAFLf08v4ziCE1Ykqwmi
	 R7jztThEgO3YA==
Date: Sat, 7 Nov 2026 14:44:12 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
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
Message-ID: <au8dHKGIv2tr_Xom@kernel.org>
References: <20261105031401.956609-1-jarkko@kernel.org>
 <20261105031401.956609-3-jarkko@kernel.org>
 <20261107032551.GA1990@sol>
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
In-Reply-To: <20261107032551.GA1990@sol>

On Fri, Nov 06, 2026 at 07:25:51PM -0800, Eric Biggers wrote:
> I don't think the retry loop is actually sufficient or desirable here
> (though it would be very rare for it to be reached).  It gets reached
> when there are too many elements in one rhashtable chain.  However,
> we're already pre-hashing with SipHash, and the rhashtable level hash is
> passed only the 32-bit SipHash.  Suppose we reach this case because the
> SipHash values collided: then rhashtable's rehashing would never reduce
> the chain length, and the -EBUSY would last forever.
> 
> I think the right solution is to just set '.insecure_elasticity = true'
> in the rhashtable_params, to disable the chain length checks.  Those
> checks make no sense when we're using SipHash anyway.

Thanks, this is a valid suggestion. I  was thinking about having maximum
retries but this is much better idea. I'll address this as you proposed.


> 
> Then the retry loop would not be needed.
> 
> (And even for rhashtable users who aren't using SipHash, like
> fs/verity/, hard-failing insertions if the hash chains gets too long
> seems wrong.  I mean, imagine if the kernel started refusing to do file
> operations if one of the hash chains in the VFS hash tables happened to
> get too long...  But I guess rhashtable was designed for towards
> networking users who are able to just drop the data without much issue.
> Plus it predates SipHash existing.)
> 
> - Eric

Br, Jarkko
