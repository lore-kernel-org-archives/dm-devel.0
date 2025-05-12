Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD7C139D
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 06:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747030367; cv=none; b=Ah5rPTqjp9NSLEEP1TXi0kOiEDbvz6Iu+DxoIzJPUD4uQeMdfmFZjRTMoX4OPocSHryDhcBRoI2/PrMD1RimUhTsxXmNfgLcoFDL8By7A9QiE/glrevd8e7O71xEF/QpG4zIet5n78Ce0HsUKoz56A0wz7dtW8l1aRT3KFbX/JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747030367; c=relaxed/simple;
	bh=a8MhP0qvnE8NBYAdMZkc2jdiJdR6UYuKBOFAto/wdjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCrGAZkkQj6VrtfSXeK6NL8FKeLO3lNh36Zm8enurLoWePAVTvD+YRPoOFXhgw8hEK2i6BEb4tYtkR7YGvw7d3mjvqFZHuQJGdkuV8w0NpefmFK/mE2XqqehX4Gmv5YxjMiNgEbxCPr6L6VjpDqCLTwYdnQpkZx/60EIl26j+J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 27B5268AA6; Mon, 12 May 2025 08:12:40 +0200 (CEST)
Date: Mon, 12 May 2025 08:12:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC md-6.16 v3 02/19] md: support discard for bitmap ops
Message-ID: <20250512061239.GA2893@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-3-yukuai1@huaweicloud.com> <20250512044125.GB868@lst.de> <2830c5d0-cc04-51eb-6785-79d0a43f4fc4@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2830c5d0-cc04-51eb-6785-79d0a43f4fc4@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 02:05:56PM +0800, Yu Kuai wrote:
>>>   -	mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
>>> -				      md_io_clone->sectors);
>>> +	if (unlikely(md_io_clone->rw == STAT_DISCARD) &&
>>> +	    mddev->bitmap_ops->start_discard)
>>> +		mddev->bitmap_ops->start_discard(mddev, md_io_clone->offset,
>>> +						 md_io_clone->sectors);
>>> +	else
>>> +		mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
>>> +					      md_io_clone->sectors);
>>>   }
>>
>> This interface feels weird, as it would still call into the write
>> interfaces when the discard ones are not defined instead of doing
>> nothing.  Also shouldn't discard also use a different interface
>> than md_bitmap_start in the caller?
>
> This is because the old bitmap handle discard the same as write, I
> can't do nothing in this case. Do you prefer also reuse the write
> api to new discard api for old bitmap?

It can just point the discard method to the same function as the
existing write one.

