Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C6CC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Apr 2022 15:55:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-V35-URzEN-W5Snu9zELlsA-1; Thu, 28 Apr 2022 11:55:36 -0400
X-MC-Unique: V35-URzEN-W5Snu9zELlsA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DE581014A76;
	Thu, 28 Apr 2022 15:55:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB77114682D9;
	Thu, 28 Apr 2022 15:55:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C4B51947046;
	Thu, 28 Apr 2022 15:55:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B921519466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 15:55:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BFE92166B1A; Thu, 28 Apr 2022 15:55:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86FD12166B18
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 15:55:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76BAE18F0242
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 15:55:25 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-x8rX4IZmNTWMPUqj5iHwCQ-1; Thu, 28 Apr 2022 11:55:23 -0400
X-MC-Unique: x8rX4IZmNTWMPUqj5iHwCQ-1
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265181322"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; d="scan'208";a="265181322"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Apr 2022 08:55:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; d="scan'208";a="514363012"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
 by orsmga003.jf.intel.com with ESMTP; 28 Apr 2022 08:55:15 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
 (envelope-from <lkp@intel.com>) id 1nk6U6-0005VH-CQ;
 Thu, 28 Apr 2022 15:55:14 +0000
Date: Thu, 28 Apr 2022 23:54:46 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <202204282336.7AY0GVKz-lkp@intel.com>
References: <20220426101241.30100-8-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220426101241.30100-8-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v4 07/10] dm: Add support for copy offload.
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
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 josef@toxicpanda.com, linux-block@vger.kernel.org, dsterba@suse.com,
 kbusch@kernel.org, tytso@mit.edu, Frederick.Knight@netapp.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, kbuild-all@lists.01.org,
 martin.petersen@oracle.com, jack@suse.com, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
config: s390-randconfig-s032-20220427 (https://download.01.org/0day-ci/archive/20220428/202204282336.7AY0GVKz-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/913c8c5197fea28ee3c8424e16eadd8b159a91f0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-Introduce-queue-limits-for-copy-offload-support/20220426-201825
        git checkout 913c8c5197fea28ee3c8424e16eadd8b159a91f0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=s390 SHELL=/bin/bash drivers/md/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/md/dm.c:1602:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted blk_status_t @@     got int @@
   drivers/md/dm.c:1602:24: sparse:     expected restricted blk_status_t
   drivers/md/dm.c:1602:24: sparse:     got int

vim +1602 drivers/md/dm.c

  1582	
  1583	/*
  1584	 * Select the correct strategy for processing a non-flush bio.
  1585	 */
  1586	static blk_status_t __split_and_process_bio(struct clone_info *ci)
  1587	{
  1588		struct bio *clone;
  1589		struct dm_target *ti;
  1590		unsigned len;
  1591	
  1592		ti = dm_table_find_target(ci->map, ci->sector);
  1593		if (unlikely(!ti))
  1594			return BLK_STS_IOERR;
  1595		else if (unlikely(ci->is_abnormal_io))
  1596			return __process_abnormal_io(ci, ti);
  1597	
  1598		if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
  1599					max_io_len(ti, ci->sector) < ci->sector_count)) {
  1600			DMERR("%s: Error IO size(%u) is greater than maximum target size(%llu)\n",
  1601					__func__, ci->sector_count, max_io_len(ti, ci->sector));
> 1602			return -EIO;
  1603		}
  1604		/*
  1605		 * Only support bio polling for normal IO, and the target io is
  1606		 * exactly inside the dm_io instance (verified in dm_poll_dm_io)
  1607		 */
  1608		ci->submit_as_polled = ci->bio->bi_opf & REQ_POLLED;
  1609	
  1610		len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
  1611		setup_split_accounting(ci, len);
  1612		clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
  1613		__map_bio(clone);
  1614	
  1615		ci->sector += len;
  1616		ci->sector_count -= len;
  1617	
  1618		return BLK_STS_OK;
  1619	}
  1620	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

