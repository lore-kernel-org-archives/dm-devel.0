Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B732D9481;
	Mon,  9 Mar 2026 08:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773045698; cv=none; b=nWMUSG3Qp9/farj3Sr7sS3l+uLI1vrz8D+OaftZmM69zK21Otpps9IfJDszsFqMAN1dacG1SHXD0Ot3F+NRuv37KJfvY1tT9GL/gR/3vAgnk8UQngp8x2CZT5xjbGt1muMkb+jMn+88HarcGHJewQn+WFhQrIErZv5ZRvB5cE30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773045698; c=relaxed/simple;
	bh=JBpXZptTSUunAq5dyKc9na25R/vc1bFHXrI3d81DJiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T9Io3iH12ZDZIcnJO/N52JZO5954nBOQgg3PHFbTXfT8UU3IC8j1BsM8LDJ62rMFIOJpdYT0U4f4HLG81nY7yIXm2pYmuT2egirsmiUbSdq1z8CS5+fKbU+gWRtwFvXi5cM0ENkYRU0QxAU9IAG6Uzv25TORCC2+YOyWaOANnSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DEzokvNv; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DEzokvNv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773045697; x=1804581697;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JBpXZptTSUunAq5dyKc9na25R/vc1bFHXrI3d81DJiI=;
  b=DEzokvNvsTs1SbPjydXPbhUzcBv+RNfFujeGoTkb67ifT+Zca+Gu9RUF
   9OFNwNNYvFsfTuczujDf8217kONKP/2xZrvRbUrYjb1rP3IwpdPyRDXIk
   loTTx0PXn9I7Al8qJdsT1d8Rc5mh3vgpFm/nJdMPzM9LlL5BP4+cYKh2F
   eALmUm1Ee4gfSmvto8JW3scyEV8A94weSL27U3cfAbzVu2yeF0/3myxMY
   4g6WcDx/CMBE2nwqmK6d2FzNvMC5OTCG8RTHRMYQsn8R+qE1wILpZrxrp
   pzDpaPzZNVSXwibsxtWOm3vu9v8SUxpkQRv62bxwu0BIeQ6Ou5g1c/btx
   Q==;
X-CSE-ConnectionGUID: 6aQI+24NR8CE97iv5grDcQ==
X-CSE-MsgGUID: lBFxuUhXReKGoYtewNGlCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="74141551"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="74141551"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 01:41:35 -0700
X-CSE-ConnectionGUID: QnlBDgkcTaOqYfPdIBMwrg==
X-CSE-MsgGUID: As52cKYSQV+Zc4xb5wE3Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="219661399"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 09 Mar 2026 01:41:27 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vzWB3-000000002pl-2K7j;
	Mon, 09 Mar 2026 08:41:25 +0000
Date: Mon, 9 Mar 2026 09:40:41 +0100
From: kernel test robot <lkp@intel.com>
To: Sungwoo Kim <iam@sung-woo.kim>, Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	James Smart <james.smart@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, Sungwoo Kim <iam@sung-woo.kim>,
	Chao Shi <cshi008@fiu.edu>, Weidong Zhu <weizhu@fiu.edu>,
	Dave Tian <daveti@purdue.edu>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, nbd@other.debian.org,
	linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
	asahi@lists.linux.dev
Subject: Re: [PATCH] blk-mq: nvme: Fix general protection fault in
 nvme_setup_descriptor_pools()
Message-ID: <202603090911.0DdOwjTR-lkp@intel.com>
References: <20260309062840.2937858-2-iam@sung-woo.kim>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309062840.2937858-2-iam@sung-woo.kim>

Hi Sungwoo,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on device-mapper-dm/for-next linus/master v6.16-rc1 next-20260306]
[cannot apply to linux-nvme/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sungwoo-Kim/blk-mq-nvme-Fix-general-protection-fault-in-nvme_setup_descriptor_pools/20260309-143107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260309062840.2937858-2-iam%40sung-woo.kim
patch subject: [PATCH] blk-mq: nvme: Fix general protection fault in nvme_setup_descriptor_pools()
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260309/202603090911.0DdOwjTR-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260309/202603090911.0DdOwjTR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603090911.0DdOwjTR-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0308]: mismatched types
   --> rust/kernel/block/mq/operations.rs:274:28
   |
   274 |         init_request: Some(Self::init_request_callback),
   |                       ---- ^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected fn pointer, found fn item
   |                       |
   |                       arguments to this enum variant are incorrect
   |
   = note: expected fn pointer `unsafe extern "C" fn(_, _, _, i32) -> _`
   found fn item `unsafe extern "C" fn(_, _, _, u32) -> _ {block::mq::operations::OperationsVTable::<T>::init_request_callback}`
   help: the type constructed contains `unsafe extern "C" fn(*mut bindings::blk_mq_tag_set, *mut bindings::request, u32, u32) -> i32 {block::mq::operations::OperationsVTable::<T>::init_request_callback}` due to the type of the argument passed
   --> rust/kernel/block/mq/operations.rs:274:23
   |
   274 |         init_request: Some(Self::init_request_callback),
   |                       ^^^^^---------------------------^
   |                            |
   |                            this argument influences the type of `Some`
   note: tuple variant defined here
   --> /opt/cross/rustc-1.88.0-bindgen-0.72.1/rustup/toolchains/1.88.0-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/core/src/option.rs:597:5
   |
   597 |     Some(#[stable(feature = "rust1", since = "1.0.0")] T),
   |     ^^^^

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
