Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C540165F16
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771877274; cv=none; b=KjD80+yhO+2SSgPxD9Rdj+mX2HDzruK2qt8HB5OkJN6aWAMlfwvkvm+MkatPVn70OIQwColOFWpPdnZOSMtzQwFcD39Rt6zcgNxD8IvSTjquM3g+cPeRirtIxY9lXp61N8UhCIOpMB/1OWK8x0g9trWGUsWOpv10+k6F/evjSfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771877274; c=relaxed/simple;
	bh=l2u8Az6/2GbRgHSJT/sxnRCoVJAlSNcC4tmV6PcbYT4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwZ11/9AQzcXV7JN6AQnMyv4tQrTR4Go/YndL0U8pQrF83D70qDLX7AyS2x+ZEZnVx8w4fBwVbDmsCa2GVhhJf9mOMz7hGA+HmFGlXmG5NkgUHpmtZOwsvrICtTIV7t425fNnwZ1nCMFjaEdl0WzpEhxm34Prz1f3zdHjVnjMr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DW5kld1h; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DW5kld1h"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-38708180241so37414381fa.1
        for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 12:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771877271; x=1772482071; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5i5wZQPBMzNDRUemsp8FkV4MRz9ExTj3IRN14tL/eKg=;
        b=DW5kld1hTOlsxkqyILiU5o9Eq/5Saz8kMRjnQt/rFShcxWaXZzCj0ciB6jzwbx2jo0
         6ZpWhIAKRY37BoJerlHfjikyLr92H8YpuG2vcYNCUtC9hxQO0RkrTCvduVzhVp+uHTW5
         xn+d0FSllGmtcRV3USOT/8GIIH5hiza9AHd8yA0IUk/LkmauUu4WWSuFFaiL4H7g2dKk
         Jl0sry9bzwhxyj6sUi14z/jEPuuim30l4dsDkWisnlUYB3ZmjQJuIJgrrUEy4cPtJvt6
         ZHE0VN6hD8NLWNtIZFMrx3zBleVSuIq+xSBIlA3Dnswcgnna+edxHS3aWmP54m5bWIyZ
         FwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771877271; x=1772482071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5i5wZQPBMzNDRUemsp8FkV4MRz9ExTj3IRN14tL/eKg=;
        b=b6igHKXW57JoSGM+EcuQTvBRgI74GnohQz/iBXg92Tbz3iUvAvPGl5roUjsjcSuc2h
         qnvwSiuwDtYNltpNbqxfL/sfznjjbQApPIyGR95w2TWDs2z15I0R/T6W1+uTLSlkE3bW
         Tm2wySPMD+OQ0NYwrvYXxKGiMnIkEqyznwezyaRZsc0kbbnaJmuY2ukjlTAqGAi9hqBy
         vHkHNqktF4KagOOaQ+vqQWczLxQui7QNR1A2XeJKLK7FC4wxctNL2z1bk2+BvbkbrSFh
         vOd3HzZmeaM4fJCCyHs3JfUZPa/7pgPwb9UCo+givNibiGvZA7F7XNSnPZx9nfOMrBlr
         /5UA==
X-Forwarded-Encrypted: i=1; AJvYcCV0xhsfh9dzdB1/C0mnmZgmrEv0vgbhAzKEDF07ScLmBdVo3IyxcVQo8rA56sDtGTpNhfyxwjAWLA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyECRTbFt0eD/Cu15r1h4N8W/rxiJEsedoR7HHUUpul+yJdacl2
	s3uqNV748wBncxuN4j2IUqmZfR2PbMwmVfEiD+BP95ed2UD6jlnXIS55
X-Gm-Gg: ATEYQzzIFfvk9FtkrkxcxKyrZqHixllt7dOGGI1aZ3s7phY7/BeWVjDXjuEKcSjuiGB
	9b36tY8ip+BRBhLhpbWYu5iRgY61GqGDMciTA1aNnAuGkaAUAJmJtqvpQFHAcCFkjBaeqJCtSX3
	OVudMDMHFG1wdiZhHSBVf/h5rb+aoBmR0LMfgd+jKCFq2Q+vJI5KhvtUhZS35HJYPYPgYxT92gc
	GPo02mrOkFaYzoPRBzIXLCr2Pv/9Bt+N+0Lxri9xIsX/c7DpJaPkCwSMyMUWDocZix1KHL/13lm
	ile2T3AworxfWeqUPJHcnyF1Y+0i7A4MOTgd5Wwx+xIWa8p9JR+/29SpN/LmMt12uOmkM7FPGx6
	/+lvh4orCYmgB60vwacKsIIGPsBm7Wb5+V8gPpyUSmNQXW+mA5FOzDUfBwTWPTDc=
X-Received: by 2002:a05:651c:220a:b0:386:fd3e:bfe8 with SMTP id 38308e7fff4ca-389a5c9298emr25983911fa.7.1771877270631;
        Mon, 23 Feb 2026 12:07:50 -0800 (PST)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-389a7a201fbsm17562561fa.22.2026.02.23.12.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 12:07:50 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 23 Feb 2026 21:07:48 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZyzlNb8ayd9bgsA@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>

On Mon, Feb 23, 2026 at 08:25:38PM +0100, Mikulas Patocka wrote:
> 
> 
> On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> 
> > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > flags.
> > > 
> > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > 
> > My only skepticism about this comes from the line in the
> > vmalloc_node_range() doc: 
> > "and %__GFP_RETRY_MAYFAIL are not supported."
> > 
> > I myself don't know why that may be. Could you elaborate on if/why the
> > doc is wrong please?
> 
> This statement was added by Michal Hocko in the commit 
> b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> you think that __GFP_RETRY_MAYFAIL is not supported?
> 
> The VDO module needs to allocate large amounts of memory and it doesn't 
> want to trigger the OOM killer (which would kill some innocent task and 
> wouldn't solve the out of memory condition at all), so I think that 
> __GFP_RETRY_MAYFAIL is appropriate.
> 
I do not see any problems using this with vmalloc from the first glance.
KASAN path was hard-coded when it comes to GFP but it is not anymore.
 
--
Uladzislau Rezki
