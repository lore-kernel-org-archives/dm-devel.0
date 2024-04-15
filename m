Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57432C182
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 07:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713166721; cv=none; b=i9rtzHGufsJNc9RDDLRJjNtuEqoGfa/GUByeGIsmglbvyrE5JuzhPI0kDLuLGCjwSrzmTx+qeCG+HNCGpATtWwndmYz3UCaETN8nTkNRakNFncAdeFeNkd94V4WVynOdqhwKluyP4hPUaxjecUqgNLAm/miETyc6TbabOKTyiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713166721; c=relaxed/simple;
	bh=YOydG6Yb0QjCjsj1xoSvTvJbFQsNturwBvcQUZrbQbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AN/+tW+QlVnBsGEwSCo7HMDp6CN8lVOCxDQA6lHA+G0yBabxmGYp8exj7bVObI55H+CrDDfqp/JrOHbsdv6Kt+6eflQMrdZQ9wnvGtfy/C/nhXRj291gmbq3gyu+EHcr0F1fNOe9yA9f0PBblAGNgg3braF6qxagOYj8AR/G5J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8CC0C68BEB; Mon, 15 Apr 2024 09:38:29 +0200 (CEST)
Date: Mon, 15 Apr 2024 09:38:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sven <dm-devel@schwermer.no>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev
Subject: Re: dm-init/dm-verity: Data device lookup failed
Message-ID: <20240415073829.GA32688@lst.de>
References: <b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no> <20240409142323.GA22617@lst.de> <ba299ab0-9b70-469f-8c1b-bf88465df63f@schwermer.no>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba299ab0-9b70-469f-8c1b-bf88465df63f@schwermer.no>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 12, 2024 at 11:13:27AM +0200, Sven wrote:
> Hi again,
>
> I have found out some more about this issue:
>
> When dm-init succeeds in finding /dev/mmcblk0p3, it actually only finds 
> /dev/mmcblk0 and NOT the partition block device (see behavior in 
> devt_from_devname).
>
> Subsequently, when dm-verity looks up the data device (/dev/mmcblk0p3) via 
> dm_get_device, the following call stack is executed:
>
> dm_get_device
>  dm_get_table_device
>   open_table_device
>    blkdev_get_by_dev
>     blkdev_get_no_open
>
> blkdev_get_no_open actually returns -ENXIO because the partition device is 
> not available yet. That error then propagates back.
>
> A naive fix that works for me follows:

Yea, the early lookup behavior is weird.  But it also dates back
a long time, so I'm not sure this changed, except for maybe timings?

If you go down the device open route it should us the kernel open
routins and not just the not open ones.  That being said the right
fix is to not use this code at all, which was only shoe horned together
and doesn't have a chance to work solidly and just wait for the
device in userspace because we do have reliably udev events there.

