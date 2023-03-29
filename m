Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520F2C6FD18
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 14:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680100253;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=v4mJKmprPgRGKLaFVGxvY++jRAnA2iLM2A4a7I4tXWE=;
	b=VUxLR6H90MB8Qiq4dpuTqrHQmiqGPCcIpz8ZttTYFrtkJnQ/QRuCkOb2kVeeGWt6OF3azg
	EoIBvr2Qr3Dh5+726at3WhOLN185EY8nXit5aL94nNBt44MUFACTf2HRWC4TLp5qEg0Rvj
	wmWlZzAl42Q1CVFOFnvWSnjT/PUFfVo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-l0o6Yt_aPvOHCMLzOh5Cbw-1; Wed, 29 Mar 2023 10:30:49 -0400
X-MC-Unique: l0o6Yt_aPvOHCMLzOh5Cbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 179B1185A78F;
	Wed, 29 Mar 2023 14:30:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01D9E2027040;
	Wed, 29 Mar 2023 14:30:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D57F8194658D;
	Wed, 29 Mar 2023 14:30:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32E4F1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 13:59:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F2CF1121331; Wed, 29 Mar 2023 13:59:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0770C1121330
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 13:59:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBC5885A588
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 13:59:23 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-qMIY3IeZOQGZP09pvHAXug-1; Wed, 29 Mar 2023 09:59:22 -0400
X-MC-Unique: qMIY3IeZOQGZP09pvHAXug-1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="329348389"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; d="scan'208";a="329348389"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 29 Mar 2023 06:58:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="716892985"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; d="scan'208";a="716892985"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
 by orsmga001.jf.intel.com with ESMTP; 29 Mar 2023 06:57:54 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1phWJF-000Jb6-0H;
 Wed, 29 Mar 2023 13:57:53 +0000
Date: Wed, 29 Mar 2023 21:56:55 +0800
From: kernel test robot <lkp@intel.com>
To: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202303292148.Pbx4mDpS-lkp@intel.com>
References: <20230327084103.21601-7-anuj20.g@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20230327084103.21601-7-anuj20.g@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 6/9] nvmet: add copy command support for
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
Cc: bvanassche@acm.org, joshi.k@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, damien.lemoal@opensource.wdc.com,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Anuj,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.3-rc4 next-20230329]
[cannot apply to device-mapper-dm/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anuj-Gupta/block-Add-copy-offload-support-infrastructure/20230329-162018
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20230327084103.21601-7-anuj20.g%40samsung.com
patch subject: [PATCH v8 6/9] nvmet: add copy command support for bdev and file ns
config: arm64-randconfig-s041-20230329 (https://download.01.org/0day-ci/archive/20230329/202303292148.Pbx4mDpS-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/f846a8ac40882d9d42532e9e2b43560650ef8510
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anuj-Gupta/block-Add-copy-offload-support-infrastructure/20230329-162018
        git checkout f846a8ac40882d9d42532e9e2b43560650ef8510
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/nvme/target/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303292148.Pbx4mDpS-lkp@intel.com/

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

