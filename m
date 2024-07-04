Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8992F23
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 06:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720073839; cv=none; b=Sja/Ci+Nu2wDA8R5oSvPNZuBwSXo1jgbDLH+lsHFXd40dm9vjWidsGTTEy4YP/aZBVGZvJNkJ+o+gBmLb7OS/B0h3j3OPZyDwGzd6Xx0036NVYdokIl9d3l4Fmb7baF/0heTVOEHebxi2vxs/8YXz+iemqsZvFjK4/cxlYS0VkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720073839; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzSn4KuyZb3t8rSHQOaupIipVgBT1K5YpnQF1k/DY+WwvHhDmEVs4hlNhbSCH448HsayW78yxXIr1jMhVnhqmO0lj560aFfhsrAclbymF7OVxqrg5eGTMOohSb/sVI9rlYbhe/yKWB7mzof6m30cCkzy69jYgx24UBrpPmpYJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eDrJPFZf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eDrJPFZf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eDrJPFZfTlrsxA/X8HlZaWihoM
	i7ug8LVE9fNnASn/dngLjYtznBOzalN5u7y29BTkd6SBLMlKNBfWmtAZfCeWFDdcV3Uwz0DKluxNO
	KAWisGxZxy8K5tF4XunM5+AuwUBXinMP35gfMhzaT42EjO6h7suwMa9xleXIjzpb6dWQa0cyFdVEf
	x1Y9X24YZ0D247BwtYJ1b3sh+CW5PU9TWbSNGylAQDuPbSHGZJCr2H8mXkg3mkHng2PUCAF3aB7Z6
	tbdrEe+e0poPbUWLvb+fqAEvu1QHZOX6zhotxrcOiApUGHQdGhdsJrEvELgUQtjOP79nMz68Biy+E
	T+6m5nHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sPFmP-0000000CJ2e-2T7G;
	Thu, 04 Jul 2024 06:17:17 +0000
Date: Wed, 3 Jul 2024 23:17:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm: Remove max_write_zeroes_granularity
Message-ID: <ZoY-bQpLNZ2U2pxL@infradead.org>
References: <20240703221336.503507-1-dlemoal@kernel.org>
 <20240703221336.503507-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703221336.503507-2-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

