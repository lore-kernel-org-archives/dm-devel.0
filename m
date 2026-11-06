Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992764;
	b=0VfvHbZcFvUCA8bQlvfn74dEO24JFxkmpj9a3pSKYFeHhmPsB1e/eYJ8ZidmrUlMX2qo
	 AJwLe3nwE/K6xBemnG6axgFZvj6h85CcGyoeUqU7RS/dy/XP3qUeU/e6b3T71czMhOZYg
	 89WoC9kosLysOR9vu87KA9tthkTMBU83pbDL453E9jw9fkqWRbzTXnFLoKrlHDhUzf7Px
	 jRN0rxtCeRTe4ZaMxLrcWOj9/z3oPrGRXlv1meOJgCQMud+iVRk8aw1QtavMVRF5XejPa
	 MYrFSifjv+TM+rPGmwZxIzroq5ozz9DccGSbVGGKB0eEAxc/u0aXueGGZcXh1zIHKuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992764;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Og9UvHNtIsAEGxEgcmvLRK4uR57FuS+ql6V7HQ6MZhw=;
	b=U0hjN03VL8LBl+yNyk/x81Temh/UNyUlgcH+0HvyRcGlWYfLE2qE/xhCRcxbMYv+gRXf
	 7ZimLwsPFzPrmjvS0sv1h/VNd+NZCm6mCDyi/QDWoYG/uFTSTBKZlUvfjk/qMen9nEKBT
	 +OWhnkqZGKFuVwjvjgFSnBqOEiNSz8l+foHMDJ/t17gOAxpvyqPn7Z+1EKpuGoS35z71e
	 +BoeJ+ybJ5Gmln/gzxsD79EZRJNempoczXQtSXltiEGpl4FJaUSxUe2DdrXPs82eOmjuG
	 JTi8KJiwHd7przgG8Jv/zI7ARoRFQqiHP/HXwOI6tT15nC9u9tFZFcjsPEoXkyj19fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hM80xQYx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE08606A326;
	Fri,  6 Nov 2026 19:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hM80xQYx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1660C1F0089F;
	Fri,  6 Nov 2026 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793992763;
	bh=Og9UvHNtIsAEGxEgcmvLRK4uR57FuS+ql6V7HQ6MZhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hM80xQYxSOn/agzNF6aKv01E/JzpxiW8ltCGlvZGom0n6XHUUGz+vhL0Uk6uxfyNM
	 go+L6tk64X+Sq3urFpcKA9TMnvNKwvUSsMU3K5CXkAKgSsYG8Va1By7xgYjI54t9O6
	 0J3noDH0wBLU+efSJ+uBWWEH1Mafc36yNxNWebVUsa1kqG9RzBLV28VzIPU6f+emPO
	 o47SlPqHgex1v2XoeJJ2PmZrodW0r78u8x9AMMWOvkzOEmeJbaOJTBeuQYytfr//W5
	 OBaaVaZbUSu/zC9sHDdanQh17R5330YgoRNacteg0SMM6WnD4WQ5xzz4HiVtCdKnnL
	 8H9aBTyQGwkvA==
Date: Fri, 6 Nov 2026 19:19:20 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, David Howells <dhowells@redhat.com>,
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
Message-ID: <20261106191920.GA3383096@google.com>
References: <20261105031401.956609-1-jarkko@kernel.org>
 <20261105031401.956609-3-jarkko@kernel.org>
 <27015846-0161-4700-b810-4643e1f7b63a@suse.de>
 <20261106090516.GA1973@sol>
 <93e6b4e6-43c3-462d-b57c-26676aec85ec@suse.de>
 <au4k69xNBUjsNErr@kernel.org>
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
In-Reply-To: <au4k69xNBUjsNErr@kernel.org>

On Fri, Nov 06, 2026 at 09:05:15PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 06, 2026 at 02:02:11PM +0100, Hannes Reinecke wrote:
> > On 11/6/26 10:05 AM, Eric Biggers wrote:
> > > On Fri, Nov 06, 2026 at 09:21:32AM +0100, Hannes Reinecke wrote:
> > > > While I am pretty much in favour with this approach, is there a specific
> > > > reason why siphash has been chosen?
> > > 
> > > SipHash is the preferred choice for secure hash tables.  It is secure,
> > > performs well on short inputs, and doesn't require special instructions.
> > > See Documentation/security/siphash.rst
> > > 
> > > > Would there be a chance to make this configurable?
> > > > I do see slight complications when running in secure environments
> > > > (ie FIPS-certified environments) where most of the hash functions
> > > > might not be available ...
> > > 
> > > SipHash support is available even when the kernel is booted with fips=1,
> > > so there's no issue there.  It's already widely used in the kernel for
> > > hash tables, and that hasn't blocked FIPS certifications either.
> > > 
> > Ah, right. Thanks for the information. Just wanted to cross-check here.
> > 
> > > Side note: fips=1 actually has little do with security, and in some
> > > cases it actually decreases security.  See for example
> > > https://lore.kernel.org/linux-crypto/20261026183332.11402-1-ebiggers@kernel.org/
> > > where I'm fixing a vulnerability caused by fips=1.
> > > 
> > Oh, I am fully aware. FIPS is more a rubber-stamp than anything else.
> > Unfortunately, a pretty powerful one.
> 
> Just representing this as an option but in the current mainline indices
> are used instead of addresses, and thus it would be also an option to
> just jhash across the board, if that part is retained (now it is being
> removed).
> 
> On plus side, any security bugs in cryptography would not be a concern
> of keyrings.

SipHash is also useful for resistance against denial-of-service attacks,
where a user puts all their keys in one hash bucket.

As I mentioned, it's already used for secure hash tables elsewhere in
the kernel.  That is what it's for; see
Documentation/security/siphash.rst.  It's very fast as well, so if you
are thinking of cryptography as being something very slow and hard to
use, that is not what this is (or ever needed to be).

Let's just use it and not over-complicate things.

- Eric
