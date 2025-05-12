Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DF8255F3E
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 06:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747032000; cv=none; b=smBy0vKmPp1BXLqczNwzrldS/hX7u72clq2Z1/q/3CsMiz0UcYFDrmRk6zeMAUNZbxMzqRFIuz2Jdi27TD4fPXJrpAQtZHoMmM8XneXwf8vA8Ku2Ty9kVQw6v0Ff4Kl7Ah7QbuBsFGOlbznqxp04xqLeKYGgN28em3exRUrcSRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747032000; c=relaxed/simple;
	bh=nD18MxVqS3twsiuQNRlgOXC20wqcGDuUTQ0HEAsKLAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nV5IyMHElgnmjjiiMXSHyx0GiG+UY8odYU3ntfgtseVYVHVa5u9RKfbp+0VXwGRhNxjCsjMYqPnfeLC2PLOTHov6/tqgrAdM0XH6PUcamQLdEtAuRqv7vKXkxjKfPSnxRR0k6ukmULNi06wEskWI6eighf4vRwT1NBeNAbL90w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5C79868AA6; Mon, 12 May 2025 08:39:53 +0200 (CEST)
Date: Mon, 12 May 2025 08:39:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC md-6.16 v3 06/19] md: add a new parameter 'offset'
 to md_super_write()
Message-ID: <20250512063953.GA3449@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-7-yukuai1@huaweicloud.com> <20250512045511.GF868@lst.de> <491de6df-9b9b-3152-c2ca-1bc3a0ac8b68@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491de6df-9b9b-3152-c2ca-1bc3a0ac8b68@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 02:32:28PM +0800, Yu Kuai wrote:
> Ok, how about md_write_metadata()?

Sounds good.

