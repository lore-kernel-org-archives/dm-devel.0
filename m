Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3392EB1C;
	Thu, 14 Dec 2023 09:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mJeOGHBJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702547196; x=1734083196;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=XJwjkx2e4CWNy4ClwoaaTXWYdEEJvTrMchPCgsaob7M=;
  b=mJeOGHBJB7TutnYsXY0DN9D6dsM2IzV6OX1JNpS+WwZUjn/Uk5K/0zkG
   JPHVM1HJGQlZ2AXdTqnPjdSEHNZs5Q0a1uFpuv86FhdXlRN+Rc+l+Ugga
   bUK/2ybeP6/LIPs8DfvEnBlbSugw+TfjfoyaZnWHLEINWGzghRe7cnggR
   c94TF64A/+oVA8S9HgIZkD5XHbHylWOWZiOiRa6s6e51EVUpCHKRDv/e/
   wLi/OD9LsPylc2uc/hqe05L8zwknuzomLEP/r17qU/70JQ0CrC1HAG65n
   hPtlG/BGRhgX2OuOzVQ88WenYNQ3AKnSrDMbWhCBIQwTEMMzEV16rHYby
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="398931719"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="398931719"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2023 01:46:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="840222708"
X-IronPort-AV: E=Sophos;i="6.04,275,1695711600"; 
   d="scan'208";a="840222708"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 14 Dec 2023 01:46:32 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rDiIY-000Ls5-1z;
	Thu, 14 Dec 2023 09:46:30 +0000
Date: Thu, 14 Dec 2023 17:45:51 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev
Subject: [device-mapper-dm:dm-vdo-wip 61/61]
 drivers/md/dm-vdo/thread-registry.c:32:28: error: 'current' undeclared
Message-ID: <202312141731.XkQLyrNY-lkp@intel.com>
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
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20231214/202312141731.XkQLyrNY-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231214/202312141731.XkQLyrNY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202312141731.XkQLyrNY-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from drivers/md/dm-vdo/index.h:13,
                    from drivers/md/dm-vdo/open-chapter.h:11,
                    from drivers/md/dm-vdo/index-layout.c:15:
>> drivers/md/dm-vdo/volume-index.h:29:18: warning: 'NO_CHAPTER' defined but not used [-Wunused-const-variable=]
      29 | static const u64 NO_CHAPTER = U64_MAX;
         |                  ^~~~~~~~~~
--
   drivers/md/dm-vdo/thread-registry.c: In function 'uds_register_thread':
>> drivers/md/dm-vdo/thread-registry.c:32:28: error: 'current' undeclared (first use in this function)
      32 |         new_thread->task = current;
         |                            ^~~~~~~
   drivers/md/dm-vdo/thread-registry.c:32:28: note: each undeclared identifier is reported only once for each function it appears in
   drivers/md/dm-vdo/thread-registry.c: In function 'uds_unregister_thread':
   drivers/md/dm-vdo/thread-registry.c:61:37: error: 'current' undeclared (first use in this function)
      61 |                 if (thread->task == current) {
         |                                     ^~~~~~~
   drivers/md/dm-vdo/thread-registry.c: In function 'uds_lookup_thread':
   drivers/md/dm-vdo/thread-registry.c:84:37: error: 'current' undeclared (first use in this function)
      84 |                 if (thread->task == current) {
         |                                     ^~~~~~~
--
   drivers/md/dm-vdo/vdo.c: In function 'vdo_make':
>> drivers/md/dm-vdo/vdo.c:566:19: warning: '%s' directive output may be truncated writing up to 55 bytes into a region of size 16 [-Wformat-truncation=]
     566 |                  "%s%u", MODULE_NAME, instance);
         |                   ^~
   drivers/md/dm-vdo/vdo.c:565:9: note: 'snprintf' output between 2 and 66 bytes into a destination of size 16
     565 |         snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     566 |                  "%s%u", MODULE_NAME, instance);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/current +32 drivers/md/dm-vdo/thread-registry.c

c7d79fd21a2c37 Matthew Sakai 2023-11-16  22  
c7d79fd21a2c37 Matthew Sakai 2023-11-16  23  /* Register the current thread and associate it with a data pointer. */
c7d79fd21a2c37 Matthew Sakai 2023-11-16  24  void uds_register_thread(struct thread_registry *registry,
c7d79fd21a2c37 Matthew Sakai 2023-11-16  25  			 struct registered_thread *new_thread, const void *pointer)
c7d79fd21a2c37 Matthew Sakai 2023-11-16  26  {
c7d79fd21a2c37 Matthew Sakai 2023-11-16  27  	struct registered_thread *thread;
c7d79fd21a2c37 Matthew Sakai 2023-11-16  28  	bool found_it = false;
c7d79fd21a2c37 Matthew Sakai 2023-11-16  29  
c7d79fd21a2c37 Matthew Sakai 2023-11-16  30  	INIT_LIST_HEAD(&new_thread->links);
c7d79fd21a2c37 Matthew Sakai 2023-11-16  31  	new_thread->pointer = pointer;
c7d79fd21a2c37 Matthew Sakai 2023-11-16 @32  	new_thread->task = current;
c7d79fd21a2c37 Matthew Sakai 2023-11-16  33  
c7d79fd21a2c37 Matthew Sakai 2023-11-16  34  	spin_lock(&registry->lock);
c7d79fd21a2c37 Matthew Sakai 2023-11-16  35  	list_for_each_entry(thread, &registry->links, links) {
c7d79fd21a2c37 Matthew Sakai 2023-11-16  36  		if (thread->task == current) {
c7d79fd21a2c37 Matthew Sakai 2023-11-16  37  			/* There should be no existing entry. */
c7d79fd21a2c37 Matthew Sakai 2023-11-16  38  			list_del_rcu(&thread->links);
c7d79fd21a2c37 Matthew Sakai 2023-11-16  39  			found_it = true;
c7d79fd21a2c37 Matthew Sakai 2023-11-16  40  			break;
c7d79fd21a2c37 Matthew Sakai 2023-11-16  41  		}
c7d79fd21a2c37 Matthew Sakai 2023-11-16  42  	}
c7d79fd21a2c37 Matthew Sakai 2023-11-16  43  	list_add_tail_rcu(&new_thread->links, &registry->links);
c7d79fd21a2c37 Matthew Sakai 2023-11-16  44  	spin_unlock(&registry->lock);
c7d79fd21a2c37 Matthew Sakai 2023-11-16  45  
c7d79fd21a2c37 Matthew Sakai 2023-11-16  46  	ASSERT_LOG_ONLY(!found_it, "new thread not already in registry");
c7d79fd21a2c37 Matthew Sakai 2023-11-16  47  	if (found_it) {
c7d79fd21a2c37 Matthew Sakai 2023-11-16  48  		/* Ensure no RCU iterators see it before re-initializing. */
c7d79fd21a2c37 Matthew Sakai 2023-11-16  49  		synchronize_rcu();
c7d79fd21a2c37 Matthew Sakai 2023-11-16  50  		INIT_LIST_HEAD(&thread->links);
c7d79fd21a2c37 Matthew Sakai 2023-11-16  51  	}
c7d79fd21a2c37 Matthew Sakai 2023-11-16  52  }
c7d79fd21a2c37 Matthew Sakai 2023-11-16  53  

:::::: The code at line 32 was first introduced by commit
:::::: c7d79fd21a2c3776577f17e22747b38bb61b9563 dm vdo: add thread and synchronization utilities

:::::: TO: Matthew Sakai <msakai@redhat.com>
:::::: CC: Mike Snitzer <snitzer@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
