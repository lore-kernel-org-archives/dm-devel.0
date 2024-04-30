Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B672F173335;
	Tue, 30 Apr 2024 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491025; cv=none; b=Cd12syoYo1bxoypLS/+ImMXGajUgQI2T/RpRUT5oc3Ir8k4UXJ6BDpw816MWrChaZ8hzT6X/Fhn/jaem682ROYnaDCprQs1NXcmVoFZL2JnAyU1XItENLGmp7Mm0Czo90/oESWN0uouE+ebILmtIS3/LXdIE+Y00/quWb8lVK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491025; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocmdPEww9R8bq/z2+dYfvR0/Jnq8PyPcEx++srX+QGs9h0kmnkcYn4maXQa8LSJjQxtWJ0VKx5nzLgj+iJ3mq/IMwpEUJkk7Fe1QpxhvJvnt+SAP1agXETP50DJYfQPXwQAuAPSXbq/S9edXOB8Q82GNRB6As9DXKYe0JAqwXBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RuZrJCV+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RuZrJCV+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RuZrJCV+ayx0FWL37NTB6o/m9s
	9DiM9GR3qOzWbTABpylZvhhSrOFEOpLywkhiIa/9EzIUeJhFIAyQOvbZGIvjktEaLwxF0UdfMxiRt
	DsNLkqsZaVz8WI0JOxT4IaeMGp/aJ0SCaziKKQuk4q+GCDsewUqSri3byTHNLbWxJgtvbTLm5xzeR
	lKuxiYP2l9IM2EFdOwsY5JPz0QlhISJH6An20Ax2QYHh3mzEPRDrmUTCAHUCvM3o9w2nXv7VkUghv
	4uU81u0Ft2GQbg5My4jvT0FdvNpe5ZqdtEOsI16iQd84B5iPB3O5esMhTWD9PILMWizZPd6OTbynw
	CsRw0OcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pR1-0000000737o-17Sv;
	Tue, 30 Apr 2024 15:30:23 +0000
Date: Tue, 30 Apr 2024 08:30:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 05/13] block: Hold a reference on zone write plugs to
 schedule submission
Message-ID: <ZjEOj2XfX1Avx6dJ@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-6-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-6-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
