Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025F925A2BE
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 13:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056308; cv=none; b=cWORRSO2ATVQ6g5M1qXeAxPoxPDVjterFfxOnNls4iLhn76sO6M5FFBwdwTQaoRuhFLQuRA8poD+k0276MHSvF5wOX+Zq/AxhDtvSL2Ry0vQYB8J88miN/QM8gGTloLqLRR6MQv1rdIvv1nLLo/r/SXZpHkhuraiH7XKP822HhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056308; c=relaxed/simple;
	bh=kdsDvnZPZoAfXMO5GhHs6R1AbdbWLUK0iToTQa2FFTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+C5W/VGJQCeDaZ0IrX4lDqT/6adGJj1BiKvMJjIlL5ny+1kNkyUXdcLPOgLn88O7nVLq/cOUJlwDmPtG/Ds+azmqOEl5Gea4Oz9y8jQW8KM4MtaoI/href4b/miTyD0p3UsIsZcHhg81QyKqTfRRpx+CQeMRLhns9TW26ER4Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1F48E68B05; Mon, 12 May 2025 15:25:03 +0200 (CEST)
Date: Mon, 12 May 2025 15:25:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC md-6.16 v3 11/19] md/md-llbitmap: implement bitmap
 IO
Message-ID: <20250512132502.GB31781@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-12-yukuai1@huaweicloud.com> <20250512051519.GA1555@lst.de> <a2d1a5c4-c041-064f-307e-eaa677e5a81c@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2d1a5c4-c041-064f-307e-eaa677e5a81c@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 04:15:34PM +0800, Yu Kuai wrote:
>>> +static bool is_raid456(struct mddev *mddev)
>>> +{
>>> +	return (mddev->level == 4 || mddev->level == 5 || mddev->level == 6);
>>> +}
>>
>> This really should be in a common helper somewhere..
>
> Perhaps md.h?

Sounds good.

