Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E492339B491
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 15:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771948300; cv=none; b=hfxoOgZ6YWJaIdIBt61hmXgbNCO3rg3tal8fPBMmd8ipNfit9L4pPYAfbubYI5jnFYj+vkgHMMxRAxilSeEHe+2EvEBEDScwTbPF3kWnjfcXKu9xCv71IFoTYuU8GqzDlz+kAWEY4/5Cs2TYzLFrhq2OiH5hNPkg4/fkquMA1Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771948300; c=relaxed/simple;
	bh=s18Ts/2ngyCDmD8No0YZTtHC3gqgzGQ+CCk3m/HSUdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzJW9xts1w9yxyiFxZ0WVEnvjY822/miEj89Drv0Iauvw6dOpSyRGvirA77LIjSHAbjyYthyiAdS4VjKt4OvHMC/5NEkNQRPNBZnA0SvupU2FiDdhXua2JwZUV1zzEMB+vdA0SPjf63vao0vdb049QPAgMNWqKDQ6QUrofANwSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ffo5kYiP; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ffo5kYiP"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so54694765e9.1
        for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 07:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771948297; x=1772553097; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5ETdepbMQNUMnuhr2VD2neSs42BrkDotrEf8tSgUw0=;
        b=Ffo5kYiPK/IQ+T5IgPXenQBDZNeoj6UcQ1vwrcb/GrllDPaFxyLiwdDjjjK7ScMgOv
         5gXxhqOPOcXNLMRJ9xAmIym+oba0aC8C7lYjztktGKYi8mkWGEXCQ+iMWb6yg8dsoVEt
         d1EiJIGMV9FcgWF0D5MBmeQoZv0kOElGOFvaVHYNHMkts4gfJq9POihrqRYkUlWoVNc5
         Biqc4/vspvYq9YxagCYulR8Y13aksflL/ne4iJ9VBzyfd8Qb2osB5QyxiqaJ2dDjFzXC
         6CJO80D9e/vW91Ad0p07Oy6z3EsrZFIOgAzHU8q/ayerfOgBFc0eFDQnvEbU8T7hOTYT
         o3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771948297; x=1772553097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z5ETdepbMQNUMnuhr2VD2neSs42BrkDotrEf8tSgUw0=;
        b=JXCT+249RrIoiCvBTJ/RwaNcreG+qRcGTE5HU7liiESTX4+EhQm+iVEaPVl6AZcXOL
         rKvu+grkF48PlWEd7Eu96SGJhO822d8nSFjKr5SJyBVGHgGe3R0RRXcFS4DEOwjg4Yjm
         t2A2jSdgp7D2J2uC7CLjMBx2aFYGBJ14dehIkHCLSnscjvBKSWj6p3rMCMkCkjDoYvlS
         IYEZeFF6Pi+Je1q9l7Kdtc0yA5pPy+EOZIXd6h1J9UVT1V5qLyoa1waCZKcEG+hltjc2
         bQBo56EWPI+vIbn7s1352lLQh4X5MF5GWUQW87m1Q/CNw6TBbbGb3i/GMaiQ3wjaZ6Tw
         W2PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK8cKI9Np5CMvLL9sS4RNEvwdVEb9SPet37Tuq/Pz/z/D+4m8g9bzLCypT4nH2GrK3E9rR+CYaww==@lists.linux.dev
X-Gm-Message-State: AOJu0YyG1vhi835hN1VWF1xFEKh/uTV4jjkhDZ6goVprnxiHx0PM+T9e
	KfzoFZ5+bjgSNGT+U/bWIXlF1DXx8EJUuVsJCZtO5N5xzy6j28DIEO/0wOfZADdMPpI=
X-Gm-Gg: AZuq6aI2gRUpY5BO8G+kf3ACbMcJhit3V27V3MydS3Lk+Li9zqa4ccJeNZ/vAPcoFhv
	ui4pbEld0dJ8vGhkNPNXBEmK7SJvl1oZF3vuoWgc3+zqLep/s2cINZXb01k4HJIVDxx27eqrP99
	JDAuPSRLB41GrifjbIJy7vG9gbPZ02eCfMWTUJ8SSuA2ghSYYFDY+1QBX7+dSNNg2E8c6nScDxj
	haGw9gRw2+3fZnO8ZXGxrcvCYflM3FTbHouNH16SIOtnqSdwt6VYJkaXXvdIkyIy1qRpvr1OuIs
	Djc+ZtMJ4vtn0w+x6kkONBnYLZFIC03l1pm4tnIM9Sf4OLr9F/6aqaBcdNhxkm/BpTL3esKB++9
	7K3XVNSaljAfc4ZAL1C0PpU2VlwWv6t0UtrizddqPOTd+8FrtVCnFhpyWFg/9Kwahp/cuP3OiKO
	OKCsiGd7locfx7hCdYNFHkuc9YUajAmH4=
X-Received: by 2002:a05:600c:468d:b0:480:7162:fa48 with SMTP id 5b1f17b1804b1-483a95c8f2dmr230149145e9.13.1771948297024;
        Tue, 24 Feb 2026 07:51:37 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d54760sm27459593f8f.35.2026.02.24.07.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:51:36 -0800 (PST)
Date: Tue, 24 Feb 2026 16:51:35 +0100
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
Message-ID: <aZ3JB5Xm3SCmJW95@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3HaVuIA4Ezu1uY@tiehlicka>

On Tue 24-02-26 16:44:43, Michal Hocko wrote:
> On Tue 24-02-26 16:38:01, Uladzislau Rezki wrote:
[...]
> > I do not have a strong opinion about workaround you noted. Maybe Mikulas
> > can switch to NOWAIT flag instead.
> 
> using NOWAIT for the full vmalloc allocation would be just too easy to
> fail under moderate memory pressure.
> 
> The real question is whether we want to provide some sort of backoff
> early but not way too easily allocation semantic for vmalloc. If yes we
> need to get creative in the vmalloc internals rather than expect callers
> to be working around that on their side. History has proven that this
> just leads to tech. dept and more work later on.

Just to make sure we are on the same page I mean something like this 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..791366fe44e2 100644
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
Michal Hocko
SUSE Labs
