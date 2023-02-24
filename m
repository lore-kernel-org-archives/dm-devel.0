Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 432F5C6FA8E
	for <dm-devel@archiver.kernel.org>; Fri, 24 Feb 2023 21:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677272725;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8JiaPjfc5ijMvLYqDawdI34dDLa8Lf+DedztjFPxrAY=;
	b=SBQ1AAqs6aWdPU55bVWzMYRFGeoiTeCz3TeX5NvEVjercdgCW0cS21rCqH1QtWQX3rrsh/
	BrXwz3C8YkEnzxnZd3O6tcugNdL+UAO29Gp6OGXZKOJj2I+5/I8GVb/uUpLgufLKw08zkd
	q7jM8fzWOT3FL25CjE5PsEvCIrk9ZVY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588--7Ya0lrENy27JpSekHyAcg-1; Fri, 24 Feb 2023 16:05:24 -0500
X-MC-Unique: -7Ya0lrENy27JpSekHyAcg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51DC685CBE6;
	Fri, 24 Feb 2023 21:05:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29AB8140EBF6;
	Fri, 24 Feb 2023 21:05:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EA56219465B1;
	Fri, 24 Feb 2023 21:05:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F74319465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 21:05:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 43712492B13; Fri, 24 Feb 2023 21:05:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B7A4492B12
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 21:05:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1744D3C0D194
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 21:05:18 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-DXvfBRuMOPKR-2buGKy0qw-1; Fri, 24 Feb 2023 16:05:15 -0500
X-MC-Unique: DXvfBRuMOPKR-2buGKy0qw-1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="419813023"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; d="scan'208";a="419813023"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 Feb 2023 13:05:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="666285820"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; d="scan'208";a="666285820"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
 by orsmga007.jf.intel.com with ESMTP; 24 Feb 2023 13:05:08 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1pVfFb-0002j9-1U;
 Fri, 24 Feb 2023 21:05:07 +0000
Date: Sat, 25 Feb 2023 05:04:09 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
 hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Message-ID: <202302250448.cEVYdC1I-lkp@intel.com>
References: <20230224174502.321490-14-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20230224174502.321490-14-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v4 13/18] nvme: Add pr_ops read_reservation
 support
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
Cc: Mike Christie <michael.christie@oracle.com>, oe-kbuild-all@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next axboe-block/for-next linus/master v6.2 next-20230224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/block-Rename-BLK_STS_NEXUS-to-BLK_STS_RESV_CONFLICT/20230225-024505
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230224174502.321490-14-michael.christie%40oracle.com
patch subject: [PATCH v4 13/18] nvme: Add pr_ops read_reservation support
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230225/202302250448.cEVYdC1I-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f66174eef73e332bdca3a158541875a4c2e617d1
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mike-Christie/block-Rename-BLK_STS_NEXUS-to-BLK_STS_RESV_CONFLICT/20230225-024505
        git checkout f66174eef73e332bdca3a158541875a4c2e617d1
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/nvme/host/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302250448.cEVYdC1I-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/nvme/host/pr.c: In function 'block_pr_type_from_nvme':
>> drivers/nvme/host/pr.c:43:24: warning: implicit conversion from 'enum nvme_pr_type' to 'enum pr_type' [-Wenum-conversion]
      43 |                 return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +43 drivers/nvme/host/pr.c

    28	
    29	static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
    30	{
    31		switch (type) {
    32		case NVME_PR_WRITE_EXCLUSIVE:
    33			return PR_WRITE_EXCLUSIVE;
    34		case NVME_PR_EXCLUSIVE_ACCESS:
    35			return PR_EXCLUSIVE_ACCESS;
    36		case NVME_PR_WRITE_EXCLUSIVE_REG_ONLY:
    37			return PR_WRITE_EXCLUSIVE_REG_ONLY;
    38		case NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY:
    39			return PR_EXCLUSIVE_ACCESS_REG_ONLY;
    40		case NVME_PR_WRITE_EXCLUSIVE_ALL_REGS:
    41			return PR_WRITE_EXCLUSIVE_ALL_REGS;
    42		case NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS:
  > 43			return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
    44		}
    45	
    46		return 0;
    47	}
    48	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

