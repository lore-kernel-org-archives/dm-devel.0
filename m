Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63398ECAAD1
	for <dm-devel@archiver.kernel.org>; Sat, 27 Aug 2022 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661625444;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JYTYuqsLnUSCnFpaYSR95aDK0WbcxQ0aEQZE0CCB2TQ=;
	b=Curj7mxfvk6sKcI99hp3tYuvX8ahc9gR/g2934sc7YC3d/3AKANVrcosbEEXH7OnyoREjf
	nynz3rsVt2D0VlI/Ro0Vev9NhQ49BifhtyYLwdmPFzWaz0as5WVv5Y9Qp/AMBkLsgPTCZN
	48I2D27dsXlkD6erTI+EFNpv7p8d/xE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-M_Jc39r7NgCXTuSBP1GA3g-1; Sat, 27 Aug 2022 14:37:22 -0400
X-MC-Unique: M_Jc39r7NgCXTuSBP1GA3g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B849B101A54E;
	Sat, 27 Aug 2022 18:37:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96162403349;
	Sat, 27 Aug 2022 18:37:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 461A11946A45;
	Sat, 27 Aug 2022 18:37:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B08A21946A44
 for <dm-devel@listman.corp.redhat.com>; Sat, 27 Aug 2022 18:37:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60278400F36; Sat, 27 Aug 2022 18:37:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C497492C3B
 for <dm-devel@redhat.com>; Sat, 27 Aug 2022 18:37:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4589685A585
 for <dm-devel@redhat.com>; Sat, 27 Aug 2022 18:37:15 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-YyTKniAMMpGo3bCc-zfTSg-1; Sat, 27 Aug 2022 14:37:13 -0400
X-MC-Unique: YyTKniAMMpGo3bCc-zfTSg-1
X-IronPort-AV: E=McAfee;i="6500,9779,10452"; a="356397858"
X-IronPort-AV: E=Sophos;i="5.93,269,1654585200"; d="scan'208";a="356397858"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 27 Aug 2022 11:36:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,269,1654585200"; d="scan'208";a="644000802"
Received: from lkp-server01.sh.intel.com (HELO fc16deae1c42) ([10.239.97.150])
 by orsmga001.jf.intel.com with ESMTP; 27 Aug 2022 11:36:08 -0700
Received: from kbuild by fc16deae1c42 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1oS0fA-0000NE-0q;
 Sat, 27 Aug 2022 18:36:08 +0000
Date: Sun, 28 Aug 2022 02:35:32 +0800
From: kernel test robot <lkp@intel.com>
To: Shaomin Deng <dengshaomin@cdjrlc.com>, agk@redhat.com,
 snitzer@kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Message-ID: <202208280213.3Ws9aJBm-lkp@intel.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
Cc: Shaomin Deng <dengshaomin@cdjrlc.com>, kbuild-all@lists.01.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20220828/202208280213.3Ws9aJBm-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/fd20974ffc753b102401c766eb62117c276a1527
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shaomin-Deng/dm-Remove-the-unneeeded-variable/20220828-004044
        git checkout fd20974ffc753b102401c766eb62117c276a1527
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/dm-dirty-log.h:16,
                    from drivers/md/dm-log.c:13:
   drivers/md/dm-log.c: In function 'disk_status':
>> include/linux/device-mapper.h:615:22: error: 'sz' undeclared (first use in this function); did you mean 's8'?
     615 | #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
         |                      ^~
   drivers/md/dm-log.c:810:17: note: in expansion of macro 'DMEMIT'
     810 |                 DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
         |                 ^~~~~~
   include/linux/device-mapper.h:615:22: note: each undeclared identifier is reported only once for each function it appears in
     615 | #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
         |                      ^~
   drivers/md/dm-log.c:810:17: note: in expansion of macro 'DMEMIT'
     810 |                 DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
         |                 ^~~~~~


vim +615 include/linux/device-mapper.h

0da336e5fab75c Alasdair G Kergon 2008-04-24  614  
0da336e5fab75c Alasdair G Kergon 2008-04-24 @615  #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
0da336e5fab75c Alasdair G Kergon 2008-04-24  616  			  0 : scnprintf(result + sz, maxlen - sz, x))
0da336e5fab75c Alasdair G Kergon 2008-04-24  617  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

