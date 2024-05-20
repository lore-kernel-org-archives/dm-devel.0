Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAF6137742
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716220497; cv=none; b=AIuc5Wd/wn92bEIYV6vO7U2h2+W4DsLBNLTGo7kLRS9ZMb+lHuHcIAdtsbupetC9sUZtZPGxk5X+6FwOvqvww1JgaKX/QBIBMD62JzGA/+RT1L/P30QcsjW+oAgRgawqtelTCHxfoe4F13h8Yb1uSfMAdZ/Fu3FoWSbEkCbVfyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716220497; c=relaxed/simple;
	bh=Homzp/63aiX0b0frqJlJfO8Q6OA7Jf4akX4P+wX3COw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INS8rNcqxcjS8a9verFMSn54qyZzi3K7xVEk/krPWPrIh/CgEOOCw0NQZujaJBfa3kWiAcgEVrerNZPXx/m6148p295YiSGkjDKmugD1XQJwx2pG7dDAQdfxwwoyH3z5RLrMrSriBar3QkTlDpGUH2WF73n0sIwN040Hm9qGF9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-43e4c568e14so16372911cf.3
        for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 08:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716220494; x=1716825294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaIyNEamC/GOVmXOOEefzqW6FyJnCYusfseZnVHqXxo=;
        b=pNZnrmPLiPzX36QjICFBSzT+NfJiYj0nYiPiQNEbPg0bRxSLb6xVjeNJqHzfo31kHx
         rMz8yfa0tjsGYOPhaC6BJG31juxpUfD9QMJWlcRcm9WkFU4B7nO3jc5603LbopNwUS5l
         l2vDyu9AnBmVPHpC67A60xjOIaT4Hb/5eWuTDZmiogtjLuWFihES6fB4155Hm6Pf5u76
         p+rqPhITO2OP2cgRoAUbTtFMl9zG/pn+kNhMTjNi/lbyXHibv5YLpmY178I65gxnag8D
         MnI49/fvQNAGfeeLu7na1ElU/aKL78rRSIt1+AWdGoIABnp9nxhW+qMwMCHygoYiRmmW
         5uQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCBJe/TJMBWtTSfUS3hSVSBbQi3qVjP/ACVxKi60YNXcXx07Z6d6vkkdwgINOLrAZOQCE4rII85etqvsW/vbgAUPfLF21Engw=
X-Gm-Message-State: AOJu0YyE0/QpDlvRg2BOyFKDj0xLLCBjgVNfnn54ukh6nf1lkwlqMS7k
	9srKJt55G/a4rLasfTDfwZKe8Qgmq7JPqEU4N/enmsysV4/IO7KFvelxbhXVxPU=
X-Google-Smtp-Source: AGHT+IFEI2WIsnG6E5eeNjkDC8pyDKtauCuIbSxAV0M2We8mLigkzXUeIcnUOFltjNKjK00xd2PSYQ==
X-Received: by 2002:ac8:5d49:0:b0:43a:a82d:4fa with SMTP id d75a77b69052e-43dfdaa9ab4mr263199961cf.15.1716220494481;
        Mon, 20 May 2024 08:54:54 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43dfa0fc2e1sm142427401cf.56.2024.05.20.08.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 08:54:54 -0700 (PDT)
Date: Mon, 20 May 2024 11:54:53 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Theodore Ts'o <tytso@mit.edu>, dm-devel@lists.linux.dev,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	regressions@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: dm: use queue_limits_set
Message-ID: <ZktyTYKySaauFcQT@kernel.org>
References: <20240518022646.GA450709@mit.edu>
 <ZkmIpCRaZE0237OH@kernel.org>
 <ZkmRKPfPeX3c138f@kernel.org>
 <20240520150653.GA32461@lst.de>
 <ZktuojMrQWH9MQJO@kernel.org>
 <20240520154425.GB1104@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520154425.GB1104@lst.de>

On Mon, May 20, 2024 at 05:44:25PM +0200, Christoph Hellwig wrote:
> On Mon, May 20, 2024 at 11:39:14AM -0400, Mike Snitzer wrote:
> > That's fair.  My criticism was more about having to fix up DM targets
> > to cope with the new normal of max_discard_sectors being set as a
> > function of max_hw_discard_sectors and max_user_discard_sectors.
> > 
> > With stacked devices in particular it is _very_ hard for the user to
> > know their exerting control over a max discard limit is correct.
> 
> The user forcing a limit is always very sketchy, which is why I'm
> not a fan of it.
> 
> > Yeah, but my concern is that if a user sets a value that is too low
> > it'll break targets like DM thinp (which Ted reported).  So forcibly
> > setting both to indirectly set the required max_discard_sectors seems
> > necessary.
> 
> Dm-think requiring a minimum discard size is a rather odd requirement.
> Is this just a debug asswert, or is there a real technical reason
> for it?  If so we can introduce a now to force a minimum size or
> disable user setting the value entirely. 

thinp's discard implementation is constrained by the dm-bio-prison's
constraints.  One of the requirements of dm-bio-prison is that a
discard not exceed BIO_PRISON_MAX_RANGE.

My previous reply is a reasonible way to ensure best effort to respect
a users request but that takes into account the driver provided
discard_granularity.  It'll force suboptimal (too small) discards be
issued but at least they'll cover a full thinp block.
 
> > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > index 4793ad2aa1f7..c196f39579af 100644
> > --- a/drivers/md/dm-thin.c
> > +++ b/drivers/md/dm-thin.c
> > @@ -4497,7 +4499,8 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
> >  
> >  	if (pool->pf.discard_enabled) {
> >  		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
> > -		limits->max_discard_sectors = pool->sectors_per_block * BIO_PRISON_MAX_RANGE;
> > +		limits->max_hw_discard_sectors = limits->max_user_discard_sectors =
> > +			pool->sectors_per_block * BIO_PRISON_MAX_RANGE;
> >  	}
> 
> Drivers really have no business setting max_user_discard_sector,
> the whole point of the field is to separate device/driver capabilities
> from user policy.  So if dm-think really has no way of handling
> smaller discards, we need to ensure they can't be set.

It can handle smaller so long as they respect discard_granularity.

> I'm also kinda curious what actually sets a user limit in Ted's case
> as that feels weird.

I agree, not sure... maybe the fstests is using the knob?
