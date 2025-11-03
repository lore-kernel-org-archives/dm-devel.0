Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD752F9DB0
	for <dm-devel@lists.linux.dev>; Mon,  3 Nov 2025 10:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165446; cv=none; b=kWJrW0A/2JZ6nO7+nsYNmao95ZsBQgIEgINPcNtJvxk7AGTPgN4G4kR/HJZnwuLHuIzgMZCGGilbipox7CzVXAWI+wriiu0QgdlsTB602CcDMJ3zdN45NM9xjWPgmVvMSt2R8wjczFvcPAbCy5e9rccSy+jITriEdJ+HMuvZr0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165446; c=relaxed/simple;
	bh=FUZCd+virfGdLoGaRbAkHyz7ciacsYkUIKqwaUx+xcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T42eLdgX+nPoPhRtOslxm5iU7id02hjfFzd/oplcd7n8U5/q1+ZfnWjGduR/M/I7zehnIX+w+me2dUzfFb/FtErfqluv9hEAan/zQTDvqooi1uUdbjJf7YJk/qQbc2SMb5A9AERRNVC7mmA4CBlVoHllQXtYGBMOHS+rFxIVvVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0D03C227A88; Mon,  3 Nov 2025 11:24:00 +0100 (CET)
Date: Mon, 3 Nov 2025 11:23:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 10/13] block: introduce BLKREPORTZONESV2 ioctl
Message-ID: <20251103102359.GA8369@lst.de>
References: <20251031061307.185513-1-dlemoal@kernel.org> <20251031061307.185513-11-dlemoal@kernel.org> <5ca96ffd-9e60-49d3-a136-c7a9eb7bce10@acm.org> <b675e291-c369-4c7e-8fa2-1470ce90f001@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b675e291-c369-4c7e-8fa2-1470ce90f001@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 03, 2025 at 02:51:57PM +0900, Damien Le Moal wrote:
> On 11/1/25 01:52, Bart Van Assche wrote:
> >> +	case BLKREPORTZONEV2:
> >> +		if (rep.flags & ~BLK_ZONE_REPV2_INPUT_FLAGS)
> >> +			return -EINVAL;
> > 
> > -EINVAL probably should be changed into something that indicates "not
> > supported" rather than "invalid argument"?
> 
> Not supported could be confused with the cached report zones not being
> supported. It is, but the user cannot specify input flags that are not defined.

Yes.

> This is to ensure that undefined flags are always 0 and that we can use these
> going forward when we need to define a new flag.
> So EINVAL seems appropriate to me.

Using EINVAL here is consistent with other APIs, but a bit of an
anti-feature.  Not sure what another good more specific error code
would be, but given that we don't have other major EINVAL conditions
we might as well stick to it.

> >> +	/* Input flags */
> >> +	BLK_ZONE_REP_CACHED	= (1 << 31),
> >>   };
> > 
> > Why 1 << 31 instead of 1 << 1?
> 
> Why not ? That separates input and output flags instead of mixing them in
> tighter definition.

Agreed.  Thinking about it, once you go up to bit 31 all of them
should be marked unsigned, though, i.e.,

	....			= (1U << bitnr),

