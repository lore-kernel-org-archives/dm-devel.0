Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB8E5EB64D7
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687956980;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dc+XjJ9z8tKcnAofV7+1mUgtMhhB5/5kmERflGcqOxs=;
	b=G91K3naemqafoD9exULP6ealbI0FU+QRrpD9ml+fCfHnmCIwET1RQyWyKLyNUEDeMsuHKy
	WC5kdZzfz87eqnj/ThVrVz0hP/cbEaCqR21WRc/rE5DKtEwV7WL1TUOc4R+4qM3XYwO1LT
	P2hdkc1b88slOSlEUvE3T9RwiCSZ7rg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-4zEoKCxpPrC53qn7CH639A-1; Wed, 28 Jun 2023 08:56:16 -0400
X-MC-Unique: 4zEoKCxpPrC53qn7CH639A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBE012814258;
	Wed, 28 Jun 2023 12:56:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3748CF5CE0;
	Wed, 28 Jun 2023 12:56:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF4331946589;
	Wed, 28 Jun 2023 12:56:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A00BE1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Jun 2023 12:52:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C5FF40C206F; Wed, 28 Jun 2023 12:52:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7453F40C2063
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 12:52:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5892C92E4C0
 for <dm-devel@redhat.com>; Wed, 28 Jun 2023 12:52:54 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-GwfC1-r5O5-D3i4ckYwAIQ-1; Wed, 28 Jun 2023 08:52:52 -0400
X-MC-Unique: GwfC1-r5O5-D3i4ckYwAIQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="427840693"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; d="scan'208";a="427840693"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Jun 2023 05:52:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="752247641"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; d="scan'208";a="752247641"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
 by orsmga001.jf.intel.com with ESMTP; 28 Jun 2023 05:52:41 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qEUf2-000DGN-2m;
 Wed, 28 Jun 2023 12:52:40 +0000
Date: Wed, 28 Jun 2023 20:52:40 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202306282001.ba1qWTf0-lkp@intel.com>
References: <20230627183629.26571-10-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230627183629.26571-10-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v13 9/9] null_blk: add support for copy
 offload
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
Cc: Anuj Gupta <anuj20.g@samsung.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>,
 djwong@kernel.org, nitheshshetty@gmail.com, llvm@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, willy@infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 oe-kbuild-all@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 gost.dev@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
 bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 53cdf865f90ba922a854c65ed05b519f9d728424]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Introduce-queue-limits-for-copy-offload-support/20230628-163126
base:   53cdf865f90ba922a854c65ed05b519f9d728424
patch link:    https://lore.kernel.org/r/20230627183629.26571-10-nj.shetty%40samsung.com
patch subject: [PATCH v13 9/9] null_blk: add support for copy offload
config: i386-randconfig-i006-20230628 (https://download.01.org/0day-ci/archive/20230628/202306282001.ba1qWTf0-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230628/202306282001.ba1qWTf0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306282001.ba1qWTf0-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/block/null_blk/main.c:1295:2: warning: variable 'rem' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           __rq_for_each_bio(bio, req) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/blk-mq.h:1012:6: note: expanded from macro '__rq_for_each_bio'
           if ((rq->bio))                  \
               ^~~~~~~~~
   drivers/block/null_blk/main.c:1300:15: note: uninitialized use occurs here
           if (WARN_ON(!rem))
                        ^~~
   include/asm-generic/bug.h:123:25: note: expanded from macro 'WARN_ON'
           int __ret_warn_on = !!(condition);                              \
                                  ^~~~~~~~~
   drivers/block/null_blk/main.c:1295:2: note: remove the 'if' if its condition is always true
           __rq_for_each_bio(bio, req) {
           ^
   include/linux/blk-mq.h:1012:2: note: expanded from macro '__rq_for_each_bio'
           if ((rq->bio))                  \
           ^
   drivers/block/null_blk/main.c:1287:12: note: initialize the variable 'rem' to silence this warning
           size_t rem, temp;
                     ^
                      = 0
   1 warning generated.


vim +1295 drivers/block/null_blk/main.c

  1281	
  1282	static inline int nullb_setup_copy_write(struct nullb *nullb,
  1283			struct request *req, bool is_fua)
  1284	{
  1285		sector_t sector_in, sector_out;
  1286		void *in, *out;
  1287		size_t rem, temp;
  1288		struct bio *bio;
  1289		unsigned long offset_in, offset_out;
  1290		struct nullb_page *t_page_in, *t_page_out;
  1291		int ret = -EIO;
  1292	
  1293		sector_out = blk_rq_pos(req);
  1294	
> 1295		__rq_for_each_bio(bio, req) {
  1296			sector_in = bio->bi_iter.bi_sector;
  1297			rem = bio->bi_iter.bi_size;
  1298		}
  1299	
  1300		if (WARN_ON(!rem))
  1301			return BLK_STS_NOTSUPP;
  1302	
  1303		spin_lock_irq(&nullb->lock);
  1304		while (rem > 0) {
  1305			temp = min_t(size_t, nullb->dev->blocksize, rem);
  1306			offset_in = (sector_in & SECTOR_MASK) << SECTOR_SHIFT;
  1307			offset_out = (sector_out & SECTOR_MASK) << SECTOR_SHIFT;
  1308	
  1309			if (null_cache_active(nullb) && !is_fua)
  1310				null_make_cache_space(nullb, PAGE_SIZE);
  1311	
  1312			t_page_in = null_lookup_page(nullb, sector_in, false,
  1313				!null_cache_active(nullb));
  1314			if (!t_page_in)
  1315				goto err;
  1316			t_page_out = null_insert_page(nullb, sector_out,
  1317				!null_cache_active(nullb) || is_fua);
  1318			if (!t_page_out)
  1319				goto err;
  1320	
  1321			in = kmap_local_page(t_page_in->page);
  1322			out = kmap_local_page(t_page_out->page);
  1323	
  1324			memcpy(out + offset_out, in + offset_in, temp);
  1325			kunmap_local(out);
  1326			kunmap_local(in);
  1327			__set_bit(sector_out & SECTOR_MASK, t_page_out->bitmap);
  1328	
  1329			if (is_fua)
  1330				null_free_sector(nullb, sector_out, true);
  1331	
  1332			rem -= temp;
  1333			sector_in += temp >> SECTOR_SHIFT;
  1334			sector_out += temp >> SECTOR_SHIFT;
  1335		}
  1336	
  1337		ret = 0;
  1338	err:
  1339		spin_unlock_irq(&nullb->lock);
  1340		return ret;
  1341	}
  1342	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

