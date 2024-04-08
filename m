Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715786F08E
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 13:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.71.1.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581621; cv=none; b=JWVNoyCuWZ3ArG3ECwyI60b+VrELvLNcfDOfnjb1E9sT/yS4oO2NqTtXCwd47rOB7pydSA610feJL1T4iOCGh02u4I3Uxa2RB1O9as0z2ki1/bmwV+q1rdqNyIdhKrcD/AryirIF54Z1R0yijKOzDFGXOeUHiVSihIP+O+TrOCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581621; c=relaxed/simple;
	bh=lCnbrdPBjAOGBk9PNQHAxITQsanRBoTq1k8rfS3qTBk=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=SbtdVha5RH+CIGThBefRyMEftLu2Kz4wGCttjlxW9UpSFQuLvK6hlBUqLNk10x1Z6wsORIu0T101z/tYyuQZlKufFnLnI6HWtaAE5qRsFcxQZ8OXW0mHTPHjASI3LY1TNDjIlyx6rGC5Mxb1vAn//haFJmW9KbS/f2AY21pnORo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=edpnet.be; spf=pass smtp.mailfrom=edpnet.be; dkim=pass (1024-bit key) header.d=edpnet.be header.i=@edpnet.be header.b=Y5lOSi1S; arc=none smtp.client-ip=212.71.1.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=edpnet.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=edpnet.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=edpnet.be header.i=@edpnet.be header.b="Y5lOSi1S"
X-ASG-Debug-ID: 1712580541-214fdf3eff2d3250001-h1EgPR
Received: from LXmail02.edpnet.net (lxmail02.edpnet.net [212.71.0.136]) by relay-b02.edpnet.be with ESMTP id 3ekiN0HJH51T66YM (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO); Mon, 08 Apr 2024 14:49:01 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@edpnet.be
X-Barracuda-Effective-Source-IP: lxmail02.edpnet.net[212.71.0.136]
X-Barracuda-Apparent-Source-IP: 212.71.0.136
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=edpnet.be; s=default;
	t=1712580540; bh=lCnbrdPBjAOGBk9PNQHAxITQsanRBoTq1k8rfS3qTBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Y5lOSi1Sh/mgZvLYdPS4r7boFEMZhXpOuzEb48X4T5NmGU78pg4jxxadbRCuud5o3
	 Q0p8clhry47kWrwHo0TokjKz42kfKLspCYyjAqz2MHwbOnp4Y+6U/5+z5p9L6gabhH
	 TB4OcHU5dtHgcwCFUSUjQLsBR248kPCqZo8a4Z0w=
Received: from webmail.edpnet.be (unknown [212.71.0.142])
	(Authenticated sender: janpietersol1.m1@edpnet.org)
	by LXmail02.edpnet.net (Postfix) with ESMTPA id 4VCpn84DGRz12Sf;
	Mon,  8 Apr 2024 14:49:00 +0200 (CEST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 08 Apr 2024 14:48:59 +0200
From: janpieter.sollie@edpnet.be
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH] block: allow device to have both virt_boundary_mask and
 max segment size
In-Reply-To: <ZhOekuZdwlwNSiZV@fedora>
X-ASG-Orig-Subj: Re: [PATCH] block: allow device to have both virt_boundary_mask and
 max segment size
References: <20240407131931.4055231-1-ming.lei@redhat.com>
 <20240408055542.GA15653@lst.de> <ZhOekuZdwlwNSiZV@fedora>
User-Agent: edpnet Webmail/1.6.3
Message-ID: <3bd355e523a04b4a355fb84d5bc59224@edpnet.be>
X-Sender: janpieter.sollie@edpnet.be
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: lxmail02.edpnet.net[212.71.0.136]
X-Barracuda-Start-Time: 1712580541
X-Barracuda-Encrypted: TLS_AES_256_GCM_SHA384
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1027
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=NO_REAL_NAME
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.123232
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 NO_REAL_NAME           From: does not include a real name

On 2024-04-08 09:36, Ming Lei wrote:
> 
> It isn't now we put the limit, and this way has been done for stacking 
> device
> since beginning, it is actually added by commit d690cb8ae14b in 
> v6.9-rc1.
> 
> If max segment size isn't aligned with virt_boundary_mask, 
> bio_split_rw()
> will split the bio with max segment size, this way still works, just 
> not
> efficiently. And in reality, the two are often aligned.

I take it as a compliment, building exotic configurations is something 
I'd love to be good at.
But, as far as I understand, this warning is caused by my raid config, 
right?
How is it possible that a raid6 array has a queue/max_segment_size of 
(2^16 - 1) in sysfs while 2 others on the same system have a 
queue/max_segment_size of (2^32 - 1)?
they are all rotational devices on the same SAS controller, just this 
malfunctioning one uses SATA drives while the other 2 are SAS.
Understanding this would help me to avoid this unwanted behavior.

Kind regards,

Janpieter Sollie
