Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EED25522B
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 10:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744194852; cv=none; b=WQXkoiPL4BprRU0mjmzHex6wc5Gq/3nxsewEq2jYYQ3C53OqhKXCqgo0ZtIr3Zf5gR9yM+uSzzACVP8Gx/XVB30Mj1RfS2PNMGoDb9IbRwIJF73W8zT85FhHUSMt8pNVbrJaLWniep09AyRHo3O9TuxjAVV/vy33SCvzRJWXqxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744194852; c=relaxed/simple;
	bh=DobfG+3gV1Rkv7VQbq130VP7/54eKGQY8yYdBas+qoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qG4R05eAHy1WF7uITuashv0PX2EP/my23G4aMJ7gRGk+D9jzZ2O7H/pPFZo2ZPhhHmUHZbwUrFtg2MGJaM3MqsDO52pFdnfmNTGNkasqBVfVJZmALiPBnhLFCFvd4IylC7bIfjty9q9P3mMr7sV4cd3JVPbTinKN6fTNqXany8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 42E1368AA6; Wed,  9 Apr 2025 12:34:05 +0200 (CEST)
Date: Wed, 9 Apr 2025 12:34:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
	tytso@mit.edu, djwong@kernel.org, john.g.garry@oracle.com,
	bmarzins@redhat.com, chaitanyak@nvidia.com,
	shinichiro.kawasaki@wdc.com, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [RFC PATCH -next v3 04/10] nvmet: set WZDS and DRB if device
 supports BLK_FEAT_WRITE_ZEROES_UNMAP
Message-ID: <20250409103405.GB4950@lst.de>
References: <20250318073545.3518707-1-yi.zhang@huaweicloud.com> <20250318073545.3518707-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318073545.3518707-5-yi.zhang@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 18, 2025 at 03:35:39PM +0800, Zhang Yi wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 5d280c7fba65..836738ab1fa6 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1344,6 +1344,11 @@ static inline unsigned int bdev_write_zeroes_sectors(struct block_device *bdev)
>  	return bdev_limits(bdev)->max_write_zeroes_sectors;
>  }
>  
> +static inline bool bdev_unmap_write_zeroes(struct block_device *bdev)
> +{
> +	return bdev_limits(bdev)->features & BLK_FEAT_WRITE_ZEROES_UNMAP;

This helper has an odd name. In doubt stick to the name of the flag
instead of reordering the words.

Also no core block code should be added in an nvmet patch, this needs
to go into the first patch.
