Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BB71DF246;
	Fri, 28 Mar 2025 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743160020; cv=none; b=QGzhZNKiUmqpId/jUhdaK9ZPZHbyrIoA4DPdVWCDPnDKTmFBWx23kVKrfah0TFuDwBmK+oLQWXZy2I7Gf5HGZCQXlpK1TxNuHIj5H/E/YQYZJCi1ziD7b5wPEta7PM7rqYn4Jo4j3YkidqO7nJUxo5Lh2RWUj/Na7e+D+taEGcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743160020; c=relaxed/simple;
	bh=vlOlmW9KO7oVmct0A7/zRYxbjGbpk1FmSIPKX0Vrncs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6FtrBDBV234mJ3/foxy3wH9LCWvdnrzHAakWbox/Z/kdBSRDEZ+M3FEZiRM901Xp7iVZAs0KQLHdx1zNVr3xhk43RzZD41++WIWysRrer0VaB77CE9Bd8cvccJJ0nmN8XW/+j/OVP5oWLTwz63dRBJiq7Rkvb4GvT9W+a72VJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yibfvNpC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yibfvNpC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MEk4NSA1v+dGQE7hHTgemcONq+WahlFx/Qj7xxfHe+8=; b=yibfvNpCYi+7xdbiVzXu8Q5FPN
	E34kemxA2oF0hr7yZ+Xd69KuWYjZkRVFcfTrggz6KiqcJDap2wOocMQGiVRVZsGRhzddluPPdd1TG
	tVPQerX4or+uvkTf443W3xH8SpFsog2+UWUNd44bZjdwIxIznWYbg4Op3Ytkjru6Q5pcc2FNCyRl6
	aimzl0f0QzO+6uFOMxQjXD+iYRKGwc1RLlKkk0RZaTCZWKbywyctfT0Ms/RvzdfzpRlXbUcrSznzO
	2mj+AqrtStcaaYEXw63bifxy0Vq74eSntss92d3qJw5H9bcoxXtYm2bwmp2RQjxeXgz9H9oh/6hdM
	QHw1RAbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1ty7Y5-0000000DCqK-0Bli;
	Fri, 28 Mar 2025 11:06:53 +0000
Date: Fri, 28 Mar 2025 04:06:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, axboe@kernel.dk,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, yukuai3@huawei.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
Message-ID: <Z-aCzTWXzFWe4oxU@infradead.org>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 28, 2025 at 02:08:39PM +0800, Yu Kuai wrote:
> A hidden disk, named mdxxx_bitmap, is created for bitmap, see details in
> llbitmap_add_disk(). And a file is created as well to manage bitmap IO for
> this disk, see details in llbitmap_open_disk(). Read/write bitmap is
> converted to buffer IO to this file.
> 
> IO fast path will set bits to dirty, and those dirty bits will be cleared
> by daemon after IO is done. llbitmap_barrier is used to syncronize between
> IO path and daemon;

Why do you need a separate gendisk?  I'll try to find some time to read
the code to understand what it does, but it would also be really useful
to explain the need for such an unusual concept here.

