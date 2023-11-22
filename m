Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6274C606
	for <dm-devel@lists.linux.dev>; Wed, 22 Nov 2023 12:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WC8BbURu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700656459; x=1732192459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ugWRVP4P3o4jitdEoqeyd6BAoTW/eKnM8rJuaoKbk3Y=;
  b=WC8BbURuYfc+4CxKHNmCdjTu9eP/MAvry6tO8sydZoBDr+aJ+lVA2JbJ
   jBcEgCwdkLoPg/rzrOaxrAoLHx3LNwmoflwPDrjnBuKGP2g8MZMWXtaTu
   GvdSs3vuBTcmmOVBLDoCn3zma7kP1ZxjT4VXtcz9URdJ7z2Y/9oJBh7Ad
   icCfMiEAEH6nmBNkS8KQU+ti/zzOsfzGqolTBu6Uymq0aw+EHgmNWHoze
   U61MFIB6QhLJy1WgVvF0TjrEuuh3aWFdf8SRuAXymGz9OnAPXcfZxbNOM
   NKoQ28MTxw8dt0A7kdG29hSo5Jk5h8y4C8Tlo7MkNfsEpsQjm/pGQ3Kb5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="391813658"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="391813658"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 04:34:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="1098384927"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="1098384927"
Received: from yadappan-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.221.198])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 04:34:16 -0800
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 8A75510A3DB; Wed, 22 Nov 2023 15:34:13 +0300 (+03)
Date: Wed, 22 Nov 2023 15:34:13 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, agk@redhat.com, bmarzins@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	mpatocka@redhat.com, mpe@ellerman.id.au, snitzer@kernel.org
Subject: Re: [PATCH 1/2] mm, treewide: Introduce NR_PAGE_ORDERS
Message-ID: <20231122123413.y54fmmk65qoxarzg@box.shutemov.name>
References: <20231120221735.k6iyr5t5wdlgpxui@box.shutemov.name>
 <20231121122712.31339-1-kirill.shutemov@linux.intel.com>
 <CAHk-=wiqu14v=RdTYZwF60gpBb0gYdN++u-e-jnqkjEm0m6UdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiqu14v=RdTYZwF60gpBb0gYdN++u-e-jnqkjEm0m6UdA@mail.gmail.com>

On Tue, Nov 21, 2023 at 09:46:57AM -0800, Linus Torvalds wrote:
> On Tue, 21 Nov 2023 at 04:27, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > NR_PAGE_ORDERS defines the number of page orders supported by the page
> > allocator, ranging from 0 to MAX_ORDER, MAX_ORDER + 1 in total.
> >
> > NR_PAGE_ORDERS assists in defining arrays of page orders and allows for
> > more natural iteration over them.
> 
> These two patches look much better to me, but I think you missed one area.
> 
> Most of the Kconfig changes by commit 23baf831a32c ("mm, treewide:
> redefine MAX_ORDER sanely") should also be basically reverted to use
> this new NR_PAGE_ORDERS.

I am not convinced.

Some architectures make this option user-visible and, in my view, user
cares more about the largest page size buddy allocator can provide than
size of the array inside the allocator.

> IOW, I think the ARCH_FORCE_MAX_ORDER #defines etc should also be done
> in "number of page orders". I suspect from a documentation standpoint
> that also makes more sense in places, eg I think that right now your
> patch says
> 
>                         amount of memory for normal system use. The maximum
> -                       possible value is MAX_ORDER/2.  Setting this parameter
> +                       possible value is MAX_PAGE_ORDER/2.  Setting this
> 
> and that's actually nonsensical, because it's NR_PAGE_ORDERS that was
> at least historically the boundary (and historically the one that was
> an even number that can be halved cleanly).

Maybe historically (I didn't check), but not now. It is all over the
place. And it more even in MAX_PAGE_ORDER terms than in NR_PAGE_ORDERS:

arch/arc/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/arc/Kconfig-	int "Maximum zone order"
arch/arc/Kconfig-	default "11" if ARC_HUGEPAGE_16M
arch/arc/Kconfig-	default "10"
--
arch/arm/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/arm/Kconfig-	int "Order of maximal physically contiguous allocations"
arch/arm/Kconfig-	default "11" if SOC_AM33XX
arch/arm/Kconfig-	default "8" if SA1111
arch/arm/Kconfig-	default "10"
--
arch/arm64/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/arm64/Kconfig-	int
arch/arm64/Kconfig-	default "13" if ARM64_64K_PAGES
arch/arm64/Kconfig-	default "11" if ARM64_16K_PAGES
arch/arm64/Kconfig-	default "10"
--
arch/loongarch/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/loongarch/Kconfig-	int "Maximum zone order"
arch/loongarch/Kconfig-	default "13" if PAGE_SIZE_64KB
arch/loongarch/Kconfig-	default "11" if PAGE_SIZE_16KB
arch/loongarch/Kconfig-	default "10"
--
arch/m68k/Kconfig.cpu:config ARCH_FORCE_MAX_ORDER
arch/m68k/Kconfig.cpu-	int "Order of maximal physically contiguous allocations" if ADVANCED
arch/m68k/Kconfig.cpu-	depends on !SINGLE_MEMORY_CHUNK
arch/m68k/Kconfig.cpu-	default "10"
--
arch/mips/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/mips/Kconfig-	int "Maximum zone order"
arch/mips/Kconfig-	default "13" if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_64KB
arch/mips/Kconfig-	default "12" if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_32KB
arch/mips/Kconfig-	default "11" if MIPS_HUGE_TLB_SUPPORT && PAGE_SIZE_16KB
arch/mips/Kconfig-	default "10"
--
arch/nios2/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/nios2/Kconfig-	int "Order of maximal physically contiguous allocations"
arch/nios2/Kconfig-	default "10"
--
arch/powerpc/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/powerpc/Kconfig-	int "Order of maximal physically contiguous allocations"
arch/powerpc/Kconfig-	range 7 8 if PPC64 && PPC_64K_PAGES
arch/powerpc/Kconfig-	default "8" if PPC64 && PPC_64K_PAGES
arch/powerpc/Kconfig-	range 12 12 if PPC64 && !PPC_64K_PAGES
arch/powerpc/Kconfig-	default "12" if PPC64 && !PPC_64K_PAGES
arch/powerpc/Kconfig-	range 8 10 if PPC32 && PPC_16K_PAGES
arch/powerpc/Kconfig-	default "8" if PPC32 && PPC_16K_PAGES
arch/powerpc/Kconfig-	range 6 10 if PPC32 && PPC_64K_PAGES
arch/powerpc/Kconfig-	default "6" if PPC32 && PPC_64K_PAGES
arch/powerpc/Kconfig-	range 4 10 if PPC32 && PPC_256K_PAGES
--
arch/sh/mm/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/sh/mm/Kconfig-	int "Order of maximal physically contiguous allocations"
arch/sh/mm/Kconfig-	default "8" if PAGE_SIZE_16KB
arch/sh/mm/Kconfig-	default "6" if PAGE_SIZE_64KB
arch/sh/mm/Kconfig-	default "13" if !MMU
arch/sh/mm/Kconfig-	default "10"
--
arch/sparc/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/sparc/Kconfig-	int "Order of maximal physically contiguous allocations"
arch/sparc/Kconfig-	default "12"
--
arch/xtensa/Kconfig:config ARCH_FORCE_MAX_ORDER
arch/xtensa/Kconfig-	int "Order of maximal physically contiguous allocations"
arch/xtensa/Kconfig-	default "10"

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
