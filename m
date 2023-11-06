Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC21208BD;
	Mon,  6 Nov 2023 13:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FWPgIG88"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699276601; x=1730812601;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2m3oBOKHyXaf9cUQLCxPi4PB5c7O8aw0Hm/vYSP5gPc=;
  b=FWPgIG88wgIQ0DmB8u1NoTczvwAMzDMnTo7ZbK34K1ehZuvJnoD7377R
   ME4zifP4oId4QDMyz9S+NJOVf+6ID1HHYbqsblwwZPc+7yw/FnvidkFB1
   4jiTTQldZ37Ttoqv+VDVhYIAPpF6KTq4W6ODICif43cnd+4T37d46RoBl
   KQsfEFlhNV+Gs/+4t4kXNIytDvMuSnJp/axAVOeGSFqsRma2uKheHwJ2V
   12nxevM3p7oaRwp6xG8SXR9skLSsleN1Uql1HHQQ9Fxvye0AEqs5ycXEX
   RkeiiVoXIf6fQdfQJEzrZhW8ravwc4frs4WeXzxpz2IllbhCAv28AIiKC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10885"; a="374301066"
X-IronPort-AV: E=Sophos;i="6.03,281,1694761200"; 
   d="scan'208";a="374301066"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 05:16:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10885"; a="1009525086"
X-IronPort-AV: E=Sophos;i="6.03,281,1694761200"; 
   d="scan'208";a="1009525086"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 06 Nov 2023 05:16:20 -0800
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qzzSk-0006QS-0b;
	Mon, 06 Nov 2023 13:16:18 +0000
Date: Mon, 6 Nov 2023 21:15:42 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev
Subject: [device-mapper-dm:dm-vdo-wip 74/90]
 dm-vdo-target.c:(.text.free_device_config+0xc0): undefined reference to
 `uds_free'
Message-ID: <202311062016.qPNyLVB1-lkp@intel.com>
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
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20231106/202311062016.qPNyLVB1-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231106/202311062016.qPNyLVB1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311062016.qPNyLVB1-lkp@intel.com/

All errors (new ones prefixed by >>):

   powerpc64-linux-ld: warning: discarding dynamic section .glink
   powerpc64-linux-ld: warning: discarding dynamic section .plt
   powerpc64-linux-ld: linkage table error against `vdo_abandon_block_map_growth'
   powerpc64-linux-ld: stubs don't match calculated size
   powerpc64-linux-ld: can not build stubs: bad value
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `process_vdo_message':
   dm-vdo-target.c:(.text.process_vdo_message+0xb0): undefined reference to `vdo_dump'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_vdo_message+0x23c): undefined reference to `vdo_message_dedupe_index'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_vdo_message+0x37c): undefined reference to `vdo_set_compressing'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_vdo_message+0x3d8): undefined reference to `vdo_set_compressing'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_vdo_message+0x404): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_vdo_message+0x430): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_message':
   dm-vdo-target.c:(.text.vdo_message+0x9c): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_message+0xe0): undefined reference to `uds_register_allocating_thread'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_message+0xf0): undefined reference to `uds_register_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_message+0x16c): undefined reference to `vdo_write_stats'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_message+0x19c): undefined reference to `vdo_map_to_system_error'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_message+0x1b0): undefined reference to `uds_unregister_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_message+0x1b8): undefined reference to `uds_unregister_allocating_thread'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_uses_device':
   dm-vdo-target.c:(.text.vdo_uses_device+0x44): undefined reference to `vdo_get_backing_device'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_resume':
   dm-vdo-target.c:(.text.vdo_resume+0x70): undefined reference to `uds_register_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_resume+0x7c): undefined reference to `vdo_get_device_name'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_resume+0x9c): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_resume+0xa4): undefined reference to `uds_unregister_thread_device_id'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `release_instance':
   dm-vdo-target.c:(.text.release_instance+0xc4): undefined reference to `uds_assertion_failed'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.release_instance+0x15c): undefined reference to `uds_assertion_failed'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `finish_operation_callback':
   dm-vdo-target.c:(.text.finish_operation_callback+0x60): undefined reference to `vdo_finish_operation'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x0): undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x8): undefined reference to `VDO_ADMIN_STATE_SAVING'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x10): undefined reference to `VDO_ADMIN_STATE_PRE_LOADED'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x18): undefined reference to `VDO_ADMIN_STATE_STOPPING'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x20): undefined reference to `VDO_ADMIN_STATE_PRE_LOADING'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x28): undefined reference to `VDO_ADMIN_STATE_SUSPENDED_OPERATION'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x30): undefined reference to `VDO_ADMIN_STATE_RESUMING'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x38): undefined reference to `VDO_ADMIN_STATE_LOADING'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x40): undefined reference to `vdo_directory_type'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:(.toc+0x48): undefined reference to `VDO_ADMIN_STATE_FORMATTING'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_is_named':
   dm-vdo-target.c:(.text.vdo_is_named+0x60): undefined reference to `vdo_get_device_name'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `process_one_thread_config_spec':
   dm-vdo-target.c:(.text.process_one_thread_config_spec+0xb8): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_one_thread_config_spec+0x110): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_one_thread_config_spec+0x1b8): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_one_thread_config_spec+0x278): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.process_one_thread_config_spec+0x2f4): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:dm-vdo-target.c:(.text.process_one_thread_config_spec+0x3d4): more undefined references to `__uds_log_message' follow
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `allocate_instance':
   dm-vdo-target.c:(.text.allocate_instance+0x104): undefined reference to `uds_reallocate_memory'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.allocate_instance+0x25c): undefined reference to `uds_assertion_failed'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `free_device_config':
>> dm-vdo-target.c:(.text.free_device_config+0xc0): undefined reference to `uds_free'
>> powerpc64-linux-ld: dm-vdo-target.c:(.text.free_device_config+0xd8): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.free_device_config+0xf8): undefined reference to `uds_free'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_module_destroy':
   dm-vdo-target.c:(.text.vdo_module_destroy+0x58): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_module_destroy+0x164): undefined reference to `uds_assertion_failed'
>> powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_module_destroy+0x18c): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_module_destroy+0x1bc): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_init':
   dm-vdo-target.c:(.init.text+0x44): undefined reference to `uds_initialize_thread_device_registry'
   powerpc64-linux-ld: dm-vdo-target.c:(.init.text+0x4c): undefined reference to `uds_memory_init'
   powerpc64-linux-ld: dm-vdo-target.c:(.init.text+0x54): undefined reference to `uds_init_sysfs'
   powerpc64-linux-ld: dm-vdo-target.c:(.init.text+0x5c): undefined reference to `vdo_initialize_device_registry_once'
   powerpc64-linux-ld: dm-vdo-target.c:(.init.text+0x7c): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.init.text+0x84): undefined reference to `vdo_register_status_codes'
   powerpc64-linux-ld: dm-vdo-target.c:(.init.text+0xc8): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.init.text+0x134): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_status':
   dm-vdo-target.c:(.text.vdo_status+0xc4): undefined reference to `vdo_fetch_statistics'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_status+0x108): undefined reference to `vdo_get_backing_device'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_status+0x1b4): undefined reference to `vdo_get_dedupe_index_state_name'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_status+0x1c4): undefined reference to `vdo_get_compressing'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_map_bio':
   dm-vdo-target.c:(.text.vdo_map_bio+0x128): undefined reference to `uds_assertion_failed'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_map_bio+0x140): undefined reference to `vdo_count_bios'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_map_bio+0x1a8): undefined reference to `vdo_launch_flush'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_map_bio+0x1cc): undefined reference to `vdo_get_current_work_queue'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_map_bio+0x1e8): undefined reference to `vdo_get_work_queue_owner'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_map_bio+0x22c): undefined reference to `vdo_launch_bio'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_dtr':
   dm-vdo-target.c:(.text.vdo_dtr+0x1a0): undefined reference to `uds_register_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_dtr+0x1b0): undefined reference to `uds_register_allocating_thread'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_dtr+0x1bc): undefined reference to `vdo_get_device_name'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_dtr+0x1dc): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_dtr+0x268): undefined reference to `vdo_dump_all'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_dtr+0x27c): undefined reference to `vdo_destroy'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_dtr+0x298): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_dtr+0x2a0): undefined reference to `uds_unregister_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_dtr+0x2a8): undefined reference to `uds_unregister_allocating_thread'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `decode_vdo.constprop.0':
   dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x7c): undefined reference to `vdo_decode_component_states'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0xd4): undefined reference to `vdo_set_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x158): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x1c8): undefined reference to `vdo_validate_component_states'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x2a0): undefined reference to `vdo_get_recovery_journal_length'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x2e4): undefined reference to `vdo_destroy_component_states'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x318): undefined reference to `__uds_log_strerror'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x370): undefined reference to `__uds_log_strerror'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x39c): undefined reference to `vdo_enable_read_only_entry'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x3dc): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x43c): undefined reference to `vdo_decode_recovery_journal'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x474): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x4bc): undefined reference to `vdo_decode_slab_depot'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x56c): undefined reference to `vdo_decode_block_map'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x5a4): undefined reference to `vdo_make_physical_zones'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x5dc): undefined reference to `vdo_make_logical_zones'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.decode_vdo.constprop.0+0x614): undefined reference to `vdo_make_hash_zones'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `join_strings.constprop.0':
   dm-vdo-target.c:(.text.join_strings.constprop.0+0xfc): undefined reference to `uds_allocate_memory'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.join_strings.constprop.0+0x17c): undefined reference to `uds_append_to_buffer'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `perform_admin_operation':
   dm-vdo-target.c:(.text.perform_admin_operation+0xec): undefined reference to `__uds_log_strerror'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.perform_admin_operation+0x1fc): undefined reference to `vdo_launch_completion_with_priority'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `apply_new_vdo_configuration':
   dm-vdo-target.c:(.text.apply_new_vdo_configuration+0xb0): undefined reference to `vdo_abandon_block_map_growth'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.apply_new_vdo_configuration+0xe4): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.apply_new_vdo_configuration+0x190): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.apply_new_vdo_configuration+0x1c0): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.apply_new_vdo_configuration+0x24c): undefined reference to `vdo_uninitialize_layout'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.apply_new_vdo_configuration+0x264): undefined reference to `vdo_abandon_new_slabs'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.apply_new_vdo_configuration+0x284): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.apply_new_vdo_configuration+0x370): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.apply_new_vdo_configuration+0x3a8): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_postsuspend':
   dm-vdo-target.c:(.text.vdo_postsuspend+0x84): undefined reference to `uds_register_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_postsuspend+0xac): undefined reference to `vdo_get_device_name'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_postsuspend+0xcc): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_postsuspend+0x130): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_postsuspend+0x18c): undefined reference to `vdo_get_admin_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_postsuspend+0x1b4): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_postsuspend+0x1e0): undefined reference to `__uds_log_strerror'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_postsuspend+0x1f0): undefined reference to `uds_unregister_thread_device_id'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `prepare_to_grow_physical':
   dm-vdo-target.c:(.text.prepare_to_grow_physical+0x7c): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0xc0): undefined reference to `uds_assertion_failed'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x198): undefined reference to `vdo_uninitialize_layout'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x1b8): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x1dc): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x200): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x230): undefined reference to `vdo_initialize_layout'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x300): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x324): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x370): undefined reference to `vdo_uninitialize_layout'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x3ec): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x3fc): undefined reference to `vdo_prepare_to_grow_slab_depot'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x430): undefined reference to `vdo_uninitialize_layout'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_grow_physical+0x458): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `prepare_to_modify':
   dm-vdo-target.c:(.text.prepare_to_modify+0x70): undefined reference to `vdo_get_admin_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_modify+0x4a0): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_modify+0x4f4): undefined reference to `uds_assertion_failed'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_modify+0x52c): undefined reference to `vdo_prepare_to_grow_block_map'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_modify+0x598): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_modify+0x75c): undefined reference to `vdo_get_device_name'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.prepare_to_modify+0x7b4): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_preresume_registered':
   dm-vdo-target.c:(.text.vdo_preresume_registered+0x64): undefined reference to `vdo_get_device_name'
--
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_logical_callback+0x440): undefined reference to `vdo_enter_read_only_mode'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_logical_callback+0x460): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_logical_callback+0x498): undefined reference to `vdo_finish_operation'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `handle_logical_growth_error':
   dm-vdo-target.c:(.text.handle_logical_growth_error+0xc0): undefined reference to `vdo_abandon_block_map_growth'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `assert_admin_phase_thread':
   dm-vdo-target.c:(.text.assert_admin_phase_thread+0x58): undefined reference to `vdo_get_callback_thread_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.assert_admin_phase_thread+0x1b0): undefined reference to `uds_assertion_failed'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `grow_physical_callback':
   dm-vdo-target.c:(.text.grow_physical_callback+0x17c): undefined reference to `vdo_is_read_only'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x1c4): undefined reference to `__uds_log_strerror'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x1d4): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x204): undefined reference to `vdo_start_operation'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x238): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x248): undefined reference to `vdo_launch_completion_with_priority'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x2b0): undefined reference to `vdo_uninitialize_layout'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x34c): undefined reference to `vdo_update_slab_depot_size'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x35c): undefined reference to `vdo_save_components'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x38c): undefined reference to `vdo_use_new_slabs'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x3b4): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x3f8): undefined reference to `vdo_get_known_partition'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x460): undefined reference to `vdo_enter_read_only_mode'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x480): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x494): undefined reference to `vdo_uninitialize_layout'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.grow_physical_callback+0x4c0): undefined reference to `vdo_finish_operation'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `resume_callback':
   dm-vdo-target.c:(.text.resume_callback+0x1b4): undefined reference to `vdo_start_operation'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x20c): undefined reference to `vdo_get_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x270): undefined reference to `vdo_set_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x280): undefined reference to `vdo_save_components'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x2a0): undefined reference to `vdo_launch_completion_with_priority'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x2bc): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x2cc): undefined reference to `vdo_launch_completion_with_priority'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x2ec): undefined reference to `vdo_allow_read_only_mode_entry'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x31c): undefined reference to `vdo_resume_hash_zones'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x34c): undefined reference to `vdo_resume_slab_depot'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x37c): undefined reference to `vdo_resume_recovery_journal'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x3ac): undefined reference to `vdo_resume_block_map'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x3dc): undefined reference to `vdo_resume_logical_zones'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x3fc): undefined reference to `vdo_get_compressing'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x504): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x520): undefined reference to `vdo_resume_packer'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x54c): undefined reference to `vdo_resume_flusher'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x57c): undefined reference to `resume_data_vio_pool'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x598): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.resume_callback+0x5cc): undefined reference to `vdo_finish_operation'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `suspend_callback':
   dm-vdo-target.c:(.text.suspend_callback+0x25c): undefined reference to `vdo_start_operation'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x27c): undefined reference to `vdo_in_read_only_mode'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x2b0): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x2d4): undefined reference to `vdo_drain_packer'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x2fc): undefined reference to `drain_data_vio_pool'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x32c): undefined reference to `vdo_drain_hash_zones'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x35c): undefined reference to `vdo_drain_flusher'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x37c): undefined reference to `vdo_synchronous_flush'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x3b0): undefined reference to `vdo_enter_read_only_mode'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x3e8): undefined reference to `vdo_drain_logical_zones'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x430): undefined reference to `vdo_drain_block_map'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x470): undefined reference to `vdo_drain_recovery_journal'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x4b0): undefined reference to `vdo_drain_slab_depot'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x4cc): undefined reference to `vdo_wait_until_not_entering_read_only_mode'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x564): undefined reference to `vdo_get_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x5b0): undefined reference to `vdo_set_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x5d4): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x5e4): undefined reference to `vdo_launch_completion_with_priority'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x600): undefined reference to `vdo_save_components'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x61c): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.suspend_callback+0x654): undefined reference to `vdo_finish_operation'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `load_callback':
   dm-vdo-target.c:(.text.load_callback+0x1b4): undefined reference to `vdo_start_operation'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x230): undefined reference to `vdo_open_recovery_journal'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x23c): undefined reference to `vdo_allow_read_only_mode_entry'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x338): undefined reference to `vdo_add_dedupe_index_sysfs'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x368): undefined reference to `vdo_add_sysfs_stats_dir'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x384): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x394): undefined reference to `vdo_launch_completion_with_priority'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x3ac): undefined reference to `vdo_is_read_only'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x3e0): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x3fc): undefined reference to `vdo_get_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x43c): undefined reference to `vdo_repair'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x4f8): undefined reference to `vdo_load_slab_depot'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x520): undefined reference to `vdo_set_state'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x530): undefined reference to `vdo_save_components'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x56c): undefined reference to `vdo_initialize_block_map_from_journal'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x654): undefined reference to `vdo_prepare_slab_depot_to_allocate'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x6c0): undefined reference to `vdo_enter_recovery_mode'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x6e4): undefined reference to `vdo_scrub_all_unrecovered_slabs'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x84c): undefined reference to `vdo_start_dedupe_index'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x8b8): undefined reference to `vdo_drain_recovery_journal'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x904): undefined reference to `vdo_wait_until_not_entering_read_only_mode'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x920): undefined reference to `vdo_set_completion_result'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.load_callback+0x954): undefined reference to `vdo_finish_operation'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `handle_load_error':
   dm-vdo-target.c:(.text.handle_load_error+0x64): undefined reference to `vdo_requeue_completion_if_needed'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.handle_load_error+0x144): undefined reference to `__uds_log_strerror'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.handle_load_error+0x1a0): undefined reference to `__uds_log_strerror'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.handle_load_error+0x1d0): undefined reference to `vdo_enter_read_only_mode'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `split_string':
   dm-vdo-target.c:(.text.split_string+0x13c): undefined reference to `uds_allocate_memory'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.split_string+0x224): undefined reference to `uds_allocate_memory'
>> powerpc64-linux-ld: dm-vdo-target.c:(.text.split_string+0x28c): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.split_string+0x2c4): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.split_string+0x440): undefined reference to `uds_allocate_memory'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.split_string+0x4a8): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.split_string+0x4d4): undefined reference to `uds_free'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `parse_optional_arguments.isra.0':
   dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x244): undefined reference to `__uds_log_message'
>> powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x274): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x2b4): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x34c): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x37c): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x3a4): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x440): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x484): undefined reference to `uds_free'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x4e8): undefined reference to `uds_free'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o:dm-vdo-target.c:(.text.parse_optional_arguments.isra.0+0x534): more undefined references to `uds_free' follow
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `parse_device_config':
   dm-vdo-target.c:(.text.parse_device_config+0x150): undefined reference to `uds_allocate_memory'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_device_config+0x2f4): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_device_config+0x564): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_device_config+0x57c): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_device_config+0x67c): undefined reference to `uds_duplicate_string'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.parse_device_config+0xe78): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `construct_new_vdo':
   dm-vdo-target.c:(.text.construct_new_vdo+0xb4): undefined reference to `uds_register_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.construct_new_vdo+0x130): undefined reference to `__uds_log_strerror'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.construct_new_vdo+0x1ac): undefined reference to `vdo_map_to_system_error'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.construct_new_vdo+0x1c0): undefined reference to `uds_unregister_thread_device_id'
   powerpc64-linux-ld: drivers/md/dm-vdo-target.o: in function `vdo_ctr':
   dm-vdo-target.c:(.text.vdo_ctr+0x64): undefined reference to `uds_register_allocating_thread'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_ctr+0x70): undefined reference to `vdo_get_device_name'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_ctr+0x88): undefined reference to `vdo_find_matching'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_ctr+0xd0): undefined reference to `uds_register_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_ctr+0x128): undefined reference to `__uds_log_message'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_ctr+0x178): undefined reference to `vdo_map_to_system_error'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_ctr+0x1c8): undefined reference to `uds_unregister_thread_device_id'
   powerpc64-linux-ld: dm-vdo-target.c:(.text.vdo_ctr+0x1d8): undefined reference to `uds_unregister_allocating_thread'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
