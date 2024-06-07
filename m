Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36991BC4E;
	Fri,  7 Jun 2024 04:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717736314; cv=none; b=m2xU1Z7zgi8ELCun1q2WdZYVAQ8DH/RPxRhH2/SA3r2lcQ93qEhqDP8CK939rzYvmdm38q6wMZwXEyqHMA2d4eMiSwjjI+JnxvUnyrUT4Rc+6LblarBOsnsAYVY+NBap4Ys5kt6kzJVxBEjpuKyekpYNaq10M557T1H4rfmMKUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717736314; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1EU2VEgmDuHwAh2hG5dQYfRlNarl+9952H6z9W1H7zAEWN7Jdhh7Zt0LmrjQI3fnJBAsqBdjtYD249VuhV8VstiS3l81w1u7krdHaR9ftbBI+WdGyoZRNg1eewdN3aQ2/6nf46/vYXE2/z0wecnasZnomIHEwOElRU9H1KMDi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c5xHZqSW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c5xHZqSW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=c5xHZqSW/Brkmp5acc7bowpjQH
	afYLUJDM8g6Bq8tFvtm6s4A0oqYWvlXqRkyHReb0ltIrnSWNvo0aJzdwcFXGmONjTpDKgfxSBuw+4
	jfPTzTkKdZi5v0kTCKF2IP7hc3c7FuPP6lJ7YVjlF9FakLDcp3Jy0QJxA4xI2dIgnQFN7whZUWkfR
	AMxbOteJ+1iKqLiiV0URwDIfCLEna72rfVx07+h4U9ma3WfZKTfwg/9tNMkiz0LIOt4QQPn/LNEsp
	9ctqyiMiMpt/Mt9B8+FSAL1nunQwvGZGwHYqUs9mjaoOE/0UjOfFyfFpQDbIpTQ8jH+2bRHOi1KH0
	m8FNpeHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFRgL-0000000CQph-3pEX;
	Fri, 07 Jun 2024 04:58:29 +0000
Date: Thu, 6 Jun 2024 21:58:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: Optimize disk zone resource cleanup
Message-ID: <ZmKTdZfIIsjnHxvs@infradead.org>
References: <20240607002126.104227-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607002126.104227-1-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

