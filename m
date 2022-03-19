Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE680C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 19 Mar 2022 08:15:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-PWPQLARUOfe1jAitrtyb-A-1; Sat, 19 Mar 2022 04:15:20 -0400
X-MC-Unique: PWPQLARUOfe1jAitrtyb-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D245A185A7A4;
	Sat, 19 Mar 2022 08:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B8732166B25;
	Sat, 19 Mar 2022 08:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5CFE1194035B;
	Sat, 19 Mar 2022 08:15:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1DB991940341
 for <dm-devel@listman.corp.redhat.com>; Sat, 19 Mar 2022 08:15:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DEACF400F72A; Sat, 19 Mar 2022 08:15:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA2CC40CF8F2
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 08:15:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC05D29AB443
 for <dm-devel@redhat.com>; Sat, 19 Mar 2022 08:15:14 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-Z8e8urX4OvGZP73steKoxg-1; Sat, 19 Mar 2022 04:15:12 -0400
X-MC-Unique: Z8e8urX4OvGZP73steKoxg-1
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237229133"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; d="scan'208";a="237229133"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 19 Mar 2022 01:14:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; d="scan'208";a="691598370"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
 by fmsmga001.fm.intel.com with ESMTP; 19 Mar 2022 01:14:04 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
 (envelope-from <lkp@intel.com>)
 id 1nVUDr-000Fiu-9z; Sat, 19 Mar 2022 08:14:03 +0000
Date: Sat, 19 Mar 2022 16:13:44 +0800
From: kernel test robot <lkp@intel.com>
To: Jane Chu <jane.chu@oracle.com>, david@fromorbit.com, djwong@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, agk@redhat.com,
 snitzer@redhat.com, dm-devel@redhat.com, ira.weiny@intel.com,
 willy@infradead.org, vgoyal@redhat.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <202203191637.PK2oJUeq-lkp@intel.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
Cc: kbuild-all@lists.01.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220319/202203191637.PK2oJUeq-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/71b9b09529b207ce15667c1f5fba4b727b6754e6
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jane-Chu/DAX-poison-recovery/20220319-143144
        git checkout 71b9b09529b207ce15667c1f5fba4b727b6754e6
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/mm/pat/ fs/fuse/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/mm/pat/set_memory.c:1935:5: warning: no previous prototype for 'set_mce_nospec' [-Wmissing-prototypes]
    1935 | int set_mce_nospec(unsigned long pfn, bool unmap)
         |     ^~~~~~~~~~~~~~
>> arch/x86/mm/pat/set_memory.c:1968:5: warning: no previous prototype for 'clear_mce_nospec' [-Wmissing-prototypes]
    1968 | int clear_mce_nospec(unsigned long pfn)
         |     ^~~~~~~~~~~~~~~~


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

