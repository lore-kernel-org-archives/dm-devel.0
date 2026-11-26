Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795682331;
	b=CmGy3RFpjmEa6Vsb7cIIuRoHpCvU/bVmMnUsuXd5Vv6Z4RI0+9IW+i/0n6ZUcXz8nzLS
	 0kPyF3Ykl2Ub8dNljHNT2Ov8Hol5VRRFWi6EJY0h/VvcckrQ3P2Wiz3KChUhf+yRUfiXK
	 hWSPzyOrQW+Xyj0gu39C4r7EBXb17ov7qCwQavfJWiH6OOURDNCwCpAf/sXrLA0G2vkwZ
	 uu3dhua4kJsrvVoNnSMq507eRXEkrjMdIZA+1qfrykZzVfmxt8wSR5TzyykLnrZPzeBuV
	 o8w5HG/rbj1G5FqWXfSZfO7LadeBfoJzaURsnW9beeuYxLqVall62Mo8Cm3hjcIb2JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795682331;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=mNj571D7ufTR7Q9nbYX9DRQk6y/MhGAcBC1LxuF4rx0=;
	b=O+TJOIBlo48XMxdwGIIXUjZKpd1DTkvP7Woq0e1rHG0d73XV3BzceioGiIwdyw20Zc7s
	 AiOiCtYqdytSz7n1MAonL1bi1uDcdSyifiSXS9RE0HOtUOtzVBMh43tsNNONXFwmbDDza
	 bkE3uj7uJSM7fpcmG5oX6WPP6Up5sZShSSDqAl6UCypHoJG5DLKKXJhghNj+UlqLtkko5
	 ICawgXTNlXYWf+6aQc6co8aLLZw++AZkRkz5B4exFvaDUxQ/tagF7X+FxvBkmGUNFOLWT
	 rueobU8pm01GZ2CbaGVSvtIfQlnSxz8w41SomZfCwAcbk2kvW7toSq6ZdSYIhrttaOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="uwEYZ/lb";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F780606A31C;
	Thu, 26 Nov 2026 08:38:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F780606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=uwEYZ/lb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mNj571D7ufTR7Q9nbYX9DRQk6y/MhGAcBC1LxuF4rx0=; b=uwEYZ/lb+ypmy07sNLJhVKUClz
	9lj0zXG8NTI0aDjG6TXhcridvaNvT6QP0IOoScuAuyiJyZ3lSjTq8JRAl/XTo+bNSDv6VekL1avqX
	VjjuCf+eWigfL+bPF3gxwXxgaUXwjcZcSaGyMwx+mUTf5PVZNppgByDDQzeuX7F48w2IcNUAkb6/H
	D4ydOYCzGnTmnDoYDatjW/X3XizDMd3DFsWKZN8yOpAIWEqhCJ88fOROveOQe8v2spZgRG9WqSOiE
	WyHmDsqvpQ1jwuH58MZ/GHkSyXB79Keohb99RCThTm/PRuPp82nFtOpGVIyhI1FuKL79Gh1wwti+b
	1ZeRAzQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWV0D-0000000CQ0U-3tkO;
	Thu, 26 Nov 2026 08:38:49 +0000
Date: Thu, 26 Nov 2026 00:38:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: tongzhiwei <tongzhiwei@cmss.chinamobile.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] block: fix divide by zero in
 queue_limit_discard_alignment()
Message-ID: <awfwGWfzhv61FV_0@infradead.org>
References: <20261120103040.610-1-tongzhiwei@cmss.chinamobile.com>
 <20261125110353.366-1-tongzhiwei@cmss.chinamobile.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125110353.366-1-tongzhiwei@cmss.chinamobile.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 25, 2026 at 07:03:51PM +0800, tongzhiwei wrote:
> Hi Christoph,
> 
> thanks for the review.  Please withdraw this patch.
> 
> I do agree with the design to fix it on setup.
> 
> Sorry for the noise, and thanks for the quick review.

You identified a real issue.  As I said we should fix this in the setup
path.  At least reject it in blk_validate_limits, and potentially higher
up the chain as well if that makes sense based on your reproducer.

