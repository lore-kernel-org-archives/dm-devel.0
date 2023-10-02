Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC67E784A7
	for <dm-devel@archiver.kernel.org>; Mon,  2 Oct 2023 01:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696211972;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fNXtE2fnYyu6mZnYO5ZMDF27oHu59jcEa9UheoIB2aU=;
	b=h/shmLo/3vCSnajQ/MoEHP9x/wvLIqrMlScafw1saokKRjtiQcbmKl0Mcr5JhO7Stw80o7
	JOd8Gsp19CnPs2CyHogMZBHaU0lm7CE4t8rT3BDG7DZUPJdpHNZ3NPJ+Q2HAoZg6Z2isVK
	xws58Lvis5Gn9Ihx4YWIW0N/XDDvl7k=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-vCj2pEFwNN-mItVkzponvA-1; Sun, 01 Oct 2023 21:59:28 -0400
X-MC-Unique: vCj2pEFwNN-mItVkzponvA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E818B29AB3E6;
	Mon,  2 Oct 2023 01:59:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5288D493113;
	Mon,  2 Oct 2023 01:59:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE8D2194658C;
	Mon,  2 Oct 2023 01:59:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7CB271946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 Oct 2023 01:59:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5BE65C158BA; Mon,  2 Oct 2023 01:59:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 53982C15BB8
 for <dm-devel@redhat.com>; Mon,  2 Oct 2023 01:59:22 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3271F185A797
 for <dm-devel@redhat.com>; Mon,  2 Oct 2023 01:59:22 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-j7wjbGcRPTig0qkAyjdwsQ-1; Sun, 01 Oct 2023 21:59:20 -0400
X-MC-Unique: j7wjbGcRPTig0qkAyjdwsQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="372920009"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; d="scan'208";a="372920009"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 01 Oct 2023 18:59:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="840862065"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; d="scan'208";a="840862065"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
 by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2023 18:59:13 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qn8DG-0005fl-1j;
 Mon, 02 Oct 2023 01:59:10 +0000
Date: Mon, 2 Oct 2023 09:58:33 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202310020910.TaSOIepO-lkp@intel.com>
References: <20230920080756.11919-9-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230920080756.11919-9-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v16 08/12] nvmet: add copy command support
 for bdev and file ns
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
Cc: Anuj Gupta <anuj20.g@samsung.com>, anuj1072538@gmail.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-doc@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
patch link:    https://lore.kernel.org/r/20230920080756.11919-9-nj.shetty%40samsung.com
patch subject: [PATCH v16 08/12] nvmet: add copy command support for bdev and file ns
config: i386-randconfig-061-20231002 (https://download.01.org/0day-ci/archive/20231002/202310020910.TaSOIepO-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231002/202310020910.TaSOIepO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310020910.TaSOIepO-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/nvme/target/io-cmd-bdev.c:498:30: sparse: sparse: restricted __le16 degrades to integer
>> drivers/nvme/target/io-cmd-bdev.c:514:41: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted blk_status_t [usertype] blk_sts @@     got int [assigned] [usertype] ret @@
   drivers/nvme/target/io-cmd-bdev.c:514:41: sparse:     expected restricted blk_status_t [usertype] blk_sts
   drivers/nvme/target/io-cmd-bdev.c:514:41: sparse:     got int [assigned] [usertype] ret

vim +498 drivers/nvme/target/io-cmd-bdev.c

   478	
   479	/*
   480	 * At present we handle only one range entry, since copy offload is aligned with
   481	 * copy_file_range, only one entry is passed from block layer.
   482	 */
   483	static void nvmet_bdev_execute_copy(struct nvmet_req *rq)
   484	{
   485		struct nvme_copy_range range;
   486		struct nvme_command *cmd = rq->cmd;
   487		ssize_t ret;
   488		off_t dst, src;
   489	
   490		u16 status;
   491	
   492		status = nvmet_copy_from_sgl(rq, 0, &range, sizeof(range));
   493		if (status)
   494			goto err_rq_complete;
   495	
   496		dst = le64_to_cpu(cmd->copy.sdlba) << rq->ns->blksize_shift;
   497		src = le64_to_cpu(range.slba) << rq->ns->blksize_shift;
 > 498		rq->copy_len = (range.nlb + 1) << rq->ns->blksize_shift;
   499	
   500		if (bdev_max_copy_sectors(rq->ns->bdev)) {
   501			ret = blkdev_copy_offload(rq->ns->bdev, dst, src, rq->copy_len,
   502						  nvmet_bdev_copy_endio,
   503						  (void *)rq, GFP_KERNEL);
   504		} else {
   505			ret = blkdev_copy_emulation(rq->ns->bdev, dst,
   506						    rq->ns->bdev, src, rq->copy_len,
   507						    nvmet_bdev_copy_endio,
   508						    (void *)rq, GFP_KERNEL);
   509		}
   510		if (ret == -EIOCBQUEUED)
   511			return;
   512	
   513		rq->cqe->result.u32 = cpu_to_le32(0);
 > 514		status = blk_to_nvme_status(rq, ret);
   515	err_rq_complete:
   516		nvmet_req_complete(rq, status);
   517	}
   518	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

