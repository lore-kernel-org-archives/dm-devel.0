Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793993446;
	b=AlN2pXMXuowmMs/5BmneMqywZRMzhMLICZFkgh8QOWOI9rIa2avNZwUyvhaDgQBJNE3m
	 ULSdfSM57lDALIY5WLIGP/T/MVX5Lm8fx3mHkWqZDCoiGHtpLkCmDJ8lG0gwaUUY0Cwdg
	 U5XF7mQbuKQEmU0RouQUXEbk+xPv3w2gojEXnM1e2MM3gmxUiqETKX+PCm1zQtIvlg3s0
	 ddFgBiJLJ6CO4TW2779Ibd+U8523eII/XC2DBwD3gpJV3w6wjl6Uty5lBP55dIiyQLbUf
	 XoQJm2J890Baw1uRH7dYYFuwgObRsA9FOTF9uLw3oOpsslLRqXJ3+K2dUwHaNJkOTlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793993446;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XmljEirP7g8E1aEpXYghzNW+MUBxa4234sIME/mYPkk=;
	b=KoEjuKAKnZzTMmGq4rVPec8Jp3QL0S/h2OMYwKc3EvLbXL93Klbxaw1MStGksYEILmoi
	 /j2rpmNywz7N03df3MmsLEBcuHyiwkVFbcStUs6ijZxUqG2mJs0TGuBPkuL7Rigz5jU13
	 tqDL2uYO9FnaqcVwzSQGsIFh8Osk4sU0YiNiIxrXq/mJ9ZAZymh/VIo6MaxCxZ0FSKpH2
	 xmvL/QDRb5SJgRe/yezV7yYDJiFgKOstCAGriG4d7GPpcxmTY+8/Iccfcd34khFoy8Q3j
	 d2e7fVhs4Vnd7AQb4XlLLvOWZlEj4M717VHpqJs8SNESD5nw4Qlbd/6vyN+cZ/m1tZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fRgb09PY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9BBEC606A326;
	Fri,  6 Nov 2026 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fRgb09PY
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 89B181F0089F;
	Fri,  6 Nov 2026 19:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793993445;
	bh=XmljEirP7g8E1aEpXYghzNW+MUBxa4234sIME/mYPkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fRgb09PYkaD6Phe8rymtD/OPdc3FEe5j7zptW9rqLEPiPGLt0uWIFNbksQ4JPPiQZ
	 5WfFSlfOba/9Z/vwhRBxda9lXAmsvDNfxor5Em6lhAabuhK76HA5hjm51SebDcki+8
	 a1p9eTkai4Ru7VKPtmdHMqDGBxt1SWHPZi7tB5xxS9JLePshmf9r47FNN1Akj639C4
	 7uFyGvtNEP0qWBaT0RLU6kOfd8a79he64DQLSkYrv7ht0PnqOVA8H/004KNo1Fijlc
	 J1VxpLGH1T7xTP4zpflSiCn/6oeBV5o6mb0faebPG9zFzPZwsNFEmpMKwVea6ITRse
	 Vu6lbY0ezf8BQ==
Date: Fri, 6 Nov 2026 21:30:41 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
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
Message-ID: <au4q4Wh7PK1-Ge9P@kernel.org>
References: <20261105031401.956609-1-jarkko@kernel.org>
 <20261105031401.956609-3-jarkko@kernel.org>
 <27015846-0161-4700-b810-4643e1f7b63a@suse.de>
 <20261106090516.GA1973@sol>
 <93e6b4e6-43c3-462d-b57c-26676aec85ec@suse.de>
 <au4k69xNBUjsNErr@kernel.org>
 <20261106191920.GA3383096@google.com>
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
In-Reply-To: <20261106191920.GA3383096@google.com>

On Fri, Nov 06, 2026 at 07:19:20PM +0000, Eric Biggers wrote:
> On Fri, Nov 06, 2026 at 09:05:15PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Nov 06, 2026 at 02:02:11PM +0100, Hannes Reinecke wrote:
> > > On 11/6/26 10:05 AM, Eric Biggers wrote:
> > > > On Fri, Nov 06, 2026 at 09:21:32AM +0100, Hannes Reinecke wrote:
> > > > > While I am pretty much in favour with this approach, is there a specific
> > > > > reason why siphash has been chosen?
> > > > 
> > > > SipHash is the preferred choice for secure hash tables.  It is secure,
> > > > performs well on short inputs, and doesn't require special instructions.
> > > > See Documentation/security/siphash.rst
> > > > 
> > > > > Would there be a chance to make this configurable?
> > > > > I do see slight complications when running in secure environments
> > > > > (ie FIPS-certified environments) where most of the hash functions
> > > > > might not be available ...
> > > > 
> > > > SipHash support is available even when the kernel is booted with fips=1,
> > > > so there's no issue there.  It's already widely used in the kernel for
> > > > hash tables, and that hasn't blocked FIPS certifications either.
> > > > 
> > > Ah, right. Thanks for the information. Just wanted to cross-check here.
> > > 
> > > > Side note: fips=1 actually has little do with security, and in some
> > > > cases it actually decreases security.  See for example
> > > > https://lore.kernel.org/linux-crypto/20261026183332.11402-1-ebiggers@kernel.org/
> > > > where I'm fixing a vulnerability caused by fips=1.
> > > > 
> > > Oh, I am fully aware. FIPS is more a rubber-stamp than anything else.
> > > Unfortunately, a pretty powerful one.
> > 
> > Just representing this as an option but in the current mainline indices
> > are used instead of addresses, and thus it would be also an option to
> > just jhash across the board, if that part is retained (now it is being
> > removed).
> > 
> > On plus side, any security bugs in cryptography would not be a concern
> > of keyrings.
> 
> SipHash is also useful for resistance against denial-of-service attacks,
> where a user puts all their keys in one hash bucket.
> 
> As I mentioned, it's already used for secure hash tables elsewhere in
> the kernel.  That is what it's for; see
> Documentation/security/siphash.rst.  It's very fast as well, so if you
> are thinking of cryptography as being something very slow and hard to
> use, that is not what this is (or ever needed to be).
> 
> Let's just use it and not over-complicate things.

I'm pretty much non-opionated when it comes to this detail. I just
merely represent all the possible if anything comes up to mind. DoS
protection that you explained was not something I did even consider so
that seals it for me.

> 
> - Eric

Br, Jarkko
