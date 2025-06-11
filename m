Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B866BFCE
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 03:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749612500; cv=none; b=K2m6BvoKIrRdsVX1va3j5zdCTb+s4Hqhu8lLtHP+zt6MzTOjqxeW4dtY4KMNkOZkfltTnTgZ7e7GGPZrGCg+84Kgr6l/4XzcQvo7GHhFxvPzHUlmSxjYltbP7/pndSAtbeFgAbdgaG5AhflF8q9O+MpUtseJtr8+4BNr44WD6lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749612500; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qd3F+Lcp4xM+3xhoduiZesc66O0ePealaddGhPWH5ere2BP2gRjZ6nj2eNK4x2PUa8/EZXxjw3DyCreIg/jVZZ2F9UwSmg1y7DOKLuskC/1tSX4PnRG53tAGGvDJNMGYkbMGwR3J2FD35mD9vX8m6sDSUh+iuxDAhKJEMoCSZNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ygSUmC4N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ygSUmC4N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ygSUmC4N1w1zZDKVn2pld7GDF9
	aaPEMGCavV5BRdavV4ww7YbZKp8EcA/K7ivENSk884qH9N4vTJqKkyOzBKTHxOW1N6Nydq1SCWKY/
	p8ARWmpLNVVtTZtLbQltET+wns/P472Hf3t+xhGoy5aXckS5QQ6yzvkHFt7m/vmYfp/gKZj2+HeFg
	g4KomOGgXr4krqlzzY70gzuFS9IibBy06/btshfzj5MrNXjqePjWTm+OVgLEbyiSpRHQttLS4HVZB
	AQbxNZc8kspgcpj/h6Y6vm0YYQ7ee+NklgKFILVdx/16bRoX8uOak/FoeHuUq55aM5eHEvow2uolz
	4GAebIlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPC8Q-00000008jn4-00XZ;
	Wed, 11 Jun 2025 03:28:18 +0000
Date: Tue, 10 Jun 2025 20:28:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm: dm-crypt: Prevent splitting of emulated zone
 append operations
Message-ID: <aEj30bm46WDi3sFl@infradead.org>
References: <20250611011340.92226-1-dlemoal@kernel.org>
 <20250611011340.92226-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611011340.92226-2-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

