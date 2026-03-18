Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C858F33B6E3;
	Wed, 18 Mar 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855619; cv=none; b=UkQ7Z3bLjy57aVMOzBubmdFO3Kg/ur3SvZKsSc0d0RNTns27Gvc/wNl05dheAYV34uSmfXE2J72bUASt9+lAqcpuSW9B3F9CI+z+zSyDG/UEo5d1QDxDXIyEMD8BjnODg2CPOS9tNIIG8fMSFTVL4m7xMqPLWJeOy900mYzQgMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855619; c=relaxed/simple;
	bh=lMaafKz25TchJzGhV5You8Kz/5A2UYmrUAz3zGYROdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=auXgczgJ3kBbCtC3EWRNRZRQB9gwZBBDgId9c/kGqJRmPK8JUcSVgL9mLuIaINznxbuM1ZqqqkuRvE/ycjDpkqU2e5vHUdopMZt6hNRL9hLJnXP6jeYhspJMIMQpeAxG+HKfz0/tBYe87eH3JfrCTt3d6c8m3J4YdhfgtPv+OIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NTOH/Kgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NTOH/Kgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047C7C19421;
	Wed, 18 Mar 2026 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773855619;
	bh=lMaafKz25TchJzGhV5You8Kz/5A2UYmrUAz3zGYROdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NTOH/KgsvJGxwwJYHkMAd6oGowUKLQquFCHZYwEyZPIs5q3Rxx5xxhEud80GGaLn6
	 IG/9DH9iHvBdLj/hRJ8lLthSceBCXQJFuixl/DOyWI2GkY+bM2Q0Tg8993ki8h39L4
	 rJQQtr85nAaSW+s9vIMYMSQIFVhLHka9B+UAHamG+CIKi9sVRt7XVWmnaAnQFrVgiu
	 aUorcCoyPqIcpWW+Xsd1za3Qmv+qrZQaknXW3OTFQGjNsz92tu+i/VYEkbFBdnOXKw
	 KgvW8gS2cTlPFsydLJdWw+bypb/+bVzuxgmQLvMJ/6hOmhrku1kbGSXAzF6HptIFVz
	 xQUNTk/oLj0Yw==
Date: Wed, 18 Mar 2026 11:40:17 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 1/2] dm-crypt: allow unaligned bio_vecs for
 direct io
Message-ID: <abrjgdttXBHCFh34@kbusch-mbp>
References: <20260316150229.1771884-1-kbusch@meta.com>
 <7cc4892a-5a2f-09b7-1f32-320acac4c797@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cc4892a-5a2f-09b7-1f32-320acac4c797@redhat.com>

On Wed, Mar 18, 2026 at 05:19:39PM +0100, Mikulas Patocka wrote:
> On Mon, 16 Mar 2026, Keith Busch wrote:
> > +	if (!unaligned_allowed) {
> > +		cc->io_alignment = cc->sector_size - 1;
> > +	} else {
> > +		set_bit(CRYPT_DISCONTIGUOUS_SEGS, &cc->cipher_flags);
> > +		cc->io_alignment = 3;
> > +	}
> >  	return 0;
> >  }
> 
> Why is "3" there? Should there be the dma_alignment of the underlying 
> block device instead?

It doesn't matter what the underlying block device reports because
dm-crypt bounces the incoming plain text buffers to something aligned to
the backing device for the cypher text.

Why 3? This can theoretically do 0, but you can't express that as a
block limit; block layer will assume you didn't set anything and use a
511 default, which is exactly what I don't want. So why not 1 instead of
3? Three is the smallest non-zero cra_alignmask currently reported, and
its inefficient to do byte aligned direct io anyway.
 
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1767,6 +1767,7 @@ int dm_calculate_queue_limits(struct dm_table *t,
> >  	bool zoned = false;
> >  
> >  	dm_set_stacking_limits(limits);
> > +	limits->dma_alignment = 0;
> >  
> >  	t->integrity_supported = true;
> >  	for (unsigned int i = 0; i < t->num_targets; i++) {
> 
> dm-integrity doesn't set dma_alignment if it is using 512-byte sector size 
> (assuming that there is default 511). This should be fixed in dm-integrity 
> before making this change.
> 
> Other device mapper targets should also be reviewed to make sure that this 
> change doens't break them.

The previous call to dm_set_stacking_limits() sets it to 511, which sets
an unnecessary minimum. Setting it to 0 here means that the stacked
device will inhereit whatever the mapper overrides it to, or go back to
511 if it decides not to override it.
