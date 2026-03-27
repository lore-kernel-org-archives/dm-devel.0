Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D067037C0FB
	for <dm-devel@lists.linux.dev>; Fri, 27 Mar 2026 20:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774643781; cv=none; b=JJxubPBpSeUjkQLtq+I/XhYlyuh7lXrt9dwN2hD2tMLJGfUwAn5jUtwMG+vyQDszroDAC6EblsSD4rMH/NighRyib6nfYEsfqasAmxq8A48xSRPpsx1Q/CxSA1oDaH2TZVo44Sz3a/6X2MvgdltYgw5U/xyvGvqyBqJbacT8zv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774643781; c=relaxed/simple;
	bh=tHg1FphT+70rdHCe57tPW7297wMnZqhOJ0AD0wTkMrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvqZ4dBq2umR0veayK/S7YWtyNDMxSWGHepIeQ17whEvl0nEqB7T82aT7GG0WTrdWHfVaw2zcpMRqfl3rGkq/Tun4gaYrjW3Bjn9d4Pkr2r/E0DCS4QqLI57nTwigjCIjqa1ETI6MbdlaSIWJBUAclt9ngV97oeFCf9EDw+5NbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlMhb3VO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlMhb3VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEFEC19423;
	Fri, 27 Mar 2026 20:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774643781;
	bh=tHg1FphT+70rdHCe57tPW7297wMnZqhOJ0AD0wTkMrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QlMhb3VOgEZ89Kde2qFjBvAmeNDId99P6llo1I8S6G1flU25tAwgChZfTRUvtun5r
	 4IllVAb5zLTidD8/DCd8FcL3f43VC647zWVrDSZ9DhPyqxcK4e2fXnbyXFuKvsWD/9
	 WXi2s7BQ4NvQvMA+1tZXybyC8DX2UVWdJ3qZ9d4zN/kXXQPNx0hjgAI/myFExG3YwW
	 gEqk3CHfy6lzvS7eiVbW0n7dIz9RxfNaXCpurNfWvRA2rZHUMnjmpUL+4rw1bTx4f6
	 /ksO6jv1bH4MAvXbq+HADMRnzs2azv3u61iC+uLjgCnTCOr87g3l3ezbBc1r8pS9yo
	 dahYJro4nroQw==
Date: Fri, 27 Mar 2026 14:36:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	mpatocka@redhat.com, snitzer@kernel.org
Subject: Re: [PATCH 1/3] dm-integrity: fix mismatched queue limits
Message-ID: <acbqQ5YaFPMQ23UI@kbusch-mbp>
References: <20260325193608.2827042-1-kbusch@meta.com>
 <acbdfhN8AT7p4qrN@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acbdfhN8AT7p4qrN@redhat.com>

On Fri, Mar 27, 2026 at 03:41:50PM -0400, Benjamin Marzinski wrote:
> > @@ -4047,9 +4047,15 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
> >  	struct dm_integrity_c *ic = ti->private;
> >  
> >  	if (ic->sectors_per_block > 1) {
> > -		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
> > -		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
> > -		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
> > +		limits->logical_block_size =
> > +				max(limits->logical_block_size,
> > +				    ic->sectors_per_block << SECTOR_SHIFT);
> > +		limits->physical_block_size =
> > +				max(limits->physical_block_size,
> > +				    ic->sectors_per_block << SECTOR_SHIFT);
> > +		limits->io_min =
> > +				max(limits->io_min,
> > +				    ic->sectors_per_block << SECTOR_SHIFT);
> >  		limits->dma_alignment = limits->logical_block_size - 1;
> >  		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
> 
> Shouldn't this also respect the underlying device's discard_granularity?

It doesn't appear to. I left it unchanged as I'm not very familiar with
this device mapper, so that seemed safer. But I thought it was fine as
is: this dm doesn't appear to forward discards, so the underlying
device's constraints aren't brought into the operation. It looks like it
just sets a "DISCARD_FILLER" pattern into metadata.
