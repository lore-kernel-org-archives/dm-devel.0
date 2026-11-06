Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793977725;
	b=tXrU4MUjO+lVCzUkI7VSc47ZEQnbRb8/PmzVQv81hKIcTevbuJxBVeMkIa6pG+Oikb+F
	 YELZB/Fv1WI2KwdZs3IP/cByArUqM2Rg61mUAvqT7R5bbzr0LatBKpc3cHdsXQ1GsMrHT
	 jagaaOEPXSJ6MVnKGf01wT6H45Cxl1H5fznqcKbCOE8lyYk+qtYnaLSNR9PLBYe5Vhpku
	 HfpC2U3r/r7OhQThh118blrTnDvqT/kxhsGiC61hlTfgTIM9rbrtEMaa6WfTcjMj/v12r
	 J2MkQOgTsbWA0ZRoimqUd0FRqhnsOhGZd/2ZVKjPsrwhxqP5OLB3vqGyxsKcDLK7FYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793977725;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=v7luENhdcXtYyU0R/Y6sABRqCwShaCT3Ig7woROEwb4=;
	b=Qk7dD3ex24Sro034JNMrNktroD4zvDt6Yvw/GF/AGuLmxRWqSabPAo5ibMxUEs/OyNFq
	 MAc89GST2M5n/0RVOA65YjwK4/vI8uodmupCYeccmdAHrWX7bGdb1hX4+Z1S+JdNDAqt9
	 Kng7Mfgvv95LsgCsipwP2Iu3qs8PR65wvVfJpnuUax+GhGRnQU0XOQaCOOZWG7zODOPeY
	 q36psc7rrt8WI9lnWJ8cS41ralaxUDkQtKmZkGYS2mpW9AzHYgrZyVieYwwMSOX0zDjQm
	 c9qKxwP8S7p4TrUNTmxROicoDb90LWpEldz/rrvGGxim75jcp3YaSU1wrPDzR4Lt0mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fXvCipBJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 36CB9606A326;
	Fri,  6 Nov 2026 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fXvCipBJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 109811F0089F;
	Fri,  6 Nov 2026 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793977724;
	bh=v7luENhdcXtYyU0R/Y6sABRqCwShaCT3Ig7woROEwb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fXvCipBJm/D+UzqzI+MRQ3AzYnnEfS3G7Jm3VFG6y9hXucyt1KRKi5KM85qYZuv6a
	 LIxIt1Y19buaYSXf+ts2NicK+/DJ+jGQnrgLJjUO3PSmW2m5NSJhvFxmTcoc8S/PUO
	 22FE8ziTtDiLbjwcWIa/X3Cg0tdYClmThVazhigDEmCWO/NpnPEGPcw7NPfVBzqb+5
	 YzcbbGj19nYvlG61eoIbFCpzjrDYo0MbbJ9E7jk9rw7A+ZFqQvx34/8bQ241pCGfFf
	 nzzO1rOy+1V9dHDJLTKLPdnzAMEmdYwGXiHuDvMmkItozOcSzss64p746xDw5ywOSy
	 Wr8zW71lRhMKg==
Date: Fri, 6 Nov 2026 17:08:40 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Hannes Reinecke <hare@suse.de>
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
	Eric Biggers <ebiggers@kernel.org>,
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
Message-ID: <au3teLK-KHmBW6Wo@kernel.org>
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
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27015846-0161-4700-b810-4643e1f7b63a@suse.de>

On Fri, Nov 06, 2026 at 09:21:32AM +0100, Hannes Reinecke wrote:
> reason why siphash has been chosen?
> Would there be a chance to make this configurable?
> I do see slight complications when running in secure environments
> (ie FIPS-certified environments) where most of the hash functions
> might not be available ...

SipHash came originall along with [1].

If we retracted back a step back i.e., use the assigned indices then the
security properties of SipHash would not be relevant.

> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

[1] https://lore.kernel.org/keyrings/20261013231251.56170-1-kylebot@openai.com/

Br, Jarkko
