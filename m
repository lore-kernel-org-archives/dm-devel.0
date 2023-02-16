Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E166C636CC
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 13:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676552982;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e+3+mhlPGPCRustUbv1Id/caO5s4eoE7pylqjV6FuJc=;
	b=J2eoDhMHsCHhjofT+GCRUqoe62DKqHcftnX2aDGldOPN8S8BfV6q4nwFrHLBy+dJtAMzKl
	KR2/uldne+LrW5dzg9aOMpbxJuocMWRk5LCusL2MW0/h6gq4JiMac+WkNcu6pcddK/lXjn
	rukH34DquqnAR7MQJ/b0ltJmLP10biU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-6pCa7Wt_MVGJVUoKmq-hDA-1; Thu, 16 Feb 2023 08:09:40 -0500
X-MC-Unique: 6pCa7Wt_MVGJVUoKmq-hDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BB47857A88;
	Thu, 16 Feb 2023 13:09:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFC441121314;
	Thu, 16 Feb 2023 13:09:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E57C1946589;
	Thu, 16 Feb 2023 13:09:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C70C71946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 13:08:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7BE532166B31; Thu, 16 Feb 2023 13:08:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7553D2166B30
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 13:08:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5791085CBE7
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 13:08:41 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-hewEJ25jPkawo-y0d1luBA-1; Thu, 16 Feb 2023 08:08:39 -0500
X-MC-Unique: hewEJ25jPkawo-y0d1luBA-1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333881459"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; d="scan'208";a="333881459"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 16 Feb 2023 05:07:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="647672293"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; d="scan'208";a="647672293"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
 by orsmga006.jf.intel.com with ESMTP; 16 Feb 2023 05:07:32 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1pSdyw-000AGZ-2R;
 Thu, 16 Feb 2023 13:07:26 +0000
Date: Thu, 16 Feb 2023 21:06:49 +0800
From: kernel test robot <lkp@intel.com>
To: Uday Shankar <ushankar@purestorage.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Message-ID: <202302162040.FaI25ul2-lkp@intel.com>
References: <20230215201507.494152-1-ushankar@purestorage.com>
MIME-Version: 1.0
In-Reply-To: <20230215201507.494152-1-ushankar@purestorage.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] blk-mq: enforce op-specific segment limits
 in blk_insert_cloned_request
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, llvm@lists.linux.dev,
 Uday Shankar <ushankar@purestorage.com>, oe-kbuild-all@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Uday,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 6bea9ac7c6481c09eb2b61d7cd844fc64a526e3e]

url:    https://github.com/intel-lab-lkp/linux/commits/Uday-Shankar/blk-mq-enforce-op-specific-segment-limits-in-blk_insert_cloned_request/20230216-041718
base:   6bea9ac7c6481c09eb2b61d7cd844fc64a526e3e
patch link:    https://lore.kernel.org/r/20230215201507.494152-1-ushankar%40purestorage.com
patch subject: [PATCH] blk-mq: enforce op-specific segment limits in blk_insert_cloned_request
config: i386-randconfig-a004-20230213 (https://download.01.org/0day-ci/archive/20230216/202302162040.FaI25ul2-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2cd958b09698bedea1a5a5f6298f0d25ec522bf9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Uday-Shankar/blk-mq-enforce-op-specific-segment-limits-in-blk_insert_cloned_request/20230216-041718
        git checkout 2cd958b09698bedea1a5a5f6298f0d25ec522bf9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302162040.FaI25ul2-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> block/blk-mq.c:3032:36: warning: format specifies type 'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                           __func__, rq->nr_phys_segments, max_segments);
                                                           ^~~~~~~~~~~~
   include/linux/printk.h:457:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                       ~~~    ^~~~~~~~~~~
   include/linux/printk.h:429:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                           ~~~~    ^~~~~~~~~~~
   1 warning generated.


vim +3032 block/blk-mq.c

  2993	
  2994	#ifdef CONFIG_BLK_MQ_STACKING
  2995	/**
  2996	 * blk_insert_cloned_request - Helper for stacking drivers to submit a request
  2997	 * @rq: the request being queued
  2998	 */
  2999	blk_status_t blk_insert_cloned_request(struct request *rq)
  3000	{
  3001		struct request_queue *q = rq->q;
  3002		unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
  3003		unsigned int max_segments = blk_queue_get_max_segments(q, req_op(rq));
  3004		blk_status_t ret;
  3005	
  3006		if (blk_rq_sectors(rq) > max_sectors) {
  3007			/*
  3008			 * SCSI device does not have a good way to return if
  3009			 * Write Same/Zero is actually supported. If a device rejects
  3010			 * a non-read/write command (discard, write same,etc.) the
  3011			 * low-level device driver will set the relevant queue limit to
  3012			 * 0 to prevent blk-lib from issuing more of the offending
  3013			 * operations. Commands queued prior to the queue limit being
  3014			 * reset need to be completed with BLK_STS_NOTSUPP to avoid I/O
  3015			 * errors being propagated to upper layers.
  3016			 */
  3017			if (max_sectors == 0)
  3018				return BLK_STS_NOTSUPP;
  3019	
  3020			printk(KERN_ERR "%s: over max size limit. (%u > %u)\n",
  3021				__func__, blk_rq_sectors(rq), max_sectors);
  3022			return BLK_STS_IOERR;
  3023		}
  3024	
  3025		/*
  3026		 * The queue settings related to segment counting may differ from the
  3027		 * original queue.
  3028		 */
  3029		rq->nr_phys_segments = blk_recalc_rq_segments(rq);
  3030		if (rq->nr_phys_segments > max_segments) {
  3031			printk(KERN_ERR "%s: over max segments limit. (%hu > %hu)\n",
> 3032				__func__, rq->nr_phys_segments, max_segments);
  3033			return BLK_STS_IOERR;
  3034		}
  3035	
  3036		if (q->disk && should_fail_request(q->disk->part0, blk_rq_bytes(rq)))
  3037			return BLK_STS_IOERR;
  3038	
  3039		if (blk_crypto_insert_cloned_request(rq))
  3040			return BLK_STS_IOERR;
  3041	
  3042		blk_account_io_start(rq);
  3043	
  3044		/*
  3045		 * Since we have a scheduler attached on the top device,
  3046		 * bypass a potential scheduler on the bottom device for
  3047		 * insert.
  3048		 */
  3049		blk_mq_run_dispatch_ops(q,
  3050				ret = blk_mq_request_issue_directly(rq, true));
  3051		if (ret)
  3052			blk_account_io_done(rq, ktime_get_ns());
  3053		return ret;
  3054	}
  3055	EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
  3056	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

