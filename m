Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0763C4B5DD
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 21:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707167533; cv=none; b=GN5mnHuMVZB7JvxChnQ+n6/xkfXMTWTbUEXD4KvcylMjJ4IDws5gN/mQbKncATsEaxVNs/Pqi0Ix1kTls4m2B1PAUO4PRp+hpJlX07a3PZbwXE8zEcW3n12g6e/HYKv3BTcfTxcsvFDvGx50IHTB9wvAZIrAw415tIs9DsKqbz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707167533; c=relaxed/simple;
	bh=XQF2uBcHLuFqq+yOdvxRNweyMEUC2bS20cGYte1KJfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHMVGtHoB0DgBvJUWY9wI0ve/EiO7Pcx7FLqqW1yz2Rnt5NQ/vljAY/YDyifilyLE6D4ukIm6pguxVpkfahy7rlee0Mx3suNQrXN8j0fr7aCqkw5itfjsyXq9fNYc+3XJzExkYwbjgnpN37A2twykm69u0eRl2Xszk0O4vbzbbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yxnwh5TE; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yxnwh5TE"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d72f71f222so39275195ad.1
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 13:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707167531; x=1707772331; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Epr4P9xrHmvsudGJkegcnKp7KkOU0wqtIemIFUjl3bk=;
        b=Yxnwh5TEeJY5B9aKS36GQfOBS0I6deuiTvYqdsqiWLL2j3usrvsMhIst7IMvtC3EZ/
         oMSg78WcLERUwtd1z6Fgcnq/QfAeNzxTIlRVG90sPW4mYmz+Mu5Ixv6oCgGlSg0+a833
         GcC+smqtnbCa0Jvas9nonqMGWXGkagZyvN9p72NvyzH8Xq+7vobzfiWBNgLC2IZDBv1K
         xjXQrhscGPWwDHDN+tieqV5vpw/yBTKC12nLkpKAuTUoWbsMlcMZYBa2hMG4HBMVgeqg
         qhZ+joQM7cfFmnnTE82Lxc6TMmchrIKzec8nI2bdnD30H0i6OKcdI60B9ANsALPVYcqW
         /FNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707167531; x=1707772331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Epr4P9xrHmvsudGJkegcnKp7KkOU0wqtIemIFUjl3bk=;
        b=qNQWAzffY5EKwRPe92v7updz1AUOkaRKrMF+nM3N4kfxrWrjj9FMNzSavez2vVJH9j
         vwS1CNQM+Rua+2t1K6WXgueTPZ1vpik3Da8IpU3IDM+OIEnmrq9d1TDqlmO8JwDhS4Lz
         5plotr+L1nK1/lspUq31MviiZrmIqauf8tfLRJ4neltwZXL0EfMg7rgjLgOsrwb/rYDZ
         FDhOkZhOYY+6EEn1DIvTg3f86eumn+7DpggMmganJaeyn4bn4eYHBUnXaW574Y2XDix3
         Gppn918ikc7hq/s69cVVR6mfSvmgyyieyPh5+VjDmmWofqlckgnPtNNUnfmteGCD379T
         83Tw==
X-Gm-Message-State: AOJu0Yz4RHB5npBJE3P8dvpshbYp6jFdefE6OOLDBUBLu/W/5hZ79w4a
	xLfQ4vLeme1P9sUfjLCo4A8Da8vY5HY3ka4lWD1Fk4fOuzMwKP35
X-Google-Smtp-Source: AGHT+IFf/wc235Q1LsngiAKkLZZRq99Fmkw9x7bucgz2Q7qPcj5sGnzopUSeVLnlgrt66ScPcyoO1A==
X-Received: by 2002:a17:902:ee81:b0:1d7:7347:d80e with SMTP id a1-20020a170902ee8100b001d77347d80emr706714pld.37.1707167531226;
        Mon, 05 Feb 2024 13:12:11 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVH5hLCVOvQ/utBPhijRYjEQzo0ZfJlK8Mhbyv3NVNlvgGrEhEMGKUy2+tlE0QIR2Txxu4BFELRanLyPgDRi9VbwYk8nkzD/6OORH608lnF0xTYa6oM6Jh708OvEET5XjMDC/hYrbk7OoN4VfhlbPv947Q2gAHulnGXZ0vOqfKS2YYJy1S73aI6b9VAY624SxEJWF/2viuz8Nf1ySJYj0ejOOfIlvPmcPI9WwaPspCbTxlZgeCr65PvcXtZg+XFU6pAlWROfsue43g8zwt9GTFnowAlOKM6ONBTJ3qKMFxwVXCspC4/vElpKs79HfK6RMylLKWQRvvtpbEraBuyKqhf0qhCirbrG/4MAlYEMxnJNx7vVvy6JCfNb7fj6ateYbCMh/Bcr+I9byyuZ9CyfN1HE2GkfqisDBzrMjcOhP0iEULMMeRLwCjNjOtVYOc=
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id w13-20020a170902d3cd00b001d9609f2e30sm326986plb.1.2024.02.05.13.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 13:12:10 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 5 Feb 2024 11:12:09 -1000
From: Tejun Heo <tj@kernel.org>
To: Allen <allen.lkml@gmail.com>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
Message-ID: <ZcFPKaWwxJhgy8HQ@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <ZcACvVz83QFuSLR6@slm.duckdns.org>
 <CAOMdWSLNMqsZNJ-oCLN2RjckZmJSvdU_Yq0F0frmqMqa67Oy1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSLNMqsZNJ-oCLN2RjckZmJSvdU_Yq0F0frmqMqa67Oy1g@mail.gmail.com>

Hello, Allen.

On Mon, Feb 05, 2024 at 12:50:28PM -0800, Allen wrote:
> Thank you. I am basing my work on the branch you have
> pushed.(or-6.9-bh-conversions)
> https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/log/?h=for-6.9-bh-conversions
> 
> In the order of priority, I have started converting drivers/media/*,
> drivers/dma/* followed by drivers/net/*
> which constitutes the majority. Putting my plan out here so that the
> work is not duplicated.
> I will write back in a day and share the branch for review.

That's great. Thanks.

> W.r.t the conversion, there are drivers which call
> tasklet_[disable/enable](), which I suppose
> can be ignored in the case of workqueues, I am not entirely sure if
> this is the right approach.
> Please correct me if I am wrong.

I don't think we can ignore them. I was just looking at tasklet_kill() and
thought we're good because that seemed to map well to cancel_work_sync().
workqueue doesn't have the counterpart for tasklet_[disable/enable](). I'll
look through them and think on it.

Thanks.

-- 
tejun
