Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B634E1DA;
	Wed,  1 May 2024 07:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549745; cv=none; b=ivy36JgA+5Jc3uCr95/XDrHleop3fFcTGFmsbsUCNNFdP6JOV39u8dHQHtbmpNo7mVvmKv3D3AwwOSisKac7ATb0Lel/eV1E19p1FgRN7+1JkQReOc9YCX0i3lBjYv2JmR9Oc0G0RfiwyqY6Oh2MSudJsDpoJ9uLrDqRIHPWVs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549745; c=relaxed/simple;
	bh=DwSe5eM3AmiI1Dq5Giy6q3PME3FwE6PW0h9hKY5PAhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IToZ8C0QBkxrl6UDZE3w2DlIDje7HhkWDg2Yf+EiYV0Tfi86dLwdlcHtcEDDSI0uTUJ+pqiSR3NYANs6xAV0getpggh9eGqPCHpR7bqscOnQdDigWhi4RRCHyBdwtovKLP+o+TUThLwUffERZhO3dKPxFgcPaX1NRZX4Fb3HxS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aGLb9YVA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aGLb9YVA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZFU1Vghd+kcJ76QbCL6rW7E5UpbqtoJIArKrgFkDS/c=; b=aGLb9YVALaKk4ghf6N5nkJXhFq
	XDUaCaDPVfFA3Llca/vm4NTYuYl4I+DryiE/YXY21rvdxWlaPTWAejKGzp+FONuZaeRCjL803/ZIb
	3bnMHY5aaD2z5PnWO89qz0ZiaY1uykYs5hSCUWnPKkbJk9/CcopcGWRy8bJCTBm/Pd0F6teltd9Vn
	dL3y4fktUByvhAoiKeEix9z1W2dy8ANZCagaMOy5XzqPoGVtYlT9KwBiCaYT4FeATnl+YQkBktf+T
	wvDO2B595m5Y631kBzhuWhMXgQKiqbgjHCXUN1OM2TeTtG1M+mK3d6fcLJLsZeeOH2VqfoxNKiyTF
	VZrCl6Ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s24i7-00000008mql-2JB9;
	Wed, 01 May 2024 07:49:03 +0000
Date: Wed, 1 May 2024 00:49:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org
Subject: Re: [PATCH] block: change rq_integrity_vec to respect the iterator
Message-ID: <ZjHz705yGUZhIaLv@infradead.org>
References: <19d1b52a-f43e-5b41-ff1d-5257c7b3492@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19d1b52a-f43e-5b41-ff1d-5257c7b3492@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please work with Anuj and Kanchan on a single coherent set of patches
to make integrity splitting work properly.  It would probably also
help if you posted your code using this somewhere.

