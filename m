Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569A53D3CEB;
	Thu, 18 Jun 2026 10:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781778215; cv=none; b=TUsHb43o1lD0+f0srP8U9mNaOw6WTReLa8fihyFXGQVX32zU3881XFO51w8qmpfEkJXXxpv+crmyc0ZW2OfgQCgEUdlTEO1NemlP75IbhsNDNFwAIbkxWYVMPVjzioFfu+SZbflCdI9gktzahG+83ntdaSEz5p8JHJrT84NiStE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781778215; c=relaxed/simple;
	bh=/5xlT4UPANLHWLwtUNkZonoJrCOL+q5aqrVw4zGGdDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XKMIaDx6lWV3LuKWNQcpmo1HsfBK2Zm2eD9yFZN+IRAXS+Uu+W2PX6Ubqy3ldcLa1cknCweOyYkiaV5Go8PNRDFBnLcgIpsOTxr2FVVulMfAevFKFFmOTXjMNNoJpr/RZyowmaSjA9nFE+bE5BrX4gcfBoWYIhg4VLLFy2m8T6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=McT9Gq9J; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="McT9Gq9J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781778205; x=1813314205;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/5xlT4UPANLHWLwtUNkZonoJrCOL+q5aqrVw4zGGdDQ=;
  b=McT9Gq9J2gBRmF2mF381PjQwqByTGS/v/I1tLI8vKOuvqBV2gB48teRq
   00yR+RleWo+8AyGV8a6+E5FhkoLU+64DGJs5J8p7AUFC5exLUwd/3iwEI
   9MGRiuMDGvmxnFL5gDaU2PfCYubKDwp/tYvrb3zw1+r/+l+nnZ5N+h+B9
   NjdyEIMdHtnGoHijvv0zl2RNwDWttDrs2lhqDvEVd4Ekxsd9V97cqn237
   Prd/qJSVmmL32hlFbDU2QZPg4DM16gCX6nLEI9QbHGQ7Pyi7P+/xEBrLs
   1gH3wunF8DS2AP0ZHfDcPF9gBGFbvVrw/WvrF9XPAs8eQHKUxT6Knroyj
   Q==;
X-CSE-ConnectionGUID: mSnSsoQrRrmg7mO1h6Ni4Q==
X-CSE-MsgGUID: nKJAB42CRr+2/yLGOKwWgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11820"; a="70126180"
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="70126180"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 03:23:23 -0700
X-CSE-ConnectionGUID: qktiaX03RSe2frDZIQqsdQ==
X-CSE-MsgGUID: RIQa1sPlSCOSPSwNz523kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="245396666"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by fmviesa007.fm.intel.com with ESMTP; 18 Jun 2026 03:23:20 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wa9u2-000000005Vd-314y;
	Thu, 18 Jun 2026 10:23:18 +0000
Date: Thu, 18 Jun 2026 12:22:51 +0200
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] block: validate user space vectors during extraction
Message-ID: <202606181254.ohF2ZO9K-lkp@intel.com>
References: <20260617233235.1016063-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617233235.1016063-2-kbusch@meta.com>

Hi Keith,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on brauner-vfs/vfs.all akpm-mm/mm-nonmm-unstable linus/master v7.1 next-20260616]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-validate-user-space-vectors-during-extraction/20260618-073522
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260617233235.1016063-2-kbusch%40meta.com
patch subject: [PATCH 1/1] block: validate user space vectors during extraction
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260618/202606181254.ohF2ZO9K-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260618/202606181254.ohF2ZO9K-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606181254.ohF2ZO9K-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: block/bio.c:1245 function parameter 'vec_align_mask' not described in 'bio_iov_iter_get_pages'
>> Warning: block/bio.c:1245 function parameter 'vec_align_mask' not described in 'bio_iov_iter_get_pages'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
