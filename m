Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333BD2C2ABF;
	Wed, 25 Jun 2025 11:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750850940; cv=none; b=fQoOraP6JcH60gkbYEl57ZuFTI7+OPO2kpp19uIy/R5IrNjNJEJTkJbv0JeytjPacC98nwGp/C0IRNHgY9Lahk78WTgpwLoIK5KG6AKl4cR7GwDk0Hsi6V2f44BAjV3rQ19t6N4w6fDbvdApK+FhlpouPClTOy+BqT/roUQDZRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750850940; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IzJaM1gIZ6tfGT73KXSVWGDkhl2n2bPaylUn6Z/J7N65uM/3Q/VYZlDSTkXXd8/gSYnnnef4XnjI6nPQ2RmVbWzaJJl31pCn0OJR3nFrpLZqKmSF4IyzHxQXn2vVjqyiEM9GJS83JcU8gJ1pj/0siF310tJMpnows/+KCSxVRUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n4Qd4OWz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n4Qd4OWz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=n4Qd4OWz4Iq3rGGB82wxu4dTW3
	Bw9icNYUn82QYhthSbOUG9eoddcIJ21kQUb1PsR5z8tiA7G5lcxsAJsmHA9opItr+Wi6VhQBKt+hL
	aQHpMCDYXvCFmKd6bsae5RuA2dbaJXgTqWpc4+0gEzy/yRetWJivQhfJvRZdvXaRW7u2nci9UTVV7
	fEGPyEN98B92AEBiIWKaAb/QCwl7p7BVAWIv+N4109UwsmwihecOOHfznQ+GzSq0gC3Yg1HUOCMyJ
	tdDxuKPMCG5ikKzT5FWOYogfLZuDSL3PULE30QcK3q6ddv4o1r3l2a9pI2wyLneiThDEjoUPpJNln
	lNNAEwWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uUOJG-00000008TUN-41J8;
	Wed, 25 Jun 2025 11:28:58 +0000
Date: Wed, 25 Jun 2025 04:28:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 2/5] block: Introduce bio_needs_zone_write_plugging()
Message-ID: <aFvdehsI45OSi9Tz@infradead.org>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625093327.548866-3-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

