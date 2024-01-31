Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439F53A8DB
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 23:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706743164; cv=none; b=uGWXk0OtCkMewBOvGOTom4fjTzcDAR8NoYuoV3mPkpyERj6Ga3H2IjrKYDQeraMv5bLxuriViSfWxW8tufNbkRJsz53QeSRck2PLLdCbndydSROB733/FR+gBANg+/c6F5W58kk/a0rNxRPINgZA2uTQ3TtHtO2+wC+dwdN9WU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706743164; c=relaxed/simple;
	bh=xblL+yrpEo1gb8xzx/6pV+ZF6z63Q7arn5+fxeove9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cz/YXpu/G6THrx366Vppz+sw9zZQeBH5mJt8D6Ak4wd5s6IySHYpXgLEq3+U3rQ5UWxlwSDQ0V8jFzJp1G3WiKoGaAf7UlSwMLMHBaCofF1DmBV09tRat3ebW5dArlDoBd03DjEO284Z48lGCcnoPrBMb0YHPwF0hIY4NjdV+9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RaNe/nmH; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RaNe/nmH"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a35e65df2d8so30183666b.0
        for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 15:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706743160; x=1707347960; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LFVGRon0CDQR02O+c0btFX180m2QPPnDAgbj2eP6Q1I=;
        b=RaNe/nmHkXvVw4ERXzSnMju0kXBT/fMChP2tZZkuM0SYa51+I2xBK4QIgPvJlQFgUp
         LYBxkZE3IU9GtKghmovoONQC6LbpFfKhj/Nw/QoMarXso86tcdEeLoyxk/Brp0XhYseI
         nvVz/WycGJy7y4QPyTnRyZFUd8jXloF8zqH/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706743160; x=1707347960;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LFVGRon0CDQR02O+c0btFX180m2QPPnDAgbj2eP6Q1I=;
        b=BZXOqy2Mbhf4HMKHiFDcwz86GhPE9/8aF3L5VT+i/SwAHHtWmLKVSApmHZ+ocvB5Nf
         IPR0aW4FvIQXh4TKV5I0VRwgPl5JQqX5GU8qLdRTEW/dyTUQ1DjqE2CO5QL9bT2pqGq3
         6Bosld+2rVN56ouGUVgCa026gXLwBJz0ol8/Nbk9bJAMAlAndxHxzgIA84a5WC5MqIw0
         6ZbnzgjBgvt1IeMjd5G7el5yhn4MIWblGS2BTNCGEbOdyEFzfkokgssOUMlHaxpbqTMf
         rYxB1EgwHbXXcxITjvatVcgQbyUDRlr+sX9PgJ+2HeUFVqe38vTAa3O5DzcRZBVRcvXT
         OZ8g==
X-Gm-Message-State: AOJu0YwYMY9IKQ1/Cc9tgKtngYy5qcV/Ag+WppLJd3+ptpCOHU+bDY0U
	HHM5IyOm/mTtFP4Tvz9ILNip/kVG7/t4JYjqS92Vgy0B8hjMvz5hSQ2cZSAyMQYDRSz+vzDYIR7
	S1x54jw==
X-Google-Smtp-Source: AGHT+IHTQ735mds5A6UPXGwuemT0L85wjF7z3O8+X0LtXt8zF5FoJU5u1RXuX58jvH4ae7CmhnzSLQ==
X-Received: by 2002:a17:906:e0cd:b0:a35:6b83:2a0a with SMTP id gl13-20020a170906e0cd00b00a356b832a0amr1791744ejb.36.1706743160268;
        Wed, 31 Jan 2024 15:19:20 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id hu19-20020a170907a09300b00a31c5caa750sm5849031ejc.177.2024.01.31.15.19.18
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 15:19:18 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-55f50cf2021so369794a12.1
        for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 15:19:18 -0800 (PST)
X-Received: by 2002:a05:6402:895:b0:55f:aa1e:2a2e with SMTP id
 e21-20020a056402089500b0055faa1e2a2emr474082edy.8.1706743158122; Wed, 31 Jan
 2024 15:19:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <20240130091300.2968534-9-tj@kernel.org>
 <c2539f87-b4fe-ac7d-64d9-cbf8db929c7@redhat.com> <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
In-Reply-To: <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Jan 2024 15:19:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjMz_1mb+WJsPhfp5VBNrM=o8f-x2=6UW2eK5n4DHff9g@mail.gmail.com>
Message-ID: <CAHk-=wjMz_1mb+WJsPhfp5VBNrM=o8f-x2=6UW2eK5n4DHff9g@mail.gmail.com>
Subject: Re: [PATCH 8/8] dm-verity: Convert from tasklet to BH workqueue
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, msnitzer@redhat.com, ignat@cloudflare.com, 
	damien.lemoal@wdc.com, bob.liu@oracle.com, houtao1@huawei.com, 
	peterz@infradead.org, mingo@kernel.org, netdev@vger.kernel.org, 
	allen.lkml@gmail.com, kernel-team@meta.com, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 31 Jan 2024 at 13:32, Tejun Heo <tj@kernel.org> wrote:
>
> I don't know, so just did the dumb thing. If the caller always guarantees
> that the work items are never queued at the same time, reusing is fine.

So the reason I thought it would be a good cleanup to introduce that
"atomic" workqueue thing (now "bh") was that this case literally has a
switch between "use tasklets' or "use workqueues".

So it's not even about "reusing" the workqueue, it's literally a
matter of making it always just use workqueues, and the switch then
becomes just *which* workqueue to use - system or bh.

In fact, I suspect there is very little reason ever to *not* just use
the bh one, and even the switch could be removed.

Because I think the only reason the "workqueue of tasklet" choice
existed in the first place was that workqueues were the "proper" data
structure, and the tasklet case was added later as a latency hack, and
everybody knew that tasklets were deprecated.

             Linus
