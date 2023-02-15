Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B463C61DA4
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 03:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676431068;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AzKCj5ZaFqL6a6nO5WZElPAXaK2JnE+zlLVe2y3hFzs=;
	b=WZ2QKMDhVR7EMqkrlfB/D2EJ9u54HylMPDoDNE1O3GhNwpfEY0Zh6W5lmGk89dlZUJzHHA
	Kjugr/9teLLeSDTKKmu1zrZfxBB3oCFk8kDsIcyAKYujTzBbVReCVJ9SrdbAUY0ihGrbYa
	JYGLg9AhdN0KUFpF60zRePS6NplTLKE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-euM0ndVXNyKZ5QIwE088-Q-1; Tue, 14 Feb 2023 22:17:44 -0500
X-MC-Unique: euM0ndVXNyKZ5QIwE088-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80BF0101A52E;
	Wed, 15 Feb 2023 03:17:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10CF840B40C9;
	Wed, 15 Feb 2023 03:17:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D4A5F1946588;
	Wed, 15 Feb 2023 03:17:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B01131946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 03:17:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A4E1C18EC7; Wed, 15 Feb 2023 03:17:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CA4618EC2
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 03:17:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C7BD1869B60
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 03:17:40 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-BBN55FAnOYOmcGDv-H90Lg-1; Tue, 14 Feb 2023 22:17:39 -0500
X-MC-Unique: BBN55FAnOYOmcGDv-H90Lg-1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="358750931"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; d="scan'208";a="358750931"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 14 Feb 2023 19:16:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="662776464"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; d="scan'208";a="662776464"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
 by orsmga007.jf.intel.com with ESMTP; 14 Feb 2023 19:16:30 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1pS8HV-0008yf-2C;
 Wed, 15 Feb 2023 03:16:29 +0000
Date: Wed, 15 Feb 2023 11:16:03 +0800
From: kernel test robot <lkp@intel.com>
To: Yang Shi <shy828301@gmail.com>, mgorman@techsingularity.net,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 akpm@linux-foundation.org
Message-ID: <202302151051.i9q3I0ia-lkp@intel.com>
References: <20230214190221.1156876-4-shy828301@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230214190221.1156876-4-shy828301@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [v2 PATCH 3/5] mm: mempool: introduce page bulk
 allocator
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
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Yang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.2-rc8 next-20230214]
[cannot apply to device-mapper-dm/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yang-Shi/mm-page_alloc-add-API-for-bulk-allocator-with-callback/20230215-030305
patch link:    https://lore.kernel.org/r/20230214190221.1156876-4-shy828301%40gmail.com
patch subject: [v2 PATCH 3/5] mm: mempool: introduce page bulk allocator
config: loongarch-randconfig-r006-20230212 (https://download.01.org/0day-ci/archive/20230215/202302151051.i9q3I0ia-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ecf5ea78b27092c35d884fad653f53d599d9ddba
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yang-Shi/mm-page_alloc-add-API-for-bulk-allocator-with-callback/20230215-030305
        git checkout ecf5ea78b27092c35d884fad653f53d599d9ddba
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash drivers/scsi/snic/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302151051.i9q3I0ia-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/snic/snic_scsi.c:4:
>> include/linux/mempool.h:18:48: warning: 'struct page' declared inside parameter list will not be visible outside of this definition or declaration
      18 |                                         struct page **page_array,
         |                                                ^~~~
   include/linux/mempool.h:71:51: warning: 'struct page' declared inside parameter list will not be visible outside of this definition or declaration
      71 |                                            struct page **page_array);
         |                                                   ^~~~
   include/linux/mempool.h:74:59: warning: 'struct page' declared inside parameter list will not be visible outside of this definition or declaration
      74 |                                         void (*cb)(struct page *, void *),
         |                                                           ^~~~


vim +18 include/linux/mempool.h

    15	
    16	typedef unsigned int (mempool_alloc_pages_bulk_t)(gfp_t gfp_mask,
    17						unsigned int nr, void *pool_data,
  > 18						struct page **page_array,
    19						void (*cb)(struct page *, void *),
    20						void *data);
    21	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

