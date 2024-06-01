Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0C210A0A;
	Sat,  1 Jun 2024 05:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717219781; cv=none; b=PfOwYhp1WCCvW/Zv1ZLpVTEwl8xhO3Jdv6fNFapFkRbq7DUpgwnor7l61vM4OeorFq9egMS169abNLUF+V+xC3z3I24lHa+tKgkLG7WsgTdt7lM24ibfCPpud6Tu+AbZvJU3bBlRT3dhpAi5Dpvw73ClPKokouiOtlALjz4LUuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717219781; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oq9G7iE7JMNNsV7fFqSx+t0NzatwvB+/RQsgj75ioh0IISC2w970uMHXP+3ZpV1/AnIrv4DYJp6k6bVycRMYbt5mncLDOknR8iTZLezmXc1SyG7rlyxH16r26fWK6CGIU8gvSe0F7Qb2y/zgmXlELX6iL4XNuSdU8AFm/yH1lRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hfodGE0a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hfodGE0a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hfodGE0aVAejQoP/jafERjYw+o
	uXvZDznDqCSKIOIBLHc0aDG/6i0q97UvRWj/QdSqWA2wuExHN7QG+QYWaQuLY0s7S150eAwMdpEZH
	CWAvhFiddeALaCm+iV+a/vHmKOiP1bZQ5AiatnNl4Jiyb8bwoztU+yCIewCfieecBn+GzhVh4vVk7
	xWdWH0EcsvNJW6cMB9wbtV1Kfkgux7c8IibCcZf3MjS/mfFLUzif+GnmGfi+HVyTsoICpbfz51k+B
	4FAGeHzBfQGTs/Nu+xeqFUwhnyh5ERyNVY4XhOXnIVMb4V7+n2HNQhcGX5HiahlG8ld3Z2zW1y1L0
	uUODTaBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDHJE-0000000C0c1-1ndn;
	Sat, 01 Jun 2024 05:29:40 +0000
Date: Fri, 31 May 2024 22:29:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] dm: Improve zone resource limits handling
Message-ID: <ZlqxxAbPOVRzHDLe@infradead.org>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530054035.491497-5-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
