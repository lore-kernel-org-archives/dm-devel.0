Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDA239EF0A;
	Mon, 22 Jun 2026 10:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782122742; cv=none; b=kuiq7wTFD/Xo8+dJyGidwN0zTkHy0i41HMJuPZBOElczd2IOxRDCKNM1/ZuzzdKBwY5Ec5HspVmA6nufiRb+6cYj5X6ZX0irFa0IBOcrkWV+7lndJhYxWdfHUsMqSZqtYpv6/XEH9v+QHOe2pkFlGjGvJF0KxEqrDnGSaxeZXvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782122742; c=relaxed/simple;
	bh=nqTroF4J47nY3tPhzkmB5OpCW/Dk71QEXK0tFUWGcNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZCVurdvj63w+W0Q8M+KNv9TFJmepNT0DdFNDWFoL412g0RqO7FtQjvbZUi+LaDdTAik+BS+D8PZh6bhqa8op7IFoJfOkM+J/DUsXKn+ygyu3trjXBYeqtmlxNDAqwkCRN5S1mBu8t4pMZFPGu5GbF+nxgnHlKfHrH4rY/84aUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RimdCaev; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RimdCaev"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782122741; x=1813658741;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nqTroF4J47nY3tPhzkmB5OpCW/Dk71QEXK0tFUWGcNY=;
  b=RimdCaevE+ZlLqrKpmkD4kDwWT4W+VraySB+qzfpS2/TebThrfYtW+kJ
   BhE64cgBDaUH5f1sbO4Bu1EO2aXoIIehDuYl/jVdCbdnoAjKZCpxZ45Yq
   A4GKIZ84QgaDJsbGYJIH1jil7I9lG41xZfz2xhiiKoQqhyo58xsHQby1y
   TRyFiIl5ImhSn++MkVw3XmctG+NJPQaQ6hYIcxPFP7st2C89twX/hXeNd
   pf12v1Q8A9ILTFnZ5nZlK+5/WMnyZtV0c87/RqR8R17j6Eu9Zy2fYrdpF
   nJ2l5MVylGRtuv4uGnrbm3gpZsiqB+RSzeCvX2o3pg7CQdbI83Q+C76lT
   w==;
X-CSE-ConnectionGUID: MU4dY03gTTK2T7jmk0bydg==
X-CSE-MsgGUID: /6lhP8AiR02NCMLz4Yv0tQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="93964354"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="93964354"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 03:05:40 -0700
X-CSE-ConnectionGUID: RdqI0EhBTsCMnTHVKuanrA==
X-CSE-MsgGUID: UqubVdIhRneuRBvcpY88HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="244831900"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 22 Jun 2026 03:05:37 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wbbWw-000000000xd-2RFE;
	Mon, 22 Jun 2026 10:05:28 +0000
Date: Mon, 22 Jun 2026 18:05:22 +0800
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev, hch@lst.de,
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk, Keith Busch <kbusch@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] block: validate user space vectors during extraction
Message-ID: <202606221846.H7g3giF8-lkp@intel.com>
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
[also build test WARNING on brauner-vfs/vfs.all akpm-mm/mm-nonmm-unstable linus/master v7.1 next-20260619]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-validate-user-space-vectors-during-extraction/20260618-073522
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260617233235.1016063-2-kbusch%40meta.com
patch subject: [PATCH 1/1] block: validate user space vectors during extraction
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20260622/202606221846.H7g3giF8-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260622/202606221846.H7g3giF8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606221846.H7g3giF8-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: block/bio.c:1245 function parameter 'vec_align_mask' not described in 'bio_iov_iter_get_pages'
>> Warning: block/bio.c:1245 function parameter 'vec_align_mask' not described in 'bio_iov_iter_get_pages'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
