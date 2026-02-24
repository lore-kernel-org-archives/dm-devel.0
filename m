Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980AF37AA9E
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 14:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771943665; cv=none; b=ZpmNiKq0PC/TyPlOHC/c4Q9dfQjP1/sTycsRrLlZV+nwRXrARoX1ZM4KC7PzQsWL1mPAGxirBumNFUDoRhJveB6bOY9vDzIXFe3XQaSotGIY2gbAynsX1WZ1r4ahvhx+30HNXgeX8mRywcklSvas7Q237oLFw6HcV9cfTh2zy/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771943665; c=relaxed/simple;
	bh=Owl+7ORyVijcZpkNs7EWJ6GQ9AoGcjLwhZP/ZwH5GB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UsWiC1F2oZD7bl+02gVHyKxD3JO6W9xD+ZTZmrXOOnukkUS+1EiFagFchp0KiKvBU2LMT/ohEd6/TIglJEsEoqnwEo38c3MoqjY/GQm1pn8Wk1iM7V2/OzJHVTZAx+Y0GSnOE6nzYETeji7xzCFzwGfRaIAKXo3BsC39Xp4TPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HZSsW+Km; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HZSsW+Km"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso42499375e9.3
        for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 06:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771943662; x=1772548462; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z6XsRQ1YbstO4vIvVioaL3gYgTplaCGPe+QatP3oUz0=;
        b=HZSsW+KmGFsnGdEFmKbBz4tFqIhu3YKZ2ioRUhhdSfy2kZjGwuvH5K4s/sa++FXxQH
         vHHYp1v+2xOunPadbxGL0ediid1UGPtPVAywcQs2FJQ2ai+XC2Nh51BTksruSfnjVEob
         AONilUQ2fkKq1Gjp4nmZrBtVFp1zr/3LxfSMYFqk1tL8sVXRFji9CCG3KjNiz7pQ4hqD
         b4s+dSHeQANhLs1SK5HQHPEua5oVMRM5ho5o8n5NjHk23Wg0Yr1fp4DC+LIK6Lwqn88F
         ALG4cEfeX0l5x1ESSOIwtdmOj2sVHJoZ2wfAws9mqZSHSyxwPmbFw7XsyTHFvDmfta3O
         kBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771943662; x=1772548462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z6XsRQ1YbstO4vIvVioaL3gYgTplaCGPe+QatP3oUz0=;
        b=aVBNBjSep/SigKI52yQBFgBB+0S6mu7yvldOjU75IbBlLTSCtCbbnaiA1DH6AjmjTX
         GWp8rXCl4cLrOb+UMRb4vDVzpgnJl+4cQGXdeViLl4+ePYnlK/Pz8eT2q9/JHQcHbTL4
         m95OZ76b2WKk7mnlmTmXjCoowlOo62EfW1UFhzrC+m2cyGhKy1AS+s8kWyUcojmQU3ZJ
         /6/dm6AEZCo7yNOIWRRWAEtLrvPujzPptel9fD2X3pzGnXR/20jQMzrhUhgpNQe9M6Py
         Yg1Hd1PW0tWgmMBt8cIAIdYCZ8MaHp9zIxuEclV6pym32F9o+t3QKLi+4S9HMcKCM8uI
         wBGA==
X-Forwarded-Encrypted: i=1; AJvYcCXRqnMh0QnmaJmKr2yEpR+VyYBtR2VBlkbuDnAFeFqW8IMtdgIkD0ivfcW9X4W35pnG5ZKUB4b4Dg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0TbgcqB0fDFwKKvVUW8jwnVJq+VjhTKEn98+9Fv5jezDx+OsO
	SjWzrY4IIDUBqyKuXIyvqC1UUP7fmqmyTBBG4ar+v7jJxbSWvGFLk2P0UJ4M4g0BS8o=
X-Gm-Gg: AZuq6aK9AzvefR8AfNGcQ2ZFcYETho0TlEaJ09RAZmA15W+m9G3sjkM+zQci/ynuNWN
	+hECtpDEqg/sY8gCGUFG2FRhd3r2Z6gAe13VvXqfo982dKeB1YWXdHR8K6jp23OygMW+UML+24v
	xcQvPjdIFoVzEK92nwj+6QdsjtEX4hiMS2qJFXX3QCiZVn2rtM8+H+GWyDJkn1T093oiDjl9Lj7
	WG68/QctJdzDTE0cVfaxL5k0tNqUDaPc1/AtIR/yoy47oN3lIxXZJTVOZln3u40HxwR0yug17Sa
	QlhvAKzPK2mq2HmfNafziB8H/1H5eQcQvClsJjPmUUlGQkqFOc5tNmn6YuqEaztWmX3mf4R8mw2
	70rZiMzPXd/hhry63Yp2Ubdb07p3yObZ+3qaU4dSJEp9F1kI+P3YLA9StGEcCsPQYMMgRSoK+xX
	rLoDZpJ6Ak8zuBM5Y7IyBzXrNv0jk/W+o=
X-Received: by 2002:a05:600c:190f:b0:477:9a28:b0a4 with SMTP id 5b1f17b1804b1-483a95574c5mr206158565e9.0.1771943661764;
        Tue, 24 Feb 2026 06:34:21 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd6854c7sm10875895e9.0.2026.02.24.06.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 06:34:20 -0800 (PST)
Date: Tue, 24 Feb 2026 15:34:19 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2261F3V2KFfO86@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ2voRA5VJytcfLp@infradead.org>
 <aZ2zPzyoFUUNWdJ7@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2zPzyoFUUNWdJ7@linux.dev>

On Tue 24-02-26 06:22:15, Shakeel Butt wrote:
> On Tue, Feb 24, 2026 at 06:03:13AM -0800, Christoph Hellwig wrote:
> > On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> > > One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> > > __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> > > allocations as those could be achieved by scoped allocation context.
> > > This could cause pre-mature failure after the whole bunch of memory has
> > > already been allocated for the backing pages but considering that page
> > > table allocations should be more and more rare over system runtime it
> > > might be just a reasonable workaround. WDYT?
> > 
> > Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
> > too hard to allocate PTEs is not breaking the overall concept.
> > 
> 
> One thing __GFP_RETRY_MAYFAIL is very clear about is to not trigger the
> oom-killer which is not the case for GFP_KERNEL. There are users who explicitly
> use __GFP_RETRY_MAYFAIL to avoid oom-killer.
> 
> Mikulas, is that the reason you are using __GFP_RETRY_MAYFAIL in your use-case?

yes https://lore.kernel.org/all/32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com/T/#u
-- 
Michal Hocko
SUSE Labs
