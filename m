Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935E335294E
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 22:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884487; cv=none; b=B0QfPh/u/TNdMnSjEgGf4hwbK9zMHzLmXvTN7+WdejGAFJzeHJ80X+wyqzcmhn83t9L1eOFJEdvufzoe/wxmDiT2q92Z7EBtJ42ZD/Oqu4DccDTJwdYEHBqZJzMUCW6QzpaNnVKd65YPFlkiUQ4cDeY0WQzkVcTtf+9PmJG27wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884487; c=relaxed/simple;
	bh=8rRIKkPrmCkn5PpPpUkyAWUlJgA7J6bf1Ru/sdlnX/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o46ZfKceCI9AV78kNbAz8XEZWzvvv5m39eZGGsFrK5MsCAArgpiWgj61/xPjeLnaFbYW1LafJS1rqzogiajvkKPcmou7956q+il5u3xcqNi9w0H/9ZsC4/ef7Arn0r0AMYRjo6wsCa2TDBD1O5kzgmM1XgryPVr33VnHbtJ8Qs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=alZKy/jl; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="alZKy/jl"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48371119eacso55952365e9.2
        for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 14:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771884484; x=1772489284; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A174gTXfl3TSZiuYfi+u8aLIZY/OSVOEvYujAHiLL+s=;
        b=alZKy/jlbcYz3SFPq9N26y015KBKFW0jrmLdVsVqM23AS/JKJUhhQNP+TxYklNRtgQ
         x56RtCwNZCqMpCyqiFESHWU6fY2rRDVnTFw0rxEa+IWt5XTbs0etyPfmgm777+06w5P1
         fyNT3AeYMUZU7AfA4nKJ1nYVzPhPJI9GWWhaz2q7JCNotqHZGvKuwAd4whRIZLe0ogfZ
         66ZOiT5IBfD6UBO2wohrlSWpTtI3P5+iBuxdOufNxXhwZi+yD6t8rbrKX6qKzVXL0YEe
         WKRZOD6qTO3k6sKLPePbUOXDVSv9uQ32nMFHLYUw6zeDnE8jxNOXeiBVTK3uooEdeJHR
         5ANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771884484; x=1772489284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A174gTXfl3TSZiuYfi+u8aLIZY/OSVOEvYujAHiLL+s=;
        b=mJX9/phQO/t5DGU+59qeF+TjhmVYymK9L2QUpGdSRNENvpMR8Abbaz9LReq0TWrOq2
         180mDlob0scc8ClBiRuH2l4ZDZfyqd1GS/ajNd22w2RkW/Xn6jx9GC8150st4u+Y0u0E
         bfrPopl45f594TzFCYBoKal1Nq5fkD20T4F3vfKPA4mNseJU46+bbctNgyddGYWESc6w
         A+YFWtXmFN8wVkCd/UOd0Wgep532zL48Ul9N74vyEGtxsrjThYqcne92PrS24LDg230v
         TA5QO3kNQuP1rbbX5hZCEP4lBDRYEWzpZFJSCss6mRqAV+w5S84Ij12V6sUDPvqy6M9D
         rFUw==
X-Forwarded-Encrypted: i=1; AJvYcCW/5YAfP6yAudmazeZwXl0tKRtIizyJ+brv2fSaO+cMPv6LZTq60w12B7VRT2QPfHN0QrMKok5I9Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxIFJyPBOUxP53YxG1+6XagBGPKk93r96bUOa4g6dZgLJKtr+g6
	7B5GIYYO2fCK3u2TOwCIBhQYzlmNGSpQd9uBof+R3lrbRPPrJZ1lSNZjOp87f3/SY8SvqxNuMvW
	MffQf
X-Gm-Gg: AZuq6aJzEyNSzuiaJrUesz0fvc4wJrW0VBt7QV425hH+DMmMl5N68uW7YIyRXXde7Uf
	1mXbvX29D1mGX4YatYaLBFH8YsyK0G1F3lfsSLJ3qNfZzI2ZOPnIycE6bjzg6gmi+8QnYmPBwsJ
	6dPorhyXywu9QE2ZlIdScj9Nim1S1xs2lI1K88o5uPa32XIwUEkANn7KfUHUmv2s43YKhXT1nuh
	gHp+3BVqixdX4A+FqK8ONFz15Br3qovJNv2viePwyCyHnQAfDDzIiXGKCjCk+rXV0QmxWFNBLec
	+UhOwmxjUqHFuaWOovM7y+Zm95CJfYg4kMW32UCH8v+4Dyir0r7TY//fapzifZBsKeOokwsPayr
	Dg3nMTFtl/zXASgY2DjMZGypZLaf/aCpNr6T60QLKCz+bX73k6ax+8Li8MJP+ei6Gm0jk68tGxn
	71eVU4ex6c3vyYCQHjwBbq8ijFVw+VfKY=
X-Received: by 2002:a05:600c:5020:b0:483:71f7:2767 with SMTP id 5b1f17b1804b1-483a95fc0a9mr183175305e9.11.1771884483837;
        Mon, 23 Feb 2026 14:08:03 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b82392cfsm6801775e9.3.2026.02.23.14.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:08:03 -0800 (PST)
Date: Mon, 23 Feb 2026 23:08:02 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZzPwsBp-Z4XM58U@tiehlicka>
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

On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
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

The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
supported. While pages that back the allocation can be easily made aware
of this failure mode there are page table allocations which are
hardocded GFP_KERNEL and there is no sensible way to extend the API to
change that (as we have learned several time over years).

> The VDO module needs to allocate large amounts of memory and it doesn't 
> want to trigger the OOM killer (which would kill some innocent task and 
> wouldn't solve the out of memory condition at all), so I think that 
> __GFP_RETRY_MAYFAIL is appropriate.

Understood. But as said the very page table allocation could be the
trigger for the unwanted OOM. The same applies to __GFP_NORETRY
unfortunately as well. vmalloc has just recently gained support of
GFP_NOWAIT allocation mode, though. This will make the allocation
failure much more likely though so I am not entirely sure this is a
proper solution for your problem.
-- 
Michal Hocko
SUSE Labs
