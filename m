Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C873C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 19 Mar 2022 08:26:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-Rdkia8xCNyarx536mogHiQ-1; Sat, 19 Mar 2022 04:26:21 -0400
X-MC-Unique: Rdkia8xCNyarx536mogHiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8325101A54C;
	Sat, 19 Mar 2022 08:26:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B44F67AD1;
	Sat, 19 Mar 2022 08:26:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F03C194035B;
	Sat, 19 Mar 2022 08:26:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 336B51940341
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 08:26:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC1A5C15D57; Sat, 19 Mar 2022 08:26:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7FE6C15D42
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 08:26:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEE6D801585
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 08:26:16 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-LS6XJH9nOOedU-2L-56EbQ-1; Sat, 19 Mar 2022 04:26:13 -0400
X-MC-Unique: LS6XJH9nOOedU-2L-56EbQ-1
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="320491978"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; d="scan'208";a="320491978"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 19 Mar 2022 01:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; d="scan'208";a="822924166"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
 by fmsmga005.fm.intel.com with ESMTP; 19 Mar 2022 01:25:04 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1nVUOV-000FjU-HW; Sat, 19 Mar 2022 08:25:03 +0000
Date: Sat, 19 Mar 2022 16:24:07 +0800
From: kernel test robot <lkp@intel.com>
To: Jane Chu <jane.chu@oracle.com>, david@fromorbit.com, djwong@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, agk@redhat.com,
 snitzer@redhat.com, dm-devel@redhat.com, ira.weiny@intel.com,
 willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <202203191603.mQUQZZV5-lkp@intel.com>
References: <20220319062833.3136528-3-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220319062833.3136528-3-jane.chu@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 2/6] x86/mce: relocate
 set{clear}_mce_nospec() functions
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
Cc: llvm@lists.linux.dev, kbuild-all@lists.01.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
config: x86_64-randconfig-a012 (https://download.01.org/0day-ci/archive/20220319/202203191603.mQUQZZV5-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a6e70e4056dff962ec634c5bd4f2f4105a0bef71)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/71b9b09529b207ce15667c1f5fba4b727b6754e6
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jane-Chu/DAX-poison-recovery/20220319-143144
        git checkout 71b9b09529b207ce15667c1f5fba4b727b6754e6
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/mm/pat/ fs/fuse/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/mm/pat/set_memory.c:1935:5: warning: no previous prototype for function 'set_mce_nospec' [-Wmissing-prototypes]
   int set_mce_nospec(unsigned long pfn, bool unmap)
       ^
   arch/x86/mm/pat/set_memory.c:1935:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int set_mce_nospec(unsigned long pfn, bool unmap)
   ^
   static 
>> arch/x86/mm/pat/set_memory.c:1968:5: warning: no previous prototype for function 'clear_mce_nospec' [-Wmissing-prototypes]
   int clear_mce_nospec(unsigned long pfn)
       ^
   arch/x86/mm/pat/set_memory.c:1968:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int clear_mce_nospec(unsigned long pfn)
   ^
   static 
   2 warnings generated.


vim +/set_mce_nospec +1935 arch/x86/mm/pat/set_memory.c

  1927	
  1928	#ifdef CONFIG_X86_64
  1929	/*
  1930	 * Prevent speculative access to the page by either unmapping
  1931	 * it (if we do not require access to any part of the page) or
  1932	 * marking it uncacheable (if we want to try to retrieve data
  1933	 * from non-poisoned lines in the page).
  1934	 */
> 1935	int set_mce_nospec(unsigned long pfn, bool unmap)
  1936	{
  1937		unsigned long decoy_addr;
  1938		int rc;
  1939	
  1940		/* SGX pages are not in the 1:1 map */
  1941		if (arch_is_platform_page(pfn << PAGE_SHIFT))
  1942			return 0;
  1943		/*
  1944		 * We would like to just call:
  1945		 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
  1946		 * but doing that would radically increase the odds of a
  1947		 * speculative access to the poison page because we'd have
  1948		 * the virtual address of the kernel 1:1 mapping sitting
  1949		 * around in registers.
  1950		 * Instead we get tricky.  We create a non-canonical address
  1951		 * that looks just like the one we want, but has bit 63 flipped.
  1952		 * This relies on set_memory_XX() properly sanitizing any __pa()
  1953		 * results with __PHYSICAL_MASK or PTE_PFN_MASK.
  1954		 */
  1955		decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
  1956	
  1957		if (unmap)
  1958			rc = set_memory_np(decoy_addr, 1);
  1959		else
  1960			rc = set_memory_uc(decoy_addr, 1);
  1961		if (rc)
  1962			pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
  1963		return rc;
  1964	}
  1965	EXPORT_SYMBOL(set_mce_nospec);
  1966	
  1967	/* Restore full speculative operation to the pfn. */
> 1968	int clear_mce_nospec(unsigned long pfn)
  1969	{
  1970		return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
  1971	}
  1972	EXPORT_SYMBOL(clear_mce_nospec);
  1973	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

