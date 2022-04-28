Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F30A3C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Apr 2022 14:03:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-HqQrXeQnNFqjajGnHL2vrQ-1; Thu, 28 Apr 2022 10:03:33 -0400
X-MC-Unique: HqQrXeQnNFqjajGnHL2vrQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9614886B8B3;
	Thu, 28 Apr 2022 14:02:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 35CE6464BA2;
	Thu, 28 Apr 2022 14:02:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E3BE01947046;
	Thu, 28 Apr 2022 14:02:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 231C719466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 14:02:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EF4FC56C136; Thu, 28 Apr 2022 14:02:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB28356C142
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 14:02:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1920805F6D
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 14:02:54 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-WaJ_1sNQP4ix9rjQaJOwtg-1; Thu, 28 Apr 2022 10:02:50 -0400
X-MC-Unique: WaJ_1sNQP4ix9rjQaJOwtg-1
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="246856335"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; d="scan'208";a="246856335"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Apr 2022 07:02:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; d="scan'208";a="541312589"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
 by orsmga002.jf.intel.com with ESMTP; 28 Apr 2022 07:02:41 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1nk4jA-0005Qa-9F;
 Thu, 28 Apr 2022 14:02:40 +0000
Date: Thu, 28 Apr 2022 22:02:28 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <202204282136.kqIaq8aK-lkp@intel.com>
References: <20220426101241.30100-6-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220426101241.30100-6-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v4 05/10] nvme: add copy offload support
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
 gost.dev@samsung.com, nitheshshetty@gmail.com, hch@lst.de,
 Nitesh Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
 Mike Snitzer <snitzer@kernel.org>, josef@toxicpanda.com,
 linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
 tytso@mit.edu, Frederick.Knight@netapp.com, axboe@kernel.dk,
 kbuild-all@lists.01.org, Kanchan Joshi <joshi.k@samsung.com>,
 martin.petersen@oracle.com, Arnav Dawn <arnav.dawn@samsung.com>, jack@suse.com,
 linux-fsdevel@vger.kernel.org,
 Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
 lsf-pc@lists.linux-foundation.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
config: s390-randconfig-s032-20220427 (https://download.01.org/0day-ci/archive/20220428/202204282136.kqIaq8aK-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/e029014185aff1d7c8facf6e19447487c6ce2b93
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-Introduce-queue-limits-for-copy-offload-support/20220426-201825
        git checkout e029014185aff1d7c8facf6e19447487c6ce2b93
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=s390 SHELL=/bin/bash drivers/md/ drivers/nvme/host/ drivers/nvme/target/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/nvme/host/core.c:803:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le16 [usertype] dspec @@     got restricted __le32 [usertype] @@
   drivers/nvme/host/core.c:803:26: sparse:     expected restricted __le16 [usertype] dspec
   drivers/nvme/host/core.c:803:26: sparse:     got restricted __le32 [usertype]

vim +803 drivers/nvme/host/core.c

   739	
   740	static inline blk_status_t nvme_setup_copy_write(struct nvme_ns *ns,
   741		       struct request *req, struct nvme_command *cmnd)
   742	{
   743		struct nvme_ctrl *ctrl = ns->ctrl;
   744		struct nvme_copy_range *range = NULL;
   745		struct bio *bio = req->bio;
   746		struct nvme_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
   747		sector_t src_sector, dst_sector, n_sectors;
   748		u64 src_lba, dst_lba, n_lba;
   749		unsigned short nr_range = 1;
   750		u16 control = 0;
   751		u32 dsmgmt = 0;
   752	
   753		if (unlikely(memcmp(token->subsys, "nvme", 4)))
   754			return BLK_STS_NOTSUPP;
   755		if (unlikely(token->ns != ns))
   756			return BLK_STS_NOTSUPP;
   757	
   758		src_sector = token->src_sector;
   759		dst_sector = bio->bi_iter.bi_sector;
   760		n_sectors = token->sectors;
   761		if (WARN_ON(n_sectors != bio->bi_iter.bi_size >> 9))
   762			return BLK_STS_NOTSUPP;
   763	
   764		src_lba = nvme_sect_to_lba(ns, src_sector);
   765		dst_lba = nvme_sect_to_lba(ns, dst_sector);
   766		n_lba = nvme_sect_to_lba(ns, n_sectors);
   767	
   768		if (unlikely(nvme_lba_to_sect(ns, src_lba) != src_sector) ||
   769				unlikely(nvme_lba_to_sect(ns, dst_lba) != dst_sector) ||
   770				unlikely(nvme_lba_to_sect(ns, n_lba) != n_sectors))
   771			return BLK_STS_NOTSUPP;
   772	
   773		if (WARN_ON(!n_lba))
   774			return BLK_STS_NOTSUPP;
   775	
   776		if (req->cmd_flags & REQ_FUA)
   777			control |= NVME_RW_FUA;
   778	
   779		if (req->cmd_flags & REQ_FAILFAST_DEV)
   780			control |= NVME_RW_LR;
   781	
   782		memset(cmnd, 0, sizeof(*cmnd));
   783		cmnd->copy.opcode = nvme_cmd_copy;
   784		cmnd->copy.nsid = cpu_to_le32(ns->head->ns_id);
   785		cmnd->copy.sdlba = cpu_to_le64(dst_lba);
   786	
   787		range = kmalloc_array(nr_range, sizeof(*range),
   788				GFP_ATOMIC | __GFP_NOWARN);
   789		if (!range)
   790			return BLK_STS_RESOURCE;
   791	
   792		range[0].slba = cpu_to_le64(src_lba);
   793		range[0].nlb = cpu_to_le16(n_lba - 1);
   794	
   795		cmnd->copy.nr_range = 0;
   796	
   797		req->special_vec.bv_page = virt_to_page(range);
   798		req->special_vec.bv_offset = offset_in_page(range);
   799		req->special_vec.bv_len = sizeof(*range) * nr_range;
   800		req->rq_flags |= RQF_SPECIAL_PAYLOAD;
   801	
   802		cmnd->copy.control = cpu_to_le16(control);
 > 803		cmnd->copy.dspec = cpu_to_le32(dsmgmt);
   804	
   805		return BLK_STS_OK;
   806	}
   807	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

