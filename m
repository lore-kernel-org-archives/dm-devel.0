Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B565F840;
	Sat,  3 Feb 2024 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706978616; cv=none; b=XxJZIxaQYU9H044vIw1GSoyC4FUVUk4Bsb9wooYbifg98TZAZRkvW4RirRt2g8pPMPG2vqTCjvT8GMtj9n6gERtXehVh3sELRNXEZsld1pgYjBbWI29a1XpiDwD/m/zVWgtGonm2lgyMw+wI/U4xn98qNlBIlb4olo/MJXfNR2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706978616; c=relaxed/simple;
	bh=9PzLQQSd8s2Wyj/yu2/QzkogAnd5eSBXtyP0qulZGkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=e5RwfvswCHwpO0rgT4TL/EYV6HVdhYAHVVyt8rhZM2VmjzJ2tRqsMtvUWdJPMH7CDxDT7tbhKBm8RDpyyPbdtrOdGceRcn7ps+x+F4GYTmU+e2pc4F/nTNOFoLu7stFNvxBbItJz5FrR3O1H26Q/HIh8zSvwHbclLCx9UBPfKZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F0Wgv170; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F0Wgv170"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706978613; x=1738514613;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=9PzLQQSd8s2Wyj/yu2/QzkogAnd5eSBXtyP0qulZGkQ=;
  b=F0Wgv170mnNhQTZNzGVxfKZOxmfrzo4YQ12TfCJvwoc+AlnEtMn//SRi
   I5hXT8mmzFCOqr03+u2/6incMX3/80L7isrElWtgIGNIH1HkPu7bWBXg0
   v0zRVZs5ZJUxnKtZoFRhs10Eu7hBK5B7Q2VWH5LZaysaxV8pPFdqxbOdc
   O1ojWXyEELQbxVwDWz6Bz1bdtJhqWm6dT68w00v4WQXrqP4XaT2mjOSZL
   BkdfSVhyCyNhA2EgPctyh5s/6MOGRx2UhTGheCjf4TzXMCPiZYseMzIKL
   XLpb2JSNs8XdtNnbJm4Eh7Bt1qChJ8D6XBXiRtXcD4r/TJDCXZAAnh/pu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="17740998"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="17740998"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 08:43:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10973"; a="908880269"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="908880269"
Received: from lkp-server02.sh.intel.com (HELO 59f4f4cd5935) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 03 Feb 2024 08:43:30 -0800
Received: from kbuild by 59f4f4cd5935 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rWJ6Z-0005Kc-1F;
	Sat, 03 Feb 2024 16:43:28 +0000
Date: Sun, 4 Feb 2024 00:42:55 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
	Matthew Sakai <msakai@redhat.com>
Subject: [device-mapper-dm:dm-vdo 59/73] drivers/md/dm-vdo/dedupe.c:1211:59:
 sparse: sparse: incorrect type in argument 4 (different base types)
Message-ID: <202402040021.MeVVz1X9-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo
head:   5ef3f52781ac8c3585d19f7ef2ecf9da8ea1b786
commit: f08158dff46c16aac8b2ff6df57fc225fdefe4f9 [59/73] dm vdo: use a proper Makefile for dm-vdo
config: riscv-randconfig-r131-20240203 (https://download.01.org/0day-ci/archive/20240204/202402040021.MeVVz1X9-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20240204/202402040021.MeVVz1X9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402040021.MeVVz1X9-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/md/dm-vdo/dedupe.c:1211:59: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected unsigned int bi_opf @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/dedupe.c:1211:59: sparse:     expected unsigned int bi_opf
   drivers/md/dm-vdo/dedupe.c:1211:59: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/dedupe.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
   drivers/md/dm-vdo/dedupe.c: note: in included file (through drivers/md/dm-vdo/dedupe.h):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   drivers/md/dm-vdo/dedupe.c:2095:13: sparse: sparse: context imbalance in 'close_index' - unexpected unlock
   drivers/md/dm-vdo/dedupe.c:2116:13: sparse: sparse: context imbalance in 'open_index' - unexpected unlock
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
--
>> drivers/md/dm-vdo/block-map.c:70:3: sparse: sparse: symbol 'block_map_tree' was not declared. Should it be static?
>> drivers/md/dm-vdo/block-map.c:789:55: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/block-map.c:789:55: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/block-map.c:789:55: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/block-map.c:1128:79: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/block-map.c:1128:79: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/block-map.c:1128:79: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/block-map.c:1062:65: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/block-map.c:1062:65: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/block-map.c:1062:65: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/block-map.c:1696:46: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/block-map.c:1696:46: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/block-map.c:1696:46: sparse:     got restricted blk_opf_t
>> drivers/md/dm-vdo/block-map.c:1626:47: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/block-map.c:1626:47: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/block-map.c:1626:47: sparse:     got restricted blk_opf_t
>> drivers/md/dm-vdo/block-map.c:1635:27: sparse: sparse: invalid assignment: |=
   drivers/md/dm-vdo/block-map.c:1635:27: sparse:    left side has type unsigned int
   drivers/md/dm-vdo/block-map.c:1635:27: sparse:    right side has type restricted blk_opf_t
   drivers/md/dm-vdo/block-map.c:1886:62: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/block-map.c:1886:62: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/block-map.c:1886:62: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/block-map.c:2621:61: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/block-map.c:2621:61: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/block-map.c:2621:61: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/block-map.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
   drivers/md/dm-vdo/block-map.c: note: in included file (through drivers/md/dm-vdo/block-map.h):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   drivers/md/dm-vdo/block-map.c: note: in included file:
>> drivers/md/dm-vdo/io-submitter.h:44:44: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/io-submitter.h:44:44: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/io-submitter.h:44:44: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/block-map.c: note: in included file (through drivers/md/dm-vdo/block-map.h):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
--
>> drivers/md/dm-vdo/data-vio.c:72:73: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned int static [toplevel] PASSTHROUGH_FLAGS @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/data-vio.c:72:73: sparse:     expected unsigned int static [toplevel] PASSTHROUGH_FLAGS
   drivers/md/dm-vdo/data-vio.c:72:73: sparse:     got restricted blk_opf_t
>> drivers/md/dm-vdo/data-vio.c:1571:52: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected unsigned int bi_opf @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/data-vio.c:1571:52: sparse:     expected unsigned int bi_opf
   drivers/md/dm-vdo/data-vio.c:1571:52: sparse:     got restricted blk_opf_t
>> drivers/md/dm-vdo/data-vio.c:1573:47: sparse: sparse: restricted blk_opf_t degrades to integer
   drivers/md/dm-vdo/data-vio.c:1573:79: sparse: sparse: restricted blk_opf_t degrades to integer
>> drivers/md/dm-vdo/data-vio.c:1580:64: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted blk_opf_t [usertype] opf @@     got int opf @@
   drivers/md/dm-vdo/data-vio.c:1580:64: sparse:     expected restricted blk_opf_t [usertype] opf
   drivers/md/dm-vdo/data-vio.c:1580:64: sparse:     got int opf
   drivers/md/dm-vdo/data-vio.c:1905:52: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected unsigned int bi_opf @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/data-vio.c:1905:52: sparse:     expected unsigned int bi_opf
   drivers/md/dm-vdo/data-vio.c:1905:52: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/data-vio.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
   drivers/md/dm-vdo/data-vio.c: note: in included file (through include/linux/wait.h, include/linux/mempool.h, include/linux/bio.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   drivers/md/dm-vdo/data-vio.c: note: in included file (through drivers/md/dm-vdo/data-vio.h):
   include/linux/bio.h:592:9: sparse: sparse: context imbalance in 'acquire_permit' - unexpected unlock
   drivers/md/dm-vdo/data-vio.c:958:6: sparse: sparse: context imbalance in 'vdo_launch_bio' - different lock contexts for basic block
--
>> drivers/md/dm-vdo/io-submitter.c:353:65: sparse: sparse: restricted blk_opf_t degrades to integer
   drivers/md/dm-vdo/io-submitter.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
--
>> drivers/md/dm-vdo/encodings.c:88:21: sparse: sparse: symbol 'VDO_LAYOUT_HEADER_3_0' was not declared. Should it be static?
   drivers/md/dm-vdo/encodings.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
--
>> drivers/md/dm-vdo/index.c:735:40: sparse: sparse: Using plain integer as NULL pointer
   drivers/md/dm-vdo/index.c:738:31: sparse: sparse: Using plain integer as NULL pointer
   drivers/md/dm-vdo/index.c:740:34: sparse: sparse: Using plain integer as NULL pointer
   drivers/md/dm-vdo/index.c:746:30: sparse: sparse: Using plain integer as NULL pointer
   drivers/md/dm-vdo/index.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
--
>> drivers/md/dm-vdo/packer.c:471:32: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected unsigned int bi_opf @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/packer.c:471:32: sparse:     expected unsigned int bi_opf
   drivers/md/dm-vdo/packer.c:471:32: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/packer.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
   drivers/md/dm-vdo/packer.c: note: in included file (through drivers/md/dm-vdo/packer.h):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
--
>> drivers/md/dm-vdo/recovery-journal.c:37:73: sparse: sparse: mixed bitwiseness
>> drivers/md/dm-vdo/recovery-journal.c:1401:75: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/recovery-journal.c:1401:75: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/recovery-journal.c:1401:75: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/recovery-journal.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
   drivers/md/dm-vdo/recovery-journal.c: note: in included file (through drivers/md/dm-vdo/recovery-journal.h):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   drivers/md/dm-vdo/recovery-journal.c: note: in included file:
>> drivers/md/dm-vdo/io-submitter.h:44:44: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/io-submitter.h:44:44: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/io-submitter.h:44:44: sparse:     got restricted blk_opf_t
--
>> drivers/md/dm-vdo/vio.c:186:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted blk_opf_t [usertype] bi_opf @@     got unsigned int bi_opf @@
   drivers/md/dm-vdo/vio.c:186:21: sparse:     expected restricted blk_opf_t [usertype] bi_opf
   drivers/md/dm-vdo/vio.c:186:21: sparse:     got unsigned int bi_opf
>> drivers/md/dm-vdo/vio.c:201:38: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted blk_opf_t [usertype] opf @@     got unsigned int bi_opf @@
   drivers/md/dm-vdo/vio.c:201:38: sparse:     expected restricted blk_opf_t [usertype] opf
   drivers/md/dm-vdo/vio.c:201:38: sparse:     got unsigned int bi_opf
   drivers/md/dm-vdo/vio.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
   drivers/md/dm-vdo/vio.c: note: in included file (through include/linux/wait.h, include/linux/mempool.h, include/linux/bio.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
--
>> drivers/md/dm-vdo/repair.c:1754:68: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/repair.c:1754:68: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/repair.c:1754:68: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/repair.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
--
>> drivers/md/dm-vdo/vdo.c:298:50: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected unsigned int bi_opf @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/vdo.c:298:50: sparse:     expected unsigned int bi_opf
   drivers/md/dm-vdo/vdo.c:298:50: sparse:     got restricted blk_opf_t
>> drivers/md/dm-vdo/vdo.c:820:33: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/vdo.c:820:33: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/vdo.c:820:33: sparse:     got restricted blk_opf_t
>> drivers/md/dm-vdo/vdo.c:892:53: sparse: sparse: Using plain integer as NULL pointer
   drivers/md/dm-vdo/vdo.c:1034:61: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/vdo.c:1034:61: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/vdo.c:1034:61: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/vdo.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
   drivers/md/dm-vdo/vdo.c: note: in included file (through include/linux/wait.h, include/linux/wait_bit.h, include/linux/fs.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
--
>> drivers/md/dm-vdo/slab-depot.c:343:66: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/slab-depot.c:343:66: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/slab-depot.c:343:66: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c:776:49: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/slab-depot.c:776:49: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/slab-depot.c:776:49: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c:1211:63: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/slab-depot.c:1211:63: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/slab-depot.c:1211:63: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c:2275:33: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/slab-depot.c:2275:33: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/slab-depot.c:2275:33: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c:2482:33: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/slab-depot.c:2482:33: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/slab-depot.c:2482:33: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c:2922:33: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/slab-depot.c:2922:33: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/slab-depot.c:2922:33: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c:4522:33: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/slab-depot.c:4522:33: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/slab-depot.c:4522:33: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c:4563:57: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/slab-depot.c:4563:57: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/slab-depot.c:4563:57: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:242:46: sparse: sparse: self-comparison always evaluates to false
   drivers/md/dm-vdo/slab-depot.c: note: in included file (through include/linux/wait.h, include/linux/wait_bit.h, include/linux/fs.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   drivers/md/dm-vdo/slab-depot.c: note: in included file:
>> drivers/md/dm-vdo/io-submitter.h:44:44: sparse: sparse: incorrect type in argument 5 (different base types) @@     expected unsigned int operation @@     got restricted blk_opf_t @@
   drivers/md/dm-vdo/io-submitter.h:44:44: sparse:     expected unsigned int operation
   drivers/md/dm-vdo/io-submitter.h:44:44: sparse:     got restricted blk_opf_t
   drivers/md/dm-vdo/slab-depot.c: note: in included file (through include/linux/wait.h, include/linux/wait_bit.h, include/linux/fs.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true

vim +1211 drivers/md/dm-vdo/dedupe.c

e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1187  
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1188  /**
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1189   * start_verifying() - Begin the data verification phase.
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1190   * @lock: The hash lock (must be LOCKING).
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1191   * @agent: The data_vio to use to read and compare candidate data.
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1192   *
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1193   * Continue the deduplication path for a hash lock by using the agent to read (and possibly
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1194   * decompress) the data at the candidate duplicate location, comparing it to the data in the agent
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1195   * to verify that the candidate is identical to all the data_vios sharing the hash. If so, it can
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1196   * be deduplicated against, otherwise a data_vio allocation will have to be written to and used for
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1197   * dedupe.
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1198   */
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1199  static void start_verifying(struct hash_lock *lock, struct data_vio *agent)
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1200  {
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1201  	int result;
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1202  	struct vio *vio = &agent->vio;
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1203  	char *buffer = (vdo_is_state_compressed(agent->duplicate.state) ?
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1204  			(char *) agent->compression.block :
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1205  			agent->scratch_block);
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1206  
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1207  	lock->state = VDO_HASH_LOCK_VERIFYING;
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1208  	ASSERT_LOG_ONLY(!lock->verified, "hash lock only verifies advice once");
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1209  
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1210  	agent->last_async_operation = VIO_ASYNC_OP_VERIFY_DUPLICATION;
e043ebf2d9a2f1 Matthew Sakai 2023-11-16 @1211  	result = vio_reset_bio(vio, buffer, verify_endio, REQ_OP_READ,
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1212  			       agent->duplicate.pbn);
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1213  	if (result != VDO_SUCCESS) {
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1214  		set_data_vio_hash_zone_callback(agent, finish_verifying);
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1215  		continue_data_vio_with_error(agent, result);
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1216  		return;
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1217  	}
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1218  
8185b1fe0c084d Mike Snitzer  2023-08-25  1219  	set_data_vio_bio_zone_callback(agent, vdo_submit_vio);
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1220  	vdo_launch_completion_with_priority(&vio->completion, BIO_Q_VERIFY_PRIORITY);
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1221  }
e043ebf2d9a2f1 Matthew Sakai 2023-11-16  1222  

:::::: The code at line 1211 was first introduced by commit
:::::: e043ebf2d9a2f1aaeca0e0e22fbb3505d37e80f2 dm vdo: add hash locks and hash zones

:::::: TO: Matthew Sakai <msakai@redhat.com>
:::::: CC: Mike Snitzer <snitzer@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
