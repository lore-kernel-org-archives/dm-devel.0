Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793994085;
	b=efUWnmdNn1LJDQj7qUzrQVXcfp+a3IDnnRDpAX8u1tTAnbPIRDvSaU9B+nMGEo1bVoiZ
	 a6+QDHs8ShOHFOaA14yTmcmAr7PEHxobUPV2YLIIpIXUBMayETCoF2VpAy17SWeORsOpk
	 CbWrUdT+b0Y9ix2hXQriW6Y3O5VlY0YQ2BgX2wjAdtONRRu7HWwWp5MeF3krO1UDMOUPP
	 yQ0J92fkiEsHFAh2OEdhwdlI7AeyUkCNcMjbgrQdbwKa2K2TWymdJmwDLjzZCQMdcEuR2
	 31yeNCADJCrRdSKXBUOIDbk6wswHBGpsUCmzUc+Ob40ptqem1JCGrMprZj3ESm4LyPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793994085;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YlgLvuvi6MzXcCGFPDS7jIHqHR1YP7BKidunKoP0lJU=;
	b=b7enz1Sp529C7t43vZKHGOQv73mJionMknI3t3Xl1znyu6MMhAB+RCrRZb3ZI5W88osu
	 VAPA80ACy+excfWT26Uv09M3cwo1muCZ3SJ2rd8ePhmYea37foke8rKhlfUfJYufqUeL8
	 RQonHssEmI4QEVOwld/3br+D7Ks7HHwPCOFRP3UDYBJM03JtP91VML9AKDGAjRAgPX4Tw
	 NCssGVpeXdzsCDOM70dASedOi2d2p9Aepwny7Y59HnUEFUgYiAK6LAklgdXH8xNa25Rwf
	 /9AQRvQpEPSSMxp1ZAx/ADQjCPWK5+8IMpLk0aeEN9tPuLjPHXsIp3cY69ExLdr6XPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gbFnx05l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6948B606A326;
	Fri,  6 Nov 2026 19:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gbFnx05l
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F7141F0089F;
	Fri,  6 Nov 2026 19:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793994085;
	bh=YlgLvuvi6MzXcCGFPDS7jIHqHR1YP7BKidunKoP0lJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gbFnx05ldh2Nzu3gMRUeaATbqhszyMS3oVk2c2PpERZp+mAWal0/IuPNDDekgB1RA
	 dvvgHjv35kv3yrgd8wePjns+ri3xOyvUmRArByEeMRk/z4p44avenpMSH169hTAWNn
	 DOrtMGDmo3/TmkuDuVJGZQ6y748uRufKosPvzTB65Omc7Un3dfZX5UsC1MvZZhHsQs
	 j6yAwxEZiwq0Okn51UQ9qUYIMFWlgnpNMKuy0LRA7E2XJAFPsJLw6XzKv5DzdXn7X5
	 zlO/3kUChmzTr/sxexYJuQH7aRvcawMo+chIWZzolfUUUPD46ACSxAmDl9pJLxVINo
	 ui6pEL+Nu07Aw==
Date: Fri, 6 Nov 2026 21:41:21 +0200
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
Message-ID: <au4tYR8ZgTLVDWHv@kernel.org>
References: <20261105031401.956609-1-jarkko@kernel.org>
 <20261105031401.956609-3-jarkko@kernel.org>
 <27015846-0161-4700-b810-4643e1f7b63a@suse.de>
 <20261106090516.GA1973@sol>
 <93e6b4e6-43c3-462d-b57c-26676aec85ec@suse.de>
 <au4k69xNBUjsNErr@kernel.org>
 <20261106191920.GA3383096@google.com>
 <au4q4Wh7PK1-Ge9P@kernel.org>
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
In-Reply-To: <au4q4Wh7PK1-Ge9P@kernel.org>

On Fri, Nov 06, 2026 at 09:30:45PM +0200, Jarkko Sakkinen wrote:
> > SipHash is also useful for resistance against denial-of-service attacks,
> > where a user puts all their keys in one hash bucket.
> > 
> > As I mentioned, it's already used for secure hash tables elsewhere in
> > the kernel.  That is what it's for; see
> > Documentation/security/siphash.rst.  It's very fast as well, so if you
> > are thinking of cryptography as being something very slow and hard to
> > use, that is not what this is (or ever needed to be).
> > 
> > Let's just use it and not over-complicate things.
> 
> I'm pretty much non-opionated when it comes to this detail. I just
> merely represent all the possible if anything comes up to mind. DoS
> protection that you explained was not something I did even consider so
> that seals it for me.

I'm cutting hairs now but indices + siphash adds to defence in depth as
it only takes DoS protection from SipHash while not protecting a secret.
Not sure if this has that much pratical meaning tho  :-)

Br, Jarkko
