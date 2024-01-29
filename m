Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6F5157031
	for <dm-devel@lists.linux.dev>; Mon, 29 Jan 2024 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548010; cv=none; b=iRN+0J7NZR3ebf4Vu0+JFvaLoTUjXR6MbSwjD0UyMdKwlXxcUk3O+mb/BQXhgKCnOvnH0bWfdslCmKBwakdrv+pNfMfE2Df2Juh/MMUZTQjUpCInPMsr1+EoHnBy3L8M/516gpmWyWQDC4yND5EDzpChJ+YZ8cKhHaJ2g8fEIgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548010; c=relaxed/simple;
	bh=aHP8f/jy8s8m5foj4ZrWGt+6GAdokU3T6VB4KE47DVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LpKYXY1MTC+AKxliTD+xyIQ8mbajyD/yxYQpmdrlzFgxGttRfDm5nr0Nxo5amNWVsazeWxNOf4OSDWxK24LTb5ajIu41lqxJA16EJM42QOWy//We/DKXTe6MV9X6gbBd+cnTIMWoqF1bLp8cYbkgjc/9oR5XYEReZ3HvGuDAaRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eeBBDJDi; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eeBBDJDi"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-595ac2b6c59so2120784eaf.2
        for <dm-devel@lists.linux.dev>; Mon, 29 Jan 2024 09:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706548008; x=1707152808; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W9e9aTgW69SCUZ7Nc/7sxARbcemroWx1eN9b35d29Ho=;
        b=eeBBDJDiLDKl0NroOao5A9CR1Qh3V626xpPjIyjQgbnZslFATEVIwz+uwCP0cW+H/Q
         La4yHTGNmQrYGe2QkUz/O/jHv2bWJ8zVaxSK0bhT7luYbWwEHqbC9SCTCQSZ/Pv6amOh
         CO6veTSuj6gDev/ZBdvlmINN/2UEssPel3j0jvOkNQy7llwbhAuC8aSU50RiPWStsCaA
         7CjBL8aFBM+IDEvnPH2d450KfCiWOAl9GliftbgARitiW7NAkuEqcYL9sjXusY4V5ama
         SXUio/U0fulQu7PeH4dfHEg9fKAumyE9QneCr4jVgdpUi+CEZnrf1zqTxw90lfTbD6XI
         P47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706548008; x=1707152808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9e9aTgW69SCUZ7Nc/7sxARbcemroWx1eN9b35d29Ho=;
        b=L5T/X9o2q8UBYFutEq7H5YaVxW4GRJIqzTVZASNaNEmhqZBYFx11hOdfHDGGTsLZoS
         SBmyJkFua4+mGsmO8o20pF57OH4XIGv6E7Ky7qTi1qniU7bKwSSZk/nFB57m1GhZPy86
         wW2T6+2NDpuEmdFBMBNuN51K0tdJe605z9EVWAEYiR/FyPVUdMFRawmOH0JE/2og6Xkb
         KpEq5/JeqkWJ7O9NzMF2rZodtl4QuCdW5DcqgvL1Ai3xnnhGoyapMOp2NsS1P+vxh0C2
         r09t4N8bYSFg/ZjQJCKyi6mBTYFA0c7EGu639EuvVDOhVgu0l9wVb+xmoS4n0o3nj0T3
         87tQ==
X-Gm-Message-State: AOJu0YwGifXXWlgB1NE9nTCnTZX2fKJkhYHzhf9gFe2HMZrH/EQ/J18Y
	eWzh+3ERh76brf/cysa5YWEdyNS3YRiK/nCvEJXPZiwsLCAtVXgn
X-Google-Smtp-Source: AGHT+IGdxuoFd4LUiMNuUO/uxr16fX5q6e1Nvuc62bGBd5Y01eX8ww0nnR180D976To9gSq/43n88A==
X-Received: by 2002:a05:6358:7205:b0:176:5cad:a2e1 with SMTP id h5-20020a056358720500b001765cada2e1mr6548304rwa.26.1706548007807;
        Mon, 29 Jan 2024 09:06:47 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id c26-20020a62e81a000000b006ddc84a03c8sm6083271pfi.85.2024.01.29.09.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 09:06:47 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 29 Jan 2024 07:06:46 -1000
From: Tejun Heo <tj@kernel.org>
To: Allen <allen.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <msnitzer@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Bob Liu <bob.liu@oracle.com>, Hou Tao <houtao1@huawei.com>,
	Nathan Huckleberry <nhuck@google.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] softirq: fix memory corruption when freeing
 tasklet_struct
Message-ID: <ZbfbJuRRklWhYk4Q@slm.duckdns.org>
References: <82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com>
 <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>
 <ZbRDnSyiSE93puQL@slm.duckdns.org>
 <CAOMdWSK5CfVpvwmCxCtYLJ-Qt+ZwhETF3K+AhNcBGtEpkKvFqg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSK5CfVpvwmCxCtYLJ-Qt+ZwhETF3K+AhNcBGtEpkKvFqg@mail.gmail.com>

Hello,

On Mon, Jan 29, 2024 at 09:00:38AM -0800, Allen wrote:
>     I rushed to reply to the draft patch you sent, I should have
> looked harder. My apologies.
> The idea that I have been working on is to completely move away from
> using tasklets.
> Essentially, "get rid of tasklets entirely in the kernel". So, the use
> of tasklet_schedule() & tasklet_hi_schedule()
> will have to go.

The idea is to take over the tasklet[_hi] softirqs once all users are
converted. Otherwise, we run into the problem of setting priorities between
tasklets and the atomic workqueue, which may be a theoretical problem.

>    I have a very hacky draft that is still wip. I am going to borrow
> many bits from your patch which makes
> the work I have better.
> 
>   Perhaps we should start a separate thread, thoughts?

Sure, please go ahead.

Thanks.

-- 
tejun
