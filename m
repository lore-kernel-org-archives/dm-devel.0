Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C079758ADD
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706606543; cv=none; b=NiIQ5oOCQ5y7sBKqWZFYb7+PmBbLd+HrvYkAyEKX/o+OcYedACgJ4o/Q4aM41zN21t15NByZy+BAMiDZIHAP0lJOatBDwVnV1etYPqBtLOTewTo3lSmRYjLb+XyZS5Rb8z/0056fNv7jCB6uWaKT5wtLN27rmcjs6GLBshOYx8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706606543; c=relaxed/simple;
	bh=bvMkPpAt6xQ1DlMmIig6BBKmp638o3n/5Mw6i1LY1rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tp8OX36joU2KyfxDZPExzfMN5Cn4IRQmvkDB2Ha7IMXZPhbNj+MLcx2Tm1uz9tD5zpqFZWnpHuaRg2eBI/tlGSfuqf7acut5ThvsSSqoc7qS9eNrtGLZQjG71oxc5vFm8zkxAdCTBk0NNSocdnWaPdeR3uF/ZKRtVIxkZYSa140=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JPXEBSH2; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPXEBSH2"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3bbbc6bcc78so3040647b6e.1
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706606541; x=1707211341; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ojw4Hr4df/GweRYxEO91+S9TfDRLzXvC4cCbQRxj8tk=;
        b=JPXEBSH2JSbnjxNjWJbxCXSkb9xO1YMyMJPo6iaMztM18NbWe7aLBwOBB+VVshJ5oG
         fh1NLFp3EnQBAlL8kU2VsFpihDJzUIFFFhcRJwhWh2yKh+WxzZvv7iRrXtZeXj+cmpEZ
         oNxsmiVSz8ZKXaY+lhdKDar7dDyDzO6BcAlT8FKAowO4QNzdoEkEtZfuLoT4oJrqSrEN
         EjIwTZupXc7TyApf5M2pfhzPJEFSfho/LM7oJIFLrYnyveEG3p0mqcWFlgRqXOwEQt+4
         ARZFJRiP1M2WscN0LRYuAxQP56nO/Z0tWuniMlV38jOWwtDJlvWKgJu/ilb2RPVUElL3
         A9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706606541; x=1707211341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ojw4Hr4df/GweRYxEO91+S9TfDRLzXvC4cCbQRxj8tk=;
        b=d14eOXU/j8V/2NQIjRulaumFHOgJnimgXr2nL4riWB33Zw86tIl0Eo/EJ1Q8PJylx7
         YO/yfeVmCE9IpxrgkfI/uUHKXNgFVkxAl803XdW3AwFKMvZRbgggivoPNhGXQ1Ci8Hof
         2h9s/Upp7OESjJ0FgLlpBawhuGLDDCBKibrsxbNBUSfkmG1Y9fMHiaTj4LcR7AqzVCMi
         JOGZtrEn4Xsc/3V7k8oig8CW0qnkXL12uYPQCYagTcG9DLqjSJjyQoWG/edoJfzCZBHU
         Q094gHFU9YN8Bhr/VpvTxUvsQN/ydaFYX8ewPnBiV4JQlRWidXr799JI7ISNtzWQtGAP
         IxOg==
X-Gm-Message-State: AOJu0YyWfGQ33lj25mvawR9/Hgsx2iaMOi/UuZXNptdQBclByZWvuQQA
	Tatpy9GENENxJuIawZzIIRYDezlNQKHzapyGSp5wfNFmdPuPaj9Y
X-Google-Smtp-Source: AGHT+IEkL5pgrSfa8TM8OZ01XwJdXDFMIKiv3P2F7VO+618JQ992jBf4ifR/kJLl6yusczD+b1QYBQ==
X-Received: by 2002:a05:6358:2c86:b0:178:7598:7d7e with SMTP id l6-20020a0563582c8600b0017875987d7emr4010626rwm.40.1706606540687;
        Tue, 30 Jan 2024 01:22:20 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id u4-20020aa78484000000b006dbd7e5bd1esm7278465pfn.52.2024.01.30.01.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:22:20 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 29 Jan 2024 23:22:19 -1000
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mpatocka@redhat.com,
	Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org,
	netdev@vger.kernel.org, allen.lkml@gmail.com, kernel-team@meta.com
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
Message-ID: <Zbi_y9w6ze7qfxQ2@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130091300.2968534-1-tj@kernel.org>

Oops, forgot to cc Lai.

On Mon, Jan 29, 2024 at 11:11:47PM -1000, Tejun Heo wrote:
> Hello,
> 
> The only generic interface to execute asynchronously in the BH context is
> tasklet; however, it's marked deprecated and has some design flaws such as
> the execution code accessing the tasklet item after the execution is
> complete which can lead to subtle use-after-free in certain usage scenarios
> and less-developed flush and cancel mechanisms.
> 
> Mikulas Patocka recently reported that dm-crypt and dm-crypt are affected by
> the access-after-completion issue and suggested adding TASKLET_STATE_ONESHOT
> flag which selectively removes post-completion access while significantly
> limiting how the tasklet can be used in the following thread:
> 
>  http://lkml.kernel.org/r/82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com
> 
> Linus didn't like the approach and suggested extending workqueue to support
> execution from atomic context:
> 
>  http://lkml.kernel.org/r/CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com
> 
> As suggested, this patchset implements BH workqueues which are like regular
> workqueues but executes work items in the BH (softirq) context and converts
> several tasklet users.

Lai, the patchset is at:

 http://lkml.kernel.org/r/20240130091300.2968534-1-tj@kernel.org

I'd really appreciate if you can take a look.

Thanks.

-- 
tejun
