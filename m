Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D755C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:37:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-6WZO0CL8PXOdBZHpvGmd0Q-1; Tue, 08 Feb 2022 17:37:31 -0500
X-MC-Unique: 6WZO0CL8PXOdBZHpvGmd0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F9E51091DB6;
	Tue,  8 Feb 2022 22:37:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 220E356F9E;
	Tue,  8 Feb 2022 22:37:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F0D03473A1;
	Tue,  8 Feb 2022 22:37:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217KE6wg005074 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 15:14:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 81FDC2166B4D; Mon,  7 Feb 2022 20:14:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D3992166B4C
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 20:14:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD0C91C04B4B
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 20:14:02 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-158-Ub_to145M32EnBwV0490mQ-1; Mon, 07 Feb 2022 15:14:01 -0500
X-MC-Unique: Ub_to145M32EnBwV0490mQ-1
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="335202163"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; d="scan'208";a="335202163"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
	by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	07 Feb 2022 12:12:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; d="scan'208";a="700590505"
Received: from lkp-server01.sh.intel.com (HELO 9dd77a123018) ([10.239.97.150])
	by orsmga005.jf.intel.com with ESMTP; 07 Feb 2022 12:12:53 -0800
Received: from kbuild by 9dd77a123018 with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nHANY-0000vV-JD; Mon, 07 Feb 2022 20:12:52 +0000
Date: Tue, 8 Feb 2022 04:12:34 +0800
From: kernel test robot <lkp@intel.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, mpatocka@redhat.com
Message-ID: <202202080346.u4ubCCIs-lkp@intel.com>
References: <20220207141348.4235-8-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220207141348.4235-8-nj.shetty@samsung.com>
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
Cc: axboe@kernel.dk, javier@javigon.com, msnitzer@redhat.com,
	kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
	llvm@lists.linux.dev, chaitanyak@nvidia.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 07/10] nvmet: add copy command support for
 bdev and file ns
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
[also build test WARNING on linus/master v5.17-rc3 next-20220207]
[cannot apply to device-mapper-dm/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: arm64-randconfig-r031-20220207 (https://download.01.org/0day-ci/archive/20220208/202202080346.u4ubCCIs-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0d8850ae2cae85d49bea6ae0799fa41c7202c05c)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/0day-ci/linux/commit/6bb6ea64499e1ac27975e79bb2eee89f07861893
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Nitesh-Shetty/block-make-bio_map_kern-non-static/20220207-231407
        git checkout 6bb6ea64499e1ac27975e79bb2eee89f07861893
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/nvme/target/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/nvme/target/admin-cmd.c:534:15: warning: implicit conversion from '__le32' (aka 'unsigned int') to '__le16' (aka 'unsigned short') changes value from 2097152 to 0 [-Wconstant-conversion]
                   id->mssrl = cpu_to_le32(BIO_MAX_VECS << (PAGE_SHIFT - SECTOR_SHIFT));
                             ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/byteorder/generic.h:88:21: note: expanded from macro 'cpu_to_le32'
   #define cpu_to_le32 __cpu_to_le32
                       ^
   include/uapi/linux/byteorder/big_endian.h:34:27: note: expanded from macro '__cpu_to_le32'
   #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +534 drivers/nvme/target/admin-cmd.c

   488	
   489	static void nvmet_execute_identify_ns(struct nvmet_req *req)
   490	{
   491		struct nvme_id_ns *id;
   492		u16 status;
   493	
   494		if (le32_to_cpu(req->cmd->identify.nsid) == NVME_NSID_ALL) {
   495			req->error_loc = offsetof(struct nvme_identify, nsid);
   496			status = NVME_SC_INVALID_NS | NVME_SC_DNR;
   497			goto out;
   498		}
   499	
   500		id = kzalloc(sizeof(*id), GFP_KERNEL);
   501		if (!id) {
   502			status = NVME_SC_INTERNAL;
   503			goto out;
   504		}
   505	
   506		/* return an all zeroed buffer if we can't find an active namespace */
   507		status = nvmet_req_find_ns(req);
   508		if (status) {
   509			status = 0;
   510			goto done;
   511		}
   512	
   513		nvmet_ns_revalidate(req->ns);
   514	
   515		/*
   516		 * nuse = ncap = nsze isn't always true, but we have no way to find
   517		 * that out from the underlying device.
   518		 */
   519		id->ncap = id->nsze =
   520			cpu_to_le64(req->ns->size >> req->ns->blksize_shift);
   521		switch (req->port->ana_state[req->ns->anagrpid]) {
   522		case NVME_ANA_INACCESSIBLE:
   523		case NVME_ANA_PERSISTENT_LOSS:
   524			break;
   525		default:
   526			id->nuse = id->nsze;
   527			break;
   528		}
   529	
   530		if (req->ns->bdev)
   531			nvmet_bdev_set_limits(req->ns->bdev, id);
   532		else {
   533			id->msrc = to0based(BIO_MAX_VECS);
 > 534			id->mssrl = cpu_to_le32(BIO_MAX_VECS << (PAGE_SHIFT - SECTOR_SHIFT));
   535			id->mcl = cpu_to_le64(le32_to_cpu(id->mssrl) * BIO_MAX_VECS);
   536		}
   537	
   538		/*
   539		 * We just provide a single LBA format that matches what the
   540		 * underlying device reports.
   541		 */
   542		id->nlbaf = 0;
   543		id->flbas = 0;
   544	
   545		/*
   546		 * Our namespace might always be shared.  Not just with other
   547		 * controllers, but also with any other user of the block device.
   548		 */
   549		id->nmic = NVME_NS_NMIC_SHARED;
   550		id->anagrpid = cpu_to_le32(req->ns->anagrpid);
   551	
   552		memcpy(&id->nguid, &req->ns->nguid, sizeof(id->nguid));
   553	
   554		id->lbaf[0].ds = req->ns->blksize_shift;
   555	
   556		if (req->sq->ctrl->pi_support && nvmet_ns_has_pi(req->ns)) {
   557			id->dpc = NVME_NS_DPC_PI_FIRST | NVME_NS_DPC_PI_LAST |
   558				  NVME_NS_DPC_PI_TYPE1 | NVME_NS_DPC_PI_TYPE2 |
   559				  NVME_NS_DPC_PI_TYPE3;
   560			id->mc = NVME_MC_EXTENDED_LBA;
   561			id->dps = req->ns->pi_type;
   562			id->flbas = NVME_NS_FLBAS_META_EXT;
   563			id->lbaf[0].ms = cpu_to_le16(req->ns->metadata_size);
   564		}
   565	
   566		if (req->ns->readonly)
   567			id->nsattr |= (1 << 0);
   568	done:
   569		if (!status)
   570			status = nvmet_copy_to_sgl(req, 0, id, sizeof(*id));
   571	
   572		kfree(id);
   573	out:
   574		nvmet_req_complete(req, status);
   575	}
   576	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

