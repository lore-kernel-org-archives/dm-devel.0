Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB2286BC
	for <dm-devel@lists.linux.dev>; Sun,  4 Feb 2024 21:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707082433; cv=none; b=ZpKmQoF4A0WJSPNUXM+/J/vOeXZKOdQyIf1Ku9zOA53+sR8x+PXd4ztztRsHLGjQQAJ2hFt0+S9VFJY+944SLJ2xppWf2TT7vVYx3MH6zmhi0NzrPyXi5DhOGkqHXiSt3m/Gr25TZ9Qi8GOHCaZ1+tdovlQ7I+pvBPr3B7rLTXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707082433; c=relaxed/simple;
	bh=FViAgGY9+E6nqcFOV1iUFPe+Yh9doxfR37J2aoGnWp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XF63JSxhiuHYLsq0WcqCD7a9s8olIbRBts2dDxSDDNCt81bAJxe3qpwYMWZLzNkdkvPqYYsvHi3dzdurPVPdP+rrInt17odbCkzY1vSxfPWuZ7fE5TeQ9g++6B4m1TJEhRlNccYnV6tf8Z1aoCdzNlR00YBDfvMz1+em5JQYXtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jot8PSqn; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jot8PSqn"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e03b583904so400517b3a.2
        for <dm-devel@lists.linux.dev>; Sun, 04 Feb 2024 13:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707082431; x=1707687231; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K05b5VLfrvxMvlDj2Oam+kbl/YvHi9sQJ4OaJmwSdN0=;
        b=Jot8PSqnr0STvR8aOvufk4qxiHnySq6pQUE0HovQhYF/NVzW9vphRgKzTbTlkH2uI1
         gaVQ8eA9fgALsWFAsUZpLGiXESTRR0OAHgPiUTdKFn0ft4Y/gGtG6gZIM5DXVfdBNdr2
         Y/me7nbWgeInA0OvOctGUZtHtm2WOSP6EWL2EC/GI0uCHzjoT+Z1Vd1nMxEThD/X9IZi
         wffwTnbTXyRyfkYaGjHl7unIILduksvciyZsVV/HLMtc9aEEQBHtUkMqK7x2GfS74CRW
         miJp2Dkf1PLYN0G5vhC3y6eNokXiB9v7+cCAL52rMKfoHPVUA11KK0Vw1Ka9AM0iIzW2
         bUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707082431; x=1707687231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K05b5VLfrvxMvlDj2Oam+kbl/YvHi9sQJ4OaJmwSdN0=;
        b=KQ5NCrapZJ8fw6/tBQgPuM/PNE6UP51s8ap+g78T3lN8DawAhpb1hUnKamlXu5UP6N
         r3rp9Nk0emQkLDSM+4os/690CvAnY+mnfFSBYoTYwBC3izZypzg795pP/c/j/Ngr3/Rq
         3spBGNIOx/T4PD9aVSCEIguNxhT+vM0+MsEw9lyoXleA2cqSpLtUXccyJHfqsuSBr9OA
         l3NV/F4nF2aIA44oqbDJAGxKT6sPCxhY/71sj+ojNlYWDvDDyBY9tYFPJpe4oMuwToD1
         +HC+t+itL2ddQgt7gXQ1Z9PEyOrXpWwAT0U5Konv3+t/5dj5X5+mhgw5cP5rvv748bAH
         ngQw==
X-Gm-Message-State: AOJu0YxEiiE3hw2AwS7bVXGyo1iT7UIDtEYxRNZi+/22B7VqkY0e5bmY
	iB8kweJtWEmWaRUD+0jti0U89RFqQoiZC0oql5dbHc47FmDuqvOC
X-Google-Smtp-Source: AGHT+IEq90LVf9NXSqesU3tg2TwrDGP9MmY7XpUK9YJk1kiC567+EGK2eUNBHUpKMXWiuE5BEyLP7A==
X-Received: by 2002:a05:6a00:d4b:b0:6e0:3aa3:e163 with SMTP id n11-20020a056a000d4b00b006e03aa3e163mr2375756pfv.7.1707082430891;
        Sun, 04 Feb 2024 13:33:50 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXTiaHeupoEVMkrMvapOSp8j4tlU0hr+rODA/5RPybihfYgmEsZTeFryROCxlOh+Hi9+lc49Z1JMO176gJFmryueU/qz5k25REqmLyWBvF7jVvLXBfWl4HxpajvW0KZP6ITyyat3d30fhdX5nfiDIUwisaj8COgExEYK/hOXNroNhEVc7pVC1YOOyRrGsOKSeI6QhXPM57V/O5NIoeXfjCL6KSAPpH4iO0eHg1AIARHRl/LUAaV2PInGvGs3HkSf+t9TYVIJhvs8FimNNZquCSVnVDAQ5ScFlENEBV7/IpleXqz+RBYBwOKXINFZbN4ltvCDlJyQ3mWOh7UShmmHF7ZvAk6qQbHQ2y0wkHGMAO+tOgRneKx80HOrSOgFn25endVqmRhOv2X6W7/teGxb5nDr77q6EhltTl9P56/0TJQMbrVNFiI
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id p22-20020aa78616000000b006db3149eacasm5177979pfn.104.2024.02.04.13.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 13:33:50 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Sun, 4 Feb 2024 11:33:49 -1000
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
Message-ID: <ZcACvVz83QFuSLR6@slm.duckdns.org>
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

On Mon, Jan 29, 2024 at 11:11:47PM -1000, Tejun Heo wrote:
>  0001-workqueue-Update-lock-debugging-code.patch
>  0002-workqueue-Factor-out-init_cpu_worker_pool.patch
>  0003-workqueue-Implement-BH-workqueues-to-eventually-repl.patch
>  0004-backtracetest-Convert-from-tasklet-to-BH-workqueue.patch
>  0005-usb-core-hcd-Convert-from-tasklet-to-BH-workqueue.patch
>  0006-net-tcp-tsq-Convert-from-tasklet-to-BH-workqueue.patch
>  0007-dm-crypt-Convert-from-tasklet-to-BH-workqueue.patch
>  0008-dm-verity-Convert-from-tasklet-to-BH-workqueue.patch

Applied 0001-0003 to wq/for-6.9. Applied 0004-0005 to
wq/for-6.9-bh-conversions. Will proceed on 0006 and other conversions after
more perf testing.

Thanks.

-- 
tejun
