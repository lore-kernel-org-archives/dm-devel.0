Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C9A2550C5
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 05:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747027155; cv=none; b=D82e3etRmMwpCFwPI8oo5K1ydC6L0Xltxe04MB+CS8lP3SM3aCLcyIOUM4m7kQ7zYYTS1QvDm8fY8V1R+gvzF/JqgQ61UisqkbFwuBcM2qdoZroeAtrZU6m7zqlVdUNLKR9Xk/cqmNlFDvXgJ0sl9tqsHuv8roq24L4cNCGNN/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747027155; c=relaxed/simple;
	bh=kI69Ed7rhq0jbTbAmM10jKuXVO07gLDLSpqkfefSbWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSNtBh39oVB9Yv96jT+JnxKd5pMIqAt8Rg9WVmSLABhJkmNfCH1tMsRH4btO7p8d6x4Ub7kYD+2xMGzA7krafRN2qJrDaavHaUVGMq1JxucxrBMGsdFojx18vdqMbk5DcFFe5ez1D9MslmUqJp6PzOLuccQUiYznRJNoceXKPSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3607F68AA6; Mon, 12 May 2025 07:19:10 +0200 (CEST)
Date: Mon, 12 May 2025 07:19:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 19/19] md/md-llbitmap: add Kconfig
Message-ID: <20250512051910.GC1667@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-20-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-20-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:27AM +0800, Yu Kuai wrote:
> +config MD_LLBITMAP
> +	bool "MD RAID lockless bitmap support"
> +	default n

n is the default default.

> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 4e27f5f793b7..dd23b6fedb70 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -22,6 +22,9 @@ typedef __u16 bitmap_counter_t;
>  enum bitmap_state {
>  	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
>  	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
> +	BITMAP_FIRST_USE   = 3, /* llbitmap is just created */
> +	BITMAP_CLEAN	   = 4, /* llbitmap is created with assume_clean */
> +	BITMAP_DAEMON_BUSY = 5, /* llbitmap daemon is not finished after daemon_sleep */

This should go into patches very early in the series, before the code
referencing them.

