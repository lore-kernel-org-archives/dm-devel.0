Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3A33EA98
	for <dm-devel@lists.linux.dev>; Wed, 14 May 2025 05:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199874; cv=none; b=LHM3IuOCEEs6CyGv2ymQW2ueHkkVqQ9yReuZVo5quxahxLJi8kq+m1qtWP732zPNG2grVlS5UoDCMLJufvs3uQ6tbsILuIhcsHes8yMbru+FEMqFqOyY7hyBqtCYCZM0u3rsyxxCLnPD7WU2L5pl1xoXY6r5B7pZRIgVOz9972A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199874; c=relaxed/simple;
	bh=B8/PYLnIVwapTuCP6BmW6RrckGy6HOia+4hp75e9Px8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZCQS4kEG7Hqva9kKoD83vlzFA86tP3zncfF6DtZnrSbQ/ecb3UQXjGAdB9RIMVX1wg1NyiGNcJiIcEO8O6WqFHMnqDX3mWSnHRhZtqqtXYs0Ogcu2CHH1W/CbcQAXJsMGoV0gFXDeabEfPgCtPEO98WaYOIZ/9vbBhE1IYYMJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 798E068AA6; Wed, 14 May 2025 07:17:47 +0200 (CEST)
Date: Wed, 14 May 2025 07:17:47 +0200
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
Message-ID: <20250514051747.GA24503@lst.de>
References: <20250512051722.GA1667@lst.de> <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com> <20250512132641.GC31781@lst.de> <20250512133048.GA32562@lst.de> <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com> <03f64fc7-4e57-2f32-bffc-04836a9df790@huaweicloud.com> <20250513064803.GA1508@lst.de> <87a53ae0-c4d6-adff-8272-c49d63bf30db@huaweicloud.com> <20250513074304.GA2696@lst.de> <d5ae7af0-dd73-7d6b-f520-c25e411f8f06@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5ae7af0-dd73-7d6b-f520-c25e411f8f06@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 13, 2025 at 05:32:13PM +0800, Yu Kuai wrote:
> I was thinking about record a stack dev depth in mddev to handle the
> weird case inside raid. Is there other stack device have the same
> problem? AFAIK, some dm targets like dm-crypt are using workqueue
> to handle all IO.

I guess anything that might have to read in metadata to serve a
data I/O.  bcache, dm-snapshot and dm-thinkp would be candidates for
that, but I haven't checked the implementation.

> I'm still interested because this can improve first write latency.
>
>>
>> So instead just write a comment documenting why you switch to a
>> different stack using the workqueue.
>
> Ok, I'll add comment if we keep using the workqueue.

Maybe do that for getting the new bitmap code in ASAP and then
revisit the above separately?

