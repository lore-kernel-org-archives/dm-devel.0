Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303E1C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 03:39:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-RHNjgAqIPuq6qI3eIDFVqA-1; Tue, 08 Feb 2022 22:39:51 -0500
X-MC-Unique: RHNjgAqIPuq6qI3eIDFVqA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDBF01091DA2;
	Wed,  9 Feb 2022 03:39:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6946D56F76;
	Wed,  9 Feb 2022 03:39:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC7611809CB8;
	Wed,  9 Feb 2022 03:39:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2193dZDT024019 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Feb 2022 22:39:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 28672401E58; Wed,  9 Feb 2022 03:39:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24A82401E57
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 03:39:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B50E185A794
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 03:39:35 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-269-gUEf13DXOjG9zZux6E8t7w-1; Tue, 08 Feb 2022 22:39:31 -0500
X-MC-Unique: gUEf13DXOjG9zZux6E8t7w-1
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229083257"
X-IronPort-AV: E=Sophos;i="5.88,354,1635231600"; d="scan'208";a="229083257"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
	by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	08 Feb 2022 19:39:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,354,1635231600"; d="scan'208";a="771204809"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
	by fmsmga006.fm.intel.com with ESMTP; 08 Feb 2022 19:39:23 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nHdpD-0001Al-6Z; Wed, 09 Feb 2022 03:39:23 +0000
Date: Wed, 9 Feb 2022 11:39:03 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, mpatocka@redhat.com
Message-ID: <202202091048.qDQvi6ab-lkp@intel.com>
References: <20220207141348.4235-5-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220207141348.4235-5-nj.shetty@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, nj.shetty@samsung.com, zach.brown@ni.com,
	chaitanyak@nvidia.com, msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	tytso@mit.edu, Frederick.Knight@netapp.com, axboe@kernel.dk,
	kbuild-all@lists.01.org, joshi.k@samsung.com,
	martin.petersen@oracle.com, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [dm-devel] [PATCH v2 04/10] block: Introduce a new ioctl for
	copy
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
[also build test WARNING on next-20220208]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: i386-randconfig-c001 (https://download.01.org/0day-ci/archive/20220209/202202091048.qDQvi6ab-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


cocci warnings: (new ones prefixed by >>)
>> block/ioctl.c:145:10-17: WARNING opportunity for memdup_user

vim +145 block/ioctl.c

   126	
   127	static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
   128			unsigned long arg)
   129	{
   130		struct copy_range crange, *ranges;
   131		size_t payload_size = 0;
   132		int ret;
   133	
   134		if (!(mode & FMODE_WRITE))
   135			return -EBADF;
   136	
   137		if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
   138			return -EFAULT;
   139	
   140		if (unlikely(!crange.nr_range || crange.reserved || crange.nr_range >= MAX_COPY_NR_RANGE))
   141			return -EINVAL;
   142	
   143		payload_size = (crange.nr_range * sizeof(struct range_entry)) + sizeof(crange);
   144	
 > 145		ranges = kmalloc(payload_size, GFP_KERNEL);
   146		if (!ranges)
   147			return -ENOMEM;
   148	
   149		if (copy_from_user(ranges, (void __user *)arg, payload_size)) {
   150			ret = -EFAULT;
   151			goto out;
   152		}
   153	
   154		ret = blkdev_issue_copy(bdev, ranges->nr_range, ranges->range_list, bdev, GFP_KERNEL, 0);
   155		if (copy_to_user((void __user *)arg, ranges, payload_size))
   156			ret = -EFAULT;
   157	out:
   158		kfree(ranges);
   159		return ret;
   160	}
   161	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

