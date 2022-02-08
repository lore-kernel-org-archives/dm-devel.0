Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1F2C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:38:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-Nm6I_SBrNSKM_MoRuxxCxw-1; Tue, 08 Feb 2022 17:38:07 -0500
X-MC-Unique: Nm6I_SBrNSKM_MoRuxxCxw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CF8218C8C20;
	Tue,  8 Feb 2022 22:38:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E7585E481;
	Tue,  8 Feb 2022 22:38:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 537C3473CF;
	Tue,  8 Feb 2022 22:38:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2183LHRF006316 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 22:21:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5DD342026D5D; Tue,  8 Feb 2022 03:21:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58ED72026D4D
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 03:21:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C9651044560
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 03:21:14 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-297-xwnmVbXzPVK9gBM-aZWNxg-1; Mon, 07 Feb 2022 22:21:12 -0500
X-MC-Unique: xwnmVbXzPVK9gBM-aZWNxg-1
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="312159786"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; d="scan'208";a="312159786"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
	by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	07 Feb 2022 19:21:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; d="scan'208";a="499422663"
Received: from lkp-server01.sh.intel.com (HELO 9dd77a123018) ([10.239.97.150])
	by orsmga002.jf.intel.com with ESMTP; 07 Feb 2022 19:21:08 -0800
Received: from kbuild by 9dd77a123018 with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nHH3z-0001He-La; Tue, 08 Feb 2022 03:21:07 +0000
Date: Tue, 8 Feb 2022 11:20:49 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, mpatocka@redhat.com
Message-ID: <202202081132.axCkiVgv-lkp@intel.com>
References: <20220207141348.4235-6-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220207141348.4235-6-nj.shetty@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, javier@javigon.com, msnitzer@redhat.com,
	kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
	chaitanyak@nvidia.com, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 05/10] block: add emulation for copy
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
config: nios2-randconfig-r001-20220207 (https://download.01.org/0day-ci/archive/20220208/202202081132.axCkiVgv-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/a7bb30870db803af4ad955a968992222bcfb478f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
        git checkout a7bb30870db803af4ad955a968992222bcfb478f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   block/blk-lib.c:185:5: warning: no previous prototype for 'blk_copy_offload' [-Wmissing-prototypes]
     185 | int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
         |     ^~~~~~~~~~~~~~~~
>> block/blk-lib.c:275:5: warning: no previous prototype for 'blk_submit_rw_buf' [-Wmissing-prototypes]
     275 | int blk_submit_rw_buf(struct block_device *bdev, void *buf, sector_t buf_len,
         |     ^~~~~~~~~~~~~~~~~


vim +/blk_submit_rw_buf +275 block/blk-lib.c

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
 > 275	int blk_submit_rw_buf(struct block_device *bdev, void *buf, sector_t buf_len,
   276					sector_t sector, unsigned int op, gfp_t gfp_mask)
   277	{
   278		struct request_queue *q = bdev_get_queue(bdev);
   279		struct bio *bio, *parent = NULL;
   280		sector_t max_hw_len = min_t(unsigned int, queue_max_hw_sectors(q),
   281				queue_max_segments(q) << (PAGE_SHIFT - SECTOR_SHIFT)) << SECTOR_SHIFT;
   282		sector_t len, remaining;
   283		int ret;
   284	
   285		for (remaining = buf_len; remaining > 0; remaining -= len) {
   286			len = min_t(int, max_hw_len, remaining);
   287	retry:
   288			bio = bio_map_kern(q, buf, len, gfp_mask);
   289			if (IS_ERR(bio)) {
   290				len >>= 1;
   291				if (len)
   292					goto retry;
   293				return PTR_ERR(bio);
   294			}
   295	
   296			bio->bi_iter.bi_sector = sector >> SECTOR_SHIFT;
   297			bio->bi_opf = op;
   298			bio_set_dev(bio, bdev);
   299			bio->bi_end_io = NULL;
   300			bio->bi_private = NULL;
   301	
   302			if (parent) {
   303				bio_chain(parent, bio);
   304				submit_bio(parent);
   305			}
   306			parent = bio;
   307			sector += len;
   308			buf = (char *) buf + len;
   309		}
   310		ret = submit_bio_wait(bio);
   311		bio_put(bio);
   312	
   313		return ret;
   314	}
   315	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

