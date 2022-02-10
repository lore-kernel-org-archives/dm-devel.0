Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D167C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 07:10:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-J6TPMO_8MnGAEva3B8BcNQ-1; Thu, 10 Feb 2022 02:10:06 -0500
X-MC-Unique: J6TPMO_8MnGAEva3B8BcNQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 037E2101F003;
	Thu, 10 Feb 2022 07:10:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2F5E5ED33;
	Thu, 10 Feb 2022 07:09:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 383104BB7C;
	Thu, 10 Feb 2022 07:09:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21A79l8Z027920 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 02:09:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 994EE2166B1C; Thu, 10 Feb 2022 07:09:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93FF52166B25
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 07:09:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E64F3C01B91
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 07:09:44 +0000 (UTC)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-385-6eG5zDbwPGyTA0yxIfm7Vg-1; Thu, 10 Feb 2022 02:09:40 -0500
X-MC-Unique: 6eG5zDbwPGyTA0yxIfm7Vg-1
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="310166978"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; d="scan'208";a="310166978"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
	by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	09 Feb 2022 23:09:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; d="scan'208";a="482643883"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
	by orsmga003.jf.intel.com with ESMTP; 09 Feb 2022 23:09:31 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nI3a7-0002rA-1q; Thu, 10 Feb 2022 07:09:31 +0000
Date: Thu, 10 Feb 2022 15:08:52 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, mpatocka@redhat.com
Message-ID: <202202101447.DEcXWmHU-lkp@intel.com>
References: <20220207141348.4235-7-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220207141348.4235-7-nj.shetty@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, nj.shetty@samsung.com, zach.brown@ni.com,
	chaitanyak@nvidia.com, SelvaKumar S <selvakuma.s1@samsung.com>,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	tytso@mit.edu, Frederick.Knight@netapp.com, axboe@kernel.dk,
	kbuild-all@lists.01.org, joshi.k@samsung.com,
	martin.petersen@oracle.com, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [dm-devel] [PATCH v2 06/10] nvme: add copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Nitesh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v5.17-rc3 next-20220209]
[cannot apply to device-mapper-dm/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: arm64-randconfig-s032-20220207 (https://download.01.org/0day-ci/archive/20220210/202202101447.DEcXWmHU-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/22cbc1d3df11aaadd02b27ce5dcb702f9a8f4272
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
        git checkout 22cbc1d3df11aaadd02b27ce5dcb702f9a8f4272
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/nvme/host/ drivers/nvme/target/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/nvme/host/core.c:1793:42: sparse: sparse: cast to restricted __le64
   drivers/nvme/host/core.c:1793:42: sparse: sparse: cast from restricted __le32
>> drivers/nvme/host/core.c:1795:48: sparse: sparse: cast to restricted __le32
>> drivers/nvme/host/core.c:1795:48: sparse: sparse: cast from restricted __le16
>> drivers/nvme/host/core.c:903:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le16 [usertype] dspec @@     got restricted __le32 [usertype] @@
   drivers/nvme/host/core.c:903:26: sparse:     expected restricted __le16 [usertype] dspec
   drivers/nvme/host/core.c:903:26: sparse:     got restricted __le32 [usertype]

vim +1793 drivers/nvme/host/core.c

  1774	
  1775	static void nvme_config_copy(struct gendisk *disk, struct nvme_ns *ns,
  1776					       struct nvme_id_ns *id)
  1777	{
  1778		struct nvme_ctrl *ctrl = ns->ctrl;
  1779		struct request_queue *queue = disk->queue;
  1780	
  1781		if (!(ctrl->oncs & NVME_CTRL_ONCS_COPY)) {
  1782			queue->limits.copy_offload = 0;
  1783			queue->limits.max_copy_sectors = 0;
  1784			queue->limits.max_copy_range_sectors = 0;
  1785			queue->limits.max_copy_nr_ranges = 0;
  1786			blk_queue_flag_clear(QUEUE_FLAG_COPY, queue);
  1787			return;
  1788		}
  1789	
  1790		/* setting copy limits */
  1791		blk_queue_flag_test_and_set(QUEUE_FLAG_COPY, queue);
  1792		queue->limits.copy_offload = 0;
> 1793		queue->limits.max_copy_sectors = le64_to_cpu(id->mcl) *
  1794			(1 << (ns->lba_shift - 9));
> 1795		queue->limits.max_copy_range_sectors = le32_to_cpu(id->mssrl) *
  1796			(1 << (ns->lba_shift - 9));
  1797		queue->limits.max_copy_nr_ranges = id->msrc + 1;
  1798	}
  1799	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

