Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DBDC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:36:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-TstPzP7oNdq4ZRlTXuhqTQ-1; Tue, 08 Feb 2022 17:36:06 -0500
X-MC-Unique: TstPzP7oNdq4ZRlTXuhqTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26DF21124C44;
	Tue,  8 Feb 2022 22:36:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F23404CEEC;
	Tue,  8 Feb 2022 22:36:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CC64050039;
	Tue,  8 Feb 2022 22:36:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217MkGD6018030 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 17:46:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 52FE81402406; Mon,  7 Feb 2022 22:46:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F1C31402403
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 22:46:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F8A73803502
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 22:46:16 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-475-JVkpnfkNNfSpuWhgucH_FA-1; Mon, 07 Feb 2022 17:46:14 -0500
X-MC-Unique: JVkpnfkNNfSpuWhgucH_FA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="335225442"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; d="scan'208";a="335225442"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
	by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	07 Feb 2022 14:46:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; d="scan'208";a="677911526"
Received: from lkp-server01.sh.intel.com (HELO 9dd77a123018) ([10.239.97.150])
	by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2022 14:45:57 -0800
Received: from kbuild by 9dd77a123018 with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nHClh-00013p-3V; Mon, 07 Feb 2022 22:45:57 +0000
Date: Tue, 8 Feb 2022 06:45:20 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, mpatocka@redhat.com
Message-ID: <202202080650.48C9Ps00-lkp@intel.com>
References: <20220207141348.4235-4-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220207141348.4235-4-nj.shetty@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, javier@javigon.com, msnitzer@redhat.com,
	kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
	chaitanyak@nvidia.com, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 03/10] block: Add copy offload support
	infrastructure
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on next-20220207]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: nios2-randconfig-r001-20220207 (https://download.01.org/0day-ci/archive/20220208/202202080650.48C9Ps00-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/12a9801a7301f1a1e2ea355c5a4438dab17894cf
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
        git checkout 12a9801a7301f1a1e2ea355c5a4438dab17894cf
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> block/blk-lib.c:185:5: warning: no previous prototype for 'blk_copy_offload' [-Wmissing-prototypes]
     185 | int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
         |     ^~~~~~~~~~~~~~~~


vim +/blk_copy_offload +185 block/blk-lib.c

   180	
   181	/*
   182	 * blk_copy_offload	- Use device's native copy offload feature
   183	 * Go through user provide payload, prepare new payload based on device's copy offload limits.
   184	 */
 > 185	int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
   186			struct range_entry *rlist, struct block_device *dst_bdev, gfp_t gfp_mask)
   187	{
   188		struct request_queue *sq = bdev_get_queue(src_bdev);
   189		struct request_queue *dq = bdev_get_queue(dst_bdev);
   190		struct bio *read_bio, *write_bio;
   191		struct copy_ctx *ctx;
   192		struct cio *cio;
   193		struct page *token;
   194		sector_t src_blk, copy_len, dst_blk;
   195		sector_t remaining, max_copy_len = LONG_MAX;
   196		int ri = 0, ret = 0;
   197	
   198		cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
   199		if (!cio)
   200			return -ENOMEM;
   201		atomic_set(&cio->refcount, 0);
   202		cio->rlist = rlist;
   203	
   204		max_copy_len = min3(max_copy_len, (sector_t)sq->limits.max_copy_sectors,
   205				(sector_t)dq->limits.max_copy_sectors);
   206		max_copy_len = min3(max_copy_len, (sector_t)sq->limits.max_copy_range_sectors,
   207				(sector_t)dq->limits.max_copy_range_sectors) << SECTOR_SHIFT;
   208	
   209		for (ri = 0; ri < nr_srcs; ri++) {
   210			cio->rlist[ri].comp_len = rlist[ri].len;
   211			for (remaining = rlist[ri].len, src_blk = rlist[ri].src, dst_blk = rlist[ri].dst;
   212				remaining > 0;
   213				remaining -= copy_len, src_blk += copy_len, dst_blk += copy_len) {
   214				copy_len = min(remaining, max_copy_len);
   215	
   216				token = alloc_page(gfp_mask);
   217				if (unlikely(!token)) {
   218					ret = -ENOMEM;
   219					goto err_token;
   220				}
   221	
   222				read_bio = bio_alloc(src_bdev, 1, REQ_OP_READ | REQ_COPY | REQ_NOMERGE,
   223						gfp_mask);
   224				if (!read_bio) {
   225					ret = -ENOMEM;
   226					goto err_read_bio;
   227				}
   228				read_bio->bi_iter.bi_sector = src_blk >> SECTOR_SHIFT;
   229				read_bio->bi_iter.bi_size = copy_len;
   230				__bio_add_page(read_bio, token, PAGE_SIZE, 0);
   231				ret = submit_bio_wait(read_bio);
   232				if (ret) {
   233					bio_put(read_bio);
   234					goto err_read_bio;
   235				}
   236				bio_put(read_bio);
   237				ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
   238				if (!ctx) {
   239					ret = -ENOMEM;
   240					goto err_read_bio;
   241				}
   242				ctx->cio = cio;
   243				ctx->range_idx = ri;
   244				ctx->start_sec = rlist[ri].src;
   245	
   246				write_bio = bio_alloc(dst_bdev, 1, REQ_OP_WRITE | REQ_COPY | REQ_NOMERGE,
   247						gfp_mask);
   248				if (!write_bio) {
   249					ret = -ENOMEM;
   250					goto err_read_bio;
   251				}
   252	
   253				write_bio->bi_iter.bi_sector = dst_blk >> SECTOR_SHIFT;
   254				write_bio->bi_iter.bi_size = copy_len;
   255				__bio_add_page(write_bio, token, PAGE_SIZE, 0);
   256				write_bio->bi_end_io = bio_copy_end_io;
   257				write_bio->bi_private = ctx;
   258				atomic_inc(&cio->refcount);
   259				submit_bio(write_bio);
   260			}
   261		}
   262	
   263		/* Wait for completion of all IO's*/
   264		return cio_await_completion(cio);
   265	
   266	err_read_bio:
   267		__free_page(token);
   268	err_token:
   269		rlist[ri].comp_len = min_t(sector_t, rlist[ri].comp_len, (rlist[ri].len - remaining));
   270	
   271		cio->io_err = ret;
   272		return cio_await_completion(cio);
   273	}
   274	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

