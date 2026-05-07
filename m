Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3FD35AC03;
	Thu,  7 May 2026 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778138708; cv=none; b=eS3bQBUJyJZ6yQ3kVtU+c8zxTCZLRJDln1T6tGicNTZkfV4qqQPvQkymKBle/gV9ZJOUt1Ev5b1kESYwJpEcfxsMA7BBkxImOugCQVENhVEWJHFxyCgRB9wMWwlludUwY1l4RyKl/Wb3bDXQTyR6FjlW7BkBRA8fYeDvxND9FKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778138708; c=relaxed/simple;
	bh=zclqlV5QhGZ0KdhGwcRGdbFD4PL+dk12thE5Ltq1F8g=;
	h=Date:From:To:Cc:Subject:Message-ID; b=NEIx5iqi7nHfhk+PWvJTjCo0cJVcdPgvX3lIBdBi8oHEqOe3hfkgq2Tjx1zczE3b+eWzEAtKHBmMfNRF79gZrrL/9v+x79MqDFSqBU5zryVbDn2dZCCQzL0XQnFYu2VAx+hql4DvI6ria8vk2iWWT60VcWct5NljHiAnCwJtG3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FSx/JTby; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FSx/JTby"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778138702; x=1809674702;
  h=date:from:to:cc:subject:message-id;
  bh=zclqlV5QhGZ0KdhGwcRGdbFD4PL+dk12thE5Ltq1F8g=;
  b=FSx/JTbyKaDORfdQYLX5UE34zGj+6xlN4Q9PHlFJh1RBDPHkCoKk0yl1
   HlLbKbG4yDoUZJSd+EeaaItbsUgtB64SJ3pviSHK2lu3YBjJn3cfnvvrn
   tYk58pTJfKuLp01s5vqnYcJfM118DxvnBcNPIfmZpgrQ73+wqXVTrw5/Z
   kBlqaZ9ZajblqT50FraDVPXpYfhcWdKCxNoNqvAB2XQ6FFXEPE7+k40rG
   3kCkma8qNjHRbwTbG7YCa8NhnhNXEE3c1tn4vhX3nzjs2Bb+HhvUDiald
   6MUH8SGXC/cIdOOiY2MdfCkw+k+a9w2qkBIiaTdGdHjFMM32FXenEWB4Z
   A==;
X-CSE-ConnectionGUID: pe4ZxoLsTP6tfzRDl+1ZRQ==
X-CSE-MsgGUID: IedgkzPBT82lAE6sddXsrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="89777446"
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="89777446"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 00:24:55 -0700
X-CSE-ConnectionGUID: dmJ1X76YR4yQDtKpxwqFog==
X-CSE-MsgGUID: +jZf4HkuRpGwkW9NUAkm5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="235394596"
Received: from lkp-server01.sh.intel.com (HELO 8365ac1094ea) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 07 May 2026 00:24:53 -0700
Received: from kbuild by 8365ac1094ea with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wKt6I-00000000061-1ACz;
	Thu, 07 May 2026 07:24:50 +0000
Date: Thu, 07 May 2026 15:24:38 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Biggers <ebiggers@google.com>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
 Mikulas Patocka <mpatocka@redhat.com>,
 Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Subject: [device-mapper-dm:for-next 14/15] Warning:
 drivers/md/dm-inlinecrypt.c:47 struct member 'key_size' not described in
 'inlinecrypt_ctx'
Message-ID: <202605071534.rxF5Bw5W-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

Hi Eric,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   b4a0774bd7fd859c1d243be0919c8df39eac20c0
commit: 753450f716417f53759c91b5bb7b96563379a719 [14/15] dm-inlinecrypt: add target for inline block device encryption
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20260507/202605071534.rxF5Bw5W-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260507/202605071534.rxF5Bw5W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605071534.rxF5Bw5W-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/md/dm-inlinecrypt.c:47 struct member 'key_size' not described in 'inlinecrypt_ctx'
>> Warning: drivers/md/dm-inlinecrypt.c:47 struct member 'key_size' not described in 'inlinecrypt_ctx'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
