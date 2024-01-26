Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CAC1C0F
	for <dm-devel@lists.linux.dev>; Fri, 26 Jan 2024 00:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706229242; cv=none; b=XLbZL+FW6ZVDo683Ny6QYniSQqy7cQLm6havhQGVXNONCrNoW+bG036Bv/elvBvSOE8zaZVKR54RvN+94YSDNZPg9OPeF26dLRahuKJdPj04hdknGsDxFg4YnVVyTqap/cffey+h9IjkRrUjH+WZ3t3fqndNfkJlkvTraeJpJqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706229242; c=relaxed/simple;
	bh=FAQRl1q6MnMVV8np0W8lncH+zy9FvDuPzVQNBdoDOQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCa0FxnaCABkx3uUNbgIysHG75Wk7uC49ifbo51gckpn5sDIT6Nh79tjZCfcBWBv7mof/Vw3bH0AArysnEueMlvlqTVgt98f0H/8fSBidZ7ppn9I1w0oaNTTE9vdPQGf6blR/MiRYsA/UHS3fE/8a+efdjZFQEJ1w6Y31fAM7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7YKdP8r; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7YKdP8r"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d70a98c189so47468415ad.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 16:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706229240; x=1706834040; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4PulaV0cbKx4FOxtybdvesZKMhhcYdEXyXz4FJ1O5Yc=;
        b=D7YKdP8rl+nt4gFTR3CzXTWh6OdaCylypdvSgCgEDxAMET2GLFkRAbAnddljiBXaR5
         eECWyN/+WJjM+giPhKDNM9y58FcOb9cuxBT3mMCx+ciRejdiqHM3EMRvFjxZo5Lr/Lky
         sofZKZWlCkbha8ZRnN73dELOXevCyxSzC18leG8uK/tHpX4FwV8f80Rmi1xHQ8OacPkm
         UoI+cms+ds8VzzOYLzHDAL6+n4RwGVgGv7X+rcKYUz6kXIDkge6Aamt02cU4xf8R+U44
         +SQawXjA7xd45boo9Ffd68/2sJMnsn19vy11l60/itZ30Ej6NHhCqkd8dAcQNt+W2/TX
         /I3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706229240; x=1706834040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4PulaV0cbKx4FOxtybdvesZKMhhcYdEXyXz4FJ1O5Yc=;
        b=cZbZOx/D2aexVfAi2SZBrDJwC/4Pv7fXMZowVXtABYCAA0K8VN/3NPc2wxyS+0OszI
         W8zqMrtTOabMRJZLcP4kGih3eTugLXEL4kTXBnzhaOzRmcW+ujuOGG4Q5h+iPpBWG7iM
         pvGaQK0H/2WEuJ8ZTwEK1WcSR/CuEeUu21EuLKtiszxLyj98gZarAyKtEBUvpCA74At0
         pj8TMoWcOL1u/k0SGK14es0aFJmvZh9Z36ZpLl1hdt7Fb31eLtwSS6vLa5/jI3MEPf8b
         uQfw3RYeUfN4p9VC6rg30sxk4nP4WLjpXNiNCUmfy1aIyCPyDOKrNRDfZnknxVchlsBI
         F/7A==
X-Gm-Message-State: AOJu0YyNRSky9Utt3k9c1WO2lA5HMvVDXCDryhC27RkBVZxvBaDxIfBV
	vAg6q0nq3DcOO2IJeIQ3dFPxp6wwrQ2Fbi+4m+HpP4rlBRrfCsFl
X-Google-Smtp-Source: AGHT+IGsZ90XesWFH+F/pb8nvUEBzeH8/0SplhG0HyJjVfwXbaLRgNNljfHmxWpq7afN0SRUOMs9mw==
X-Received: by 2002:a17:902:efca:b0:1d4:cb8c:fafe with SMTP id ja10-20020a170902efca00b001d4cb8cfafemr384611plb.74.1706229239570;
        Thu, 25 Jan 2024 16:33:59 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id h1-20020a170902eec100b001d785fc6ec7sm79412plb.177.2024.01.25.16.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 16:33:59 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 25 Jan 2024 14:33:57 -1000
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
Message-ID: <ZbL99b6ywZUqG3YK@slm.duckdns.org>
References: <82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com>
 <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>

Hello, Linus.

On Thu, Jan 25, 2024 at 11:51:28AM -0800, Linus Torvalds wrote:
...
> So we could have a per-cpu 'atomic_wq' that things can be scheduled
> on, and that runs from softirqs just like tasklets, and shares the
> workqueue queueing infrastructure but doesn't use the workqueue
> threads.
> 
> Yes, the traditional use of workqueues is to be able to sleep and do
> things in process context, so that sounds a bit odd, but let's face
> it, we
> 
>  (a) already have multiple classes of workqueues
> 
>  (b) avoiding deep - and possibly recursive - stack depths is another
> reason people use workqueues
> 
>  (c) avoiding interrupt context is a real concern, even if you don't
> want to sleep
> 
> and I really *really* would like to get rid of tasklets entirely.
> 
> They started as this very specific hardcoded softirq thing used by
> some drivers, and then the notion was generalized.
> 
> And I think it was generalized badly, as shown by this example.
> 
> I have added Tejun to the cc, so that he can throw his hands up in
> horror and say "Linus, you're crazy, your drug-fueled idea would be
> horrid because of Xyz".
> 
> But *maybe* Tejun has been taking the same drugs I have, and goes
> "yeah, that would fit well".
> 
> Tejun? Please tell me I'm not on some bad crack..

That doesn't sound too crazy to me. I need to think more about how flush /
cancel paths would look but hopefully it won't be too bad. I'll hack up
something and see how things look.

Thanks.

-- 
tejun
