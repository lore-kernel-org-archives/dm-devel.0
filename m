Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10A535AC10
	for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782226875; cv=none; b=TptiU0shLKLjS5buF9uazGtYBicVdaOpJcIsbZ13YpGX+iLcfbL+aDFBDaUv4xq25u84FxZX8kPrU9dL6wmd9uXo2cOUWIKmO5Z46gjuqGgL51GeGDpP2vzGsIpyOyhBEgbvBZjlZWTbAkzotK+Yc3a1S74+eeUABUOPi8/oY70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782226875; c=relaxed/simple;
	bh=acuvJL70IzPv/oZ6mn6Pz96kPyRu0my/JSQ0PIhZViU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTrgTaBi0HNbRBVoGVtxG1aTW28TBazY8mPrByi40TzfWv2AxmtgbtlZoZkACNvioN6VYMcW6EhZvS4wghddJJYMPw/6VkhKdRrjbmTAckzFEAjAtDHeZU/99z5il25NItl9sewKq0mYYAo3Nwh7oOPdz/eSLy0I9maEZk3t/WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E087A68C7B; Tue, 23 Jun 2026 17:01:09 +0200 (CEST)
Date: Tue, 23 Jun 2026 17:01:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 3/6] block: fix dio leak on metadata mapping error
Message-ID: <20260623150109.GC13628@lst.de>
References: <20260622174241.2299563-1-kbusch@meta.com> <20260622174241.2299563-4-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622174241.2299563-4-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 10:42:38AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> A failed integrity mapping holds a dio reference, so we need to go
> through the full bio ending in case there were previously submitted
> bio's in the sequence.

Yeah, the goto fail is for sure wrong here.  I have a vague memory
of seeing the same or at least a very similar patch from others before,
but right now I'm too overloaded to find out if that really was the
case.

Reviewed-by: Christoph Hellwig <hch@lst.de>

