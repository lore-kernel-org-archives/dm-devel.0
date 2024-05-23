Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A31263AE
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 14:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475784; cv=none; b=YZBEIOx0J3hCJHQE/53RVRIKOC3Haxn4rG92CJrPG8dnEV0JKbLZvdXj2U+ki01k3t0dLfTlvw1Kdih5jaqvqeXZhO8+el5jaopfdVxc3962n2VPFKizNzHwJ3CbpHA6E4gi/3tNf+yLFV4CbSh2ARWmKfzTEencmgqPlSVFxCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475784; c=relaxed/simple;
	bh=qnSoiHZ1wjsv6y3P9vWqB7UAKnF6ZVSr1i6P+s0QQ2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8RGyT6nkRreat1YyrcCcFFHijxj/vW1dEIGeWpc7GaeRh5wCESo+rrMSpEfEauQRY+pX9ZnaDT4ypTImJa09fAonLigMYrf04Xxhrrm8Z2gIrzcixsOsmtHkDAfrtAXp2hC7ZRT2gK4GaHpuP5TtCYhPOJalQTT/yKtYBSrrxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AEBFD68BFE; Thu, 23 May 2024 16:49:38 +0200 (CEST)
Date: Thu, 23 May 2024 16:49:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
Message-ID: <20240523144938.GA30227@lst.de>
References: <20240522025117.75568-1-snitzer@kernel.org> <20240522142458.GB7502@lst.de> <Zk4h-6f2M0XmraJV@kernel.org> <20240523082731.GA3010@lst.de> <Zk9OyGTESlHXu6Wa@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk9OyGTESlHXu6Wa@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 23, 2024 at 10:12:24AM -0400, Mike Snitzer wrote:
> Not sure what is sketchy about the max_sectors == 0 check, the large
> comment block explains that check quite well.  We want to avoid EIO
> for unsupported operations (otherwise we'll get spurious path failures
> in the context of dm-multipath).  Could be we can remove this check
> after an audit of how LLD handle servicing IO for unsupported
> operations -- so best to work through it during a devel cycle.

Think of what happens if you create a dm device, and then reduce
max_sectors using sysfs on the lower device after the dm device
was created: you'll trivially trigger this check.

> Not sure why scsi_debug based testing with mptest isn't triggering it
> for you. Are you seeing these limits for the underlying scsi_debug
> devices?
> 
> ./max_hw_sectors_kb:2147483647
> ./max_sectors_kb:512

root@testvm:~/mptest# cat /sys/block/sdc/queue/max_hw_sectors_kb 
2147483647

root@testvm:~/mptest# cat /sys/block/sdd/queue/max_sectors_kb 
512

root@testvm:~/mptest# cat /sys/block/dm-0/queue/max_hw_sectors_kb 
2147483647

root@testvm:~/mptest# cat /sys/block/dm-0/queue/max_sectors_kb 
1280

so they don't match, but for some reason bigger bios never get built.

