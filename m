Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC0380
	for <dm-devel@lists.linux.dev>; Thu,  1 Feb 2024 00:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706745868; cv=none; b=EhypogvjM7mP4lJ6oI9o6WsEYy6XVQZOI1YDYPGTk6OiRVGt7jhZuB1iw2Gy8+nd6v/2nsfYlszlfA/DNH46CW5MB66sC9EumfHBsIDkcqyEpJvmXTf6/FsSHA96Pm0fLJg67xHY1I62eMScKziM6UVPSReFX0optbpXfA97tF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706745868; c=relaxed/simple;
	bh=ocp7AlYTWdpktj/bKSgADTaYJuvdE/zKdxZf6Npx1Kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3pz66sVxfJGOyHgLplQIUWhAoXU6oibiUriLQLp7dITL+wc1mrHYj7HGQPdU90dTzje7f9vLPQY6ncob/lBYkm+48+PitWPzh0EV7c65uw2KLSMMMEu++glPrNinnxp4Y0mLcZtr83g8nRRwgUT5Mek0UJ5cm6JKbVixElK4x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MEHMSEpc; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MEHMSEpc"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6de287449f1so215259b3a.2
        for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 16:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706745866; x=1707350666; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QWmJW1ioE6shF94cLYg8UXpbXdCkseBL4kZBLYoeBuI=;
        b=MEHMSEpcLFQNcaFsEUj840mKu8Mpa35wUVxkjDj72od8yClgeKi4fjFHFjjmo3pRko
         NRNov5gfglJRAgPA8SzC3dN728Svz92ViH916/628ayRqMps4JBcAPvcOCA2sBHOFMxT
         JEHvY184jCDpvEPOkNO60GLi8hhQm9iv4glqPjK+x5guBVlnS57prqoMhp0okgxWZU7Q
         jFfOQhSNTwfGWsjRjgBCEvbe/zcpv2mGUij8pfCj9lO7990wB9a6aeOs/gpIF7dlibmJ
         W6vHxOuPdNH5FvSDbedUzyuXuw5a0K+C1ve1MVO31eJlgOmYuMee1ZQKvGaC2OBmwrae
         Inhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706745866; x=1707350666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QWmJW1ioE6shF94cLYg8UXpbXdCkseBL4kZBLYoeBuI=;
        b=voN624C9GC4uyXKk5H+92MiK0/DWFSwtdUrxc9RwBnEY0BTYs2dTUcrr4D8uECfPTY
         s+kORBjIBkT6we71mtJaVZU61CmE6kk6PCrsh40stptNxs/imFgtLtimEXu+yWRol8Oo
         mc0cb+BC7768DLw+aBZKW5tuib23q+CGy9Wa9RtFZumNoZ+dePteUgc1jodH4j/b98FH
         SbR/eTQF3PQQBImdtPpoh6oWbGD5luf8YsJZIA8+tPP1bRipeoLXzAlvLKphjVVcRU66
         WI1tP7ZaIO+rh92VOb56wcF5TOUAuTkVY+AKpvc95gm5VO5+fUo+ZUVArWXpdh8HFs+E
         43Cw==
X-Gm-Message-State: AOJu0Yz5TIL7VHRXIweyz3gyeoJXRkFZq5omQyA7DnXla8dqYoXI7v+u
	JS6LLkhCRzh5gKr6ewfI4QOBk5ieMWitwVdtrHESRDdeB/Bj5eXP
X-Google-Smtp-Source: AGHT+IGBKobfIm1xyfYyTe1hLyDXEz+BO2PI+5A5iytez90gtfBGuKYEcrsACR6tlmTY3B1KQ7lVsg==
X-Received: by 2002:a05:6a00:1c91:b0:6d9:ac1f:421e with SMTP id y17-20020a056a001c9100b006d9ac1f421emr3881511pfw.26.1706745866320;
        Wed, 31 Jan 2024 16:04:26 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id jw3-20020a056a00928300b006dbd2231184sm10443282pfb.70.2024.01.31.16.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 16:04:26 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 31 Jan 2024 14:04:24 -1000
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, msnitzer@redhat.com, ignat@cloudflare.com,
	damien.lemoal@wdc.com, bob.liu@oracle.com, houtao1@huawei.com,
	peterz@infradead.org, mingo@kernel.org, netdev@vger.kernel.org,
	allen.lkml@gmail.com, kernel-team@meta.com,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH 8/8] dm-verity: Convert from tasklet to BH workqueue
Message-ID: <ZbrgCPEolPJNfg1x@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-9-tj@kernel.org>
 <c2539f87-b4fe-ac7d-64d9-cbf8db929c7@redhat.com>
 <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
 <CAHk-=wjMz_1mb+WJsPhfp5VBNrM=o8f-x2=6UW2eK5n4DHff9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjMz_1mb+WJsPhfp5VBNrM=o8f-x2=6UW2eK5n4DHff9g@mail.gmail.com>

Hello, Linus.

On Wed, Jan 31, 2024 at 03:19:01PM -0800, Linus Torvalds wrote:
> On Wed, 31 Jan 2024 at 13:32, Tejun Heo <tj@kernel.org> wrote:
> >
> > I don't know, so just did the dumb thing. If the caller always guarantees
> > that the work items are never queued at the same time, reusing is fine.
> 
> So the reason I thought it would be a good cleanup to introduce that
> "atomic" workqueue thing (now "bh") was that this case literally has a
> switch between "use tasklets' or "use workqueues".
> 
> So it's not even about "reusing" the workqueue, it's literally a
> matter of making it always just use workqueues, and the switch then
> becomes just *which* workqueue to use - system or bh.

Yeah, that's how the dm-crypt got converted. The patch just before this one.
This one probably can be converted the same way. I don't see the work item
being re-initialized. It probably is better to initialize the work item
together with the enclosing struct and then just queue it when needed.

Mikulas, I couldn't decide what to do with the "try_verify_in_tasklet"
option and just decided to do the minimal thing hoping that someone more
familiar with the code can take over the actual conversion. How much of user
interface commitment is that? Should it be renamed or would it be better to
leave it be?

Thanks.

-- 
tejun
