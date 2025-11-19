Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203DF32E748
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763542675; cv=none; b=C7x8m7Nt1/hJr1U2zBACRNtWjX3pNEhNgwtChmU7omi2txM44CUSD/Cgq58vUD/JUfaqAH3JvXSxkg5839N69mstDGsj+5MpWyYvjkZurcCFn8oiUvWVuB7ZtdtOHdinpIGMxXs+eaZjPSfHK3T7xvP6Onp9+fXsCUQnvnN7gSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763542675; c=relaxed/simple;
	bh=LdDBSn/xOyk1QAPZXqvrbOKS6FZXNalw8mcYsPxqMxc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jX/lqWywgnTRrLeGHRsyiQ2Y5zdY2uYO4avwQB3ayyK8TsXI7jtrErVMKIggiqqE1EfeSbL19ionoiBDBF0tooPqEl3HxeITyYV3q+6QslZvj3iYgvVC0Mo9vT5kNzPs4bJggyN9Yoh3Pu5DXYalyd9DV65QRl86C2mMhDW1G+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gzt2bQkU; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gzt2bQkU"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-36bf096b092so46630941fa.1
        for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 00:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763542672; x=1764147472; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mgWvauDE/A9FCQ7EIPYUm9cNRAKR3j3ELJfdCYK2WwY=;
        b=Gzt2bQkUTESBo3orcToG0yE4VkgRwz6QMTQg9OnfkU2rjag78Cci2ZDxSEn00+NCDu
         +e3VlpCz+wBjaUDWqz7Wc8sBd6Z6WYl3aL4hplakgwsDfpuMPpGvyz41OC+Vg70qUkBc
         L6qlk0AAqgI+GBvWvyqn99ZFO7L99zckVue9kf1HwpYyt/+EdifHQAyhLCv6QDHh34DI
         QC/Fc9lZTQnWv3+e3ThmQmA1sK72r2XxZUk/VFMv3EpUMu7PBBeR5ByqCGHSk4OJbr7R
         suiVdeSx0BomOH6/gBOF1WqVCBwnR8p8FK1NpEDzmdWtfhkMTMGyqrpp5IQBYyOGMr8z
         CeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763542672; x=1764147472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mgWvauDE/A9FCQ7EIPYUm9cNRAKR3j3ELJfdCYK2WwY=;
        b=BXKwvBHDAdGvPk0pFDBtkkjSxvkKI7VBfHMtwA0FGBvVUd1o9/WnadjeuOCrkqbkfQ
         +Bp4V1wjN07pq0oLUlJk04/oBUiVOS0FTCAey3iU2Mm1vrzoFVVsnX91UoaJFUA+N4cI
         rvnYeuNz8VDi2Q3bSBO/zpuraOIioe7Kb4WcAx/VNp7WePcW18vgJmoGijH4zvbKFqbz
         BdcTttbMXjb70wOP1t2TjHwWELk94O1h6w/X5wyMqhpRxikKLOPFHQrS4/zZV6gdksYR
         0/bv3kfXSpNySbFOIZLIAAOdgNGi8iC1SzDYak14uXiSCjkhft88X5nDppaBBE/bZwgN
         d24A==
X-Forwarded-Encrypted: i=1; AJvYcCUZ+lFsJUtAajo+J98YOTWjlModSENHG7mUqYG3n74MHXc1kNzDua+cWNkcHWsCd8t0y9zw/25q5A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+oelPLMBs1XzkMZMgTzmE/aHTYjxhDP1eKOP27Bl5nzEY9tfV
	rgvwmkK3qO89RYr7ayotaXyEcx25r5xkONAg/YjTqF/VwTONbQ26JFR7rvyHnrQmtNo=
X-Gm-Gg: ASbGncsUZ1D7hpkJfzZ2GORa0HpavlSHuI8CGPjRQiqnWn+8+4IqJAUOVzvyZdjkxEA
	oiszKX4dYac/7DlsqZlQMk0vI1SrcW39gzAUukxsne48GYebmBvL+FQIwqh14HlYSdqV0/pUeVr
	J6Ds/e7+rERgHNilMg6mUu6Xr9sEK0NuN02eenWVPtbcGmrzvVEtLpt16bMKM7DbnGGLID7fJMV
	XJmzCwakGdj+UEJv5NH8YWGmkfZzTa86JjfiLm6Fsz/D+A4xE3x/V5trt7Wa4eclVcm4B7m+tR7
	xxjU6jsSIjvOzzbNRfcd8ufkEwJeGQuKIvBMjLajGmIga3xx6NTAvaW/IzuJO2/djF7g6o5Q4ZP
	Mo8Hzi641rk6SYJFuANOVnELyIB3Vj+ITtUyZNIlGuyhMRHDljKitjH3En/YbSnYYxko2ByhN/5
	FvZiLfPrRoC99jxDinVarICb1mJgR9pND23G1SqdyX
X-Google-Smtp-Source: AGHT+IHoPX8oRgJ3J3tyKYKcVZTylMjZyvWKkEZPzyweBqQNt8aqUgjhR6EhctjFYBY9dk1OqOgiGQ==
X-Received: by 2002:a05:651c:408e:b0:37a:84e5:a1cc with SMTP id 38308e7fff4ca-37babbe5afbmr41470771fa.22.1763542671798;
        Wed, 19 Nov 2025 00:57:51 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595803b7a67sm4485944e87.43.2025.11.19.00.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 00:57:51 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 19 Nov 2025 09:57:49 +0100
To: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aR2GjRaNWrfHbDGQ@pc636>
References: <20251117105945.10179-1-urezki@gmail.com>
 <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
 <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <aR2DIXsymZWD9EvG@pc636>
 <20251119085328.GA24461@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119085328.GA24461@lst.de>

On Wed, Nov 19, 2025 at 09:53:28AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 19, 2025 at 09:43:13AM +0100, Uladzislau Rezki wrote:
> > Well. LBA is fixed in my case. Just only one format which is 512B.
> > 
> > Whereas the I/O can not be performed by using LBAs sizes. It is fixed
> > and bigger.
> 
> Then it is not an LBA.  The LBA is defined as the minimum block size
> you can do I/O on.  Aka your device is really gravely broken.  What
> device is this and who is selling it?
> 
I define UBS - underlying block size. The lower layer expects BIOs in
that sizes but this is not true.

I am not allowed to disclose and answer your last question.

--
Uladzislau Rezki
