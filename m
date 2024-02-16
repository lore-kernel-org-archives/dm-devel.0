Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B904512D770
	for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708100680; cv=none; b=TUEmu9+TCOaJ08OUdIyMbe0FOORck8B0dMqV46emobQIeyH8ahwGGMXDdPMeFDYVotc7l4RxJRBCwVka1WRV1rPRzmUq1WS9lKpgN2Y40aSF2Htn4IxZBrscINpGekW0DqjNM1t1H8By4uCnMjPWBQf1NxvvTDu9d5fPrEBf44w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708100680; c=relaxed/simple;
	bh=U6YG9Ti4C0gWK/nGR2s4gkUdINqjSSAttW9vvgbqrtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZ02gDJTWQbkjt+Yk6uPXDlUKodWIEAl3ke1dVeISq/zA2Oz3md9s3Y4DJCB2CkG9oO3oOklxeqY3h5mGLQH/6oTULTOWk01k1ZWmtYscJqunoix2xmd4Xx9rsUpkXadStHkzhxaRpKEL0ozdm9uOT7ka5guXf3s8vrfi5O6JtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cIGwTqCZ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cIGwTqCZ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e104196e6eso2335160b3a.0
        for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 08:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708100678; x=1708705478; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YQ+UNV/EAPr4AAhwPiPwcLP/Ta6X6kk2pf9+0780rLc=;
        b=cIGwTqCZo6JealeI5VsD+Rh3hKeD6/089LoaXWw+XUW6HG78ezQ5ONdRkvRYKkRQvj
         s/caKHlslV8tfSqy4VIYikgBqdkTQwmgAxDJmBjtt3/vNkg33mOb19mbEdXFsyaKsf4c
         RH9gDj2oQRKHSrv7VTORx6L92HvkNF+KhckF7eWyRJVsj9oJehPPgFDJQBo+xuoG762E
         kvhlfAp17kq9Gs090XKuqoGzwf0zYFCnE+0N06+UGmnjtIq6/kqlPxwTxB108RspJFFw
         rNtM8sL4T0+aAYeFLF21r/L2b7gtucE/UZkeuKYq7wisxJNRhp0x7jy+wfSbnQmDEP8B
         Gq3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708100678; x=1708705478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQ+UNV/EAPr4AAhwPiPwcLP/Ta6X6kk2pf9+0780rLc=;
        b=UK+On6SnE6q+JfTMFBjoTEQ/kG20dBM9Kmx4Q8LkCjpdA4P0YljXE3euo4hYExFhwz
         3qr2uqh2tHhwfLTwP58KLocgbNkNh6L/LX482kUeJJvcfqQbX9bMSpe764D3K73f0Dew
         QGoemmJchJunzv480VNLZI1CM/OnfpFTS6ceeMt7qS9QSQtd7pTyzJOszGTAMX4q3ajt
         uzUmgxnd3OM1LHonBIFQVDe3OBdRyZEm+MHqw4jLTWLCo4mmXnqtRP9B2Y84nWoJanVz
         IwW5IjLN9UVZ1h0yAH9K0t6tqJX7VFKihRYBhCMIREJuiWW+xhG7MTN/JucYMG2YwGST
         ccBg==
X-Forwarded-Encrypted: i=1; AJvYcCU2AxVGVkPzSODjRRJIb1bTS3sYJCVtyRJRgWClMA3I+03agKWDBJNBlVh/m4i8JJHnfPoGMGqt52E+X4jyE+ccd+FnrOCvGHQ=
X-Gm-Message-State: AOJu0Yx1lKmgxh74bBHnxGPqdsfU08rBgCUD88ln2/C9DSSzr8CI5zqQ
	/1d+p+7Y6qbQZiIAXnoQ3LOjX/80nKE84u6a8ELkYYIYewnjZg8a
X-Google-Smtp-Source: AGHT+IHb4zZg1UAszeDHy7JoD5f7d909sEn93hlBJmzyVRU53SDtzBN4FcJ5+lA4W5FXP6Z8EfsGSA==
X-Received: by 2002:a05:6a00:1995:b0:6e0:e618:7eb0 with SMTP id d21-20020a056a00199500b006e0e6187eb0mr6237661pfl.8.1708100677762;
        Fri, 16 Feb 2024 08:24:37 -0800 (PST)
Received: from localhost (dhcp-141-239-158-86.hawaiiantel.net. [141.239.158.86])
        by smtp.gmail.com with ESMTPSA id l15-20020a62be0f000000b006e133caaaa1sm151113pff.16.2024.02.16.08.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 08:24:37 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Fri, 16 Feb 2024 06:24:36 -1000
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, David Wei <davidhwei@meta.com>
Subject: Re: [PATCH 6/8] net: tcp: tsq: Convert from tasklet to BH workqueue
Message-ID: <Zc-MRN2tUmsCQLZO@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-7-tj@kernel.org>
 <Zc7zLsEhDzGkCH9m@slm.duckdns.org>
 <CANn89iKDsJPY=QQrTHK0Jw=s=A_G_GzcOA0WsqXaytWAVV3R4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKDsJPY=QQrTHK0Jw=s=A_G_GzcOA0WsqXaytWAVV3R4Q@mail.gmail.com>

Hello, Eric. How have you been?

On Fri, Feb 16, 2024 at 09:23:00AM +0100, Eric Dumazet wrote:
...
> TSQ matters for high BDP, and is very time sensitive.
> 
> Things like slow TX completions (firing from napi poll, BH context)
> can hurt TSQ.
> 
> If we add on top of these slow TX completions, an additional work
> queue overhead, I really am not sure...

Just to be sure, the workqueue here is executing in the same softirq context
as tasklets. This isn't the usual workqueue which has to go through the
scheduler. The only difference would be that workqueue does a bit more work
(e.g. to manage the currenty executing hashtable) than tasklet. It's
unlikely to show noticeable latency penalty in any practical case although
the extra overhead would likely be visible in targeted microbenches where
all that happens is scheduling and running noop work items.

> I would recommend tests with pfifo_fast qdisc (not FQ which has a
> special override for TSQ limits)

David, do you think this is something we can do?

> Eventually we could add in TCP a measure of the time lost because of
> TSQ, regardless of the kick implementation (tasklet or workqueue).
> Measuring the delay between when a tcp socket got tcp_wfree approval
> to deliver more packets, and time it finally delivered these packets
> could be implemented with a bpftrace program.

I don't have enough context here but it sounds like you are worried about
adding latency in that path. This conversion is unlikely to make a
noticeable difference there. The interface and sementics are workqueue but
the work items are being executed exactly the same way from the same
softirqs as tasklets. Would testing with pfifo_fast be sufficient to dispel
your concern?

Thanks.

-- 
tejun
