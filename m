Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E2E3126C0
	for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 08:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772008389; cv=none; b=o6eArlt99G8wLuaXw+Te5VtL/fjQaIrn4ADMmHv+MLPQInu4p6XH8/1OAHp1OmL9eg4W2xvffqzbmvUgiVQMrQ1kdM4E8VI9UMS0MvqsezwFGiO8DqHwCtjabkesu1QO/m+CckfY5QmxKy9PmzAj/3AF/8VUxOG0BA6m+XNjR9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772008389; c=relaxed/simple;
	bh=q2Xvq8EuUSEClaJdXMzroPjR/7leDBTtIcnhYBsH7KM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKFct2SzH+e0vdEtRgIva2n6ZmP6pVjX6C0gXKAILVswNkzj/ZbaiIiOz6nCZ+xQGX8wdskZ3QPoLQC2wOHXgCmqijz9u7l1s4bYj7rpnTKlIJAmINv94w2DIzqTIssCWCOqlC7mn9jBnxzL6N05jvVEWa4LLJH7M6zhFAjBQBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jlAbfQHh; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jlAbfQHh"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a1016ef3b6so609654e87.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 00:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772008386; x=1772613186; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QUcecvJ6CTvZw4HoYhcVZcZInJ2rCw8PwxbbGXj6WpA=;
        b=jlAbfQHhTEN8bfhSsXXzofkvtXZ/ajPnCvyXtf6m8v+Wuw28DuqROsnEWzEKKbfnvU
         2Nr+nkRpQb7N4W9ousy2p+dXb/N0JMH8UPYy8rd2fOgnIN0TSM4Z7jN6e9tvlkUxKrIG
         fih551gH38YpRkRVb7U3l2TA+GDJGxG72OyhtMI5MsYK7jIPpcxQc9DrW3Mvq2MpC2BC
         isoeG7Oe/riQo1olE/2kEgYbj348wtEMP0UOo1+2jkXIjkiQacxEvp/xC6ReMCGXoeQ6
         lwfQqFGTCCz2iuLpewB8HlNZ0lr+uAM1MPde6fo4nWhk929+1EG1yzg6Z+pOJtrUERai
         h91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772008386; x=1772613186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QUcecvJ6CTvZw4HoYhcVZcZInJ2rCw8PwxbbGXj6WpA=;
        b=DphZU/EuM+e/uqAv3lji+OkYwtSmDK8FHbFsGo455pVO7nfjhiM47KbpzMVsTIO1Ys
         PptMbWcGmeYx5k43KOoSyvKrXnaEP+avKaMmn5IYA1xp9Cv6znEGweewiuqmHmt12D8J
         14dib9fC/LhlTYzJKgKcyrWMRRRKBYA4jFi4zgTSxpZJKR4PX4TbiIRfgtZqZ/9ehXuI
         aXYMGQn1Z4AUvdI8bKdFHkb9/sevxeQtUZODVKQ+BGSATmw/brd5NF4FL8x68H/+DIVd
         kdY/Lk34sW42Hy7Um+5rZIPdi/krX7c6ljw4b1smJliMSMfi2hAS0cdEhigKMp5VsbZm
         mLuA==
X-Forwarded-Encrypted: i=1; AJvYcCWOT++gHbsZ2kv+J6pPeRNtsmEEx16vjOWv2gT01Za7skYFm5w5D3+RS0/dAvyx5cYC3WfIgLYwUA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyKwjuNeVoXfdNN2zr8zAfz52ecxP+NI26OZHHFNBnWNI/1DJrQ
	jYWhmiqfN8bQ4SpGCgzTyBd6OJJy3pYZM919HbxxiSzzVA4O/SJOB99l
X-Gm-Gg: ATEYQzzH6vsWasu+XycTQ6BJALwSg5070xTqMb9eIe2UvvaFJialWI683f+HJt2KRWU
	9biYmXxXHbYveDXl1KiO9s5pBH6AFRtYXOO1oUHNO0FxtgUfxnhzAtD4dHjU7so1maWBAXDQ1kD
	N6aehGFjOeBInIF9Kx6fIiB2SjRhqbuC2iVWszNPaC8e8tUyr+s+S7ZMgrmfmteEiWNeJfTtwoe
	2tHljBhdU3qpbzWImv8Uoh8Qj7RaMxjx/WLlA3vIuGvpUp33Lh4wYtJqJQKM0mEPGiUzbta+y3h
	b7X82KNrb+KXLzZwPRXTzFbuOjl6rUxWzmFQCWl93oTnneBlQ1UPkuht+hVuNOncZw13ILEkb0M
	OfggAOB1hXeEOti/GgWBUTCNHMCgo/WcqJ/TJ1Wl6f6IVP2q9GxegBLuMyiVCJrdxqRcgp3xbh1
	46digkvBcglwiP4BGWTHbEiSyokEEi36zDBVDfXp8fogvEDaaaR7UlEbg++VEneKk=
X-Received: by 2002:a05:6512:2213:b0:5a0:ef6d:475b with SMTP id 2adb3069b0e04-5a0fe48952dmr910148e87.11.1772008386045;
        Wed, 25 Feb 2026 00:33:06 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb0b9aasm2778886e87.12.2026.02.25.00.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 00:33:05 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 25 Feb 2026 09:33:04 +0100
To: Michal Hocko <mhocko@suse.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ6zwMQIj-3JFQZq@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
 <aZ3JB5Xm3SCmJW95@tiehlicka>
 <aZ3MzxtMp2OykAQq@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3MzxtMp2OykAQq@pc636>

On Tue, Feb 24, 2026 at 05:07:43PM +0100, Uladzislau Rezki wrote:
> On Tue, Feb 24, 2026 at 04:51:35PM +0100, Michal Hocko wrote:
> > On Tue 24-02-26 16:44:43, Michal Hocko wrote:
> > > On Tue 24-02-26 16:38:01, Uladzislau Rezki wrote:
> > [...]
> > > > I do not have a strong opinion about workaround you noted. Maybe Mikulas
> > > > can switch to NOWAIT flag instead.
> > > 
> > > using NOWAIT for the full vmalloc allocation would be just too easy to
> > > fail under moderate memory pressure.
> > > 
> > > The real question is whether we want to provide some sort of backoff
> > > early but not way too easily allocation semantic for vmalloc. If yes we
> > > need to get creative in the vmalloc internals rather than expect callers
> > > to be working around that on their side. History has proven that this
> > > just leads to tech. dept and more work later on.
> > 
> > Just to make sure we are on the same page I mean something like this 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 61caa55a4402..791366fe44e2 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
> >   * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
> >   * GFP_NOFS - memalloc_nofs_save()
> >   * GFP_NOIO - memalloc_noio_save()
> > + * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save() to prevent
> > + * OOMs
> >   *
> >   * Returns a flag cookie to pair with restore.
> >   */
> > @@ -3806,7 +3808,7 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
> >  {
> >  	unsigned int flags = 0;
> >  
> > -	if (!gfpflags_allow_blocking(gfp_mask))
> > +	if (!gfpflags_allow_blocking(gfp_mask) || (gfp_mask & (__GFP_RETRY_MAYFAIL|__GFP_NORETRY)))
> >  		flags = memalloc_noreclaim_save();
> >  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> >  		flags = memalloc_nofs_save();
> > @@ -3940,7 +3942,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >   * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
> >   */
> >  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> > -				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> > +				__GFP_NOFAIL |  __GFP_ZERO | |\
> > +				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
> >  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> >  				GFP_USER | __GFP_NOLOCKDEP)
> >  
> > @@ -3971,12 +3974,15 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
> >   * virtual range with protection @prot.
> >   *
> >   * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> > - * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> > + * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
> > + * Zone modifiers are not supported.
> >   * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> >   * by __vmalloc().
> >   *
> > - * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > - * and %__GFP_RETRY_MAYFAIL are not supported.
> > + * Retry modifiers: only %__GFP_NOFAIL is fully supported; 
> > + * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
> > + * i.e. page tables are allocated with NOWAIT semantic so they might fail
> > + * under moderate memory pressure. 
> >   *
> >   * %__GFP_NOWARN can be used to suppress failure messages.
> >   *
> > 
> Yep, i got your intention correctly. It would eliminate the problem
> with page tables allocations :)
> 
If no objection, we can go the way which was proposed by Michal and
support __GFP_RETRY_MAYFAIL flag.

Mikulas is that possible for you to resend the patch including
Michal changes(unless Michal wants to send the patch on his own)?

--
Uladzislau Rezki
