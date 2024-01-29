Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA7853803;
	Mon, 29 Jan 2024 23:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706572223; cv=none; b=RVqr59/6Mc9vbBFjkL+npH9i7kJsWbjarhR/G/ixFfmcAAIgcpzbXy4O15Q/DTgm0n4t84Y4ck3WA62+KCsp9PKr02rLe6PyjFj6WXZqWhkJt+aJpFzAT8OpkV0CiPUyDqxIcLzC41rmu2J68saMTKPSUlLG1sWM+HYJhQvLmz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706572223; c=relaxed/simple;
	bh=RytXXKcv0IxFeJkn4nM5nL9FjqFAoyustJPJPowNz04=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=D1wvOHNDnQ+OorrXkZdVfYffmhsva8X8qlnsN27THrXy+DFteOpgTaXzHn0k6/gKbcT7/fcpIInhhu1LVArGN2Po8o+H++zEPyCpW7DAlSt+r4I3kJISibtZMHPJWAppfCI9Mi8FgZXuorlyqv4eIUMrSlouc/9kRKClUyggo2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hr8qDwWd; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hr8qDwWd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706572221; x=1738108221;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=RytXXKcv0IxFeJkn4nM5nL9FjqFAoyustJPJPowNz04=;
  b=Hr8qDwWdWwwUq+M1iogKmpu4KnjIGp5BzIIyg5pfwgW7jBmkLNey6EPn
   KAE5AHJHRQslY22Bbpv6PqbZ68rrzLioBNWgTI43dELXxAX45uaz3cZS+
   uh4gXZqU3Wl9CgS8lgyJ7U+uVhC8W6OdkWcR/ZKpkw3LG5oI7E2G1euSt
   QpPg5DxysDXPeTF55nkugd+rgaHGkmD0Gut++vTaUIox1flF6XKJ6gsEp
   5ZBrYqFwGC3unjTTiIpb2uFeOtp2aGvteR2+xq0qWqc2HOsiNGxSgXM9q
   zrdyXABMZA8d4yBeknX05NfD2WImcQnT5SJf7w3NmetMhlNamJ1YfTWiy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="400260448"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="400260448"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 15:50:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="737576914"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="737576914"
Received: from lkp-server01.sh.intel.com (HELO 370188f8dc87) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 29 Jan 2024 15:50:18 -0800
Received: from kbuild by 370188f8dc87 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rUbOJ-0004iY-2X;
	Mon, 29 Jan 2024 23:50:15 +0000
Date: Tue, 30 Jan 2024 07:49:29 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev
Subject: [device-mapper-dm:dm-vdo-wip 73/78]
 drivers/md/dm-vdo/constants.h:100:28: warning:
 'MINIMUM_VDO_SLAB_JOURNAL_BLOCKS' defined but not used
Message-ID: <202401300735.kFp2omKb-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo-wip
head:   4047b38a6b9963fea70002e5547dae1cb02914f7
commit: 6e748cc6e193caaada6a4350a91882b5dbaaa635 [73/78] dm vdo: fix sparse warnings about missing statics
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20240130/202401300735.kFp2omKb-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240130/202401300735.kFp2omKb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401300735.kFp2omKb-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/md/dm-vdo/encodings.h:17,
                    from drivers/md/dm-vdo/vdo.h:18,
                    from drivers/md/dm-vdo/action-manager.c:15:
>> drivers/md/dm-vdo/constants.h:100:28: warning: 'MINIMUM_VDO_SLAB_JOURNAL_BLOCKS' defined but not used [-Wunused-const-variable=]
     100 | static const block_count_t MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2;
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/dm-vdo/constants.h:97:28: warning: 'MAXIMUM_VDO_PHYSICAL_BLOCKS' defined but not used [-Wunused-const-variable=]
      97 | static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/dm-vdo/constants.h:94:28: warning: 'MAXIMUM_VDO_LOGICAL_BLOCKS' defined but not used [-Wunused-const-variable=]
      94 | static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from drivers/md/dm-vdo/encodings.h:17,
                    from drivers/md/dm-vdo/vdo.h:18,
                    from drivers/md/dm-vdo/vdo.c:30:
>> drivers/md/dm-vdo/constants.h:100:28: warning: 'MINIMUM_VDO_SLAB_JOURNAL_BLOCKS' defined but not used [-Wunused-const-variable=]
     100 | static const block_count_t MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2;
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/dm-vdo/constants.h:97:28: warning: 'MAXIMUM_VDO_PHYSICAL_BLOCKS' defined but not used [-Wunused-const-variable=]
      97 | static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/dm-vdo/constants.h:94:28: warning: 'MAXIMUM_VDO_LOGICAL_BLOCKS' defined but not used [-Wunused-const-variable=]
      94 | static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/dm-vdo/vdo.c: In function 'vdo_make':
   drivers/md/dm-vdo/vdo.c:566:19: warning: '%s' directive output may be truncated writing up to 55 bytes into a region of size 16 [-Wformat-truncation=]
     566 |                  "%s%u", MODULE_NAME, instance);
         |                   ^~
   drivers/md/dm-vdo/vdo.c:565:9: note: 'snprintf' output between 2 and 66 bytes into a destination of size 16
     565 |         snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     566 |                  "%s%u", MODULE_NAME, instance);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/MINIMUM_VDO_SLAB_JOURNAL_BLOCKS +100 drivers/md/dm-vdo/constants.h

    92	
    93	/** The maximum logical space is 4 petabytes, which is 1 terablock. */
  > 94	static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
    95	
    96	/** The maximum physical space is 256 terabytes, which is 64 gigablocks. */
  > 97	static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
    98	
    99	/** unit test minimum */
 > 100	static const block_count_t MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2;
   101	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
