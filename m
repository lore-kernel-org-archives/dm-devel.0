Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBB9C76195
	for <dm-devel@archiver.kernel.org>; Tue, 28 Mar 2023 07:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679987531;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lSmhdAYVqyi4kTKxGFgz4pBqsU79+Vk5Fp8/jiFZUpI=;
	b=ApF+Upgx7J/zIIIUQnwdUpt0RrxXMmR8pRv0sltfKoR5g+1uqVxpxJCSJm7Xagb7DYIxXb
	pGJuiGEd/VO7OkUJ3Z4Uvgf9FbZOzqH8LmGBdZtAtG8gb++iX9lAeChkjTmIGasPCr3W+8
	4rglTcPvB6eTwa7sTxknu9Q8brLc9hc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-A4YAc96SOom35criM_7FNg-1; Tue, 28 Mar 2023 03:12:05 -0400
X-MC-Unique: A4YAc96SOom35criM_7FNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B9EA857AA2;
	Tue, 28 Mar 2023 07:12:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16F9E440BC;
	Tue, 28 Mar 2023 07:12:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E4890194658C;
	Tue, 28 Mar 2023 07:12:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 84E3F1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Mar 2023 07:12:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 516D9492B01; Tue, 28 Mar 2023 07:12:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 49B1D492C3E
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 07:12:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2ED6788B7A7
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 07:12:01 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-nbF7qFbuOPWF3Axj6PyTqg-1; Tue, 28 Mar 2023 03:11:59 -0400
X-MC-Unique: nbF7qFbuOPWF3Axj6PyTqg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="426754949"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; d="scan'208";a="426754949"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Mar 2023 00:11:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="773033858"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; d="scan'208";a="773033858"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
 by FMSMGA003.fm.intel.com with ESMTP; 28 Mar 2023 00:11:54 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1ph3Un-000IMh-1x;
 Tue, 28 Mar 2023 07:11:53 +0000
Date: Tue, 28 Mar 2023 15:11:05 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
 hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Message-ID: <202303281502.U47uzous-lkp@intel.com>
References: <20230324181741.13908-12-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20230324181741.13908-12-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v5 11/18] nvme: Add pr_ops read_keys support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next axboe-block/for-next linus/master v6.3-rc4 next-20230328]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/block-Add-PR-callouts-for-read-keys-and-reservation/20230325-022314
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230324181741.13908-12-michael.christie%40oracle.com
patch subject: [PATCH v5 11/18] nvme: Add pr_ops read_keys support
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20230328/202303281502.U47uzous-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/fcd2233cf643c550ab3cea2b6102077b1d05b389
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mike-Christie/block-Add-PR-callouts-for-read-keys-and-reservation/20230325-022314
        git checkout fcd2233cf643c550ab3cea2b6102077b1d05b389
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 olddefconfig
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/nvme/host/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303281502.U47uzous-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/nvme/host/pr.c:165:24: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [assigned] [usertype] cdw11 @@     got int @@
   drivers/nvme/host/pr.c:165:24: sparse:     expected restricted __le32 [assigned] [usertype] cdw11
   drivers/nvme/host/pr.c:165:24: sparse:     got int
>> drivers/nvme/host/pr.c:171:21: sparse: sparse: restricted __le32 degrades to integer

vim +165 drivers/nvme/host/pr.c

   156	
   157	static int nvme_pr_resv_report(struct block_device *bdev, void *data,
   158			u32 data_len, bool *eds)
   159	{
   160		struct nvme_command c = { };
   161		int ret;
   162	
   163		c.common.opcode = nvme_cmd_resv_report;
   164		c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
 > 165		c.common.cdw11 = NVME_EXTENDED_DATA_STRUCT;
   166		*eds = true;
   167	
   168	retry:
   169		ret = nvme_send_pr_command(bdev, &c, data, data_len);
   170		if (ret == NVME_SC_HOST_ID_INCONSIST &&
 > 171		    c.common.cdw11 == NVME_EXTENDED_DATA_STRUCT) {
   172			c.common.cdw11 = 0;
   173			*eds = false;
   174			goto retry;
   175		}
   176	
   177		if (ret < 0)
   178			return ret;
   179	
   180		return nvme_sc_to_pr_err(ret);
   181	}
   182	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

