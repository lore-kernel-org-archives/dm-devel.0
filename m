Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77A38286D;
	Wed,  6 Mar 2024 12:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709728252; cv=none; b=d7DknvwfSdQhTaHcjU+OsgwrBk+u4NiyvfyvULTKSpvsCSaalOcDgNbYBFhON6M6rF5iKGFGieykjdfonHGkLEZyQPPHR3Ppu9rv4jB/W5gGJPuIb3AfhGLRMbYVko+a/I3UObmaFtptjYVV5QVbVZKqaknSeP/CQx7pwwluDGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709728252; c=relaxed/simple;
	bh=YTQMSi5VEBYMAjYoAugbfmrBeKrUxScCjHhU9xssM5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCrBBFwZI73V90FU9ajr6S67KxcIgSvSMWQL3WPbFHwWPS2x0AfkmK2oZtnHCR0zBRnPuqCnfgSWrLmduX5otrozRBAYuVf7LGhbAgS7yEQtT7yKzUROQO+8nOoNIGq9tkgVFIuK1kOthgsj+BJxk+Pxdmm7v6bOEJGB7zkPIFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lys72Odz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lys72Odz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wCkQR4cHA9xuvHKzS90uHmsTZqSi2S1HI/0MEmerI9A=; b=lys72OdzLB0W3a+SwSVRceozRO
	coEThVxWBncsGydoGUBJnHh42gpphGT/yVt8pSlYPqMC701HmqbU5OqC7i8i6ET0MpLLSy2ruwEb3
	c/u5MdhWpyLCIkrEiUbsfnISeiEmhfYEZce6h+09mi++o3eaIkI9igHdkZAEBgcVtMktj2T4INYju
	Z/V9kP0fQLFWmmy7qSSW+Fg/VNmrlOv4/5ZM1lEPabrtgB4kcge7j9ZZ9I8+r7b7rKDNzVPSpy0PT
	cwpCw5DHNoRlhTcbBCd3qgJdiXYY30D7wiaxrEcwJ6I5guWQMcomMRiHR0vfBISA/lfDvTWb5NOYb
	VkHQR5Xg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhqQ0-00000000C9P-1Vg4;
	Wed, 06 Mar 2024 12:30:44 +0000
Date: Wed, 6 Mar 2024 04:30:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Song Liu <songliubraving@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Xiao Ni <xni@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Junxiao Bi <junxiao.bi@oracle.com>, Dan Moulding <dan@danm.net>,
	Song Liu <song@kernel.org>
Subject: Re: [GIT PULL] md-6.9 20240305
Message-ID: <Zehh9BvpfsG0tAEs@infradead.org>
References: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Song,

can you also send the queue limits changes on?  I'd really like to
have all non-scsi queue limits updates in 6.9 and have been working
hard on that.

