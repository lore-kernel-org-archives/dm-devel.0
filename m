Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F4B37BE7A
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 11:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771933180; cv=none; b=fto39bWqZ/P6UzF159N03aNVFYD9A7eMk3ITiA5LpsXR3hUodhQXfM5TIoxNO3uOt4L/JLrYEaTVzLbq1keOTPGPafW++w/4n5VNlzhxyJ9XjQobx0Gvv3/iMaIXln/i//F39YjLh7xHLyItj8PZD9Xx2tMyA9fIjnlSjVvFsAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771933180; c=relaxed/simple;
	bh=DDfy69qRmUNyRIv4EHALGtNWaiXMykDCEYuYBlB+FVc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agEcB+ihDPu06WgUv78JSms1BxGZHqTTghnzcYLqrmh8nhg/6LFyCEoOJR7WfZ/AnZ3+7U5m0ku9sajwTJNVB4UhLbK0NmtssfN/kQz7FRog7WRrsozwM623MEXlGfVCfLf3M8ae4DXutfdX4ZCm3WM+jTeKnNIbmKj8A4o0VwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPeGhh7B; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPeGhh7B"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3870c7479c6so42907391fa.3
        for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 03:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771933177; x=1772537977; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7KthUXIGMkC3Ch7vQnkMN1zxx/VHydxO2+xjM+lwoS0=;
        b=WPeGhh7BxaC5DjKX9Jp6wuFafgk3T2Tg/d8ghATepeYhUZaEY75o0t0qFsmitr5CF1
         JrLYIMyv5r1I8pC42rnS+wcAsBREDdBxjXSoCJOLzPyaGio3RBDpZwe8xAnEmiFfYi6s
         k3mr4u8BIPNnvf8+I0Y19Mg5WA8ewEN4PlpASc1D9wbWdOd62GjI6tEYGdKNVWe2f4bb
         B9ggjL6dulMV8fL5cJF+aRJyK/RkjDgEzXTzJklKd+ZCBFxOll6jG7mZ1DR4L3NRGsk2
         yyy39um+FXdpSW42CG9tqwI/yxup4SZrc0SsvITCdqZeIyGBlGIRkmYKB+kWb9uT2Z7m
         efog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771933177; x=1772537977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KthUXIGMkC3Ch7vQnkMN1zxx/VHydxO2+xjM+lwoS0=;
        b=syt6jeq5WMcM1WzBV+06k3/L9Yx0gu8aTwBFNfkwF7Jheg7KZZ6LE3yDJ0MZbttq8A
         tv229IJ5bxKyAySCpS0qAQBfVZiQXWcVuyAfxjnvpQ0rVjaD5G4pVaIjn0PEavjPLGHF
         FxCx6iTIAWKCcIErzu6J36a4G/aHrgLhI8Il36Vz9M1OArpvGndR9SpY2cYLxEOEbCq0
         FNx2a1JInJWaB2hdNt1JUihCVGgtKPodKG91YiZTZMJXIOpHpqMHduthqeISMKgiT9fK
         jeyIcfYv4qQgua+JON7cF/QdVosQChXnYVs5x8NkK6atC4Q0T/VCsqsT1ZeWgpXxHcd9
         lSIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDL7A6Ok1cOAwIyO9fb48b3KUOA18wE6BChoNN0J/saRCCFMtWF/pf/MQr94kGMkzWfHpvi0kcZg==@lists.linux.dev
X-Gm-Message-State: AOJu0YweTDdxdbJ/d68oBRofaIK3ya4cWdgyJ1MbX9534H+z/N81C7OR
	OWiVIda2kzI9hmZ0v1/xm2w7PrlKy3A9dXkXTiFhQQuj1MN+3nAbeN2W
X-Gm-Gg: ATEYQzyAFL+Dof2CC3/kHRXn+pQVlvW9wVXnBMZQEz21LmXFdzyoaavcNe9f8FWX2bl
	Z4m9P/TsN+y0jPohahPduI4SZK3L+uAe/h4NgegTiA/VNl9zSM9YJdUZnwQ31X7ayUa/2fzGjDv
	i0/UOHQ5sBUw/9Kycw0hkFMRIULPABbCUqa/jQI42x4uFU/DhvH2FoNp9f6ivNzqnoZaxqeqjjr
	tyD1+YbHySEM7aDLq06xy5UiEZwd45RRV8fbCwkUPhY2LcgcSQd3se5sPJ1RQmBWusQ/CnBBFtn
	g42Pu2BWxdvdHTD6ihTwSIi04h9E3XRzavsC1GfcWqd7bOODy1iMD5p2a2qFPGDa5uLSa4P+sI7
	t/7KjWWUlI/IzvyqMInKlT6QZJb5s3/bdj4jSa0o8vvW6GeqcXhMZN4B4+FCc6eJ2mEllxtcuM9
	2G5vcrk5qTaTvJfAtl4TJBatEPQUgeFQqYjgDGr6mX24c9AGzQ7HGE
X-Received: by 2002:a05:6512:1306:b0:59e:6447:f520 with SMTP id 2adb3069b0e04-5a0ed99d856mr3918854e87.37.1771933176950;
        Tue, 24 Feb 2026 03:39:36 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb0b8f0sm2106563e87.14.2026.02.24.03.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 03:39:36 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 24 Feb 2026 12:39:33 +0100
To: Michal Hocko <mhocko@suse.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2N9a4XgxnurOhz@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZzPwsBp-Z4XM58U@tiehlicka>

On Mon, Feb 23, 2026 at 11:08:02PM +0100, Michal Hocko wrote:
> On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> > 
> > > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > > flags.
> > > > 
> > > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > > 
> > > My only skepticism about this comes from the line in the
> > > vmalloc_node_range() doc: 
> > > "and %__GFP_RETRY_MAYFAIL are not supported."
> > > 
> > > I myself don't know why that may be. Could you elaborate on if/why the
> > > doc is wrong please?
> > 
> > This statement was added by Michal Hocko in the commit 
> > b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> > you think that __GFP_RETRY_MAYFAIL is not supported?
> 
> The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
> supported. While pages that back the allocation can be easily made aware
> of this failure mode there are page table allocations which are
> hardocded GFP_KERNEL and there is no sensible way to extend the API to
> change that (as we have learned several time over years).
> 
> > The VDO module needs to allocate large amounts of memory and it doesn't 
> > want to trigger the OOM killer (which would kill some innocent task and 
> > wouldn't solve the out of memory condition at all), so I think that 
> > __GFP_RETRY_MAYFAIL is appropriate.
> 
> Understood. But as said the very page table allocation could be the
> trigger for the unwanted OOM. The same applies to __GFP_NORETRY
> unfortunately as well. vmalloc has just recently gained support of
> GFP_NOWAIT allocation mode, though. This will make the allocation
> failure much more likely though so I am not entirely sure this is a
> proper solution for your problem.
>
Yes, the page-table manipulation entries are hard-coded and it looks
like it is the last path which is not wired properly with gfp-flags.

Since we grow PTEs and never release it might not be a big issue for
the __GFP_RETRY_MAYFAIL usage. But it is still not valid in noted path.

--
Uladzislau Rezki
