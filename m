Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A704A23
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 04:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747025847; cv=none; b=Etka1QHpb71sj1VZDY4eJIinB7PuBFTtLGPnAnNde3/drswxtuvSFwndare3r9aYG+C09WvzmOIYwFlyNwSf9gYK71kv/3fPXLIoGT2zrR1uZiZd+ThRwvDkAbPGDDdk0k6G/fhY9cYZ6EhLpRnfNj3L0I7PHdpKlPRsFyaSJY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747025847; c=relaxed/simple;
	bh=psWwzrMpJp7cTWX5luQvyXy4eLvNowrlLY+xfNTgmWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7G3y5BJpSKbbRAsO+lHPRzoGif9Vp7qw4lbbUe+LJFS6N50xZV9/ghLl6ZdRAyULExGwx56xcuXxo6GFvV+5WMMErctnAG5YmI6jgfwjNg3evaewAYNWkAnsje24SL+2utc4CrLFONXJmiMLICbEvbQxRiNuFDCHsuA96nOEI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E3DFB68AA6; Mon, 12 May 2025 06:57:21 +0200 (CEST)
Date: Mon, 12 May 2025 06:57:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 08/19] md/md-bitmap: add a new helper
 blocks_synced() in bitmap_operations
Message-ID: <20250512045721.GH868@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-9-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-9-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Btw, both for the previous and this patch: function pointers in
structures are methods, not helpers.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

