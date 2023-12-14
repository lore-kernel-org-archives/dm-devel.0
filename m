Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AD25ABA3;
	Thu, 14 Dec 2023 14:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aZWAvhm0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702564900; x=1734100900;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=rN6hud+oJsUKQi8X4OIhfmAZHdbmCpxNJAQDU9g1zg0=;
  b=aZWAvhm0iBOGe84oXd6UhVWahJJfmGzwLyofxmXWRZiO81kC6M7Pliij
   7kNalk6xuUuGw+HELD8khQ4vksvxvshaQ8982YhmcvVwCBd83+ntDkbtX
   tRZletcc1PwdVsweRw50o/6EqMCGRi8AK9jz3gM2el9yC6DGmX9+5xDIA
   uzWBFusVPqcwI63PK8/nsAnJduXQHqdwa0HRtDbQLCdIKbpmV5lhRSobr
   HjLYtBQD3byafkKX1o2yCnzD+0jaHAtEdxuZa/e3MUJ5meZp7Sjd1rqrW
   B6Kc5jhHOlz2GxirZbFwdEfPZMIUJQh9hiv1NoQ1/sgKsD9oGuiAE5aDt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="392302134"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="392302134"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 06:41:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="892488775"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="892488775"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 14 Dec 2023 06:41:33 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rDmu3-000MBM-2T;
	Thu, 14 Dec 2023 14:41:31 +0000
Date: Thu, 14 Dec 2023 22:40:40 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dm-devel@lists.linux.dev
Subject: [device-mapper-dm:dm-vdo-wip 61/61]
 drivers/md/dm-vdo/dm-vdo-target.c:1157: warning: Function parameter or
 member 'vdo' not described in 'get_thread_id_for_phase'
Message-ID: <202312142231.3Mm9oNl0-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo-wip
head:   e64f626707d0a0b2908bf0d47705d755ada6fd2d
commit: e64f626707d0a0b2908bf0d47705d755ada6fd2d [61/61] dm vdo: use a proper Makefile for dm-vdo
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20231214/202312142231.3Mm9oNl0-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231214/202312142231.3Mm9oNl0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312142231.3Mm9oNl0-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/md/dm-vdo/completion.c:72: warning: Function parameter or member 'completion' not described in 'vdo_set_completion_result'
>> drivers/md/dm-vdo/completion.c:72: warning: Function parameter or member 'result' not described in 'vdo_set_completion_result'
>> drivers/md/dm-vdo/completion.c:88: warning: Function parameter or member 'completion' not described in 'vdo_launch_completion_with_priority'
>> drivers/md/dm-vdo/completion.c:133: warning: Function parameter or member 'completion' not described in 'vdo_requeue_completion_if_needed'
>> drivers/md/dm-vdo/completion.c:133: warning: Function parameter or member 'callback_thread_id' not described in 'vdo_requeue_completion_if_needed'
--
>> drivers/md/dm-vdo/admin-state.c:159: warning: Function parameter or member 'state' not described in 'get_next_state'
>> drivers/md/dm-vdo/admin-state.c:159: warning: Function parameter or member 'operation' not described in 'get_next_state'
>> drivers/md/dm-vdo/admin-state.c:198: warning: Function parameter or member 'state' not described in 'vdo_finish_operation'
>> drivers/md/dm-vdo/admin-state.c:198: warning: Function parameter or member 'result' not described in 'vdo_finish_operation'
>> drivers/md/dm-vdo/admin-state.c:226: warning: Function parameter or member 'state' not described in 'begin_operation'
>> drivers/md/dm-vdo/admin-state.c:226: warning: Function parameter or member 'operation' not described in 'begin_operation'
>> drivers/md/dm-vdo/admin-state.c:226: warning: Function parameter or member 'waiter' not described in 'begin_operation'
>> drivers/md/dm-vdo/admin-state.c:226: warning: Function parameter or member 'initiator' not described in 'begin_operation'
>> drivers/md/dm-vdo/admin-state.c:271: warning: Function parameter or member 'state' not described in 'start_operation'
>> drivers/md/dm-vdo/admin-state.c:271: warning: Function parameter or member 'operation' not described in 'start_operation'
>> drivers/md/dm-vdo/admin-state.c:271: warning: Function parameter or member 'waiter' not described in 'start_operation'
>> drivers/md/dm-vdo/admin-state.c:271: warning: Function parameter or member 'initiator' not described in 'start_operation'
>> drivers/md/dm-vdo/admin-state.c:288: warning: Function parameter or member 'valid' not described in 'check_code'
>> drivers/md/dm-vdo/admin-state.c:288: warning: Function parameter or member 'code' not described in 'check_code'
>> drivers/md/dm-vdo/admin-state.c:288: warning: Function parameter or member 'what' not described in 'check_code'
>> drivers/md/dm-vdo/admin-state.c:288: warning: Function parameter or member 'waiter' not described in 'check_code'
>> drivers/md/dm-vdo/admin-state.c:310: warning: Function parameter or member 'operation' not described in 'assert_vdo_drain_operation'
>> drivers/md/dm-vdo/admin-state.c:310: warning: Function parameter or member 'waiter' not described in 'assert_vdo_drain_operation'
>> drivers/md/dm-vdo/admin-state.c:310: warning: expecting prototype for vdo_drain_operation(). Prototype was for assert_vdo_drain_operation() instead
>> drivers/md/dm-vdo/admin-state.c:325: warning: Function parameter or member 'state' not described in 'vdo_start_draining'
   drivers/md/dm-vdo/admin-state.c:325: warning: Function parameter or member 'operation' not described in 'vdo_start_draining'
   drivers/md/dm-vdo/admin-state.c:325: warning: Function parameter or member 'waiter' not described in 'vdo_start_draining'
   drivers/md/dm-vdo/admin-state.c:325: warning: Function parameter or member 'initiator' not described in 'vdo_start_draining'
   drivers/md/dm-vdo/admin-state.c:352: warning: Function parameter or member 'state' not described in 'vdo_finish_draining'
   drivers/md/dm-vdo/admin-state.c:362: warning: Function parameter or member 'state' not described in 'vdo_finish_draining_with_result'
   drivers/md/dm-vdo/admin-state.c:362: warning: Function parameter or member 'result' not described in 'vdo_finish_draining_with_result'
   drivers/md/dm-vdo/admin-state.c:374: warning: Function parameter or member 'operation' not described in 'vdo_assert_load_operation'
   drivers/md/dm-vdo/admin-state.c:374: warning: Function parameter or member 'waiter' not described in 'vdo_assert_load_operation'
   drivers/md/dm-vdo/admin-state.c:389: warning: Function parameter or member 'state' not described in 'vdo_start_loading'
   drivers/md/dm-vdo/admin-state.c:389: warning: Function parameter or member 'operation' not described in 'vdo_start_loading'
   drivers/md/dm-vdo/admin-state.c:389: warning: Function parameter or member 'waiter' not described in 'vdo_start_loading'
   drivers/md/dm-vdo/admin-state.c:389: warning: Function parameter or member 'initiator' not described in 'vdo_start_loading'
   drivers/md/dm-vdo/admin-state.c:400: warning: Function parameter or member 'state' not described in 'vdo_finish_loading'
   drivers/md/dm-vdo/admin-state.c:411: warning: Function parameter or member 'state' not described in 'vdo_finish_loading_with_result'
   drivers/md/dm-vdo/admin-state.c:411: warning: Function parameter or member 'result' not described in 'vdo_finish_loading_with_result'
   drivers/md/dm-vdo/admin-state.c:423: warning: Function parameter or member 'operation' not described in 'assert_vdo_resume_operation'
   drivers/md/dm-vdo/admin-state.c:423: warning: Function parameter or member 'waiter' not described in 'assert_vdo_resume_operation'
   drivers/md/dm-vdo/admin-state.c:439: warning: Function parameter or member 'state' not described in 'vdo_start_resuming'
   drivers/md/dm-vdo/admin-state.c:439: warning: Function parameter or member 'operation' not described in 'vdo_start_resuming'
   drivers/md/dm-vdo/admin-state.c:439: warning: Function parameter or member 'waiter' not described in 'vdo_start_resuming'
   drivers/md/dm-vdo/admin-state.c:439: warning: Function parameter or member 'initiator' not described in 'vdo_start_resuming'
   drivers/md/dm-vdo/admin-state.c:450: warning: Function parameter or member 'state' not described in 'vdo_finish_resuming'
   drivers/md/dm-vdo/admin-state.c:461: warning: Function parameter or member 'state' not described in 'vdo_finish_resuming_with_result'
   drivers/md/dm-vdo/admin-state.c:461: warning: Function parameter or member 'result' not described in 'vdo_finish_resuming_with_result'
   drivers/md/dm-vdo/admin-state.c:472: warning: Function parameter or member 'state' not described in 'vdo_resume_if_quiescent'
   drivers/md/dm-vdo/admin-state.c:487: warning: Function parameter or member 'state' not described in 'vdo_start_operation'
   drivers/md/dm-vdo/admin-state.c:487: warning: Function parameter or member 'operation' not described in 'vdo_start_operation'
   drivers/md/dm-vdo/admin-state.c:502: warning: Function parameter or member 'state' not described in 'vdo_start_operation_with_waiter'
   drivers/md/dm-vdo/admin-state.c:502: warning: Function parameter or member 'operation' not described in 'vdo_start_operation_with_waiter'
   drivers/md/dm-vdo/admin-state.c:502: warning: Function parameter or member 'waiter' not described in 'vdo_start_operation_with_waiter'
   drivers/md/dm-vdo/admin-state.c:502: warning: Function parameter or member 'initiator' not described in 'vdo_start_operation_with_waiter'
--
>> drivers/md/dm-vdo/action-manager.c:64: warning: Function parameter or member 'scheduler' not described in 'action_manager'
--
>> drivers/md/dm-vdo/data-vio.c:233: warning: Function parameter or member 'pool' not described in 'check_for_drain_complete_locked'
>> drivers/md/dm-vdo/data-vio.c:342: warning: Function parameter or member 'data_vio' not described in 'set_data_vio_compression_status'
>> drivers/md/dm-vdo/data-vio.c:342: warning: Function parameter or member 'status' not described in 'set_data_vio_compression_status'
>> drivers/md/dm-vdo/data-vio.c:342: warning: Function parameter or member 'new_status' not described in 'set_data_vio_compression_status'
>> drivers/md/dm-vdo/data-vio.c:342: warning: Excess function parameter 'state' description in 'set_data_vio_compression_status'
>> drivers/md/dm-vdo/data-vio.c:342: warning: Excess function parameter 'new_state' description in 'set_data_vio_compression_status'
>> drivers/md/dm-vdo/data-vio.c:394: warning: Function parameter or member 'data_vio' not described in 'cancel_data_vio_compression'
>> drivers/md/dm-vdo/data-vio.c:487: warning: Function parameter or member 'data_vio' not described in 'launch_data_vio'
>> drivers/md/dm-vdo/data-vio.c:487: warning: Function parameter or member 'lbn' not described in 'launch_data_vio'
>> drivers/md/dm-vdo/data-vio.c:660: warning: Function parameter or member 'pool' not described in 'schedule_releases'
>> drivers/md/dm-vdo/data-vio.c:788: warning: Function parameter or member 'data_vio' not described in 'initialize_data_vio'
>> drivers/md/dm-vdo/data-vio.c:788: warning: Function parameter or member 'vdo' not described in 'initialize_data_vio'
>> drivers/md/dm-vdo/data-vio.c:844: warning: Function parameter or member 'pool_ptr' not described in 'make_data_vio_pool'
>> drivers/md/dm-vdo/data-vio.c:844: warning: Excess function parameter 'pool' description in 'make_data_vio_pool'
>> drivers/md/dm-vdo/data-vio.c:898: warning: Function parameter or member 'pool' not described in 'free_data_vio_pool'
>> drivers/md/dm-vdo/data-vio.c:959: warning: Function parameter or member 'pool' not described in 'vdo_launch_bio'
>> drivers/md/dm-vdo/data-vio.c:959: warning: Function parameter or member 'bio' not described in 'vdo_launch_bio'
>> drivers/md/dm-vdo/data-vio.c:1004: warning: Function parameter or member 'pool' not described in 'drain_data_vio_pool'
>> drivers/md/dm-vdo/data-vio.c:1015: warning: Function parameter or member 'pool' not described in 'resume_data_vio_pool'
>> drivers/md/dm-vdo/data-vio.c:1034: warning: Function parameter or member 'pool' not described in 'dump_data_vio_pool'
   drivers/md/dm-vdo/data-vio.c:1152: warning: Function parameter or member 'completion' not described in 'release_allocated_lock'
   drivers/md/dm-vdo/data-vio.c:1232: warning: Function parameter or member 'completion' not described in 'release_logical_lock'
   drivers/md/dm-vdo/data-vio.c:1269: warning: Function parameter or member 'data_vio' not described in 'finish_cleanup'
   drivers/md/dm-vdo/data-vio.c:1378: warning: Function parameter or member 'data_vio' not described in 'get_data_vio_operation_name'
   drivers/md/dm-vdo/data-vio.c:1398: warning: Function parameter or member 'data_vio' not described in 'data_vio_allocate_data_block'
   drivers/md/dm-vdo/data-vio.c:1418: warning: Function parameter or member 'data_vio' not described in 'release_data_vio_allocation_lock'
   drivers/md/dm-vdo/data-vio.c:1438: warning: Function parameter or member 'data_vio' not described in 'uncompress_data_vio'
   drivers/md/dm-vdo/data-vio.c:1557: warning: Function parameter or member 'completion' not described in 'read_block'
   drivers/md/dm-vdo/data-vio.c:1714: warning: Function parameter or member 'completion' not described in 'read_old_block_mapping'
   drivers/md/dm-vdo/data-vio.c:1742: warning: Function parameter or member 'completion' not described in 'pack_compressed_data'
   drivers/md/dm-vdo/data-vio.c:1763: warning: Function parameter or member 'completion' not described in 'compress_data_vio'
   drivers/md/dm-vdo/data-vio.c:1792: warning: Function parameter or member 'data_vio' not described in 'launch_compress_data_vio'
   drivers/md/dm-vdo/data-vio.c:1830: warning: bad line: 
   drivers/md/dm-vdo/data-vio.c:1834: warning: Function parameter or member 'completion' not described in 'hash_data_vio'
   drivers/md/dm-vdo/data-vio.c:1868: warning: Function parameter or member 'bio' not described in 'write_bio_finished'
   drivers/md/dm-vdo/data-vio.c:1922: warning: Function parameter or member 'completion' not described in 'acknowledge_write_callback'
   drivers/md/dm-vdo/data-vio.c:1947: warning: Function parameter or member 'completion' not described in 'allocate_block'
   drivers/md/dm-vdo/data-vio.c:1978: warning: Function parameter or member 'completion' not described in 'handle_allocation_error'
   drivers/md/dm-vdo/data-vio.c:2007: warning: Function parameter or member 'completion' not described in 'continue_data_vio_with_block_map_slot'
--
>> drivers/md/dm-vdo/dedupe.c:577: warning: Function parameter or member '__always_unused' not described in 'abort_waiter'
>> drivers/md/dm-vdo/dedupe.c:577: warning: Excess function parameter 'context' description in 'abort_waiter'
>> drivers/md/dm-vdo/dedupe.c:932: warning: Function parameter or member 'waiter' not described in 'enter_forked_lock'
>> drivers/md/dm-vdo/dedupe.c:932: warning: Function parameter or member 'context' not described in 'enter_forked_lock'
>> drivers/md/dm-vdo/dedupe.c:1746: warning: Function parameter or member 'completion' not described in 'vdo_continue_hash_lock'
>> drivers/md/dm-vdo/dedupe.c:1746: warning: Excess function parameter 'data_vio' description in 'vdo_continue_hash_lock'
>> drivers/md/dm-vdo/dedupe.c:1843: warning: Function parameter or member 'completion' not described in 'vdo_acquire_hash_lock'
>> drivers/md/dm-vdo/dedupe.c:1843: warning: Excess function parameter 'data_vio' description in 'vdo_acquire_hash_lock'
>> drivers/md/dm-vdo/dedupe.c:2572: warning: Function parameter or member 'context' not described in 'suspend_index'
>> drivers/md/dm-vdo/dedupe.c:2572: warning: Function parameter or member 'completion' not described in 'suspend_index'
>> drivers/md/dm-vdo/dedupe.c:2586: warning: Function parameter or member 'state' not described in 'initiate_drain'
>> drivers/md/dm-vdo/dedupe.c:2597: warning: Function parameter or member 'context' not described in 'drain_hash_zone'
>> drivers/md/dm-vdo/dedupe.c:2597: warning: Function parameter or member 'zone_number' not described in 'drain_hash_zone'
>> drivers/md/dm-vdo/dedupe.c:2597: warning: Function parameter or member 'parent' not described in 'drain_hash_zone'
>> drivers/md/dm-vdo/dedupe.c:2634: warning: Function parameter or member 'context' not described in 'resume_index'
>> drivers/md/dm-vdo/dedupe.c:2634: warning: Function parameter or member 'parent' not described in 'resume_index'
>> drivers/md/dm-vdo/dedupe.c:2667: warning: Function parameter or member 'context' not described in 'resume_hash_zone'
>> drivers/md/dm-vdo/dedupe.c:2667: warning: Function parameter or member 'zone_number' not described in 'resume_hash_zone'
>> drivers/md/dm-vdo/dedupe.c:2667: warning: Function parameter or member 'parent' not described in 'resume_hash_zone'
>> drivers/md/dm-vdo/dedupe.c:2745: warning: Function parameter or member 'zones' not described in 'vdo_get_dedupe_statistics'
   drivers/md/dm-vdo/dedupe.c:2745: warning: Function parameter or member 'stats' not described in 'vdo_get_dedupe_statistics'
   drivers/md/dm-vdo/dedupe.c:2745: warning: Excess function parameter 'hash_zones' description in 'vdo_get_dedupe_statistics'
   drivers/md/dm-vdo/dedupe.c:2837: warning: expecting prototype for vdo_dump_hash_zone(). Prototype was for dump_hash_zone() instead
--
>> drivers/md/dm-vdo/dm-vdo-target.c:1157: warning: Function parameter or member 'vdo' not described in 'get_thread_id_for_phase'
--
>> drivers/md/dm-vdo/block-map.c:183: warning: Function parameter or member 'cache' not described in 'initialize_info'
>> drivers/md/dm-vdo/block-map.c:222: warning: Function parameter or member 'cache' not described in 'allocate_cache_components'
>> drivers/md/dm-vdo/block-map.c:222: warning: Excess function parameter 'maximum_age' description in 'allocate_cache_components'
>> drivers/md/dm-vdo/block-map.c:248: warning: Function parameter or member 'cache' not described in 'assert_on_cache_thread'
>> drivers/md/dm-vdo/block-map.c:248: warning: Function parameter or member 'function_name' not described in 'assert_on_cache_thread'
>> drivers/md/dm-vdo/block-map.c:284: warning: Function parameter or member 'state' not described in 'get_page_state_name'
>> drivers/md/dm-vdo/block-map.c:351: warning: Function parameter or member 'info' not described in 'set_info_state'
>> drivers/md/dm-vdo/block-map.c:351: warning: Function parameter or member 'new_state' not described in 'set_info_state'
>> drivers/md/dm-vdo/block-map.c:427: warning: Function parameter or member 'cache' not described in 'find_free_page'
>> drivers/md/dm-vdo/block-map.c:446: warning: Function parameter or member 'cache' not described in 'find_page'
>> drivers/md/dm-vdo/block-map.c:465: warning: Function parameter or member 'cache' not described in 'select_lru_page'
>> drivers/md/dm-vdo/block-map.c:537: warning: Function parameter or member 'info' not described in 'distribute_page_over_waitq'
>> drivers/md/dm-vdo/block-map.c:537: warning: Function parameter or member 'waitq' not described in 'distribute_page_over_waitq'
>> drivers/md/dm-vdo/block-map.c:562: warning: Function parameter or member 'cache' not described in 'set_persistent_error'
>> drivers/md/dm-vdo/block-map.c:562: warning: Function parameter or member 'result' not described in 'set_persistent_error'
>> drivers/md/dm-vdo/block-map.c:594: warning: Function parameter or member 'completion' not described in 'validate_completed_page'
>> drivers/md/dm-vdo/block-map.c:770: warning: Function parameter or member 'info' not described in 'launch_page_load'
>> drivers/md/dm-vdo/block-map.c:770: warning: Function parameter or member 'pbn' not described in 'launch_page_load'
>> drivers/md/dm-vdo/block-map.c:847: warning: Function parameter or member 'info' not described in 'schedule_page_save'
>> drivers/md/dm-vdo/block-map.c:863: warning: Function parameter or member 'info' not described in 'launch_page_save'
   drivers/md/dm-vdo/block-map.c:878: warning: Function parameter or member 'waiter' not described in 'completion_needs_page'
   drivers/md/dm-vdo/block-map.c:889: warning: Function parameter or member 'info' not described in 'allocate_free_page'
   drivers/md/dm-vdo/block-map.c:941: warning: Function parameter or member 'cache' not described in 'discard_a_page'
   drivers/md/dm-vdo/block-map.c:967: warning: Function parameter or member 'vdo_page_comp' not described in 'discard_page_for_completion'
   drivers/md/dm-vdo/block-map.c:1145: warning: Function parameter or member 'completion' not described in 'vdo_release_page_completion'
   drivers/md/dm-vdo/block-map.c:1185: warning: Function parameter or member 'info' not described in 'load_page_for_completion'
   drivers/md/dm-vdo/block-map.c:1185: warning: Function parameter or member 'vdo_page_comp' not described in 'load_page_for_completion'
   drivers/md/dm-vdo/block-map.c:1332: warning: Function parameter or member 'cache' not described in 'vdo_invalidate_page_cache'
   drivers/md/dm-vdo/block-map.c:1359: warning: Function parameter or member 'forest' not described in 'get_tree_page_by_index'
   drivers/md/dm-vdo/block-map.c:1359: warning: Function parameter or member 'root_index' not described in 'get_tree_page_by_index'
   drivers/md/dm-vdo/block-map.c:1359: warning: Function parameter or member 'height' not described in 'get_tree_page_by_index'
   drivers/md/dm-vdo/block-map.c:1359: warning: Function parameter or member 'page_index' not described in 'get_tree_page_by_index'
   drivers/md/dm-vdo/block-map.c:2223: warning: Function parameter or member 'data_vio' not described in 'vdo_find_block_map_slot'
   drivers/md/dm-vdo/block-map.c:2448: warning: Function parameter or member 'map' not described in 'make_forest'
   drivers/md/dm-vdo/block-map.c:2486: warning: Function parameter or member 'map' not described in 'replace_forest'
   drivers/md/dm-vdo/block-map.c:2502: warning: Function parameter or member 'cursor' not described in 'finish_cursor'
   drivers/md/dm-vdo/block-map.c:2561: warning: Function parameter or member 'cursor' not described in 'traverse'
   drivers/md/dm-vdo/block-map.c:2634: warning: Function parameter or member 'waiter' not described in 'launch_cursor'
   drivers/md/dm-vdo/block-map.c:2650: warning: Function parameter or member 'map' not described in 'compute_boundary'
   drivers/md/dm-vdo/block-map.c:2650: warning: Function parameter or member 'root_index' not described in 'compute_boundary'
   drivers/md/dm-vdo/block-map.c:2683: warning: Function parameter or member 'map' not described in 'vdo_traverse_forest'
   drivers/md/dm-vdo/block-map.c:2724: warning: Function parameter or member 'map' not described in 'initialize_block_map_zone'
   drivers/md/dm-vdo/block-map.c:2724: warning: Function parameter or member 'zone_number' not described in 'initialize_block_map_zone'
   drivers/md/dm-vdo/block-map.c:2724: warning: Function parameter or member 'cache_size' not described in 'initialize_block_map_zone'
   drivers/md/dm-vdo/block-map.c:3105: warning: Function parameter or member 'data_vio' not described in 'clear_mapped_location'
   drivers/md/dm-vdo/block-map.c:3120: warning: Function parameter or member 'data_vio' not described in 'set_mapped_location'
   drivers/md/dm-vdo/block-map.c:3120: warning: Function parameter or member 'entry' not described in 'set_mapped_location'
--
>> drivers/md/dm-vdo/flush.c:97: warning: expecting prototype for waiter_as_flush(). Prototype was for vdo_waiter_as_flush() instead
>> drivers/md/dm-vdo/flush.c:532: warning: Function parameter or member 'state' not described in 'initiate_drain'
--
>> drivers/md/dm-vdo/encodings.c:439: warning: Function parameter or member 'root_count' not described in 'vdo_compute_new_forest_pages'
>> drivers/md/dm-vdo/encodings.c:439: warning: Function parameter or member 'old_sizes' not described in 'vdo_compute_new_forest_pages'
>> drivers/md/dm-vdo/encodings.c:439: warning: Function parameter or member 'new_sizes' not described in 'vdo_compute_new_forest_pages'
>> drivers/md/dm-vdo/encodings.c:466: warning: Function parameter or member 'buffer' not described in 'encode_recovery_journal_state_7_0'
>> drivers/md/dm-vdo/encodings.c:466: warning: Function parameter or member 'offset' not described in 'encode_recovery_journal_state_7_0'
>> drivers/md/dm-vdo/encodings.c:466: warning: Function parameter or member 'state' not described in 'encode_recovery_journal_state_7_0'
>> drivers/md/dm-vdo/encodings.c:489: warning: Function parameter or member 'offset' not described in 'decode_recovery_journal_state_7_0'
>> drivers/md/dm-vdo/encodings.c:548: warning: Function parameter or member 'buffer' not described in 'encode_slab_depot_state_2_0'
>> drivers/md/dm-vdo/encodings.c:548: warning: Function parameter or member 'offset' not described in 'encode_slab_depot_state_2_0'
>> drivers/md/dm-vdo/encodings.c:548: warning: Function parameter or member 'state' not described in 'encode_slab_depot_state_2_0'
>> drivers/md/dm-vdo/encodings.c:576: warning: Function parameter or member 'buffer' not described in 'decode_slab_depot_state_2_0'
>> drivers/md/dm-vdo/encodings.c:576: warning: Function parameter or member 'offset' not described in 'decode_slab_depot_state_2_0'
>> drivers/md/dm-vdo/encodings.c:576: warning: Function parameter or member 'state' not described in 'decode_slab_depot_state_2_0'
>> drivers/md/dm-vdo/encodings.c:870: warning: Function parameter or member 'offset' not described in 'vdo_initialize_layout'
>> drivers/md/dm-vdo/encodings.c:870: warning: Excess function parameter 'origin' description in 'vdo_initialize_layout'
>> drivers/md/dm-vdo/encodings.c:1174: warning: Function parameter or member 'buffer' not described in 'decode_vdo_component'
>> drivers/md/dm-vdo/encodings.c:1174: warning: Function parameter or member 'offset' not described in 'decode_vdo_component'
>> drivers/md/dm-vdo/encodings.c:1174: warning: Function parameter or member 'component' not described in 'decode_vdo_component'
>> drivers/md/dm-vdo/encodings.c:1174: warning: expecting prototype for vdo_decode_component(). Prototype was for decode_vdo_component() instead
>> drivers/md/dm-vdo/encodings.c:1405: warning: Function parameter or member 'buffer' not described in 'vdo_encode_component_states'
   drivers/md/dm-vdo/encodings.c:1405: warning: Function parameter or member 'offset' not described in 'vdo_encode_component_states'
   drivers/md/dm-vdo/encodings.c:1405: warning: Function parameter or member 'states' not described in 'vdo_encode_component_states'
   drivers/md/dm-vdo/encodings.c:1423: warning: Function parameter or member 'buffer' not described in 'vdo_encode_super_block'
   drivers/md/dm-vdo/encodings.c:1423: warning: Function parameter or member 'states' not described in 'vdo_encode_super_block'
   drivers/md/dm-vdo/encodings.c:1447: warning: Function parameter or member 'buffer' not described in 'vdo_decode_super_block'
--
>> drivers/md/dm-vdo/funnel-workqueue.c:385: warning: Function parameter or member 'thread_name_prefix' not described in 'vdo_make_work_queue'
>> drivers/md/dm-vdo/funnel-workqueue.c:385: warning: Function parameter or member 'name' not described in 'vdo_make_work_queue'
>> drivers/md/dm-vdo/funnel-workqueue.c:385: warning: Function parameter or member 'owner' not described in 'vdo_make_work_queue'
>> drivers/md/dm-vdo/funnel-workqueue.c:385: warning: Function parameter or member 'type' not described in 'vdo_make_work_queue'
>> drivers/md/dm-vdo/funnel-workqueue.c:385: warning: Function parameter or member 'thread_count' not described in 'vdo_make_work_queue'
>> drivers/md/dm-vdo/funnel-workqueue.c:385: warning: Function parameter or member 'thread_privates' not described in 'vdo_make_work_queue'
>> drivers/md/dm-vdo/funnel-workqueue.c:385: warning: Function parameter or member 'queue_ptr' not described in 'vdo_make_work_queue'
--
>> drivers/md/dm-vdo/logical-zone.c:170: warning: Function parameter or member 'state' not described in 'initiate_drain'
>> drivers/md/dm-vdo/logical-zone.c:181: warning: Function parameter or member 'context' not described in 'drain_logical_zone'
>> drivers/md/dm-vdo/logical-zone.c:181: warning: Function parameter or member 'zone_number' not described in 'drain_logical_zone'
>> drivers/md/dm-vdo/logical-zone.c:181: warning: Function parameter or member 'parent' not described in 'drain_logical_zone'
>> drivers/md/dm-vdo/logical-zone.c:204: warning: Function parameter or member 'context' not described in 'resume_logical_zone'
>> drivers/md/dm-vdo/logical-zone.c:204: warning: Function parameter or member 'zone_number' not described in 'resume_logical_zone'
>> drivers/md/dm-vdo/logical-zone.c:204: warning: Function parameter or member 'parent' not described in 'resume_logical_zone'
>> drivers/md/dm-vdo/logical-zone.c:303: warning: expecting prototype for void attempt_generation_complete_notification()(). Prototype was for attempt_generation_complete_notification() instead
..


vim +1157 drivers/md/dm-vdo/dm-vdo-target.c

57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1151  
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1152  /**
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1153   * get_thread_id_for_phase() - Get the thread id for the current phase of the admin operation in
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1154   *                             progress.
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1155   */
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1156  static thread_id_t __must_check get_thread_id_for_phase(struct vdo *vdo)
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16 @1157  {
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1158  	switch (vdo->admin.phase) {
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1159  	case RESUME_PHASE_PACKER:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1160  	case RESUME_PHASE_FLUSHER:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1161  	case SUSPEND_PHASE_PACKER:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1162  	case SUSPEND_PHASE_FLUSHES:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1163  		return vdo->thread_config.packer_thread;
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1164  
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1165  	case RESUME_PHASE_DATA_VIOS:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1166  	case SUSPEND_PHASE_DATA_VIOS:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1167  		return vdo->thread_config.cpu_thread;
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1168  
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1169  	case LOAD_PHASE_DRAIN_JOURNAL:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1170  	case RESUME_PHASE_JOURNAL:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1171  	case SUSPEND_PHASE_JOURNAL:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1172  		return vdo->thread_config.journal_thread;
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1173  
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1174  	default:
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1175  		return vdo->thread_config.admin_thread;
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1176  	}
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1177  }
57a3b0b0fc7414 drivers/md/dm-vdo-target.c Matthew Sakai 2023-11-16  1178  

:::::: The code at line 1157 was first introduced by commit
:::::: 57a3b0b0fc74143a59aabfaeac00d4dd64d28f73 dm vdo: add the top-level DM target

:::::: TO: Matthew Sakai <msakai@redhat.com>
:::::: CC: Mike Snitzer <snitzer@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
