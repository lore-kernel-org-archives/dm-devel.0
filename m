Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA4A32C8B
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 06:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118889; cv=none; b=sgLqB8gO7IVxoXFozNyAifxOqvoIO64v0l/ixCscnGjvxdwDF9zK0Zf9VJe2VDz0+uSXY47UskoomkbdriwTvbaH+C3iaU/ia70fmHtFnlVRYARySz/oS8koTeGm7v3XSeeTbdCvV4ioQbNNU3yNXCnVBr/dDDqhWLFljL++4ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118889; c=relaxed/simple;
	bh=4PLJJYQclSDJxAPd/I6fUc+pgL+dM5fCx2w9Ok0+7DQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cm/lCh8bzDkex3zMuOlk5gF0RrVf9qRjUEpIt4assXzwdd/5/kVSYXO+dcb6Ph6xBbhAL/C0n5BtBjbmnJ23+DafxiWsqwGsH3lZ5owvsb5TbOVnAZqjLPZ/S/WFmPKvW3v3dvQ/+tvRd04Jyt5OK5Cte+f6D0XyOPEFpPNTSdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6783168BEB; Tue, 13 May 2025 08:48:03 +0200 (CEST)
Date: Tue, 13 May 2025 08:48:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC md-6.16 v3 15/19] md/md-llbitmap: implement APIs to
 dirty bits and clear bits
Message-ID: <20250513064803.GA1508@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-16-yukuai1@huaweicloud.com> <20250512051722.GA1667@lst.de> <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com> <20250512132641.GC31781@lst.de> <20250512133048.GA32562@lst.de> <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com> <03f64fc7-4e57-2f32-bffc-04836a9df790@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03f64fc7-4e57-2f32-bffc-04836a9df790@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 13, 2025 at 02:32:04PM +0800, Yu Kuai wrote:
> However, for bitmap file case, bio is issued from submit_bh(), I'll have
> to change buffer_head code and I'm not sure if we want to do that.

Don't bother with the old code, I'm still hoping we can replace it with
your new code ASAP. 

> +       BIO_STACKED_META,       /* bio is metadata from stacked device */

I don't think that is the right name and description.  The whole point
of the recursion avoidance is to to supported stacked devices by
reducing the stack depth.  So we clearly need to document why that
is not desirable for some very specific cases like reading in metadata
needed to process a write I/O.  We should also ensure it doesn't
propagate to lover stacked devices.

In fact I wonder if a better interfaces would be one to stash away
current->bio_list and then restore it after the call, as that would
enforce all that.
