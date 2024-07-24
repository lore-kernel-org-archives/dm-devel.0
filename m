Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBC11591F3;
	Wed, 24 Jul 2024 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721835266; cv=none; b=VqI+nYcMGocJScAlnWydnJyOfsGZ8krfg3M4SusqtBwCjvFMsjomnOtcj13J/8triZ/4LB71TmLq3qQNDA8JkYK5EwAnY2X1aq2ssCxubiTk0INRZIBXcP2PgWrJJSpdqLIljoP29BowkrXxbxfRCJFA+G1v7c0yLNE9iGOmYUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721835266; c=relaxed/simple;
	bh=reTeHReaUpywJP1N11sZ+Cc8+WxQSGN5YH7m+GATX9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D68rkeyS8EMcQzwc//gAUXUq/i+qxlzRwkp/ErclGivbuu3C3CRDlf4sEWQR0bjrEiboiGyB9BglgT5tXg2XZAuqEvyw8ny1H+icb2HNFniRwYY27jN5/xAHT1LNXNsL2LWRDmfpuQEIxmhIoF1m9IpZ96xLlpPvJRMHCeBEJZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VGiplkUo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VGiplkUo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=reTeHReaUpywJP1N11sZ+Cc8+WxQSGN5YH7m+GATX9Q=; b=VGiplkUoeihQjVzF7MFdeDmyic
	FHyM9Ru0kumLtPgVYtg30v+hIe0s9iAJuWUohib4F57+3A0w9aAl4Bw30yB0Chm+jQ6Bacml9Aiwr
	P1vxzNPIDI/hafQLgTy3EEhDdcUI4Uwf+k0gw9UcwSWxA+uttzLdkNK9n8szlgkoLrIly6UyZRbjP
	X4UhN8Z+dl9IVpAfdqJHF7dBQ14acE7Oy1VnEj2GB32yTaG1yhQTpI7lCBi7XFNE/+icAYBrsBlrT
	7Ow+2Mjxd9KQwgQP9+8kbs7N1SJt74yCFEh9zSrpF3l0we4HVQj2btIogNxoeWn3EZXrZWcM5RI8Y
	2AllJ/yA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sWe0W-0000000Fmck-2GlN;
	Wed, 24 Jul 2024 15:34:24 +0000
Date: Wed, 24 Jul 2024 08:34:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, Bryan Gurney <bgurney@redhat.com>
Subject: Re: [PATCH blktests v3] dm/002: add --retry option to dmsetup remove
 command
Message-ID: <ZqEfANvq-TQASjME@infradead.org>
References: <20240723045855.304279-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723045855.304279-1-shinichiro.kawasaki@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I've also occasionally seen this, and the patch seems to fix the issue:

Reviewed-by: Christoph Hellwig <hch@lst.de>

