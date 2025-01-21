Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B455129A78;
	Tue, 21 Jan 2025 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737489981; cv=none; b=bTM9eOVZpSc483C0IlDRGukKNcfa/lNo7p1Pnj+74cUPbwBK6jQXQTGiUEHkTwoMjV3KZmuYEDYblZhrumtzM2jUVDw/w/Undfk2PeMM3Rb7HRbHM+yXvPj1Vod/x8Ussz/2VA/O/go3m0NoYfL9gb65fk0Q4tpYMyLKGUjElPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737489981; c=relaxed/simple;
	bh=YpYSr0sNI7VGc4t/23Xo75gHQdbw7uGgLeeJy+bmquI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rlb9DV10k6BBnYju9WgyFqmObfeHMiSa3TI1zgii1e6UxU39D79qOmfYxdYxYeSqCmqYoCSFd+3QkAF4Zzj62X1v+rSMBNyOJ+sY2sdEFD2vW/RT1JPQPF2OQTOGJLF4fP7mgAL1vsc84Bh87H9csIvM3/DOuF7UlCnrV4dGJok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OViNjFJh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OViNjFJh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737489980; x=1769025980;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=YpYSr0sNI7VGc4t/23Xo75gHQdbw7uGgLeeJy+bmquI=;
  b=OViNjFJhu0xpLkMuZTeZJskUcbaLIMEbFNohwiHVZIBqqzMnR4+q/AVT
   SSEJmLlPNmT6b0nUJAAsb3y5OQIB3H0wSvrhqHdbK12yR8NCfyRwNdBtH
   e886ZDgxGBL5VTkYqyFXqCgXvund10r4vNqD3F4jvAbYNzYyz+qxkSwOp
   crAfBWOTZzoVpRHuBn3juZj1fmF/nI9TeYXC/zbW2Dkoind9nLsv2YgI+
   TABqTyT+c3B4xi4JdliXElu0+Lb++gBtdXt5mrWAnQU1qIQyvpgD5RNAy
   kPw97ehTdpKjzfJJRP2kXIh5tvzuF5tSNzyjogLtM31TrVNCo1qCd8okT
   g==;
X-CSE-ConnectionGUID: Sceno0zYSC2XanS0XTZCkw==
X-CSE-MsgGUID: Rp0eYCB8QdqtUBw6Au33DA==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="63283176"
X-IronPort-AV: E=Sophos;i="6.13,223,1732608000"; 
   d="scan'208";a="63283176"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 12:06:18 -0800
X-CSE-ConnectionGUID: 3uuEipCBR8uyMkKFyifsAQ==
X-CSE-MsgGUID: /JoZeA/AQsOADqqDlkfCSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,223,1732608000"; 
   d="scan'208";a="137742533"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 21 Jan 2025 12:06:17 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1taKVp-000Yut-2z;
	Tue, 21 Jan 2025 20:06:13 +0000
Date: Wed, 22 Jan 2025 04:06:03 +0800
From: kernel test robot <lkp@intel.com>
To: Hou Tao <houtao1@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [device-mapper-dm:for-next 14/17] drivers/md/dm-crypt.c:1190:9:
 error: implicit declaration of function 'bip_set_seed'; did you mean
 'bio_set_dev'?
Message-ID: <202501220353.25OWE3tE-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   cc5c4135da9584aa2ccbd0453cccfe52891f172e
commit: e3baf2b47a93f6d27beb0a94df8b912e57f3534f [14/17] dm-crypt: use bi_sector in bio when initialize integrity seed
config: riscv-randconfig-002-20250122 (https://download.01.org/0day-ci/archive/20250122/202501220353.25OWE3tE-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250122/202501220353.25OWE3tE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501220353.25OWE3tE-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/dm-crypt.c: In function 'dm_crypt_integrity_io_alloc':
>> drivers/md/dm-crypt.c:1190:9: error: implicit declaration of function 'bip_set_seed'; did you mean 'bio_set_dev'? [-Wimplicit-function-declaration]
    1190 |         bip_set_seed(bip, bio->bi_iter.bi_sector);
         |         ^~~~~~~~~~~~
         |         bio_set_dev


vim +1190 drivers/md/dm-crypt.c

  1174	
  1175	static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
  1176	{
  1177		struct bio_integrity_payload *bip;
  1178		unsigned int tag_len;
  1179		int ret;
  1180	
  1181		if (!bio_sectors(bio) || !io->cc->tuple_size)
  1182			return 0;
  1183	
  1184		bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
  1185		if (IS_ERR(bip))
  1186			return PTR_ERR(bip);
  1187	
  1188		tag_len = io->cc->tuple_size * (bio_sectors(bio) >> io->cc->sector_shift);
  1189	
> 1190		bip_set_seed(bip, bio->bi_iter.bi_sector);
  1191	
  1192		ret = bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
  1193					     tag_len, offset_in_page(io->integrity_metadata));
  1194		if (unlikely(ret != tag_len))
  1195			return -ENOMEM;
  1196	
  1197		return 0;
  1198	}
  1199	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
