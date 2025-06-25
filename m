Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8109723AD;
	Wed, 25 Jun 2025 06:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832198; cv=none; b=nyXP1Ey01XmS/R6WMWnEMuIPLnhTqN38lckTGElYvmzk8kXGBrjtpv541KmXKAQW5+f/9ionixNzfTxyWcFnRYQTpgLh2p9QJ1hj+ga45BMBve82qtIPulJ2cMENiklEWShN5NmR9iwX8MoDgP6wR8qClLbH1Tcn6YTquxIN5h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832198; c=relaxed/simple;
	bh=7TRycBsPvUgHgY02m8aQShUfMB9Nfj334qF1+1Uk7q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcDRhw1nqf1YOKvk0OqvH4i4MwBb3b7fJJqD8bTzCbfqCJfFIk4TObe0x4B/MtYAqgwp8IlJ55cl+1ukTr0xrvKpkBr/wdcDbYiUklLL8/sXmoMeOrVtu/E1QFuFeoKyq59mb2161t2eVjKKyMLtpyHarDuoLuMzspGaAkSXT3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tNiZDiXm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tNiZDiXm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7TRycBsPvUgHgY02m8aQShUfMB9Nfj334qF1+1Uk7q8=; b=tNiZDiXmKmt78ttIujWAICMznt
	L8+g3dFldnhejKZEp82HpaDuLTYU+gt2JdlnsUWgtFtcDQd5jIW/AHV1IJGafs6pIi9SnZi5bYFJ8
	EJCEI40MDajKcr2bYQNt98PgS7Rr+1ZpcUiLgzYzHHgypCTpoIYtOjmEhD0Ya0UZsvyRjuYyMl8TA
	T6l/O3z2skh0kajIu+GB6Oq4XS0tJ98Dl3KbQvuHKdTrChJO/SGS1UI54dJpGxAOgI22u/jTiznT3
	7KIdkSHdhrha7SSUSXYGpoSw/o/e47ERPnCrT3D70+5MnhhR9oDeAD2iSBDIn7ZTYLbJJMvr8rb6b
	ooivpNBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uUJQz-00000007e4F-0UmQ;
	Wed, 25 Jun 2025 06:16:37 +0000
Date: Tue, 24 Jun 2025 23:16:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 4/4] dm: Check for forbidden splitting of zone write
 operations
Message-ID: <aFuURUCOC_xfDc2U@infradead.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
 <20250625055908.456235-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625055908.456235-5-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Ah, I guess that addressed my comment for patch 2..

