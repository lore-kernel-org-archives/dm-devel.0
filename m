Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1570C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 28 Mar 2022 23:43:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-REbeZBdzO_SZfMPkibmrEA-1; Mon, 28 Mar 2022 19:43:42 -0400
X-MC-Unique: REbeZBdzO_SZfMPkibmrEA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E8FE2800947;
	Mon, 28 Mar 2022 23:43:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1AAA9C15D59;
	Mon, 28 Mar 2022 23:43:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BCF2F1949761;
	Mon, 28 Mar 2022 23:43:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2AE8B1947BBF
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 23:43:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED361C15D59; Mon, 28 Mar 2022 23:43:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E93E5C15D61
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 23:43:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAA273801EC3
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 23:43:36 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-vlawHfiVPjexxE83KhZ_2w-1; Mon, 28 Mar 2022 19:43:34 -0400
X-MC-Unique: vlawHfiVPjexxE83KhZ_2w-1
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="259094471"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; d="scan'208";a="259094471"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Mar 2022 16:43:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; d="scan'208";a="652455642"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
 by orsmga004.jf.intel.com with ESMTP; 28 Mar 2022 16:43:30 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1nYz1G-0002Q8-6C; Mon, 28 Mar 2022 23:43:30 +0000
Date: Tue, 29 Mar 2022 07:42:54 +0800
From: kernel test robot <lkp@intel.com>
To: Kirill Tkhai <kirill.tkhai@openvz.org>, agk@redhat.com,
 snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org,
 linux-kernel@vger.kernel.org, khorenko@virtuozzo.com
Message-ID: <202203290708.kbbyhG39-lkp@intel.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220329/202203290708.kbbyhG39-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c41a15c11909af3588885a88f6622c36dcc9ca35
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kirill-Tkhai/dm-Introduce-dm-qcow2-driver-to-attach-QCOW2-files-as-block-device/20220328-192031
        git checkout c41a15c11909af3588885a88f6622c36dcc9ca35
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   m68k-linux-ld: drivers/md/dm-qcow2-target.o: in function `calc_cached_parameters':
   dm-qcow2-target.c:(.text+0x10ee): undefined reference to `__divdi3'
   m68k-linux-ld: drivers/md/dm-qcow2-map.o: in function `qio_subclu_indexes':
   dm-qcow2-map.c:(.text+0x15e): undefined reference to `__udivdi3'
   m68k-linux-ld: drivers/md/dm-qcow2-map.o: in function `calc_refcounters_map':
   dm-qcow2-map.c:(.text+0x2be): undefined reference to `__divdi3'
>> m68k-linux-ld: dm-qcow2-map.c:(.text+0x2e8): undefined reference to `__moddi3'
   m68k-linux-ld: drivers/md/dm-qcow2-map.o: in function `process_embedded_qios':
   dm-qcow2-map.c:(.text+0x38fa): undefined reference to `__divdi3'
   m68k-linux-ld: drivers/md/dm-qcow2-map.o: in function `parse_metadata':
   dm-qcow2-map.c:(.text+0x4d7a): undefined reference to `__divdi3'
>> m68k-linux-ld: dm-qcow2-map.c:(.text+0x4d98): undefined reference to `__divdi3'
   m68k-linux-ld: dm-qcow2-map.c:(.text+0x4e00): undefined reference to `__moddi3'
   m68k-linux-ld: dm-qcow2-map.c:(.text+0x4e26): undefined reference to `__divdi3'
   m68k-linux-ld: drivers/md/dm-qcow2-map.o: in function `relocate_refcount_table':
   dm-qcow2-map.c:(.text+0x52ce): undefined reference to `__udivdi3'
   `.exit.text' referenced in section `.data' of sound/soc/codecs/tlv320adc3xxx.o: defined in discarded section `.exit.text' of sound/soc/codecs/tlv320adc3xxx.o

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

