Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9943261696;
	Thu, 14 Dec 2023 17:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UB0wxzJ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702573388; x=1734109388;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=0VMewdynpRXGZAjrpufLqhuWZ7NyTYnlt0fJDM7o47M=;
  b=UB0wxzJ/TK4sK2/Dc/y6FHWqjzH52F8ji0deSrpQb8s/TIWmGxCGSp2e
   PLC/ZJ5/CoE9O0UN0Hz1mUcrqDrzY5iz/zczwd+sy8PsnrLp/ezfJsDSp
   MjC0bTA2e4oSLtPQP6CAKwvvTD6rpWu79D5wyoj5pv8nhRu29Gx4uqcsE
   Y/+rpymKkYIq853veG7EnoAo8tVdNoNAKroFlFl7zlRMT0wRcogR3eR42
   H90J/AF9jym/Mgo1sbDAIssrdc6vMXmETBX9OYw8qFsmRWGqB0M/o68Xf
   5aGP3YVM415rAWz4ram/smEuufJhKwfp24kNTKzYbBuV8lMMxZ4LC52sg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="2306570"
X-IronPort-AV: E=Sophos;i="6.04,276,1695711600"; 
   d="scan'208";a="2306570"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 09:03:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="947638809"
X-IronPort-AV: E=Sophos;i="6.04,276,1695711600"; 
   d="scan'208";a="947638809"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 14 Dec 2023 09:03:05 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rDp71-000MMu-0s;
	Thu, 14 Dec 2023 17:03:03 +0000
Date: Fri, 15 Dec 2023 01:01:30 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev
Subject: [device-mapper-dm:dm-vdo-wip 61/61]
 drivers/md/dm-vdo/action-manager.c:64: warning: Excess struct member
 'Scheduler' description in 'action_manager'
Message-ID: <202312150044.hPIyz3eh-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mike,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo-wip
head:   e64f626707d0a0b2908bf0d47705d755ada6fd2d
commit: e64f626707d0a0b2908bf0d47705d755ada6fd2d [61/61] dm vdo: use a proper Makefile for dm-vdo
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20231215/202312150044.hPIyz3eh-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231215/202312150044.hPIyz3eh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312150044.hPIyz3eh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/md/dm-vdo/action-manager.c:64: warning: Function parameter or member 'scheduler' not described in 'action_manager'
>> drivers/md/dm-vdo/action-manager.c:64: warning: Excess struct member 'Scheduler' description in 'action_manager'


vim +64 drivers/md/dm-vdo/action-manager.c

dcbcd2b05e60cfe Matthew Sakai 2023-11-16  38  
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  39  /**
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  40   * struct action_manager - Definition of an action manager.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  41   * @completion: The completion for performing actions.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  42   * @state: The state of this action manager.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  43   * @actions: The two action slots.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  44   * @current_action: The current action slot.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  45   * @zones: The number of zones in which an action is to be applied.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  46   * @Scheduler: A function to schedule a default next action.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  47   * @get_zone_thread_id: A function to get the id of the thread on which to apply an action to a
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  48   *                      zone.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  49   * @initiator_thread_id: The ID of the thread on which actions may be initiated.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  50   * @context: Opaque data associated with this action manager.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  51   * @acting_zone: The zone currently being acted upon.
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  52   */
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  53  struct action_manager {
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  54  	struct vdo_completion completion;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  55  	struct admin_state state;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  56  	struct action actions[2];
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  57  	struct action *current_action;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  58  	zone_count_t zones;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  59  	vdo_action_scheduler_fn scheduler;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  60  	vdo_zone_thread_getter_fn get_zone_thread_id;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  61  	thread_id_t initiator_thread_id;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  62  	void *context;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  63  	zone_count_t acting_zone;
dcbcd2b05e60cfe Matthew Sakai 2023-11-16 @64  };
dcbcd2b05e60cfe Matthew Sakai 2023-11-16  65  

:::::: The code at line 64 was first introduced by commit
:::::: dcbcd2b05e60cfead83f389a2585e78f45491d56 dm vdo: add administrative state and action manager

:::::: TO: Matthew Sakai <msakai@redhat.com>
:::::: CC: Mike Snitzer <snitzer@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
