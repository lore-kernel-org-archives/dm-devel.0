Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC54ECAAD5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Aug 2022 19:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661629646;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EnhIhw1LIptKT/JREtrkxjVhH/l7SIs4FlGQgT49U+w=;
	b=V1sTZOh2MdRZ+OZUndr9epfJ6ToMM+KJC44FgFNJbjehTNVVStTkk1iGaEzduiRDLghXKY
	wzYNbZU5ZT5ecVVbR4QC699H5FjNnGRDnNHAOifEuCStT/r/jND9oQWV35/JQ4Ac/aWXXd
	Ms4H+e7eNRsOl/PV+VKPz/+t5XNKZ60=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-qR-8uhoXP-yr2MiQIo5UiA-1; Sat, 27 Aug 2022 15:47:22 -0400
X-MC-Unique: qR-8uhoXP-yr2MiQIo5UiA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC1FD811E76;
	Sat, 27 Aug 2022 19:47:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E2CD4010FA0;
	Sat, 27 Aug 2022 19:47:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C42F1946A45;
	Sat, 27 Aug 2022 19:47:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B52AA1946A44
 for <dm-devel@listman.corp.redhat.com>; Sat, 27 Aug 2022 19:47:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A449E2166B29; Sat, 27 Aug 2022 19:47:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F3BF2166B26
 for <dm-devel@redhat.com>; Sat, 27 Aug 2022 19:47:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C82138041CA
 for <dm-devel@redhat.com>; Sat, 27 Aug 2022 19:47:17 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-lcZneb7xM7q3BIVPQLubEg-1; Sat, 27 Aug 2022 15:47:15 -0400
X-MC-Unique: lcZneb7xM7q3BIVPQLubEg-1
X-IronPort-AV: E=McAfee;i="6500,9779,10452"; a="356401254"
X-IronPort-AV: E=Sophos;i="5.93,269,1654585200"; d="scan'208";a="356401254"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 27 Aug 2022 12:47:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,269,1654585200"; d="scan'208";a="561789386"
Received: from lkp-server01.sh.intel.com (HELO fc16deae1c42) ([10.239.97.150])
 by orsmga003.jf.intel.com with ESMTP; 27 Aug 2022 12:47:12 -0700
Received: from kbuild by fc16deae1c42 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1oS1lv-0000QT-18;
 Sat, 27 Aug 2022 19:47:11 +0000
Date: Sun, 28 Aug 2022 03:46:18 +0800
From: kernel test robot <lkp@intel.com>
To: Shaomin Deng <dengshaomin@cdjrlc.com>, agk@redhat.com,
 snitzer@kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Message-ID: <202208280313.Avg378Ql-lkp@intel.com>
References: <20220827163848.24296-1-dengshaomin@cdjrlc.com>
MIME-Version: 1.0
In-Reply-To: <20220827163848.24296-1-dengshaomin@cdjrlc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] dm: Remove the unneeeded variable
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
Cc: Shaomin Deng <dengshaomin@cdjrlc.com>, llvm@lists.linux.dev,
 kbuild-all@lists.01.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Shaomin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on v6.0-rc2]
[also build test ERROR on linus/master next-20220826]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shaomin-Deng/dm-Remove-the-unneeeded-variable/20220828-004044
base:    1c23f9e627a7b412978b4e852793c5e3c3efc555
config: riscv-randconfig-r003-20220828 (https://download.01.org/0day-ci/archive/20220828/202208280313.Avg378Ql-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project a2100daf12fb980a29fd1a9c85ccf8eaaaf79730)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/fd20974ffc753b102401c766eb62117c276a1527
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shaomin-Deng/dm-Remove-the-unneeeded-variable/20220828-004044
        git checkout fd20974ffc753b102401c766eb62117c276a1527
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/md/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/md/dm-log.c:810:3: error: use of undeclared identifier 'sz'
                   DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
                   ^
   include/linux/device-mapper.h:615:22: note: expanded from macro 'DMEMIT'
   #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
                        ^
>> drivers/md/dm-log.c:810:3: error: use of undeclared identifier 'sz'
   include/linux/device-mapper.h:615:30: note: expanded from macro 'DMEMIT'
   #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
                                ^
>> drivers/md/dm-log.c:810:3: error: use of undeclared identifier 'sz'
   include/linux/device-mapper.h:616:29: note: expanded from macro 'DMEMIT'
                             0 : scnprintf(result + sz, maxlen - sz, x))
                                                    ^
>> drivers/md/dm-log.c:810:3: error: use of undeclared identifier 'sz'
   include/linux/device-mapper.h:616:42: note: expanded from macro 'DMEMIT'
                             0 : scnprintf(result + sz, maxlen - sz, x))
                                                                 ^
   drivers/md/dm-log.c:817:3: error: use of undeclared identifier 'sz'
                   DMEMIT("%s %u %s %u ", log->type->name,
                   ^
   include/linux/device-mapper.h:615:22: note: expanded from macro 'DMEMIT'
   #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
                        ^
   drivers/md/dm-log.c:817:3: error: use of undeclared identifier 'sz'
   include/linux/device-mapper.h:615:30: note: expanded from macro 'DMEMIT'
   #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
                                ^
   drivers/md/dm-log.c:817:3: error: use of undeclared identifier 'sz'
   include/linux/device-mapper.h:616:29: note: expanded from macro 'DMEMIT'
                             0 : scnprintf(result + sz, maxlen - sz, x))
                                                    ^
   drivers/md/dm-log.c:817:3: error: use of undeclared identifier 'sz'
   include/linux/device-mapper.h:616:42: note: expanded from macro 'DMEMIT'
                             0 : scnprintf(result + sz, maxlen - sz, x))
                                                                 ^
   drivers/md/dm-log.c:820:3: error: use of undeclared identifier 'sz'
                   DMEMIT_SYNC;
                   ^
   drivers/md/dm-log.c:776:3: note: expanded from macro 'DMEMIT_SYNC'
                   DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
                   ^
   include/linux/device-mapper.h:615:22: note: expanded from macro 'DMEMIT'
   #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
                        ^
   drivers/md/dm-log.c:820:3: error: use of undeclared identifier 'sz'
   drivers/md/dm-log.c:776:3: note: expanded from macro 'DMEMIT_SYNC'
                   DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
                   ^
   include/linux/device-mapper.h:615:30: note: expanded from macro 'DMEMIT'
   #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
                                ^
   drivers/md/dm-log.c:820:3: error: use of undeclared identifier 'sz'
   drivers/md/dm-log.c:776:3: note: expanded from macro 'DMEMIT_SYNC'
                   DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
                   ^
   include/linux/device-mapper.h:616:29: note: expanded from macro 'DMEMIT'
                             0 : scnprintf(result + sz, maxlen - sz, x))
                                                    ^
   drivers/md/dm-log.c:820:3: error: use of undeclared identifier 'sz'
   drivers/md/dm-log.c:776:3: note: expanded from macro 'DMEMIT_SYNC'
                   DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
                   ^
   include/linux/device-mapper.h:616:42: note: expanded from macro 'DMEMIT'
                             0 : scnprintf(result + sz, maxlen - sz, x))
                                                                 ^
   12 errors generated.


vim +/sz +810 drivers/md/dm-log.c

^1da177e4c3f41 Linus Torvalds     2005-04-16  802  
416cd17b198221 Heinz Mauelshagen  2008-04-24  803  static int disk_status(struct dm_dirty_log *log, status_type_t status,
^1da177e4c3f41 Linus Torvalds     2005-04-16  804  		       char *result, unsigned int maxlen)
^1da177e4c3f41 Linus Torvalds     2005-04-16  805  {
^1da177e4c3f41 Linus Torvalds     2005-04-16  806  	struct log_c *lc = log->context;
^1da177e4c3f41 Linus Torvalds     2005-04-16  807  
^1da177e4c3f41 Linus Torvalds     2005-04-16  808  	switch(status) {
^1da177e4c3f41 Linus Torvalds     2005-04-16  809  	case STATUSTYPE_INFO:
315dcc226f066c Jonathan E Brassow 2007-05-09 @810  		DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
64b30c46e866bb Mikulas Patocka    2009-12-10  811  		       lc->log_dev_flush_failed ? 'F' :
64b30c46e866bb Mikulas Patocka    2009-12-10  812  		       lc->log_dev_failed ? 'D' :
64b30c46e866bb Mikulas Patocka    2009-12-10  813  		       'A');
^1da177e4c3f41 Linus Torvalds     2005-04-16  814  		break;
^1da177e4c3f41 Linus Torvalds     2005-04-16  815  
^1da177e4c3f41 Linus Torvalds     2005-04-16  816  	case STATUSTYPE_TABLE:
^1da177e4c3f41 Linus Torvalds     2005-04-16  817  		DMEMIT("%s %u %s %u ", log->type->name,
315dcc226f066c Jonathan E Brassow 2007-05-09  818  		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log_dev->name,
^1da177e4c3f41 Linus Torvalds     2005-04-16  819  		       lc->region_size);
^1da177e4c3f41 Linus Torvalds     2005-04-16  820  		DMEMIT_SYNC;
8ec456629d0bf0 Tushar Sugandhi    2021-07-12  821  		break;
8ec456629d0bf0 Tushar Sugandhi    2021-07-12  822  
8ec456629d0bf0 Tushar Sugandhi    2021-07-12  823  	case STATUSTYPE_IMA:
8ec456629d0bf0 Tushar Sugandhi    2021-07-12  824  		*result = '\0';
8ec456629d0bf0 Tushar Sugandhi    2021-07-12  825  		break;
^1da177e4c3f41 Linus Torvalds     2005-04-16  826  	}
^1da177e4c3f41 Linus Torvalds     2005-04-16  827  
fd20974ffc753b Shaomin Deng       2022-08-27  828  	return 0;
^1da177e4c3f41 Linus Torvalds     2005-04-16  829  }
^1da177e4c3f41 Linus Torvalds     2005-04-16  830  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

