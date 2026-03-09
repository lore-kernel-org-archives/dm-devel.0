Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EBD22A1D4;
	Mon,  9 Mar 2026 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773071152; cv=none; b=Pupdwpm5lsWYXpyj2OFzjhTa2hVFHbwk7dfQhhT1DsgJsPisyXCPIlyqfNbrUpyn0qfnVK5uIIDlw9P/UnoMG5T6Qk7h0D4RwNNuqVcqtbAEJMXWxTA686C8Lry66Z4cI7xSvWrLlvd/+jVDJBA3NEHazCRJiI3QoYZZ/MQPQvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773071152; c=relaxed/simple;
	bh=rCt8TwEoX6RUjX3Ol5H8E1fQFJJiWpMnctAnEqxheAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BrdZAcUZkWA7XuKF9YLPJw252S6JKTRUytVCRX+oCN7FfA5+NEmB/teHi0FW5dP/zzuHip53cUjNKTa5ESISmt0kRXedPs3blIAMDGjCvZj11DhuTsa6AhYLB9Qni0kJFOCGh+FoIFSDIcA3847QfJXu4Ddrm33QtMmLYESnKuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khPM7IdR; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khPM7IdR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773071150; x=1804607150;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rCt8TwEoX6RUjX3Ol5H8E1fQFJJiWpMnctAnEqxheAo=;
  b=khPM7IdR9MFli8rDH937Lsm8dp9Dmg8V5j4dCYencoORJTX4yHnnIVzM
   zQpGeMlD4mpxF/xzhbYlxP52JY46s/3DoYbGlyGXBox6yBudBW4SBmWlD
   o9+L8CulA1Vr4CzUf74rLMyxmOX1C+PDhmNGZgjrCIXU3hKCDKTRUlQeM
   WYvnOjbR6hXadCQcJQijPs3n0WYAI0F8Yje72n0xeWjwzTyVzDnj/9eHg
   0K1pJzceiUOjRQ7UldzLpysiLyDjSypPtvW3R4usgME96HagjZwalSQn6
   bFSXMy6Npqvx1Q23BWl4Ti3SoiaVfQ31iofug+kw1IwqH1/7jYf7UH3bZ
   w==;
X-CSE-ConnectionGUID: bsE6bDQSQ4eiXB/X8DogJg==
X-CSE-MsgGUID: PYIJBvPyQDWpI683vnN/cQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="84425193"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="84425193"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 08:45:45 -0700
X-CSE-ConnectionGUID: OMDR4XcbRTSxWzhtRo1HIw==
X-CSE-MsgGUID: rFUv7x1wQnqy+hBWujFnNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="218939094"
Received: from lkp-server01.sh.intel.com (HELO 434e41ea3c86) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 09 Mar 2026 08:45:38 -0700
Received: from kbuild by 434e41ea3c86 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vzcnV-000000000Rw-12zd;
	Mon, 09 Mar 2026 15:45:33 +0000
Date: Mon, 9 Mar 2026 23:44:44 +0800
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
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>, Chao Shi <cshi008@fiu.edu>,
	Weidong Zhu <weizhu@fiu.edu>, Dave Tian <daveti@purdue.edu>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	nbd@other.debian.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, asahi@lists.linux.dev
Subject: Re: [PATCH] blk-mq: nvme: Fix general protection fault in
 nvme_setup_descriptor_pools()
Message-ID: <202603092305.jcWVkoXK-lkp@intel.com>
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
[also build test ERROR on device-mapper-dm/for-next linus/master v7.0-rc3 next-20260306]
[cannot apply to linux-nvme/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sungwoo-Kim/blk-mq-nvme-Fix-general-protection-fault-in-nvme_setup_descriptor_pools/20260309-143107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260309062840.2937858-2-iam%40sung-woo.kim
patch subject: [PATCH] blk-mq: nvme: Fix general protection fault in nvme_setup_descriptor_pools()
config: x86_64-randconfig-074-20260309 (https://download.01.org/0day-ci/archive/20260309/202603092305.jcWVkoXK-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260309/202603092305.jcWVkoXK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603092305.jcWVkoXK-lkp@intel.com/

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
   found fn item `unsafe extern "C" fn(_, _, _, u32) -> _ {OperationsVTable::<T>::init_request_callback}`
   help: the type constructed contains `unsafe extern "C" fn(*mut blk_mq_tag_set, *mut bindings::request, u32, u32) -> i32 {OperationsVTable::<T>::init_request_callback}` due to the type of the argument passed
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
