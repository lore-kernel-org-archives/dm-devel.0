Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7714FA29;
	Mon, 10 Jun 2024 07:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718003759; cv=none; b=lS2XbFudrjkr13R7d65MrbD/MnwB6IS6mL/wdkgRJERRrwpNMxiX5eQHAeH40Yv8D6SPKH3sUBaqjmMOLTEnj+tz6lkXIt4Y2Tnonlok07Q2xEWS0lvB4VyqnLFNvU3CZRw7mi2S/WBS7oCcIKsGfkyWUMYYw5Nm7WRfEhvueT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718003759; c=relaxed/simple;
	bh=AT9caPkcxQw40Ah/9E2kglfuKY4ib2yx/plttk2J048=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcKU6BcNk89ssEq+4ZrJBZW1PbcLrEO5o6pSY+4meDH2cRNBrGGiK2iZDP/ylJ3bEI/yrgIvf6J/WavMEwC6NNryXnEkcKomLLj9WiqbV6DfgaQP4qayLSXLS+YU/6sOC/LycrlyTokkljUGeMmmE+DEosbi9Kk1sRBi8VAN5m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qai6yvH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qai6yvH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF7EC2BBFC;
	Mon, 10 Jun 2024 07:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718003758;
	bh=AT9caPkcxQw40Ah/9E2kglfuKY4ib2yx/plttk2J048=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qai6yvH9ybD6CkDSZOMsrcy1JrptBFE8ZMTiSpcXntPv3ChqEtaiq7n+TeCBH2bfx
	 tLz572USYVRI7YN5KstoNlX7YqkKsVIaF20J3vZuHzIqv0U0kImLSJf+sOqRyFXMkA
	 eTEY32Enla3glMWuU1e7SNDXhn6MNlmlRXcfIifsR6oU38PV4kuFgUV+qK8+VQV73K
	 iYU8/fA+lJ15/OH3T0rt0bwybLftjjjIuai52M/GKPz2s2eqJfRoYOyRWYDZLcoRod
	 Kwt2iLO4BALhN98RhSi35k/SAUmLgK3K10ocTI5oQWffo6I2W0GIUvrCULZUMvcnR8
	 kza+vFRhw7ndw==
Date: Mon, 10 Jun 2024 09:15:53 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v6 1/4] block: Improve checks on zone resource limits
Message-ID: <ZmaoKbULhbb8sIdE@ryzen.lan>
References: <20240606082147.96422-1-dlemoal@kernel.org>
 <20240606082147.96422-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606082147.96422-2-dlemoal@kernel.org>

On Thu, Jun 06, 2024 at 05:21:44PM +0900, Damien Le Moal wrote:
> Make sure that the zone resource limits of a zoned block device are
> correct by checking that:
> (a) If the device has a max active zones limit, make sure that the max
>     open zones limit is lower than the max active zones limit.
> (b) If the device has zone resource limits, check that the limits
>     values are lower than the number of sequential zones of the device.
>     If it is not, assume that the zoned device has no limits by setting
>     the limits to 0.
> 
> For (a), a check is added to blk_validate_zoned_limits() and an error
> returned if the max open zones limit exceeds the value of the max active
> zone limit (if there is one).
> 
> For (b), given that we need the number of sequential zones of the zoned
> device, this check is added to disk_update_zone_resources(). This is
> safe to do as that function is executed with the disk queue frozen and
> the check executed after queue_limits_start_update() which takes the
> queue limits lock. Of note is that the early return in this function
> for zoned devices that do not use zone write plugging (e.g. DM devices
> using native zone append) is moved to after the new check and adjustment
> of the zone resource limits so that the check applies to any zoned
> device.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
