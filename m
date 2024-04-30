Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE98770F2;
	Tue, 30 Apr 2024 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491574; cv=none; b=uHKcxCoi8T1oJ003c8tWR89DaJxQpyBSTGZXOEbNG1C/LcYBi/D4JFXgEHeOBxB8Ajp6vkWr1xNFqPks62h6QRlW2AhfRcoVt3wo4skz9mVjSMxHjM9xWRgzsXqaSmh3PlN6WMSORc8bW9pydsjEgURaWcrvdtZ0jXFBs2f1w3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491574; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i16q1btuZ+fGii1Zn1h4Hv2bBtLtk5xDZQIQ7lI6X7PtL4+6u0wPo42zMpBz9EJnYSXMoPe30VEded6QyNfHHECzPHg8Us3BAGc+eAoX4MeHh0vxCwmBGcWqDk4yY7O8knLhH3OLBzlrODS90OdoNREJDeo7rk66Jy+YHRmnzOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HO7ChlXT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HO7ChlXT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HO7ChlXTCLedVUpDtcLze9Kupg
	8VOrV0A9wY2Z+aUMmgVukT9u4CGF+FKaI1OUK/40C8leUl+lrYt+brT9eTQcIWZ8i25MPzFqYHdHq
	uKs0Tw4AI/nxUQDwhXIr0NmLN8a0TyFXFuMFBzfDWLSBIxlECqkvIUtJhBWBrmP8xl0YXyYwtRGVb
	lxJh6I9Ilpdsqn9pSwKOnCZC/tjYG5z15P52Q1/3KetkWT1y+8TF/YsfSzno3nGj1I5SKP6tjaHSR
	hBr327ErPemcJpSW+7/FYNqG4vM3qmZrIHwGpwGMgAS+f1kvHG+YFGTmjgnBS4a3QeifLBg9o5tSB
	3W+OpOSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pZs-0000000755I-3Xd0;
	Tue, 30 Apr 2024 15:39:32 +0000
Date: Tue, 30 Apr 2024 08:39:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 11/13] block: Improve zone write request completion
 handling
Message-ID: <ZjEQtGbeCMGawk8y@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-12-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-12-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

