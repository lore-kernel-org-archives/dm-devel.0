Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C97FF9CC;
	Sat,  1 Jun 2024 05:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717219580; cv=none; b=EuqWVmIgf2HJSIs4pom5qRmnveI4AWk8aO2Esox+SXomdssKyssywsqY1JBz+dxvWM2fphv11Yq8ZBjOEMadgsaFz0isuqyRVpTKiJZDS6aEknWXwvzbRfQMSgc3G5uO8hh5JaxwlQ9SHrv21xqxMywsBFz0yY1jU+DMZB8ii8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717219580; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMs4CUy+0/oVCV4qjxBgnghVg8OEA0ZdUVTSNuSGwgGGTg889JfGcWxiKxwqszdmeyektyHne6vqnlfUTNLLLusXt9gNIz4d6vVZTzqP2s1PuhnQMUeNZU7TAMOSxbtVOT4MOr7NVmBoRrEgIVdSda5loCPr7iUfR+Wh4MuamYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xAr4IgbY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xAr4IgbY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xAr4IgbYUKZRHUhstkJYinwCwh
	MO1jfkaPhk7DTzD0rsEdUI6fDworz91Z6GlO5zTbQcv94EWpTclEtq/odG1AoUmF0CCWJOUYdaItq
	KCqT21/9ifqI92jujGrEO3IzYeZrcc1z5EBFeoGSXep+2/uQzUv+q+1vWaW5QiC0NP35KIz89h35W
	YbCk43+immdlFmxWUwpYTkv+gjCS4hOQ829uwIG4FGqDdPB1/7gT7Z1XKp8FRC8KhZ4qoCM+2Lc2t
	+rND+FLSBE1KAc3uBBrfdZPXQN38LvuoSzFJklaW4mw4uiTXG8xtneI2P7MrpfY6ofChCvQvbCFhJ
	T16v9ybg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDHFy-0000000C0Sc-49hJ;
	Sat, 01 Jun 2024 05:26:18 +0000
Date: Fri, 31 May 2024 22:26:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/4] block: Fix validation of zoned device with a runt
 zone
Message-ID: <Zlqw-lYXozk0XcJA@infradead.org>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530054035.491497-3-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
