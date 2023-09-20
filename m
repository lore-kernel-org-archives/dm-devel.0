Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0136DCE79B0
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 10:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695207376;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RdwGgVmQ792uGIcLf55GWFT+DGv2pfsYBUygKNThXlI=;
	b=Nvb7Q2ejKi24wL4LibdBO8B1M/rhRY2DmQ2nWfPT/Rz/DWBJgmQ9pRw5X93MEirq7hQCPE
	PGtbhf6kSC8WWrwZKuMq/HGsWoOYSp9+Galg7Kv8ze2KodvSCS0mZkioXPje0TqMOrMr6c
	ftFPt7EFAWnveLlx1aqH4rTrfekBO5w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-PNQ2Av2nN92zzqIRVj4EnA-1; Wed, 20 Sep 2023 06:56:15 -0400
X-MC-Unique: PNQ2Av2nN92zzqIRVj4EnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B189101B04E;
	Wed, 20 Sep 2023 10:56:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C25714027BE;
	Wed, 20 Sep 2023 10:56:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F09E619466EC;
	Wed, 20 Sep 2023 10:56:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC5BB19466E6
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 10:55:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B9F82156702; Wed, 20 Sep 2023 10:55:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 945582156701
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 10:55:37 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74C8F185A797
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 10:55:37 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-MCJ4dynEMaSQvD3LASPzWQ-1; Wed, 20 Sep 2023 06:55:35 -0400
X-MC-Unique: MCJ4dynEMaSQvD3LASPzWQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="365238762"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; d="scan'208";a="365238762"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 20 Sep 2023 03:55:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10838"; a="781647988"
X-IronPort-AV: E=Sophos;i="6.02,161,1688454000"; d="scan'208";a="781647988"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
 by orsmga001.jf.intel.com with ESMTP; 20 Sep 2023 03:55:27 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qiurd-0008fM-16;
 Wed, 20 Sep 2023 10:55:25 +0000
Date: Wed, 20 Sep 2023 18:54:55 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202309201836.c2wRnper-lkp@intel.com>
References: <20230920080756.11919-13-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230920080756.11919-13-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v16 12/12] null_blk: add support for copy
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
 anuj1072538@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-doc@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 7fc7222d9680366edeecc219c21ca96310bdbc10]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Introduce-queue-limits-and-sysfs-for-copy-offload-support/20230920-170132
base:   7fc7222d9680366edeecc219c21ca96310bdbc10
patch link:    https://lore.kernel.org/r/20230920080756.11919-13-nj.shetty%40samsung.com
patch subject: [PATCH v16 12/12] null_blk: add support for copy offload
config: parisc-allyesconfig (https://download.01.org/0day-ci/archive/20230920/202309201836.c2wRnper-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230920/202309201836.c2wRnper-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309201836.c2wRnper-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:102,
                    from drivers/block/null_blk/trace.h:104,
                    from drivers/block/null_blk/main.c:15:
   drivers/block/null_blk/./trace.h: In function 'trace_raw_output_nullb_copy_op':
>> drivers/block/null_blk/./trace.h:91:27: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
      91 |                 TP_printk("%s req=%-15s: dst=%llu, src=%llu, len=%lu",
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   drivers/block/null_blk/./trace.h:73:1: note: in expansion of macro 'TRACE_EVENT'
      73 | TRACE_EVENT(nullb_copy_op,
         | ^~~~~~~~~~~
   drivers/block/null_blk/./trace.h:91:17: note: in expansion of macro 'TP_printk'
      91 |                 TP_printk("%s req=%-15s: dst=%llu, src=%llu, len=%lu",
         |                 ^~~~~~~~~
   In file included from include/trace/trace_events.h:237:
   drivers/block/null_blk/./trace.h:91:68: note: format string is defined here
      91 |                 TP_printk("%s req=%-15s: dst=%llu, src=%llu, len=%lu",
         |                                                                  ~~^
         |                                                                    |
         |                                                                    long unsigned int
         |                                                                  %u


vim +91 drivers/block/null_blk/./trace.h

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
  > 91			TP_printk("%s req=%-15s: dst=%llu, src=%llu, len=%lu",
    92				  __print_disk_name(__entry->disk),
    93				  blk_op_str(__entry->op),
    94				  __entry->dst, __entry->src, __entry->len)
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

