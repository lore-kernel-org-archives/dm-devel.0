Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977B923C9
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 06:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716877759; cv=none; b=utyNyU6MX+Fz5X/p6xxs5XF+lfjisjw+DnldfQTcc86qy+3v8BDg7vuzXIY0QpOr3FFSfzMskCyZ+AoFe9F3PrY03Ugj9VoIusOu+jdM8dLUpkSqXTDYzsaThD455OsTDE/OPm3EgrukEBTsGh58xnodUF+OuUToqnm4T5Ka8DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716877759; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mm7XPG77B4iLNNTWbYTxRJ0Kq+tYP47zPIROAoV38lwvMWULhCQjmnMZ6zsmIoYHyQiZ4lIy5XhtWD3UIwwsfrA2G8XCnxsMSzkNF2d3FRzqxOJApuBTH3g4p5Nxe+vIcJ/wUSns0adNb/xxdgRcd9EXDtMsiLV+A8Q/y/Rvj6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5FA3267373; Tue, 28 May 2024 08:29:11 +0200 (CEST)
Date: Tue, 28 May 2024 08:29:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCHv2] block: check for max_hw_sectors underflow
Message-ID: <20240528062911.GA29940@lst.de>
References: <20240524104651.92506-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524104651.92506-1-hare@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
