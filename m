Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AF92857FF;
	Thu, 10 Jul 2025 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752163815; cv=none; b=lbc0VbgodzBg49DkSnQkRl+cltS1c9XaVC5Nd8jsviGgDZCVZcYJ2TKCY/wbFuUiVnwJckmyMgCmkOcPx8OoRxMcczu/jm1yfT7O5F7oVFZbBf2BIJxZzA6yqv7xv2X1NVnyAAt559y8CVOlgWH/o3QhhkT6N3xnP+G9QulM0rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752163815; c=relaxed/simple;
	bh=HsaQD1FzOjjJAoMEb/ZqrYezOqpDFwCtpyhKgWDHHQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t1L+ToN06O9hbdiXMrocJQATIxC9v25nZRSU5EbXsGBXoto950XEyCRHWrMbTZODSCnR4wSrXr4x9z+p/pyK+LggMBAfuweewexqu1GWS6dw9O1JfuIiqnm95yn7On5S1TgRfMXF4DT1nDyALy2PlAy/0DdohdIwH0OmjojFZYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlqYfsdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlqYfsdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1B2C4CEE3;
	Thu, 10 Jul 2025 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752163814;
	bh=HsaQD1FzOjjJAoMEb/ZqrYezOqpDFwCtpyhKgWDHHQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nlqYfsdoO/0BjDrlgFRtOXAB3gfgBRiUQD++vmNHeV6eAEUfzNMf6lUNdsuMPvsP5
	 JP0fUeFGUB3+X0kAG2YQRc7c7BlsnOVmmVAtrjPxHLpqsBA1zBpnsLYSxP1WGCkAPY
	 cji0KefOEQ35gPX56TyLiL1+WnqOJu1PHu69t/94d2EtclqRXvfibYdutFZ21iMgIE
	 wbUwuKq6j9BuXTGfApRZyL+UdqQQxK/IxGrZsXmabxW5CzYw4YOtij9MHGEyOwRbCg
	 8qO/HdFSLp7QrJuAnXZqoEhmWpA9CkcBSzhj8AHRr+GdIYfxJORnBaJe/8Wan7mh36
	 bGJpZWwErr0XA==
Date: Thu, 10 Jul 2025 16:10:12 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2] dm-verity: remove support for asynchronous hashes
Message-ID: <20250710161012.GB604603@google.com>
References: <20250709190902.49554-1-ebiggers@kernel.org>
 <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ee8338a-b19a-409a-bbe6-2068893b8abc@gmail.com>

On Thu, Jul 10, 2025 at 10:28:55AM +0200, Milan Broz wrote:
> On 7/9/25 9:09 PM, Eric Biggers wrote:
> > The support for asynchronous hashes in dm-verity has outlived its
> > usefulness.  It adds significant code complexity and opportunity for
> > bugs.  I don't know of anyone using it in practice.  (The original
> > submitter of the code possibly was, but that was 8 years ago.)  Data I
> > recently collected for en/decryption shows that using off-CPU crypto
> > "accelerators" is consistently much slower than the CPU
> > (https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/),
> > even on CPUs that lack dedicated cryptographic instructions.  Similar
> > results are likely to be seen for hashing.
> > 
> > I already removed support for asynchronous hashes from fsverity two
> > years ago, and no one ever complained.
> > 
> > Moreover, neither dm-verity, fsverity, nor fscrypt has ever actually
> > used the asynchronous crypto algorithms in a truly asynchronous manner.
> > The lack of interest in such optimizations provides further evidence
> > that it's only the CPU-based crypto that actually matters.
> > 
> > Historically, it's also been common for people to forget to enable the
> > optimized SHA-256 code, which could contribute to an off-CPU crypto
> > engine being perceived as more useful than it really is.  In 6.16 I
> > fixed that: the optimized SHA-256 code is now enabled by default.
> > 
> > Therefore, let's drop the support for asynchronous hashes in dm-verity.
> > 
> > Tested with verity-compat-test.
> 
> Hi,
> 
> I shortly tested it with veritysetup too, also on 32bit.
> And I like this patch (I wish we can remove the async thing from the dmcrypt too...)

IMO we should do it for dm-crypt too, though it's going to be a slightly
tougher sell there because it actually goes through the trouble of using
the async API "properly".

- Eric
