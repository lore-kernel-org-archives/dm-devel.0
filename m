Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A3F72639;
	Sun,  4 Jan 2026 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767548787; cv=none; b=Q55rmbn/jSiu9w0mkggDaechobK8Oyciguv7KUczpBgYv0aCTbLmTlAQ6o+XdiPyIpLgfKn1n/oJakNilpB6/tfLm8I4kHuEiUTk5pxQM7P/FDNfnC0zAtj0ndSU1MZ8NRZagQT93JQnJmk1p75+DzyPQAEk5ZgZAcNttVLPuAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767548787; c=relaxed/simple;
	bh=WUGOSMhvLtA4KXmagabyo/ge8M7uSF0H8Gtxicf/UkM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=RniYrQVPbbB31ly00ejTDjOXTiErdqT/6LkFfguOpMZ8SuIHv/Z4yWM5WIUbcCRvyPMcujayZwfSlOMEo4ev/7RTocbu3171vOpY6TEBTVWYwz2Yd04bAURumh5Vae2vbsexGWxdMZcO7yljGaN4ICNFIpBS8dRBjl5FYBPck7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=baMIUrcD; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="baMIUrcD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767548785; x=1799084785;
  h=date:from:to:cc:subject:message-id;
  bh=WUGOSMhvLtA4KXmagabyo/ge8M7uSF0H8Gtxicf/UkM=;
  b=baMIUrcDMXOwpelBGO50p0DPSu993sN3JBMfilxWccCBLgogJZPpgwma
   lY7Bv9jnWexpPwtfqB8d+Vq8g4bJGhK80Nsj1EuwXRu7Re062ZqBcT4jW
   yK5L6ZkbvwedW0V1hPTaO2y0/ktvGKfilShBWabNXhpOzOkxXh0X63Tl+
   xWdcFZDGL2kflzltJ078eOevTJt39Pc6Ju7ZKV4w4GKt/q3NQG/mtLN7U
   tCo45CGmnRnb4cVljRAWhYryINPdS/6YJDiiLJ6Rnu+KjQIc7XtwW7wMd
   tR37+Dzj3wx3Fa1O57AcqHPHMLe7ner05bB92PN+luwYJRc7fo6JIN69B
   g==;
X-CSE-ConnectionGUID: XOYOQLZsSIGFmiRsVXgSPA==
X-CSE-MsgGUID: WOCIlF29S/CmqbSJl0q06g==
X-IronPort-AV: E=McAfee;i="6800,10657,11661"; a="68841050"
X-IronPort-AV: E=Sophos;i="6.21,201,1763452800"; 
   d="scan'208";a="68841050"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2026 09:46:22 -0800
X-CSE-ConnectionGUID: 06BZay4hRgOePEiriCGZFg==
X-CSE-MsgGUID: BSPNQ70HSbm4KXRJYIXtDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,201,1763452800"; 
   d="scan'208";a="201852668"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 04 Jan 2026 09:46:20 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vcSBF-000000000hr-45E6;
	Sun, 04 Jan 2026 17:46:17 +0000
Date: Mon, 05 Jan 2026 01:46:03 +0800
From: kernel test robot <lkp@intel.com>
To: "jaeyuel.im" <jaeyuel.im@lge.com>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
 Mikulas Patocka <mpatocka@redhat.com>
Subject: [device-mapper-dm:for-next 6/15]
 drivers/md/dm-init.c:314:41: error: implicit declaration of function
 'blkdev_get_no_open'; did you mean 'blkdev_get_zone_info'?
Message-ID: <202601050152.9pJILlEG-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   89db2b980bb27a5ec625382f8fe7798f6ab10d01
commit: 5cf739d81755e49c39a3bd3c8bf5ec57441710b5 [6/15] dm init: ensure block device is ready before creating mapped device
config: sparc-randconfig-002-20260104 (https://download.01.org/0day-ci/archive/20260105/202601050152.9pJILlEG-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260105/202601050152.9pJILlEG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601050152.9pJILlEG-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/dm-init.c: In function 'dm_init_init':
>> drivers/md/dm-init.c:314:41: error: implicit declaration of function 'blkdev_get_no_open'; did you mean 'blkdev_get_zone_info'? [-Werror=implicit-function-declaration]
     314 |                         while (!(bdev = blkdev_get_no_open(dev, false)))
         |                                         ^~~~~~~~~~~~~~~~~~
         |                                         blkdev_get_zone_info
   drivers/md/dm-init.c:314:39: warning: assignment to 'struct block_device *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     314 |                         while (!(bdev = blkdev_get_no_open(dev, false)))
         |                                       ^
>> drivers/md/dm-init.c:316:25: error: implicit declaration of function 'blkdev_put_no_open' [-Werror=implicit-function-declaration]
     316 |                         blkdev_put_no_open(bdev);
         |                         ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +314 drivers/md/dm-init.c

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
