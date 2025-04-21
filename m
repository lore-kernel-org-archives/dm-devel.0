Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400A4264624;
	Mon, 21 Apr 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745236808; cv=none; b=f4KUYsPGvjFYq7Iszrzra+rVExufRmNwfcVuXGTnwTkB+Dvr3U1KC35nHlZmRkFQIIdhNG9945sinNOc/5EO7cigG06nR7/T1hk48X/SyyFtpR+xdQ39r39ppWsCoEeZap9GiT8ZmH5zyyA67TKvVixw6VOeubyzoAET9gypQBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745236808; c=relaxed/simple;
	bh=CzHQBIEgY5H8jlzmoQRh9h6aCBHyrFdLlDjnHcZx2ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HR4G6j/U8bKpnudfg5TJah3yVGQCrbYjWY8N6xd6Rtrn5/SNGz/mMDcAhEdU8zNC6Php0VK1zR+r+vZdOWZuir4kYQ4E9DZUPIkLgrjDMpUvB3eqq1d5s2qMKJpXzso5oP8g71EW04Cg+cUDayXOe9oL8lJ4k7fTb3v4JQMyNBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2skvae9h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2skvae9h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IXi712kwKHh2MZzmtEd2555xtxCOXdWziL8U8Y8S3gY=; b=2skvae9hTmNxd34o4WDlXLoFTY
	yxjo6ALjtgU3qyLRbK7EkhNcafN9cnJbkdBy21PH2WFNR+N/sIIpJyt4cSDx1nlmo2+l/HgpcDAy5
	ZL4I7cwKJTPxCzaIs3gUGhDaWq64X+GAG1RzXSbglfSMnp49oFc48JMWo7CRKTmlTI5oyAIfosfy4
	WGygiXCJHOUHPT1LJWm9Fx2YCZyYbBxRd9FZBmeIQTmKssfNLa0Mo6KkLNMAAHzw0yMbO/zIOZadU
	7Y55NlRLPQfpCjYlo31EGJ9RWSlpzdna9gq6kC0kX6yLroKWvfUe9ByKPgyLGKTgEkGT5D4e03+XA
	VDuGgTRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u6pob-00000004EW8-1FBN;
	Mon, 21 Apr 2025 11:59:57 +0000
Date: Mon, 21 Apr 2025 04:59:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, xni@redhat.com, agk@redhat.com, snitzer@kernel.org,
	mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	nadav.amit@gmail.com, ubizjak@gmail.com, cl@linux.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH v2 1/5] block: cleanup and export bdev IO inflight APIs
Message-ID: <aAYzPYGR_eF7qveO@infradead.org>
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
 <20250418010941.667138-2-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418010941.667138-2-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 18, 2025 at 09:09:37AM +0800, Yu Kuai wrote:
> - remove unused blk_mq_in_flight

That should probably be a separate patch.

> - rename blk_mq_in_flight_rw to blk_mq_count_in_driver_rw, to distinguish
>   from bdev_count_inflight_rw.

I'm not sure why this is needed or related, or even what additional
distinction is added here.

> -
> -void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
> -		unsigned int inflight[2])
> +void blk_mq_count_in_driver_rw(struct request_queue *q,
> +			       struct block_device *part,
> +			       unsigned int inflight[2])

Any reason to move away from two tab indents for the prototype
continuations in various places in this patch?

> + * Noted, for rq-based block device, use blk_mq_count_in_driver_rw() to get the
> + * number of requests issued to driver.

I'd just change this helper to call blk_mq_count_in_driver_rw for
blk-mq devices and remove the conditional from the sysfs code instead.
That gives us a much more robust and easier to understand API.

> +void bdev_count_inflight_rw(struct block_device *bdev, unsigned int inflight[2]);

Overly long line.

> +static inline unsigned int bdev_count_inflight(struct block_device *bdev)
> +{
> +	unsigned int inflight[2];
> +
> +	bdev_count_inflight_rw(bdev, inflight);
> +
> +	return inflight[0] + inflight[1];
> +}
>  #endif /* _LINUX_PART_STAT_H */

Maybe keep this inside of block as it should not not be used by
drivers?  Also the reimplementation should probably be a separate
patch from the public API change and exporting.

