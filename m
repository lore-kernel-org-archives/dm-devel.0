Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABE812E68
	for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 05:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708061490; cv=none; b=n1arUynGO0FmbF/F8+ayhfoFKyIIkltYRKGD212VaD0zCZX+3iPSAMMRMPims002Dc0201gozwLfCKfKSOA2YGB29w7cNjSRkB+zImyMjYU28CfrnG1ToRKimdgO0bb4hygSPoofyhaNn+2Be1ZNRaEuWQ91arfpQXkCkLZ+w+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708061490; c=relaxed/simple;
	bh=IO6wXrWgnOjdRNHYOyVqjCgY14opWEM+FIcIepTxP2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JlCl4B4P+ip47/mzFdPIgnkxjsoG3Scqc+TuIGgbPFYgUJ910FCrnNDjmMG+lG44glB33yHaLpfYwCtkW2aY7iz9nykT0wiH9NgKnqnn6dCwiC2FKKa61s8vr6dUprB2ecsueixEPiKgC33DJL+hdxUj1Ow3qsFrMffzdeMstCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O0B4Wp6u; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O0B4Wp6u"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-290d59df3f0so1328708a91.2
        for <dm-devel@lists.linux.dev>; Thu, 15 Feb 2024 21:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708061489; x=1708666289; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tjqvFkfM5Lfa1Uthf+wvZFrrDCYAGzM+X3+/QDBtjEM=;
        b=O0B4Wp6u8ofjpCMvYxfbfJ0nxSXAInOGseeT0KtEOcKR1hS8B8pPIPiuGDmvx4jUK0
         ewt0Fn8qzJSnbenFZe5TX5dAPLpLbuSxU2sBNdiU3PbV0//be6pPAgP7iFuh3BkMdj3Q
         wQ4lItl3GSpz1sZuonYWj+h/6l9IZYlpvfUrQ+kuagTrZOO6kOQ0huR0A7BGGf3XpkxD
         oJn3jIc/e7lpullaCKIvkOb1tw/01TWNqQ7IuwyE+ufWZiU8y+H3DnWoOzt83EmuDr1E
         Yp2fJOSbRNIpxyXvv6bYnfMhhXBywTvcx6ef3ll4f9u79/lrP+eCGe2f5N7qUOYJNqPl
         S3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708061489; x=1708666289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tjqvFkfM5Lfa1Uthf+wvZFrrDCYAGzM+X3+/QDBtjEM=;
        b=euxvf1f/3PQ8CRQNup0DUeusAWTnbpwVvFh0kQm58Risr+p644oxxl+obECAqXnHF8
         Nua62tpZXvgvQhVrgDMkHx0pA5PZTgqeD2eg4SfBRyN/q7fx7+K34D2mxEvt1X1vQgng
         zvg8wRnehOF6eGV4y/sF5IQJB7NOZ4OQ6+tN/WtvANTCEHUVU8zLO9z0eeba86GYe4a1
         xFvheBF/F26TJQaC3O7emKJMgjXV93hedmd70eaSmeA6JnJu89egWVGjtQZY4THx8D/o
         A1hSS5GwCCmxGwFPWxCM+Lv1FeJ0a+d2b8yl14FROaVm61mAeLKGc48BGgF9ZZM86GGR
         MC/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVe+BGbWTJet3E7zQ//bEPjoJQM9rSIMyyi8t+xObWIrrlfGqFVKiy4BqhohUNHH1BRPbL0wkcxsb7w/TubdJzQTmHG6m5oeM=
X-Gm-Message-State: AOJu0YzLkPyd8DtLzSK3UnBVaPKPeIiKBlpnY083nGPGl8N7qek4bJbI
	C6rdaVThnvM9sEU2Dwsuk9eccbftoyXIVzSmMTfv2eCIPTQ0VreG
X-Google-Smtp-Source: AGHT+IF3YmN1qawIPxNBZ267l/ivRrJxf0WqB2STpKTxG3GPCe2BMlVFVyRTIk7pohrmWgR5uF5SPQ==
X-Received: by 2002:a17:90b:fca:b0:299:3007:ad13 with SMTP id gd10-20020a17090b0fca00b002993007ad13mr1404504pjb.32.1708061488696;
        Thu, 15 Feb 2024 21:31:28 -0800 (PST)
Received: from localhost (dhcp-141-239-158-86.hawaiiantel.net. [141.239.158.86])
        by smtp.gmail.com with ESMTPSA id t22-20020a17090a1c9600b00298e639d17esm2647645pjt.22.2024.02.15.21.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 21:31:28 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 15 Feb 2024 19:31:26 -1000
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, David Wei <davidhwei@meta.com>
Subject: Re: [PATCH 6/8] net: tcp: tsq: Convert from tasklet to BH workqueue
Message-ID: <Zc7zLsEhDzGkCH9m@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-7-tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130091300.2968534-7-tj@kernel.org>

Hello,

On Mon, Jan 29, 2024 at 11:11:53PM -1000, Tejun Heo wrote:
> The only generic interface to execute asynchronously in the BH context is
> tasklet; however, it's marked deprecated and has some design flaws. To
> replace tasklets, BH workqueue support was recently added. A BH workqueue
> behaves similarly to regular workqueues except that the queued work items
> are executed in the BH context.
> 
> This patch converts TCP Small Queues implementation from tasklet to BH
> workqueue.
> 
> Semantically, this is an equivalent conversion and there shouldn't be any
> user-visible behavior changes. While workqueue's queueing and execution
> paths are a bit heavier than tasklet's, unless the work item is being queued
> every packet, the difference hopefully shouldn't matter.
> 
> My experience with the networking stack is very limited and this patch
> definitely needs attention from someone who actually understands networking.

On Jakub's recommendation, I asked David Wei to perform production memcache
benchmark on the backported conversion patch. There was no discernible
difference before and after. Given that this is likely as hot as it gets for
the path on a real workloal, the conversions shouldn't hopefully be
noticeable in terms of performance impact.

Jakub, I'd really appreciate if you could ack. David, would it be okay if I
add your Tested-by?

Thanks.

-- 
tejun
