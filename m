Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934F21EEA38
	for <dm-devel@lists.linux.dev>; Fri, 31 Jan 2025 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738342477; cv=none; b=JlFdf/AOVHBjTEU/nPhCI/Na4tqK7BbUVJ8N9v/+cN8bJXABEQsOtEVslujKZSLiChq+Ajy0leANl+ZC1/U8sjYS/k8abtIoZigNOMW3vkCuwzmW0pfW1pNJgx+d3H6Uvye6kqoWmvTpN8JZGMEFSCeQ3gT7+GtzbSkwr7ys2KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738342477; c=relaxed/simple;
	bh=T4w4l/ML8sG/6PL1ZLUlQtOeG//l3YrKy+fXjPA3kgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rHIe/CoP8E+WznGIu4325weS06/diky9YPW3ieCGLLT60EGy1b+Z7ZPqcSBpPWCBCxqlA22bsPhemqyX6ewMkG2hNfR8eQUnyXNQzkEsIPO0rugbp2C5+bd13gLmLVlcuf+LTj2dquavcMXEL0EHzmOxgCd5GsWJIH5mMVvDpCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vWKEvn6v; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vWKEvn6v"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Yl26x6LbZz6ClY99;
	Fri, 31 Jan 2025 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738342466; x=1740934467; bh=H5OxaIOFfU0Kvkdx0QEkv/B1
	Xo6nZgwqF8qHcl2XHts=; b=vWKEvn6veUFMlK4Keshv1At+q+I6MZqhbjU5cSNL
	YCgRV5p3q2l1o3zFSExt17y6OQ7b37Ru++SM1yCmXCBrmrUjLZ+tEGN0h4d/CJ/D
	NpfyS7qIwJyjCxZI7umt1HvmQI4vlozmQ1M6hfvTAMeaVU/7z3PMkT8ZFuOqS2YI
	Mfl+sEPuYSQaVkginaobADpNnz5aBfVKTydLybWrpBMciKfth9+YtQK3GbPPv2AZ
	3xNINyPsLte7/PsOwkcdx5F4oqh4USohEKTBaE0bGpU1uOSsVWvzFmlhu9W1RD7n
	8mFvlVOHPdpxiBNrutiENNhJFhGsvWQoKGgMEbgUcze26g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TQKAQK4UugGM; Fri, 31 Jan 2025 16:54:26 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Yl26k6bm9z6ClY95;
	Fri, 31 Jan 2025 16:54:22 +0000 (UTC)
Message-ID: <89bc6dd3-4015-409f-bb1c-2a957171cfd0@acm.org>
Date: Fri, 31 Jan 2025 08:54:21 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] block: mark bounce buffering as incompatible with
 integrity
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 target-devel@vger.kernel.org
References: <20250131122436.1317268-1-hch@lst.de>
 <20250131122436.1317268-2-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250131122436.1317268-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/31/25 4:24 AM, Christoph Hellwig wrote:
> +	if (lim->features & BLK_FEAT_BOUNCE_HIGH) {
> +		pr_warn("no bounce buffer support for integruty metadata\n");
> +		return -EINVAL;
> +	}

integruty -> integrity

Thanks,

Bart.
