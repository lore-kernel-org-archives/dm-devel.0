Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E20947E
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 03:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929759; cv=none; b=WMwS2WyxwqeS8LjHeLRLp0HqjzCjgh0V0tZbDLgn3T43UXeGkJl0N88UQhfDL+IoNN7l+1RiCQQdC5YmnQ6uPoZSYn756PmypwR4ROnA1nxQmY28lvLH8e4Co27ly87FS49PFWXBR+POyOXkay52De+WWTbF3hpMmolLqyf0Poc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929759; c=relaxed/simple;
	bh=JwK/dbIxaWptB2RhQ9uRvZfMOjQTtoDNhMRznP/UqKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0S+5yPbmEvWKxvZQ5CADO6RI3oRw7xzsYmu3h5agFQrzX50xmaPmPswlu5m56NVi8eHsgNeIuSss7m1xJI46vonNoTAW437/rbpfdzg8EKQ1ZAGHCuVfkigZJY3AXUa18e7oh6XFFYE9c0CG36x2uetWOINK9VHoJscTuuWtUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jof1areH; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jof1areH"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e2c725e234so3936715ad.1
        for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 20:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713929758; x=1714534558; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iovjPUoBjii91EbA5LBmNWR1OvCfHoM4dBJsUW8BYkE=;
        b=jof1areHEKq/LpDzxOfUCH1+6WA2UvEJy2ZAhTl/KmYcKePUP3AFVK2rJtGHTWEfC4
         y1878J5eZMfAPa/EHrz6X4480FzcqcijexvDOpyLWKlgk8gRduFdOKF7bbsCQ85EaPoX
         cdcdcSFUkMr8Ga5yfwsJYPVvivgu/kPSedSeVr9HESwhJlP3FGbCdSoSDWnvIo5y6Rlx
         P6QeON/OWDLyWqFnFZ1/2e5nrnzbPOn5sw3aViOVW8z8Xgr6nZeYRz99gSPiRJEoaFT2
         Ao0hfONgRiTEqDWeYoNMCiy0FVSlaVMjvfiU5SlDte2Be/LhJMYo64OK3B2eS2OzxS9C
         6Dcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713929758; x=1714534558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iovjPUoBjii91EbA5LBmNWR1OvCfHoM4dBJsUW8BYkE=;
        b=Jgpnwbw0mgqMBa7QjrRw7/1ftQOyfTDjshPoYyLsq7K8q1fc49xHC3B8TctGANlKE/
         DawLcjYE/CmortazUmgxct4JiHiWNlCVDuTUeHGTm9zLGPwDjxJlN9RzuWron7U/cmZk
         CycZZ6eBLQz+jFSq/6yoE3eopblXVf/NKLVENZwvqWqLwy4AikyVfc9H3xp40SPcpaUF
         LqzzbWgbUK7YWct9Bg697rGQLz0pWoKD2QjWuQxFhh2wvXteqLu+dfnVKitEThNv1uxo
         LC5/DDSVbcLK6QXn8PiGfdI5bQ20q0U+nMyeEwRBAfca8oFBR7KTKAQlDpof4dVxfbIb
         kdIw==
X-Gm-Message-State: AOJu0YzZp3SIy6+lKHO7lfysC/NPnDIJGhLYbisMJ4HGvGHc7Vgnc1jT
	3bgs+FR4k9E3hilhYKNx/nw1yBxqGRq0kEN3k+6JPxchEQMlftXU
X-Google-Smtp-Source: AGHT+IF8ME0QkL0Rg/LVV5viucXaiTQ4qryWF+rDCSDYnUB2QGOXTckp6Ek8w+lonE0vtJ9ksSi9zQ==
X-Received: by 2002:a17:902:f682:b0:1e0:bc64:a37a with SMTP id l2-20020a170902f68200b001e0bc64a37amr6167288plg.8.1713929757605;
        Tue, 23 Apr 2024 20:35:57 -0700 (PDT)
Received: from localhost (dhcp-141-239-159-203.hawaiiantel.net. [141.239.159.203])
        by smtp.gmail.com with ESMTPSA id n6-20020a170903110600b001e668c1060bsm10781772plh.122.2024.04.23.20.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 20:35:57 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 23 Apr 2024 17:35:56 -1000
From: Tejun Heo <tj@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Message-ID: <Zih-HANo8RV6L-4Y@slm.duckdns.org>
References: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
 <ZhbRm2i3OeBVwE44@slm.duckdns.org>
 <kmi647h6yrkpc2d5zfbxzvv6yi37yh3aonbbjkohvbf44s7s3n@frptyb2kp5vl>
 <ZhlugLZbFk8xUbJ8@slm.duckdns.org>
 <nl3ys53xadoca2qht2r5ikjh2vrxyrlwvs7n5nbitzxuxx4maa@daejezc4mr6z>
 <ZicERHDW2w02sJQA@slm.duckdns.org>
 <ZifiSILH9MlSDjxw@slm.duckdns.org>
 <isfz6pnm2l6aizihmdrksktlcpkkbnkmxgc55ar4akkrmggecc@lxu4tko3ht5k>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <isfz6pnm2l6aizihmdrksktlcpkkbnkmxgc55ar4akkrmggecc@lxu4tko3ht5k>

Hello,

On Wed, Apr 24, 2024 at 12:36:45AM +0000, Shinichiro Kawasaki wrote:
> Hello Tejun, thanks for the fix. I confirmed that the number of in-flight works
> become larger than 8 during the unmount operation.
> 
>                             total  infl  CPUtime CPUitsv CMW/RPR  mayday rescued
> dmz_cwq_dmz_dml_072           613    33      4.6       -       0       0       0
> 
>                             total  infl  CPUtime CPUitsv CMW/RPR  mayday rescued
> dmz_cwq_dmz_dml_072           617    33      4.7       -       0       0       0
> 
>                             total  infl  CPUtime CPUitsv CMW/RPR  mayday rescued
> dmz_cwq_dmz_dml_072           619    33      4.8       -       0       0       0
> 
> 
> Also I measured xfs unmount time of 10 times. Its avarage is as follows.
> 
>  Kernel               | Unmount time
> ----------------------+--------------
>  v6.8                 |   29m  3s
>  v6.9-rc2             |   34m 17s
>  v6.9-rc2 + Tejun fix |   30m 55s
> 
> We can see that the fix reduced the unmount time, which is great! Still there is
> a gap from v6.8 kernel. I think this gap can be a left work, and hope the fix
> patch to be upstreamed.

So, v6.8 was buggy in that it allowed a lot higher concurrency than
requested. If higher concurrency is desirable, you can just set @max_active
to a higher number. Currently, the absolute maximum is 512 (WQ_MAX_ACTIVE)
but that number was picked arbitrarily probably more than a decade ago, so
if you find higher concurrency useful, we can definitely push up that
number.

> BTW, the URL of the Link tag is not working. Instead, I suggest this:
> 
>   https://lore.kernel.org/dm-devel/20240410084531.2134621-1-shinichiro.kawasaki@wdc.com/

Ah, updated. Thanks.

-- 
tejun
