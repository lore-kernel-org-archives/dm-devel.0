Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB6660888
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706606384; cv=none; b=EMbzah6wk6WeLrNoqaDPnyO5L5lgCLtbDfjIpacXd0AB7cRKio/ppKyUs8iGJa4ph+gOr3gexrUw0/ZJz/o4Q/6i420iuizj4M/0vR07pg+2DJhFYWLb6nFcPLOUO/PIdcCgaO/LTdIWUL7b3YReuidLcU9YQHbYHcfrhq8bTPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706606384; c=relaxed/simple;
	bh=BuQ21+ovIZw4O3X3gm0jwHDGVMsfPwdAs6CkLmSfngU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSGWSTxx4wHpeSUgMI5MQoDsqq8SFpXuqyGKA+ev/d8dq/dBmC5sU8NFlkzYYox7DWH/MHzYCO3owBugHFo/Z8kLIIL0Cmmj+tNLvyBd8TyZVBzrSnC5zaeHJlnNdRmKfbtb0z8KHO2yz6kfNEPIE0Z2/tj7HVUktzkAPs0tdO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uqd+ycKz; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uqd+ycKz"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6dddee3ba13so1420285b3a.1
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706606382; x=1707211182; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PIxMkx8XGFZp5+ArdrZFjloeoHh0HNlPldRTN466UNk=;
        b=Uqd+ycKzMeRERT1fmKvDO1muw30wTb79LzESiVh+VWfF5i2Po/9rfS56O8BuPBtB8Q
         TTuCKO0k/HhwND3Y6w32OEpv8qPAe1Iu8c/xAqqo01lRgPyB0m7ffTbTRW+R+Rr6BSkC
         NVrlYkwrrgtwd+Zzeut+rTfTCUxvUQyY6FVAL0y2Kec8uKmxN4R5sBJp4hcHu8R735WY
         kBi1qTc0t8zBIjmyTn6oZkFN6L4JwtTNw47F23MvHn3wnnLhAeBH1OLZpljveuc1qPia
         ezYGebYySVXxPx2z33PlecdyZD2uxZqWoYz6ONDfXjrPQqz0vZ/5j8Tn5gsqq71r3KF8
         9qBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706606382; x=1707211182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PIxMkx8XGFZp5+ArdrZFjloeoHh0HNlPldRTN466UNk=;
        b=ndZ20sxrdAsKnkwVFmlLWjy4UxIlTBMkXZ2cOZRguy7y7J2p+Xu0tDfhY/5913tO0B
         xWKO7HUyJrsL8QGwLjnBFsMOGb6rtGajrribtAurpjnVt14KJrrxNEvyWNSEDssiX+Qc
         yIZ3Wt2zCTpoNK96RtaxTZ0GkIHvFx4w2h/Qp/5G63xMfUg4irXCuoOQzPyu9j9VuxgU
         F+L/jyxpYb8hRWfzHYlaXh6rMuLfGcE4SAtyf0sOiiKmtI+c6kaSuXI40KZapGuYppP9
         /m0XzL8buD4mijGQH0p+UQxAuxmvso6dmLB3oclibwE29Hw9+GCwS/4ItOTuVmXxwdoO
         vAAQ==
X-Gm-Message-State: AOJu0YxDI9cgxHy8oRyOYHISGqar8NeRxU2nAac2qvfHLJPkUgUbg6Q/
	wt1i2O6rsvGON+lNEvBKtJDRj60CiJcySe0+u/3V4ovmYGCQj3RM
X-Google-Smtp-Source: AGHT+IGQdC4nLoSoiscOQZE9pZywsieV6oVbh3SRyarT8ETvZ7d0gpH15qiT4cLqoktVJeltXJRpKA==
X-Received: by 2002:a05:6a00:bc2:b0:6db:e491:c879 with SMTP id x2-20020a056a000bc200b006dbe491c879mr3924610pfu.20.1706606381971;
        Tue, 30 Jan 2024 01:19:41 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id g4-20020a056a0023c400b006dbc5569599sm7485770pfc.10.2024.01.30.01.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:19:41 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 29 Jan 2024 23:19:40 -1000
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <msnitzer@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Bob Liu <bob.liu@oracle.com>, Hou Tao <houtao1@huawei.com>,
	Nathan Huckleberry <nhuck@google.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] softirq: fix memory corruption when freeing
 tasklet_struct
Message-ID: <Zbi_LNCeuZDVC0HH@slm.duckdns.org>
References: <82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com>
 <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>
 <ZbRDnSyiSE93puQL@slm.duckdns.org>
 <ZbVNeVkGItt1KTan@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbVNeVkGItt1KTan@slm.duckdns.org>

On Sat, Jan 27, 2024 at 08:37:45AM -1000, Tejun Heo wrote:
> Should have known when it worked too well on the first try but I missed a
> part in init and this was just running them on per-cpu workqueues. Will post
> an actually working version later.

For posterity, the patchset is at

 http://lkml.kernel.org/r/20240130091300.2968534-1-tj@kernel.org

-- 
tejun
