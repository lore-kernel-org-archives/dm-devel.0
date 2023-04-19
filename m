Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25310C77B78
	for <dm-devel@archiver.kernel.org>; Wed, 19 Apr 2023 18:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681930579;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+nY2kHbJg2qfnfwYVu5MLGGiSkEWTz5txSpVqUM4zCU=;
	b=h/FYAyZErcvcmogZ7S7rzvgKgq7c4yhjZ5brnfKn2C38/ZsXjKvtCFuV8NzgGdgvVzmBIc
	x8Qk1o4Wy9JuZyzUlkcSl0YHh89gQER064q7wQMGdX0nZyfjEjzhVJ9MkpxfrKk23Z+HO8
	vVetfcoKskSTqoaavT0PIBcvZXvoeAM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-K8Wh-YuPMI60bq3nBkWfhg-1; Wed, 19 Apr 2023 14:56:17 -0400
X-MC-Unique: K8Wh-YuPMI60bq3nBkWfhg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DB7C101A556;
	Wed, 19 Apr 2023 18:56:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 35FC140C2064;
	Wed, 19 Apr 2023 18:56:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 11C2119465B9;
	Wed, 19 Apr 2023 18:56:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E31419465B5
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 18:56:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4ED56C16026; Wed, 19 Apr 2023 18:56:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46D02C16024
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 18:56:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BE96857F81
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 18:56:13 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-T8AYbNQ_MjiGkIjoN4J7CA-1; Wed, 19 Apr 2023 14:56:09 -0400
X-MC-Unique: T8AYbNQ_MjiGkIjoN4J7CA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="343015580"
X-IronPort-AV: E=Sophos;i="5.99,210,1677571200"; d="scan'208";a="343015580"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 19 Apr 2023 11:56:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="780939661"
X-IronPort-AV: E=Sophos;i="5.99,210,1677571200"; d="scan'208";a="780939661"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
 by FMSMGA003.fm.intel.com with ESMTP; 19 Apr 2023 11:56:01 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1ppCyH-000f74-01;
 Wed, 19 Apr 2023 18:56:01 +0000
Date: Thu, 20 Apr 2023 02:55:53 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202304200240.fsLkpzvk-lkp@intel.com>
References: <20230419114320.13674-7-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230419114320.13674-7-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v10 6/9] nvmet: add copy command support for
 bdev and file ns
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, nitheshshetty@gmail.com,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20230418]
[cannot apply to axboe-block/for-next device-mapper-dm/for-next linus/master v6.3-rc7 v6.3-rc6 v6.3-rc5 v6.3-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Add-copy-offload-support-infrastructure/20230419-204352
patch link:    https://lore.kernel.org/r/20230419114320.13674-7-nj.shetty%40samsung.com
patch subject: [PATCH v10 6/9] nvmet: add copy command support for bdev and file ns
config: m68k-randconfig-s032-20230416 (https://download.01.org/0day-ci/archive/20230420/202304200240.fsLkpzvk-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/420b04f7ba9a54898d62c1d60905f8cf952afde2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-Add-copy-offload-support-infrastructure/20230419-204352
        git checkout 420b04f7ba9a54898d62c1d60905f8cf952afde2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=m68k SHELL=/bin/bash drivers/nvme/target/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304200240.fsLkpzvk-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/nvme/target/io-cmd-bdev.c:55:27: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] val @@     got restricted __le16 [usertype] mssrl @@
   drivers/nvme/target/io-cmd-bdev.c:55:27: sparse:     expected unsigned int [usertype] val
   drivers/nvme/target/io-cmd-bdev.c:55:27: sparse:     got restricted __le16 [usertype] mssrl
>> drivers/nvme/target/io-cmd-bdev.c:55:27: sparse: sparse: cast from restricted __le16
>> drivers/nvme/target/io-cmd-bdev.c:55:27: sparse: sparse: cast from restricted __le16
>> drivers/nvme/target/io-cmd-bdev.c:55:27: sparse: sparse: cast from restricted __le16
>> drivers/nvme/target/io-cmd-bdev.c:55:27: sparse: sparse: cast from restricted __le16
   drivers/nvme/target/io-cmd-bdev.c:57:29: sparse: sparse: cast from restricted __le16
   drivers/nvme/target/io-cmd-bdev.c:60:27: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] val @@     got restricted __le16 [usertype] mssrl @@
   drivers/nvme/target/io-cmd-bdev.c:60:27: sparse:     expected unsigned int [usertype] val
   drivers/nvme/target/io-cmd-bdev.c:60:27: sparse:     got restricted __le16 [usertype] mssrl
   drivers/nvme/target/io-cmd-bdev.c:60:27: sparse: sparse: cast from restricted __le16
   drivers/nvme/target/io-cmd-bdev.c:60:27: sparse: sparse: cast from restricted __le16
   drivers/nvme/target/io-cmd-bdev.c:60:27: sparse: sparse: cast from restricted __le16
   drivers/nvme/target/io-cmd-bdev.c:60:27: sparse: sparse: cast from restricted __le16

vim +55 drivers/nvme/target/io-cmd-bdev.c

    12	
    13	void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
    14	{
    15		/* Logical blocks per physical block, 0's based. */
    16		const __le16 lpp0b = to0based(bdev_physical_block_size(bdev) /
    17					      bdev_logical_block_size(bdev));
    18	
    19		/*
    20		 * For NVMe 1.2 and later, bit 1 indicates that the fields NAWUN,
    21		 * NAWUPF, and NACWU are defined for this namespace and should be
    22		 * used by the host for this namespace instead of the AWUN, AWUPF,
    23		 * and ACWU fields in the Identify Controller data structure. If
    24		 * any of these fields are zero that means that the corresponding
    25		 * field from the identify controller data structure should be used.
    26		 */
    27		id->nsfeat |= 1 << 1;
    28		id->nawun = lpp0b;
    29		id->nawupf = lpp0b;
    30		id->nacwu = lpp0b;
    31	
    32		/*
    33		 * Bit 4 indicates that the fields NPWG, NPWA, NPDG, NPDA, and
    34		 * NOWS are defined for this namespace and should be used by
    35		 * the host for I/O optimization.
    36		 */
    37		id->nsfeat |= 1 << 4;
    38		/* NPWG = Namespace Preferred Write Granularity. 0's based */
    39		id->npwg = lpp0b;
    40		/* NPWA = Namespace Preferred Write Alignment. 0's based */
    41		id->npwa = id->npwg;
    42		/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
    43		id->npdg = to0based(bdev_discard_granularity(bdev) /
    44				    bdev_logical_block_size(bdev));
    45		/* NPDG = Namespace Preferred Deallocate Alignment */
    46		id->npda = id->npdg;
    47		/* NOWS = Namespace Optimal Write Size */
    48		id->nows = to0based(bdev_io_opt(bdev) / bdev_logical_block_size(bdev));
    49	
    50		/*Copy limits*/
    51		if (bdev_max_copy_sectors(bdev)) {
    52			id->msrc = id->msrc;
    53			id->mssrl = cpu_to_le16((bdev_max_copy_sectors(bdev) <<
    54					SECTOR_SHIFT) / bdev_logical_block_size(bdev));
  > 55			id->mcl = cpu_to_le32(id->mssrl);
    56		} else {
    57			id->msrc = (u8)to0based(BIO_MAX_VECS - 1);
    58			id->mssrl = cpu_to_le16((BIO_MAX_VECS << PAGE_SHIFT) /
    59					bdev_logical_block_size(bdev));
    60			id->mcl = cpu_to_le32(id->mssrl);
    61		}
    62	}
    63	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

