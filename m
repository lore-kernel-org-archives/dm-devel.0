Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9264409;
	Wed, 22 Nov 2023 01:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iknPA2iI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700617466; x=1732153466;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=oVDrmCWgjC19bPboAFQw1X17VEU/l7u0ewuo8hoqECQ=;
  b=iknPA2iIpeXH4BIclZ27INAMlXlWyccD8X8yK9kYoVTTzGodJsSb6Ryr
   x4rq6SXmpxTYLSgPKlybVMyi1HmpJ1EC8q7viASSnX/5IJnfnV8aCCDf6
   3lq17GZLSc/2VU8dpUJjBKVlXJFWUJws2oTkMoirfg4o8MccDr44cq5VS
   Op3CL/jfLEu596KHfStcyswRRPHFn6o6PV7ENF428lo0Hw+HE9smZKhVU
   HoLog/en45YxqCd3dIPldMROSo3p/Wn0P5PA9kezuqzE7QdGR0yqLVhj4
   NTcUKXjcWduUIfqKZIwtQBUgYtuLtw0mWtkuIEBcZ9Ok4rGC5w7vqKjzg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="395879099"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="395879099"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 17:44:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="716683246"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="716683246"
Received: from lkp-server02.sh.intel.com (HELO b8de5498638e) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 21 Nov 2023 17:44:22 -0800
Received: from kbuild by b8de5498638e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r5cGa-0008VB-1C;
	Wed, 22 Nov 2023 01:43:01 +0000
Date: Wed, 22 Nov 2023 09:41:53 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	"J. corwin Coburn" <corwin@hurlbutnet.net>,
	John Wiele <jwiele@redhat.com>
Subject: [device-mapper-dm:dm-vdo 45/51] ld.lld: error: undefined symbol:
 __uds_log_message
Message-ID: <202311220946.0nYi10v2-lkp@intel.com>
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
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20231122/202311220946.0nYi10v2-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231122/202311220946.0nYi10v2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311220946.0nYi10v2-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __uds_log_message
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_module_destroy)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_module_destroy)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced 50 more times
--
>> ld.lld: error: undefined symbol: uds_free
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_module_destroy)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced 31 more times
--
>> ld.lld: error: undefined symbol: __uds_log_strerror
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_postsuspend)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_preresume)
   >>> referenced 8 more times
--
>> ld.lld: error: undefined symbol: vdo_make
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
--
>> ld.lld: error: undefined symbol: vdo_destroy
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_dtr)
--
>> ld.lld: error: undefined symbol: vdo_prepare_to_grow_block_map
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
--
>> ld.lld: error: undefined symbol: vdo_map_to_system_error
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_preresume)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_message)
--
>> ld.lld: error: undefined symbol: uds_unregister_thread_device_id
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_dtr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_postsuspend)
   >>> referenced 3 more times
--
>> ld.lld: error: undefined symbol: uds_unregister_allocating_thread
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_dtr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_message)
--
>> ld.lld: error: undefined symbol: vdo_get_known_partition
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
   >>> referenced 11 more times
--
>> ld.lld: error: undefined symbol: vdo_prepare_to_grow_slab_depot
   >>> referenced by usercopy_64.c
   >>>               vmlinux.o:(vdo_ctr)
..

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
