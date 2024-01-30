Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167921292DB
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706635538; cv=none; b=Og6qzO82InfJ4e9YlLgJgrOe2oozEk2dy87y/uKSUofXENjck5Cbn6i6eQ3T9ep6lPSyTB2dF1xyC4RW3SdAShr407lXz0XzW7Sk1V4Hd4vcJXd0XTzwk6ZEyQaXgcEyJ9wJOWJydazKNdUxvFuh1s9K3+kWDW3sKUGFKtK0BCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706635538; c=relaxed/simple;
	bh=FcwkWgQyZxHw0vq0MR9FTO1uQCeqns6oU7XSsrjb7aE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AfkKOaZ3/UW0zIqmOhlFcBYspngAPyHZiTx0+z6B0dVNwNCuTD1jNUcsNZ9m3mPaQibR2nc350ia1xgA11ABEbJyUKyOSdyFOUwnVegMJUTfkpiE8iMHdlbf7NSqjrMetB1dKt9db0coGkF61wusUlgLne0DwsY8H61YJoE2RWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=none smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CDDWoxPK; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CDDWoxPK"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2cf3a095ba6so50384921fa.2
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706635535; x=1707240335; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3M0wWn2WcqB5JyFL/iZZPD7cHnf4NTD7VpnGyg3ebus=;
        b=CDDWoxPKpKvnFYdEEXndYrAhVF7C4/2zeR/x3Qh6WyrcA/ogMocAo/ZO/3nDCv4DJa
         tJVw+NAtOJoUjpB57Vaq0dkiP7ffavFBEaj6dfdCktz6e8Uk/prU2rMXYpisrmPS+tWh
         9q9dVB1KXGxqweDoudToWfmoxehjJd/ccZUQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706635535; x=1707240335;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3M0wWn2WcqB5JyFL/iZZPD7cHnf4NTD7VpnGyg3ebus=;
        b=YjnSsap6l/ZQy2IUKvO+mqN7ZP7pgAw0ypaWe3P0yrNkr8HBBuvTc8ZgD+/aeQYn4H
         4lobFLlX7jhsVpmD/y1FTxI0+HsDlgFZBpMV0zQ1psArDyjxkWmZwt/G1PxWetWOSPzF
         45aa4tDhlhvUGJZ16Sn/LyGqGguJsJwfaM6OdMHA5GLcL3jxSN7xI6ICGBFlNPpgpPQE
         ouuy2l6W/+91Ez5r0w6PVIUTFAtJth55LbNceDqTy74DhUmVi4B4z8y76Qysr+UJd6Zy
         y2rvjhNFwPfkA9iYY6FmrQ6UXlvYymg1+yhY1qpm+57AjXzIKzRJqtwM2Umsb1bweu5C
         qaYg==
X-Gm-Message-State: AOJu0Yy1mzWpJ+K7dAQeEcoWhob/2ENlKzNPh8u9ufcaQR7jj6dJ3JSY
	R7oMCSI+xlKTJFButCd2yYpDET6fHnCvRbBnOmtsuFm8KK8CUAGCCoAEVu4q3x0SXlvbISISyyG
	Ioob0Bg==
X-Google-Smtp-Source: AGHT+IEOuyg5Sa9lW1WuRIqZd3uKmLNJXQsM08hsQtoW+49TvC33Y3o7IIVMQbEpjsI+1yjUNi5oWw==
X-Received: by 2002:a05:651c:612:b0:2d0:5ffd:1d58 with SMTP id k18-20020a05651c061200b002d05ffd1d58mr865305lje.36.1706635534831;
        Tue, 30 Jan 2024 09:25:34 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id w23-20020a2e3017000000b002ce06c6ee29sm1160081ljw.77.2024.01.30.09.25.34
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jan 2024 09:25:34 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5102e2ab56eso3815974e87.2
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:25:34 -0800 (PST)
X-Received: by 2002:a2e:8417:0:b0:2cf:36b:9abb with SMTP id
 z23-20020a2e8417000000b002cf036b9abbmr5802206ljg.44.1706635533757; Tue, 30
 Jan 2024 09:25:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <20240130091300.2968534-4-tj@kernel.org>
In-Reply-To: <20240130091300.2968534-4-tj@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 30 Jan 2024 09:25:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=whyr9jtwpiF8=es3j+D3tFF_338nJqdUq3f3oc=oJAPMA@mail.gmail.com>
Message-ID: <CAHk-=whyr9jtwpiF8=es3j+D3tFF_338nJqdUq3f3oc=oJAPMA@mail.gmail.com>
Subject: Re: [PATCH 3/8] workqueue: Implement BH workqueues to eventually
 replace tasklets
To: Tejun Heo <tj@kernel.org>
Cc: mpatocka@redhat.com, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, msnitzer@redhat.com, ignat@cloudflare.com, 
	damien.lemoal@wdc.com, bob.liu@oracle.com, houtao1@huawei.com, 
	peterz@infradead.org, mingo@kernel.org, netdev@vger.kernel.org, 
	allen.lkml@gmail.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Jan 2024 at 01:13, Tejun Heo <tj@kernel.org> wrote:
>
> This patch implements BH workqueues which share the same semantics and
> features of regular workqueues but execute their work items in the softirq
> context.

Thanks for doing this. Honestly, while I felt this was a natural thing
to do and would clean things up, every time I look at the workqueue
code I just shudder and go "I'm sure Tejun can work this out".

Patches look fine to me - I'd love to actually have the dm-crypt
people (and networking people, for that matter) verify that there are
no performance gotchas from the slightly heavier (but more generic)
workqueue interfaces.

                   Linus
