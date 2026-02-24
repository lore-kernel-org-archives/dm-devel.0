Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391A7396B91
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 12:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771935761; cv=none; b=Rw+o/TUSCMsdmf++4U72kJPHzf47QBp+luFldiFQcDaELxWScsklFW3xAFH2F7sBmoXRmXIR4zGr9hVGq2OwkOdmR6faVZ4qnQwuF6EG9wgOcAXZgMBfW5PPt3Ybq2PYN6h/FOSdzRGe9Ter8Zt9wXqp7SVe6WUBm/XOgayPdU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771935761; c=relaxed/simple;
	bh=lig/CBhCdchMvT12AaP9frJWoYUw/75lG1wfXLddETk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOdPKPcu7ytSv3hMqUOGIQHhsVRRWijyYpI9yrZI5lv9/1635uQMdyucDT20ZkV5tqMeR5rztqooB8pFLA9EjjEQfJ07KGhuX8LPqcgEdkVdbxbBZSFqxee7OTaxheLsObTK0XsDBk5/h+rotlUnUHTDxt+jR254mii5OmYQbhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XR3uTLxp; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XR3uTLxp"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-436317c80f7so4400227f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 04:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771935759; x=1772540559; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CITHtR2qBTJvAFbBU67H6Y2kGo1f8+Vk17lQYkH3FlM=;
        b=XR3uTLxpHcHPp39EdbCElR4vlbphTGMnKaHfDqFEkhFTZ6fWYA2uN+K7/E3pU6lTqc
         Yc2+39h+GjvZdHDYDYSXeXFZ7j2r8yBiZsbWJvNYHezZCrcp9s+Zrhkt4NnZv0vEkfAN
         AyOju2dUyxYjEpqMIH84QY3YMvbzahJyZMEGwBRR/FPqIXd1891pgrBbKbQHD5TaYtYQ
         MN1HJ8zVKQxJsXVDHxZZJKyb06zR78Zq2vFKN1IY8M81XQJTGfnufNZDr7pgcVsekcsd
         TkjxVpAQKHbnt5IT5aXCYyLqFQvjb+QPr113jnQmL8CY/mWtpzwHOBImKmyhMiyC1/yq
         ihog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771935759; x=1772540559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CITHtR2qBTJvAFbBU67H6Y2kGo1f8+Vk17lQYkH3FlM=;
        b=Rw3Iv70GHNkWBqpjQaPRafXIXSrGQAPke9v+K7QAOH02/ApIEvPd6QBBCFEp+VO2j8
         A4xH0+i3/3a9Tl1tNoEDO14CPbNIxrMbg7I2RnDkhgdriwZnfOdpXClIDh4PFbHOqHX4
         YKqtrqTFFAq7YRemeZfclijKi12saychlpsyMAnfxKCf0p+0Ubcflsoi3w7kMBMckR/d
         nFz5M7OBt4kY3luq4VEUqn4PH4bu0IBvYPriVIy/y1PMk88vXXMn5XFHccPQ7UyVPHSp
         EKQSrR2wtiA/MAVDlWVOvljsTwkP1IQMpaTN5cfyZWZbdLDD5PChl6RQ87jfWh5b16z+
         /3zg==
X-Forwarded-Encrypted: i=1; AJvYcCWdYtbL9CMNBWlq+5poYl2pqFjyKJnJASmzl7N+rK38vDqnPALLhQ/mWWmLbY+L9GTNKHd1ytAVyw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywfl4NwhHcQ1c5RcIYNhad1mO7bPJjKWtqP94oVPQFlz4beBYDl
	dL3FHbfdj9fE7zkpp13oMVfNYVo2agUPNhppUbzf6Hr3KHSJrXpwHZiPN7ReGfetVT8=
X-Gm-Gg: AZuq6aIRmcj6aHrO2fO/ZLti8B2LYOJ+z0IB07yPZ0x02J+KT40aoHuPL3TmQNVGOyO
	CBXVnMxfcbZ+RE+V49j+q3hL1SGm9GU9xX0z8HbxL6qmURi6LTV9hUTq2nYtifnPGaokgMt0Use
	ZrKVV8HF552FhvIsa1baqJp48Hj+h7TeUiURDLBfaa+cJv/M+xGvZRRtd7vH0YoBAuTtuJi+LXW
	zD2pxtBILTFqQjSdGQ0G2qPLiGItJn2qs7FoCNrOhY8HuJ0jkwfS5DGMkVcEXMjDxy71Q0HkEvW
	H4TnPG7tlajdvLaRcx2bMPrMEFWbkzDZLl7I6FC65axSIypy+lZ9ohEpciMd+ojvbI/IUh/saIT
	XA5pVV8N/xuuoPWSLJ4J1VVeaqV0UElR8SF0mrB6zSksI4XBcMaT1VFXscDBZAQy2zjdD00Ykfh
	a5jdAyscG2Uci2s2g3hQgkpY8DeWU3h6E=
X-Received: by 2002:a05:600c:4e14:b0:475:ddad:c3a9 with SMTP id 5b1f17b1804b1-483a94d1479mr185540435e9.13.1771935758583;
        Tue, 24 Feb 2026 04:22:38 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b88f97acsm17442695e9.13.2026.02.24.04.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 04:22:38 -0800 (PST)
Date: Tue, 24 Feb 2026 13:22:36 +0100
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
Message-ID: <aZ2YDD_l5JN78DJC@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2N9a4XgxnurOhz@pc636>

On Tue 24-02-26 12:39:33, Uladzislau Rezki wrote:
> On Mon, Feb 23, 2026 at 11:08:02PM +0100, Michal Hocko wrote:
> > On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> > > 
> > > > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > > > flags.
> > > > > 
> > > > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > > > 
> > > > My only skepticism about this comes from the line in the
> > > > vmalloc_node_range() doc: 
> > > > "and %__GFP_RETRY_MAYFAIL are not supported."
> > > > 
> > > > I myself don't know why that may be. Could you elaborate on if/why the
> > > > doc is wrong please?
> > > 
> > > This statement was added by Michal Hocko in the commit 
> > > b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> > > you think that __GFP_RETRY_MAYFAIL is not supported?
> > 
> > The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
> > supported. While pages that back the allocation can be easily made aware
> > of this failure mode there are page table allocations which are
> > hardocded GFP_KERNEL and there is no sensible way to extend the API to
> > change that (as we have learned several time over years).
> > 
> > > The VDO module needs to allocate large amounts of memory and it doesn't 
> > > want to trigger the OOM killer (which would kill some innocent task and 
> > > wouldn't solve the out of memory condition at all), so I think that 
> > > __GFP_RETRY_MAYFAIL is appropriate.
> > 
> > Understood. But as said the very page table allocation could be the
> > trigger for the unwanted OOM. The same applies to __GFP_NORETRY
> > unfortunately as well. vmalloc has just recently gained support of
> > GFP_NOWAIT allocation mode, though. This will make the allocation
> > failure much more likely though so I am not entirely sure this is a
> > proper solution for your problem.
> >
> Yes, the page-table manipulation entries are hard-coded and it looks
> like it is the last path which is not wired properly with gfp-flags.
> 
> Since we grow PTEs and never release it might not be a big issue for
> the __GFP_RETRY_MAYFAIL usage. But it is still not valid in noted path.

One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
__GFP_NORETRY is to use NOWAIT allocation semantic for page table
allocations as those could be achieved by scoped allocation context.
This could cause pre-mature failure after the whole bunch of memory has
already been allocated for the backing pages but considering that page
table allocations should be more and more rare over system runtime it
might be just a reasonable workaround. WDYT?
-- 
Michal Hocko
SUSE Labs
