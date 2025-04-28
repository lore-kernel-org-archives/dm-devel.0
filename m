Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3412D153808;
	Mon, 28 Apr 2025 13:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745845614; cv=none; b=uZNxGHqpO3PDWIHL502iIxEtnH0WVTysaetm61A6N/u4CPZZDFXWYuaQgIz/8VtSaX+5oqoGyT7ir+9FSjFVsXgvFfY2giB8cPRcgtCU8P3rB2oNs3OtZh0DXV1EIlpHMGq/6jxln2K7LOW162Bca6IXQWt1LrZ1RDS8IQFXEaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745845614; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+AVeGmOci2m4HjhedMyhmP8Fuuibvt2Fi7Qg2tMSc6IKogLq0V0H17RUVwPPYLGSOHtfDb22P2ArYoDOrSkOJwoEe+rs0aZOcTCZh945KZKuAqRGleMwRntokpVdXdH1NAuwgE8c3xull0NZufpgRxNWrifYrVNQW5MU9Bz1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cGTev+On; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cGTev+On"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cGTev+OnyAOAJAY7+PzzVdXJ3+
	O2EUzHDnoS1tTzLLJCkxKa1Bj9R6DlhAH0Lxdvsf+halfL9sKwSjS7IWH6Ey13Aak2wmDOCc4b9Ve
	1XAzw4Qq4aW92jvhRNa2VLtJqZAXpJvHQWwrIda4FoyMEfmR6ccMOYvL4nNlNdk9yqBhm39jeBMzi
	qvArE5X/jNzYOVYYtpDqLtXgVB4lCMkMVxcbwphMUKBHqrnFPc0Sh3arxturRu01miz+mKde4Nura
	dVkaLXaW+zGZy0m/1VxcaaEIKGHUlMvE+NBe/jLi5S4K15fUfmtpcr4AuKd6r6gfN/6jvp26KvBN3
	HV73m9Gg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u9OC7-00000006MYh-0FA0;
	Mon, 28 Apr 2025 13:06:47 +0000
Date: Mon, 28 Apr 2025 06:06:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
	ubizjak@gmail.com, akpm@linux-foundation.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH v2 2/9] block: reuse part_in_flight_rw for part_in_flight
Message-ID: <aA99Z4zbjEvl7lSR@infradead.org>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-3-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427082928.131295-3-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

