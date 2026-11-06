Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991920;
	b=1havXuO5t2SichSSDA+OB9tZISIVumYfiw16UY/pXhmIpr5Dk5WOHmzIbUb9+475qzW4
	 YCXyZrGcdU59yjrSXxGa9c1tiqlmZgP+uOs2K4VA47KddXiXOPKeoSZ6a0zzLlOmtL41r
	 rRSbfgjtjWZy6WGGfvYLY0OUFAAG9iX3yyU2tO6cnoDSET0QypDCFSOtokFpP4t4p/uJC
	 1STanJHy0aYh2lutQTiXc43xYY55IRwLGiRr/IoLpB8wOV4vP/6d21+4DpeZNUoHzU7E9
	 UZzqmkcWnwIBp3N1VGvh0Xgn7l51pmj9YqvCK5y20xV5fV78EJIFXDQsFstabnq8UsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991920;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=KP0QCfy6n/aAd3jVf+wjI/kSKv7FWxjBTOq+hpFStLw=;
	b=qpwa8QdaSNNFaCLZXvPg2vuIJO55jjPkcULKkpEdSV3WKzaeAZAXljBRG3v7ugN2fsT9
	 pZggI2mOu3ikuJg1cDSCNdgo8yr/3wa3OoK28GBm2QQBG1Uw2bs9tSIL8fL5BA6zxJeJv
	 YyBQEpwDzG6xPUDOgh3WITSLBHuwoQ0ZT85nJYl6+kNg+NeBaO1TXUN86Jx9G8A6BKwv7
	 j9vR4+0RjVAOvgIyUAx+DQcSb8Tv0SUz+gGmQ7d5IAISdLX7yQ+spmpgztSwGiJ3Ihrul
	 KmUKQ4XzPUFIuEAcBpe8eZIFtG75mEFGo3aiGFETfUtuKAyDxwOlKbdK6Dldll5d8EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8tque+l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3884C606A326;
	Fri,  6 Nov 2026 19:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8tque+l
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0696D1F0089F;
	Fri,  6 Nov 2026 19:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793991919;
	bh=KP0QCfy6n/aAd3jVf+wjI/kSKv7FWxjBTOq+hpFStLw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C8tque+l5v7c9mujhczRgUd0lgAJiVKY+/ot2dvviS/j8YectO8mzr4CFc5YIXjtS
	 qKMo8O4S4JyVQ9oy/mZpN12sZf7VWTrzqKTbDfqH5r52F6baposRiIgJTyz5jAOsQt
	 /UPK+Lx4c5vMgntucIxzDzxxRIXuuesbqFLVNLFq7M4mI+CdeXcKAENC1JJ47hxQgr
	 90sL9x/uEVwWfref3Eluzt6azkVCprndR7sJlx2+CTnomVRKEOvZnthETmngVUMsIR
	 l8gmcaNA1nJ6j2HsY/EIrAIr3j45eLWMHokTJRwIJvCUn9bhTc/h/+g875ZObx87an
	 PCwYAB4NsD+Tw==
Date: Fri, 6 Nov 2026 21:05:15 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Eric Biggers <ebiggers@kernel.org>, David Howells <dhowells@redhat.com>,
	bpf@vger.kernel.org, dm-devel@lists.linux.dev,
	fsverity@lists.linux.dev, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
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
Message-ID: <au4k69xNBUjsNErr@kernel.org>
References: <20261105031401.956609-1-jarkko@kernel.org>
 <20261105031401.956609-3-jarkko@kernel.org>
 <27015846-0161-4700-b810-4643e1f7b63a@suse.de>
 <20261106090516.GA1973@sol>
 <93e6b4e6-43c3-462d-b57c-26676aec85ec@suse.de>
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
In-Reply-To: <93e6b4e6-43c3-462d-b57c-26676aec85ec@suse.de>

On Fri, Nov 06, 2026 at 02:02:11PM +0100, Hannes Reinecke wrote:
> On 11/6/26 10:05 AM, Eric Biggers wrote:
> > On Fri, Nov 06, 2026 at 09:21:32AM +0100, Hannes Reinecke wrote:
> > > While I am pretty much in favour with this approach, is there a specific
> > > reason why siphash has been chosen?
> > 
> > SipHash is the preferred choice for secure hash tables.  It is secure,
> > performs well on short inputs, and doesn't require special instructions.
> > See Documentation/security/siphash.rst
> > 
> > > Would there be a chance to make this configurable?
> > > I do see slight complications when running in secure environments
> > > (ie FIPS-certified environments) where most of the hash functions
> > > might not be available ...
> > 
> > SipHash support is available even when the kernel is booted with fips=1,
> > so there's no issue there.  It's already widely used in the kernel for
> > hash tables, and that hasn't blocked FIPS certifications either.
> > 
> Ah, right. Thanks for the information. Just wanted to cross-check here.
> 
> > Side note: fips=1 actually has little do with security, and in some
> > cases it actually decreases security.  See for example
> > https://lore.kernel.org/linux-crypto/20261026183332.11402-1-ebiggers@kernel.org/
> > where I'm fixing a vulnerability caused by fips=1.
> > 
> Oh, I am fully aware. FIPS is more a rubber-stamp than anything else.
> Unfortunately, a pretty powerful one.

Just representing this as an option but in the current mainline indices
are used instead of addresses, and thus it would be also an option to
just jhash across the board, if that part is retained (now it is being
removed).

On plus side, any security bugs in cryptography would not be a concern
of keyrings.

Br, Jarkko
