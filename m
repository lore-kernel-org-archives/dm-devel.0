Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A86C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 19 Mar 2022 08:25:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-laRvWCr3OXCOw03CE9jZXQ-1; Sat, 19 Mar 2022 04:25:16 -0400
X-MC-Unique: laRvWCr3OXCOw03CE9jZXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9BFB833960;
	Sat, 19 Mar 2022 08:25:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC3540149B1;
	Sat, 19 Mar 2022 08:25:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F22F194035B;
	Sat, 19 Mar 2022 08:25:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5AC8C1940341
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 08:25:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4524401E74; Sat, 19 Mar 2022 08:25:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E08C2401476
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 08:25:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59AA2185A79C
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 08:25:12 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-RKp_XrPWO3uDufsThBZ-8Q-1; Sat, 19 Mar 2022 04:25:10 -0400
X-MC-Unique: RKp_XrPWO3uDufsThBZ-8Q-1
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="256106305"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; d="scan'208";a="256106305"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
 by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 19 Mar 2022 01:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; d="scan'208";a="647829406"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
 by orsmga004.jf.intel.com with ESMTP; 19 Mar 2022 01:25:04 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1nVUOV-000FjS-DO; Sat, 19 Mar 2022 08:25:03 +0000
Date: Sat, 19 Mar 2022 16:24:04 +0800
From: kernel test robot <lkp@intel.com>
To: Jane Chu <jane.chu@oracle.com>, david@fromorbit.com, djwong@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, agk@redhat.com,
 snitzer@redhat.com, dm-devel@redhat.com, ira.weiny@intel.com,
 willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <202203191610.umg0CGkh-lkp@intel.com>
References: <20220319062833.3136528-5-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220319062833.3136528-5-jane.chu@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v6 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
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
Cc: kbuild-all@lists.01.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jane,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nvdimm/libnvdimm-for-next]
[also build test WARNING on device-mapper-dm/for-next linus/master v5.17-rc8 next-20220318]
[cannot apply to tip/x86/mm]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jane-Chu/DAX-poison-recovery/20220319-143144
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: s390-randconfig-r044-20220317 (https://download.01.org/0day-ci/archive/20220319/202203191610.umg0CGkh-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/203570f765a6ad07eb5809850478a25a5257f7e2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jane-Chu/DAX-poison-recovery/20220319-143144
        git checkout 203570f765a6ad07eb5809850478a25a5257f7e2
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash fs/fuse/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/fuse/virtio_fs.c: In function 'virtio_fs_zero_page_range':
>> fs/fuse/virtio_fs.c:774:58: warning: passing argument 4 of 'dax_direct_access' makes integer from pointer without a cast [-Wint-conversion]
     774 |         rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
         |                                                          ^~~~~~
         |                                                          |
         |                                                          void **
   In file included from fs/fuse/virtio_fs.c:8:
   include/linux/dax.h:187:21: note: expected 'int' but argument is of type 'void **'
     187 |                 int flags, void **kaddr, pfn_t *pfn);
         |                 ~~~~^~~~~
   fs/fuse/virtio_fs.c:774:14: error: too few arguments to function 'dax_direct_access'
     774 |         rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
         |              ^~~~~~~~~~~~~~~~~
   In file included from fs/fuse/virtio_fs.c:8:
   include/linux/dax.h:186:6: note: declared here
     186 | long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
         |      ^~~~~~~~~~~~~~~~~
   fs/fuse/virtio_fs.c: At top level:
   fs/fuse/virtio_fs.c:783:26: error: initialization of 'long int (*)(struct dax_device *, long unsigned int,  long int,  int,  void **, pfn_t *)' from incompatible pointer type 'long int (*)(struct dax_device *, long unsigned int,  long int,  void **, pfn_t *)' [-Werror=incompatible-pointer-types]
     783 |         .direct_access = virtio_fs_direct_access,
         |                          ^~~~~~~~~~~~~~~~~~~~~~~
   fs/fuse/virtio_fs.c:783:26: note: (near initialization for 'virtio_fs_dax_ops.direct_access')
   cc1: some warnings being treated as errors


vim +/dax_direct_access +774 fs/fuse/virtio_fs.c

22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  767  
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  768  static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  769  				     pgoff_t pgoff, size_t nr_pages)
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  770  {
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  771  	long rc;
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  772  	void *kaddr;
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  773  
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19 @774  	rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  775  	if (rc < 0)
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  776  		return rc;
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  777  	memset(kaddr, 0, nr_pages << PAGE_SHIFT);
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  778  	dax_flush(dax_dev, kaddr, nr_pages << PAGE_SHIFT);
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  779  	return 0;
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  780  }
22f3787e9d95e7 Stefan Hajnoczi 2020-08-19  781  

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

