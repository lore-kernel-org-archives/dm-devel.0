Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B7A3D81
	for <dm-devel@lists.linux.dev>; Mon, 21 Apr 2025 07:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745221175; cv=none; b=WQmh3XuJyVmbFWZuCmk9a2z5iNgb01BJAU5qo6F3wNWAeOUZ9LcYCyin5ixwj2ncc6emWFWvqGM/fxhL6rvnFqL/dUzucZIcl+JI9AxGMJ+DPEp7pwdeQd14OA1HluWaZDlxV5Ucey8O64lzN/VltzE6SD1QdjZoKCPEDndsQus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745221175; c=relaxed/simple;
	bh=boRLROJn4ucEtnjOb76u7xegVX7n55u48HuLH2Zc5uQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNws1mHA59ZprQlsfZDmWi7umNTjQjHYZrBH0Mz3pd7bc3K16bgmZWfrMcL6SMMUr40AwrG8Czx1Q7nTzUu459X8515eR+OW3rUoFg4DdKz+zSuZ6gzIN8jGubJUhQAeLByiFrG0gpwbJP74pfjEkBS4Qg2DS4gDu2fmgmlMNI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2CA067373; Mon, 21 Apr 2025 09:39:22 +0200 (CEST)
Date: Mon, 21 Apr 2025 09:39:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
	mpatocka@redhat.com, song@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com, kbusch@kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
Message-ID: <20250421073922.GA19465@lst.de>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com> <Z-aCzTWXzFWe4oxU@infradead.org> <c6c608e2-23e7-486f-100a-d1fb6cfff4f2@huaweicloud.com> <20250409083208.GA2326@lst.de> <115c3b08-aff1-dd97-fe6a-7901452ce62c@huaweicloud.com> <20250409094019.GA3890@lst.de> <28bb1c35-5f75-4e1c-4b5d-32bcb87050ce@huaweicloud.com> <54ab4291-9152-44d1-bf6c-675b58cfcea8@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ab4291-9152-44d1-bf6c-675b58cfcea8@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Apr 19, 2025 at 04:46:03PM +0800, Yu Kuai wrote:
> So, today I implement a version, and I do admit this way is much
> simpler, turns out total 200 less code lines.

That's what I thought :)

> And can you check the
> following untested code if you agree with the implementation? I'll
> start to work a new version if you agree.

From a very quick look this looks great.
