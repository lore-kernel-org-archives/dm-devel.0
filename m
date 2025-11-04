Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D91494C2;
	Tue,  4 Nov 2025 00:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762216755; cv=none; b=L9mdPFxeHZQ7hHw5owtaak89WYs1HTBUjQIdIGfplUQcaMOJZI4DsLx6rUoLLlzow49HoaV5QPZN7YsqefEOrX7WbG72TgZ0Gg4nEvWQjmX8+T64YOPLzRTcNwD42B9psSJwC0BfPEaSaYX0wiEwhX5Ed431Z5CsEhl9HkKtKxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762216755; c=relaxed/simple;
	bh=mPNm/C4lAMOMRgM7UB0KMAJ0ifsULw0KEfI5BGUhPDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=suMEh+yJwtsoWTCZde/+YPYHrje+Qw+7S1/H2sd8xhRCQUtfsCGjvg2MAUZJciffERMwcDkAvw6fK7hXXxab3l9fzg0cWRVgGb9a+eg63R+sGEN8m/CQOMmi/xMf1E40CuEXuelelRWmLqAq5rvSSYNQNC9+HKuEWIyJo1e8atk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UhSuOo9e; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhSuOo9e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762216754; x=1793752754;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mPNm/C4lAMOMRgM7UB0KMAJ0ifsULw0KEfI5BGUhPDQ=;
  b=UhSuOo9ejRR5yDu3FL1xntaaincssnmAu+kbnk+CONg7HexAxBGSnF5I
   Wn0ej0pOjEQdah0MebgIppxCFHdoy2UJgqmOLhayBXWcfTSDxqB9sAaQS
   +EA33YxNswxcnPqiuDDSXkVhGFyGFkEIJMzYlwI17n5+oGvBVGKNRpzVO
   l9GMEW4hfd7w8RCx9o7qAtNdkGq93+Z+wusepq8atQai9u1HQGcpuQun9
   UJ6TRxvKrRYTfh49Z0VXacoS8fWMLt2RXSb5gSTOZXLwLNDA8oTlFsQP9
   oNrEIuLD4UBZ0HBbUhMbSzkTcrGh+5TzBZjC+xqFY/UMqyXO+t6/RCUsZ
   Q==;
X-CSE-ConnectionGUID: iWt8//YORl2dFgQKhA8WMw==
X-CSE-MsgGUID: RrOCRJpoSI+Su95Krx53pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="66916321"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="66916321"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 16:39:13 -0800
X-CSE-ConnectionGUID: OfZ4HEkuRhyIWHXTjR/tcQ==
X-CSE-MsgGUID: if1kyanTQXSEi5380gA62w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="210520385"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 03 Nov 2025 16:39:10 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vG544-000QgW-1B;
	Tue, 04 Nov 2025 00:38:45 +0000
Date: Tue, 4 Nov 2025 08:36:25 +0800
From: kernel test robot <lkp@intel.com>
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 04/15] block: introduce disk_report_zone()
Message-ID: <202511040843.y29M2yJp-lkp@intel.com>
References: <20251103133123.645038-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103133123.645038-5-dlemoal@kernel.org>

Hi Damien,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ba6a8208cc205c6545c610b5863ea89466fc486a]

url:    https://github.com/intel-lab-lkp/linux/commits/Damien-Le-Moal/block-handle-zone-management-operations-completions/20251103-214422
base:   ba6a8208cc205c6545c610b5863ea89466fc486a
patch link:    https://lore.kernel.org/r/20251103133123.645038-5-dlemoal%40kernel.org
patch subject: [PATCH v2 04/15] block: introduce disk_report_zone()
config: sparc-randconfig-002-20251104 (https://download.01.org/0day-ci/archive/20251104/202511040843.y29M2yJp-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251104/202511040843.y29M2yJp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511040843.y29M2yJp-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/scsi/sd_zbc.c:47 function parameter 'args' not described in 'sd_zbc_parse_report'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
