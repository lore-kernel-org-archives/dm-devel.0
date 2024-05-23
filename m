Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86B122616
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716482308; cv=none; b=XmjyOIHzWbhCVohNSafxXVcrv7FGjfKfeQRwvAq3a/KX4NS2mBrs5cryLOX5aVylS/GbGr5ql0LGayaN1woA+sSFEkNfE8vLvvXkauWNfJRny9HoEUqxf6jZ/wfheuTsaFXjR/Y1tzgqxnVsrg7N/1qN4YYz4Z8PDX+MmREA/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716482308; c=relaxed/simple;
	bh=u9Wir9iPBM8gnarcCmvRVioqS8WnxFLE/plLFHpkQME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMi5IXjrICaJJTpEKhe6Y1AZKCBXSZpMNFCUFsPzJadCzpBJ0gayGCSCzxvkrfwYp95Dt1jLWLGaSXM0kYor0XoQvjFlqRaiie3XFURJKLNEnvqo8fFAPW4KH+Q7+pL04xtwK2+zVO452hSvr1I97KjXdkg76SwRIQnguzgBk4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-792ba098eccso474001085a.2
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 09:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716482305; x=1717087105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vIfLdj49wKy854TltAEAmYWURF6O/ckM40TlcEN9pF0=;
        b=MffpIVhRo2dXuXi0dzZ5tLdPkOqVcTt8POT0MdToKPPFjoPwP2Vherx2pD5YGh6SXF
         uTDgFH+zybRakWKIdt/wNbdlXMTCz6ICR+phsEvxUBsKLD0WKKGVetV8WLviSB+XYxbo
         6UcvGu7N9KYO55DPQB+jSEKNWLLEEwM2OCFoYFt2UFsT5wBhnNZ27fVIdr0IBG/wVBzr
         BiFWPOKB/LAcVD0kRIlK9HYPPo+gDeUuMY9ZI3OppbWJ6sntZOj8QlEgfIdl/DsK8zOl
         wlJrKoRiD5aXKDoDJQGPnHCfuTJsBV8Y392Vph6xZJJgakcRchOemsfeL1+v+zLiJ0iF
         9Ctg==
X-Forwarded-Encrypted: i=1; AJvYcCWDApN833n4BXRClo1dYgdXgx6cVhIINjvl4Qx5GTKnyUX+7Wrk2BLfyWqheNfpKSKjlYKd9b97UJzWYNQKUT6I/kCHw0S1G3Q=
X-Gm-Message-State: AOJu0YzT41pteo4ZJBAEbUSOwL1eYKzSmxiKceQdmzfO3pjXYwNPyMd2
	DVeNkohS8uL0b9GUZncdfHryL+KfBRAj3vPO2M2taUOtBbCxKOx6XJOvir0B/eQ=
X-Google-Smtp-Source: AGHT+IHImD2ZZ/UHBIoJzCXH67k5b003ufsWsa+fk2wDCEAso958XFH+V1+azPGCkeH/2m+Je7QZHA==
X-Received: by 2002:a05:620a:e0f:b0:792:a479:a149 with SMTP id af79cd13be357-794994a2f1bmr560698985a.55.1716482305616;
        Thu, 23 May 2024 09:38:25 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2fc466sm1502251785a.77.2024.05.23.09.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 09:38:25 -0700 (PDT)
Date: Thu, 23 May 2024 12:38:24 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH for-6.10-rc1] block: fix blk_validate_limits() to
 properly handle stacked devices
Message-ID: <Zk9xAJur96MVX0cy@kernel.org>
References: <20240522025117.75568-1-snitzer@kernel.org>
 <20240522142458.GB7502@lst.de>
 <Zk4h-6f2M0XmraJV@kernel.org>
 <Zk6haNVa5JXxlOf1@fedora>
 <Zk9i7V2GRoHxBPRu@kernel.org>
 <20240523154435.GA1783@lst.de>
 <Zk9lYpthswuegMhn@kernel.org>
 <20240523155217.GA2346@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523155217.GA2346@lst.de>

On Thu, May 23, 2024 at 05:52:17PM +0200, Christoph Hellwig wrote:
> On Thu, May 23, 2024 at 11:48:50AM -0400, Mike Snitzer wrote:
> > 
> > Reality is, we have stacking block devices that regularly are _not_
> > accounted for when people make changes to block core queue_limits
> > code.  That is a serious problem.
> 
> Well, maybe we need to sure blktests covers this instead of either
> impossible to run on a stock distro (device_mapper tests) or always
> somehow hanging (lvm2 testsuite) separate tests..

Happy to see mptest get folded into blktests (its just bash code) --
but it doesn't reproduce for you so not a reliable safeguard.

The other testsuites aren't applicable to this particular issue, but I
don't disagree that the unicorn automated test frameworks used for DM
aren't robust enough.

> > Happy to see the need for the 'stacking' flag to go away in time but I
> > fail to see why it is "fundamentally wrong".
> 
> Because stacking limits should not in any way be built different.
> Both the stacking flag and your restoring of the value just hack
> around the problem instead of trying to address it.  Let's use a
> little time to sort this out properly instead of piling up hacks.

I have limited patience for queue_limits bugs given how long it took
us to stablize limits stacking (and how regressions keep happening).

All of the changes to render max_sectors and max_discard_sectors
unsettable directly (and only allow them being set in terms of an ever
growing array of overrides) were quite the big hammer. But yeah, it
is what it is.

I do appreciate your concern with me wanting limits stacking to be a
more pronounced first-class citizen in block core's queue_limits code.
I was trying to get the code back to a reliable state relative to
blk_stack_limits() et al -- for any underlying driver that might also
be blind to (ab)using max_user_sectors to steer blk_validate_limits().
I'm concerned such hacks are also fragile.

But in general I know we share the same goal, so I'll slow down and
yield to you to run with piecewise fixes where needed.  Will reply to
your latest patch now.

Mike
