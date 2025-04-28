Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EC326981E;
	Mon, 28 Apr 2025 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745845584; cv=none; b=qbKLt95PFxP8tXfsrospyV6J3m3IMPX+z3ttPJADKvSYIc38WK85vxQQE47lAsLfgHTSR+/WI17M1E5ijBiyCikDYtGqfmglFX3ffHE/k7kQNdLvkPclMfD159amveLR3c19wUNsOt5tU8DihGSC0+1yrVdGH0ATURhGlH8/32M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745845584; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PD8g8Th/bpbZlKBNHNu+Al2G/puUCl8e1pkTl/So8tOmQqBQFz78oVQWBtigIMTbliNugGRpHxXx3cfEX3PXjx1t1MeCQgQGQFDV8SbQbes+B0mg5loThFB0F/2beshpfWCUH0lYuXqIonZxjHWqI7GeHS5exaj326PWEc/GZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sXMVFtL+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sXMVFtL+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=sXMVFtL+pxZiWLq/ARLbrZ0HxW
	oFql8bevxV9fAVRRE4w+J7yeQstwVahOBgJAayvlxPvgUOy/d0e2OxH+XHx/gy8tc3Zl8b+cWEwzR
	uObfFl+Nwfk3KGSfqfyTostX0lnKThiyLUjNuu730jjJctYORB2gjf1CJXp9YE38ylbEzUopfZKMt
	zFdtakgeLmtqIyn0yjyB0rMK73T4/A06j1D4q7n1ILaqHSxmkHchjvqKs2yMe0x4aTlWEd4BIVLo6
	Jj9/yNCdv9ceETBKVTYwaBVmAT6dEgN96REqIkenLoBmKGoIcjrwe/AXhDPrjmb7jvo958YQ8Hfs7
	gXldigwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u9OBb-00000006M0f-0nRT;
	Mon, 28 Apr 2025 13:06:15 +0000
Date: Mon, 28 Apr 2025 06:06:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
	ubizjak@gmail.com, akpm@linux-foundation.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH v2 1/9] blk-mq: remove blk_mq_in_flight()
Message-ID: <aA99Rz_mHujV6al8@infradead.org>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-2-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427082928.131295-2-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

