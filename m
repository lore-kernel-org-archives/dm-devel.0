Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B540B20FE;
	Sun,  5 Nov 2023 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sp2fTHyy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699174907; x=1730710907;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4kuPnkOWqIaHsGNQLfGMR1SzyRM7sFtC+ycon3pMk7M=;
  b=Sp2fTHyyPXrD0R5kVM42a99kOYyDbKENBFyOeYBCIkwPW2DySQ13zC8l
   uZsRK3+O1NeymlN9TbiUj1DVu2mA2Wpk9h59gOenHQ3lNX6nsdF9LHz8f
   zwtwL26Ln8nb7vIQs0RRMAvElqJ15TR97qLp5l6eXuc55t/GWGrw23RGp
   JSWKStKC0dVD5tWjHcUkoJPoStCbiG+OFbnt1ErTyPpTiBxzfO5KIpYku
   rvkheR5Ef5z2ZkmjNE0lODAQDZDG+CpYOTMAdjd/RSi5jzSzcyNckk8xV
   urwcmZvcYs2CDyuNusNhWnsNyergByVLsfpTPMSy0//3RK+nbybXyll1w
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10884"; a="392001313"
X-IronPort-AV: E=Sophos;i="6.03,278,1694761200"; 
   d="scan'208";a="392001313"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2023 01:01:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10884"; a="755575702"
X-IronPort-AV: E=Sophos;i="6.03,278,1694761200"; 
   d="scan'208";a="755575702"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 05 Nov 2023 01:01:45 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qzZ0o-0005EQ-3B;
	Sun, 05 Nov 2023 09:01:42 +0000
Date: Sun, 5 Nov 2023 17:01:01 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev
Subject: [device-mapper-dm:dm-vdo-wip 74/90] aarch64-linux-ld:
 dm-vdo-target.c:undefined reference to `uds_free'
Message-ID: <202311051642.f2ECCH3V-lkp@intel.com>
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
commit: e8b8b9da5b385af7d01e88b230a22ac402b27b9f [74/90] dm vdo memory-alloc: rename uds_free_memory to uds_free
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20231105/202311051642.f2ECCH3V-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231105/202311051642.f2ECCH3V-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311051642.f2ECCH3V-lkp@intel.com/

All errors (new ones prefixed by >>):

   aarch64-linux-ld: Unexpected GOT/PLT entries detected!
   aarch64-linux-ld: Unexpected run-time procedure linkages detected!
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_uses_device':
   dm-vdo-target.c:(.text+0x280): undefined reference to `vdo_get_backing_device'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_resume':
   dm-vdo-target.c:(.text+0x368): undefined reference to `uds_register_thread_device_id'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x370): undefined reference to `vdo_get_device_name'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x38c): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x390): undefined reference to `uds_unregister_thread_device_id'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `finish_operation_callback':
   dm-vdo-target.c:(.text+0x454): undefined reference to `vdo_finish_operation'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `release_instance':
   dm-vdo-target.c:(.text+0x560): undefined reference to `uds_assertion_failed'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x5d4): undefined reference to `uds_assertion_failed'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_presuspend':
   dm-vdo-target.c:(.text+0x6d4): undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `VDO_ADMIN_STATE_SUSPENDING' which may bind externally can not be used when making a shared object; recompile with -fPIC
   dm-vdo-target.c:(.text+0x6d4): dangerous relocation: unsupported relocation
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x6dc): undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x6e4): undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x6ec): undefined reference to `VDO_ADMIN_STATE_SAVING'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `VDO_ADMIN_STATE_SAVING' which may bind externally can not be used when making a shared object; recompile with -fPIC
   dm-vdo-target.c:(.text+0x6ec): dangerous relocation: unsupported relocation
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x6f4): undefined reference to `VDO_ADMIN_STATE_SAVING'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x6fc): undefined reference to `VDO_ADMIN_STATE_SAVING'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_is_named':
   dm-vdo-target.c:(.text+0x7d4): undefined reference to `vdo_get_device_name'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `process_one_thread_config_spec':
   dm-vdo-target.c:(.text+0x8d4): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x910): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x98c): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0xa0c): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0xa64): undefined reference to `__uds_log_message'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o:dm-vdo-target.c:(.text+0xb00): more undefined references to `__uds_log_message' follow
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `allocate_instance':
   dm-vdo-target.c:(.text+0xd1c): undefined reference to `uds_reallocate_memory'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0xe08): undefined reference to `uds_assertion_failed'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `free_device_config':
   dm-vdo-target.c:(.text+0xf84): undefined reference to `uds_free'
>> aarch64-linux-ld: dm-vdo-target.c:(.text+0xf94): undefined reference to `uds_free'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0xfac): undefined reference to `uds_free'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_module_destroy':
   dm-vdo-target.c:(.text+0x1058): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1108): undefined reference to `uds_assertion_failed'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x111c): undefined reference to `uds_free'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1140): undefined reference to `__uds_log_message'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_status':
   dm-vdo-target.c:(.text+0x122c): undefined reference to `vdo_fetch_statistics'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1254): undefined reference to `vdo_get_backing_device'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x12d4): undefined reference to `vdo_get_dedupe_index_state_name'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x12e0): undefined reference to `vdo_get_compressing'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_map_bio':
   dm-vdo-target.c:(.text+0x1524): undefined reference to `uds_assertion_failed'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1534): undefined reference to `vdo_count_bios'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1568): undefined reference to `vdo_launch_flush'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x158c): undefined reference to `vdo_get_current_work_queue'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x15a0): undefined reference to `vdo_get_work_queue_owner'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x15e4): undefined reference to `vdo_launch_bio'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_dtr':
   dm-vdo-target.c:(.text+0x1774): undefined reference to `uds_register_thread_device_id'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1780): undefined reference to `uds_register_allocating_thread'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x178c): undefined reference to `vdo_get_device_name'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x17a8): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1810): undefined reference to `vdo_dump_all'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x181c): undefined reference to `vdo_destroy'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1834): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1838): undefined reference to `uds_unregister_thread_device_id'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x183c): undefined reference to `uds_unregister_allocating_thread'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `decode_vdo.constprop.0':
   dm-vdo-target.c:(.text+0x1968): undefined reference to `vdo_decode_component_states'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x19a4): undefined reference to `vdo_set_state'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1a10): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1a68): undefined reference to `vdo_validate_component_states'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1b04): undefined reference to `vdo_get_recovery_journal_length'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1b3c): undefined reference to `vdo_destroy_component_states'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1b68): undefined reference to `__uds_log_strerror'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1bb0): undefined reference to `__uds_log_strerror'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1bcc): undefined reference to `vdo_enable_read_only_entry'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1bf4): undefined reference to `vdo_get_known_partition'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1c4c): undefined reference to `vdo_decode_recovery_journal'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1c70): undefined reference to `vdo_get_known_partition'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1cb4): undefined reference to `vdo_decode_slab_depot'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1d38): undefined reference to `vdo_decode_block_map'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1d5c): undefined reference to `vdo_make_physical_zones'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1d80): undefined reference to `vdo_make_logical_zones'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1da4): undefined reference to `vdo_make_hash_zones'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `join_strings.constprop.0':
   dm-vdo-target.c:(.text+0x1f08): undefined reference to `uds_allocate_memory'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x1f64): undefined reference to `uds_append_to_buffer'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `process_vdo_message':
   dm-vdo-target.c:(.text+0x2110): undefined reference to `vdo_dump'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2224): undefined reference to `vdo_message_dedupe_index'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2334): undefined reference to `vdo_set_compressing'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2370): undefined reference to `vdo_set_compressing'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2394): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x23b8): undefined reference to `__uds_log_message'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_message':
   dm-vdo-target.c:(.text+0x24cc): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x24f8): undefined reference to `uds_register_allocating_thread'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2504): undefined reference to `uds_register_thread_device_id'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x255c): undefined reference to `vdo_write_stats'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2578): undefined reference to `vdo_map_to_system_error'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2584): undefined reference to `uds_unregister_thread_device_id'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2588): undefined reference to `uds_unregister_allocating_thread'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `copy_partition':
   dm-vdo-target.c:(.text+0x29ac): undefined reference to `vdo_get_known_partition'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x29bc): undefined reference to `vdo_get_known_partition'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x29e8): undefined reference to `vdo_get_backing_device'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2a4c): undefined reference to `vdo_get_backing_device'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `parse_key_value_pairs':
   dm-vdo-target.c:(.text+0x2d6c): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2dd8): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2e24): undefined reference to `__uds_log_message'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `copy_callback':
   dm-vdo-target.c:(.text+0x2fbc): undefined reference to `vdo_set_completion_result'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x2fc8): undefined reference to `vdo_launch_completion_with_priority'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `perform_admin_operation':
   dm-vdo-target.c:(.text+0x30e8): undefined reference to `__uds_log_strerror'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x31bc): undefined reference to `vdo_launch_completion_with_priority'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `apply_new_vdo_configuration':
   dm-vdo-target.c:(.text+0x330c): undefined reference to `vdo_abandon_block_map_growth'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x3334): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x33bc): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x33dc): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x3440): undefined reference to `vdo_uninitialize_layout'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x3450): undefined reference to `vdo_abandon_new_slabs'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x3468): undefined reference to `vdo_get_known_partition'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x351c): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x3548): undefined reference to `__uds_log_message'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_postsuspend':
   dm-vdo-target.c:(.text+0x3634): undefined reference to `uds_register_thread_device_id'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x3650): undefined reference to `vdo_get_device_name'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x366c): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x36bc): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x36fc): undefined reference to `vdo_get_admin_state'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x371c): undefined reference to `__uds_log_message'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x3740): undefined reference to `__uds_log_strerror'
   aarch64-linux-ld: dm-vdo-target.c:(.text+0x3748): undefined reference to `uds_unregister_thread_device_id'
   aarch64-linux-ld: drivers/md/dm-vdo-target.o: in function `prepare_to_grow_physical':
   dm-vdo-target.c:(.text+0x382c): undefined reference to `__uds_log_message'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
