Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FE528E8;
	Fri,  4 Apr 2025 09:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743758991; cv=none; b=HrCGBl2SEUpiE9N5PNEIpk+PBHfnRISWAChH5AMygUIHDFwkMXsgI95HwusOD2wiFIa1/cfRMkPKYW+DFBoP6wRix9j3r341MpSaWJ2Jg7FB0jJnEp05caIotrOXYbRqd4kF2bOCtBa6lHqGs623efRCUNAlwlJRzjtN7dmA9mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743758991; c=relaxed/simple;
	bh=ik1i71QYf3JPG65boEzuUFsCyr5fouGAXXX3YLJi7B4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6wluVm3suoXcURaH2QizUYvaeGDVxf/t4qg2ZxiExLq9Aeucy8TFcniSfueo8dLv7neXD91S2wqr5u5he+I6XMQPdsM9Am54OYiKTZzLBlFeHNp4g24tRnQRYHQKRi5jTxAOZTp94pkXnyokkzP6DwgRhPdJarsSYxDvfOtMWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yZd0gP3M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yZd0gP3M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=29rwdADjqHRGeAdMUDh8+xeUJnzqZ9cQBhBrtI11k9Y=; b=yZd0gP3MeQXwHRTDp3LlV9IF2d
	cKYUXkxP3qFf1RsYSvn9vMEPWhLcsiy+znHEtiVci3LyFZnjKOObrSS3ttaAEm6WZP7OAJfK65dqM
	MF4Lfa6k+ztucqGH9kvPhllhZgMohmY60EcrLeil+eUfhPKGSt0l9PlPXaAArHD5EwPdjv8w+FN10
	0nTVn2oJBFw4/8MFAI8E2oONcZnN1v4CEPibVDsrsQW2FpX1i74AIhUFDmBjIPUi6jDzNQdgc0X4D
	mKzifzW9H1+s1z4CWH1Kl92hFvyXmkek/SLWO/G9UzW/BoroTaAlD9HmklbkYfK8aK/JZKTv0Lfuu
	xr0aii2A==;
Received: from [185.236.188.25] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u0dMr-0000000BHPO-45mp;
	Fri, 04 Apr 2025 09:29:42 +0000
Date: Fri, 4 Apr 2025 11:29:37 +0200
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, axboe@kernel.dk,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, yukuai3@huawei.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH RFC v2 02/14] md/md-bitmap: pass discard information to
 bitmap_{start, end}write
Message-ID: <Z--mgctoFieWvuM0@infradead.org>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
 <20250328060853.4124527-3-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328060853.4124527-3-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  	int (*startwrite)(struct mddev *mddev, sector_t offset,
> -			  unsigned long sectors);
> +			  unsigned long sectors, bool is_discard);
>  	void (*endwrite)(struct mddev *mddev, sector_t offset,
> -			 unsigned long sectors);
> +			 unsigned long sectors, bool is_discard);

a bool discard is not a very good interface.  I'd expect an op enum or a set
of flag to properly describe it.

But is start/end write really the right interface for discard or should it
have it's own set of ops?

