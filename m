Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732FDC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 28 Apr 2022 14:54:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-D5Uz8sGFPGy6fUG2XLfCZQ-1; Thu, 28 Apr 2022 10:54:19 -0400
X-MC-Unique: D5Uz8sGFPGy6fUG2XLfCZQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6304186B8AB;
	Thu, 28 Apr 2022 14:54:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C398570211;
	Thu, 28 Apr 2022 14:54:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E40061947046;
	Thu, 28 Apr 2022 14:54:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A29219466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 14:54:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC5CA2024CCB; Thu, 28 Apr 2022 14:54:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D756C2024CD2
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 14:54:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0CFF1C0854D
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 14:54:07 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-FFUAmFATPcqz3sWGVkmhzA-1; Thu, 28 Apr 2022 10:54:04 -0400
X-MC-Unique: FFUAmFATPcqz3sWGVkmhzA-1
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="253695068"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; d="scan'208";a="253695068"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Apr 2022 07:53:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; d="scan'208";a="514327844"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
 by orsmga003.jf.intel.com with ESMTP; 28 Apr 2022 07:53:43 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1nk5WY-0005Sd-BN;
 Thu, 28 Apr 2022 14:53:42 +0000
Date: Thu, 28 Apr 2022 22:53:21 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <202204282248.B5VfX8LS-lkp@intel.com>
References: <20220426101241.30100-7-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220426101241.30100-7-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v4 06/10] nvmet: add copy command support for
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
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 msnitzer@redhat.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
 gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de,
 Nitesh Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
 Mike Snitzer <snitzer@kernel.org>, josef@toxicpanda.com,
 linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
 tytso@mit.edu, Frederick.Knight@netapp.com, Sagi Grimberg <sagi@grimberg.me>,
 axboe@kernel.dk, kbuild-all@lists.01.org, martin.petersen@oracle.com,
 Arnav Dawn <arnav.dawn@samsung.com>, jack@suse.com,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20220422]
[cannot apply to axboe-block/for-next device-mapper-dm/for-next linus/master v5.18-rc4 v5.18-rc3 v5.18-rc2 v5.18-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Nitesh-Shetty/block-Introduce-queue-limits-for-copy-offload-support/20220426-201825
base:    e7d6987e09a328d4a949701db40ef63fbb970670
config: s390-randconfig-s032-20220427 (https://download.01.org/0day-ci/archive/20220428/202204282248.B5VfX8LS-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/6a9ea8570c34a7222786ca4d129578f48426d2f2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-Introduce-queue-limits-for-copy-offload-support/20220426-201825
        git checkout 6a9ea8570c34a7222786ca4d129578f48426d2f2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=s390 SHELL=/bin/bash drivers/md/ drivers/nvme/target/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/nvme/target/io-cmd-bdev.c:56:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned char [usertype] msrc @@     got restricted __le16 @@
   drivers/nvme/target/io-cmd-bdev.c:56:26: sparse:     expected unsigned char [usertype] msrc
   drivers/nvme/target/io-cmd-bdev.c:56:26: sparse:     got restricted __le16
   drivers/nvme/target/io-cmd-bdev.c:59:34: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned char [usertype] msrc @@     got restricted __le16 @@
   drivers/nvme/target/io-cmd-bdev.c:59:34: sparse:     expected unsigned char [usertype] msrc
   drivers/nvme/target/io-cmd-bdev.c:59:34: sparse:     got restricted __le16
--
>> drivers/nvme/target/admin-cmd.c:537:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned char [usertype] msrc @@     got restricted __le16 @@
   drivers/nvme/target/admin-cmd.c:537:26: sparse:     expected unsigned char [usertype] msrc
   drivers/nvme/target/admin-cmd.c:537:26: sparse:     got restricted __le16

vim +56 drivers/nvme/target/io-cmd-bdev.c

    12	
    13	void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
    14	{
    15		const struct queue_limits *ql = &bdev_get_queue(bdev)->limits;
    16		/* Number of logical blocks per physical block. */
    17		const u32 lpp = ql->physical_block_size / ql->logical_block_size;
    18		/* Logical blocks per physical block, 0's based. */
    19		const __le16 lpp0b = to0based(lpp);
    20	
    21		/*
    22		 * For NVMe 1.2 and later, bit 1 indicates that the fields NAWUN,
    23		 * NAWUPF, and NACWU are defined for this namespace and should be
    24		 * used by the host for this namespace instead of the AWUN, AWUPF,
    25		 * and ACWU fields in the Identify Controller data structure. If
    26		 * any of these fields are zero that means that the corresponding
    27		 * field from the identify controller data structure should be used.
    28		 */
    29		id->nsfeat |= 1 << 1;
    30		id->nawun = lpp0b;
    31		id->nawupf = lpp0b;
    32		id->nacwu = lpp0b;
    33	
    34		/*
    35		 * Bit 4 indicates that the fields NPWG, NPWA, NPDG, NPDA, and
    36		 * NOWS are defined for this namespace and should be used by
    37		 * the host for I/O optimization.
    38		 */
    39		id->nsfeat |= 1 << 4;
    40		/* NPWG = Namespace Preferred Write Granularity. 0's based */
    41		id->npwg = lpp0b;
    42		/* NPWA = Namespace Preferred Write Alignment. 0's based */
    43		id->npwa = id->npwg;
    44		/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
    45		id->npdg = to0based(ql->discard_granularity / ql->logical_block_size);
    46		/* NPDG = Namespace Preferred Deallocate Alignment */
    47		id->npda = id->npdg;
    48		/* NOWS = Namespace Optimal Write Size */
    49		id->nows = to0based(ql->io_opt / ql->logical_block_size);
    50	
    51		/*Copy limits*/
    52		if (ql->max_copy_sectors) {
    53			id->mcl = cpu_to_le32((ql->max_copy_sectors << 9) / ql->logical_block_size);
    54			id->mssrl = cpu_to_le16((ql->max_copy_range_sectors << 9) /
    55					ql->logical_block_size);
  > 56			id->msrc = to0based(ql->max_copy_nr_ranges);
    57		} else {
    58			if (ql->zoned == BLK_ZONED_NONE) {
    59				id->msrc = to0based(BIO_MAX_VECS);
    60				id->mssrl = cpu_to_le16(
    61						(BIO_MAX_VECS << PAGE_SHIFT) / ql->logical_block_size);
    62				id->mcl = cpu_to_le32(le16_to_cpu(id->mssrl) * BIO_MAX_VECS);
    63	#ifdef CONFIG_BLK_DEV_ZONED
    64			} else {
    65				/* TODO: get right values for zoned device */
    66				id->msrc = to0based(BIO_MAX_VECS);
    67				id->mssrl = cpu_to_le16(min((BIO_MAX_VECS << PAGE_SHIFT),
    68						ql->chunk_sectors) / ql->logical_block_size);
    69				id->mcl = cpu_to_le32(min(le16_to_cpu(id->mssrl) * BIO_MAX_VECS,
    70							ql->chunk_sectors));
    71	#endif
    72			}
    73		}
    74	}
    75	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

