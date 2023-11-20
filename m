Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52096134B0;
	Mon, 20 Nov 2023 10:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T8n0rpMK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700476352; x=1732012352;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ywRsmRUzuJdLlCTjeuJHtRBSm+sGyVxn8YL3h99U0ZA=;
  b=T8n0rpMKK4WxZl/xHf+dg/v0WNOCk295j4XtLP97tkxO/YtsTH1o3BcX
   OVyuzgFTdEEqRc3T41Nroyl9loBBZ1xDDTByt9GBWnYF1rIQOX2P19QSR
   vzsTjBCumiPeNZHea0v7GAZH46pFfBepPUj04QJVFPWUVgID0qlf6Wb2G
   +3N8Ek6s1xJuD2+ber+wmlD/DuQIt1VJEyHptgzIfiM0VLJ64xovSs0gO
   1CoiLKIkQJi4tXQ/XLb4Pevuu/1bPMkCbkmY6v/QTM9qTnEt/wAzEp9r+
   bXIOa8wZC8fnrTWSMsYz+iwIXXZPpJejj52q+Zj7wyzgL6hvS4NnDkn/Y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="381983093"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="381983093"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 02:32:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="14104664"
Received: from lkp-server02.sh.intel.com (HELO b8de5498638e) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 20 Nov 2023 02:32:30 -0800
Received: from kbuild by b8de5498638e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r51Zq-0006Mf-23;
	Mon, 20 Nov 2023 10:32:26 +0000
Date: Mon, 20 Nov 2023 18:31:54 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	"J. corwin Coburn" <corwin@hurlbutnet.net>,
	John Wiele <jwiele@redhat.com>
Subject: [device-mapper-dm:dm-vdo 45/51] ld.lld: error: undefined symbol:
 vdo_initialize_layout
Message-ID: <202311201808.GSxJeVFR-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo
head:   19b93e634cff09b45c7825804ff65ed4b58b631f
commit: 07ca0024cbfae90b461baa0a4cd0a6081d2cd4bd [45/51] dm vdo: enable configuration and building of dm-vdo
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20231120/202311201808.GSxJeVFR-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231120/202311201808.GSxJeVFR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311201808.GSxJeVFR-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: vdo_initialize_layout
   >>> referenced by dm-vdo-target.c
   >>>               drivers/md/dm-vdo-target.o:(vdo_ctr) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
