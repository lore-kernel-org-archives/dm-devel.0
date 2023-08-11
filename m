Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88BCC0015E
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691788634;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zWPfpdjLeygEwY/tf4tqQsi6o8nOnjyTqdISmj5y3S8=;
	b=EgZG2Mthx30kd+oInV0oHaVA1wGU16XOFolyXkOWh9kklVrJJb3dqRFuonyY1DE3JPvKjH
	ybV9OE6U4tvEk6mtXnKwDgpZw6xRxevCX1R5jay2wBCkcxyuseoJy8gLaVASdbjvaABqMc
	GW8R1IwH7bBIHkR21xqkx96WRUgm5FQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-fA1-hBNUNg6mNUFVVYqmJg-1; Fri, 11 Aug 2023 17:17:11 -0400
X-MC-Unique: fA1-hBNUNg6mNUFVVYqmJg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA69F8DC66C;
	Fri, 11 Aug 2023 21:17:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E08B40C6F4E;
	Fri, 11 Aug 2023 21:17:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C351B1946594;
	Fri, 11 Aug 2023 21:17:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 595B6194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 21:17:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0C64540C6F53; Fri, 11 Aug 2023 21:17:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0417340C6F4E
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:17:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C35D28007A4
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:17:05 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-5wFQXjFJPFabQ0e5SewtnQ-1; Fri, 11 Aug 2023 17:17:03 -0400
X-MC-Unique: 5wFQXjFJPFabQ0e5SewtnQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10799"; a="438098272"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; d="scan'208";a="438098272"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Aug 2023 14:15:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10799"; a="802817157"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; d="scan'208";a="802817157"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
 by fmsmga004.fm.intel.com with ESMTP; 11 Aug 2023 14:15:52 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qUZU8-00082u-06;
 Fri, 11 Aug 2023 21:15:52 +0000
Date: Sat, 12 Aug 2023 05:15:10 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202308120529.EW7DuUW7-lkp@intel.com>
References: <20230811105300.15889-12-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230811105300.15889-12-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v14 11/11] null_blk: add support for copy
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
 linux-block@vger.kernel.org, mcgrof@kernel.org, dlemoal@kernel.org,
 oe-kbuild-all@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on f7dc24b3413851109c4047b22997bd0d95ed52a2]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Introduce-queue-limits-and-sysfs-for-copy-offload-support/20230811-192259
base:   f7dc24b3413851109c4047b22997bd0d95ed52a2
patch link:    https://lore.kernel.org/r/20230811105300.15889-12-nj.shetty%40samsung.com
patch subject: [PATCH v14 11/11] null_blk: add support for copy offload
config: hexagon-randconfig-r032-20230811 (https://download.01.org/0day-ci/archive/20230812/202308120529.EW7DuUW7-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230812/202308120529.EW7DuUW7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308120529.EW7DuUW7-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __tracepoint_nullb_copy_op
   >>> referenced by atomic-arch-fallback.h:444 (include/linux/atomic/atomic-arch-fallback.h:444)
   >>>               drivers/block/null_blk/main.o:(null_process_cmd) in archive vmlinux.a
   >>> referenced by atomic-arch-fallback.h:444 (include/linux/atomic/atomic-arch-fallback.h:444)
   >>>               drivers/block/null_blk/main.o:(null_process_cmd) in archive vmlinux.a
--
>> ld.lld: error: undefined symbol: __traceiter_nullb_copy_op
   >>> referenced by trace.h:71 (drivers/block/null_blk/trace.h:71)
   >>>               drivers/block/null_blk/main.o:(null_process_cmd) in archive vmlinux.a
   >>> referenced by trace.h:71 (drivers/block/null_blk/trace.h:71)
   >>>               drivers/block/null_blk/main.o:(null_process_cmd) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

