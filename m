Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16913A7833
	for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 11:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772020012; cv=none; b=mHGOyr4BRS7ut6O4EVA2Ja3djXXdHnSX7JWjRez43iRt7VaBB9dlfEJlsxatzIXwRmwDAnI//31KHBCHj939HyDbgqYG3O60bES12lv31xM32yrVhyIBP7rYIZnpbSBUO7nASuyalE5FmDKudeQJtiFsXOeL8cuEElCFQMRO5VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772020012; c=relaxed/simple;
	bh=21oILARaiS2cDvPL+RMoTSb3jZyBwHJRiZ2aQ156ef4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkhhJZccyLrva1Bia9k/fTo3P17au3Jmod0LY11Y/y3uFDTcLCdZvlTUn+KglEQ/KdbJVnIiX0uArB6o8Zp15YHdPcRytWMyhxRse6jO2w0yTnRKlPtyWs141osZcYEfhS6/2h7GL+uZRvrZeGP9xA0P2Aii+fXgbL+TZ2KY7cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aezxq1dk; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aezxq1dk"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-48373a4bca3so40542285e9.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 03:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772020009; x=1772624809; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cNc9GIaPSTJl+nOh/VY47x5Qb0/LB38ox3wV8xU//DI=;
        b=aezxq1dksSBSqhVyglu7WxHPriLCD+8IrY7/SY54fznyX1ROK80FcH/zSHvP2QsCro
         xZpnTvwE+U2pJL8lXsyN5OugQi1P4OQNEQNVenaHNTY0VptN8mEoZGO0ylnZ3GNJ1Lgu
         nsIh2QL220xTbVos13Q3ZovRoRT01Cd41tQ/+RHZ8PZv54xDA0oC1EWbjp7SesEHY4eN
         kOM34iz87AyH5PrYM171ke1pdK7umxz78VZ7Hllb40GdO363Xv9tZYiKu/IdoirREnQJ
         HrstlV2KyK+a9GnpAYRtU5tYapjiymI8Xxoozz9UUkfOmcsa3OnD74g0sJ7rawF4yT7t
         bT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772020009; x=1772624809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cNc9GIaPSTJl+nOh/VY47x5Qb0/LB38ox3wV8xU//DI=;
        b=wAR5IIJsM7Cj2RmlyoJwe4uBDToYpQmZSm+HFweS+I49d5irsbNPxoa0OSRTk+o7b2
         XMQdg+nI1NDuk531lzfOdidiFakVFjwalkObM66YECq8ER/L2l75Y4mKWehsIJAVeGkV
         d7Qbk4Lb9XDZ02RbbdeTgQbvojQZWRCFwh4XEDbYuwhgQfEA5pyr/pkEIHo8IsBKNzjq
         Th3W7cCyC2lFGA5j6iPzuK/59wRDvu5x6sMwnRot3iD3pH8OEvQsZx22LvX9fSQI39gF
         Sk4tCZqKhrn2h3hsnGULVHnMEktoZIQZ3sqNHilN8sbgzDGzO3vdouNACbON8bcKet9Z
         3wiw==
X-Forwarded-Encrypted: i=1; AJvYcCWGQ7E+ICyFyssRaQkU4cGyVikKIJxzXCMQHv3tcpWjxbaHyspN+Zv1H4DuuIHFiyUZpmdGy0ftVA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzN+CYvBV/RX+T8nb3/OCjvGar0r2yywL0C5LRpNyYGoJIS3ycp
	3X1c06FK4+/0Zr4E7C8Gy8kSBafy7dH9jcf50ZpPNE18TGa11YwxduIKAC81kXudB1g=
X-Gm-Gg: ATEYQzxAkD+5otQB8LE3HMPQiTAZvFyGg9obeII1LYmQiUG35wIIWq49qtqiXgStdNz
	rK1mLr5eDeLQHlsBwE6cEJX00zy+8AuOfRYBslkyLa0yhaGH5habEJI8yPQ3n2f1oY8iWEfs1Om
	6nHDI2RrNSGYMxEX3eHJuCEpXgo9ueS0SnlS7DPGm/qH8QltyAzfjEWaV4jszCGGs6To5gus9mQ
	n0g0mCWyrg26oT/GVGgdM5HtGYo4BGwFKyPIP4dlpi9QdQTRm82+HwEkXwIZ3A9ZE9tEWVTOWpv
	e5X8YvsLAUZMPyftXDQ0dOFm5SNj+eDNNQXDM7h1/dixCG2h1ltzApXa5pFQEhicBNpu68A9EA1
	uhZLo41u6Lyxz1W636MH193KdWAANSYC0e4e5sBtNwhJ71mzL8JykIDlUgtQfSuSV9NE3Za6LqY
	+Srqk8MmsniXKRE8ySzzFVaQkSG0YdRhk=
X-Received: by 2002:a05:600c:4f93:b0:480:1b65:b741 with SMTP id 5b1f17b1804b1-483c21793d2mr1738195e9.15.1772020008975;
        Wed, 25 Feb 2026 03:46:48 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcd0818sm10055605e9.26.2026.02.25.03.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:46:48 -0800 (PST)
Date: Wed, 25 Feb 2026 12:46:46 +0100
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
Message-ID: <aZ7hJi2-iATBD6GL@tiehlicka>
References: <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
 <aZ3JB5Xm3SCmJW95@tiehlicka>
 <aZ3MzxtMp2OykAQq@pc636>
 <aZ6zwMQIj-3JFQZq@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ6zwMQIj-3JFQZq@pc636>

Feel free to use this patch. But please note that I do not have any user
so I couldn't test it. So make sure this is tested before posted for
official inclusion.

--- 
From ee94ade23655dac7e239c1dfd2b04c0db3d10298 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 25 Feb 2026 12:38:28 +0100
Subject: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY

__GFP_RETRY_MAYFAIL and __GFP_NORETRY haven't been supported so far
because their semantic (i.e. to not trigger OOM killer) is not possible
with the existing vmalloc page table allocation which is allowing for
the OOM killer.

There are usecases for these modifiers when a large allocation request
should rather fail than trigger OOM killer which wouldn't be able to
handle the situation anyway [1].

While we cannot change existing page table allocation code easily we can
piggy back on scoped NOWAIT allocation for them that we already have in
place. The rationale is that the bulk of the consumed memory is sitting
in pages backing the vmalloc allocation. Page tables are only
participating a tiny fraction. Moreover page tables for virtually allocated
areas are never reclaimed so the longer the system runs to less likely
they are. So it makes sense to allow an approximation of __GFP_RETRY_MAYFAIL
and __GFP_NORETRY even if the page table allocation part is much weaker.
This doesn't break the failure mode while it allows for the no OOM
semantic.

[1] https://lore.kernel.org/all/32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com/T/#u

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/vmalloc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..86b912d38bd3 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
  * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
  * GFP_NOFS - memalloc_nofs_save()
  * GFP_NOIO - memalloc_noio_save()
+ * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save() to prevent
+ * OOMs
  *
  * Returns a flag cookie to pair with restore.
  */
@@ -3806,7 +3808,7 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
 {
 	unsigned int flags = 0;
 
-	if (!gfpflags_allow_blocking(gfp_mask))
+	if (!gfpflags_allow_blocking(gfp_mask) || (gfp_mask & (__GFP_RETRY_MAYFAIL|__GFP_NORETRY)))
 		flags = memalloc_noreclaim_save();
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		flags = memalloc_nofs_save();
@@ -3940,7 +3942,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
  */
 #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
-				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
+				__GFP_NOFAIL |  __GFP_ZERO | |\
+				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
 				GFP_USER | __GFP_NOLOCKDEP)
 
@@ -3971,12 +3974,15 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  * virtual range with protection @prot.
  *
  * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
- * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
+ * Zone modifiers are not supported.
  * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
  * by __vmalloc().
  *
- * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
- * and %__GFP_RETRY_MAYFAIL are not supported.
+ * Retry modifiers: only %__GFP_NOFAIL is fully supported;
+ * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
+ * i.e. page tables are allocated with NOWAIT semantic so they might fail
+ * under moderate memory pressure.
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *
-- 
2.53.0

-- 
Michal Hocko
SUSE Labs
