Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BA025776;
	Mon, 15 Jun 2026 19:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781551520; cv=none; b=Y5UgyGG9NBy/3oykWYZLtME7b71VMh/dOQHVmXRsg68frswpnyDxR3M89Xz7jvSHRVnEUToCYcbXl3GmtTycmOYcJS5FM+CXgw3ks++IrS84gYTbXEdWsxrH0jhLhjYeTVsCqFY7Rv907Q5FnJW4ei93pXlirR2PQo/QaBKCQqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781551520; c=relaxed/simple;
	bh=xcCL0pBFLSUueKbbdCERNE0vD2OIUdxB4/A2QjFsqZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRUzfWDPWh4Ly5OMWU8BQtgmZHKKdYY2IRIy0UsuKD7pmLNYweO071kGGqVEfT37flJrNRPkwJCpXU0ZNd7rziukK1yb9QndyVtptC+Ze/Gq3YZwWfGBZ/qO/bks+QPIce107UVF6aLE93E3GWiF3UQ5onGsBi8iyXGP8L/UnAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUR1syh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUR1syh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704671F000E9;
	Mon, 15 Jun 2026 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781551519;
	bh=XImiJzUy2p4Y8Op2JwUEIV2Jl3UCBUZzU96cLFEpEWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EUR1syh3q/KB0CueCCTt3Px9pBu0R9A3V9pCfX8ZKli1nfgYENVfjJJl2xwmtIxxF
	 TZZd0wOUEN7yqkCkoaVR3/KofDcXoB/aMI3WjngNEYZHxPEbffpn5l0th3XHt0XLSx
	 4Inr6GoC9GPQgMxx02vpfBgn2kRPRYV+IOVLmY4tyV0QNTmO90kmdnaUXWtAj3RVoQ
	 PL1N50fMzl9sWciAzgBTmG5PkxF8ZwJSpfO3gl0GSN4BcWnf6rKi+bZTSiQNtcfwD3
	 ZeiBerDntAsEnZYThBoD3FoDIig2U8W7oTboI2pyicSAtaPWLOERqtL3VVoCpQt+9H
	 qh2+py2ZKtc5w==
Date: Mon, 15 Jun 2026 13:25:17 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajBRnUqXd7DqxLiG@kbusch-mbp>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <ajAYN_mmjzYBAimV@kbusch-mbp>
 <ajAb0m9cNraQn2Pw@kbusch-mbp>
 <ajAqUwo3eTm1c2_J@gallifrey>
 <ajA0L-u-r4nhbpfl@kbusch-mbp>
 <ajA5kpUraXqh9ag9@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajA5kpUraXqh9ag9@gallifrey>

On Mon, Jun 15, 2026 at 05:42:42PM +0000, Dr. David Alan Gilbert wrote:
> * Keith Busch (kbusch@kernel.org) wrote:
> > On Mon, Jun 15, 2026 at 04:37:39PM +0000, Dr. David Alan Gilbert wrote:
> > > Hi Keith,
> > >   Thanks for the patch, alas it doesn't seem to be helping here;
> > >  the first warn is still the same
> > > and it still hangs the test process hard and eventually BUGs at
> > > 
> > > void blk_mq_end_request(struct request *rq, blk_status_t error)
> > > {
> > >         if (blk_update_request(rq, error, blk_rq_bytes(rq)))
> > >                 BUG();
> > 
> > Oh, that was not expected.
> > 
> > What is the dma alignment requirement of your backing devices? You can
> > find the attribute for sda at /sys/block/sda/queue/dma_alignment. I'm
> > expecting 511, but just want to double check.
> 
> Yeh looks like it:
> /sys/block/sda/queue/dma_alignment:511
> /sys/block/sdb/queue/dma_alignment:511
> 
> all of the lvm also looks like it is.

Thanks for confirming.

I'm struggling to see how you're getting there with your reproducer with
the proposal included. I can see other short comings with preadv or
really large pread's, but not with a 4k pread. For those other issues
this patch can fix it:

  https://lore.kernel.org/linux-block/20260612223205.465913-1-kbusch@meta.com/

It is currently staged for upstream, so hasn't landed yet. But again, I
don't think those conditions apply to what you're seeing, but worth a
shot on top of the previous proposal to use byte units instead of
sectors.

In the meantime, since I so far can't reproduce this after including my
previous proposal, I may have to request trying out a debug patch to get
some more visibility on what's happening if that's okay.
