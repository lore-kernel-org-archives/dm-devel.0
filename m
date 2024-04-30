Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32403143744;
	Tue, 30 Apr 2024 15:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491279; cv=none; b=fSOzJ3BxecNIQcgvAnv+KXF/zzuBX82cxIRSIytrXnfI57eLhjRQOJf6cpThgqY5yif7Vwl6Tg1YPmtrUI4HdMkwSIuJouN5Syo0lXfwHiGKXSlcGvEWJZteu0OEZEyxX4Jcn9TRXEuPIsn2vVlvgvkjKxVj9jxFHX3H8My2CqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491279; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c47xgMWf1gpIPF6XscJ3tTobynL9symKOhr8Z8U36JFBKcdS1maYO4PKrYNoHA1Txq5/D+KRBBIXFDEvurFuVAp4ArUPoOxj013kBrIGjgc0e0AriPDCkn+97ZMO4OmMG1d1b07fXmtf/k5Vrm9vH1+XfzTTH6d9b/5xL653r9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FnkcjLr0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FnkcjLr0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FnkcjLr0sTpQawz8JippM0YAXN
	VNBgYczXy0cjvOW2v4kfHxeIAxfnTDRgOtMBLJcy7yNaZM5XiqLmYCke97UM45OdMSkxEMBDiw6CP
	789qhj6MhpQ7h0IWleSEYwDGmIXzbeW99oKtWJMvhSVd6fqUVdkut4qBQirnlk6JHkKELin+pfnyS
	CxPJXuAReNrMvyMAj/CNU/qp5555kd6GWGRFGtyAZhYpTi3eAYCQbvCWiSUI5oC3ZH9YW8cYWlFEG
	6pTXmIrFAso+dHss40OHQgLOnYoIY79b1Sw8+kDCF1idJ3pxkhcAG+Jm9MA22bAt6ZM6KAGyYfDgW
	Zmvl4U+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pV6-0000000747J-3N5F;
	Tue, 30 Apr 2024 15:34:36 +0000
Date: Tue, 30 Apr 2024 08:34:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 09/13] block: Fix handling of non-empty flush write
 requests to zones
Message-ID: <ZjEPjH0CHN2TE91m@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-10-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-10-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
