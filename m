Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4FD1F95A;
	Thu,  2 May 2024 05:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714628317; cv=none; b=QUGZS4CIHEkbgQxNXfP/IXJIX7eHa3Qdgy3F2nYNuDm2ErIJLiMtkgLuzhAk8SK+2iw11fcAsVBfjn5i9QejIgQ4pFEZO0tTpVdnzkitVYnqw307Q+fWxhHe4gbQ3mbgqFgO2s4U1AbfFpazMzeRh552OmdwzZp17YWm0t/54fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714628317; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIKAHXkPRKARZEcKjrwgAtDDpiJ8zxrrlPeXJW4bRuQmirP1VKm25ri8UIDhHHO+xi5V4l/v7JDmQPMJuHOau7Fq/1Tq+6M+tJNJo3iawCltHF6JA/NM1NtIS1y8c5ANxe5d5Cqoaw2tavu24NzCaCGTAeyV2M0KEsPCRKWirxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JwR439+G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JwR439+G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JwR439+Gx2ZJUh1fLllPXvZWK8
	JctMFI5Ppa9UY8b5PyRQSsaKh9E3U3e27cmNBWLLmckf+ggAttmpuNqeol+cPUAfSBIeBCygPV223
	pHi2y0E8Kyqfj2xdAB0WfyM6iFrKS8d5Xh2rJVAusmESzwu0l8jIB76o7kDrH4gZp4PHRXWgdeNNN
	BlprHDE4x1VE3g1VA1PwaD4XfRHTrFxfR3UdnxYJ5CSI5jZTSC+9YZ0e9SwHdCUaeatpkURHHZFgw
	hjGEGQZwZEko1y/wm2pRbGV8tJqvdWNLHH9jvjqZZ+yGxshldmrV6TeC3rYDbZyokjik1iZ12/hUb
	iewiKrBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s2P9O-0000000BXma-3vgV;
	Thu, 02 May 2024 05:38:34 +0000
Date: Wed, 1 May 2024 22:38:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 07/14] block: Do not remove zone write plugs still in
 use
Message-ID: <ZjMm2u6mW2OEo1wO@infradead.org>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-8-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501110907.96950-8-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
