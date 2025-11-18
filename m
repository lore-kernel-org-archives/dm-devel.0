Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3542D24A0
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 12:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763469634; cv=none; b=L7mboIff5WrmEO793TKazLlP7iH5wtoEB7Kg8aF0puZJCCJhLaeVyXBRLrPdWjCKKmAZVTq2HhU/gtX+LAgENQcY8kkRw9TxByU6EEXRCt0X3HkqOnSQFLfPsaHeB+/ZONb6Sg1SkcpUdJJqA3nw7Zkw2GawX4f/jtCVp897Cxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763469634; c=relaxed/simple;
	bh=Q4opE9iq6qRv+MF/L7KhSZpSQvzF64Pdq5jC1x+OIXc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OL124XuEuNvUTAwXToegdlKOlJxwC5UNXJjhEzo8QkQvfCp1QLrRqwqBPKoyV80/9IvGcKhDFTC/rH8DyWjE6WhWKCLRZ7pRcQhOuTTyVC7QGesewRhSiTi84E6G0PlGXjIx62pZEuZ1DIlLSnDyqtGZrMRhIQLI5CAZFjTxO9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ualf1T0B; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ualf1T0B"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5958931c9c7so3960043e87.2
        for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 04:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763469631; x=1764074431; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fCFCjId+RddohxyCZqcCsm0B96GhTFlnhVi4etwRPmo=;
        b=Ualf1T0BF+kWY/T8XP1fSfxOmgXz43Wu/9OKPoRWwpTH3/yr3bUU0juF4cMY1stiGB
         BqMAGLF33nBYkX6NBdTR5jy1XicbMhNKQdl4PQ+Pc2tUHrltNKCIf3/LaJrxa1LUToRL
         wXOpAHFScV11pyFWIAjVkRHH22LOmiGShF93hU6Rn7XcgOVdXDkcFxfertFKNSE0+wcK
         tNsDjGElySPwipOxIgdnWLrguBHIOfcTSLqIF9y48nGSB/OyZZND+VOlYLTTrmMUS23t
         nGRZQVjA1tehVfGuDCn8CuEFh8ZIIFhpOlwaQHSsb530hzF1cdOHUCeQtTKcqoRMaalS
         ZZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763469631; x=1764074431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fCFCjId+RddohxyCZqcCsm0B96GhTFlnhVi4etwRPmo=;
        b=GdSkL9P+7ckb4s3+YwbeihkUHK/nKNODLqPkk87Dw6W6Jkh1IY5VwCPQkz/EEh+BBn
         Js6qCWrkhFT0V63ThvlWdHVIm6snOWiuTx7xiT40Ox6ikacB5nAhyjZHhkxN6ZduJuQ4
         Xs7+wPvkOCaJQJ5Uf+FHW4q4jDCeY6SDzQPCmq71TCuy0fhkPeC6UnNPESNOgkG0Ijta
         cW1ZaiDcHxcaSafBUbTbVNEq4pqEx39yYO+fLaAe00fgQjgrqZFfJOCIU9EnpLxyDgiD
         dBBoi4gcJbrOKHDfMB6a6fSWxIG4I+XcPF+jVPgzpjnPrwrTD4BpaNuqpN7RjkiR+C/N
         ++pw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ8bZ1ekPnsX6FBZRajj4DW4iGCvIOo9m5YB5fQR/s+QGnhGfk3FDPex07kWSETKLd9COho0Ww0g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0TTOq2OrrvCToEgnCjj5Jne3UjFa5XCvW30dWTkLxhUPnvS0G
	Wn6LZvgOcCU8ZFoPnwkFYC5EmYsFm0QyJW6c0JbZdrvzATzQIZt+iaeM
X-Gm-Gg: ASbGncvf587IHQeKM7m7RsYqtAmdp1gsMYgCtWgvfg6/w69R092Y9VSWVn0AXVCHEm+
	DKdALx7dB90Y/r65mhdSfxVerBD1T2xkxJytaJqS1hzrGDUV+N0mypVcQbziJBSYead4ANz/Tbr
	tYmf92LibsEpifqzHENlI501b9w6LXLW8zFGbWLGxvIo9UyG65VtQUmGLdWfWdwv+MFu8XkWPUD
	YVZK/pWgJiRkVGKeXABqKuyvVd9GG4vpOCKm7GY6ILb76olgu04eF/A2Ydz3JmyyFCYT5a9zbUp
	LQ01jZwjGsCM81niBr3cwDILdihnz/XcFB8Y2O2Bla2EPSUHfdXW8OO9ZDNv1wIOew5oQiZLMH1
	Be7e7rE7W2yhII/gZ2E7IExR+H9tiBxBPeR2fFA+FBzqVRqLPBQ8c7w==
X-Google-Smtp-Source: AGHT+IGsHdnJqIwLsAu4peB9fQLYq+hm2KI9BFPl7FZJ7hNXXIoGLnbtixa4Ad/TSz2inw899R6n9A==
X-Received: by 2002:a05:6512:4028:b0:594:34c4:a33a with SMTP id 2adb3069b0e04-595841b4b06mr5886386e87.19.1763469630622;
        Tue, 18 Nov 2025 04:40:30 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5958040c0e6sm3931856e87.97.2025.11.18.04.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 04:40:30 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 18 Nov 2025 13:40:28 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Alasdair Kergon <agk@redhat.com>,
	DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aRxpPFQmbB0wnmM7@milan>
References: <20251117105945.10179-1-urezki@gmail.com>
 <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
 <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>

On Tue, Nov 18, 2025 at 01:00:36PM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 18 Nov 2025, Uladzislau Rezki wrote:
> 
> > Hello, Mikulas!
> > 
> > > Hi
> > > 
> > > What is the logical_block_size of the underlying nvme device? - i.e. 
> > > what's the content of this file 
> > > /sys/block/nvme0n1/queue/logical_block_size in the virtual machine?
> > > 
> > It is 512. Whereas a physical is bigger, i.e. my device can not perform
> > I/O by 512 granularity.
> 
> And what is physical block size? Is it 8192?
> 
Bigger then logical.

> > As for virtual machine, i just simulated the problem so people can set
> > it up and check. The commit message describes how it can be reproduced.
> > 
> > The dm-ebs target which i setup does ebs to ubs conversion, so the NVME
> > driver gets BIOs are in size and aligned to ubs size. The ubs size
> > corresponds to the underlying physical device I/O size.
> > 
> > So your patch does not work if logical < physical. Therefore it does
> > not help my project.
> 
> Logical block size is the granularity at which the device can accept I/O. 
> Physical block size is the block size on the medium.
> 
> If logical < physical, then the device performs read-modify-write cycle 
> when writing blocks that are not aligned at physical block size.
> 
This is not true. It depends on your device and specification. If it
can't there is the dm-ebs that does the job.

> So, your setup is broken, because it advertises logical block size 512, 
> but it is not able to perform I/O at this granularity.
> 
I posted the workflow how to reproduce the problem. See the commit
messages. But as i noted it is for people so they can simulate it.
 
But in my case, real one, logical < pysical.

> There is this piece of code in include/linux/blkdev.h:
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> /*
>  * We should strive for 1 << (PAGE_SHIFT + MAX_PAGECACHE_ORDER)
>  * however we constrain this to what we can validate and test.
>  */
> #define BLK_MAX_BLOCK_SIZE      SZ_64K
:wq
> #else
> #define BLK_MAX_BLOCK_SIZE      PAGE_SIZE
> #endif
> 
> /* blk_validate_limits() validates bsize, so drivers don't usually need to */
> static inline int blk_validate_block_size(unsigned long bsize)
> {
>         if (bsize < 512 || bsize > BLK_MAX_BLOCK_SIZE || !is_power_of_2(bsize))
>                 return -EINVAL;
> 
>         return 0;
> }
> 
> What happens when you define CONFIG_TRANSPARENT_HUGEPAGE in your .config? 
> Does it fix the problem with small logical block size for you?
> 
TRANSPARENT stuff allows you to work with PS < BS. I have it enabled in
my case.
 
Just to repeat, the device can not do I/O with logical bs only physical.

--
Uladzislau Rezki
