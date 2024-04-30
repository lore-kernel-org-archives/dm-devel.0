Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EB3143753;
	Tue, 30 Apr 2024 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491352; cv=none; b=juE7DR9dTMlfm66wE7jrdjPNkly4OOIOyQgKdN9WvN+EeUSW7oLRbcpDt5ksZqDd0r2lShIwPTqoPH1asQvCJauORnFOQyCkDffa1BxNRaSvG3QSloFBR+XYbwHkLSfr+RT5ekwjprPlv7+APLcz3fA5mTBWRKvMzuboQAfWxT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491352; c=relaxed/simple;
	bh=JROjRF5DtmZnSXgsBlpUb91anxCnSu1CUrcqNhbf36M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agE+Vm9dWN6K952tJSSnv6iUTmPo/4pLMwLiIuu8K6KYC1qa63aUJBUPVPb0nPn3TPJPdZyTJ9rJaxyQsZsbr6q/bkMh2L+Y+ul7bNvW6SiCTeBMNj4YvGyUCsI69yVLV46UVXDKjFsedMSiReq8BJ5THEnqUceMxdw1uExmVs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zdHD/itA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zdHD/itA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JROjRF5DtmZnSXgsBlpUb91anxCnSu1CUrcqNhbf36M=; b=zdHD/itAucCyb2+kjeWLQ7L0vs
	MrHNHDgrn6kxxpy1Vk56I03DDj4QGBTEba6FRgIJtv43C0ieYTTW1xNM9U2IUmjU7VsQHPmhaU9R5
	JovweuZYySSCtBNpHqEfs2LUojpaQj2QYgD4OkS1FyK9eBv+lgLRUAEyOZvROkrBh/QlS+/lSX7gr
	P0ddDL+pByRplus4OS+wwNi3GemFKpIt/NbHH0V6+AYY93pGyOqMjPlYY4SoWB5O7m0GA/Qpd2J3i
	BDzRm2NeKEyE6CXFm0Jg2mTP796UKXhcVu7FnEGv0t2UMLuEOFtNL4Fh/3wJXoFYTptJGn3Z2Fb+P
	vk9KeKaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pWI-000000074Pd-0vVo;
	Tue, 30 Apr 2024 15:35:50 +0000
Date: Tue, 30 Apr 2024 08:35:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 10/13] block: Improve blk_zone_write_plug_bio_merged()
Message-ID: <ZjEP1mA7TajR7DdI@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-11-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-11-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 30, 2024 at 09:51:28PM +0900, Damien Le Moal wrote:
> Improve blk_zone_write_plug_bio_merged() to check that we succefully get
> a reference on the zone write plugi of the merged BIO, as expected since

s/plug/plug/ ?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
