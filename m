Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF77C5475E
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 04:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747024753; cv=none; b=cB7Fxp1Mgxu5O+7k0dK8Bmc62kKRCIZGbjOtbe2hiKCseGWCyOoeNwg4yabGmak8fgKYKzUWp5oonGtSJ7X1bJfXjDGbuEBPtqOzRFfXDQH5y09W19EUrOr4eT8XaWbzVJYjCZu1rur33oOebHbx6GnIcvseo7Iv7XF4t7IgP2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747024753; c=relaxed/simple;
	bh=YrMs+kgoFJzR/eaWb3BozlxjxJGaAYDHE0xeBukMsY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5H7FysOEnV11ayShfBu4RAlQvJ40fGS8G2RgIQ0HqFpEwHe3XEniSUzLksJ5aQsaDKJfEuNhhsd5H69oDEt0sVHy3MxV5ivq7nFXRElUA+ROZ8puwKSJShD+xCnJRTsn5bmEY11hLjTH0ZF7Z1a3RjFvdIWGbYvVoeB1rIsYGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0A89668AA6; Mon, 12 May 2025 06:39:07 +0200 (CEST)
Date: Mon, 12 May 2025 06:39:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 01/19] md/md-bitmap: add {start,
 end}_discard in bitmap_operations
Message-ID: <20250512043906.GA868@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-2-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-2-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:09AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Prepare to support discard in new md bitmap.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

