Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E1915E96
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 03:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749612589; cv=none; b=aVOSGWRL8zUhBpA3+4nY1ZhLvSwaKKYI+Kb+WrVvvwnLTlpwb1vqX7W7oT1W0UNbipX/JYGt5pwcrGn8w8z2E2RbtIjfNKuYoVJuBCLeZfVDcy2lpP+q34zLRub351QbZdSmemeSdWDmTQPJuKIrdSVsuJWOjoXhBCZ2uBMLwqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749612589; c=relaxed/simple;
	bh=DjCG7g3BwGNbtfVTti9LGnthnA3mnvZLeNvVG22rYnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a30tT7FXdNbLhO9o/b3XIdK9lX4VU8I/Ts4dDjh2q/dlsda7htg9/aTxKmm/NiCR2DvVpjM/IofR7hKN6dBgckDtZn5jI+jr6gno2UG1lEzE8GUEzucMkpFTdPvhSyi0XPogSaC708Oz0Z++QfLOEMNaW1lm/1QRVqQccUiR/+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eESh/9mm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eESh/9mm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DjCG7g3BwGNbtfVTti9LGnthnA3mnvZLeNvVG22rYnM=; b=eESh/9mmp9WQC4V0hTmwxOH2om
	Np0bc/qvytbCJhaYCK/cUYd8mHUfIO7LSgJqTjw391D4oxSaBjHvjDazwkqcuU3ZRVj+ma3q1ecfW
	GofETauJJcpQUsL3Am/3gpZdUlxHQsKq4EERhtS1zy3Soa6WJUNRia7J6YfRCGV8oUXmjiWZhmVf/
	SP4GyePSJLNIrZ3DxACKYHLPKzIaGnFYrcl5Vm7t2eUVPazRoTBUmwn5/QHnC4m5tOxTQvkhdj4N0
	sRxRm0eWmD5BWD71YvkhnSMmf7dtJRfnXIzGpvoe+GFqhmlKL+LEi9cswiu6WgSvLjqXDWfCC+/CT
	jsosjilQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPC9s-00000008jtE-20hb;
	Wed, 11 Jun 2025 03:29:48 +0000
Date: Tue, 10 Jun 2025 20:29:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm: Simplify dm_io_complete()
Message-ID: <aEj4LI1KZtzJ-9Mr@infradead.org>
References: <20250611011457.92309-1-dlemoal@kernel.org>
 <20250611011457.92309-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611011457.92309-3-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Not sure if there is much of a point in second guessing the compiler
with the explicit inline statement (t'll probably inline anyway),
but the logic change looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
