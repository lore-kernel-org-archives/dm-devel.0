Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793955920;
	b=QslAtVg8k012F9h7lILIyb4/GdIl+TCOH6UGJgHdY2Qgup1/O8Jf2/oMF2hyXAzy4t/W
	 ITTcG1gWdcnQX3AkQ5S0qWN1mpp6zn+d5iMcGpgLfSZIxshXMyACG+GCjghrOnVzUNhaP
	 ugEkjIHlDZjTgA9NB0tFKvY0V248re+87G+eHgJA21Gw1ju64P/Wr56uoZcqaqL0Skc+1
	 5tRqt/fAQoiw9HCBfivZMwqEL7PFC3xmY1NS7JnMJS5pto3Q442u0E1rWKWFGktASK2YP
	 GuRXC12+5uL08nro4EBFtN0fdIqiUiQd0jNcTuwlDaPptLmglppFPjumL+8SYPhGyhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793955920;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=sTFwFHk0E64AYEEUcX8t7DWdOvQ6PLUQ/fthkL753Io=;
	b=co3HGuB1ydbjedHMG5rirmR+goTF/au2ACxaLnTdW8qaXLngHNdgmEIanEbwwUx5nZQD
	 IC/36H7XT/Qap51CtoS4lwUzEKk9pjAt5qxwpgIHPC2lqZaL7TZToLBnOPX2FmYFiq1Vq
	 IlEAhNh8HDuIN2diHPLer3lBqvV0TQ4+ibT2ffQ/Q+6Ff595bh3l1tvqHO1S83zQOEX+i
	 TBws8thjLpnrIemWglyC9dZKwiege9q2Pbt8H6hRzMLpIycCcAZmGyErkMLbVFibYJhG1
	 LI0QDT6Ajyi1/+EdD4g0MWVVkm4QddlNrdKZ48pb0GQJ5jUEzb5clKoYduK0vxdC76g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NxG4Yq28;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A18606A326;
	Fri,  6 Nov 2026 09:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NxG4Yq28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C19F1F0089F;
	Fri,  6 Nov 2026 09:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793955920;
	bh=sTFwFHk0E64AYEEUcX8t7DWdOvQ6PLUQ/fthkL753Io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NxG4Yq28SBZ5pvwkOA2iAYG11qXpnj0/U/4mz8TRCJco0CmfcWsGatdxSJUI7EvJS
	 APt/LCv5vmGrIstmtMDjefq9lAL6ZUkRdKAesed25zP6/6QYUzdu5k/UIsj8cOqjKW
	 wxJgUyASJmfcUYRwu5Yxh+FSnuQu58iHYvNrMYjFgkGWoEygoLgJZz4v5OwDareFN7
	 P1KpTDQ5mDTNlKcKNH37py/9Td+Amts88a/QdlKwM1JOBVjQm39I3NT1MlE26jZJHR
	 WNphDN7M+CtPeL4Zq1+PqjL231Yj7MhdwF3uERuy/5ORsvDjS8hh73L5dk+n2nQwZV
	 4H79poaACgWhg==
Date: Fri, 6 Nov 2026 01:05:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	David Howells <dhowells@redhat.com>, bpf@vger.kernel.org,
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
Message-ID: <20261106090516.GA1973@sol>
References: <20261105031401.956609-1-jarkko@kernel.org>
 <20261105031401.956609-3-jarkko@kernel.org>
 <27015846-0161-4700-b810-4643e1f7b63a@suse.de>
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
In-Reply-To: <27015846-0161-4700-b810-4643e1f7b63a@suse.de>

On Fri, Nov 06, 2026 at 09:21:32AM +0100, Hannes Reinecke wrote:
> While I am pretty much in favour with this approach, is there a specific
> reason why siphash has been chosen?

SipHash is the preferred choice for secure hash tables.  It is secure,
performs well on short inputs, and doesn't require special instructions.
See Documentation/security/siphash.rst

> Would there be a chance to make this configurable?
> I do see slight complications when running in secure environments
> (ie FIPS-certified environments) where most of the hash functions
> might not be available ...

SipHash support is available even when the kernel is booted with fips=1,
so there's no issue there.  It's already widely used in the kernel for
hash tables, and that hasn't blocked FIPS certifications either.

Side note: fips=1 actually has little do with security, and in some
cases it actually decreases security.  See for example
https://lore.kernel.org/linux-crypto/20261026183332.11402-1-ebiggers@kernel.org/
where I'm fixing a vulnerability caused by fips=1.

- Eric
