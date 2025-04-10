Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4261CEEBB
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 07:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744271678; cv=none; b=NKnbQ7fVhiuqyCDS7fzsUwSyBY3k6llkwplyx7wAiHLKzAvRdmQ4UGFmSdEKEGihJlBKlH4R+/XNq5QzgZCBq4rAj7haUqJQgDT6PRVH1fA7Zlr6XgbeiEkNMrtR+vOLy5ISray3BisRElib3LFZmMoAF/AwFhZEObFSk3EPeOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744271678; c=relaxed/simple;
	bh=rA4bvuWBjJKOBUCPGayHQVRp9xmtmURDLDww5Eb7VrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZM9SCLkOHfJD0InaFzXCNgy6gdT3YJ6PLgKG3/6KcJTrgAq+TN0zi0XoTi+C+zWzcC82oUOTVlPRG3eWs2Z/4tqFWqCPwS3JfWU8nDOOv+HS3XOalj/D+arKrD21Od8AU1M41sRWsWtIZfO7nxAYya3r+aG48+IMRo0Eo1o9lLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CCE7468B05; Thu, 10 Apr 2025 09:54:31 +0200 (CEST)
Date: Thu, 10 Apr 2025 09:54:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] dm-delay: Prevent zoned write reordering on suspend
Message-ID: <20250410075431.GA763@lst.de>
References: <20250410043311.990675-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410043311.990675-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 10, 2025 at 01:33:11PM +0900, Damien Le Moal wrote:
> When a dm-delay devie is being suspended, the .presuspend() operation is

s/devie/device/

> first executed (delay_presuspend()) to immediately issue all the BIOs
> present in the delayed list of the device and also sets the device
> may_delay boolean to false. At the same time, any new BIO is issued to
> the device will not be delayed and immediately issued with delay_bio()
> returning DM_MAPIO_REMAPPED. This creates a situation where potentially
> 2 different contexts may be issuing write BIOs to the same zone of a
> zone device without respecting the issuing order from the user, that is,
> a newly issued write BIO may be issued before other write BIOs for the
> same target zone that are in the device delayed list. If such situation
> occurs, write BIOs may be failed by the underlying zoned device due to
> an unaligned write error.
> 
> Prevent this situation from happening by always handling newly issued
> write BIOs using the delayed list of BIOs, even when the device is being
> suspended. This is done by forcing the use of the worker kthread for
> zoned devices, and by modifying flush_worker_fn() to always flush all
> delayed BIOs if the device may_delay boolean is false.

Is that scenario specific to dm-delay?  I think the same applies to
any other target that supports passing on bios to zoned devices.

>  	spin_lock(&dc->delayed_bios_lock);
>  	if (unlikely(!dc->may_delay)) {
> -		spin_unlock(&dc->delayed_bios_lock);
> -		return DM_MAPIO_REMAPPED;
> +		/*
> +		 * Issue the BIO immediately if the device is not zoned. FOr a
> +		 * zoned device, preserver the ordering of write operations by
> +		 * using the delay list.
> +		 */
> +		if (!bdev_is_zoned(c->dev->bdev) || c != &dc->write) {
> +			spin_unlock(&dc->delayed_bios_lock);
> +			return DM_MAPIO_REMAPPED;

Don't we only need to do that if anything is queued up due to a
suspension?  Then again having a different patch might be premature
optimization, it's not like anyone cares about dm-delay performance
almost by definition :)

