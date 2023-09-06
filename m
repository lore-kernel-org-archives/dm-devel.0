Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951C9EE14A9
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694037748;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sAfqDMZlnNfFRv51w/cys+V7VlkkUMfhkx3kkWaUmr8=;
	b=NvkVXlcfCc1184TyGZtiq8KakPnJi+OY3S/yZX7QAXxo33mswTmV/sH4x4jcfyOW41IYPt
	WEkuGeOH5lva5BndgK+hp9RngHOz8zr0dk/8/KWS/U3cJTcDF5Qg75GWxvsCPaSExXFICj
	MPOaZFagaABhE6Db/DtW4MicWKuu8FE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-qEIJjrldOuS-7XKSY0gjsA-1; Wed, 06 Sep 2023 18:02:24 -0400
X-MC-Unique: qEIJjrldOuS-7XKSY0gjsA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DA498279A5;
	Wed,  6 Sep 2023 22:02:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45D49412F2CE;
	Wed,  6 Sep 2023 22:02:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E24B2194658D;
	Wed,  6 Sep 2023 22:02:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A1D9A194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:02:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C37F1121318; Wed,  6 Sep 2023 22:02:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 743EF1121314
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 22:02:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 588B180D75F
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 22:02:17 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-JarzhXkTPkyMUcgw9LO-0w-1; Wed, 06 Sep 2023 18:02:13 -0400
X-MC-Unique: JarzhXkTPkyMUcgw9LO-0w-1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="357507878"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; d="scan'208";a="357507878"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 06 Sep 2023 15:02:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="718438474"
X-IronPort-AV: E=Sophos;i="6.02,233,1688454000"; d="scan'208";a="718438474"
Received: from lkp-server01.sh.intel.com (HELO 59b3c6e06877) ([10.239.97.150])
 by orsmga006.jf.intel.com with ESMTP; 06 Sep 2023 15:02:06 -0700
Received: from kbuild by 59b3c6e06877 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qe0b6-0000d2-00;
 Wed, 06 Sep 2023 22:02:04 +0000
Date: Thu, 7 Sep 2023 06:01:50 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202309070542.P9utuu9p-lkp@intel.com>
References: <20230906163844.18754-13-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230906163844.18754-13-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v15 12/12] null_blk: add support for copy
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
Cc: Anuj Gupta <anuj20.g@samsung.com>, Vincent Fu <vincent.fu@samsung.com>,
 martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c50216cfa084d5eb67dc10e646a3283da1595bb6]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Introduce-queue-limits-and-sysfs-for-copy-offload-support/20230907-015817
base:   c50216cfa084d5eb67dc10e646a3283da1595bb6
patch link:    https://lore.kernel.org/r/20230906163844.18754-13-nj.shetty%40samsung.com
patch subject: [PATCH v15 12/12] null_blk: add support for copy offload
config: arm-randconfig-001-20230907 (https://download.01.org/0day-ci/archive/20230907/202309070542.P9utuu9p-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project.git f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230907/202309070542.P9utuu9p-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309070542.P9utuu9p-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/block/null_blk/main.c:15:
   In file included from drivers/block/null_blk/./trace.h:104:
   In file included from include/trace/define_trace.h:102:
   In file included from include/trace/trace_events.h:237:
>> drivers/block/null_blk/./trace.h:94:34: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
                             __entry->dst, __entry->src, __entry->len)
                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/trace/stages/stage3_trace_output.h:6:17: note: expanded from macro '__entry'
   #define __entry field
                   ^
   include/trace/stages/stage3_trace_output.h:9:43: note: expanded from macro 'TP_printk'
   #define TP_printk(fmt, args...) fmt "\n", args
                                   ~~~       ^
   include/trace/trace_events.h:45:16: note: expanded from macro 'TRACE_EVENT'
                                PARAMS(print));                   \
                                ~~~~~~~^~~~~~~
   include/linux/tracepoint.h:107:25: note: expanded from macro 'PARAMS'
   #define PARAMS(args...) args
                           ^~~~
   include/trace/trace_events.h:203:27: note: expanded from macro 'DECLARE_EVENT_CLASS'
           trace_event_printf(iter, print);                                \
                                    ^~~~~
   1 warning generated.


vim +94 drivers/block/null_blk/./trace.h

    72	
    73	TRACE_EVENT(nullb_copy_op,
    74			TP_PROTO(struct request *req,
    75				 sector_t dst, sector_t src, size_t len),
    76			TP_ARGS(req, dst, src, len),
    77			TP_STRUCT__entry(
    78					 __array(char, disk, DISK_NAME_LEN)
    79					 __field(enum req_op, op)
    80					 __field(sector_t, dst)
    81					 __field(sector_t, src)
    82					 __field(size_t, len)
    83			),
    84			TP_fast_assign(
    85				       __entry->op = req_op(req);
    86				       __assign_disk_name(__entry->disk, req->q->disk);
    87				       __entry->dst = dst;
    88				       __entry->src = src;
    89				       __entry->len = len;
    90			),
    91			TP_printk("%s req=%-15s: dst=%llu, src=%llu, len=%lu",
    92				  __print_disk_name(__entry->disk),
    93				  blk_op_str(__entry->op),
  > 94				  __entry->dst, __entry->src, __entry->len)
    95	);
    96	#endif /* _TRACE_NULLB_H */
    97	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

