Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578DFC74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680115078;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DoLzBz6zkQN9orxEw7OBwJ6Dn7KjRzlfM/Hdo1teJG8=;
	b=FQkyxHRsGSmNbV1yraPPXnliZun4MwOJ0C2Ft61vFlffSmOZyAxL3xZ7Srf/Le/T7fLIQi
	plJ/nkq6cihRlllwZI6INQMeuZHQwLhSV+nrM4FUZ2x8TxAEdKOqCN5TuQ4VMThIEvMDye
	6wUKWLeuyob8nh8xPRrvdeTmiGTqPjE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-6sHl53eCMXuALwkFhLYM3A-1; Wed, 29 Mar 2023 14:37:56 -0400
X-MC-Unique: 6sHl53eCMXuALwkFhLYM3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37B17101A54F;
	Wed, 29 Mar 2023 18:37:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D88F91121330;
	Wed, 29 Mar 2023 18:37:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A54891946588;
	Wed, 29 Mar 2023 18:37:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3AD1F1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 18:37:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A205202701F; Wed, 29 Mar 2023 18:37:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2248C202701E
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 18:37:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01CA529AA3B9
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 18:37:24 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-Cu9ylMvsPJafwJyx7UGGWA-1; Wed, 29 Mar 2023 14:37:22 -0400
X-MC-Unique: Cu9ylMvsPJafwJyx7UGGWA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="427243799"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; d="scan'208";a="427243799"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 29 Mar 2023 11:37:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="1014137919"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; d="scan'208";a="1014137919"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
 by fmsmga005.fm.intel.com with ESMTP; 29 Mar 2023 11:37:07 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1phafS-000Jp4-2L;
 Wed, 29 Mar 2023 18:37:06 +0000
Date: Thu, 30 Mar 2023 02:36:31 +0800
From: kernel test robot <lkp@intel.com>
To: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <202303300238.vmt9ne37-lkp@intel.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
config: arm64-randconfig-s041-20230329 (https://download.01.org/0day-ci/archive/20230330/202303300238.vmt9ne37-lkp@intel.com/config)
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
| Link: https://lore.kernel.org/oe-kbuild-all/202303300238.vmt9ne37-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/nvme/target/admin-cmd.c:539:29: sparse: sparse: cast from restricted __le16

vim +539 drivers/nvme/target/admin-cmd.c

   490	
   491	static void nvmet_execute_identify_ns(struct nvmet_req *req)
   492	{
   493		struct nvme_id_ns *id;
   494		u16 status;
   495	
   496		if (le32_to_cpu(req->cmd->identify.nsid) == NVME_NSID_ALL) {
   497			req->error_loc = offsetof(struct nvme_identify, nsid);
   498			status = NVME_SC_INVALID_NS | NVME_SC_DNR;
   499			goto out;
   500		}
   501	
   502		id = kzalloc(sizeof(*id), GFP_KERNEL);
   503		if (!id) {
   504			status = NVME_SC_INTERNAL;
   505			goto out;
   506		}
   507	
   508		/* return an all zeroed buffer if we can't find an active namespace */
   509		status = nvmet_req_find_ns(req);
   510		if (status) {
   511			status = 0;
   512			goto done;
   513		}
   514	
   515		if (nvmet_ns_revalidate(req->ns)) {
   516			mutex_lock(&req->ns->subsys->lock);
   517			nvmet_ns_changed(req->ns->subsys, req->ns->nsid);
   518			mutex_unlock(&req->ns->subsys->lock);
   519		}
   520	
   521		/*
   522		 * nuse = ncap = nsze isn't always true, but we have no way to find
   523		 * that out from the underlying device.
   524		 */
   525		id->ncap = id->nsze =
   526			cpu_to_le64(req->ns->size >> req->ns->blksize_shift);
   527		switch (req->port->ana_state[req->ns->anagrpid]) {
   528		case NVME_ANA_INACCESSIBLE:
   529		case NVME_ANA_PERSISTENT_LOSS:
   530			break;
   531		default:
   532			id->nuse = id->nsze;
   533			break;
   534		}
   535	
   536		if (req->ns->bdev)
   537			nvmet_bdev_set_limits(req->ns->bdev, id);
   538		else {
 > 539			id->msrc = (u8)to0based(BIO_MAX_VECS - 1);
   540			id->mssrl = cpu_to_le16(BIO_MAX_VECS <<
   541					(PAGE_SHIFT - SECTOR_SHIFT));
   542			id->mcl = cpu_to_le32(le16_to_cpu(id->mssrl));
   543		}
   544	
   545		/*
   546		 * We just provide a single LBA format that matches what the
   547		 * underlying device reports.
   548		 */
   549		id->nlbaf = 0;
   550		id->flbas = 0;
   551	
   552		/*
   553		 * Our namespace might always be shared.  Not just with other
   554		 * controllers, but also with any other user of the block device.
   555		 */
   556		id->nmic = NVME_NS_NMIC_SHARED;
   557		id->anagrpid = cpu_to_le32(req->ns->anagrpid);
   558	
   559		memcpy(&id->nguid, &req->ns->nguid, sizeof(id->nguid));
   560	
   561		id->lbaf[0].ds = req->ns->blksize_shift;
   562	
   563		if (req->sq->ctrl->pi_support && nvmet_ns_has_pi(req->ns)) {
   564			id->dpc = NVME_NS_DPC_PI_FIRST | NVME_NS_DPC_PI_LAST |
   565				  NVME_NS_DPC_PI_TYPE1 | NVME_NS_DPC_PI_TYPE2 |
   566				  NVME_NS_DPC_PI_TYPE3;
   567			id->mc = NVME_MC_EXTENDED_LBA;
   568			id->dps = req->ns->pi_type;
   569			id->flbas = NVME_NS_FLBAS_META_EXT;
   570			id->lbaf[0].ms = cpu_to_le16(req->ns->metadata_size);
   571		}
   572	
   573		if (req->ns->readonly)
   574			id->nsattr |= NVME_NS_ATTR_RO;
   575	done:
   576		if (!status)
   577			status = nvmet_copy_to_sgl(req, 0, id, sizeof(*id));
   578	
   579		kfree(id);
   580	out:
   581		nvmet_req_complete(req, status);
   582	}
   583	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

