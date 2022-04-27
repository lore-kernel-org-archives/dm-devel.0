Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E5B4C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 00:18:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-gv-c8_1ANROqCBfWDbemTg-1; Tue, 26 Apr 2022 20:18:33 -0400
X-MC-Unique: gv-c8_1ANROqCBfWDbemTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B9731C0BF10;
	Wed, 27 Apr 2022 00:18:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F37A9111F3C7;
	Wed, 27 Apr 2022 00:18:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B4BF51947BBE;
	Wed, 27 Apr 2022 00:18:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 715D919451F0
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 00:12:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B12D40D0161; Wed, 27 Apr 2022 00:12:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 467E740D0160
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 00:12:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CD213810789
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 00:12:27 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-7tK3esv_Mf66y14S8oc-iA-1; Tue, 26 Apr 2022 20:12:23 -0400
X-MC-Unique: 7tK3esv_Mf66y14S8oc-iA-1
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265286170"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; d="scan'208";a="265286170"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
 by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 26 Apr 2022 17:12:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; d="scan'208";a="807761334"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
 by fmsmga006.fm.intel.com with ESMTP; 26 Apr 2022 17:12:14 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1njVHx-00046e-BM;
 Wed, 27 Apr 2022 00:12:13 +0000
Date: Wed, 27 Apr 2022 08:11:24 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <202204270754.pM0Ewhl5-lkp@intel.com>
References: <20220426101241.30100-3-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220426101241.30100-3-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v4 02/10] block: Add copy offload support
 infrastructure
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
Cc: djwong@kernel.org, llvm@lists.linux.dev, linux-nvme@lists.infradead.org,
 clm@fb.com, dm-devel@redhat.com, osandov@fb.com,
 Alasdair Kergon <agk@redhat.com>, msnitzer@redhat.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de,
 Nitesh Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
 Mike Snitzer <snitzer@kernel.org>, josef@toxicpanda.com,
 linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
 tytso@mit.edu, Frederick.Knight@netapp.com, Sagi Grimberg <sagi@grimberg.me>,
 axboe@kernel.dk, kbuild-all@lists.01.org, martin.petersen@oracle.com,
 Arnav Dawn <arnav.dawn@samsung.com>, jack@suse.com,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
config: hexagon-randconfig-r041-20220425 (https://download.01.org/0day-ci/archive/20220427/202204270754.pM0Ewhl5-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 1cddcfdc3c683b393df1a5c9063252eb60e52818)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3e91cba65ef73ba116953031d5548da7fd33a150
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-Introduce-queue-limits-for-copy-offload-support/20220426-201825
        git checkout 3e91cba65ef73ba116953031d5548da7fd33a150
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> block/blk-lib.c:178:5: warning: no previous prototype for function 'blk_copy_offload' [-Wmissing-prototypes]
   int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
       ^
   block/blk-lib.c:178:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
   ^
   static 
   1 warning generated.


vim +/blk_copy_offload +178 block/blk-lib.c

   173	
   174	/*
   175	 * blk_copy_offload	- Use device's native copy offload feature
   176	 * Go through user provide payload, prepare new payload based on device's copy offload limits.
   177	 */
 > 178	int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
   179			struct range_entry *rlist, struct block_device *dst_bdev, gfp_t gfp_mask)
   180	{
   181		struct request_queue *sq = bdev_get_queue(src_bdev);
   182		struct request_queue *dq = bdev_get_queue(dst_bdev);
   183		struct bio *read_bio, *write_bio;
   184		struct copy_ctx *ctx;
   185		struct cio *cio;
   186		struct page *token;
   187		sector_t src_blk, copy_len, dst_blk;
   188		sector_t remaining, max_copy_len = LONG_MAX;
   189		unsigned long flags;
   190		int ri = 0, ret = 0;
   191	
   192		cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
   193		if (!cio)
   194			return -ENOMEM;
   195		cio->rlist = rlist;
   196		spin_lock_init(&cio->lock);
   197	
   198		max_copy_len = min_t(sector_t, sq->limits.max_copy_sectors, dq->limits.max_copy_sectors);
   199		max_copy_len = min3(max_copy_len, (sector_t)sq->limits.max_copy_range_sectors,
   200				(sector_t)dq->limits.max_copy_range_sectors) << SECTOR_SHIFT;
   201	
   202		for (ri = 0; ri < nr_srcs; ri++) {
   203			cio->rlist[ri].comp_len = rlist[ri].len;
   204			src_blk = rlist[ri].src;
   205			dst_blk = rlist[ri].dst;
   206			for (remaining = rlist[ri].len; remaining > 0; remaining -= copy_len) {
   207				copy_len = min(remaining, max_copy_len);
   208	
   209				token = alloc_page(gfp_mask);
   210				if (unlikely(!token)) {
   211					ret = -ENOMEM;
   212					goto err_token;
   213				}
   214	
   215				ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
   216				if (!ctx) {
   217					ret = -ENOMEM;
   218					goto err_ctx;
   219				}
   220				ctx->cio = cio;
   221				ctx->range_idx = ri;
   222				ctx->start_sec = dst_blk;
   223	
   224				read_bio = bio_alloc(src_bdev, 1, REQ_OP_READ | REQ_COPY | REQ_NOMERGE,
   225						gfp_mask);
   226				if (!read_bio) {
   227					ret = -ENOMEM;
   228					goto err_read_bio;
   229				}
   230				read_bio->bi_iter.bi_sector = src_blk >> SECTOR_SHIFT;
   231				__bio_add_page(read_bio, token, PAGE_SIZE, 0);
   232				/*__bio_add_page increases bi_size by len, so overwrite it with copy len*/
   233				read_bio->bi_iter.bi_size = copy_len;
   234				ret = submit_bio_wait(read_bio);
   235				bio_put(read_bio);
   236				if (ret)
   237					goto err_read_bio;
   238	
   239				write_bio = bio_alloc(dst_bdev, 1, REQ_OP_WRITE | REQ_COPY | REQ_NOMERGE,
   240						gfp_mask);
   241				if (!write_bio) {
   242					ret = -ENOMEM;
   243					goto err_read_bio;
   244				}
   245				write_bio->bi_iter.bi_sector = dst_blk >> SECTOR_SHIFT;
   246				__bio_add_page(write_bio, token, PAGE_SIZE, 0);
   247				/*__bio_add_page increases bi_size by len, so overwrite it with copy len*/
   248				write_bio->bi_iter.bi_size = copy_len;
   249				write_bio->bi_end_io = bio_copy_end_io;
   250				write_bio->bi_private = ctx;
   251	
   252				spin_lock_irqsave(&cio->lock, flags);
   253				++cio->refcount;
   254				spin_unlock_irqrestore(&cio->lock, flags);
   255	
   256				submit_bio(write_bio);
   257				src_blk += copy_len;
   258				dst_blk += copy_len;
   259			}
   260		}
   261	
   262		/* Wait for completion of all IO's*/
   263		return cio_await_completion(cio);
   264	
   265	err_read_bio:
   266		kfree(ctx);
   267	err_ctx:
   268		__free_page(token);
   269	err_token:
   270		rlist[ri].comp_len = min_t(sector_t, rlist[ri].comp_len, (rlist[ri].len - remaining));
   271	
   272		cio->io_err = ret;
   273		return cio_await_completion(cio);
   274	}
   275	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

