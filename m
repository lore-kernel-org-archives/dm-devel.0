Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64439A808
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 15:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771947886; cv=none; b=hgH4f9/n/EAYx4ZvLqaRBmoX13CYf5nWkyZj8706MwZ2q08cn+g/cSyuV+BSfkmdiGDYcpkDkdK05unhdDqeCGOH7KVh+C2ZhHKwFmmcrMheAggTeIp4yow1SnMOXvJigHbcKexNpy6330aTsKmddfmVMauMzvAnvjRpdaLStl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771947886; c=relaxed/simple;
	bh=39guGhRcE5h40NH7Tn/HbVVKO7kWWVdhmCMpGU0grIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csoBQwFVM+jWroRGqDBVbSfyRFlx63rCtBzFpT7KCU/G+Xyh61J2rZ4rk6sm0arQk51tkCJ0MIjUOWlc25GJnMk7ru4w1KAQkXVecR0cgoyjVML77qnqXITZJPSIXPl8b2WVPzasCfMvQ5IHvNghxEZ4IhiA/tp7I2xFGF36FHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R/v2gvvr; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R/v2gvvr"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-482f454be5bso61104495e9.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 07:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771947883; x=1772552683; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mjHfY2lLGnUeJNju8+7/gahIG0wuIDcc4ZAP6X6I1uA=;
        b=R/v2gvvrEuK8Nq+SK7nkTFng456TG2Bdl/BIkIFwkVOKYok3XMmwYRyfZ3tlqMH7D/
         bTbEMjCDLwt19wxMM+mTvNxx9TSJoKsfMnpvgSnk/euspEKp+OX33vtSuQUP4SXZRH0n
         cA5VqERsCt/3S6gJIwbFCLhaI56krDpjIgEAeNsR8rI0evhovzkf/grotfCtnq8OjBYG
         FQBg/KS5sW9d+G4bw8uV0KEWelrNqmPPKf/sLXuJKzN1gW8A7m/rt51IETq9qORXbVVl
         xRUm47yal+nppwdBAvOkszZB9QQjcGI2LOYMhCxKsEsrhSM/Wz3i/b+N7FE2DNb1Ci70
         YhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771947883; x=1772552683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mjHfY2lLGnUeJNju8+7/gahIG0wuIDcc4ZAP6X6I1uA=;
        b=WEojpsuFI0iw6YOTLb2aPhAr22T0cYUYXNGjoaz1mAEcLKGdCaEWwzoafF9aarjr5w
         HLucHyzaVJtAPBr3k5VyzqIoE02DjHzI0mZOguuzYtmaSsF3HAYzoVZyuCCX4M7HMv9G
         vXpuj8GLeDFN1hnvK0T+fuA8U+70dxNKuvtSEywoB4HzbS/N7jeTX42XINRjBTkh14F4
         jWXl9ggdBLUkXhSYYfggvy4jNofBEJiWfJovq0fOuT1rMIvafXizhUgbm6MWIv0ovms3
         NHLRrfB2TWS8v8iJplV3RyPTabfUBDg4q7OMts9eljRA+sWDv0/YpvZYKZw0cXTh2eTC
         9YPg==
X-Forwarded-Encrypted: i=1; AJvYcCU0Lwq3xQ+gyyh4/L/wtLUoGMR9O0AT7pdpTz29wqQePFRgbnGVx4TawsUucp5qPm5DKdFkSZkc1A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxmXG4n79zuFuMv3RwrxjQpQ2m87drB5bojiWkvwsrBNyy5h4Hd
	BC5NaF+GJWqPUfJBiZgCRKp5jifl1V0I5i2GD0a+kVk5l7gD+2JlxhSBrO7kc7+bK60=
X-Gm-Gg: AZuq6aKhVMgrXbMXeQw7i/HaCn1t6rN/tswrfa/LpnGeKsJRMPD7jBwZHHMrYsgOAo9
	oPe4SlxOrjR3OeTogxHKvGndyC9rebIJ4NamIpo1XUAENgF3g+AhYZq9O3BzTg0SAzRxdKHOkOA
	3s0CmvxiynCeZDksRTDCOT8/eVU0D7DUoGWpHZUz7IBaa5ALAifSXu3mzIPfZ0SP6wwWc3rStl6
	1CDNid//kMoe9I26heIYCIJaSvGPlIQQPEGrIHRERzYRUS0fMhkPzY4b4vyapcEsezyZTR8XBpq
	FGdCzBf80MQ2JQmsDK1BjImvMUff68csynZ8R45uSajNNpkHJMH+i7MkBty+1RH1c8NJQn4LfoG
	uKzeCkqBzOSIWFIIUmR6uYLo0ppwgZyac6WrUmUZXs+AJt3xlGjErwK9AMvjMunbgb+CwXOBJHg
	OltcxkweMVGX1wEL/VCObj3f5m57oUlO0=
X-Received: by 2002:a05:600c:4812:b0:47e:e0b3:2437 with SMTP id 5b1f17b1804b1-483bd726b00mr4761635e9.5.1771947883174;
        Tue, 24 Feb 2026 07:44:43 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b87db57fsm38737105e9.3.2026.02.24.07.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:44:42 -0800 (PST)
Date: Tue, 24 Feb 2026 16:44:41 +0100
From: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ3HaVuIA4Ezu1uY@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3F2cghZpqBi1Mk@pc636>

On Tue 24-02-26 16:38:01, Uladzislau Rezki wrote:
> On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> > On Tue 24-02-26 12:39:33, Uladzislau Rezki wrote:
> > > On Mon, Feb 23, 2026 at 11:08:02PM +0100, Michal Hocko wrote:
> > > > On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> > > > > 
> > > > > 
> > > > > On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> > > > > 
> > > > > > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > > > > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > > > > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > > > > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > > > > > flags.
> > > > > > > 
> > > > > > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > > > > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > > > > > 
> > > > > > My only skepticism about this comes from the line in the
> > > > > > vmalloc_node_range() doc: 
> > > > > > "and %__GFP_RETRY_MAYFAIL are not supported."
> > > > > > 
> > > > > > I myself don't know why that may be. Could you elaborate on if/why the
> > > > > > doc is wrong please?
> > > > > 
> > > > > This statement was added by Michal Hocko in the commit 
> > > > > b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> > > > > you think that __GFP_RETRY_MAYFAIL is not supported?
> > > > 
> > > > The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
> > > > supported. While pages that back the allocation can be easily made aware
> > > > of this failure mode there are page table allocations which are
> > > > hardocded GFP_KERNEL and there is no sensible way to extend the API to
> > > > change that (as we have learned several time over years).
> > > > 
> > > > > The VDO module needs to allocate large amounts of memory and it doesn't 
> > > > > want to trigger the OOM killer (which would kill some innocent task and 
> > > > > wouldn't solve the out of memory condition at all), so I think that 
> > > > > __GFP_RETRY_MAYFAIL is appropriate.
> > > > 
> > > > Understood. But as said the very page table allocation could be the
> > > > trigger for the unwanted OOM. The same applies to __GFP_NORETRY
> > > > unfortunately as well. vmalloc has just recently gained support of
> > > > GFP_NOWAIT allocation mode, though. This will make the allocation
> > > > failure much more likely though so I am not entirely sure this is a
> > > > proper solution for your problem.
> > > >
> > > Yes, the page-table manipulation entries are hard-coded and it looks
> > > like it is the last path which is not wired properly with gfp-flags.
> > > 
> > > Since we grow PTEs and never release it might not be a big issue for
> > > the __GFP_RETRY_MAYFAIL usage. But it is still not valid in noted path.
> > 
> > One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> > __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> > allocations as those could be achieved by scoped allocation context.
> > This could cause pre-mature failure after the whole bunch of memory has
> > already been allocated for the backing pages but considering that page
> > table allocations should be more and more rare over system runtime it
> > might be just a reasonable workaround. WDYT?
> >
> As far as i understand, Mikulas uses __GFP_RETRY_MAYFAIL with vmalloc
> for some time already. I have not seen any reports about that a PTE/xxx
> alloc path triggers OOM killer thus i tend to say that it is not easy
> to trigger.

Yes, triggering OOM killer is usually not all that easy. But rare OOMs
are likely even worse because they are harder to test for. So I can see
reasosning to avoid it as much as possible and rather fail early.

> I do not have a strong opinion about workaround you noted. Maybe Mikulas
> can switch to NOWAIT flag instead.

using NOWAIT for the full vmalloc allocation would be just too easy to
fail under moderate memory pressure.

The real question is whether we want to provide some sort of backoff
early but not way too easily allocation semantic for vmalloc. If yes we
need to get creative in the vmalloc internals rather than expect callers
to be working around that on their side. History has proven that this
just leads to tech. dept and more work later on.
-- 
Michal Hocko
SUSE Labs
