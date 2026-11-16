Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794857849;
	b=qC2n0l0/D9NEbLFuPaa7rEBMjBrRJE5f81UA9L4rmQ5DxHVpzw+R8Rt2g/pL57TZGnuq
	 HMDkPbifPaeQCoEIMTNQnNLNZm05SuxuOGPNYfRaJzKM6FzYbCSsVu2+DoPLkQU2Kg94a
	 Lpzb9MOyP7JBJuMa+WWr0M9T9EWOuDCo87H37rPvwx8sDAfX2p+OaRSDti7kV2RH0Wnz4
	 hz7iHTMOo/dZ6UU3repRI9pFiBEb16pQx0ov0KCAffMlyrRPRXzJi3VBnx5uYbQxHsJCk
	 mrtcYgHgOUgzEK9ghpDWVISwl+FBQV0KKppcxXKHi7g0F78MxhEVImU7tP7aO6ftVMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794857849;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VgCzYve1kCS7waE1BrpxdQm3V/eHAwNUjgHqRgoaPno=;
	b=vwUKjBe6g3WKNZn6U4j9Xs+dIgfuF8IScy8RLjl/CC+pzjbXzErbHdkr/ch84XfHBYSC
	 ud7X1hJYI0eBoK64BodJhFy0e1dLCnuB4JeEMzdlYEUWZjCwlnMwkXtGYV9Dfbj2MsgZy
	 Cu8XY5j+ukKiiEXWj2aCegeZxhWJSe5M7OIZCYkY7E1sn+LQKl/3LnJkKLRpfaytMGWL5
	 +EY/crBEbulg/cwoijowuU4Mtsme0fxFbPHByXEBJ0Nr7S+tpJKJNNl2jBR36MFaJHyGY
	 /AhcmQskc56kY2k0JabCfFt5lRNYE63T51z2wM1gdWXthj1/qWG+0dUuQSADfn3js8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7wz07DI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 71FAA606A31C;
	Mon, 16 Nov 2026 19:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b7wz07DI
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4FC681F000C4;
	Mon, 16 Nov 2026 19:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794857849;
	bh=VgCzYve1kCS7waE1BrpxdQm3V/eHAwNUjgHqRgoaPno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b7wz07DIP3vgML0qQDMBFxUuiC4snWIOw82w+o5jNvTrQ2OKmd+Wxll3WmKLyu8gm
	 P+J6xBmRadl6GGcHpghMpaeNyR1XJOugm9rPcnyWkrqsZxmBplcyECQhZ9P+EtobWX
	 Rk6HMNPUu2uwL9ax63LNFbdL5fP++OFem7Y9Z39EzPlypQLyK2/wsnM4BexEGJctel
	 cQk0Hi9zMIcmY7dkRij4b9xUaMe6t1zcdf4NRBR96IU1L4wxFOWrkRiCkvyOoA+zBQ
	 +jYU44Afao8OqsXN+tZA1xGezP2kgG0E3UPPeKcI44WxZzcj33bHL22tztp1Zl/CsA
	 3Koaue1vujUGw==
Date: Mon, 16 Nov 2026 21:37:25 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>, bpf@vger.kernel.org,
	dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
	keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>,
	Anastasia Eskova <anastasia.eskova@ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ignat Korchagin <ignat@linux.win>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>, Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>, Song Liu <song@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: Re: [PATCH v13 0/7] KEYS: Replace assoc_array with rhashtable
Message-ID: <avtbdRYtBl3fsXBF@kernel.org>
References: <20261114193631.731615-1-jarkko@kernel.org>
 <20261116120722.99807Ac6-hca@linux.ibm.com>
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
In-Reply-To: <20261116120722.99807Ac6-hca@linux.ibm.com>

On Mon, Nov 16, 2026 at 01:07:22PM +0100, Heiko Carstens wrote:
> Hi Jarkko,
> 
> On Sat, Nov 14, 2026 at 09:36:24PM +0200, Jarkko Sakkinen wrote:
> > The keyrings subsystem is the sole user of assoc_array. It has over 1700
> > lines of code, no test suite, and a long history of bugs, with LLMs now
> > finding more.
> > 
> > This unfortunate outcome has evolved over time by large from the shortage
> > of in-kernel callers, time bandwidth and 3rd party contributors.  What the
> > keyrings subsystem needs is just a generic key-value store, which performs
> > well with sparse key sets. Replace assoc_array with an rhashtable-backed
> > keyring index and remove assoc_array from the kernel.
> 
> ...
> 
> > v13:
> > - s390/cert_store: Hold key reference across key_unlink(), and ignore -ENOENT.
> > - s390/cert_store: Add "s390/cert_store: Read-lock keyring semaphore in
> >   invalidate_keyring_keys()".
> 
> Actually I had / have a patch series of 15 small patches ready to address
> various bugs in certstore, including yours. I'll send them later - a few
> (or many) collide with your patches. Not sure how we coordinate this.

That is perfect. I don't honestly care about patch authorship in this case
too much. Do whatever you want :-) I'm just happy to get them out of the
way.


Br, Jarkko
