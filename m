Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381AE23D288;
	Wed,  4 Mar 2026 13:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629599; cv=none; b=UjOnGKvZKhM3B/aK8TL/lS+LNfiBshhs8VQIU2n5COamxHn36rW8fhbKRz8U+h4duHdUE2kkO0g6uZ95fRzUA8pQ4SOG5H78+AZDYMvBs3tWBO+8PaqQf8ZUAel9w0hm9Fl8Ug3XdgCE8WolcA46lfpr1pvRHSNWHPLaip+2xq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629599; c=relaxed/simple;
	bh=z/yecvTUu1sp7BjbCvKO03EAOXcTj8gBxrIiw/vN5Mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SquTIH6HyKOYv5AcdKNsPFswGXWxyijD35byvKH5phB7oXyqkrQDOAlcY4iAiek4Q80Lx8DzCyB6FBhqRRf3sK+m9ien9XPpAYGtIWAAIYOA3unQo4xbYLyTOTzlOUBlvxMYqr7xv6I2nDTUdygnlrzin9tbLPJVw7gDy8EcbTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=krMzkgW6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="krMzkgW6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vll5bWK7ApEJ0aCi6+vtKjCM2GETEWaIWvDWKW4Ke08=; b=krMzkgW6FAZxiTZ84pxh7u6zg0
	6ugC531sj4WbTIfMwKhCgKWtWyvTBvliY9CrsbqpbRhd9ygsjZmwRL4suM+pNzgEhAKw+9Ga8v/cf
	yivKAr+QHzJ2YDJObVZ/LSg8Abjss1MAdTiFAqkAXDS+k4mjENbUbpKg0i2iNg4m22/iNcxP2CDQP
	nxI1NXc6PBZ0Bh7yP6weDxy00CENaZJ6x3V9zGGrvjI8mMLYqGonlc/JiB7/o05rMZWSMZjvXe5Ve
	fDY69d3mp2qx0yd6s3qMrEt9aPY5OeOOsE7TzmTnrx5tAXAEB8uijee5vR3Bx+4VItVGRZ4vQLSqh
	ZxP7+flQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxlvv-0000000HDp7-0lU3;
	Wed, 04 Mar 2026 13:06:35 +0000
Date: Wed, 4 Mar 2026 05:06:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
	dm-devel@lists.linux.dev, quic_mdalam@quicinc.com,
	gmazyland@gmail.com, israelr@nvidia.com, mpatocka@redhat.com
Subject: Re: [PATCH v1 0/3] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <aaguW3p3_LOeM_Dz@infradead.org>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

What is the use case for this?  I'd much rather add fscrypt support
to file systems that are missing it than forcing another stacking
layer.
