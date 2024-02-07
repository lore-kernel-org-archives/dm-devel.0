Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C429F7E57A;
	Wed,  7 Feb 2024 14:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707316564; cv=none; b=Cv/tX8VC2VNGmQMvn2TPlh85sgFy5sFfX17Umy472fQboTZMWN6cx6LxwoV6dT3OmKjtwEmqrOuTZab+Zv6bUvM2i9CVOQYXcwRlzHr6n6b6MEEZOABBIhFFdnoKM3nIj3mT2xRyTjys6TvHIW8LAK0T4D6epeRPhaTNmiPbhh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707316564; c=relaxed/simple;
	bh=jtSkTs2LDY3fE47Hj8oArTD/Pq1/eKWD+gRWpP+Zi+c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dRV1mUiZcazje4+575JmYlDg7MnTlA9A4dsj6DoHrrFFVwpTP/9IoEdT+OM6CKW9QkSHjkqL67n+lRrpL7z3ESt57Gmfxt/ivblHnOVFV6kFhxqP4duUOWVH9Kdgm342JfIUsI4XjTT++oEc5oorQ0hgvQTN4XhHrIIKb5ZayyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OWw3zLAo; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OWw3zLAo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707316563; x=1738852563;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=jtSkTs2LDY3fE47Hj8oArTD/Pq1/eKWD+gRWpP+Zi+c=;
  b=OWw3zLAo2iFnHBL5W5yLHTN04dwjf+061joO7wNcgDjfHicSCTouVLDO
   4HpxoPnNLZp1/mXRbpLVyo794vlM06/A8HXGUlTF8uBSH/Dx/Y/Llda8F
   ml4BsEFj57SXNl4nfbu6MIQNiBt2MAZ7suc/AonjEv08uumVaMuP8clW/
   j/fG91nxIGcBsEqiCYNfzKCU9s54hzXlClOeydAWQeqvwUEYbjx9uDKg4
   RwPHWnL2YkxREvuoB8A4PVKktK4arUm2ZrH/8FllfeT5PbGn+cMzDOzb8
   izuUu9LF7gibmTVfeR/+SfjcVQKvuRJmhOhYM9mYeaytYtigjOIR+P5hB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="1278009"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="1278009"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 06:36:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="933791570"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="933791570"
Received: from lkp-server01.sh.intel.com (HELO 01f0647817ea) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2024 06:35:58 -0800
Received: from kbuild by 01f0647817ea with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rXj1o-0002iS-0M;
	Wed, 07 Feb 2024 14:35:56 +0000
Date: Wed, 7 Feb 2024 22:35:43 +0800
From: kernel test robot <lkp@intel.com>
To: Susan LeGendre-McGhee <slegendr@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [device-mapper-dm:for-next 83/83]
 drivers/md/dm-vdo/encodings.h:616:28: warning: 'MAXIMUM_VDO_PHYSICAL_BLOCKS'
 defined but not used
Message-ID: <202402072259.v3h88Ogl-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   076f0dbc1ae258e8a872499b84e65bb10aa5c5f3
commit: 076f0dbc1ae258e8a872499b84e65bb10aa5c5f3 [83/83] dm vdo: move encoding constants to encodings.h
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20240207/202402072259.v3h88Ogl-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240207/202402072259.v3h88Ogl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402072259.v3h88Ogl-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/md/dm-vdo/vdo.h:18,
                    from drivers/md/dm-vdo/action-manager.c:15:
>> drivers/md/dm-vdo/encodings.h:616:28: warning: 'MAXIMUM_VDO_PHYSICAL_BLOCKS' defined but not used [-Wunused-const-variable=]
     616 | static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/dm-vdo/encodings.h:613:28: warning: 'MAXIMUM_VDO_LOGICAL_BLOCKS' defined but not used [-Wunused-const-variable=]
     613 | static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/MAXIMUM_VDO_PHYSICAL_BLOCKS +616 drivers/md/dm-vdo/encodings.h

   611	
   612	/** The maximum logical space is 4 petabytes, which is 1 terablock. */
 > 613	static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
   614	
   615	/** The maximum physical space is 256 terabytes, which is 64 gigablocks. */
 > 616	static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
   617	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
