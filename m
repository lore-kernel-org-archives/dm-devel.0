Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com [209.85.208.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299B727F4F5
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 15:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771947487; cv=none; b=Q0flTwk6zuIVWXMt/umWnPVjJ9np52qjmNOTLEsrZkDyO89RjyTGtxDe/wiLSaFvSkh1SKnRWL7wQ15KOfg0e8sQZat4YDkABI5tgx2aXpH+TBAlsplhyE/fGzRL5uODjaPvztTh2k1rALoU+kQVXZqeDNH8X5a2gES+9Ri016k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771947487; c=relaxed/simple;
	bh=Ns8C2SijYQpLsijEWV9afZHpJ+wQTsBYGNs5+M/F/ow=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vb7BFHZYwI1TVdek4EpqWuDZ6HG4XZKUyoDsFzJeJgi7NEspFY+V/Y7AS0NJd3Ll1cGe8lEIRDYKROeL33J8JaSZFMAGN0m3KneosFHYRMWotBY4YBzqJ+T7EX/Wz9CT1YtOPMfC3sSS28zs4/7j9pkShKr3FYQ1O9PvN0S+8Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XlUXZGRt; arc=none smtp.client-ip=209.85.208.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XlUXZGRt"
Received: by mail-lj1-f194.google.com with SMTP id 38308e7fff4ca-385cfc572f1so44615481fa.3
        for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 07:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771947484; x=1772552284; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1d3HoreSzqInLLmkALJG0kLsfv4b9J4eqo5ttaXel6U=;
        b=XlUXZGRtz8ywP/cHGapVXjHr8EeHbRA/1Q6IWyd69QWZDCn5JKlQhF9oAKoA19GLRj
         KxloqOdf4o0URGwg6ZOELBSppSZdVxIhDSuYjG7HHysb7GfYD4GVVVPIF0dayB075fUl
         v49gbUaqQHpqLN3SKMgAyM1lG3g9a9MbI6IdlO+NArq0605+q7pGfsyQqlszVQj6oqXl
         fj0OI79OrCZziU+rTysAR197iRDNaUAJuQQnxqT/+WWBcg8NTut+WqEyqCM4O5/Jdhsh
         89RjpPDuYaTKl0hg+oOZ5Uxu9v2Y875Ki4fLNNS5REs48P9EEbLFeiu9ZO3y8xzb9FEY
         bTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771947484; x=1772552284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1d3HoreSzqInLLmkALJG0kLsfv4b9J4eqo5ttaXel6U=;
        b=t10ADwjgB+HZEAhn/pJrTAfWAcXtHNj3ZxZlKnuI5swMFkdERnvu/PPIWonspWTUBM
         KCAOoQSreHSddgh4W/O11Hll3hgIHKsjedhNvSCXm9cOWbngI+HtON4XGq4DXpzke3n6
         Iskon7GaJtqEZpUEbqvixL07GVcPyRsplKpoclKtkQxrXxkPbFWAxQGrYNPt48w8QtXE
         do+kvodrYCr5PmVM9JSviTLDOGrLyG7aWNq0a7jhZjLKX/oa5E81TeJr7SAam+E3J7MI
         bHi4kUCOrVhp31pB/iIi+GIHdhyhq9mAHHbaU0/16o+EHxIyBUzf/CfzpEJfkkGxjbMM
         PwmA==
X-Forwarded-Encrypted: i=1; AJvYcCVZB4yGkcHlrNwrtZjWd9SXuEBaFZlch9pfk/AsLdrfKGlnYvc9jWPylfqfoObW2ULMTnJm7Im6Tg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwsL3TxWH5sm0gPVgU5buJTBOuKW5EfJaxgwKJR/UFDL/19XlPf
	c7b/1oh8GvarR3A4jtyA2DruoxtqEcnRUEj+KyoZ/f40G33BG7g0fZpl
X-Gm-Gg: ATEYQzx/lg6Nv5tIYEyulBXDLUOwU/eM0tCOrctinWtFOdc9d2gJ0inUU07CmNFBXNh
	6+9cRlwUhb3pT4CBytVE3ksyQl3YrM7XcpczqycUN4aYAcA3DKVDwB2iDYffv/sDGjbc7m38/AX
	xuTma8/DLcbBhIARE+fiTirSx+170EyhgSISbvXnCWD36AEMQmgyIick6bNwcseQ4L00gxWb9h3
	dm6Fb4/RUf+wY6m4yoyyIWzD0I5iSIEsF3JnUkcqH8+eTnzy/gvRt8gyFf9CKZb7/Tr04frQajF
	xSxc7EKs34DEWuH95cnbWBDYAGsBKGns6mbdKKQsYhQPCGh5RGPpyDCEn3qpJkPyC4c08z4SYaf
	tjx6QiSqYb+S9rDHns6aGzjDRYXBAg1ThCA/Y4hgUG4SIrD8pgqLwX2PqirVsvfVBb21ktEiUAz
	6+woZsJqRV0CR9FtU8iOlAS0VVFbESKRqe5bjd4ieLNmMOjJ5pNmcc
X-Received: by 2002:a05:651c:324e:b0:385:fbff:ab2f with SMTP id 38308e7fff4ca-389a5d4ec51mr35490151fa.17.1771947483965;
        Tue, 24 Feb 2026 07:38:03 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-389a7a71271sm23396621fa.31.2026.02.24.07.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:38:03 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 24 Feb 2026 16:38:01 +0100
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ3F2cghZpqBi1Mk@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2YDD_l5JN78DJC@tiehlicka>

On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> On Tue 24-02-26 12:39:33, Uladzislau Rezki wrote:
> > On Mon, Feb 23, 2026 at 11:08:02PM +0100, Michal Hocko wrote:
> > > On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> > > > 
> > > > > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > > > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > > > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > > > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > > > > flags.
> > > > > > 
> > > > > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > > > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > > > > 
> > > > > My only skepticism about this comes from the line in the
> > > > > vmalloc_node_range() doc: 
> > > > > "and %__GFP_RETRY_MAYFAIL are not supported."
> > > > > 
> > > > > I myself don't know why that may be. Could you elaborate on if/why the
> > > > > doc is wrong please?
> > > > 
> > > > This statement was added by Michal Hocko in the commit 
> > > > b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> > > > you think that __GFP_RETRY_MAYFAIL is not supported?
> > > 
> > > The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
> > > supported. While pages that back the allocation can be easily made aware
> > > of this failure mode there are page table allocations which are
> > > hardocded GFP_KERNEL and there is no sensible way to extend the API to
> > > change that (as we have learned several time over years).
> > > 
> > > > The VDO module needs to allocate large amounts of memory and it doesn't 
> > > > want to trigger the OOM killer (which would kill some innocent task and 
> > > > wouldn't solve the out of memory condition at all), so I think that 
> > > > __GFP_RETRY_MAYFAIL is appropriate.
> > > 
> > > Understood. But as said the very page table allocation could be the
> > > trigger for the unwanted OOM. The same applies to __GFP_NORETRY
> > > unfortunately as well. vmalloc has just recently gained support of
> > > GFP_NOWAIT allocation mode, though. This will make the allocation
> > > failure much more likely though so I am not entirely sure this is a
> > > proper solution for your problem.
> > >
> > Yes, the page-table manipulation entries are hard-coded and it looks
> > like it is the last path which is not wired properly with gfp-flags.
> > 
> > Since we grow PTEs and never release it might not be a big issue for
> > the __GFP_RETRY_MAYFAIL usage. But it is still not valid in noted path.
> 
> One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> allocations as those could be achieved by scoped allocation context.
> This could cause pre-mature failure after the whole bunch of memory has
> already been allocated for the backing pages but considering that page
> table allocations should be more and more rare over system runtime it
> might be just a reasonable workaround. WDYT?
>
As far as i understand, Mikulas uses __GFP_RETRY_MAYFAIL with vmalloc
for some time already. I have not seen any reports about that a PTE/xxx
alloc path triggers OOM killer thus i tend to say that it is not easy
to trigger.

I do not have a strong opinion about workaround you noted. Maybe Mikulas
can switch to NOWAIT flag instead.

--
Uladzislau Rezki
