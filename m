Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BF9218AD2
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 10:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744194716; cv=none; b=LEm0OwAy+0eo//YqeZHkaShwvm/2nNSb3KHwiAEkk6pWa8ZVMgDsze1tbZ7STSYFQezWhiKvRkXKwNShSch0BQ0gDSdoJcgccVJETyh4BoJA3udGJAOd8yYNEJqSu1spWwptmAaldiuL71SMfXgv+4hK6kpRA8PunYCXqRn9XG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744194716; c=relaxed/simple;
	bh=Cup2omxbIn9Mcn/SeiY1fFGTnuLvFypmMrtA0yKrEqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KGA7H6lFDqYaiLhKHbiQJsbdRIDwuSy2CsJ+aumGhtc59JEnFBq/l7YhKphsoWFUCsSEcU/QiBRhES7maNggSJvO1e3KtpmWyB6N0C7aRaJmXyjQqpQuU/WEZ2A9VkMVV3dD469FkGdEL/F/SDXvuejcfTGvH8Vbf9smBAMWEJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7E1E268CFE; Wed,  9 Apr 2025 12:31:48 +0200 (CEST)
Date: Wed, 9 Apr 2025 12:31:48 +0200
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
Subject: Re: [RFC PATCH -next v3 01/10] block: introduce
 BLK_FEAT_WRITE_ZEROES_UNMAP to queue limits features
Message-ID: <20250409103148.GA4950@lst.de>
References: <20250318073545.3518707-1-yi.zhang@huaweicloud.com> <20250318073545.3518707-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318073545.3518707-2-yi.zhang@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 18, 2025 at 03:35:36PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Currently, disks primarily implement the write zeroes command (aka
> REQ_OP_WRITE_ZEROES) through two mechanisms: the first involves
> physically writing zeros to the disk media (e.g., HDDs), while the
> second performs an unmap operation on the logical blocks, effectively
> putting them into a deallocated state (e.g., SSDs). The first method is
> generally slow, while the second method is typically very fast.
> 
> For example, on certain NVMe SSDs that support NVME_NS_DEAC, submitting
> REQ_OP_WRITE_ZEROES requests with the NVME_WZ_DEAC bit can accelerate
> the write zeros operation by placing disk blocks into

Note that this is a can, not a must.  The NVMe definition of Write
Zeroes is unfortunately pretty stupid.

> +		[RO] Devices that explicitly support the unmap write zeroes
> +		operation in which a single write zeroes request with the unmap
> +		bit set to zero out the range of contiguous blocks on storage
> +		by freeing blocks, rather than writing physical zeroes to the
> +		media.

This is not actually guaranteed for nvme or scsi.

