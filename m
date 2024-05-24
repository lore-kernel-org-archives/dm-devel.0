Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F456EB4B
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 09:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716544703; cv=none; b=XVtvK82J5O5sYAvw59RzF/Dw1jQXeloX+2oPLs4z4Oi5R0Ydfw9pSYIb3mcNaDLLualESnJNRphTMUfnEyquv4yVRK0kcbYaqCBbz+YS9fItMgLLc1NheBb6xBFDiNX8J2i/VYVg+Q1kT6Sf943JF4s7SfVbGFkzoF6TReaQ9tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716544703; c=relaxed/simple;
	bh=obs/0dbhs32AHfM+jUANDeGLMhqO2cqtwm3azYdtQaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdtZpJHoTWLhbNuBwyDymfpNNoui2qiITduH/6nDrZX2PCB777mK6RoETlBXH5ta0zcVIz5+G7PEYaefITRgQvBLdpHjHHOumEHatmseW4qY/3TYSPgHpBrgCeei62rikgOt+Qweefwlle7rlFOo8Wm2rOE0zngijsqM16BMvAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 95B2968B05; Fri, 24 May 2024 11:58:17 +0200 (CEST)
Date: Fri, 24 May 2024 11:58:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] block: blk_set_stacking_limits() doesn't validate
Message-ID: <20240524095817.GA26791@lst.de>
References: <20240524062119.143788-1-hare@kernel.org> <20240524073957.GB16336@lst.de> <6658470a-fce2-4570-ab2d-6eb28f2fc421@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6658470a-fce2-4570-ab2d-6eb28f2fc421@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 24, 2024 at 11:56:17AM +0200, Hannes Reinecke wrote:
> I just found it weird that a simple 'memset' for the initial device 
> configuration and then calling blk_set_stacking_limits() will lead to a 
> failure in blk_validate_limits() ...

You don't need a memset before calling blk_set_stacking_limits as
blk_set_stacking_limits already does the memset for you.  But as
implied by the name and documented in the kerneldoc comment,
blk_set_stacking_limits is indeed intended to prepare for stacking
in other limits and is not supposed to be directly applied.

