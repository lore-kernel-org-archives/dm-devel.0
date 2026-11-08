Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794142460;
	b=HANtxk7wE3ye6+ZZS6C7L1Hq3UwVQYaQGE70L/lCXirvr4ogoMCV5JOFZK2qcFDUIm1B
	 CrZSpLgCKv/stYQiCuvW7H1l/hUdZEt5m39ga71x5uUhu8okl9b3x/NYt9RttwFl3/acV
	 kdALmsUVOsknOSOM0C83ZcTM+6LZAklNiFksz4RVKYyzMRrm2S5/mydOJaYUox+2mYknO
	 k4vjBTVxGwOCKkZ9igioBCf9FdqQIIJ9uo+tuFOxC/1w5Zj8uKogALmgtspktfzJTLKJo
	 3m1kuN6yjzp0Lncz22b6mCNeByanTzoST1WpnQ37aEKwCWTsPM+UGCmIpA92EEJgHhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794142460;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=S+YnvTW9wjLG9Bb1xdTq3cc7U/wCPzi1Ggn3aEWL+QI=;
	b=FWJqWWjWaUwe7GA9lwrOYed5+pz7xUe425OBJvRCkwHk9LKOdumAbEZXWROeq9AyPfzo
	 ZbuW1ezGQ9pfY7iGsKnVok5GXaEPekZQ3IYAmXce/bSlGbU3o5SXApCf2RntyzKUX7GoT
	 CVu6aXrIcWFjZ8JuuvOuKjX0i+qEP+kJ6Wm9voX3yJYyyE0XeMSyniLXmood4gCRKg4k8
	 T7DrzNsy5MJetFVYHvasVQJ0XtBrIiIzc9Stz/lht1+4QWNWalFPmm4fCTDTIBVc3nTr8
	 N7Kz+0/M3zpC4188pA8Kn86aO8Yz3yB1QKooLpkwNN32DUzim5OOsoNA6UkhadbXpkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HST+DHzN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C8BF0606A31C;
	Sun,  8 Nov 2026 12:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HST+DHzN
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8DF571F0089F;
	Sun,  8 Nov 2026 12:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794142459;
	bh=S+YnvTW9wjLG9Bb1xdTq3cc7U/wCPzi1Ggn3aEWL+QI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HST+DHzNkQ1gw3AIpd5D0TgEIQolNUgaQB9q3S8j8KXW+uTqPNqvM8T0TTL4jFzW+
	 8fneCgSKng5GEK2sP82/xhwzqlqgXhd3RBI6qsRDgn8dp5gNK1oIL8Ao3I5gcCyL+7
	 wz4384LrRO97ZlPNnpbvfJ5bwVxJafoDd9PNg8q98LKXIJGZRNtG/CErKEdVDta5c9
	 te2zVyCjNm05bgFQBEQks//164933xqL3KJltQjDTlEm9OFRN2Fl9el+ZZF8beOPTF
	 +n4QDzjA9vwmInwZ9d04Lg1Uq07df41UopVKlvjsyABmJ1mge57z7oG8RJ8S7YsLui
	 86ewMO/v9JKYA==
Date: Sun, 8 Nov 2026 14:54:15 +0200
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
Message-ID: <avBw92ZChNT6E8cZ@kernel.org>
References: <20261107195605.3929659-1-jarkko@kernel.org>
 <au-FkAtC4Gcw7Bkb@kernel.org>
 <20261107204210.GG6049@quark>
 <avBVgZt92j3OkpOG@kernel.org>
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
In-Reply-To: <avBVgZt92j3OkpOG@kernel.org>

On Sun, Nov 08, 2026 at 12:57:09PM +0200, Jarkko Sakkinen wrote:
> I think know what is the problem here exactly. It's the prepending bug
> fixes. Sorry, I only now realized this althouhgh it should be quite
                                                             ~~
                                                             have been
> obvious.
> 
> I updated mainline few days for the sake of v7.4-rcX PRs late this
           ~             ~~~~ 
	   the           days ago
			 
> week (I think it was Thu or Fri) but linux-next was not up to date
> last time I checked.
> 
> One I'm able to send the PR containing the fixes, I'll do that and
  ~~~
  Once
> once that is in the mainline. I'll send a new version of this patch
                              ~
			      ,
> set.

A few keys of my laptop's keyboard were stuck when I wrote this. Thus, I
had difficulties to write a proper email :-) Now that I'm reading what I
wrote, the typos started jump into my eyes, so thus the corrections.

Br, Jarkko
