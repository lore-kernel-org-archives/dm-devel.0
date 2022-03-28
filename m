Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4C9C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 28 Mar 2022 20:04:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-fRc60pIUOomfQsThMM6AIA-1; Mon, 28 Mar 2022 16:04:09 -0400
X-MC-Unique: fRc60pIUOomfQsThMM6AIA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9A3F1C05EA3;
	Mon, 28 Mar 2022 20:04:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5256F453625;
	Mon, 28 Mar 2022 20:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 203CD1949761;
	Mon, 28 Mar 2022 20:04:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E2A891947BBF
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 20:04:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B13A440CF910; Mon, 28 Mar 2022 20:04:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACF4D40CF900
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 20:04:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93737804184
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 20:04:04 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-7S622SZUMX2uqQsdxmAq1w-1; Mon, 28 Mar 2022 16:04:00 -0400
X-MC-Unique: 7S622SZUMX2uqQsdxmAq1w-1
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="345529207"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; d="scan'208";a="345529207"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Mar 2022 13:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; d="scan'208";a="502640853"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
 by orsmga003.jf.intel.com with ESMTP; 28 Mar 2022 13:03:56 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1nYval-0002HX-H0; Mon, 28 Mar 2022 20:03:55 +0000
Date: Tue, 29 Mar 2022 04:03:31 +0800
From: kernel test robot <lkp@intel.com>
To: Kirill Tkhai <kirill.tkhai@openvz.org>, agk@redhat.com,
 snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org,
 linux-kernel@vger.kernel.org, khorenko@virtuozzo.com
Message-ID: <202203290340.HdsYxZJQ-lkp@intel.com>
References: <164846631540.251310.2398727490395218229.stgit@pro>
MIME-Version: 1.0
In-Reply-To: <164846631540.251310.2398727490395218229.stgit@pro>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 3/4] dm-qcow2: Introduce driver to create
 block devices over QCOW2 files
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Kirill,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on device-mapper-dm/for-next]
[also build test ERROR on song-md/md-next linus/master v5.17 next-20220328]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Kirill-Tkhai/dm-Introduce-dm-qcow2-driver-to-attach-QCOW2-files-as-block-device/20220328-192031
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20220329/202203290340.HdsYxZJQ-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c41a15c11909af3588885a88f6622c36dcc9ca35
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kirill-Tkhai/dm-Introduce-dm-qcow2-driver-to-attach-QCOW2-files-as-block-device/20220328-192031
        git checkout c41a15c11909af3588885a88f6622c36dcc9ca35
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> drivers/md/dm-qcow2-target.c:428:6: warning: no previous prototype for 'ploop_enospc_timer' [-Wmissing-prototypes]
     428 | void ploop_enospc_timer(struct timer_list *timer)
         |      ^~~~~~~~~~~~~~~~~~
--
   drivers/md/dm-qcow2-map.c: In function 'process_cow_indexes_write':
>> drivers/md/dm-qcow2-map.c:3861:28: warning: variable 'qvec' set but not used [-Wunused-but-set-variable]
    3861 |         struct qcow2_bvec *qvec;
         |                            ^~~~
   drivers/md/dm-qcow2-map.c: At top level:
>> drivers/md/dm-qcow2-map.c:4136:6: warning: no previous prototype for 'submit_embedded_qio' [-Wmissing-prototypes]
    4136 | void submit_embedded_qio(struct qcow2_target *tgt, struct qio *qio)
         |      ^~~~~~~~~~~~~~~~~~~
--
   arch/mips/kernel/head.o: in function `kernel_entry':
   (.ref.text+0xac): relocation truncated to fit: R_MIPS_26 against `start_kernel'
   init/main.o: in function `set_reset_devices':
   main.c:(.init.text+0x20): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0x30): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
   init/main.o: in function `debug_kernel':
   main.c:(.init.text+0xa4): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0xb4): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
   init/main.o: in function `quiet_kernel':
   main.c:(.init.text+0x128): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0x138): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
   init/main.o: in function `warn_bootconfig':
   main.c:(.init.text+0x1ac): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0x1bc): relocation truncated to fit: R_MIPS_26 against `__sanitizer_cov_trace_pc'
   init/main.o: in function `init_setup':
   main.c:(.init.text+0x238): relocation truncated to fit: R_MIPS_26 against `_mcount'
   main.c:(.init.text+0x258): additional relocation overflows omitted from the output
   mips-linux-ld: drivers/md/dm-qcow2-target.o: in function `calc_cached_parameters':
>> dm-qcow2-target.c:(.text.calc_cached_parameters+0x194): undefined reference to `__divdi3'
>> mips-linux-ld: dm-qcow2-target.c:(.text.calc_cached_parameters+0x264): undefined reference to `__divdi3'
   mips-linux-ld: drivers/md/dm-qcow2-map.o: in function `qio_subclu_indexes':
>> dm-qcow2-map.c:(.text.qio_subclu_indexes+0x21c): undefined reference to `__udivdi3'
>> mips-linux-ld: dm-qcow2-map.c:(.text.qio_subclu_indexes+0x298): undefined reference to `__udivdi3'
   mips-linux-ld: drivers/md/dm-qcow2-map.o: in function `calc_refcounters_map':
>> dm-qcow2-map.c:(.text.calc_refcounters_map+0x118): undefined reference to `__divdi3'
>> mips-linux-ld: dm-qcow2-map.c:(.text.calc_refcounters_map+0x184): undefined reference to `__moddi3'
>> mips-linux-ld: dm-qcow2-map.c:(.text.calc_refcounters_map+0x23c): undefined reference to `__divdi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_refcounters_map+0x46c): undefined reference to `__moddi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_refcounters_map+0x4a8): undefined reference to `__divdi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_refcounters_map+0x4f0): undefined reference to `__moddi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_refcounters_map+0x574): undefined reference to `__divdi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_refcounters_map+0x598): undefined reference to `__moddi3'
   mips-linux-ld: drivers/md/dm-qcow2-map.o: in function `calc_cluster_map':
>> dm-qcow2-map.c:(.text.calc_cluster_map+0x178): undefined reference to `__divdi3'
>> mips-linux-ld: dm-qcow2-map.c:(.text.calc_cluster_map+0x198): undefined reference to `__divdi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_cluster_map+0x3d8): undefined reference to `__divdi3'
>> mips-linux-ld: dm-qcow2-map.c:(.text.calc_cluster_map+0x5a8): undefined reference to `__moddi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_cluster_map+0x5d0): undefined reference to `__moddi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_cluster_map+0x650): undefined reference to `__moddi3'
   mips-linux-ld: dm-qcow2-map.c:(.text.calc_cluster_map+0x6bc): undefined reference to `__moddi3'
   mips-linux-ld: drivers/md/dm-qcow2-map.o: in function `split_qio_to_list':
>> dm-qcow2-map.c:(.text.split_qio_to_list+0x228): undefined reference to `__divdi3'
>> mips-linux-ld: dm-qcow2-map.c:(.text.split_qio_to_list+0x244): undefined reference to `__divdi3'
   mips-linux-ld: drivers/md/dm-qcow2-map.o: in function `relocate_refcount_table':
>> dm-qcow2-map.c:(.text.relocate_refcount_table+0x5c8): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

