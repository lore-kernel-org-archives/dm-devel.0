Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D92140E26;
	Tue, 30 Apr 2024 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714490812; cv=none; b=CkuhygAlFbQpxQ85SIoPtysJRQuxFJFTD2/GH/0rdCFyc8jNrW2r6pX/ZdIwYZBJLU901LZRHUAc9adsvxP+s72H8zuVNlfM9lawpzqPsXZ8uoPnzlewiV2NxoScQnX6Y9bvIWHwzNSlMfrPBApIdMqW86xubQXfxGct1hamxOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714490812; c=relaxed/simple;
	bh=Mp8nmJM4fj7MmA9rfrpsrKJsaO0r6WI3GJI7zSlTwNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRw0JvSQEn/7RKR4Xqz3ZfHQ7LIoLKo/JnTm/B4n8puC8VmqGFVBXkG67Flno9JDevAvjVC1ZqqrKFeslpAw+BSHSHprX28fdw+wMphFl+mRwwyNLaj8bsb8cK8rf67xatLiC9NxxWdj14mz3Hq8Hi0aQqT/SJ8PZqOBViv1WaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rwEfwRRS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rwEfwRRS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mp8nmJM4fj7MmA9rfrpsrKJsaO0r6WI3GJI7zSlTwNs=; b=rwEfwRRS+sYepWMT2jHg6IoU8e
	sKszCg1l7Yq6Ymq8V7XhMDCBJnOzEpQHzZnm/pqZwjj6hsYcOVkQ7ANHxK0PpwozC2hZU04NYYMZG
	JJq2klIlHH6vZWMEe9Zbpkyov3hgmfxRgA1e7EtuM9iiAMhyHbP6iw37gO8/T/N1DNKHPMgS7SWUy
	a1NJYnHfekA3oru+Vc9kPUKuRrCTLjiP8GnPPszM2wWTKwJs1edo4w4qlGeW/Y71dHEIKGxzJdDmh
	T49nm0EZZqnauJggorFUAAZVCB9OBXVoVbRCNlmQH/KGLseLt3fmPuJTU5GoJA3oUwjkLqneJ9fvJ
	c5iOntvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pNa-0000000728Z-1bzb;
	Tue, 30 Apr 2024 15:26:50 +0000
Date: Tue, 30 Apr 2024 08:26:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 08/13] block: Fix flush request sector restore
Message-ID: <ZjENujO2R5TGb_sh@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-9-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-9-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 30, 2024 at 09:51:26PM +0900, Damien Le Moal wrote:
> Make sure that a request bio is not NULL before trying to restore the
> request start sector.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

