Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA76A3C5827
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388594; cv=none; b=MVwFLLYvXTHjI/7jVfMYfLMUlx6EjhzpwjLFmLr0SrK94DkibYAncgSU4m6TRDU2CMYOmEhaJqnMCaRV1GbNteT4HnUPQIjlnfH0qqPJerXf6Qy9krDbNYLzvvuY4iliFAp92ssWeTymdyGlISObQOgG5pMyk8OZZHwHAhyiSe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388594; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rN3SaN8bt71ZZ+X5BY3old8kRbVc4k8BQo7zrcX/Jm7sMtxqeVaQoDNSW1X3EAlMLZZmDquuTnyqgqUBdlx6HDXDe6Xc0MmtJdaFKwJ5lrifE943NcLK9Bwx4cIcR2QCsro6oVERXFMpQkrUN8SJfXfJjwo4YOJCH58D2ySjeCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 48AD368B05; Thu, 25 Jun 2026 13:56:28 +0200 (CEST)
Date: Thu, 25 Jun 2026 13:56:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 1/5] block: use blkdev_iov_iter_get_pages status for
 errors
Message-ID: <20260625115628.GB18348@lst.de>
References: <20260624170905.3972095-1-kbusch@meta.com> <20260624170905.3972095-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624170905.3972095-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

