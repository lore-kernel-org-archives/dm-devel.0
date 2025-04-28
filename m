Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10C6269899;
	Mon, 28 Apr 2025 13:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745845635; cv=none; b=LFJ90XcuymuZMW3WCnRTy3v/8bod21cbzCiLyKBRHSwdVd5+fqBZK6jj9Jo9yJObPgAiyt9EQ8fOMcd+xCvEkt28LB3TLxq+3n1z33/LoeHZ5NNzBjR5s5IFCF5j4XmIlT8hN2gTXn2AfIBsl7WdJR4P+mg7inpOi5xIGS5T2Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745845635; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvDqPtUH4mX3vZvV9TRakmbjsbH9O+WW+uhVA5cd8eqYotUlGuqF9ACgJ0BCtJDdLJ6Zk/7b8TqOnXcNAUWqPqW4z3hQ16fDmmgYMaHlwJBd8FpqAORhxzd5wpuEGbb9k6h5gJvVt/SSh1XSYBlnX88q5ys3Pa+GKX8D1pw/Q3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hg7jGyN1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hg7jGyN1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Hg7jGyN11rAgZN+HlHtncHmaHN
	WZzFeXeL6SUeQsE7XCwHQUft1t3uZQkqN1Ouk64RavKfCyYI9MlwNDEO3THJVlSokCH3TDi26S2Y3
	IkMiUCUixC26oVXHWVlciszuE1qWPl2lZjVXlT9+vi3Pj6xmcwRecHsPFFeBdB8KbB10Vm9lq4m2b
	Obgmid5CE3l3DnidTt09EiI5lwO+s56QYeAWOVHfkjPFcw5vUz53WHe/oGy2ZwfuKfNpmbi+jFn9x
	a0dl6eQOOhH83G9yo1tBK9n6gWEHkaszMJ3AF/s8LkuYWwx6R8chd27I3Zu209FyVz0yYeXQ8KwXL
	yo7C30xA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u9OCT-00000006Mvm-2Cpb;
	Mon, 28 Apr 2025 13:07:09 +0000
Date: Mon, 28 Apr 2025 06:07:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
	ubizjak@gmail.com, akpm@linux-foundation.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH v2 3/9] block: WARN if bdev inflight counter is negative
Message-ID: <aA99fd7ErYm64h4h@infradead.org>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-4-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427082928.131295-4-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

