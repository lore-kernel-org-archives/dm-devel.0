Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEBA294A16
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056407; cv=none; b=FbIoWr+zLVYAJN73xexxnCRnvNO//5qM0S+8wNyvDBBOJRkq/SJD1UZHKAssvZW11+GqeLZQ9nZDRnzeawN5HwNx5wqGfgEYGJMttb65mMpdosBtCRWeI/dBe/dmMrg0E9Wxf3NAmLmGse7shTU2qGoq60XoTHwX1DdXKrISnSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056407; c=relaxed/simple;
	bh=juaEZH1+tvcoScTwEGGK4KkT1GOC2QS3hb52NpKVXUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkIK3yq3JYFdwKB6Tm+hxMUD+IfLVxXyzzWdr9JtKd4vpFMvMmwIFUkbQITlw6ZjdGMqB+mmkIomFMLpw/CFQmZnX5HdoQgLYPGsuqP0vzM060ki9sM34W17Hprp/cN3HxSTfYuULktYF2lqRI6PDglK1qnCqdDni5CnJ2mCHnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E8B6568B05; Mon, 12 May 2025 15:26:41 +0200 (CEST)
Date: Mon, 12 May 2025 15:26:41 +0200
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
Message-ID: <20250512132641.GC31781@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-16-yukuai1@huaweicloud.com> <20250512051722.GA1667@lst.de> <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 04:23:55PM +0800, Yu Kuai wrote:
>>> +	INIT_WORK_ONSTACK(&unplug_work.work, llbitmap_unplug_fn);
>>> +	queue_work(md_llbitmap_unplug_wq, &unplug_work.work);
>>> +	wait_for_completion(&done);
>>> +	destroy_work_on_stack(&unplug_work.work);
>>
>> Why is this deferring the work to a workqueue, but then synchronously
>> waits on it?
>
> This is the same as old bitmap, by the fact that issue new IO and wait
> for such IO to be done from submit_bio() context will deadlock.
>
> 1) bitmap bio must be done before this bio can be issued;
> 2) bitmap bio will be added to current->bio_list, and wait for this bio
> to be issued;
>
> Do you have a better sulution to this problem?

A bew block layer API that bypasses bio_list maybe?  I.e. export
__submit_bio with a better name and a kerneldoc detailing the narrow
use case.

