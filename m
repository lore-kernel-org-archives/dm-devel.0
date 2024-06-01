Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364CDF9D4;
	Sat,  1 Jun 2024 05:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717219610; cv=none; b=QRi/iav/EJHo4HiADkeIMirz5hh7Xt1GCKc9A7KA7RLnRkge3wNQjURZWxQmeMeDmp8KiOEzQJFqhM1pNORxPENHcSvsr4GrTSxarlKUnElTS4y0A1V/GaGqVea7j14//8uOmq4AOPrGwd1HLUS8uVPPcbCSuD0vdfxMbgfCiTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717219610; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fh4ulmDD9dX8Tqv8weBYbqX4+++W0NVjiyaet0VW6mncP6WDjL9XtVC6aScOfV0WdZAWLgMm5pzQMnDRGN9gLh7CnFmE/a5cuyG1D6TDyPNESafjwIM643YbDbywqAjc9y6QLIoPSfN3O0YGRN0BRzr1j5FgNDTx5ol2AwKFVsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jsQ1ww4P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jsQ1ww4P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jsQ1ww4PDUKAaSv3PP9jm1Y0uB
	0klWnpz9e+d859t7LoarEHE7qAmQQWWKUaKjhTqlnoLs43Z4X6PkpK6YOCLFGoJ9zTo7nzb9KSSJq
	23AAw2pULCesC6a8eM6P0Bn+1rTs9N/j0CDdYR8Bs+Ib/UXQe+xCt3McEs1nZ9jQrWUTh/MApisub
	5cszcgSfV3TJU0UdhAJmUIo4+490dJDvAHt6TpYQ6jqbE9Y6ZXD5FkdnMHv9AiXvYMkfPtOeon25j
	jmc/0s7xTk27TbwuQBAtDUcQvHN954r4st+O8wwgBgEU29mUAZ6n/+a1Yuw22PqHh0sJUF5VH0xvy
	fr8o8Zsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDHGS-0000000C0Ur-3WlV;
	Sat, 01 Jun 2024 05:26:48 +0000
Date: Fri, 31 May 2024 22:26:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/4] block: Fix zone write plugging handling of devices
 with a runt zone
Message-ID: <ZlqxGI-rA1rzOA-6@infradead.org>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530054035.491497-4-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

