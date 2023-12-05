Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420E16A35A;
	Tue,  5 Dec 2023 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nOQeCOjJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701799694; x=1733335694;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ERKvdm5yifo9oxvUSA9gEQUcdOjfku6TJyBq1cElm6c=;
  b=nOQeCOjJxRpEYekiBRcpet02YnyJqa+UUbLibbwEGgW5wwm2Kq26C2by
   csL8CL2PyNnHElrEe+7hfSYg7ZjmP/+rg1/YNS1JQ7hv0f5QZ3/LoSzDL
   J7fkbApr3QPTPHWD350laKEiyAbP7VwEijCzSi7oQcTJv/inhJe9kVknb
   A5Qu8vGuY/dEF7UNgW6ml2sU25jsMU0Q6+kNlFfl7tS67ipStI66ihY2r
   OXviYnlooZsdDf2XPWaMvXhyzu4xxU3GNSHR9SC7VDID5J39X0FbJee0d
   Lw3dmLN5Tl57MKMDlkPrfzTq+TjvguUEz82/h2WMQ9FNZRJM9lELW/mKQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="391100978"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="391100978"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 10:08:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="889024037"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="889024037"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 05 Dec 2023 10:08:10 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rAZq3-0009VU-1s;
	Tue, 05 Dec 2023 18:08:07 +0000
Date: Wed, 6 Dec 2023 02:07:41 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	"J. corwin Coburn" <corwin@hurlbutnet.net>,
	John Wiele <jwiele@redhat.com>
Subject: [device-mapper-dm:dm-vdo-wip 40/55] drivers/md/dm-vdo-target.c:2889:
 undefined reference to `__uds_log_message'
Message-ID: <202312060134.mGNJWfnZ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo-wip
head:   875cbb267383021281c440186fe790d726914274
commit: a867dd502e380601dc85e6eb0ad45fcfa8448c98 [40/55] dm vdo: enable configuration and building of dm-vdo
config: x86_64-randconfig-161-20231203 (https://download.01.org/0day-ci/archive/20231206/202312060134.mGNJWfnZ-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231206/202312060134.mGNJWfnZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312060134.mGNJWfnZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/md/dm-vdo-target.o: in function `vdo_module_destroy':
>> drivers/md/dm-vdo-target.c:2889: undefined reference to `__uds_log_message'
>> ld: drivers/md/dm-vdo-target.c:2897: undefined reference to `uds_free'
>> ld: drivers/md/dm-vdo-target.c:2894: undefined reference to `uds_assertion_failed'
   ld: drivers/md/dm-vdo-target.o: in function `process_vdo_message_locked':
>> drivers/md/dm-vdo-target.c:1037: undefined reference to `vdo_set_compressing'
>> ld: drivers/md/dm-vdo-target.c:1032: undefined reference to `vdo_set_compressing'
>> ld: drivers/md/dm-vdo-target.c:1046: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:1041: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_message':
>> drivers/md/dm-vdo-target.c:1108: undefined reference to `uds_register_allocating_thread'
>> ld: drivers/md/dm-vdo-target.c:1109: undefined reference to `uds_register_thread_device_id'
>> ld: drivers/md/dm-vdo-target.c:1119: undefined reference to `vdo_map_to_system_error'
>> ld: drivers/md/dm-vdo-target.c:1122: undefined reference to `uds_unregister_thread_device_id'
>> ld: drivers/md/dm-vdo-target.c:1123: undefined reference to `uds_unregister_allocating_thread'
>> ld: drivers/md/dm-vdo-target.c:1116: undefined reference to `vdo_write_stats'
   ld: drivers/md/dm-vdo-target.c:1103: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_uses_device':
>> drivers/md/dm-vdo-target.c:1148: undefined reference to `vdo_get_backing_device'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_status':
>> drivers/md/dm-vdo-target.c:996: undefined reference to `vdo_fetch_statistics'
>> ld: drivers/md/dm-vdo-target.c:999: undefined reference to `vdo_get_compressing'
>> ld: drivers/md/dm-vdo-target.c:999: undefined reference to `vdo_get_dedupe_index_state_name'
>> ld: drivers/md/dm-vdo-target.c:999: undefined reference to `vdo_get_backing_device'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_resume':
>> drivers/md/dm-vdo-target.c:2856: undefined reference to `uds_register_thread_device_id'
>> ld: drivers/md/dm-vdo-target.c:2858: undefined reference to `vdo_get_device_name'
   ld: drivers/md/dm-vdo-target.c:2858: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:2859: undefined reference to `uds_unregister_thread_device_id'
   ld: drivers/md/dm-vdo-target.o: in function `finish_operation_callback':
>> drivers/md/dm-vdo-target.c:1264: undefined reference to `vdo_finish_operation'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_presuspend':
   drivers/md/dm-vdo-target.c:1962: undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   ld: drivers/md/dm-vdo-target.c:1962: undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   ld: drivers/md/dm-vdo-target.c:1962: undefined reference to `VDO_ADMIN_STATE_SAVING'
   ld: drivers/md/dm-vdo-target.c:1962: undefined reference to `VDO_ADMIN_STATE_SAVING'
   ld: drivers/md/dm-vdo-target.c:1962: undefined reference to `VDO_ADMIN_STATE_SAVING'
   ld: drivers/md/dm-vdo-target.c:1962: undefined reference to `VDO_ADMIN_STATE_SUSPENDING'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_map_bio':
   drivers/md/dm-vdo-target.c:914: undefined reference to `vdo_count_bios'
   ld: drivers/md/dm-vdo-target.c:919: undefined reference to `vdo_launch_flush'
   ld: drivers/md/dm-vdo-target.c:924: undefined reference to `vdo_get_current_work_queue'
   ld: drivers/md/dm-vdo-target.c:927: undefined reference to `vdo_launch_bio'
   ld: drivers/md/dm-vdo-target.c:910: undefined reference to `uds_assertion_failed'
   ld: drivers/md/dm-vdo-target.c:925: undefined reference to `vdo_get_work_queue_owner'
   ld: drivers/md/dm-vdo-target.o: in function `release_instance':
   drivers/md/dm-vdo-target.c:1435: undefined reference to `uds_assertion_failed'
   ld: drivers/md/dm-vdo-target.c:1431: undefined reference to `uds_assertion_failed'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_is_named':
   drivers/md/dm-vdo-target.c:1509: undefined reference to `vdo_get_device_name'
   ld: drivers/md/dm-vdo-target.o: in function `process_one_thread_config_spec':
   drivers/md/dm-vdo-target.c:409: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:472: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:412: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:421: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:430: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.o:drivers/md/dm-vdo-target.c:439: more undefined references to `__uds_log_message' follow
   ld: drivers/md/dm-vdo-target.o: in function `grow_bit_array':
   drivers/md/dm-vdo-target.c:1543: undefined reference to `uds_reallocate_memory'
   ld: drivers/md/dm-vdo-target.o: in function `allocate_instance':
   drivers/md/dm-vdo-target.c:1584: undefined reference to `uds_assertion_failed'
   ld: drivers/md/dm-vdo-target.o: in function `free_device_config':
   drivers/md/dm-vdo-target.c:195: undefined reference to `uds_free'
   ld: drivers/md/dm-vdo-target.c:196: undefined reference to `uds_free'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_dtr':
   drivers/md/dm-vdo-target.c:1933: undefined reference to `uds_register_thread_device_id'
   ld: drivers/md/dm-vdo-target.c:1934: undefined reference to `uds_register_allocating_thread'
   ld: drivers/md/dm-vdo-target.c:1936: undefined reference to `vdo_get_device_name'
   ld: drivers/md/dm-vdo-target.c:1937: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:1941: undefined reference to `vdo_destroy'
   ld: drivers/md/dm-vdo-target.c:1942: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:1943: undefined reference to `uds_unregister_thread_device_id'
   ld: drivers/md/dm-vdo-target.c:1944: undefined reference to `uds_unregister_allocating_thread'
   ld: drivers/md/dm-vdo-target.c:1939: undefined reference to `vdo_dump_all'
   ld: drivers/md/dm-vdo-target.o: in function `decode_from_super_block':
   drivers/md/dm-vdo-target.c:1283: undefined reference to `vdo_decode_component_states'
   ld: drivers/md/dm-vdo-target.o: in function `decode_vdo':
   drivers/md/dm-vdo-target.c:1331: undefined reference to `vdo_destroy_component_states'
   ld: drivers/md/dm-vdo-target.o: in function `decode_from_super_block':
   drivers/md/dm-vdo-target.c:1288: undefined reference to `vdo_set_state'
   ld: drivers/md/dm-vdo-target.c:1302: undefined reference to `vdo_validate_component_states'
   ld: drivers/md/dm-vdo-target.o: in function `decode_vdo':
   drivers/md/dm-vdo-target.c:1337: undefined reference to `vdo_get_recovery_journal_length'
   ld: drivers/md/dm-vdo-target.c:1350: undefined reference to `vdo_enable_read_only_entry'
   ld: drivers/md/dm-vdo-target.c:1354: undefined reference to `vdo_get_known_partition'
   ld: drivers/md/dm-vdo-target.c:1356: undefined reference to `vdo_decode_recovery_journal'
   ld: drivers/md/dm-vdo-target.c:1364: undefined reference to `vdo_get_known_partition'
   ld: drivers/md/dm-vdo-target.c:1365: undefined reference to `vdo_decode_slab_depot'
   ld: drivers/md/dm-vdo-target.c:1370: undefined reference to `vdo_decode_block_map'
   ld: drivers/md/dm-vdo-target.c:1378: undefined reference to `vdo_make_physical_zones'
   ld: drivers/md/dm-vdo-target.c:1383: undefined reference to `vdo_make_logical_zones'
   ld: drivers/md/dm-vdo-target.o: in function `decode_from_super_block':
   drivers/md/dm-vdo-target.c:1296: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.o: in function `uds_do_allocation':
   drivers/md/dm-vdo/memory-alloc.h:56: undefined reference to `uds_allocate_memory'
   ld: drivers/md/dm-vdo-target.o: in function `join_strings':
   drivers/md/dm-vdo-target.c:350: undefined reference to `uds_append_to_buffer'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_launch_completion':
   drivers/md/dm-vdo/completion.h:52: undefined reference to `vdo_launch_completion_with_priority'
   ld: drivers/md/dm-vdo-target.o: in function `perform_grow_logical':
   drivers/md/dm-vdo-target.c:2542: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.o: in function `apply_new_vdo_configuration':
   drivers/md/dm-vdo-target.c:2744: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.o: in function `perform_grow_logical':
   drivers/md/dm-vdo-target.c:2553: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:2538: undefined reference to `vdo_abandon_block_map_growth'
   ld: drivers/md/dm-vdo-target.o: in function `perform_grow_physical':
   drivers/md/dm-vdo-target.c:2711: undefined reference to `vdo_get_known_partition'
   ld: drivers/md/dm-vdo-target.o: in function `apply_new_vdo_configuration':
   drivers/md/dm-vdo-target.c:2750: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.o: in function `perform_grow_physical':
   drivers/md/dm-vdo-target.c:2722: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:2704: undefined reference to `vdo_uninitialize_layout'
   ld: drivers/md/dm-vdo-target.c:2705: undefined reference to `vdo_abandon_new_slabs'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_preresume_registered':
   drivers/md/dm-vdo-target.c:2758: undefined reference to `vdo_get_device_name'
   ld: drivers/md/dm-vdo-target.o: in function `get_underlying_device_block_count':
   drivers/md/dm-vdo-target.c:1024: undefined reference to `vdo_get_backing_device'
   ld: drivers/md/dm-vdo-target.o: in function `vdo_preresume_registered':
   drivers/md/dm-vdo-target.c:2771: undefined reference to `vdo_get_admin_state'
   ld: drivers/md/dm-vdo-target.c:2771: undefined reference to `VDO_ADMIN_STATE_PRE_LOADED'
   ld: drivers/md/dm-vdo-target.c:2771: undefined reference to `VDO_ADMIN_STATE_PRE_LOADED'
   ld: drivers/md/dm-vdo-target.c:2793: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:2818: undefined reference to `vdo_get_admin_state'
   ld: drivers/md/dm-vdo-target.c:2832: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:2772: undefined reference to `__uds_log_message'
   ld: drivers/md/dm-vdo-target.c:2780: undefined reference to `__uds_log_strerror'
   ld: drivers/md/dm-vdo-target.c:2782: undefined reference to `VDO_ADMIN_STATE_STOPPING'
   ld: drivers/md/dm-vdo-target.c:2782: undefined reference to `VDO_ADMIN_STATE_STOPPING'
   ld: drivers/md/dm-vdo-target.c:2811: undefined reference to `__uds_log_strerror'
   ld: drivers/md/dm-vdo-target.c:2814: undefined reference to `vdo_enter_read_only_mode'


vim +2889 drivers/md/dm-vdo-target.c

57a3b0b0fc7414 Matthew Sakai 2023-11-16  2677  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2678  /**
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2679   * perform_grow_physical() - Grow the physical size of the vdo.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2680   * @vdo: The vdo to resize.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2681   * @new_physical_blocks: The new physical size in blocks.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2682   *
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2683   * Context: This method may only be called when the vdo has been suspended and must not be called
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2684   * from a base thread.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2685   *
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2686   * Return: VDO_SUCCESS or an error.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2687   */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2688  static int perform_grow_physical(struct vdo *vdo, block_count_t new_physical_blocks)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2689  {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2690  	int result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2691  	block_count_t new_depot_size, prepared_depot_size;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2692  	block_count_t old_physical_blocks = vdo->states.vdo.config.physical_blocks;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2693  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2694  	/* Skip any noop grows. */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2695  	if (old_physical_blocks == new_physical_blocks)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2696  		return VDO_SUCCESS;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2697  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2698  	if (new_physical_blocks != vdo->next_layout.size) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2699  		/*
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2700  		 * Either the VDO isn't prepared to grow, or it was prepared to grow to a different
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2701  		 * size. Doing this check here relies on the fact that the call to this method is
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2702  		 * done under the dmsetup message lock.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2703  		 */
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2704  		vdo_uninitialize_layout(&vdo->next_layout);
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2705  		vdo_abandon_new_slabs(vdo->depot);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2706  		return VDO_PARAMETER_MISMATCH;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2707  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2708  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2709  	/* Validate that we are prepared to grow appropriately. */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2710  	new_depot_size =
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2711  		vdo_get_known_partition(&vdo->next_layout, VDO_SLAB_DEPOT_PARTITION)->count;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2712  	prepared_depot_size = (vdo->depot->new_slabs == NULL) ? 0 : vdo->depot->new_size;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2713  	if (prepared_depot_size != new_depot_size)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2714  		return VDO_PARAMETER_MISMATCH;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2715  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2716  	result = perform_admin_operation(vdo, GROW_PHYSICAL_PHASE_START,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2717  					 grow_physical_callback,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2718  					 handle_physical_growth_error, "grow physical");
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2719  	if (result != VDO_SUCCESS)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2720  		return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2721  
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2722  	uds_log_info("Physical block count was %llu, now %llu",
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2723  		     (unsigned long long) old_physical_blocks,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2724  		     (unsigned long long) new_physical_blocks);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2725  	return VDO_SUCCESS;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2726  }
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2727  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2728  /**
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2729   * apply_new_vdo_configuration() - Attempt to make any configuration changes from the table being
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2730   *                                 resumed.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2731   * @vdo: The vdo being resumed.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2732   * @config: The new device configuration derived from the table with which the vdo is being
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2733   *          resumed.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2734   *
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2735   * Return: VDO_SUCCESS or an error.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2736   */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2737  static int __must_check apply_new_vdo_configuration(struct vdo *vdo,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2738  						    struct device_config *config)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2739  {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2740  	int result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2741  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2742  	result = perform_grow_logical(vdo, config->logical_blocks);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2743  	if (result != VDO_SUCCESS) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2744  		uds_log_error("grow logical operation failed, result = %d", result);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2745  		return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2746  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2747  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2748  	result = perform_grow_physical(vdo, config->physical_blocks);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2749  	if (result != VDO_SUCCESS)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2750  		uds_log_error("resize operation failed, result = %d", result);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2751  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2752  	return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2753  }
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2754  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2755  static int vdo_preresume_registered(struct dm_target *ti, struct vdo *vdo)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2756  {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2757  	struct device_config *config = ti->private;
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2758  	const char *device_name = vdo_get_device_name(ti);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2759  	block_count_t backing_blocks;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2760  	int result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2761  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2762  	backing_blocks = get_underlying_device_block_count(vdo);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2763  	if (backing_blocks < config->physical_blocks) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2764  		/* FIXME: can this still happen? */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2765  		uds_log_error("resume of device '%s' failed: backing device has %llu blocks but VDO physical size is %llu blocks",
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2766  			      device_name, (unsigned long long) backing_blocks,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2767  			      (unsigned long long) config->physical_blocks);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2768  		return -EINVAL;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2769  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2770  
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2771  	if (vdo_get_admin_state(vdo) == VDO_ADMIN_STATE_PRE_LOADED) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2772  		uds_log_info("starting device '%s'", device_name);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2773  		result = perform_admin_operation(vdo, LOAD_PHASE_START, load_callback,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2774  						 handle_load_error, "load");
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2775  		if ((result != VDO_SUCCESS) && (result != VDO_READ_ONLY)) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2776  			/*
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2777  			 * Something has gone very wrong. Make sure everything has drained and
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2778  			 * leave the device in an unresumable state.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2779  			 */
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2780  			uds_log_error_strerror(result,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2781  					       "Start failed, could not load VDO metadata");
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2782  			vdo->suspend_type = VDO_ADMIN_STATE_STOPPING;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2783  			perform_admin_operation(vdo, SUSPEND_PHASE_START,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2784  						suspend_callback, suspend_callback,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2785  						"suspend");
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2786  			return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2787  		}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2788  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2789  		/* Even if the VDO is read-only, it is now able to handle read requests. */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2790  		uds_log_info("device '%s' started", device_name);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2791  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2792  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2793  	uds_log_info("resuming device '%s'", device_name);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2794  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2795  	/* If this fails, the VDO was not in a state to be resumed. This should never happen. */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2796  	result = apply_new_vdo_configuration(vdo, config);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2797  	BUG_ON(result == VDO_INVALID_ADMIN_STATE);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2798  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2799  	/*
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2800  	 * Now that we've tried to modify the vdo, the new config *is* the config, whether the
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2801  	 * modifications worked or not.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2802  	 */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2803  	vdo->device_config = config;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2804  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2805  	/*
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2806  	 * Any error here is highly unexpected and the state of the vdo is questionable, so we mark
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2807  	 * it read-only in memory. Because we are suspended, the read-only state will not be
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2808  	 * written to disk.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2809  	 */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2810  	if (result != VDO_SUCCESS) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2811  		uds_log_error_strerror(result,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2812  				       "Commit of modifications to device '%s' failed",
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2813  				       device_name);
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2814  		vdo_enter_read_only_mode(vdo, result);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2815  		return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2816  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2817  
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2818  	if (vdo_get_admin_state(vdo)->normal) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2819  		/* The VDO was just started, so we don't need to resume it. */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2820  		return VDO_SUCCESS;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2821  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2822  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2823  	result = perform_admin_operation(vdo, RESUME_PHASE_START, resume_callback,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2824  					 resume_callback, "resume");
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2825  	BUG_ON(result == VDO_INVALID_ADMIN_STATE);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2826  	if (result == VDO_READ_ONLY) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2827  		/* Even if the vdo is read-only, it has still resumed. */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2828  		result = VDO_SUCCESS;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2829  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2830  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2831  	if (result != VDO_SUCCESS)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2832  		uds_log_error("resume of device '%s' failed with error: %d", device_name,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2833  			      result);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2834  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2835  	return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2836  }
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2837  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2838  static int vdo_preresume(struct dm_target *ti)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2839  {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2840  	struct registered_thread instance_thread;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2841  	struct vdo *vdo = get_vdo_for_target(ti);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2842  	int result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2843  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2844  	uds_register_thread_device_id(&instance_thread, &vdo->instance);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2845  	result = vdo_preresume_registered(ti, vdo);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2846  	if ((result == VDO_PARAMETER_MISMATCH) || (result == VDO_INVALID_ADMIN_STATE))
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2847  		result = -EINVAL;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2848  	uds_unregister_thread_device_id();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2849  	return vdo_map_to_system_error(result);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2850  }
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2851  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2852  static void vdo_resume(struct dm_target *ti)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2853  {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2854  	struct registered_thread instance_thread;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2855  
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2856  	uds_register_thread_device_id(&instance_thread,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2857  				      &get_vdo_for_target(ti)->instance);
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2858  	uds_log_info("device '%s' resumed", vdo_get_device_name(ti));
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2859  	uds_unregister_thread_device_id();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2860  }
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2861  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2862  /*
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2863   * If anything changes that affects how user tools will interact with vdo, update the version
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2864   * number and make sure documentation about the change is complete so tools can properly update
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2865   * their management code.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2866   */
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2867  static struct target_type vdo_target_bio = {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2868  	.features = DM_TARGET_SINGLETON,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2869  	.name = "vdo",
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2870  	.version = { 8, 2, 0 },
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2871  	.module = THIS_MODULE,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2872  	.ctr = vdo_ctr,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2873  	.dtr = vdo_dtr,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2874  	.io_hints = vdo_io_hints,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2875  	.iterate_devices = vdo_iterate_devices,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2876  	.map = vdo_map_bio,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2877  	.message = vdo_message,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2878  	.status = vdo_status,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2879  	.presuspend = vdo_presuspend,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2880  	.postsuspend = vdo_postsuspend,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2881  	.preresume = vdo_preresume,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2882  	.resume = vdo_resume,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2883  };
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2884  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2885  static bool dm_registered;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2886  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2887  static void vdo_module_destroy(void)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2888  {
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2889  	uds_log_debug("unloading");
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2890  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2891  	if (dm_registered)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2892  		dm_unregister_target(&vdo_target_bio);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2893  
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2894  	ASSERT_LOG_ONLY(instances.count == 0,
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2895  			"should have no instance numbers still in use, but have %u",
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2896  			instances.count);
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2897  	uds_free(instances.words);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2898  	memset(&instances, 0, sizeof(struct instance_tracker));
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2899  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2900  	uds_log_info("unloaded version %s", CURRENT_VERSION);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2901  }
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2902  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2903  static int __init vdo_init(void)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2904  {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2905  	int result = 0;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2906  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2907  	/*
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2908  	 * UDS module level initialization must be done first, as VDO initialization depends on it
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2909  	 */
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2910  	uds_initialize_thread_device_registry();
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2911  	uds_memory_init();
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2912  	uds_init_sysfs();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2913  
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2914  	vdo_initialize_device_registry_once();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2915  	uds_log_info("loaded version %s", CURRENT_VERSION);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2916  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2917  	/* Add VDO errors to the already existing set of errors in UDS. */
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2918  	result = vdo_register_status_codes();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2919  	if (result != UDS_SUCCESS) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2920  		uds_log_error("vdo_register_status_codes failed %d", result);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2921  		vdo_module_destroy();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2922  		return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2923  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2924  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2925  	result = dm_register_target(&vdo_target_bio);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2926  	if (result < 0) {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2927  		uds_log_error("dm_register_target failed %d", result);
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2928  		vdo_module_destroy();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2929  		return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2930  	}
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2931  	dm_registered = true;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2932  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2933  	return result;
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2934  }
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2935  
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2936  static void __exit vdo_exit(void)
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2937  {
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2938  	vdo_module_destroy();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2939  	/*
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2940  	 * UDS module level exit processing must be done after all VDO module exit processing is
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2941  	 * complete.
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2942  	 */
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2943  	uds_put_sysfs();
57a3b0b0fc7414 Matthew Sakai 2023-11-16 @2944  	uds_memory_exit();
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2945  }
57a3b0b0fc7414 Matthew Sakai 2023-11-16  2946  

:::::: The code at line 2889 was first introduced by commit
:::::: 57a3b0b0fc74143a59aabfaeac00d4dd64d28f73 dm vdo: add the top-level DM target

:::::: TO: Matthew Sakai <msakai@redhat.com>
:::::: CC: Mike Snitzer <snitzer@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
