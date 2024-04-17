Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B978B1422A2
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713366205; cv=none; b=Lpv3wJCNZfi1g5yZZN7/h3vMUxkUU9MNrwXt//GEKCYpcL05kHmOKRY9gNAqcyhPYu07lVh6ZA37F1Bo4yWE9TNXF16ssNdWdHYDfkec0IVmLodWHLwLMeSoFu/bB5spdsrC+3ke8CbMt0vrlZh4uHmPMQfx3ILEtTwduNRD1CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713366205; c=relaxed/simple;
	bh=m72dq8JJ2rx7jrP/jTIhckYmkVUvPOj708c9DIwFjIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OviD4ozLHMnhHG2R4TnV7ngQCWehdfNd2QRvhbQ4ch74mgjfbD7ozpiXtV+QGm+GmqJvT0swjCd9bUpbYzmtapXpJ/6ThagywUol7hcRLKK0aE8IwvtwgLWOz+npNDOklnPHZGIMt0qnZM4mm7Fq7BYL1OuYHqZZ6Su1dn6+f1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 40361227A88; Wed, 17 Apr 2024 17:03:13 +0200 (CEST)
Date: Wed, 17 Apr 2024 17:03:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sven <dm-devel@schwermer.no>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev
Subject: Re: dm-init/dm-verity: Data device lookup failed
Message-ID: <20240417150313.GA1914@lst.de>
References: <b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no> <20240409142323.GA22617@lst.de> <ba299ab0-9b70-469f-8c1b-bf88465df63f@schwermer.no> <20240415073829.GA32688@lst.de> <847a0907-b174-4ba2-90b0-3be96db2e2da@schwermer.no>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <847a0907-b174-4ba2-90b0-3be96db2e2da@schwermer.no>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 15, 2024 at 03:02:25PM +0200, Sven wrote:
>> Yea, the early lookup behavior is weird.  But it also dates back
>> a long time, so I'm not sure this changed, except for maybe timings?
>
> This might just be a timing change. I don't know. As mentioned in the 
> initial email, this change looks relevant: 
> https://lore.kernel.org/all/20230531125535.676098-19-hch@lst.de/

Well, only in terms of timing.  But as asked before, any chance
you could try to bisect the issue?

>> If you go down the device open route it should us the kernel open
>> routins and not just the not open ones.
>
> OK. Would you mind elaborating why?

Because the no open ones are competely internal.

>> That being said the right
>> fix is to not use this code at all, which was only shoe horned together
>> and doesn't have a chance to work solidly and just wait for the
>> device in userspace because we do have reliably udev events there.
>
> I cannot wait for user space because my root device is dm-verity-backed 
> which is why I am using dm-init in the first place. And I am not using an 
> initramfs.

But that's exactly the use case the initramfs is made for.

> Isn't the point of dm-init to be able to use e.g. dm-verity for 
> the root device or did I misunderstand the docs?

It's sort of the point, but dm-init is a really broken concept and
should never have been merged as the whole early bdev lookup is a
hack and only works outside the core init code by accident.

