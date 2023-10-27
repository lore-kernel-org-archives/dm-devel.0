Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DC53AC22
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 19:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-779fb118fe4so173197885a.2
        for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 12:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698434237; x=1699039037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJT7fPV2gPr266dgHb6wRFTeUO0bh/e9lQXSKG8KwCw=;
        b=Af30CLhNuAcfg1vXrMafjkaCPY6ecwM4GVpNgnFqDozgaqO177q0npMe11UkZLcvwy
         bntUEBJNhecfhi4hkEM6vt2mXjkP2SZCgx3+0XN8f6efxiTnhVUs1kdZHloxzi5qSVvj
         gYo5IDRSz2K4OBpds5EuL+LrYrm8o1iD6av00E1NnKq+ozHJz1j36g7C6LOby1zg/9wj
         ytBddert5BYIO5MZcv6bP736j6QKS2Yv2bLD3gsL9C8s3Evq08Px8bN9hFlqJ0+9fXsL
         n8niNANzdxlfXntMhb5XFdxRInpI7ya4uTp5KbDlEImF4E3/0oF8WGOect1jwp7id52a
         usOA==
X-Gm-Message-State: AOJu0Ywz82Lf/rUZQibgyZakd1pB7cZurl3+z6M0l52Y1PysCr6liwWa
	U9DU3p3Doeo6ZLzhfMmf1ZKX
X-Google-Smtp-Source: AGHT+IGLmN8n1FQeybzaJrhM20MOqQA9u1RvtdEKFrTtEQePlgVuP5hPnD3wvPLymT3W9A53TRS8SA==
X-Received: by 2002:a05:620a:4514:b0:775:7d81:f8bb with SMTP id t20-20020a05620a451400b007757d81f8bbmr4690750qkp.11.1698434237078;
        Fri, 27 Oct 2023 12:17:17 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id l21-20020a05620a28d500b007743446efd1sm806006qkp.35.2023.10.27.12.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 12:17:16 -0700 (PDT)
Date: Fri, 27 Oct 2023 15:17:15 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christian Loehle <christian.loehle@arm.com>
Cc: dm-devel@lists.linux.dev, agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dm: delay: use kthread instead of timers and wq
Message-ID: <ZTwMu5uHcKnShoKU@redhat.com>
References: <7aab63e2-b133-49ec-ab8b-36ebec685de2@arm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aab63e2-b133-49ec-ab8b-36ebec685de2@arm.com>

On Fri, Oct 20 2023 at  7:46P -0400,
Christian Loehle <christian.loehle@arm.com> wrote:

> The current design of timers and wq to realize the delays
> is insufficient especially for delays below ~50ms.
> The design is enhanced with a kthread to flush the expired delays,
> trading some CPU time (in some cases) for better delay accuracy and
> delays closer to what the user requested for smaller delays.
> The new design is chosen as long as all the delays are below 50ms.
> 
> Since bios can't be completed in interrupt context using a kthread
> is probably the most reasonable way to approach this.
> 
> Testing with
> echo "0 2097152 zero" | dmsetup create dm-zeros
> for i in $(seq 0 20);
> do
>   echo "0 2097152 delay /dev/mapper/dm-zeros 0 $i" | dmsetup create dm-delay-${i}ms;
> done
> 
> Some performance numbers for comparison
> beaglebone black (single core) CONFIG_HZ_1000=y:
> fio --name=1msread --rw=randread --bs=4k --runtime=60 --time_based --filename=/dev/mapper/dm-delay-1ms
> Theoretical maximum: 1000 IOPS
> Previous: 250 IOPS
> Kthread: 500 IOPS
> fio --name=10msread --rw=randread --bs=4k --runtime=60 --time_based --filename=/dev/mapper/dm-delay-10ms
> Theoretical maximum: 100 IOPS
> Previous: 45 IOPS
> Kthread: 50 IOPS
> fio --name=1mswrite --rw=randwrite --direct=1 --bs=4k --runtime=60 --time_based --filename=/dev/mapper/dm-delay-1ms
> Theoretical maximum: 1000 IOPS
> Previous: 498 IOPS
> Kthread: 1000 IOPS
> fio --name=10mswrite --rw=randwrite --direct=1 --bs=4k --runtime=60 --time_based --filename=/dev/mapper/dm-delay-10ms
> Theoretical maximum: 100 IOPS
> Previous: 90 IOPS
> Kthread: 100 IOPS
> fio --name=10mswriteasync --rw=randwrite --direct=1 --bs=4k --runtime=60 --time_based --filename=/dev/mapper/dm-delay-10ms --numjobs=32 --iodepth=64 --ioengine=libaio --group_reporting
> Previous: 13.3k IOPS
> Kthread: 13.3k IOPS
> (This one is just to prove the new design isn't impacting throughput,
> not really about delays)
> 
> Signed-off-by: Christian Loehle <christian.loehle@arm.com>
> ---
> v2:
> 	- Keep the timer wq and delay design for longer delays
> 	- Address the rest of Mike's minor comments


Hi,

I've picked this up.  But I fixed various issues along the way.

Please see the staged commit here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.7&id=c1fce71d29b2a48fd6788f9555561fda0f0c1863

Issues ranged from whitespace, to removing needless forward
declaration, to removing stray changes (restoring 'continue;' in
flush_delayed_bios), actually using a bool for bool params, fixed
missing mutex_init, and use max() rather than opencode comparisons in
the ctr.  I might be forgetting some other code change. ;)

I also tweaked the commit header for whitespace (line wrapping, etc).

Thanks,
Mike
