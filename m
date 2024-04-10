Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038FF17BB17
	for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 17:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712771488; cv=none; b=eZmSaTagSDfsg0BgdyyoxmYOK4L5ySFDQ9osbvh6LBVrGIkbCt8mayCljIoYjq1K6VnIysxHx9eS3Gyj3jkA2kSaAcKpoiVkNOvfB5KPJr6irjFad5uTfdWTN6hT+Y5KeEc+eW5XkFyA83Hn9rlpGrMAvzQy6c2JGVW5616tbCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712771488; c=relaxed/simple;
	bh=D5g9dKCapGU/uTqenguqmTBnD3q1hWyUfcaskRjyhIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R22lu72G9E33MiL2PXW+jc+77tOBP6gYV+EjuuQ+2EaLg/aT7a5MUoacdQiV6n2qgW5mspeoz7jxPdxPM/vtkYLgwLwijXwQFhfizmpljdzs5lTHbp6988hGvL/84KY4MOF6pM1aBYUCD3HR85yicKg4d9i5QqboAFKXiDn2xuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bt6LteYv; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bt6LteYv"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e3c3aa8938so34881335ad.1
        for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 10:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712771485; x=1713376285; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QClVgWhE5RKcdKOXPBTCS58BRjJBS/jAPujqo6I4aBQ=;
        b=bt6LteYvElkiIaC8yIxPPd5+Xh3jodDZA3DpiHWfFtR/xtiNfgonwmKhBoPXjA+tEK
         DrDO99ha3mqpdnQVRXbfKPiHyDUhBzHq9/Kahy6n2grRiGK5+rxlYTqCHd8Cab3KQ2zb
         XavZIqcMvJrUGanIT3VHM8D0V1AbhARFHUlR2ZC8AzRnuzHsQ5HGgof+tGTwNaFo3cyj
         eWIL6JwUy5yXOvouLYk1n28SuA3GEJFsCNymZWaPF8Hdvo5eNpXfrD0n61QLuE74P9oS
         8KjonDn18AYokbBF8Vzhn15XnRA06fCV6WV/zV56GuFSdihIKWtjhJL4uY87jkMAYVoV
         bDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712771485; x=1713376285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QClVgWhE5RKcdKOXPBTCS58BRjJBS/jAPujqo6I4aBQ=;
        b=jemA8xKmUnw+L2upaJAZRFv0L/3Z0P2KJ2uVGJ2koDx5m3FQ5bnmE08Td8fEHDDRiB
         GAIc9Z3sYtKkP5LriTMRwEBDL01crSTC46IO3FkJpfQZizUJGAYdG2EUj8cHNQIQgJkW
         Ibia1TXvTgGwo1TuD+zzGIZxkfelD3zc6JVCk+w+YwnJCKGW3Ybfqrg61T6nkHc8lL+V
         vQH/D9IjcHQB0Nsebwc4LAPnAEQMFdqieAEEfeXz8zAbtxUROny29ep6Zs0zmDPsTuCn
         gOKL8BvMZE9hs98H7xHTfHf7mF5QSK7/zQmolhEcoOv5ONCj8VwAUvx8/cgtsUI2daBj
         OOMA==
X-Gm-Message-State: AOJu0YzHl/VaBJtj10NdJJps4MnGqL1Uxe2g0DLQZ+GGcTkpieADAXiG
	+Yys8IF0YF2imBLtKB0X0I85oeMimLvTiyNM2d5kTj8L+hTrCB3QpcZw0+c9
X-Google-Smtp-Source: AGHT+IG00gdxJU998Et66RF7sgFk5Qgh12osD+0dHHqugbavk5R0MqCR+QGSgYMG+S5ZIS5FQ0jEUQ==
X-Received: by 2002:a17:902:f14b:b0:1e2:6d57:c1bb with SMTP id d11-20020a170902f14b00b001e26d57c1bbmr2675685plb.21.1712771485118;
        Wed, 10 Apr 2024 10:51:25 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:a5f4])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903244800b001e530aab374sm240436pls.194.2024.04.10.10.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 10:51:24 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 10 Apr 2024 07:51:23 -1000
From: Tejun Heo <tj@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Message-ID: <ZhbRm2i3OeBVwE44@slm.duckdns.org>
References: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>

Hello,

On Wed, Apr 10, 2024 at 05:45:31PM +0900, Shin'ichiro Kawasaki wrote:
> Commit 5797b1c18919 ("workqueue: Implement system-wide nr_active
> enforcement for unbound workqueues") modified the maximum number of
> active works that an unbound workqueue can handle to at most
> WQ_DFL_MIN_ACTIVE (8 by default). This commit thus limits the number of

This shouldn't be the case. The default max_active remains the same at 256.
MIN_ACTIVE is used only to guarantee minimum forward progress guarantee when
@max_active too low in multi NUMA setups. It's unexpected that the commit
caused significant behavior difference on a single NUMA machines. The limits
and enforcement for single NUMA machien shouldn't have changed.

> active dm-zoned chunk works that execute concurrently on a single NUMA
> node machine. This reduction results in garbage collection performance
> degradation which manifests itself with longer unmount time with the xfs
> file system on dm-zoned devices.
> 
> To restore unmount duration with dm-zoned devices, drop the WQ_UNBOUND
> flag for the chunk workqueue, thus allowing more than WQ_DFL_MIN_ACTIVE
> chunk works. Though this change bounds all chunk works to the same CPU,
> it provides more parallelism and improved performance. The table below
> shows the average xfs unmount time of 10 times measurements, using a
> single NUMA node machine with 32 CPUs. The xfs volume was prepared on
> dm-zoned devices on top of an SMR HDD with 26GB dm-linear clip, then
> filled with data files before executing unmount.
> 
>  Kernel              | Unmount time
> ---------------------+--------------
>  v6.8                |   29m  3s
>  v6.9-rc2            |   34m 17s
>  v6.9-rc2 + this fix |   27m 12s

Can you please run `drgn tools/workqueue/wq_monitor.py 'dmz_cwq.*'` while
testing? It should show how many work items are in flight and how much CPU
time the workqueues are consuming.

Thanks.

-- 
tejun
