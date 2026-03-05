Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC29334685;
	Thu,  5 Mar 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721501; cv=none; b=uwVjhbdho23c0Kf9Fr/+izsl9Qx3sp0vHX5eBgSto0rcF1pEYMbElHjsrJPpAA5dh5tfqDebxdalNMqbzv76Gxte9yHES0YHoVfey3LcVhH2yxkFqBbMbpNqAM+k47e4aq+FtjCCw91xwC/VEolWflgLdgaW8hTjZevl2I+XMk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721501; c=relaxed/simple;
	bh=Aa3G6/S8t6pJ7Gm8T1kOYk1pBCzqfa7v6DOedTkDZ6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbattO+mWcFk9l76P+PskvgBbRmDHawJsQwPOsUFfk37SwJIGPP2Nr0+Is6L13m+7+J6iuYXdREvt1spSUzf/accgp3HuHa6zYBFW+MikbgaSj/KgHF1zKBfmu75VRHE5YDK6v1QlBKe+VFUkEauRJT/AupNMPPUNpWwlpruc6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1hVZBk1U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1hVZBk1U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xOUTuNuSRBZbL1ueUm5qfqOmmk38QH6XBB6u0ubYvjU=; b=1hVZBk1UAL6ybRINUCtiCnO7Kh
	iclPcd8Oq7FlNqG0/9ONyza4ESWMqo36S+ZU2E0fl5j1YeIzfR3AtyI2C6pajZLZIjj6Aof4gaDL0
	CSYHB03DH6oJleVPsFFeCHA77sTEuNFMJ4hCwFLhqblvVXf+CBJAJpUx5AAAC82LJf6dgh1aHBNJ6
	2qtbsgY1QGo/vkWVNiagfWCftSGSQphZ7d+PQO9pkhqWnDR5r1X5c5UkqLp3L/Ulu+a3TTjWo58YT
	Y4KIfa/CABTOI2GKSBv1Un4np23/EMB7iSmn0z+U4dxjHVKRwS81dWyqZjM42OWigTFrbo7u6Pl0v
	2rhsTwzg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9qG-000000020M3-0Mns;
	Thu, 05 Mar 2026 14:38:20 +0000
Date: Thu, 5 Mar 2026 06:38:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Vovk <adrianvovk@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
	linux-block@vger.kernel.org, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	quic_mdalam@quicinc.com, gmazyland@gmail.com, israelr@nvidia.com,
	mpatocka@redhat.com
Subject: Re: [PATCH v1 0/3] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <aamVXAqlWGcPXCDe@infradead.org>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <aaguW3p3_LOeM_Dz@infradead.org>
 <CAAdYy_mSB4U39Onwa=V2e2XB0sJXV6tCGkzwV2-z7ZtMcm+8zg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdYy_mSB4U39Onwa=V2e2XB0sJXV6tCGkzwV2-z7ZtMcm+8zg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 01:02:41PM -0500, Adrian Vovk wrote:
> Hello Christoph,
> 
> Maybe I am misunderstanding something, but this seems orthogonal to
> fscrypt? Userspace would use this to do LUKS full-disk encryption, but with
> the hardware acceleration provided by the inline encryption hardware.

Ok, if people really still want to do that that should be ok.

