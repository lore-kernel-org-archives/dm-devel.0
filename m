Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63E525783A;
	Sat,  3 Jan 2026 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767461248; cv=none; b=gDFoQx136HeWUeeL4uQjlw8tSLGR8alXJl16GchMf5TS5tCKlNeuHuGCE/7mt2/pGtzt0WTIPCIOF1BFSYVTXrqEmJNQzoUR5schg9KR0lUUI7Cjrrw9rNP+33zLo2iaRuJ2Umiz3+GcsWI4OZvmu4rRqpXDfoDVFod4IAqAw8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767461248; c=relaxed/simple;
	bh=1KTepNE9/PIiH60G1XCJqDTU661np6x7wNVI1ZkZJPY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=UahQcHDuOzI75iqO95znpk6VA8xKA7RbsfzD0nHUQsTh37R44l3pvaZX2gzFCvMeL3/mVmyHftepUkdHHe0h5rJ1NOYq44EKzdAlddN2ZQ5L9j3+GMMLbps9R1NbWMBUxaSxWlqBk2BrjSrVsRtWvow/sgap7bZESBYSt9Malus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OLKbiucR; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OLKbiucR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767461246; x=1798997246;
  h=date:from:to:cc:subject:message-id;
  bh=1KTepNE9/PIiH60G1XCJqDTU661np6x7wNVI1ZkZJPY=;
  b=OLKbiucRee3J1r96bJUdGm+t1GXK7qbfXQ/Rllcva3y97uXBZ7nAce4x
   XQYV61XUKGhqIDv9jlusF/qIKV0JEAxS1oW0ZjwSWDZQaVeWfB8/aXxPX
   cNFeWxh5YLEYnUIK0Ce8s5D8DNn1Q/FoFMkK6sBJGWS7Gp0ey2jqOhRZE
   fhsqOVJizBS0ZP/1GrPV+zH1tYqpev1O4aGuAmWu4qOeO4v2BHgoejBzk
   zr7OknotVlUGiFIaOy9KPBN4v06gI9vfInPSyEXtjrexJtfkJAZ95VSo/
   qQrhYCt+lsmgKcMJBab3RsOQkTecw689EltGbK4hldX5Rj10729woeO/j
   Q==;
X-CSE-ConnectionGUID: TX9GB3vaSf+tqM2H4hYO4w==
X-CSE-MsgGUID: xSSeQJqlSDq1HMD83CuEaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="68644641"
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="68644641"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2026 09:27:25 -0800
X-CSE-ConnectionGUID: CUej8eGpTyqHTCFJLHKbgw==
X-CSE-MsgGUID: WmLsXgdlQUqvgzYVgUEv4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="201794097"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 03 Jan 2026 09:27:22 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vc5PM-000000000An-3fGB;
	Sat, 03 Jan 2026 17:27:20 +0000
Date: Sun, 04 Jan 2026 01:26:23 +0800
From: kernel test robot <lkp@intel.com>
To: "jaeyuel.im" <jaeyuel.im@lge.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>
Subject: [device-mapper-dm:for-next 6/15]
 drivers/md/dm-init.c:314:20: error: call to undeclared function
 'blkdev_get_no_open'; ISO C99 and later do not support implicit function
 declarations
Message-ID: <202601040123.HHNIwEua-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   89db2b980bb27a5ec625382f8fe7798f6ab10d01
commit: 5cf739d81755e49c39a3bd3c8bf5ec57441710b5 [6/15] dm init: ensure block device is ready before creating mapped device
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20260104/202601040123.HHNIwEua-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260104/202601040123.HHNIwEua-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601040123.HHNIwEua-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/dm-init.c:314:20: error: call to undeclared function 'blkdev_get_no_open'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     314 |                         while (!(bdev = blkdev_get_no_open(dev, false)))
         |                                         ^
>> drivers/md/dm-init.c:314:18: error: incompatible integer to pointer conversion assigning to 'struct block_device *' from 'int' [-Wint-conversion]
     314 |                         while (!(bdev = blkdev_get_no_open(dev, false)))
         |                                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/dm-init.c:316:4: error: call to undeclared function 'blkdev_put_no_open'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     316 |                         blkdev_put_no_open(bdev);
         |                         ^
   3 errors generated.


vim +/blkdev_get_no_open +314 drivers/md/dm-init.c

   267	
   268	/**
   269	 * dm_init_init - parse "dm-mod.create=" argument and configure drivers
   270	 */
   271	static int __init dm_init_init(void)
   272	{
   273		struct dm_device *dev;
   274		LIST_HEAD(devices);
   275		char *str;
   276		int i, r;
   277	
   278		if (!create)
   279			return 0;
   280	
   281		if (strlen(create) >= DM_MAX_STR_SIZE) {
   282			DMERR("Argument is too big. Limit is %d", DM_MAX_STR_SIZE);
   283			return -EINVAL;
   284		}
   285		str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
   286		if (!str)
   287			return -ENOMEM;
   288	
   289		r = dm_parse_devices(&devices, str);
   290		if (r)
   291			goto out;
   292	
   293		DMINFO("waiting for all devices to be available before creating mapped devices");
   294		wait_for_device_probe();
   295	
   296		for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
   297			if (waitfor[i]) {
   298				dev_t dev;
   299				struct block_device *bdev;
   300	
   301				DMINFO("waiting for device %s ...", waitfor[i]);
   302				while (early_lookup_bdev(waitfor[i], &dev))
   303					fsleep(5000);
   304	
   305				/*
   306				 * early_lookup_bdev() only checks if the device node exists and
   307				 * returns the dev_t. It does not guarantee that the underlying
   308				 * block device is fully initialized and ready to be opened. On
   309				 * some platforms, this can lead to a race condition where
   310				 * dm_early_create() fails because the device is not yet ready.
   311				 * Ensure the block device is truly available by attempting to
   312				 * get it.
   313				 */
 > 314				while (!(bdev = blkdev_get_no_open(dev, false)))
   315					fsleep(5000);
 > 316				blkdev_put_no_open(bdev);
   317			}
   318		}
   319	
   320		if (waitfor[0])
   321			DMINFO("all devices available");
   322	
   323		list_for_each_entry(dev, &devices, list) {
   324			if (dm_early_create(&dev->dmi, dev->table,
   325					    dev->target_args_array))
   326				break;
   327		}
   328	out:
   329		kfree(str);
   330		dm_setup_cleanup(&devices);
   331		return r;
   332	}
   333	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
