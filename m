Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8408C0015E
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691797220;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IFhBzsS+zABnv52nfFbYVbGIdAMPEZTP6gRSzeCz3hw=;
	b=XSca3tIt0o8t8Th/WVjERRuc79oriP8whXq97Werab7F9al+p378MhP7C0BdFV9qYHMBvq
	mXL4Rly//HhBD6pVBKtDt+LOGGMhis+kb776y1+uhvUUO6MzFptlN5T+ZQvP4vh8f7pr1F
	LdvH64uXzLJMrfzlLslfx5jXRbTU/0g=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-XrrW4JfhOjGKkjTzWtuL7g-1; Fri, 11 Aug 2023 19:40:17 -0400
X-MC-Unique: XrrW4JfhOjGKkjTzWtuL7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBEB61C07263;
	Fri, 11 Aug 2023 23:40:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E01032166B25;
	Fri, 11 Aug 2023 23:40:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A3BFB1946594;
	Fri, 11 Aug 2023 23:40:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0DB7D194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 23:40:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 289571121315; Fri, 11 Aug 2023 23:40:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 207DE1121314
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 23:40:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE9408011AD
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 23:40:04 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-WBV-5nVTPoyKBSQalt1uwA-1; Fri, 11 Aug 2023 19:40:03 -0400
X-MC-Unique: WBV-5nVTPoyKBSQalt1uwA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10799"; a="435677458"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; d="scan'208";a="435677458"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Aug 2023 16:40:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10799"; a="682698421"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; d="scan'208";a="682698421"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
 by orsmga003.jf.intel.com with ESMTP; 11 Aug 2023 16:39:54 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qUbjW-00086b-0G;
 Fri, 11 Aug 2023 23:39:54 +0000
Date: Sat, 12 Aug 2023 07:39:22 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202308120736.Od5Pc9vy-lkp@intel.com>
References: <20230811105300.15889-8-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230811105300.15889-8-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v14 07/11] nvme: add copy offload support
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
Cc: Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, dlemoal@kernel.org,
 oe-kbuild-all@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f7dc24b3413851109c4047b22997bd0d95ed52a2]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Introduce-queue-limits-and-sysfs-for-copy-offload-support/20230811-192259
base:   f7dc24b3413851109c4047b22997bd0d95ed52a2
patch link:    https://lore.kernel.org/r/20230811105300.15889-8-nj.shetty%40samsung.com
patch subject: [PATCH v14 07/11] nvme: add copy offload support
config: arm64-randconfig-r013-20230812 (https://download.01.org/0day-ci/archive/20230812/202308120736.Od5Pc9vy-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230812/202308120736.Od5Pc9vy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308120736.Od5Pc9vy-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/nvme/host/core.c:782:2: warning: variable 'dst_lba' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
     782 |         __rq_for_each_bio(bio, req) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/blk-mq.h:1008:6: note: expanded from macro '__rq_for_each_bio'
    1008 |         if ((rq->bio))                  \
         |             ^~~~~~~~~
   drivers/nvme/host/core.c:804:33: note: uninitialized use occurs here
     804 |         cmnd->copy.sdlba = cpu_to_le64(dst_lba);
         |                                        ^~~~~~~
   include/linux/byteorder/generic.h:86:21: note: expanded from macro 'cpu_to_le64'
      86 | #define cpu_to_le64 __cpu_to_le64
         |                     ^
   include/uapi/linux/byteorder/little_endian.h:32:51: note: expanded from macro '__cpu_to_le64'
      32 | #define __cpu_to_le64(x) ((__force __le64)(__u64)(x))
         |                                                   ^
   drivers/nvme/host/core.c:782:2: note: remove the 'if' if its condition is always true
     782 |         __rq_for_each_bio(bio, req) {
         |         ^
   include/linux/blk-mq.h:1008:2: note: expanded from macro '__rq_for_each_bio'
    1008 |         if ((rq->bio))                  \
         |         ^
   drivers/nvme/host/core.c:772:13: note: initialize the variable 'dst_lba' to silence this warning
     772 |         u64 dst_lba, src_lba, n_lba;
         |                    ^
         |                     = 0
   1 warning generated.


vim +782 drivers/nvme/host/core.c

   765	
   766	static inline blk_status_t nvme_setup_copy_offload(struct nvme_ns *ns,
   767							   struct request *req,
   768							   struct nvme_command *cmnd)
   769	{
   770		struct nvme_copy_range *range = NULL;
   771		struct bio *bio;
   772		u64 dst_lba, src_lba, n_lba;
   773		u16 nr_range = 1, control = 0, seg = 1;
   774	
   775		if (blk_rq_nr_phys_segments(req) != COPY_MAX_SEGMENTS)
   776			return BLK_STS_IOERR;
   777	
   778		/*
   779		 * First bio contains information about source and last bio contains
   780		 * information about destination.
   781		 */
 > 782		__rq_for_each_bio(bio, req) {
   783			if (seg == blk_rq_nr_phys_segments(req)) {
   784				dst_lba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
   785				if (n_lba != bio->bi_iter.bi_size >> ns->lba_shift)
   786					return BLK_STS_IOERR;
   787			} else {
   788				src_lba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
   789				n_lba = bio->bi_iter.bi_size >> ns->lba_shift;
   790			}
   791			seg++;
   792		}
   793	
   794		if (req->cmd_flags & REQ_FUA)
   795			control |= NVME_RW_FUA;
   796	
   797		if (req->cmd_flags & REQ_FAILFAST_DEV)
   798			control |= NVME_RW_LR;
   799	
   800		memset(cmnd, 0, sizeof(*cmnd));
   801		cmnd->copy.opcode = nvme_cmd_copy;
   802		cmnd->copy.nsid = cpu_to_le32(ns->head->ns_id);
   803		cmnd->copy.control = cpu_to_le16(control);
   804		cmnd->copy.sdlba = cpu_to_le64(dst_lba);
   805		cmnd->copy.nr_range = 0;
   806	
   807		range = kmalloc_array(nr_range, sizeof(*range),
   808				      GFP_ATOMIC | __GFP_NOWARN);
   809		if (!range)
   810			return BLK_STS_RESOURCE;
   811	
   812		range[0].slba = cpu_to_le64(src_lba);
   813		range[0].nlb = cpu_to_le16(n_lba - 1);
   814	
   815		req->special_vec.bv_page = virt_to_page(range);
   816		req->special_vec.bv_offset = offset_in_page(range);
   817		req->special_vec.bv_len = sizeof(*range) * nr_range;
   818		req->rq_flags |= RQF_SPECIAL_PAYLOAD;
   819	
   820		return BLK_STS_OK;
   821	}
   822	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

