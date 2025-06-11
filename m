Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390092253F3
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 06:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749622154; cv=none; b=S2GkpyDUOyGURR3I10Kp2DYnnqR+RA0f2IwavtJKLKKsAsOaQrD8UEJa9wD9mIg4F0Vu20ksA5dv0hzcE+OxmLusBfk83q7vt7uS3gbuSbgpQIhHRNifIispZvLV3nzaJNQa7uprRKPmspEIJdDRnSzMy05Hz69ta/TfSnePuUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749622154; c=relaxed/simple;
	bh=8sMku4WxahX1FuZlVCqNoL8+EPGRsyZn1w622Xjs6Cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJUJv56jJyu2dskYfDlIXCTE8uM0UJTD9iTUIU+tYSzto5nw30IDbgwltnytQ1P4TwtDhPaFEh3jtxuO5BlaOt35RbvRu7Kl8UxWwEEA8RQaADlnYoWUtK8maBcEDEaKFqUd0KIGttw/J1/oiYYCzvdpL8bvo7hoNLh2oVxuceY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9CE2368AA6; Wed, 11 Jun 2025 08:09:00 +0200 (CEST)
Date: Wed, 11 Jun 2025 08:09:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
	tytso@mit.edu, djwong@kernel.org, john.g.garry@oracle.com,
	bmarzins@redhat.com, chaitanyak@nvidia.com,
	shinichiro.kawasaki@wdc.com, brauner@kernel.org,
	martin.petersen@oracle.com, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 01/10] block: introduce BLK_FEAT_WRITE_ZEROES_UNMAP to
 queue limits features
Message-ID: <20250611060900.GA4613@lst.de>
References: <20250604020850.1304633-1-yi.zhang@huaweicloud.com> <20250604020850.1304633-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604020850.1304633-2-yi.zhang@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 04, 2025 at 10:08:41AM +0800, Zhang Yi wrote:
> +static ssize_t queue_write_zeroes_unmap_show(struct gendisk *disk, char *page)

..

> +static int queue_write_zeroes_unmap_store(struct gendisk *disk,
> +		const char *page, size_t count, struct queue_limits *lim)

We're probably getting close to wanting macros for the sysfs
flags, similar to the one for the features (QUEUE_SYSFS_FEATURE).

No need to do this now, just thinking along.

> +/* supports unmap write zeroes command */
> +#define BLK_FEAT_WRITE_ZEROES_UNMAP	((__force blk_features_t)(1u << 17))


Should this be exposed through sysfs as a read-only value?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
