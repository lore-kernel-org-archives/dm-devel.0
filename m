Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E0178C91;
	Tue, 22 Apr 2025 06:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745302320; cv=none; b=aRdwBMXoLAzOxd9a+sl/gcX6kH//tPRLdb+VgYYfPgy30MnmYpK7c7ROyw6FIJ5aaK/jbj3nJsi+8ZMTkV6aTeDXzsSy+foXhfnYvUIS1iNI1hojlMha2I5jofPRiSghuEz5X6eWjnGOhe88OQkokO16+sKcqh2VJa/L44syATs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745302320; c=relaxed/simple;
	bh=3U6SSAwI++1mMarBQrCnXaUsz8plHo4CysXh50ykFH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lj6MWyIFkyqxZWS7FBFjkF+LyJlh4RMwQ2O1fbEDKweuJYA0xuPt9VQqg1ruyJK0u+rQb/y680fvP5gWTCAb+Sg6VnH8QyBPzM5k4KRB0xjpqp2vvi5mtxGYMtSY16LFHkDb6ZuNZ0cvJkUqE7lCLMa+gOjuTaznej6qH8yPWtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IfJgyzCR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IfJgyzCR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=i9IDz0JyHUWXPtjTKZlN6b5bZEngPXaM8Z/wmtOSlTc=; b=IfJgyzCRY3hexpQwQo3ixEoWxK
	/1LEeNL6/goAyEsYXJZAbBev1+aHqotUrm7a7BhLKJf3iUSS/ieq+qXhNpOo2p+/fwqN9oiMUjFmY
	zn4owcYOy9LwGIeVYYx0PQ4oD6vNIAgW+N19UTNCjhic8NNYpSzw2L8qbbbxIhQ9HgBbaCIWa9MYj
	h2f6u6/TMpt53ZqgT3xrq5Mjp8EdM7XDk473nrJ+b2fShwDOTd5+5MQf074BUnVG7Scdug5X6PoW1
	5UsUEJP4sVyq2G5YWvSt/NUNAFVYsXf4x5RAUDS6aoATjL+ptGY2s9dLcBPFCtO55FvEl4Ea4G/G3
	t7GpDpCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u76rH-00000005vDV-1Qlj;
	Tue, 22 Apr 2025 06:11:51 +0000
Date: Mon, 21 Apr 2025 23:11:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, xni@redhat.com,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	nadav.amit@gmail.com, ubizjak@gmail.com, cl@linux.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v2 1/5] block: cleanup and export bdev IO inflight APIs
Message-ID: <aAczJzofvwrCUUNa@infradead.org>
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
 <20250418010941.667138-2-yukuai1@huaweicloud.com>
 <aAYzPYGR_eF7qveO@infradead.org>
 <f01cb2d7-d69c-1565-d3e4-09c4b70856f6@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f01cb2d7-d69c-1565-d3e4-09c4b70856f6@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 21, 2025 at 09:13:57PM +0800, Yu Kuai wrote:
> > I'm not sure why this is needed or related, or even what additional
> > distinction is added here.
> 
> Because for rq-based device, there are two different stage,
> blk_account_io_start() while allocating new rq, and
> blk_mq_start_request() while issuing the rq to driver.
> 
> When will we think the reqeust is inflight? For iostat, my anser is the
> former one, because rq->start_time_ns is set here as well. And noted in
> iostats api diskstats_show（/proc/diskstats) and part_stat_show
> (/sys/block/sda/stat), inflight is get by part_in_flight, which is
> different from disk sysfs api(/sys/block/sda/inflight).

Trying to express this in a not very obvious function name isn't
going to work very well.  Documenting your findings in comments is
much better.

> > 
> > I'd just change this helper to call blk_mq_count_in_driver_rw for
> > blk-mq devices and remove the conditional from the sysfs code instead.
> > That gives us a much more robust and easier to understand API.
> 
> Ok, and another separate patch, right?

Yes.

