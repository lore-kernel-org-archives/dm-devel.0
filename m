Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794592133;
	b=PoV6hG0t/zcQpUzRfIMAZTlv/+Z3w6B+qO04qsmn+X6+wEnua5aRyEZoLYYvn3aCGp4n
	 aaPqDxwAp9vxta4cpXUY22MVZuJkHl836/Kn4TIwqkkNj2ZA/WTf7nqKqoMFyh32bJqvr
	 tPQVjGuFyjZH43rcAmmskAgNRCbF7yCGfp5cgDWMRDwABgo4rVuPG+caLQgzLbNojQUAA
	 8e5A3GB4oB8HICAy9Waiq9iwkLm5gcSpPLWvZxgAabwrnqVxQPZx+dsIOjebwKTsdGKO+
	 1Tp+f6H6E088mLaOnkywx/hgkg5oHEAjsys5NZ5gnDzmGpLkwlZIST9IsC11gqz5/7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794592133;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ooI7fR5hPMADfM09gnQ2GeQ2RGDqZeb2INKQW8KW1jc=;
	b=JMZVZnjRCVH0z5G5fItvyyLZrqRnW6c2qruYeNYIE6NXU5Mj1ZlMf/JwK8k72MU0EVQb
	 pPMgLA+V5cKzoG/eN7CVgBZDqzJ+0ji1k6fScL22SGX4tDydqIawcOW62pDuk4CwXIMHh
	 CsvG8UrxQ1YaeW3lEtu9ujuc9WDYxOrF9W8Gm51G0Mxi/23adPFh+OAjTTZgq3cNHsjTD
	 /hrcxon3RY0sdl5RcJCI30LQBIkdG+ZwN+2gvq4l0FjbRYaJ9UZkHqkKW21meVOBMxCmR
	 t6qo7qCY3FTnOz3K2SiZmUReWLNBG+3iFlRTZYT9hcD+bsKZNGBdKZkZUu7Y3d2bH/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N3sElEkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15DA607A5C7;
	Fri, 13 Nov 2026 17:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N3sElEkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620591F000C4;
	Fri, 13 Nov 2026 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794592132;
	bh=ooI7fR5hPMADfM09gnQ2GeQ2RGDqZeb2INKQW8KW1jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N3sElEkn+JBk91djvtjbrP0QuPXQKPTN9E0olSHtjnzsPyVohW8R4vo7JJaZVk0bq
	 h1tBOe7paGj3F2pnqo6MB49o155jxpXtEctVTzyJNDDrUz83IFlRD/CyMMU+FG9Eef
	 h0Jp9elwcoEoEcdLyUq+nYVpJwmG3g93HcQG2mfu7ukdWFg6MRBFnWILaSntgy6zeA
	 wrWRJkqX1r3nkdl8Tg0jm9mocmB7u9X+FtPE9bZg35KCxs3jZ9VrO7kW6SgrUQkpn3
	 U5VCZBEyDKYjtonnl/hHhBj3IMIFsui7joZvVFED0s0gq7irofMUXuKfYnchVE2rfe
	 tYhN9GrA++h/A==
Date: Fri, 13 Nov 2026 12:48:51 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, dm-devel@lists.linux.dev, mpatocka@redhat.com,
	bmarzins@redhat.com, linux-block@vger.kernel.org
Subject: Re: block: let a stacking device inherit its members' DMA alignment
Message-ID: <avdNg7ckyt6-M8si@kernel.org>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-2-kbusch@meta.com>
 <atpBVtPqGDWZ2AFo@kernel.org>
 <aumxcHVjVonjs6OV@infradead.org>
 <auoab2ewQZGDpRi3@kbusch-mbp>
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
In-Reply-To: <auoab2ewQZGDpRi3@kbusch-mbp>

On Tue, Nov 03, 2026 at 10:31:27AM -0700, Keith Busch wrote:
> On Tue, Nov 03, 2026 at 02:03:28AM -0800, Christoph Hellwig wrote:
> > On Thu, Oct 22, 2026 at 01:01:10PM -0400, Mike Snitzer wrote:
> > > On Thu, Jul 09, 2026 at 09:15:17AM -0700, Keith Busch wrote:
> > > > From: Keith Busch <kbusch@kernel.org>
> > > > 
> > > > All device mappers that want to override the dma_alignment do so.
> > 
> > Don't start a patch description by quoting another mail.
> > 
> > > Direct I/O from memory every member accepts is therefore rejected at
> > > the stacking device, and callers that check the advertised alignment
> > > (for instance through STATX_DIOALIGN) fall back to buffered I/O.
> > > 
> > > Leave dma_alignment at zero in blk_set_stacking_limits() so that the
> > > stacked value is the strictest of the members'.  blk_validate_limits()
> > > still applies the SECTOR_SIZE - 1 default when nothing was stacked,
> > > such as for a table with no devices.  Targets that process the data
> > > themselves and need logical-block-aligned memory already set
> > > dma_alignment in their io_hints (dm-crypt, dm-integrity, dm-verity,
> > > dm-log-writes), and NVMe multipath sets its own.
> > 
> > Chances are very high that this will introduce bugs somewhere,
> > as a lot of drivers are historically not ready to deal with lower
> > alignments, and will creeat nasty exploitable bugs.
> > 
> > So you'll need to audit each driver that wants to relax this
> > individually, and then override the value for them.  Alternatively
> > we could start with 0 in the block layer, but then you need to
> > lift the current setting into each caller first, and only remove
> > them one-by-one with a commit per driver explaining why that is safe
> > (and sensible).
> 
> I suppose it would be safer to have each stacking driver that can
> tolerate lower alignment granularity explicitly override the limit to 0
> to inherit whatever the stacking members require. For md-raid,
> that's not too bad as it can set lim.dma_alignment = 0 in
> raid0_set_limits() after md_init_stacking_limits(). But other device
> mappers don't have a way to override it so I guess something has to
> happen in dm_calculate_queue_limits() to allow this option.

DM devices have the ability to change limits really well, both in DM
core and the individual DM targets using .io_hints hook in their
target_type struct.  Mikulas knows what is needed for DM.

Mike
