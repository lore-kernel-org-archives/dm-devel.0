Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E375AC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 20:40:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6513A61042
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 20:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6513A61042
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-zsKKfevgN_SBzMCX8V5D6A-1; Tue, 17 Aug 2021 16:40:16 -0400
X-MC-Unique: zsKKfevgN_SBzMCX8V5D6A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B15F51937FC3;
	Tue, 17 Aug 2021 20:40:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E90760938;
	Tue, 17 Aug 2021 20:40:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9D4E24BB7B;
	Tue, 17 Aug 2021 20:40:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HKc4C0017253 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 16:38:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E4304115589D; Tue, 17 Aug 2021 20:38:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF07E1155898
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 20:38:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CE0689C7DE
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 20:38:01 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-585-W8_YbJanOc60HQ_3sw6bdQ-1; Tue, 17 Aug 2021 16:37:58 -0400
X-MC-Unique: W8_YbJanOc60HQ_3sw6bdQ-1
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="203386719"
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
	d="gz'50?scan'50,208,50";a="203386719"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
	by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	17 Aug 2021 13:36:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
	d="gz'50?scan'50,208,50";a="531221721"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
	by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2021 13:36:50 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1mG5pJ-000SBF-9L; Tue, 17 Aug 2021 20:36:49 +0000
Date: Wed, 18 Aug 2021 04:35:43 +0800
From: kernel test robot <lkp@intel.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
Message-ID: <202108180431.JPZU44Bn-lkp@intel.com>
References: <20210817101423.12367-4-selvakuma.s1@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20210817101423.12367-4-selvakuma.s1@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, damien.lemoal@wdc.com, kbuild-all@lists.01.org,
	linux-scsi@vger.kernel.org, linux-api@vger.kernel.org,
	kbusch@kernel.org, clang-built-linux@googlegroups.com,
	dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, asml.silence@gmail.com
Subject: Re: [dm-devel] [PATCH 3/7] block: copy offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi SelvaKumar,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on block/for-next]
[also build test WARNING on dm/for-next linus/master v5.14-rc6 next-20210817]
[cannot apply to linux-nvme/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/SelvaKumar-S/block-make-bio_map_kern-non-static/20210817-193111
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: hexagon-randconfig-r013-20210816 (attached as .config)
compiler: clang version 12.0.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/35fc502a7f20a7cd42432cee2777a621c40a3bd3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review SelvaKumar-S/block-make-bio_map_kern-non-static/20210817-193111
        git checkout 35fc502a7f20a7cd42432cee2777a621c40a3bd3
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=hexagon 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> block/blk-lib.c:197:5: warning: no previous prototype for function 'blk_copy_offload_submit_bio' [-Wmissing-prototypes]
   int blk_copy_offload_submit_bio(struct block_device *bdev,
       ^
   block/blk-lib.c:197:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int blk_copy_offload_submit_bio(struct block_device *bdev,
   ^
   static 
>> block/blk-lib.c:250:5: warning: no previous prototype for function 'blk_copy_offload_scc' [-Wmissing-prototypes]
   int blk_copy_offload_scc(struct block_device *src_bdev, int nr_srcs,
       ^
   block/blk-lib.c:250:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int blk_copy_offload_scc(struct block_device *src_bdev, int nr_srcs,
   ^
   static 
   2 warnings generated.


vim +/blk_copy_offload_submit_bio +197 block/blk-lib.c

   196	
 > 197	int blk_copy_offload_submit_bio(struct block_device *bdev,
   198			struct blk_copy_payload *payload, int payload_size,
   199			struct cio *cio, gfp_t gfp_mask)
   200	{
   201		struct request_queue *q = bdev_get_queue(bdev);
   202		struct bio *bio;
   203	
   204		bio = bio_map_kern(q, payload, payload_size, gfp_mask);
   205		if (IS_ERR(bio))
   206			return PTR_ERR(bio);
   207	
   208		bio_set_dev(bio, bdev);
   209		bio->bi_opf = REQ_OP_COPY | REQ_NOMERGE;
   210		bio->bi_iter.bi_sector = payload->dest;
   211		bio->bi_end_io = cio_bio_end_io;
   212		bio->bi_private = cio;
   213		atomic_inc(&cio->refcount);
   214		submit_bio(bio);
   215	
   216		return 0;
   217	}
   218	
   219	/* Go through all the enrties inside user provided payload, and determine the
   220	 * maximum number of entries in a payload, based on device's scc-limits.
   221	 */
   222	static inline int blk_max_payload_entries(int nr_srcs, struct range_entry *rlist,
   223			int max_nr_srcs, sector_t max_copy_range_sectors, sector_t max_copy_len)
   224	{
   225		sector_t range_len, copy_len = 0, remaining = 0;
   226		int ri = 0, pi = 1, max_pi = 0;
   227	
   228		for (ri = 0; ri < nr_srcs; ri++) {
   229			for (remaining = rlist[ri].len; remaining > 0; remaining -= range_len) {
   230				range_len = min3(remaining, max_copy_range_sectors,
   231									max_copy_len - copy_len);
   232				pi++;
   233				copy_len += range_len;
   234	
   235				if ((pi == max_nr_srcs) || (copy_len == max_copy_len)) {
   236					max_pi = max(max_pi, pi);
   237					pi = 1;
   238					copy_len = 0;
   239				}
   240			}
   241		}
   242	
   243		return max(max_pi, pi);
   244	}
   245	
   246	/*
   247	 * blk_copy_offload_scc	- Use device's native copy offload feature
   248	 * Go through user provide payload, prepare new payload based on device's copy offload limits.
   249	 */
 > 250	int blk_copy_offload_scc(struct block_device *src_bdev, int nr_srcs,
   251			struct range_entry *rlist, struct block_device *dest_bdev,
   252			sector_t dest, gfp_t gfp_mask)
   253	{
   254		struct request_queue *q = bdev_get_queue(dest_bdev);
   255		struct cio *cio = NULL;
   256		struct blk_copy_payload *payload;
   257		sector_t range_len, copy_len = 0, remaining = 0;
   258		sector_t src_blk, cdest = dest;
   259		sector_t max_copy_range_sectors, max_copy_len;
   260		int ri = 0, pi = 0, ret = 0, payload_size, max_pi, max_nr_srcs;
   261	
   262		cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
   263		if (!cio)
   264			return -ENOMEM;
   265		atomic_set(&cio->refcount, 0);
   266	
   267		max_nr_srcs = q->limits.max_copy_nr_ranges;
   268		max_copy_range_sectors = q->limits.max_copy_range_sectors;
   269		max_copy_len = q->limits.max_copy_sectors;
   270	
   271		max_pi = blk_max_payload_entries(nr_srcs, rlist, max_nr_srcs,
   272						max_copy_range_sectors, max_copy_len);
   273		payload_size = struct_size(payload, range, max_pi);
   274	
   275		payload = kvmalloc(payload_size, gfp_mask);
   276		if (!payload) {
   277			ret = -ENOMEM;
   278			goto free_cio;
   279		}
   280		payload->src_bdev = src_bdev;
   281	
   282		for (ri = 0; ri < nr_srcs; ri++) {
   283			for (remaining = rlist[ri].len, src_blk = rlist[ri].src; remaining > 0;
   284							remaining -= range_len, src_blk += range_len) {
   285	
   286				range_len = min3(remaining, max_copy_range_sectors,
   287									max_copy_len - copy_len);
   288				payload->range[pi].len = range_len;
   289				payload->range[pi].src = src_blk;
   290				pi++;
   291				copy_len += range_len;
   292	
   293				/* Submit current payload, if crossing device copy limits */
   294				if ((pi == max_nr_srcs) || (copy_len == max_copy_len)) {
   295					payload->dest = cdest;
   296					payload->copy_nr_ranges = pi;
   297					ret = blk_copy_offload_submit_bio(dest_bdev, payload,
   298									payload_size, cio, gfp_mask);
   299					if (ret)
   300						goto free_payload;
   301	
   302					/* reset index, length and allocate new payload */
   303					pi = 0;
   304					cdest += copy_len;
   305					copy_len = 0;
   306					payload = kvmalloc(payload_size, gfp_mask);
   307					if (!payload) {
   308						ret = -ENOMEM;
   309						goto free_cio;
   310					}
   311					payload->src_bdev = src_bdev;
   312				}
   313			}
   314		}
   315	
   316		if (pi) {
   317			payload->dest = cdest;
   318			payload->copy_nr_ranges = pi;
   319			ret = blk_copy_offload_submit_bio(dest_bdev, payload, payload_size, cio, gfp_mask);
   320			if (ret)
   321				goto free_payload;
   322		}
   323	
   324		/* Wait for completion of all IO's*/
   325		ret = cio_await_completion(cio);
   326	
   327		return ret;
   328	
   329	free_payload:
   330		kvfree(payload);
   331	free_cio:
   332		cio_await_completion(cio);
   333		return ret;
   334	}
   335	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--HcAYCG3uE/tztfnV
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--HcAYCG3uE/tztfnV--

