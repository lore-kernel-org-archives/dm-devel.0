Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08974A99C
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 20:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707166245; cv=none; b=jlUauaJ1MSrB5rt1cHNO7dxi1riM4jNOljVoBY2i3otmf6ctzPbt1utAY14DWEstP7w+H7/NSlV2xgwpQhjhNZi2GDPUDdW04vkO2VD+IRJr4JCthLg1oYDUT/3+AQU2sF/yL8CDeCmLnPH6o7gf0q5teqToO8uqG8R8BrYmyQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707166245; c=relaxed/simple;
	bh=lUkPMd5XHACLufFZ79Zzokj1SM1sqqtoROpSlvJd930=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TInkNa7y8NTeMqx/Y1/KWeIsfZ8NcmVLy71zNHKdiZpuYkqjN/o0ma6DtnhcC4ZE09uWSmvzh7u760xrqpYTEsNKFlUd+uiOLLw1duExAciOVvHSgGgK8bNVrMKUI5ARk1duM/8EDxdXVekD6QScLKWFRly7o1qfCyJHwVyNvUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SahZlund; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SahZlund"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4b739b49349so1592492e0c.1
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 12:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707166242; x=1707771042; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b5yztHDEz5ryVDr2lFRitQEpPkarGvjyutYElBOoSfQ=;
        b=SahZlundLwCMnaVlBU6fRM15ia4+bs0iiJCRPK7F6vOYdx0Tktq2Kh7kJFFxyjTbGj
         nQ4+DzGiWM+xvejQWnmjWe89yKW8KNWw/FjzW20YsncATPfjdXPJAzKAHwQHtbiArVQ3
         pzr3j4iVh69ZkUJk/3XhpAa4lY7GaNgQTkvj0kDouMN3BUsQ4Yr1KKVLN7jYACuOMAFO
         mxm0rmd1AGe6sDqUnbfgBL2vMCoGKSFKSr43XTbHG/ncwOEiWzTYHoFdLYfli65hLiVD
         GtAFt9whqBtsOHIIKoL8UiGx/SmH9vMTHkWKQIc3oJICwGEDyUDraQ7s7dPYGqIty6cu
         QE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707166242; x=1707771042;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b5yztHDEz5ryVDr2lFRitQEpPkarGvjyutYElBOoSfQ=;
        b=R+FvnD1/9msmXC2GQDs7X2VkxsagiVLIZ40Z0u0KAthS1Sli8mip/a2TeCE9ug5DTa
         Mno3Re8mC0Av9eBT+LDP1YlgQObI7I8eBEJW/bDbESLralZlXkhz1XeJ+u2bzx3CGNWE
         z1DG9VhUDUd3odK/KERvhrSR7QIW7Mf6n8Fvf0B534jP5IoJxao/egiINyySldMD1nK6
         95kP+LNoLtnlhv9z/DaKdnWapTqAWIg6pjN4Fr/8tn4K6FynmnbceqQjTWo3RtdKugfi
         z1X4lehsZzbIAyqXeS3Uzu9kKv0UY41Na6k8rkced3/wT/OooplTtEnKbtfpbxBtigAO
         ZWaA==
X-Gm-Message-State: AOJu0YwkLwzr6qJ9oT6ZUU1QEBvsrv5ZbbGYD9Au2FkTbPKyw3iZznxT
	u7N5mNcblb0a3PKL0QJ87r6eoOSPctd7HktQkZmCOFj3zSc8h4N4P0TXdu4ziafaSjzOfvuCkV6
	+2LZi+JsGQi51JImZZ2wvjlu1zWE=
X-Google-Smtp-Source: AGHT+IGcTxkm6GLg4DTYAnRBYG+ywiXp6c9pDzORkTwj5jst1Jo0ekpU2xdI4zbfCGteDDo0jOxw5hTKH+089BOk2LE=
X-Received: by 2002:ac5:cf11:0:b0:4c0:3545:285 with SMTP id
 y17-20020ac5cf11000000b004c035450285mr657728vke.5.1707166242440; Mon, 05 Feb
 2024 12:50:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <ZcACvVz83QFuSLR6@slm.duckdns.org>
In-Reply-To: <ZcACvVz83QFuSLR6@slm.duckdns.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 5 Feb 2024 12:50:28 -0800
Message-ID: <CAOMdWSLNMqsZNJ-oCLN2RjckZmJSvdU_Yq0F0frmqMqa67Oy1g@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

> On Mon, Jan 29, 2024 at 11:11:47PM -1000, Tejun Heo wrote:
> >  0001-workqueue-Update-lock-debugging-code.patch
> >  0002-workqueue-Factor-out-init_cpu_worker_pool.patch
> >  0003-workqueue-Implement-BH-workqueues-to-eventually-repl.patch
> >  0004-backtracetest-Convert-from-tasklet-to-BH-workqueue.patch
> >  0005-usb-core-hcd-Convert-from-tasklet-to-BH-workqueue.patch
> >  0006-net-tcp-tsq-Convert-from-tasklet-to-BH-workqueue.patch
> >  0007-dm-crypt-Convert-from-tasklet-to-BH-workqueue.patch
> >  0008-dm-verity-Convert-from-tasklet-to-BH-workqueue.patch
>
> Applied 0001-0003 to wq/for-6.9. Applied 0004-0005 to
> wq/for-6.9-bh-conversions. Will proceed on 0006 and other conversions after
> more perf testing.
>
> Thanks.
>

Thank you. I am basing my work on the branch you have
pushed.(or-6.9-bh-conversions)
https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/log/?h=for-6.9-bh-conversions

In the order of priority, I have started converting drivers/media/*,
drivers/dma/* followed by drivers/net/*
which constitutes the majority. Putting my plan out here so that the
work is not duplicated.
I will write back in a day and share the branch for review.

W.r.t the conversion, there are drivers which call
tasklet_[disable/enable](), which I suppose
can be ignored in the case of workqueues, I am not entirely sure if
this is the right approach.
Please correct me if I am wrong.


Thanks,

  - Allen
