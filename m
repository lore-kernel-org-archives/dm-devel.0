Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01891EF0B0
	for <dm-devel@lists.linux.dev>; Wed, 30 Oct 2024 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730296339; cv=none; b=gBvGSmbPfuMmTSldYqmOPLCV5dYEM9Fn0Mmr2nQsUhPWdZvM0+JzRpk0EMS00Tkq1gczSnO+pj61TnZFt52hZw/uSqsx9fkqqJrT1+Y/ggP0GyhnL0yS7HsazsPgtCaDSvUb/BBgvb0BwewQ3N0tpjHX4iddoHHdjYf/lWsN2RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730296339; c=relaxed/simple;
	bh=2mLUU982IqWK2KYwZS4Lz725WmnjU47VYzfifclBaDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lf8qPFNHLOn+Z8QZutHsqnmBPOWmU34U1eMqHtFVBLgnrJijMETLA1OTCDYdN+XYcmcR+AlrVVHkYhuR9vWWBrexSyFUX+Ro9Be/aGZs3WPtHxnzY/pD64JzCDp2DdmZxT8p234cI8wti5AwT4qEsI8q9KQMzxPUXgD6pLDo4yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 82A48227AAE; Wed, 30 Oct 2024 14:52:14 +0100 (CET)
Date: Wed, 30 Oct 2024 14:52:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Coddington <bcodding@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH] dm: add support for get_unique_id
Message-ID: <20241030135214.GA28166@lst.de>
References: <f3657efae72f9abb93d3169308052e77bf0dbad6.1730292757.git.bcodding@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3657efae72f9abb93d3169308052e77bf0dbad6.1730292757.git.bcodding@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 08:57:56AM -0400, Benjamin Coddington wrote:
> This adds support to obtain a device's unique id through dm, similar to the
> existing ioctl and persistent resevation handling.  We limit this to
> single-target devices.
> 
> This enables knfsd to export pNFS SCSI luns that have been exported from
> multipath devices.

Is there anything that ensures that the underlying IDs actually
match?

> +	struct dm_unique_id *dmuuid = data;
> +	const struct block_device_operations *fops = dev->bdev->bd_disk->fops;
> +
> +	if (fops->get_unique_id)
> +		return fops->get_unique_id(dev->bdev->bd_disk, dmuuid->id, dmuuid->type);
> +
> +	return 0;

Overly long line here.  Also maybe just personal, but I find code easier
to read when the exit early condition is in the branch, e.g.

	strut gendisk *disk = dev->bdev->bd_disk

	if (!disk->fops->get_unique_id)
		return 0;
	return disk->fops->get_unique_id(disk, dmuuid->id, dmuuid->type);

