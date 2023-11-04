Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007167FF;
	Sat,  4 Nov 2023 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddxa9QFh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699061720; x=1730597720;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=HO9ri4RNcBoGPK0I002fM1jI9+holzkbb4AZZWxaZwE=;
  b=ddxa9QFhZZKq4X4+DfO4DRyrci++qHNsHKLhzNhka2NxZlPAYs23FCsj
   r5pvXZdvTRd6cDHm6/KnCQobzlh3au3bWS/lvsmZl6GhOJzFX5WHEgJA8
   7dPvL1JqFbSWKCxv031dZouHi8pbTAzZMmzejuzf2Z0N3LLsUazDtbEdm
   H6qu4Y0mcGRVHFcnkssNSWd9Xr6qBsWeNLspwIRKtz6qXluS0EhYysV6d
   Y65F5dPY09YrquCk0xUXSNcdDIlm8nuNS1qgZeBsP0/iyzbp3ufN+/fCS
   +MlqtCIl3DvsFyx/s7jmqy/8Sdecq6PEJ3yDiMLaDEP8WCNMktRi3o9oq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10883"; a="392941136"
X-IronPort-AV: E=Sophos;i="6.03,275,1694761200"; 
   d="scan'208";a="392941136"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2023 18:35:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10883"; a="711683498"
X-IronPort-AV: E=Sophos;i="6.03,275,1694761200"; 
   d="scan'208";a="711683498"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 03 Nov 2023 18:35:17 -0700
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qz5ZC-0003Bo-3C;
	Sat, 04 Nov 2023 01:35:14 +0000
Date: Sat, 4 Nov 2023 09:34:55 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	"J. corwin Coburn" <corwin@hurlbutnet.net>,
	linux-doc@vger.kernel.org
Subject: [device-mapper-dm:dm-vdo-wip 17/90] htmldocs:
 Documentation/admin-guide/device-mapper/vdo.rst: WARNING: document isn't
 included in any toctree
Message-ID: <202311040953.rWGbDuls-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo-wip
head:   295f5e2cde5fe5db8cfcf2eef7674a7b5e85c279
commit: 31d6568e294e51ef7c3338bb773b1aef0d050682 [17/90] dm: add documentation for dm-vdo target
reproduce: (https://download.01.org/0day-ci/archive/20231104/202311040953.rWGbDuls-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311040953.rWGbDuls-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/admin-guide/device-mapper/vdo.rst: WARNING: document isn't included in any toctree
>> Documentation/admin-guide/device-mapper/vdo-design.rst: WARNING: document isn't included in any toctree

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
