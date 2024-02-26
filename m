Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93EF1DFEB
	for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 18:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973231; cv=none; b=ekABUpTGm80Y0kQElIJuYBVXl0hzV6Yd86l6PjnlSr9+1+25ykg1Y5peuFMGsIfvnstkKNQnsim+J3IVZqQPvVapUYAfQp02cA7w5GHZyDWTinQRjmS3Pr7tucLD7MD5Gk1G8qjphhJWi69IQMrabZ5JVi9Z6UYgcmuULQLXj/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973231; c=relaxed/simple;
	bh=D4J+iACiEQMVt1Yvog+GeKbpf9dV3YV9YJZuQfPNjjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QDrbf2OAtOfhmxLOLpctYryPW3fVLebq6AWNTaRtZxAtexWzoMKVdv7GSplzqBEafyJgXTM/j3zrCXhhXqgUnT4l0ZcJBfyi8BhU1XkyLCds0t4rzdof+tUUtBE5xOdiV/4muAU8JxtQX/wJadKfP4PqdZvLLGhyEhLAVauF1nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lv4YHDse; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lv4YHDse"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-59fd6684316so1491061eaf.0
        for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 10:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708973229; x=1709578029; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PFL8pDiC7nUP+eFCvCdg4g+ZRJAF9hLv9BvAZ0ru27I=;
        b=Lv4YHDsepYjqsN2bdWuHtfJNA7y3GpURgzE3dUQjaTIPWKaENWeL84xcUw5hHonqlN
         K1YA1CFXEVAMVoDodL8JA63UJYpIK/ELxGDZhUPvi0ZOvSZWKYIVpkIppOS5QWG6GdTW
         atsLt10gMpSorXUVt0K5W444XjU1zkuYoBWPhw3nlOZGvVyDDHxOEy6LvjVqy/3/mn30
         VgutX6H1UndBF01OrcoZUbNcpzhGiG+a9BKs9czkMsHs4oZjwRXRwzstAFskS9XVYih+
         CNM9YzVVHpbFL1yjWHYwOSQZq/fPVsG/nguBlXozkXW3ZdO5vD/ZeYlW0pUN19gLda9R
         TaIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708973229; x=1709578029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFL8pDiC7nUP+eFCvCdg4g+ZRJAF9hLv9BvAZ0ru27I=;
        b=Px5CV1i0J0jzKDInHGu1h+wSq/bKFWRiSgQM+b1ZpVubNIiPERAcO3Dc7xF9T6yjef
         x6td9cYZrn1Dr1AmYMMaKMa1JqoGY9X+VKoOn4Tl7MtCjApxjX0UweoEv84c3dfXKwt4
         r8mypETw3OHc4yapQ6lN5SGPDRZ7+z9Vax2B93H1aUKqixmbW9wh74QNzOD2HWyWcvP1
         g+IbWLRuny6JeyDkDwXxwZoy0qi/1CMB/gTvWnrYwvSaZJ2kwoB9bvYXzfq0PGOGW72D
         GIvCbJkSbuPDgisuVe1ZmeLos/x/Iiax3c+XmsHfn44pA8Q3KENZ5Pa2VXtBJA8KmY/k
         clBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVeQPXEqvKEv5HFqW8XNPYyu12Awokd9n5AcZZgXsPW6EJwLXiqgc8OVeI9ifze/f7luJMTOYTQNTCL93NQfw0jNRMf0C3F4o=
X-Gm-Message-State: AOJu0YxRtvfp9OmWsnDSxB5tT0bEyOqT7t3byB5+x/G3JhcgGdgOAfiK
	yjFY0MFn9UR3LPODoPN5X5uZAmzwOBCVYf4OoCxrZ4JdWnYHB16R
X-Google-Smtp-Source: AGHT+IE/z/ZckjyccWtrq/CQPSJPdlaFy9/8HNqmT+/ptTbkYGWVj24Pf5Ol4cbQHtjyQZpqiJDyOw==
X-Received: by 2002:a05:6359:4102:b0:17b:b52c:c121 with SMTP id kh2-20020a056359410200b0017bb52cc121mr1452236rwc.13.1708973229018;
        Mon, 26 Feb 2024 10:47:09 -0800 (PST)
Received: from localhost ([2620:10d:c090:400::4:31e4])
        by smtp.gmail.com with ESMTPSA id a22-20020a631a56000000b005dc832ed816sm4293862pgm.59.2024.02.26.10.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 10:47:08 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 26 Feb 2024 08:47:07 -1000
From: Tejun Heo <tj@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 3/8] workqueue: Implement BH workqueues to eventually
 replace tasklets
Message-ID: <Zdzcq_Z9iGb4XC0B@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-4-tj@kernel.org>
 <ZcABypwUML6Osiec@slm.duckdns.org>
 <Zdvw0HdSXcU3JZ4g@boqun-archlinux>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zdvw0HdSXcU3JZ4g@boqun-archlinux>

Hello,

On Sun, Feb 25, 2024 at 06:00:48PM -0800, Boqun Feng wrote:
> Sorry, late to the party, but I wonder how this play along with cpu
> hotplug? Say we've queued a lot BH_WORK on a CPU, and we offline that
> cpu, wouldn't that end up with a few BH_WORK left on that CPU not being
> executed?

Ah, good point. tasklets get transferred out of offline CPU. Workqueue
counterpart doesn't do that. I'll fix that.

Thanks.

-- 
tejun
