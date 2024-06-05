Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CDE190484
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 06:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717570155; cv=none; b=isswzoUPuLopgdKzF3hf200Wgw8eunANaFfHI+1nIqioI5Bimb0r8Vzxc+TFlQXEcSiX6Yap/Nyqii3usN9TrMqU4anJLIxBloiHTPholl2cxZq7ETnikqGn/n2BRLjD0E9ezun8pEw2fped07r6nWFD5Q7Y8HZjKl3on4q3kMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717570155; c=relaxed/simple;
	bh=E8cxZOpNs06fxtDMP3JLM/5xUjFAp11XIyEgNoTGJkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CfzzUAe53utx5PUp7XC67M2Mock+yW87zr6uimgfvui+aE1EWXi3xPN0divKsmANStpMj1OGuZ7MfpS+93ysrLk1oovttis1Oi9RZTtp8s9oYDuVVh3jU6MquFQNQx2S5IjpWqCeN3RZecgblH/rqAho8KixGN0KFYZl+sh2xNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E851E68D05; Wed,  5 Jun 2024 08:49:10 +0200 (CEST)
Date: Wed, 5 Jun 2024 08:49:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v3 2/2] dm: Improve zone resource limits handling
Message-ID: <20240605064910.GB14642@lst.de>
References: <20240605063907.129120-1-dlemoal@kernel.org> <20240605063907.129120-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605063907.129120-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +	/*
> +	 * If the limits are larger than the number of mapped sequential zones,
> +	 * assume no limits. Note that blk_revalidate_disk_zones() also executes
> +	 * this adjustment, but only for mapped devices that use zone write
> +	 * plugging, that is, for mapped devices needing zone append emulation.
> +	 * So for DM devices using native zone append of the target devices, we
> +	 * need to adjust the zone resource limits here.
> +	 */
> +	if (lim->max_active_zones > zlim.mapped_nr_seq_zones)
> +		lim->max_active_zones = 0;
> +	if (lim->max_open_zones > zlim.mapped_nr_seq_zones)
> +		lim->max_open_zones = 0;

Is there any good reason to not just do this unconditionally in common
code?

