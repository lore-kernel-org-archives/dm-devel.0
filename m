Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794587205;
	b=yHGxPlPTsEx9FHqrXkAf/QsM5+ap5Vv2wnDQ19xH1vKBYOFjOzmeSpRoF/3sdV1FS2WC
	 KAuM9E7ZG/VueSdUFPU+NgcTXEM9X1E2aG8biHF7beqREDW3DViD+Oz3Egp927q92MEzZ
	 uq5U5fQzh2+H+tvOVRuP1M6zi48E+6srY/hBZOfZRdkdD+caMQ8V26AiZFWH+VtnpH1yn
	 8nCildS0GcYd835+JV9J/WfC97ixi65biwHwHftk4EOUcEbxDjda7Tnu4cE/nWbEBmBQb
	 cXVmrlt30hoyn4eXallKQkb/RtsMDwozHr51wmcZeTnYLJN6CQiLUDoxKiaTWgcql/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794587205;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7ZfF8luHREto/ub5t5xIcKnzvyfNad3KP1cbQ4+yoxs=;
	b=TQ42+SvPVDgfofY3wrfBE1O/uKtJZDZ7Rbms3QnWvBxCa1FEf4AncrtzvxieXr9C1xTM
	 vPLBLIYuZTKcTnMQLRh5ddkcIRMQdJ8vOzOzu4okF47Tz7ZttQ2U088xj1tic6F3zktBZ
	 p/jDejhnVhTJ3PeF9GVr01VfWGKUOCdZcyGMefDgakqaDl1ehIryKXQlDfXMdStXbAWbT
	 O+D3BUpjAA7eryt2nrg1jZMFKiOoLKer5J9xKAdl1j+VwBBn/DUQcSOMHYjvsvGISllgj
	 KiyBJZNX1DTU9TMrZSmTY7i6T5Q90eTVohs0PRsy4vQ8oT7wDlFvXnx81IDnv0eqmyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PGdbvyD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6D136606B2EA;
	Fri, 13 Nov 2026 16:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PGdbvyD+
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5B4821F000C4;
	Fri, 13 Nov 2026 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794587205;
	bh=7ZfF8luHREto/ub5t5xIcKnzvyfNad3KP1cbQ4+yoxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PGdbvyD+2glvNYn4aWF67C5abmwt8X5SusDm06ubZ5KfmfHlvA6WSsotDlfEZ5Jo5
	 nCkLaoKt0XLmtR1Hi6JkJ61CaAwYpyRTC740e6+kpGsdAxlAuQvQNwET/tXQKB+X3K
	 /XdbhzeuRy2IFU1d0BiJxGO8t7i/48Vqq1Nsj238jba6JtysSGtxnC0shZNGF8ZtQP
	 JnsH+OOidLxZFlQ/yFf5c97LWhpISeIeBjbWvvDsigvl9jdT1Taj/lRgvRobfeVEHK
	 8cfOs6ioXBp1G03RIOuVBD8tQzIiQrwnD8WH+Qj5wr5SMUVr+KhZcoCLQSJoIWTxvm
	 2JjKLTgq7vBMA==
Date: Fri, 13 Nov 2026 18:26:41 +0200
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
	Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH v10 0/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <avc6QSzdVwtpUxUf@kernel.org>
References: <20261113161836.3587552-1-jarkko@kernel.org>
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
In-Reply-To: <20261113161836.3587552-1-jarkko@kernel.org>

On Fri, Nov 13, 2026 at 06:18:33PM +0200, Jarkko Sakkinen wrote:
> v10:
> - No changes since the previous round. This is a sanity check round
>   given the lack of feedback to v9. I'll apply these patch very soon,
>   unless nothing (relevant) comes up fast.

We're at mid-cycle. Thus, it makes sense to get these changes ASAP to
-next so that they get more exposure.

I have one PR waiting for keyrings in queue with a couple of bug fixes.
As soon as -next is in-sync, I'll send tate PR, apply rhashstable patches
and make the commits available at -next.

Br, Jarkko
