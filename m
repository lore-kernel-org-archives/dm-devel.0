Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6E651C40
	for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 09:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941520; cv=none; b=pHc8kI7u4LQP+6qea3KVF/zZG9KTUrGaakBRWbwkAycDB7FgyWIQSjQ8uD1ixLULKV50lgy1aZMrnW9/pjB4wYgajoQEGu5c3ULfa7M+h8z1Gc3G0x8OR7EJYoTIXnt9Q3xmyME8OCs+LOea/B7K32suAm4pa5dSwtua9bKc1+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941520; c=relaxed/simple;
	bh=Oj72ZDYXvE7wY3UPhwSNYcoZRO7uatVhMexptiLM55I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISjK/gNQ00KzusExQ8e4WmBK1/bHia5t3X5X02MGTljoGGns22/xMvJQxRbFU+SJLTCRGEGkavU6xUzgx0Ebi46jRxxVvCYAn3QRVHVRtcMq/Q8CIgX/Q6Cg+0IqVed8wAvwxhiTsyO5X76WBuC7fQu5vgJtmn35agl9mCxpZA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E7AA68CFE; Mon, 26 Feb 2024 10:58:29 +0100 (CET)
Date: Mon, 26 Feb 2024 10:58:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] common: dm-error now supports zoned devices
Message-ID: <20240226095829.GB26465@lst.de>
References: <20240221063741.3563039-1-hch@lst.de> <20240225163828.7a3tntpg5kaywlw7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240225163828.7a3tntpg5kaywlw7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 26, 2024 at 12:38:28AM +0800, Zorro Lang wrote:
> This patch makes sense to me, but I think this patch might cause
> failures on old kernel which doesn't has kernel commit a951104333bd, right?
> 
> Is there a simple way to check if dm-error supports zoned block device? If
> there's not, I think we have to let it fails on old kernel, to make it run
> on newer kernel.

I don't know any way.  But as this just affects zoned devices on btrfs
for now I guess the usual parties can just make sure it works by
backporting the right patches.  The previous don't work wasn't even
a not supported, but a case of dm-error being buggy for zoned devices.

In other words the original exclusion in xfstests should have never
gone in and whoever put it there should have fixed dm-error instead.

