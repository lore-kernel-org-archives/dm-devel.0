Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B5618A6A9;
	Tue, 15 Apr 2025 06:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744697853; cv=none; b=utZ53IgOhXOXoQ3/T5CWUltpxjSqI+besRjvXOGvHTHUb1qgXyJSp9eQ+vUR+C64WvJXBRPquY/YEzJ2u6Jxus4G5+4pI4hYksKGIZxw0IERvXX6wPqmvXcpZQBAcSOEpop2SLHwAh3aJ0D5HLzATEcciBQ3mQAyL4Q56I3TRQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744697853; c=relaxed/simple;
	bh=oMp5bg88AhH5U94XDV4HaMSAy3UaGzipazBEuW0fFLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGNXtpnT5j1eR2D+V2CuKz/RT+NLh2PrqBNrZPC6gdSQLmamksq4tFlMJIFpYijwK5MRS6CdyvN54d6Ql3KVGUWLpHyv9PRW2Y8rYL/X0ZMi/YudhSmB01KK6/EskDhaVqNwIZQJcptLDfyagyqamGSWVspoy9tsC86BVk7whcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I8VjnLjj; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I8VjnLjj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744697852; x=1776233852;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oMp5bg88AhH5U94XDV4HaMSAy3UaGzipazBEuW0fFLQ=;
  b=I8VjnLjj3KZFAH6gC5kcZlmTqniRLtYFGssW8bX8fZt4QW9foYdEP0CW
   LDI5qN4DKcbGaPV0w84MW9J0O0GoAtdYLcGpZv9aYoMe1/gMtYutZIxAa
   WIknaKOeGz9lDruTufxs7ImV3qqINXztCVKyJ34gRcuSRIfM7Qlzs5ytV
   26DLPROH9lWltW2KMrKKwUIEC7UnXoc2RD99lztAO/EbUItABVvE7Nyda
   WH/EaWgFGmnu9+53G3HUz2GqxtKMnLh+lizkx6pPo0dXc6slyRzWjQ3Bt
   +8zeVBZ38/AzgR5TI/gTuu3g1sr6bShnVrisDk59OsktvM6GohBRIoCl4
   w==;
X-CSE-ConnectionGUID: mXbkBWFuQc6wRVFaJ/hIpA==
X-CSE-MsgGUID: Nd/2xxyZSouOhIgSBoCw1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="57553653"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="57553653"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 23:17:31 -0700
X-CSE-ConnectionGUID: F3Bjzp7aS8yBT+ylbnfwxA==
X-CSE-MsgGUID: 09qgvQJFTgupxCMA3RiOYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="130349942"
Received: from smile.fi.intel.com ([10.237.72.58])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 23:17:28 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1u4Zbp-0000000CSTC-2I7c;
	Tue, 15 Apr 2025 09:17:25 +0300
Date: Tue, 15 Apr 2025 09:17:25 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] dm table: Fix W=1 build warning when
 mempool_needs_integrity is unused
Message-ID: <Z_359RoIe9TjAWV0@smile.fi.intel.com>
References: <20250407072126.3879086-1-andriy.shevchenko@linux.intel.com>
 <Z_zdwSCfaYDotOI2@smile.fi.intel.com>
 <Z_zd1NCtn_QxaCzC@smile.fi.intel.com>
 <a0b1fcbf-9cda-9da2-ecbe-ac5cbc75b775@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0b1fcbf-9cda-9da2-ecbe-ac5cbc75b775@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Apr 14, 2025 at 02:13:18PM +0200, Mikulas Patocka wrote:
> On Mon, 14 Apr 2025, Andy Shevchenko wrote:
> > On Mon, Apr 14, 2025 at 01:04:49PM +0300, Andy Shevchenko wrote:
> > > On Mon, Apr 07, 2025 at 10:21:26AM +0300, Andy Shevchenko wrote:
> > > > The mempool_needs_integrity is unused. This, in particular, prevents
> > > > kernel builds with Clang, `make W=1` and CONFIG_WERROR=y:
> > > > 
> > > > drivers/md/dm-table.c:1052:7: error: variable 'mempool_needs_integrity' set but not used [-Werror,-Wunused-but-set-variable]
> > > >  1052 |         bool mempool_needs_integrity = t->integrity_supported;
> > > >       |              ^
> > > > 
> > > > Fix this by removing the leftover.
> > > 
> > > This issue is still present in v6.15-rc1.
> > 
> > I meant v6.15-rc2, of course.
> 
> I will send it to Linus (maybe with other changes) before 6.15 comes out.

Thank you!

-- 
With Best Regards,
Andy Shevchenko


