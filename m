Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B7012FF63
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712672608; cv=none; b=ArABPxGvfGk0tlwc/GtP5tPoYwivt/X2qhGz0ntusSfeNr39iWyvElsuCqOVhPWGrzYv9uTbfntU0z7zZrck1mXje8n1aaMX7/GyYwoTQD3GxuGmzIlUuMf04ijlfUP5Ch/pEs7iFOzrmy2x1xKRHbPzfUzooumFtNb4YaYxY2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712672608; c=relaxed/simple;
	bh=U+fSL+crM3DUO4XnzoIw0Ixh7hJNaxD9IBK0PFblPFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPu1+aPucnJequ5BfS9hc3FwMCtfrKSIsxPmN6XAIJw1e799EofKpMZLPWOBhOi27wscQmzM4JCJPKPPCk3jdN6jIKyGM0eLMsMd8PuH8ecthZf/iiiK3UqlgG4umc2B4uBNXea44yIfUSis2cD3ljIV1nHtDH20OXzvC0Of66A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 12EC468BEB; Tue,  9 Apr 2024 16:23:24 +0200 (CEST)
Date: Tue, 9 Apr 2024 16:23:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sven <dm-devel@schwermer.no>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
Subject: Re: dm-init/dm-verity: Data device lookup failed
Message-ID: <20240409142323.GA22617@lst.de>
References: <b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 09, 2024 at 01:33:13PM +0200, Sven wrote:
> Hi,
>
> I'm using dm-init to set up a dm-verity rootfs, i.e. my kernel command line 
> includes:
>
> root=/dev/dm-0
> dm-mod.waitfor=/dev/mmcblk0p3
> dm-mod.create="rootfs,,0,ro,0 614400 verity 1 /dev/mmcblk0p3 /dev/mmcblk0p3 
> 1024 4096 307200 76801 sha256 HASH HASH"
>
> Occasionally, my device refuses to boot with the following errors:
>
> device-mapper: table: 254:0: verity: Data device lookup failed (-ENXIO)
> device-mapper: ioctl: error adding target to table
>
> There appears to be a race condition somewhere. This problem started to 
> appear when updating from kernel version 5.15.148 to 6.6.22. Looking at the 
> changes between the versions, this patch seems relevant: 
> https://lore.kernel.org/all/20230531125535.676098-19-hch@lst.de/
>
> It appears that early_lookup_bdev in dm_init_init would succeed even if the 
> partition block device is not there yet but the parent block device is. 
> Could that explain why the subsequent device lookup for the partition 
> fails?

-ENXIO isn't really an error that should come from the early block
device lookup.  On the other hand mmc_blk_open can return -ENXIO
and block device open return values end up here.  Can you throw
a printk or trace probe of your choice into mmc_blk_open to see if
that's the culprit?

