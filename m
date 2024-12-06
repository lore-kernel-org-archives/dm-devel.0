Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734181D8E12;
	Fri,  6 Dec 2024 06:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733465457; cv=none; b=KSBcWap0NIZr7QSCdSMjENcLciWz8aJCgRy/Kt+LpcgPm0aPIThLMOb141qWkpekD90QknW94Qpv5nkM6aR1+Vtt9IPp1IFj3F8kEOzmJNHgpw3wVy32G8GfwnIahgI1eYOe4OiP1ldcIWJd71uMcECI1xjk84vDBxcY5IRfSG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733465457; c=relaxed/simple;
	bh=byiOWDYq8mTgW3endEtkkX5vAx1PxeQf2rYQ0aFgvAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0QG/1BG2RXAO8Hex0aK+0smybuDaMjCLYp/dB6mH1GZwBVfBDJUuEnTGJ1OyAzZv4lCv/20ZgWsT4KCriIDrQAeRr9phHPL02r2sHs13lFF2UKxDSJFV60nSfPyjRcPk/aEINavqvrBG9YiyzTeWnHpw8f2fED7ObuM1MkxGHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XlA303xR; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XlA303xR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733465456; x=1765001456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=byiOWDYq8mTgW3endEtkkX5vAx1PxeQf2rYQ0aFgvAU=;
  b=XlA303xRaWKdudnPMHe6JwPMisjqqd58tz4cX88CCzwjm++FOvq8r8Ab
   ldPVOjodG69Bfi1j/K/dBYI53cma7cIy3hwZGBmtx7rpwt1OnF0139kxu
   DFWH9meON1WYbeTHhNhUp+kYas4/dt9yK8AfyHFB/Q8d8t4l/PHz7dXh9
   CRR7BimRR02OebJINITP/Ppbo02kkK/nUf9jWc4mBaPh73PvT2i0LevBz
   LEdFInt+V4zqQiWdkmPYg2XnaAFP6Oxd/bGaPi8j+p5i1A0OvuXDEhEow
   Nq572EcfP0jSAUJYttX2UJP6GLN4U137QyAF0GxNr8u29fEZXiDyhpisf
   g==;
X-CSE-ConnectionGUID: /McVAjxFQ2CL6hCRrkEIzA==
X-CSE-MsgGUID: NTnBvkijSgqgRx2vN9LlgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="37742510"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="37742510"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 22:10:55 -0800
X-CSE-ConnectionGUID: NjY9ySRhTZSJesLOQ+fq3w==
X-CSE-MsgGUID: sE0ZS/2kRDOib5K2Jbwy7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="99267811"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 05 Dec 2024 22:10:53 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tJRYA-0000l5-01;
	Fri, 06 Dec 2024 06:10:50 +0000
Date: Fri, 6 Dec 2024 14:10:41 +0800
From: kernel test robot <lkp@intel.com>
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/4] dm: Fix dm-zoned-reclaim zone write pointer alignment
Message-ID: <202412061404.Utec5WgH-lkp@intel.com>
References: <20241206015240.6862-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206015240.6862-5-dlemoal@kernel.org>

Hi Damien,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.13-rc1 next-20241205]
[cannot apply to device-mapper-dm/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Damien-Le-Moal/block-Use-a-zone-write-plug-BIO-work-for-REQ_NOWAIT-BIOs/20241206-095452
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241206015240.6862-5-dlemoal%40kernel.org
patch subject: [PATCH 4/4] dm: Fix dm-zoned-reclaim zone write pointer alignment
config: arc-randconfig-002-20241206 (https://download.01.org/0day-ci/archive/20241206/202412061404.Utec5WgH-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241206/202412061404.Utec5WgH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412061404.Utec5WgH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> block/blk-zoned.c:1751: warning: Excess function parameter 'flags' description in 'blkdev_issue_zone_zeroout'


vim +1751 block/blk-zoned.c

  1735	
  1736	/**
  1737	 * blkdev_issue_zone_zeroout - zero-fill a block range in a zone
  1738	 * @bdev:	blockdev to write
  1739	 * @sector:	start sector
  1740	 * @nr_sects:	number of sectors to write
  1741	 * @gfp_mask:	memory allocation flags (for bio_alloc)
  1742	 * @flags:	controls detailed behavior
  1743	 *
  1744	 * Description:
  1745	 *  Zero-fill a block range in a zone (@sector must be equal to the zone write
  1746	 *  pointer), handling potential errors due to the (initially unknown) lack of
  1747	 *  hardware offload (See blkdev_issue_zeroout()).
  1748	 */
  1749	int blkdev_issue_zone_zeroout(struct block_device *bdev, sector_t sector,
  1750			sector_t nr_sects, gfp_t gfp_mask)
> 1751	{
  1752		int ret;
  1753	
  1754		if (WARN_ON_ONCE(!bdev_is_zoned(bdev)))
  1755			return -EIO;
  1756	
  1757		ret = blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask,
  1758					   BLKDEV_ZERO_NOFALLBACK);
  1759		if (ret != -EOPNOTSUPP)
  1760			return ret;
  1761	
  1762		/*
  1763		 * The failed call to blkdev_issue_zeroout() advanced the zone write
  1764		 * pointer. Undo this using a report zone to update the zone write
  1765		 * pointer to the correct current value.
  1766		 */
  1767		ret = disk_zone_sync_wp_offset(bdev->bd_disk, sector);
  1768		if (ret != 1)
  1769			return ret < 0 ? ret : -EIO;
  1770	
  1771		/*
  1772		 * Retry without BLKDEV_ZERO_NOFALLBACK to force the fallback to a
  1773		 * regular write with zero-pages.
  1774		 */
  1775		return blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask, 0);
  1776	}
  1777	EXPORT_SYMBOL(blkdev_issue_zone_zeroout);
  1778	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
