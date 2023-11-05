Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D605CA50;
	Sun,  5 Nov 2023 06:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P+GH5Q77"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699164874; x=1730700874;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Jjbq2k/FJtvepSLx7QjY7mYNAURCrs0EjeaVl6xff60=;
  b=P+GH5Q774HZt9h63yCtTssS+kL20DCcYr33eKqdACcypNsleAfR0iey6
   X90ZIYdIuO3jcDQ/SUqSx1e17jpM4asTU0+FhA0g4BMvwhJ4GLFZJeGva
   sVyjOtWrFiNfkOBQs0K9QPdHPdhO7Cq0tqKzNlCrJ915Rmtj2sGdUR2L1
   nstWx8xtp7IWYF9DkS2qQTuPmj2PxAqRQmd7zMQsqHP1WgpiEb83rn4ci
   rRcZec2ZoIAl2wJsmnD4aw46r3oHAUTLqNyQaZpEQBiXPk6LOs7a3LmbN
   rJzOvMl6Qf7fwBsiuWQgxgjDrW8mW1EgaF1zAnQpungCTI40RDrC7nl/c
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10884"; a="2033245"
X-IronPort-AV: E=Sophos;i="6.03,278,1694761200"; 
   d="scan'208";a="2033245"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2023 23:14:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10884"; a="711908382"
X-IronPort-AV: E=Sophos;i="6.03,278,1694761200"; 
   d="scan'208";a="711908382"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 04 Nov 2023 23:14:30 -0700
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qzWOy-00056e-2C;
	Sun, 05 Nov 2023 06:14:28 +0000
Date: Sun, 5 Nov 2023 14:14:00 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev
Subject: [device-mapper-dm:dm-vdo-wip 74/90] dm-vdo-target.c:undefined
 reference to `uds_free'
Message-ID: <202311051407.fSklTwr1-lkp@intel.com>
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
commit: 707684671d4e99b82779553afd453cf5062c3001 [74/90] dm vdo memory-alloc: rename uds_free_memory to uds_free
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20231105/202311051407.fSklTwr1-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231105/202311051407.fSklTwr1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311051407.fSklTwr1-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `process_vdo_message':
   dm-vdo-target.c:(.text+0xd2280c5): undefined reference to `vdo_set_compressing'
   ld: dm-vdo-target.c:(.text+0xd22813c): undefined reference to `vdo_message_dedupe_index'
   ld: dm-vdo-target.c:(.text+0xd22815b): undefined reference to `vdo_dump'
   ld: dm-vdo-target.c:(.text+0xd22818f): undefined reference to `vdo_set_compressing'
   ld: dm-vdo-target.c:(.text+0xd2281b4): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd2281ea): undefined reference to `__uds_log_message'
   ld: vmlinux.o: in function `vdo_message':
   dm-vdo-target.c:(.text+0xd2282f8): undefined reference to `uds_register_allocating_thread'
   ld: dm-vdo-target.c:(.text+0xd22830a): undefined reference to `uds_register_thread_device_id'
   ld: dm-vdo-target.c:(.text+0xd228366): undefined reference to `vdo_map_to_system_error'
   ld: dm-vdo-target.c:(.text+0xd228372): undefined reference to `uds_unregister_thread_device_id'
   ld: dm-vdo-target.c:(.text+0xd228377): undefined reference to `uds_unregister_allocating_thread'
   ld: dm-vdo-target.c:(.text+0xd2283c4): undefined reference to `vdo_write_stats'
   ld: dm-vdo-target.c:(.text+0xd2283e8): undefined reference to `__uds_log_message'
   ld: vmlinux.o: in function `vdo_uses_device':
   dm-vdo-target.c:(.text+0xd228464): undefined reference to `vdo_get_backing_device'
   ld: vmlinux.o: in function `vdo_resume':
   dm-vdo-target.c:(.text+0xd2285bd): undefined reference to `uds_register_thread_device_id'
   ld: dm-vdo-target.c:(.text+0xd2285c5): undefined reference to `vdo_get_device_name'
   ld: dm-vdo-target.c:(.text+0xd2285e0): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd2285e5): undefined reference to `uds_unregister_thread_device_id'
   ld: vmlinux.o: in function `finish_operation_callback':
   dm-vdo-target.c:(.text+0xd2286be): undefined reference to `vdo_finish_operation'
   ld: vmlinux.o: in function `release_instance':
   dm-vdo-target.c:(.text+0xd22888c): undefined reference to `uds_assertion_failed'
   ld: dm-vdo-target.c:(.text+0xd2288b8): undefined reference to `uds_assertion_failed'
   ld: vmlinux.o: in function `vdo_presuspend':
   dm-vdo-target.c:(.text+0xd22897c): undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   ld: dm-vdo-target.c:(.text+0xd228988): undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   ld: dm-vdo-target.c:(.text+0xd2289d8): undefined reference to `VDO_ADMIN_STATE_SAVING'
   ld: dm-vdo-target.c:(.text+0xd2289e4): undefined reference to `VDO_ADMIN_STATE_SAVING'
   ld: vmlinux.o: in function `vdo_is_named':
   dm-vdo-target.c:(.text+0xd228a7f): undefined reference to `vdo_get_device_name'
   ld: vmlinux.o: in function `process_one_thread_config_spec':
   dm-vdo-target.c:(.text+0xd228da2): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd228e03): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd228e2a): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd228e51): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd228e78): undefined reference to `__uds_log_message'
   ld: vmlinux.o:dm-vdo-target.c:(.text+0xd228ea2): more undefined references to `__uds_log_message' follow
   ld: vmlinux.o: in function `allocate_instance':
   dm-vdo-target.c:(.text+0xd229016): undefined reference to `uds_reallocate_memory'
   ld: dm-vdo-target.c:(.text+0xd2291e3): undefined reference to `uds_assertion_failed'
   ld: vmlinux.o: in function `free_device_config':
>> dm-vdo-target.c:(.text+0xd2292e9): undefined reference to `uds_free'
>> ld: dm-vdo-target.c:(.text+0xd2292fb): undefined reference to `uds_free'
   ld: dm-vdo-target.c:(.text+0xd229330): undefined reference to `uds_free'
   ld: vmlinux.o: in function `vdo_module_destroy':
   dm-vdo-target.c:(.text+0xd2293e9): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22946f): undefined reference to `uds_free'
   ld: dm-vdo-target.c:(.text+0xd2294af): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd229504): undefined reference to `uds_assertion_failed'
   ld: vmlinux.o: in function `vdo_status':
   dm-vdo-target.c:(.text+0xd229679): undefined reference to `vdo_fetch_statistics'
   ld: dm-vdo-target.c:(.text+0xd2296fe): undefined reference to `vdo_get_compressing'
   ld: dm-vdo-target.c:(.text+0xd229743): undefined reference to `vdo_get_dedupe_index_state_name'
   ld: dm-vdo-target.c:(.text+0xd2297aa): undefined reference to `vdo_get_backing_device'
   ld: vmlinux.o: in function `vdo_map_bio':
   dm-vdo-target.c:(.text+0xd2298e4): undefined reference to `vdo_count_bios'
   ld: dm-vdo-target.c:(.text+0xd22992f): undefined reference to `vdo_launch_flush'
   ld: dm-vdo-target.c:(.text+0xd22995f): undefined reference to `vdo_get_current_work_queue'
   ld: dm-vdo-target.c:(.text+0xd229986): undefined reference to `vdo_launch_bio'
   ld: dm-vdo-target.c:(.text+0xd2299b8): undefined reference to `uds_assertion_failed'
   ld: dm-vdo-target.c:(.text+0xd2299cf): undefined reference to `vdo_get_work_queue_owner'
   ld: vmlinux.o: in function `vdo_dtr':
   dm-vdo-target.c:(.text+0xd229c68): undefined reference to `uds_register_thread_device_id'
   ld: dm-vdo-target.c:(.text+0xd229c74): undefined reference to `uds_register_allocating_thread'
   ld: dm-vdo-target.c:(.text+0xd229c7c): undefined reference to `vdo_get_device_name'
   ld: dm-vdo-target.c:(.text+0xd229c9a): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd229cec): undefined reference to `vdo_destroy'
   ld: dm-vdo-target.c:(.text+0xd229d07): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd229d0c): undefined reference to `uds_unregister_thread_device_id'
   ld: dm-vdo-target.c:(.text+0xd229d11): undefined reference to `uds_unregister_allocating_thread'
   ld: dm-vdo-target.c:(.text+0xd229d3d): undefined reference to `vdo_dump_all'
   ld: vmlinux.o: in function `decode_vdo.constprop.0':
   dm-vdo-target.c:(.text+0xd229e27): undefined reference to `vdo_decode_component_states'
   ld: dm-vdo-target.c:(.text+0xd229e45): undefined reference to `vdo_destroy_component_states'
   ld: dm-vdo-target.c:(.text+0xd229e96): undefined reference to `vdo_set_state'
   ld: dm-vdo-target.c:(.text+0xd229f29): undefined reference to `vdo_validate_component_states'
   ld: dm-vdo-target.c:(.text+0xd22a020): undefined reference to `vdo_get_recovery_journal_length'
   ld: dm-vdo-target.c:(.text+0xd22a066): undefined reference to `vdo_enable_read_only_entry'
   ld: dm-vdo-target.c:(.text+0xd22a095): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22a103): undefined reference to `vdo_decode_recovery_journal'
   ld: dm-vdo-target.c:(.text+0xd22a12e): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22a1c6): undefined reference to `vdo_decode_slab_depot'
   ld: dm-vdo-target.c:(.text+0xd22a26e): undefined reference to `vdo_decode_block_map'
   ld: dm-vdo-target.c:(.text+0xd22a29c): undefined reference to `vdo_make_physical_zones'
   ld: dm-vdo-target.c:(.text+0xd22a2c6): undefined reference to `vdo_make_logical_zones'
   ld: dm-vdo-target.c:(.text+0xd22a2f0): undefined reference to `vdo_make_hash_zones'
   ld: dm-vdo-target.c:(.text+0xd22a31b): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22a36f): undefined reference to `__uds_log_strerror'
   ld: dm-vdo-target.c:(.text+0xd22a399): undefined reference to `__uds_log_strerror'
   ld: vmlinux.o: in function `join_strings.constprop.0':
   dm-vdo-target.c:(.text+0xd22a4bb): undefined reference to `uds_allocate_memory'
   ld: dm-vdo-target.c:(.text+0xd22a518): undefined reference to `uds_append_to_buffer'
   ld: vmlinux.o: in function `perform_admin_operation':
   dm-vdo-target.c:(.text+0xd22a925): undefined reference to `vdo_launch_completion_with_priority'
   ld: dm-vdo-target.c:(.text+0xd22a9f2): undefined reference to `__uds_log_strerror'
   ld: vmlinux.o: in function `apply_new_vdo_configuration':
   dm-vdo-target.c:(.text+0xd22aac1): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22ab17): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22ab93): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22abb2): undefined reference to `vdo_abandon_block_map_growth'
   ld: dm-vdo-target.c:(.text+0xd22ac2d): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22acb9): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22ad19): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22ad2e): undefined reference to `vdo_uninitialize_layout'
   ld: dm-vdo-target.c:(.text+0xd22ad46): undefined reference to `vdo_abandon_new_slabs'
   ld: vmlinux.o: in function `vdo_postsuspend':
   dm-vdo-target.c:(.text+0xd22ae3e): undefined reference to `uds_register_thread_device_id'
   ld: dm-vdo-target.c:(.text+0xd22ae63): undefined reference to `vdo_get_device_name'
   ld: dm-vdo-target.c:(.text+0xd22ae81): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22af02): undefined reference to `__uds_log_strerror'
   ld: dm-vdo-target.c:(.text+0xd22af24): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22af2e): undefined reference to `uds_unregister_thread_device_id'
   ld: dm-vdo-target.c:(.text+0xd22af6c): undefined reference to `vdo_get_admin_state'
   ld: dm-vdo-target.c:(.text+0xd22af92): undefined reference to `__uds_log_message'
   ld: vmlinux.o: in function `prepare_to_grow_physical':
   dm-vdo-target.c:(.text+0xd22b04c): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22b12f): undefined reference to `vdo_uninitialize_layout'
   ld: dm-vdo-target.c:(.text+0xd22b13c): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22b163): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22b187): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22b1c8): undefined reference to `vdo_initialize_layout'
   ld: dm-vdo-target.c:(.text+0xd22b1ef): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22b20c): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22b24a): undefined reference to `vdo_get_known_partition'
   ld: dm-vdo-target.c:(.text+0xd22b268): undefined reference to `vdo_prepare_to_grow_slab_depot'
   ld: dm-vdo-target.c:(.text+0xd22b29a): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22b335): undefined reference to `uds_assertion_failed'
   ld: dm-vdo-target.c:(.text+0xd22b347): undefined reference to `vdo_uninitialize_layout'
   ld: dm-vdo-target.c:(.text+0xd22b35f): undefined reference to `vdo_uninitialize_layout'
   ld: vmlinux.o: in function `prepare_to_modify':
   dm-vdo-target.c:(.text+0xd22b430): undefined reference to `vdo_get_admin_state'
   ld: dm-vdo-target.c:(.text+0xd22b437): undefined reference to `VDO_ADMIN_STATE_PRE_LOADED'
   ld: dm-vdo-target.c:(.text+0xd22b448): undefined reference to `VDO_ADMIN_STATE_PRE_LOADED'
   ld: dm-vdo-target.c:(.text+0xd22b69e): undefined reference to `vdo_get_device_name'
   ld: dm-vdo-target.c:(.text+0xd22b6ea): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22b7a9): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22b7ed): undefined reference to `vdo_prepare_to_grow_block_map'
   ld: dm-vdo-target.c:(.text+0xd22b87b): undefined reference to `__uds_log_message'
   ld: dm-vdo-target.c:(.text+0xd22b9e3): undefined reference to `uds_assertion_failed'
   ld: vmlinux.o: in function `vdo_preresume_registered':
   dm-vdo-target.c:(.text+0xd22baf3): undefined reference to `vdo_get_device_name'
   ld: dm-vdo-target.c:(.text+0xd22bafe): undefined reference to `vdo_get_backing_device'
   ld: dm-vdo-target.c:(.text+0xd22bb67): undefined reference to `vdo_get_admin_state'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
