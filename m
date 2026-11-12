Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794493173;
	b=u8hilQYCIPnIgVM+HF0USvW1R4Sz6qgdZAS3dMN1FqAm43Tomkufpz7rKnvLZpuzPSYk
	 W5RbSDFoJ5w3ORtRGUVBJyReG46qCAfYc30HCbzdldvnYxLD2cfUGEErA/t8o5D8J9a9I
	 PnHPrF89HZJWB5C3/GQchD8+muDdGmNN4l46+9ndow0/sdxt6hRl7AM1Wxk77TxxmgLzh
	 Sf4YbcX45CHHvvmMxzL0fdkFWEyJISQOxENG48BndbJxxEITDJI/q75RDIBte3DlXTyFX
	 AWWWMEMCCmbkWdePmIghrjJ4+mhVSBR//exRlt+2KMcnpixApkLLUbBBQDmuG0eWAuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794493173;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PtL6fQIP5x0WU3dTc2bEBHEkK0f64LH1mQ5PFkYFhLE=;
	b=kmRT+bTpOmqqTFGPSbLW7KoCtYbf7RXKPFwjDdpzlxUM04BqUoM+JO16Xgb1gdsGI+To
	 KuaB4/avsQF0iAORXukcXgtymH4emMKcbDoAC/TgkjDOH9+/mMXLk6P16DzIG7ohtctC5
	 Thuusv0R5FV07S0eq1UvVoZyH7iu0tfaJEMJhQxNLgxOA4rFDgrWgX++O/uZLl4qyu7Wp
	 GYp3/UBEm8VHhKkWQMe+3SgmoVY9+Hmt0VHTaHxEg/YCrMGzw+d775KkUH7rMSCvBRzE4
	 UoyOLxmIHaoQsJpxXDUsUI3yw0lYiW4zekEpiUzBjyJwGBdJiJSw3gllA3Dw5gIRFKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f8Roc0cn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7BA71606A8B8;
	Thu, 12 Nov 2026 14:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f8Roc0cn
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8A5A81F00A05;
	Thu, 12 Nov 2026 14:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794493173;
	bh=PtL6fQIP5x0WU3dTc2bEBHEkK0f64LH1mQ5PFkYFhLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f8Roc0cn+u0O6ciGdXv0N/5hcJSLC8kHdFhAQejJqfdgDhIHN7lbJIFyWjliyn9wv
	 AHbYxO6tYFds4zpiwiNjwDENXGeowTYs1VpY2vh9W0r1YiuRyl2LWdNnx3JO/5GS+R
	 m9kHpUSrAVM4oc8cB59tP2gyh5shglS+H/fY5e/h8k74l3RK7OdzKafIA+M/4z5OaU
	 jo8Lx61IXK9lgsoKiKfzQnpssl+cW/pfFg8khmPNbM7Y6w/DoFd+8U5BjWvCXleo9Z
	 LL+umGjeOKnYEvxWh1rCvVVBaJR+QBYwrwMNc8KtpQHX+cuHVFFLcWjQysR7+uIe/o
	 3R3xCo03mT+NQ==
Date: Thu, 12 Nov 2026 16:19:29 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: bpf@vger.kernel.org, dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
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
	Yonghong Song <yonghong.song@linux.dev>
Subject: Re: [PATCH v9 0/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <avXK8UKNmsr8NwSM@kernel.org>
References: <20261110053323.2936729-1-jarkko@kernel.org>
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
In-Reply-To: <20261110053323.2936729-1-jarkko@kernel.org>

On Tue, Nov 10, 2026 at 07:33:20AM +0200, Jarkko Sakkinen wrote:
> The keyrings subsystem is the sole user of assoc_array. It has over 1700
> lines of code, no test suite, and a long history of bugs, with LLMs now
> finding more.
> 
> This unfortunate outcome has evolved over time by large from the shortage
> of in-kernel callers, time bandwidth and 3rd party contributors.  What the
> keyrings subsystem needs is just a generic key-value store, which performs
> well with sparse key sets. Replace assoc_array with an rhashtable-backed
> keyring index and remove assoc_array from the kernel.

Hmm...

- 1/3: 2x R-by
- 2/3: 1x R-by
- 3/3: 1x R-by

Does anyone want to bring something up, and should I just apply these?

I'm lost of ideas what to do with this further.

The only thing that comes up to my mind is whether it would be smart to
stick to ids instead of moving back to addresses. This is not actually
important (and can be always revisited).

Br, Jarkko
