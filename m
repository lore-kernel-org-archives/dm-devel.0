Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D474015E8B;
	Wed,  6 Nov 2024 02:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730858641; cv=none; b=U5M1wd3BrgZLOOTKqzK6gh6vPcqct75nb12hSXyh648f0h6o39is8guUpK3PZfItg4/VTUsnh3mh8xQB3Hl1ZJfof+VXeqZaIAOVMBTyxpOL/SWFm80FykqOsSDZ9LMxutgHy69A8OExJeuZpdq2V3s+CxgdwI9jyvIVdBPl2uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730858641; c=relaxed/simple;
	bh=8xOHKdysz0I1thehXlHDuwIhJm1l23HMPTz/Hczj7tI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=agFjCSuCmmb10CzPXrYmBvpFa9EWHGIrTPq9af6/bmkkEZ+L9iN8Wc5jW5N3HE6l9wzNz76gJ46P4HDKV/bKIM5ElHZk7DECa4AUWOpk3tKv0ckiJTExnBqSKnSA1HFMcNcES08DDvd2QL0IVEOgvWzhC1UOABMg5sj89cXkevw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CQ3YX3AE; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CQ3YX3AE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730858640; x=1762394640;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=8xOHKdysz0I1thehXlHDuwIhJm1l23HMPTz/Hczj7tI=;
  b=CQ3YX3AEV5jkQlcO0IVQY+1aHMYvlkXcRIP2Qpm2flgqGRC5vx7On58R
   pKRvk0/vrxkSkqS+MCZNC2K+WBuLGBkUR/hxTEvJMzCn94O+CQ3voF/Ut
   Vrg9xJFncYHe8+fufmTbqhF/coo4rTwU9SZz5VkZGgKjxz9FiBj6PCjd1
   BIm98Eeem/UkzL68rBLdyQLOyyGJ8/tpFdzDyGtmSqXTxmPGByJaIZcFZ
   mXdYpQZCo26bvBCFd1q4tiM6RTJOeDM+YtG1Xy41xQlMDyarnZSyKB/9B
   DKWVw4J3FuzPdKJPS56GMM+ChS5Qh9K2pFkWzxF/08/DEN/+w1M+BaW9q
   A==;
X-CSE-ConnectionGUID: sniITUv7RwGvJ/ZaNrTiRg==
X-CSE-MsgGUID: Bc2G3WEMRrqi2uz50U2kWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="56036255"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="56036255"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:03:59 -0800
X-CSE-ConnectionGUID: vqpyg6bmQoiEieVq1NtUBg==
X-CSE-MsgGUID: ew3ZM7iQTfCGc42aAWpoog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="84600419"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 05 Nov 2024 18:03:58 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8VOl-000mjr-1e;
	Wed, 06 Nov 2024 02:03:55 +0000
Date: Wed, 6 Nov 2024 10:03:12 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Sakai <msakai@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [device-mapper-dm:for-next 15/15]
 drivers/md/dm-vdo/recovery-journal.c:1369: warning: Function parameter or
 struct member 'context' not described in 'write_block'
Message-ID: <202411060937.ogzFm46t-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   02f655ded53008ff0f45bfd96b82581fcd61d2c2
commit: 02f655ded53008ff0f45bfd96b82581fcd61d2c2 [15/15] dm vdo: fix function doc comment formatting
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20241106/202411060937.ogzFm46t-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241106/202411060937.ogzFm46t-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411060937.ogzFm46t-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/md/dm-vdo/recovery-journal.c:268: warning: Function parameter or struct member 'waiter' not described in 'continue_waiter'
   drivers/md/dm-vdo/recovery-journal.c:268: warning: Function parameter or struct member 'context' not described in 'continue_waiter'
   drivers/md/dm-vdo/recovery-journal.c:1085: warning: Function parameter or struct member 'waiter' not described in 'assign_entry'
   drivers/md/dm-vdo/recovery-journal.c:1085: warning: Function parameter or struct member 'context' not described in 'assign_entry'
   drivers/md/dm-vdo/recovery-journal.c:1172: warning: Function parameter or struct member 'waiter' not described in 'continue_committed_waiter'
   drivers/md/dm-vdo/recovery-journal.c:1172: warning: Function parameter or struct member 'context' not described in 'continue_committed_waiter'
   drivers/md/dm-vdo/recovery-journal.c:1369: warning: Function parameter or struct member 'waiter' not described in 'write_block'
>> drivers/md/dm-vdo/recovery-journal.c:1369: warning: Function parameter or struct member 'context' not described in 'write_block'
   drivers/md/dm-vdo/recovery-journal.c:1620: warning: Function parameter or struct member 'state' not described in 'initiate_drain'


vim +1369 drivers/md/dm-vdo/recovery-journal.c

95a72357688803 Matthew Sakai 2023-11-16  1362  
95a72357688803 Matthew Sakai 2023-11-16  1363  /**
95a72357688803 Matthew Sakai 2023-11-16  1364   * write_block() - Issue a block for writing.
95a72357688803 Matthew Sakai 2023-11-16  1365   *
95a72357688803 Matthew Sakai 2023-11-16  1366   * Implements waiter_callback_fn.
95a72357688803 Matthew Sakai 2023-11-16  1367   */
02f655ded53008 Matthew Sakai 2024-10-02  1368  static void write_block(struct vdo_waiter *waiter, void __always_unused *context)
95a72357688803 Matthew Sakai 2023-11-16 @1369  {
95a72357688803 Matthew Sakai 2023-11-16  1370  	struct recovery_journal_block *block =
95a72357688803 Matthew Sakai 2023-11-16  1371  		container_of(waiter, struct recovery_journal_block, write_waiter);
95a72357688803 Matthew Sakai 2023-11-16  1372  	struct recovery_journal *journal = block->journal;
95a72357688803 Matthew Sakai 2023-11-16  1373  	struct packed_journal_header *header = get_block_header(block);
95a72357688803 Matthew Sakai 2023-11-16  1374  
d6e260cc426164 Mike Snitzer  2023-11-20  1375  	if (block->committing || !vdo_waitq_has_waiters(&block->entry_waiters) ||
d6e260cc426164 Mike Snitzer  2023-11-20  1376  	    is_read_only(journal))
95a72357688803 Matthew Sakai 2023-11-16  1377  		return;
95a72357688803 Matthew Sakai 2023-11-16  1378  
d6e260cc426164 Mike Snitzer  2023-11-20  1379  	block->entries_in_commit = vdo_waitq_num_waiters(&block->entry_waiters);
95a72357688803 Matthew Sakai 2023-11-16  1380  	add_queued_recovery_entries(block);
95a72357688803 Matthew Sakai 2023-11-16  1381  
95a72357688803 Matthew Sakai 2023-11-16  1382  	journal->pending_write_count += 1;
95a72357688803 Matthew Sakai 2023-11-16  1383  	journal->events.blocks.written += 1;
95a72357688803 Matthew Sakai 2023-11-16  1384  	journal->events.entries.written += block->entries_in_commit;
95a72357688803 Matthew Sakai 2023-11-16  1385  
95a72357688803 Matthew Sakai 2023-11-16  1386  	header->block_map_head = __cpu_to_le64(journal->block_map_head);
95a72357688803 Matthew Sakai 2023-11-16  1387  	header->slab_journal_head = __cpu_to_le64(journal->slab_journal_head);
95a72357688803 Matthew Sakai 2023-11-16  1388  	header->entry_count = __cpu_to_le16(block->entry_count);
95a72357688803 Matthew Sakai 2023-11-16  1389  
95a72357688803 Matthew Sakai 2023-11-16  1390  	block->committing = true;
95a72357688803 Matthew Sakai 2023-11-16  1391  
95a72357688803 Matthew Sakai 2023-11-16  1392  	/*
95a72357688803 Matthew Sakai 2023-11-16  1393  	 * We must issue a flush and a FUA for every commit. The flush is necessary to ensure that
95a72357688803 Matthew Sakai 2023-11-16  1394  	 * the data being referenced is stable. The FUA is necessary to ensure that the journal
95a72357688803 Matthew Sakai 2023-11-16  1395  	 * block itself is stable before allowing overwrites of the lbn's previous data.
95a72357688803 Matthew Sakai 2023-11-16  1396  	 */
f7f46761ccd9b4 Mike Snitzer  2023-08-25  1397  	vdo_submit_metadata_vio(&block->vio, journal->origin + block->block_number,
b863d7f7503c42 Mike Snitzer  2024-02-05  1398  				complete_write_endio, handle_write_error,
b863d7f7503c42 Mike Snitzer  2024-02-05  1399  				REQ_OP_WRITE | REQ_PRIO | REQ_PREFLUSH | REQ_SYNC | REQ_FUA);
95a72357688803 Matthew Sakai 2023-11-16  1400  }
95a72357688803 Matthew Sakai 2023-11-16  1401  

:::::: The code at line 1369 was first introduced by commit
:::::: 95a72357688803736bf60db973cbf94c0ff3a6da dm vdo: add the recovery journal

:::::: TO: Matthew Sakai <msakai@redhat.com>
:::::: CC: Mike Snitzer <snitzer@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
