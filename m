Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793727090;
	b=SXOVrEE3t+O0tCmJRZwufnoO5FDKMT1nG1nLZk/9tXU2GkRkeBkvk0rXuriH6weSqGHF
	 iuLaFBcOxei96vpGBncaLL30UNuctBg44/NoWZ+m/WghvCWts0UoO0JOB7Xr1SD1ZOX6q
	 auROft4hh/7eMqPrBh2s14WCE93hIxcTDYAmQPW+k2vR/aj3I3zug4qabbrtP5i9rGxNB
	 xN/36AJxudwhLexDwQKYsnmTCZZtk0UTvtPNLnhEnzS40j7PeTj4IKEC9kc/Ch8PmuOdy
	 gUukOvRW+Cvy/fOgIBmGcMOiYK+bZ/CVyapqLd5zckuInnO9uTASnSSr6ZPvqlBpyrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793727090;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1EcVZ6IQLR3bNJLWqG5/crsE6rB26+Jlh3JchK6UekA=;
	b=WQ+Kv6q6saKstTULt7QA7jp9FCat5p57i8sGORg3rnVDnlf3wMd80wR+VIKHR3mPuKFL
	 jJnNbVahU8hIzuXKBZu4lE/TWbLIdIiZZtj48CRvsyNxG02albnuR4xw8cEGkB+o6mfv1
	 kaUh252Sl+3tKmq2vbi4uea2iC2uivCHqocZKC55lvmfPhIQQgXfufzRefLhyFDsVzAHm
	 V/aovCILxUJABgbLGmLTCVQ2ri3c1eavu/nupSx8t4NWw9krzLAiTq1Yd95q3TnavL1Wv
	 Uy068VwU+GnM+0QhJI+QKDHSgV4HMt7U2PykZrcpMrUlps2vyz4PePL7em0vfytglrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqRmhqpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB22606A328;
	Tue,  3 Nov 2026 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqRmhqpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADA81F000C1;
	Tue,  3 Nov 2026 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793727089;
	bh=1EcVZ6IQLR3bNJLWqG5/crsE6rB26+Jlh3JchK6UekA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kqRmhqppnrb1SJ3SynN7sRWHrL/yNTibnHR0ojTm9puPVsLVomIvWXGXUFW0XjBY1
	 O3uKyFvToOeEjKfCiJL8FVGwqhKkTW6/6UNXIgDWtfWnnCCCvbNLS78Bp5KRUIUJQd
	 xIxXRgcYqGHtrgPBaN/cEro4IJHjPF1p2sUjeT164BDyDFEsEu0KgQSk4bgLMqNnPw
	 XZlp9TcWq4H98j6N1+CUedQWQa9LHNGbnAcbKJsBjY/WGPt+denrDEhmFNcC+TCbYu
	 JYnEhncnYi06gghnIjoZVPfVncfmpTPMoojtMs+x+CK1eFwphqskUNUR+I1rFOOpQ8
	 xTrIvpYZ+yqqA==
Date: Tue, 3 Nov 2026 10:31:27 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <snitzer@kernel.org>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, dm-devel@lists.linux.dev, mpatocka@redhat.com,
	bmarzins@redhat.com, linux-block@vger.kernel.org
Subject: Re: [PATCH] block: let a stacking device inherit its members' DMA
 alignment
Message-ID: <auoab2ewQZGDpRi3@kbusch-mbp>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-2-kbusch@meta.com>
 <atpBVtPqGDWZ2AFo@kernel.org>
 <aumxcHVjVonjs6OV@infradead.org>
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
In-Reply-To: <aumxcHVjVonjs6OV@infradead.org>

On Tue, Nov 03, 2026 at 02:03:28AM -0800, Christoph Hellwig wrote:
> On Thu, Oct 22, 2026 at 01:01:10PM -0400, Mike Snitzer wrote:
> > On Thu, Jul 09, 2026 at 09:15:17AM -0700, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > All device mappers that want to override the dma_alignment do so.
> 
> Don't start a patch description by quoting another mail.
> 
> > Direct I/O from memory every member accepts is therefore rejected at
> > the stacking device, and callers that check the advertised alignment
> > (for instance through STATX_DIOALIGN) fall back to buffered I/O.
> > 
> > Leave dma_alignment at zero in blk_set_stacking_limits() so that the
> > stacked value is the strictest of the members'.  blk_validate_limits()
> > still applies the SECTOR_SIZE - 1 default when nothing was stacked,
> > such as for a table with no devices.  Targets that process the data
> > themselves and need logical-block-aligned memory already set
> > dma_alignment in their io_hints (dm-crypt, dm-integrity, dm-verity,
> > dm-log-writes), and NVMe multipath sets its own.
> 
> Chances are very high that this will introduce bugs somewhere,
> as a lot of drivers are historically not ready to deal with lower
> alignments, and will creeat nasty exploitable bugs.
> 
> So you'll need to audit each driver that wants to relax this
> individually, and then override the value for them.  Alternatively
> we could start with 0 in the block layer, but then you need to
> lift the current setting into each caller first, and only remove
> them one-by-one with a commit per driver explaining why that is safe
> (and sensible).

I suppose it would be safer to have each stacking driver that can
tolerate lower alignment granularity explicitly override the limit to 0
to inherit whatever the stacking members require. For md-raid,
that's not too bad as it can set lim.dma_alignment = 0 in
raid0_set_limits() after md_init_stacking_limits(). But other device
mappers don't have a way to override it so I guess something has to
happen in dm_calculate_queue_limits() to allow this option.
