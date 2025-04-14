Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B719B25E804;
	Mon, 14 Apr 2025 10:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744625117; cv=none; b=O7h0M/aK9O1Qtm4StlykdkQbR6vm00Ki/EBa0fyGg4cfdUlmtkKvl0WTSs5ztzpLKy3rILRKjvoUGlsVVcqTt+xjfjNwCmyX0sOEujPNC0WxGN9c+GzG9FYn8qdjJPxLeweFQSXRZ9pXuoF0gsGzSXLDBEETBeVP6heKiB5WaRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744625117; c=relaxed/simple;
	bh=uqgYg2BJtBzuQ9/dVXr1lqIyh/Q6T+Jizhlw2pSZ5MA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrWRxuFt27TN9+Wu8dMYIqfR2D+OX1rqhnmRcYSeAbQUft6TqXhlNOJEjwjY/mAYu/wCKDldqF+fWFp/nMGsHLAXzMFIGDzSLUW9GivWrR8m59z/LuhdXsFrSjaVJPmUtH6CM9eo7vXw9wJS8C/KhfPNv+IG4MhiruIIHc58UKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KHMr2TnZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KHMr2TnZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744625116; x=1776161116;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uqgYg2BJtBzuQ9/dVXr1lqIyh/Q6T+Jizhlw2pSZ5MA=;
  b=KHMr2TnZEYfMoUb1LEDin00up/Q7d2jo/pap6gS640NmaT9+2+b6HNz/
   OlDPlP1MzqMm6DhcdRHfy499IAb0kMm6QSYpPAqyYKPXKygkeIeBxD2cm
   O00wou43H0uudV2vUkRPJc0VyQzAopnU3amv+luyVBM4de7cKmTxPgKTe
   eG+fyWtgEpsqjwMhDYTn3QBIgABMExR0QiBIJjVyMdTuoPl3Hi0zU+FnU
   Kc3ataIgcZS3zt+fq3SZKEZ0kXvSYLeX1z6xXfPH3ZumzgBjz3H0dH9Su
   yCX/MYPHjcdIrGHVw8NGV++P+NZzMP0mJBPX4CeiLTUKcg+88tzwfRycv
   w==;
X-CSE-ConnectionGUID: OU6E12qzRuqhetZTFvHeKA==
X-CSE-MsgGUID: 8xwYvPs9RPeN8JwFf+ObLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="46218517"
X-IronPort-AV: E=Sophos;i="6.15,212,1739865600"; 
   d="scan'208";a="46218517"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 03:05:14 -0700
X-CSE-ConnectionGUID: uzpaVyvgRWiYIaniGAG/8A==
X-CSE-MsgGUID: RG0eWEDiReePF5ugEMqixA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,212,1739865600"; 
   d="scan'208";a="160731476"
Received: from smile.fi.intel.com ([10.237.72.58])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 03:05:12 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1u4Gge-0000000CCZf-2GWA;
	Mon, 14 Apr 2025 13:05:08 +0300
Date: Mon, 14 Apr 2025 13:05:08 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] dm table: Fix W=1 build warning when
 mempool_needs_integrity is unused
Message-ID: <Z_zd1NCtn_QxaCzC@smile.fi.intel.com>
References: <20250407072126.3879086-1-andriy.shevchenko@linux.intel.com>
 <Z_zdwSCfaYDotOI2@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_zdwSCfaYDotOI2@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Apr 14, 2025 at 01:04:49PM +0300, Andy Shevchenko wrote:
> On Mon, Apr 07, 2025 at 10:21:26AM +0300, Andy Shevchenko wrote:
> > The mempool_needs_integrity is unused. This, in particular, prevents
> > kernel builds with Clang, `make W=1` and CONFIG_WERROR=y:
> > 
> > drivers/md/dm-table.c:1052:7: error: variable 'mempool_needs_integrity' set but not used [-Werror,-Wunused-but-set-variable]
> >  1052 |         bool mempool_needs_integrity = t->integrity_supported;
> >       |              ^
> > 
> > Fix this by removing the leftover.
> 
> This issue is still present in v6.15-rc1.

I meant v6.15-rc2, of course.

-- 
With Best Regards,
Andy Shevchenko


