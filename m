Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E865514C5A3
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712942724; cv=none; b=A1a9bSzfRvXMYCVX7oxVq2p5Fz8AliKQfJPmygt/f0RO72oyobKyUHpN636OzIfkFeXfdZSZgWtUExeFNueHACAW2KgrdeQfp9UV3weshcGtw4dpPK/feLnpmDHFUL17VcjiagsNvxV8JBmBeyX9WRdeXY7zcI5BG7MjcYAXqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712942724; c=relaxed/simple;
	bh=AWVuUg+SzssFlDLrwY3xHgXqy4B8D2Kd7ymwrTMs62g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lX+//B7YhxxMbmxOTYzteCOMqLSe002+/bpEDo3pU+YalGaLXNOccx5Nj/0iSO+HsYBGaeCxItLZw1grKZ+gtb7gkBuBfhdiRUPBnCJKOm/zIx0wVFNx53zUB/7f4g6+1iwtAp3sEtmX9/TiIi1LaPHf8RqqgogmfHFyHL+KVFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ETCnXMfy; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETCnXMfy"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e3e84a302eso8856205ad.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 10:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712942722; x=1713547522; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYf66cUODs+wVvucwNiDq56CdsdAM9mA1Y6KhMiHD/k=;
        b=ETCnXMfyLVhN62bcnm9mUb2Z4lmdvz5cZ/nHBrarOfslpnuw8i5izOHWiY2PnSbPMH
         WAvWOwOmh/CZc6LjA8QR/BDHcrVNMCeY7Vx0ZOrKxCd+oPhVTA5TzRQRI8YurWYskrpU
         M4SxwkgeaePV/kGD3VI9fdDw1EYP8B5YXv5IIe46LOAZqEo1TVmDDs2Dtg1cMhI4yQwR
         onsnqWFbxwnp17bVGz44GfDiji0D+J1cJAkKMY3x0oXFG2RklGEnLmW9JgVxnnsVhinh
         PvEgtplgz3bXlv1xQBNXP2X/HcQBrcmacBPXGnEn80GbZS5NxLygVQudX3+TvSkJHjI2
         A9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712942722; x=1713547522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYf66cUODs+wVvucwNiDq56CdsdAM9mA1Y6KhMiHD/k=;
        b=OBqOS7OZEJ+FRGkayudgjZEexkD28t+1AO6eWLSRdc39zK1krIYgpbH4ksYRDNBt2e
         cxNdxc+AAIcBh7Fi5Fz5upeNIewnZcTmDlKHyIKaIWflnay2fNFDzAQ+0LvHQikxWq9n
         L2iicVp2mL/vXEO3MfE1IqQa5+SzOo/oqdGuKM2j4bf/DX1b+IP3+n2ejAY8sGm+vU5e
         X5nuxuaYVJkSSUF3zDDxmLpF0SLPzqnTpifmAe4/lP8Mv0FQHzI7lHqc7f14CCqs+u+v
         jyrMoQ/fhDVQVdnV+vD0y8wqBwTQqeqzUX/+A7PIMsG95Xg7d1jIgN2Txn98ocxPIXbo
         Y5ug==
X-Gm-Message-State: AOJu0YzUqOyvsRCnEEPB4c0TGmPP+4rmYqvQSgWOLd/WqpKaje7rKwhN
	urdFN73tv6Ivcbe5UMO4vQ3prwwsDG71D+qWJw4Mje0FzBGk4o/i
X-Google-Smtp-Source: AGHT+IHIcvsX/I5d6VdRpW0/7DNZ48JAsAiI8F+m4/yBncLtWtcRQsOk9/k/q/FI/+wFr0JE09JE9A==
X-Received: by 2002:a17:903:124e:b0:1e4:200e:9c2b with SMTP id u14-20020a170903124e00b001e4200e9c2bmr3259839plh.21.1712942722105;
        Fri, 12 Apr 2024 10:25:22 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:a5f4])
        by smtp.gmail.com with ESMTPSA id v20-20020a170902d09400b001e435350a7bsm3226433plv.259.2024.04.12.10.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 10:25:21 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Fri, 12 Apr 2024 07:25:20 -1000
From: Tejun Heo <tj@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk
 workqueue
Message-ID: <ZhlugLZbFk8xUbJ8@slm.duckdns.org>
References: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
 <ZhbRm2i3OeBVwE44@slm.duckdns.org>
 <kmi647h6yrkpc2d5zfbxzvv6yi37yh3aonbbjkohvbf44s7s3n@frptyb2kp5vl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kmi647h6yrkpc2d5zfbxzvv6yi37yh3aonbbjkohvbf44s7s3n@frptyb2kp5vl>

Hello,

On Thu, Apr 11, 2024 at 04:38:34AM +0000, Shinichiro Kawasaki wrote:
> Sure. I manually ran the command below during the unmount operation.
> 
>  $ sudo drgn ./tools/workqueue/wq_monitor.py -i 10 'dmz_cwq.*'
> 
> Please find the command outputs below. I captured the outputs with three kernel
> variations. Each of them shows the output for a minute.
> 
> Kernel: v6.8
> --------------------------------------------------------------------------------
>                             total  infl  CPUtime CPUitsv CMW/RPR  mayday rescued
> dmz_cwq_dmz_dml_072           825    76     17.1       -       0       0       0
> --------------------------------------------------------------------------------
> 
> Kernel: v6.9-rc2
> --------------------------------------------------------------------------------
>                             total  infl  CPUtime CPUitsv CMW/RPR  mayday rescued
> dmz_cwq_dmz_dml_072           580     7      3.9       -       0       0       0

There's definitely something going wrong here. This isn't the expected
behavior. Can you please attach the output of tools/workqueue/wq_dump.py
too? What'd be the easiest way to reproduce the problem you're seeing?

Thanks.

-- 
tejun
