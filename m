Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC569160
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 16:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889868; cv=none; b=HWJ2O6o1D5zxvh9Bhqg64Xl0zefBgfv4GwYmBWnOr8xwUlcuOVQLLtGg+AsaYxnsbGPCrMKUC4QcfPqyLUownoiyokT43PTnMWvi5SSKX/Ei/SSxGoYaAuHvgpaWVq5MabZvl7k/chr0cvBcePIrmNNqNslsGx5pYqfbF+dN7gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889868; c=relaxed/simple;
	bh=U2MZdd+9Rt41ocZdukFU7nbZdZgpQqPlgXUazYqpbCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+qUIUoTOjjtRZNV3q/RPjHNao6OFCoyoLPLJ+f4xSBwWWl+kQIzvIXbguzThLdCnjSdgvrwMZw0aecvKW3w55wEPGbtjDJ6W/Aj6wEVA5RXgHFUFu6V2NLr1UehXyN6JLvwKaiQw1n4k/CxkMKxnn4+k4UsvxkO1WuuzcbuhjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLwl+/69; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLwl+/69"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e65b29f703so45113895ad.3
        for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 09:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713889866; x=1714494666; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQdb+gb13aDffmyrVa1/DUF2z7QqWEjY6z0UkrAzU+c=;
        b=FLwl+/69wkNCnF1tMqD8kjLbf3R7A7aC/+AH9LeTNaUK5iqVHBMXmeWQ7+67++HKhQ
         6nNuSSz1BAs/I8k7rQ1ZqAvDBaHT7D+psWP59TOsvOgxR8TI7BtRRVP5gOe9/O0lhxgR
         eWmOlPBwPQFALWKL5brj6OH75RK2TXj/sDG5gKZJVG1rk0h9zSgJSvCpwz2/gyyhcNor
         o8Ewmd64lxtT5FTsRnMJTFn2zAAZ/B+uaanalFMRJz4uLcB0e7ZuVu+yUhwzbtDoEJJA
         aGDR6xwsfprqZGTYDKfzZcgEC1b0+NkxmhHLsW4K+RR/vfT6x47+CgjrcGlEA5OiTosc
         3NJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713889866; x=1714494666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HQdb+gb13aDffmyrVa1/DUF2z7QqWEjY6z0UkrAzU+c=;
        b=gZNzl83kQZVvD1EstjyHZ1wKDhHDBFSs4dtc9o8VmUcvb0/jkQrQKPsfmyEhHLqoq8
         EzyPne583/mPJqgHPUjJsKHYlW70j+SSfQkwTr6wqRorIh4zCBJC7g+m7HinIndoxxAh
         eDbbWIPnAwUaaQe11aATCl66xf2It1grXKO7kZnsnIcQdQvh/CbGNMwaj00fJIASvXjm
         F9f2g52VDJQ+fcwKCAE9eggSLdNKu0c5mqHzLOtAqx7wlFiCzf4Oz0lkn+1TdF6cLVGu
         uv6v3e/SZWDMxzmSNDn7ySudVHaEYeOtzhdkmaiMHOu7ylv7cggsVUvRQez6EqxGG5TL
         a4cg==
X-Gm-Message-State: AOJu0YxHj5SRQYRj30/1JfX9Xr8lIQlSy/eAM7+jmHFeK6UT6K8dhua6
	gbUELFayX/uWCqnBnaq/YsCMyEMCAGaXTKWl1CwgSbGl7E0+FxgZ
X-Google-Smtp-Source: AGHT+IGgOXBttlBybis4Yl+YOI8+hy+YskrDi9fkSbcz7YstfmX6fkhOeiTTaMhxOl1xhdTeg7l/CQ==
X-Received: by 2002:a17:902:da8f:b0:1e4:70d0:9333 with SMTP id j15-20020a170902da8f00b001e470d09333mr15717151plx.9.1713889866012;
        Tue, 23 Apr 2024 09:31:06 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:6f51])
        by smtp.gmail.com with ESMTPSA id e14-20020a17090301ce00b001e3f148ffd3sm10178482plh.201.2024.04.23.09.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 09:31:05 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 23 Apr 2024 06:31:04 -1000
From: Tejun Heo <tj@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Message-ID: <ZifiSILH9MlSDjxw@slm.duckdns.org>
References: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
 <ZhbRm2i3OeBVwE44@slm.duckdns.org>
 <kmi647h6yrkpc2d5zfbxzvv6yi37yh3aonbbjkohvbf44s7s3n@frptyb2kp5vl>
 <ZhlugLZbFk8xUbJ8@slm.duckdns.org>
 <nl3ys53xadoca2qht2r5ikjh2vrxyrlwvs7n5nbitzxuxx4maa@daejezc4mr6z>
 <ZicERHDW2w02sJQA@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZicERHDW2w02sJQA@slm.duckdns.org>

On Mon, Apr 22, 2024 at 02:43:48PM -1000, Tejun Heo wrote:
> workqueue: The default node_nr_active should have its max set to max_active
> 
> The default nna (node_nr_active) is used when the pool isn't tied to a
> specific NUMA node. This can happen in the following cases:
> 
>  1. On NUMA, if per-node pwq init failure and the fallback pwq is used.
>  2. On NUMA, if a pool is configured to span multiple nodes.
>  3. On single node setups.
> 
> 5797b1c18919 ("workqueue: Implement system-wide nr_active enforcement for
> unbound workqueues") set the default nna->max to min_active because only #1
> was being considered. For #2 and #3, using min_active means that the max
> concurrency in normal operation is pushed down to min_active which is
> currently 8, which can obviously lead to performance issues.
> 
> #1 is very unlikely to happen to begin with and even when it does which
> exact value nna->max is set to doesn't really matter. #2 can only happen if
> the workqueue is intentionally configured to ignore NUMA boundaries and
> there's no good way to distribute max_active in this case. #3 is the default
> behavior on single node machines.
> 
> Let's set it the default nna->max to max_active. This fixes the artificially
> lowered concurrency problem on single node machines and shouldn't hurt
> anything for other cases.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Fixes: 5797b1c18919 ("workqueue: Implement system-wide nr_active enforcement for unbound workqueues")
> Link: http://lkml.kernel.org/r/20240410082822.2131994-1-shinichiro.kawasaki@wdc.com

Apply to wq/for-6.9-fixes.

Thanks.

-- 
tejun
