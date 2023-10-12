Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2210B23D3
	for <dm-devel@lists.linux.dev>; Thu, 12 Oct 2023 04:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A28YKmXi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=62SeY2x84Qw6a+BcPqZgnwpxl2pDf5680x3k9BEoNw4=; b=A28YKmXi8D2KoVMfLCfbESUWMf
	oKD/KOgQUr8Lj4qBqnvGvoytPiXvFwyTL6pdlO6MonfJ+Lq5tdRSOGrh/wvfSpt3fKcLr1PTzpvwF
	iWKpSTajYh2+KzRN1Xz0d3WoqyTeO0ducAwrqDvXG6YKxGtffoZmcUxT9Ojup8F04+jUBmRFZzkJ/
	fTrh8s5tPXXFXZb+lKUv5DtVW6iL4r5CKk0CsD5Hn25fdxUVgng00bzgS326fYPwhLiTAVerkdTzM
	EPnj65cxRNBwhbW/HfC94tGq4qUmDByt+5pmWbRokuaRezDf5C89AF3GzI4wiiX7e8QQ16mJBr9aY
	8BHOfNRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qqnD4-00HMVG-2Z;
	Thu, 12 Oct 2023 04:22:06 +0000
Date: Wed, 11 Oct 2023 21:22:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: charlesfdotz@tutanota.com
Cc: Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Dm Devel <dm-devel@lists.linux.dev>
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Message-ID: <ZSd0biKdfG8YILji@infradead.org>
References: <NgGvkdW--3-9@tutanota.com>
 <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
 <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org>
 <NgP-4zc--7-9@tutanota.com>
 <64e727f6-edcf-4b61-a2de-cb36d971fa2a@kernel.org>
 <NgUxgpw--3-9@tutanota.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NgUxgpw--3-9@tutanota.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html


Hi Charles,

you are doing a whole lot of handwaiving here (and not even following
the Linux mailing list style).

If you actually have a driver with your alleged behavior you can
simply switch the scsi disk driver to zero blocks on discard by
doing an

    echo "writesame_zero" > /sys/.../provisioning_mode

and get your behavior.  I very much doubt you'll find such a drive.
There are exactly three hard drive manufactures left, with just a few
models each, and they are pretty well understood.  You've even got
feedback from the prime expert on hard drive handling in Linux who
works for one of them.
