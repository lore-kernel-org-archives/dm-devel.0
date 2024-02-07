Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619E484FC1
	for <dm-devel@lists.linux.dev>; Wed,  7 Feb 2024 19:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707332572; cv=none; b=QUVeNAWOb1FxDQLQCRS7BgwQwTGeG7mwtzNOd/otsqmviVUVnBHqAEvznGBWVpuCSfyfenydP9QlZrlTCqeaUefe1k2ZNzGQQKvVjKpNyDiTom9zzfwBJCVsWTcyTxHobrqwwpj5ngr9Yj5E4snZBnBWbU0H2eGT787M6AFcpIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707332572; c=relaxed/simple;
	bh=0WP3GhnoPTDV0+joY1N49lbD3qna4WrhBLUKcV4NQ7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFo9IYavE+xDSFpwERMWw35hoAeCCsneLe9qWsAlEZ33tkGb81YKp3yrSEOtgyDceD96EwqFYMMAl+JaFKg/hbnhEB9CSDKebPWf2E31/9E2sCpliM3SQnBljCQwyR+D6kKA82CX50m4XMrvbLAredtSJHDnUileC6B88T3xh0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtYuFI3n; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtYuFI3n"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4c009d2053fso412930e0c.3
        for <dm-devel@lists.linux.dev>; Wed, 07 Feb 2024 11:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707332570; x=1707937370; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ujAb35RnTLt8ZUbzta1x6PdsdJ+WhetZSVI49IXzaL4=;
        b=GtYuFI3nUm9dG8f+ypSpQj7q2nZ1+pUUkHOrhSOwQ6vS2r1gl8DuBfLs+Lu9n814lL
         XbcwEMBD+JGPjP72R4h4TvqsMGCU9+NR4dpF9t/6IW0yU+f/M+FD00SbAxbuw82bAh+c
         Xer6vLn67+ZlTyU6nkxUC5McAJqvWZi+E8TT1NecOTD7xTa9h+4x3QizQiOiv5tJ7YOK
         nziAyMxQ1Llk/2fBzwCK18tDLaruHr8Fywx4kT42nVVxs+uIyOY8okSF0WbSC1tvbXFs
         HMAfGYqWG/u3Hsw9N2g1nweC8e7tbLks3Wzq1PSNTI7OYVHfuqeLTx29s4Nu9pftis10
         sqrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707332570; x=1707937370;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujAb35RnTLt8ZUbzta1x6PdsdJ+WhetZSVI49IXzaL4=;
        b=oUyFyBw/2zrvRRScJvjC/1vHPr8//VQSdkVTdOQsboIqsavKcMnxj44MIuBqSNzZr6
         wxvxYxxCrvsBLx8dPYu9VL5SOdel6eZT48IavlWr0B54J9VNNV2KPTR7wcX5eLo1b6wN
         iBvFptW4cXrdsJk+keP0eNOHC/MXryC94B31WVIV7lh0V+NTHoqCj0XmbY3HU2TmNClC
         uUAwXBx2rfN5isGKHKZK/m6/SIGOyuT8lCZjVRErXWtFTefxhpVG3RWYwm22oMcRApHQ
         +fhhby57jZ02BFtbQTnLU1YnxNdHxckk7PnIBBbtyTU5+A7w64Efiv9a1LrCg0YDTTO8
         cV5w==
X-Forwarded-Encrypted: i=1; AJvYcCU+iFweW+mDH5sNF9yTub0QTskc8GiOkdG4u4Xi7iv3ObidTeshYZUfF6UT9j3mVzDmvAnSTxvlx4SzHguiVbJ4aoW2bj1I2C8=
X-Gm-Message-State: AOJu0YwY2xG8I2+COgOir4tFmvXvbJhlKpNi34XXa9v5EJjk3g8fo+/5
	V4RScxfesrbDAzTpAutYEL+sF5/DXe6nJ748oNo1kI2rcanqhD0ZxksOrnisaLuxqWlwNX/KXEf
	+Izj6xxgLzL+LK83tIhnL8/KNF+M=
X-Google-Smtp-Source: AGHT+IEGjaS2wfaJL/3N0IjNMSRVZR1yOOmxYjAVKnt3O04KW4cnozm5HRpUgMBIQTf4a+F1nGQe1OZy405NekISujs=
X-Received: by 2002:a05:6122:1699:b0:4c0:2553:3b19 with SMTP id
 25-20020a056122169900b004c025533b19mr3739687vkl.13.1707332569959; Wed, 07 Feb
 2024 11:02:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <ZcACvVz83QFuSLR6@slm.duckdns.org>
 <CAOMdWSLNMqsZNJ-oCLN2RjckZmJSvdU_Yq0F0frmqMqa67Oy1g@mail.gmail.com>
 <ZcFPKaWwxJhgy8HQ@slm.duckdns.org> <CAOMdWSKQC4UWXp57qubcSOHmPj0E7wHZWWbCz+yCZqROhoPSGw@mail.gmail.com>
In-Reply-To: <CAOMdWSKQC4UWXp57qubcSOHmPj0E7wHZWWbCz+yCZqROhoPSGw@mail.gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 7 Feb 2024 11:02:37 -0800
Message-ID: <CAOMdWSLF9AaQF0ux03-tonw-Jy+4rXdKEZGzPrp_v+fnas6SnQ@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

Tejun,

> > On Mon, Feb 05, 2024 at 12:50:28PM -0800, Allen wrote:
> > > Thank you. I am basing my work on the branch you have
> > > pushed.(or-6.9-bh-conversions)
> > > https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/log/?h=for-6.9-bh-conversions
> > >
> > > In the order of priority, I have started converting drivers/media/*,
> > > drivers/dma/* followed by drivers/net/*
> > > which constitutes the majority. Putting my plan out here so that the
> > > work is not duplicated.
> > > I will write back in a day and share the branch for review.
> >
> > That's great. Thanks.
> >

  I have the first set of conversions ready. Kindly review the patchset
before I post it to the list. These convert drivers/dma/* to use the new
Atomic WQ mechanism.

Based on
https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-6.9-bh-conversions


https://github.com/allenpais/for-6.9-bh-conversions

 I am holding on to the patch that converts drivers/media/*, as I haven't found
a right way to replace tasklet_[disable/enable] api's. The rest should be ready
in a day or two.

Thanks,
  - Allen
