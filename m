Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDDD3D6486
	for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782226515; cv=none; b=fxy4Nsgq3TZ4iQQseM0G3OCW1SYf07OpIfLKJ3FpNhVNfWay1TgwlbohB4oqtbcFq19QhfylPqiUh3sVUYX2okKoajaAZ3w4zG1XbEm74lmcY3RUqhYOhLl9jNsTKgTGbnYL/xaM4Ai+GLlxYi6QP+4T7rPbOPvml9mzi9nz2Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782226515; c=relaxed/simple;
	bh=lBMpEk1GmpkVGF/cv9becGSzMI1EM8R7S8f6bV5Ulxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoniKT4Q72HMV57QpOfi6Q3imM5JAxSGJjRFrc+nOQc1Qu8OgswBp8lQsHfMZAxjLPPu/BYaFppBkXFfjBxaaxaDEmcFz6EDtsQkGnexzd1NrivRnbet3ZWNf7Mcsn2jTl7dDZJESvCZKvmLDkTkjiWNO6Xs0EIzdRM9bhvkq5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2934268C4E; Tue, 23 Jun 2026 16:55:12 +0200 (CEST)
Date: Tue, 23 Jun 2026 16:55:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 2/6] block: report the actual status
Message-ID: <20260623145511.GB13628@lst.de>
References: <20260622174241.2299563-1-kbusch@meta.com> <20260622174241.2299563-3-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622174241.2299563-3-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 10:42:37AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Rather than assume EIO, set the actual reported status for user space
> informational purposes.

Where "informational purposes" primarily mean not dropping the EINVAL
for incorrect alignment, right?  Maybe state that more clearly..

