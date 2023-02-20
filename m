Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C87EFC05027
	for <dm-devel@archiver.kernel.org>; Mon, 20 Feb 2023 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676906322;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LIztUwVtUlaayuylDn5I2RYplrHIoZuCcCOSTZQWrGg=;
	b=K5R7kA0/QhvJf4ktov003zdlTM2Wek8z621XB1kUj8CCabnPMjn+/asS7Y9UTbv18gl5qm
	C607+ZP/el3XlhoONHZr+pLq1My5G0RDmoPTvgPSsNdYtAh2ZzjMbcYxOkrkTz9+jbJsmV
	QPX+1cNwUqw2VqB8oEPhC8bWFzgzgjk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-OSciWY32PvGYcj1C15ewJg-1; Mon, 20 Feb 2023 10:18:39 -0500
X-MC-Unique: OSciWY32PvGYcj1C15ewJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AABC8100F827;
	Mon, 20 Feb 2023 15:18:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 501341121314;
	Mon, 20 Feb 2023 15:18:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C7381946588;
	Mon, 20 Feb 2023 15:18:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B88111946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Feb 2023 15:18:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95BF32026D68; Mon, 20 Feb 2023 15:18:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EBFD2026D4B
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 15:18:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F6BA185A794
 for <dm-devel@redhat.com>; Mon, 20 Feb 2023 15:18:30 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-GJKjl3GFMpeodCfWYbTNlQ-1; Mon, 20 Feb 2023 10:18:28 -0500
X-MC-Unique: GJKjl3GFMpeodCfWYbTNlQ-1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="331087858"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; d="scan'208";a="331087858"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 20 Feb 2023 07:18:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="814167593"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; d="scan'208";a="814167593"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
 by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2023 07:18:21 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1pU7vo-000E13-1K;
 Mon, 20 Feb 2023 15:18:20 +0000
Date: Mon, 20 Feb 2023 23:18:00 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Message-ID: <202302202321.zfUe705N-lkp@intel.com>
References: <20230220105336.3810-5-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230220105336.3810-5-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v7 4/8] fs,
 block: copy_file_range for def_blk_ops for direct block device.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: bvanassche@acm.org, joshi.k@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, damien.lemoal@opensource.wdc.com,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on device-mapper-dm/for-next]
[also build test WARNING on linus/master v6.2 next-20230220]
[cannot apply to axboe-block/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Add-copy-offload-support-infrastructure/20230220-205057
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
patch link:    https://lore.kernel.org/r/20230220105336.3810-5-nj.shetty%40samsung.com
patch subject: [PATCH v7 4/8] fs, block: copy_file_range for def_blk_ops for direct block device.
config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20230220/202302202321.zfUe705N-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0f95ad2cb727ac6ac8406a01ff216d9237b403b7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-Add-copy-offload-support-infrastructure/20230220-205057
        git checkout 0f95ad2cb727ac6ac8406a01ff216d9237b403b7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302202321.zfUe705N-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> block/fops.c:614:9: warning: no previous prototype for 'blkdev_copy_file_range' [-Wmissing-prototypes]
     614 | ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_in,
         |         ^~~~~~~~~~~~~~~~~~~~~~


vim +/blkdev_copy_file_range +614 block/fops.c

   613	
 > 614	ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_in,
   615					struct file *file_out, loff_t pos_out,
   616					size_t len, unsigned int flags)
   617	{
   618		struct block_device *in_bdev = I_BDEV(bdev_file_inode(file_in));
   619		struct block_device *out_bdev = I_BDEV(bdev_file_inode(file_out));
   620		int comp_len;
   621	
   622		comp_len = blkdev_copy_offload(in_bdev, pos_in, out_bdev, pos_out, len,
   623				    NULL, NULL, GFP_KERNEL);
   624		if (comp_len != len)
   625			comp_len = generic_copy_file_range(file_in, pos_in + comp_len,
   626				file_out, pos_out + comp_len, len - comp_len, flags);
   627	
   628		return comp_len;
   629	}
   630	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

