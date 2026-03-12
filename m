Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4E33E8697
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 16:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334494; cv=none; b=Ir0sjOi/jrIqdML0kRs9Y+aPLYr+941H3J59rpJCafU1BAV/+p2r96AQ+5fDno4BhIWYXRcctbGm1rdKuDyhPnXjSXEEL0zKYdRnKJmWyWtOqnnjCdCFDzw8DrvlvUBOPU5YVRRaLyNVTa61JSzU2+wtPyljSJ4stxC9hSOuoSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334494; c=relaxed/simple;
	bh=ENv0+4bH9YdpFLGeURNwJ3+rEUsnNn74RNCtOl26SEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Re8DwSbBRFrERFcDTIeNUWiTDUKAMchgWnf64eJWGQaaUo8h58ENQpTeANaPZX56LQf9Ao3wy9A9GxILSnD7PRnUbdb2LNUCJoDCyzssZRpRleO+bXsf+k5McxraNhi4e9r/jDXPy6NqyiRMa32zMPOqFnr8U3A5nwGGptxTiyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XdvK8Dom; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XdvK8Dom"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5094e1d17d3so7532791cf.3
        for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 09:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773334491; x=1773939291; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VQXCfPVu6b6dIVECzm0C8AUD7IL7VvpSkD5+M4S95sw=;
        b=XdvK8DomXzUZgO6AoDwb+gZ7o/ziIbnIXHeoewfKtBKE5xyNG2Zck6CmNzNDWec1SB
         l6itnkZH4V9Sxuv0dVfHojcx0ZpqqhGCu/CZ5lz2UxM0wQMexAGfjHJyeFboOcff/WPI
         JWK+J3NRN2leYxfwrsAMxhrjjfN+/EJv+9htug6y4h/ByTJ80eVLtuuGfD4FwFG/E8H4
         +uJdLGbU04IwX90inux/pY/ZLtJN3b61jhvP7qTFaBcM7pf3RlEjLXo6caO0csHVqAxz
         hJgxIdv6OCGWX2aaKuKGlaQjUc3E4H2ah716Fy2ZS8tSsepbC+HgAc1oQbQJOLyGhGnN
         nYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773334491; x=1773939291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQXCfPVu6b6dIVECzm0C8AUD7IL7VvpSkD5+M4S95sw=;
        b=Qh1hYba+b7S3HiRJtcW/vbYd3mii+U/iYaeJTemXzNj4cvc1TnxU4vFHWy2mEYpkOT
         igxw/elskI9C6Jo5NMZmtQBb9E/OThqaRsfhCRvzsGGIrnnDMszKOrEuTLVmwMW3vhv0
         7PilkfRqok6jpNicWup9J9yld6mGXZTF7KtBkv6Twi+ZyG4i1iH8c9XWeqADqxDE4zqA
         zkwitPhXgKUqp4Vb0jFaboJhvtNP+u766xIdzO0xNr7BIl5KoRS5uIixuaiV+k1KQj1B
         9vwDHm4td8J/NUA/CFVZIaq8pIUSKy9cZ3SPViEiXCybAKf1CWjqqGMBNHCxpnyDW5wk
         57Mw==
X-Forwarded-Encrypted: i=1; AJvYcCVVba49EAv1tPut86LOR/+a3M9wj2+3bPO02ulgTkUhcklaKFTR4VU0NtBuWr3AMF/m1X3X7KS4/Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yypj/Omh0vIXiHxzgsw9KClkXp2zHbGOvPzlRr1bHjxcpDRTvtH
	JxADF0w/1AufqUqzQs0PXvJ1wZKS7mDjbKb7lcmJQlxAwzaGWFwF9TKfhnbG/M6tpPQ=
X-Gm-Gg: ATEYQzwsbQRvsk2Pz7z8QHhS/a2N6MEsE8QEnhrlmmK+Gd+TLWo+BQgp6gHdNQVc+L0
	XLe23D99yFNHtY2hR0rlzl0qspjHZKjnRcqgAQlj5Ai3rQUWW5y+K5nO7gVw3sKn1vFT82GGZ0i
	Sf1QP7IBxR6p7gqFmiphsY/Jo2aEaafKm8eBwJs9YZfRAHP/+vx407ddaAckiS+DbnN5HqruQfo
	ptE/KbC89CamTvgQ2pOfaovfis4ipe2JdZSS7SiU/tu9iyQVkBcOBYDXBPo3AxLJ+EzQEe5niVy
	kI6u8yX7hF5ZX/iGlC5AHLP/n6atZeQPedijtYt5dQZQ5wh7sIO5vmW/N+YMuqVRUUec+vEpNNK
	vLZQrhfC8Hg/AehaoI9N+QoQLuT8IgIC4BATs1MZufFObkjBDYtMKZTkMFuml5jrmRQOLOGVKNR
	Ep7JGTWoycaeQA3s+mg3BCk1Ik4WHq2sygtja3K18jBJ8KFw59sx2rWY+Ug6q8J8dv8EBeoYxx7
	2w2HoAi1DzBjx48xHs=
X-Received: by 2002:a05:622a:289:b0:509:44c3:5ffa with SMTP id d75a77b69052e-50957e10673mr1403911cf.52.1773334490530;
        Thu, 12 Mar 2026 09:54:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093a119602sm36658181cf.28.2026.03.12.09.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:54:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0jJA-00000006i8N-40X9;
	Thu, 12 Mar 2026 13:54:48 -0300
Date: Thu, 12 Mar 2026 13:54:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, Philipp Hahn <phahn-oss@avm.de>,
	amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
Message-ID: <20260312165448.GN1469476@ziepe.ca>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <abBlpGKO842B3yl9@google.com>
 <20260312125730.GI1469476@ziepe.ca>
 <f5688b895eaebabae6545a0d9baf8f1404e8454e.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5688b895eaebabae6545a0d9baf8f1404e8454e.camel@HansenPartnership.com>

On Thu, Mar 12, 2026 at 11:32:37AM -0400, James Bottomley wrote:
> On Thu, 2026-03-12 at 09:57 -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 11, 2026 at 02:40:36AM +0800, Kuan-Wei Chiu wrote:
> > 
> > > IMHO, the necessity of IS_ERR_OR_NULL() often highlights a
> > > confusing or flawed API design. It usually implies that the caller
> > > is unsure whether a failure results in an error pointer or a NULL
> > > pointer. 
> > 
> > +1
> > 
> > IS_ERR_OR_NULL() should always be looked on with suspicion. Very
> > little should be returning some tri-state 'ERR' 'NULL' 'SUCCESS'
> > pointer. What does the middle condition even mean? IS_ERR_OR_NULL()
> > implies ERR and NULL are semanticly the same, so fix the things to
> > always use ERR.
> 
> Not in any way supporting the original patch.  However, the pattern
> ERR, NULL, PTR is used extensively in the dentry code of filesystems. 
> See the try_lookup..() set of functions in fs/namei.c
> 
> The meaning is
> 
> PTR - I found it
> NULL - It definitely doesn't exist
> ERR - something went wrong during the lookup.
> 
> So I don't think you can blanket say this pattern is wrong.

Lots of places also would return ENOENT, I'd argue that is easier to
use..

But yes, I did use the word "suspicion" not blanket wrong :)

Jason
