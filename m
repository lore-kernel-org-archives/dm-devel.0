Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87810C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 01:33:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-V6HCZdSjOyCYPwJY7YCr8w-1; Tue, 26 Apr 2022 21:33:33 -0400
X-MC-Unique: V6HCZdSjOyCYPwJY7YCr8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 278023810791;
	Wed, 27 Apr 2022 01:33:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 781E040D282D;
	Wed, 27 Apr 2022 01:33:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 37FDA1947BBE;
	Wed, 27 Apr 2022 01:33:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2598C19451F0
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 01:33:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DA294C28139; Wed, 27 Apr 2022 01:33:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D663EC28137
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 01:33:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B99AD83395E
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 01:33:28 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-i917fgjTO6uUzmH2IyhZ2Q-1; Tue, 26 Apr 2022 21:33:24 -0400
X-MC-Unique: i917fgjTO6uUzmH2IyhZ2Q-1
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="290927489"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; d="scan'208";a="290927489"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 26 Apr 2022 18:33:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; d="scan'208";a="617279875"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
 by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2022 18:33:17 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1njWYO-0004BM-D3;
 Wed, 27 Apr 2022 01:33:16 +0000
Date: Wed, 27 Apr 2022 09:33:04 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <202204270913.Ecb3uQx1-lkp@intel.com>
References: <20220426101241.30100-5-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220426101241.30100-5-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v4 04/10] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, djwong@kernel.org,
 llvm@lists.linux.dev, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 msnitzer@redhat.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
 gost.dev@samsung.com, nitheshshetty@gmail.com, hch@lst.de,
 Nitesh Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
 Mike Snitzer <snitzer@kernel.org>, josef@toxicpanda.com,
 linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
 tytso@mit.edu, Frederick.Knight@netapp.com, Sagi Grimberg <sagi@grimberg.me>,
 axboe@kernel.dk, kbuild-all@lists.01.org, martin.petersen@oracle.com,
 Arnav Dawn <arnav.dawn@samsung.com>, jack@suse.com,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20220422]
[cannot apply to axboe-block/for-next device-mapper-dm/for-next linus/master v5.18-rc4 v5.18-rc3 v5.18-rc2 v5.18-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Introduce-queue-limits-for-copy-offload-support/20220426-201825
base:    e7d6987e09a328d4a949701db40ef63fbb970670
config: hexagon-randconfig-r041-20220425 (https://download.01.org/0day-ci/archive/20220427/202204270913.Ecb3uQx1-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 1cddcfdc3c683b393df1a5c9063252eb60e52818)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c406c5145dc7d628d4197f6726c23a3f1179b88e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-Introduce-queue-limits-for-copy-offload-support/20220426-201825
        git checkout c406c5145dc7d628d4197f6726c23a3f1179b88e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   block/blk-lib.c:178:5: warning: no previous prototype for function 'blk_copy_offload' [-Wmissing-prototypes]
   int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
       ^
   block/blk-lib.c:178:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
   ^
   static 
>> block/blk-lib.c:276:5: warning: no previous prototype for function 'blk_submit_rw_buf' [-Wmissing-prototypes]
   int blk_submit_rw_buf(struct block_device *bdev, void *buf, sector_t buf_len,
       ^
   block/blk-lib.c:276:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int blk_submit_rw_buf(struct block_device *bdev, void *buf, sector_t buf_len,
   ^
   static 
   2 warnings generated.


vim +/blk_submit_rw_buf +276 block/blk-lib.c

   275	
 > 276	int blk_submit_rw_buf(struct block_device *bdev, void *buf, sector_t buf_len,
   277					sector_t sector, unsigned int op, gfp_t gfp_mask)
   278	{
   279		struct request_queue *q = bdev_get_queue(bdev);
   280		struct bio *bio, *parent = NULL;
   281		sector_t max_hw_len = min_t(unsigned int, queue_max_hw_sectors(q),
   282				queue_max_segments(q) << (PAGE_SHIFT - SECTOR_SHIFT)) << SECTOR_SHIFT;
   283		sector_t len, remaining;
   284		int ret;
   285	
   286		for (remaining = buf_len; remaining > 0; remaining -= len) {
   287			len = min_t(int, max_hw_len, remaining);
   288	retry:
   289			bio = bio_map_kern(q, buf, len, gfp_mask);
   290			if (IS_ERR(bio)) {
   291				len >>= 1;
   292				if (len)
   293					goto retry;
   294				return PTR_ERR(bio);
   295			}
   296	
   297			bio->bi_iter.bi_sector = sector >> SECTOR_SHIFT;
   298			bio->bi_opf = op;
   299			bio_set_dev(bio, bdev);
   300			bio->bi_end_io = NULL;
   301			bio->bi_private = NULL;
   302	
   303			if (parent) {
   304				bio_chain(parent, bio);
   305				submit_bio(parent);
   306			}
   307			parent = bio;
   308			sector += len;
   309			buf = (char *) buf + len;
   310		}
   311		ret = submit_bio_wait(bio);
   312		bio_put(bio);
   313	
   314		return ret;
   315	}
   316	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

