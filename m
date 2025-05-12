Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118A0383
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 05:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747027048; cv=none; b=AOZZbrzXdOXI9DFgYR2r1D2rCJ7hgEacL4uk/qVfxPFaPeHDOexEqbRTOvr8M3V2PTPQqPnFRCNrXB+ZHHqn3FoIYy2WsSsjddqNdA+OOG/ZmNS98MetADlhzDE9dSe83sXsL1qO8MWCKjZ2pvSr1sTGQ1I7dq500wAMZtTrKGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747027048; c=relaxed/simple;
	bh=oKZ6fQ0lEQ/OEEwLVInzPIoIpvS34AB+dlup+t+pdXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZZJ6uTAjRoB4lUfbUDDL3knUA9j6FhsWFF+zdA+xiOIVPZHezPEAskG3zx5Dcn/0vW0YFFQrnfSQFe+nwrRU630oj1GCHN9/mpKOWJu+Oq/9Lg0OFNDp5vUtGP1efohXCx22X02K3zFFlU/FHO6MGX1VeDSsQuWhTkjkc4rl6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA23168AA6; Mon, 12 May 2025 07:17:22 +0200 (CEST)
Date: Mon, 12 May 2025 07:17:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 15/19] md/md-llbitmap: implement APIs to
 dirty bits and clear bits
Message-ID: <20250512051722.GA1667@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-16-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-16-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:23AM +0800, Yu Kuai wrote:
> +static void llbitmap_unplug(struct mddev *mddev, bool sync)
> +{
> +	DECLARE_COMPLETION_ONSTACK(done);
> +	struct llbitmap *llbitmap = mddev->bitmap;
> +	struct llbitmap_unplug_work unplug_work = {
> +		.llbitmap = llbitmap,
> +		.done = &done,
> +	};
> +
> +	if (!llbitmap_dirty(llbitmap))
> +		return;
> +
> +	INIT_WORK_ONSTACK(&unplug_work.work, llbitmap_unplug_fn);
> +	queue_work(md_llbitmap_unplug_wq, &unplug_work.work);
> +	wait_for_completion(&done);
> +	destroy_work_on_stack(&unplug_work.work);

Why is this deferring the work to a workqueue, but then synchronously
waits on it?

