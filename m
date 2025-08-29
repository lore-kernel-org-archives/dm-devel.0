Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E24625DB12
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 09:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756458876; cv=none; b=d6O196/mp9qLGLVmEX2X9lWYHcXXM+5Tq5bvUgs9Rf+aEorOc5QadFCVMMBr3Iw3WYvdonZYMcCR3a/sF0aj9ghCLJFY0H7Km4cxJGxBg3QCJajpcTJZUI073G3Gi+oCSCAo9/AmoAJ0OPxi226FA4QFD8DH4Bt/vGptnVELewA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756458876; c=relaxed/simple;
	bh=RY+3NnRstDYbzbbFs7/rt+mSR0o2mzbtiTuvdStYB9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9sAEy9KF5jhZSgF90Mci1w6Nhc8QIdcZN3+KbZef4U9mAsNE8VPAi9aK7nLrCjoVQTmMe15Qx1hER6WRNCSitnwttrQT1Nqabm12wG9q8NBaksUo0ZZTYbivbJASxGEYvllgTka2Qv7lrEcRjGMMsaiIa56uQ17jC4aTlHnvxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ldueaK88; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ldueaK88"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b77f59bd8so8797465e9.0
        for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 02:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756458873; x=1757063673; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A05W48MAXCFx7fKJxj1G5Bqe90+G93RXAaVC4nTixYE=;
        b=ldueaK88bviTzN/wqXf9zUZ+I2ptcD7806sEDFDLnGl4mv5+uLsayGUBScSafSOM7h
         cKwNhUx0+qhQmJO0vQS05Y52AI9peO6yeC6WVhxPHKJ2p3tkT4HtXNkpkf4qC3nSeEjN
         RDU1XDUoloMXSj1zD03P9JmFdByXbwf3JXsyHVKWJCjqTptYZyQQnkGVEs883VMUfyjg
         QyLJQlLu0Z9/TGdXqrsUozwe/i8x5E284uhA+P6/R9tAZjGBpxR065c6rYGQSbNtJ+Bi
         o7Z71f69bSdq/+B+1ofwVk3AjRTIJaHcTC32vlsOHiKPuSM1WcaXCQcergE6OQYI908F
         YCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756458873; x=1757063673;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A05W48MAXCFx7fKJxj1G5Bqe90+G93RXAaVC4nTixYE=;
        b=ZeIVBgWgnu3wJrMciVXWAbOqu+HgjLs42fQ9KgLXnDgLldPmFPqfwWQfaXRpe2PjQi
         3pMQuB6ZTR4E0SCUqfIZuvw2ds3t4nLkoxclL/RmRqNXakLlP5xILSAE5ObKoIJFgpC+
         T5gmPrOql5bqIRJIme9luoitmioCSg1WqAwl2DbFT8chB2bg0M+/mCfJiwmg3f2QEUig
         VCsNHHdKhZYY2ZN6SC/c62PeffGS3DAOcCO/YwjtrkEiIwPHU4L78ak5AFol9QC2kh+7
         LdboHMVTezOED+LD0ZxaFBD/KlLyBRvvpiYs1sgYFb8pzVnwmLT9a7+w62nBJYnptuHK
         8UNA==
X-Gm-Message-State: AOJu0Yx8QU7VlLTgRSuk3jdBHeT05pd45i3jxRByARWdAPIU5b9o6l1I
	GZYm5wI8y3EkAI4ht0SGPrbYO5CPXYKzN5YLNUUA+qg/p6z9RY/NZiINwRr2Vn+3l+k=
X-Gm-Gg: ASbGncsPlG9hp3MVFOIPVqyKFwGwRBBnAl7wFEjqGeMbhTOjjPrPmbvLxkv/b4IpBNo
	cQ8rgk6id5Ec38LK20mPZbHiuBfdT7EUAYIn56B6eRitshukopef3Py6iqyt4q3kbvVlJaoFHlT
	jqB6eqNoBVS2YZGydPcjQVHRbPJ7xo9dO+XHWxadx1ZVpqhQXqjHpXxqS85fyVVhu+PtP89x8RW
	vbDJmcJaN1I36BFx3p/qd2cHX3Jr3JwXFlQt7wZgO4aTl/XD2Il+SAxUu9zWcv8QkzuzliQngP/
	CFcDVQAvKqQXNSrDpJbBFoEPMFHXH3UPF/kyUmuekTAvoeNwOXrhK84b9PqxoQ2eC6knlInP9vX
	TDoTSNmSS+cQD9llzn36jckXV5Z5lith9DDE3qqT2SM0XPfWu
X-Google-Smtp-Source: AGHT+IGm/sWd58l8hKgRVb2XDsJWIUEY1gDzLJkE5su9EQmmtXCtVFL4BtM7719ofv4vV9HdFxsEUA==
X-Received: by 2002:a05:6000:1786:b0:3ce:bf23:3c15 with SMTP id ffacd0b85a97d-3cebf2345e6mr2758169f8f.26.1756458872653;
        Fri, 29 Aug 2025 02:14:32 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf33adf170sm2743293f8f.33.2025.08.29.02.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 02:14:32 -0700 (PDT)
Date: Fri, 29 Aug 2025 12:14:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev
Subject: Re: [bug report] dm-pcache: add persistent cache target in
 device-mapper
Message-ID: <aLFvdA9clSu_i-DC@stanley.mountain>
References: <aLE9JjiTzKmeKzsN@stanley.mountain>
 <824ba1cc-be92-47ae-9b81-a7e94f600010@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <824ba1cc-be92-47ae-9b81-a7e94f600010@linux.dev>

On Fri, Aug 29, 2025 at 02:03:36PM +0800, Dongsheng Yang wrote:
> 
> 在 8/29/2025 1:39 PM, Dan Carpenter 写道:
> > Hello Dongsheng Yang,
> > 
> > Commit 1d57628ff95b ("dm-pcache: add persistent cache target in
> > device-mapper") from Aug 12, 2025 (linux-next), leads to the
> > following Smatch static checker warning:
> > 
> > 	drivers/md/dm-pcache/cache_segment.c:263 cache_seg_gen_increase()
> > 	warn: sleeping in atomic context
> 
> 
> Hi Dan,
> 
>     Thanx for your report, I will send out the patch after my testing
> finished.
> 
> BTW, can you share the Smatch checking command or script? I want to add
> 
> Smatch check in my testing suit if possible, I did not found this kind of
> problem with simple:
> 
> make CHECK="smatch -p=kernel" C=1 M=drivers/md/dm-pcache
> 

It requires several rebuilds of the cross function database...  Everytime
you rebuild then it does:

First build: cache_data_alloc() disables preemption calls cache_seg_put()
Second build: cache_seg_put() calls cache_seg_invalidate()
Third build: cache_seg_invalidate() calls cache_seg_gen_increase()

Rebuilding the databse takes hours and hours.

~/path/to/smatch/smatch_scripts/build_kernel_data.sh

regards,
dan carpenter

