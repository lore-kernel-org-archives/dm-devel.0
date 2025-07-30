Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EED51E0DE8;
	Wed, 30 Jul 2025 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753899696; cv=none; b=B7M/5LzFst8YJT++Cewi13QxfAn//mGtgTwpur7hYJbGhLM4VzTUSZ3uvV8ggy53fR3PbqSDKzGfzZgUsx7G5Svw/oIPMKcGL7eUHDPvlzNw2L+Yy475t8YU/zOrtdoiEJi2kk8M+fR5mE5/1y63yR3ENznD5s58lJI335Nhtuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753899696; c=relaxed/simple;
	bh=UpvXeVNarbyUdGqDIl8DKREUkKHQZ56TiDkR/cfavA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sMxnNNwvGZbaUPzVSPUM/Mtj2atAcKkvyQh0FukzVDjnvv9jiaqpKNAikT/3EvpXxXIyXj2U6frKwUQEv42H8s+NJ1ETZF3iBSe4O8owPTOWl0KsKSVmPS47nLZYtx5KISrbh8PoDVCwMLcisiI0CpLURqQ6AV42bE1CaZSfZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yq2X1Gr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yq2X1Gr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4CEC4CEE3;
	Wed, 30 Jul 2025 18:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753899696;
	bh=UpvXeVNarbyUdGqDIl8DKREUkKHQZ56TiDkR/cfavA4=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Yq2X1Gr+okL0KlZfaDtFVXlLTd7B3aikJ6ParYUUEzFB+nF/A4YaV4PwVr9wOL2Fv
	 gy/H8/B+CM3sZI0BgP1yBQjrE6zjsH+LZUIcRxO3ZOHa7bC3y+wWPbyriCJtMOTb/4
	 F9nhQtj51eTjbkHTaOebVyrvfCb3pLAAwqZubhd9I5hjx2IDVLNyiwxaJH0deljc8N
	 1Y8BRA2rTEkjAdQlrIv9XhL05bm1CbHHOurnXq3hXtq/If3DbwTPnW2BFxFsWKocEl
	 CF5XErzfE8shS7SbC8Q/hd2Lz8ZAtUDynoHWTYNFCSq+PxyS9WZsawSdUBN0YCkheP
	 EMutuL6i116Kg==
Message-ID: <063582fe-b441-4325-9060-2b6bc2bd09c2@kernel.org>
Date: Thu, 31 Jul 2025 02:21:30 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH v5 00/15] md/md-bitmap: introduce CONFIG_MD_BITMAP
To: Yu Kuai <yukuai1@huaweicloud.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250707012711.376844-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <20250707012711.376844-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/7/7 9:26, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v5:
>   - rebase on the top of md-6.17;
>   - fix compile problem if md-mod is build as module;
>   - fix two problems for lvm2 dm-raid tests, patch 5,13
>   - other cleanups;
> Changes in v4:
>   - rebase on the top of other patchset;
> Changes in v3:
>   - update commit message.
> Changes in v2:
>   - don't export apis, and don't support build md-bitmap as module
>
> Due to known performance issues with md-bitmap and the unreasonable
> implementations like following:
>
>   - self-managed pages, bitmap_storage->filemap;
>   - self-managed IO submitting like filemap_write_page();
>   - global spin_lock
>   ...
>
> I have decided not to continue optimizing based on the current bitmap
> implementation, and plan to invent a new lock-less bitmap. And a new
> kconfig option is a good way for isolation.
>
> However, we still encourage anyone who wants to continue optimizing the
> current implementation
>
> Yu Kuai (15):
>    md/raid1: change r1conf->r1bio_pool to a pointer type
>    md/raid1: remove struct pool_info and related code
>    md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
>    md/md-bitmap: merge md_bitmap_group into bitmap_operations
>    md/md-bitmap: add a new parameter 'flush' to bitmap_ops->enabled
>    md/md-bitmap: add md_bitmap_registered/enabled() helper
>    md/md-bitmap: handle the case bitmap is not enabled before
>      start_sync()
>    md/md-bitmap: handle the case bitmap is not enabled before end_sync()
>    md/raid1: check bitmap before behind write
>    md/raid1: check before referencing mddev->bitmap_ops
>    md/raid10: check before referencing mddev->bitmap_ops
>    md/raid5: check before referencing mddev->bitmap_ops
>    md/dm-raid: check before referencing mddev->bitmap_ops
>    md: check before referencing mddev->bitmap_ops
>    md/md-bitmap: introduce CONFIG_MD_BITMAP
>
>   drivers/md/Kconfig      |  18 +++++
>   drivers/md/Makefile     |   3 +-
>   drivers/md/dm-raid.c    |  18 +++--
>   drivers/md/md-bitmap.c  |  74 +++++++++---------
>   drivers/md/md-bitmap.h  |  62 ++++++++++++++-
>   drivers/md/md-cluster.c |   2 +-
>   drivers/md/md.c         | 112 +++++++++++++++++++--------
>   drivers/md/md.h         |   4 +-
>   drivers/md/raid1-10.c   |   2 +-
>   drivers/md/raid1.c      | 163 +++++++++++++++++++---------------------
>   drivers/md/raid1.h      |  22 +-----
>   drivers/md/raid10.c     |  49 ++++++------
>   drivers/md/raid5.c      |  30 ++++----
>   13 files changed, 330 insertions(+), 229 deletions(-)
>
Applied to md-6.17
Thanks

