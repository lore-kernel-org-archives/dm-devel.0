Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216E31F6694;
	Mon, 28 Apr 2025 13:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745845743; cv=none; b=PdQYkagy6gDqn99v16xXgFX8NapDXNAczAbaNkXFrq4vcFNJPSFdEni3ne+ncT4Mg7Q8oIWYOyyxwcmhs4sArRwsIcpNOWomz+3uOdg0xoVZDACU21JqLc4oVUhXN69s6U9xRXhvq8pSYQkmVe7C3IbRHy/Dculjxzl7LG0Yg1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745845743; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/U6oJ6jXg6rCOjENtLT6gdwsDnl79y6N9luEq2gHpt+YPYn9/awOsjm2yYk0coPh0GYxTBzLn8k6SWjivzTjmxFhkK7tRIDjxhJTIRmWQIQLCKwaEDPqIZaPjOH9rlmVCQqJfJG/+SzBreu+BtoIcmvsPN6ZwsjRWu1wDiZolE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qPkkrsKJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qPkkrsKJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qPkkrsKJ96fPyYd89hQ3xQYXoY
	NrdKMjAWJTbwb9LOCjjw6oNvlBAC7JCiDxf2v0nrhBqc4kQVJfD3spQRCnC0R7bXHPVRj0xnS+VJZ
	QF5bZ8Gw67CEM8AackX/AJLJd1rRgbYWQosaBrgyb0PzQcD5pjUjMYQXZVNsLR05nst7T/cNdyhiu
	bdHwdIri7haqIr3+NYna7dglNaKYS4iLRO9C9yC5TWUAt55KgdKvbu+bdJS0uCp1QEvTJXj0SoU2a
	5gbqMPD+A4G3r2EDt7nx3qopNotRfrwR7S+xp38u260JU6aVym1LAGxTqgWdEw9rkyhDbH6lmrEQB
	4cn8h/cA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u9OEF-00000006Omz-05CB;
	Mon, 28 Apr 2025 13:08:59 +0000
Date: Mon, 28 Apr 2025 06:08:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
	ubizjak@gmail.com, akpm@linux-foundation.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH v2 5/9] block: export API to get the number of bdev
 inflight IO
Message-ID: <aA996mcR25M4iawP@infradead.org>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-6-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427082928.131295-6-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

