Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4522E3FC2
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 04:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747025521; cv=none; b=uUs/mEVJQRNhA+4LKbJUEvz//zJG/HD0nn3kCyfCsY2YTnyliSP1nwcLCBOHAA6lfx2fRrq962BNef3xzv5KA+hE3RJ/3HptuLV54cFm1Rj++9EOZFoMfnE/WuwaBcMJ37fu4/PbCRQGqFxSaGB7iMLmUcTl+GAl92s/nYty1nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747025521; c=relaxed/simple;
	bh=nuzymvJ9urfYFge83vIgEUU9ANY2WZuCC0qWpKMcJvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=swoZCi5b7HDAqBxSVEER8waSJtq665k/DTzsd45Da6sf9hPTcdTfUeqz1yQMO+wV5IJFcSLPlLbOhMO6c6u+GgdUv81Qe73XxgryNvN69ekST9VxuxbwUiycx44nQfkFqbp1YpQjFwHMGOKkaocRhZzBVld3IhdMTIiguyiKxpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B44E068AA6; Mon, 12 May 2025 06:51:55 +0200 (CEST)
Date: Mon, 12 May 2025 06:51:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 04/19] md: add a new sysfs api
 bitmap_version
Message-ID: <20250512045155.GD868@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-5-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-5-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:12AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> The api will be used by mdadm to set bitmap version while creating new
> array or assemble array, prepare to add a new bitmap.

Maybe call it type or variant instead of version?

Also this needs a Documentation/ file like for other new sysfs APIs.

