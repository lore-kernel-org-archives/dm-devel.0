Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EC2144038
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 20:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709239053; cv=none; b=RXGVlQNR1/YDMsFMMWuHivlH96Uwj9JD9NmyjjOBS+bItqU5cVQ9AJeGTAnACrZIOSmw7ifN2ZDU7tvGmUlW01+5KDIgmnkBlUHzDjpl75T1xREFVc0il9y7AbAZs34yPpjq644zA5M2ThhvkVPIRGgtQmQlO0lKNMhJzZdOAyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709239053; c=relaxed/simple;
	bh=ii4D7YiCreEVMR4r5RTvfhi7WZ6+lvbN3NGPlbGfYUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMys/j2UClzr/S2bsuj5Jw49J0KjB89bqSTei6KHe/kXSPMtPs/HszncR1M3p4jaaVQnPd8xi/JusrijgoQwizuEX5Mvk0JxPWDALoIVp/o5YY8XIScsblrKkAUJ8ndHKjL9bh30GOtoJO/MlTdZn94oxaaYEwpBHPeA1bPoBZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EnG4JDj2; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EnG4JDj2"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dca8b86ee7so13380065ad.2
        for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 12:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709239051; x=1709843851; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i5blMfwCgLp1FPPnA5HDVy206wgmfNgtw944me58i0A=;
        b=EnG4JDj22xaDgBllNFxuOFiZ/4YS9iPvVMcPh5Ay3+UmuWu0DKKnx2D3XFNSEKE1+5
         SS1AZK0NeKNXn91zL0xYkXRr7am66vz7TqCyk2MzTuGSGBaTT4FhQOf4pdXyL12/eUYv
         Ttc+K+jVHqJHTkRltxxGSPiNIz4RjzhWJa/PEPowGEvosWS7OyBCnszGMF6kyzelzSRi
         7X3Q2rUEHVW3Y+rBTGPnUNQMi7lo4m3rVXbSepMidrep8S4qLhHmhZ5rT+cx2aeDSSFu
         C04sN0ah3g4TLyS9cpTyndi29o1aGT/tHJQyr50krGT1D/QAEmp9tQH6F/ErAWUwR5OE
         4ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709239051; x=1709843851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i5blMfwCgLp1FPPnA5HDVy206wgmfNgtw944me58i0A=;
        b=lQgs1LTp5Turz3AYbE3pLTmN93enM6kdt94xAxpZdSGZYDVnwx0gg8GWkR1IEonfHd
         CW0WYao9BAvm7Pqx38qgQQeK5PZjGuaSo/yqXrjQNYPv1G+QDGZsb9aOh7JRZYm5T6S3
         37wAsgg/+V9qaoAeb1lY1hJy0jEoZUEHzMvzLF2b/3p9TcH4uiIHji51fnUe30DNHQXR
         Ya47SYoAmv2ssCnU1Wx8mLjkGhwSsRow46RGVivTy78vIS/2SKOqkx1DC2Wge0lxH5Hn
         sYv7BkI457FxdW7qrJTuISXFCcZ/wL/uDhJdVdVfInsFsXfR96hIwOYKgYUFiyn8cjgn
         viJw==
X-Forwarded-Encrypted: i=1; AJvYcCUYb4dvLD2nXW/bUGdGHrTwGnYuow/MxtLf3oZx7ys1fx8G+c+FnXGVF690Mqh1w9QTp0K6FPmmmGpOcqSsjfJz1JTKTKBoSd4=
X-Gm-Message-State: AOJu0YwVapNHt6SmAVWwUH679Ax5wXxxB1WUCkQ0uaarxb0CxTMWOQ0s
	iA1nOGPH3g3WaiqfAYYoE6DkoqdRA1/4wNBfpbSsJDby5W7u2pedkGC/R8Dsgbc=
X-Google-Smtp-Source: AGHT+IFceYVsyf342UvaMXXreAwvaQzmHEhFmJrWZ40V54W++PEy915RjWYjmCRa7EohfqoaHubDsA==
X-Received: by 2002:a17:902:c403:b0:1db:ecf1:3b67 with SMTP id k3-20020a170902c40300b001dbecf13b67mr4292849plk.66.1709239050771;
        Thu, 29 Feb 2024 12:37:30 -0800 (PST)
Received: from localhost ([2620:10d:c090:400::5:8305])
        by smtp.gmail.com with ESMTPSA id y5-20020a170902ed4500b001dbb06b6133sm1920015plb.127.2024.02.29.12.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 12:37:30 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 29 Feb 2024 10:37:28 -1000
From: Tejun Heo <tj@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH for-6.9] workqueue: Drain BH work items on hot-unplugged
 CPUs
Message-ID: <ZeDrCMLlzVZpvbrG@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-4-tj@kernel.org>
 <ZcABypwUML6Osiec@slm.duckdns.org>
 <Zdvw0HdSXcU3JZ4g@boqun-archlinux>
 <Zd09L9DgerYjezGT@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd09L9DgerYjezGT@slm.duckdns.org>

On Mon, Feb 26, 2024 at 03:38:55PM -1000, Tejun Heo wrote:
> Boqun pointed out that workqueues aren't handling BH work items on offlined
> CPUs. Unlike tasklet which transfers out the pending tasks from
> CPUHP_SOFTIRQ_DEAD, BH workqueue would just leave them pending which is
> problematic. Note that this behavior is specific to BH workqueues as the
> non-BH per-CPU workers just become unbound when the CPU goes offline.
> 
> This patch fixes the issue by draining the pending BH work items from an
> offlined CPU from CPUHP_SOFTIRQ_DEAD. Because work items carry more context,
> it's not as easy to transfer the pending work items from one pool to
> another. Instead, run BH work items which execute the offlined pools on an
> online CPU.
> 
> Note that this assumes that no further BH work items will be queued on the
> offlined CPUs. This assumption is shared with tasklet and should be fine for
> conversions. However, this issue also exists for per-CPU workqueues which
> will just keep executing work items queued after CPU offline on unbound
> workers and workqueue should reject per-CPU and BH work items queued on
> offline CPUs. This will be addressed separately later.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Boqun Feng <boqun.feng@gmail.com>
> Link: http://lkml.kernel.org/r/Zdvw0HdSXcU3JZ4g@boqun-archlinux

Applying this to wq/for-6.9.

Thanks.

-- 
tejun
