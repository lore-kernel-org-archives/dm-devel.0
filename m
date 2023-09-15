Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD146EE6457
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 12:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694780767;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PCdemlXhRRWVnMmt38e4O4IsF3xtAqbLVXDBKWlVSUw=;
	b=AmBgu3YZDd5MM7fUFlw/RbwyGBlPycfcd6VgwzyyltEkyTVlFrvg6WQN4J6Ixns5iaMTq2
	YN/yUfS+iKvhGL+zrNCof3oKnZo2I1f6IHKGjAPjtq7Yl4Wj5IXeXUatyNTryJZOnx9OCd
	Xo2/Mq7o/RpmLgkNcRgCO3+W6k9AIEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-Ic4eLk74MQ2TCQgMszlPUg-1; Fri, 15 Sep 2023 08:26:03 -0400
X-MC-Unique: Ic4eLk74MQ2TCQgMszlPUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 239B680A08D;
	Fri, 15 Sep 2023 12:26:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A812B1C64A;
	Fri, 15 Sep 2023 12:26:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E9C4194658C;
	Fri, 15 Sep 2023 12:26:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 820CA1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 12:26:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 537BA176C3; Fri, 15 Sep 2023 12:26:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C5D628FB
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 12:26:00 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28C65805B29
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 12:26:00 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-MJWZSkrtPo-CPSh0AbCfQA-1; Fri, 15 Sep 2023 08:25:58 -0400
X-MC-Unique: MJWZSkrtPo-CPSh0AbCfQA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="358650460"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; d="scan'208";a="358650460"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 15 Sep 2023 05:25:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="918637894"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; d="scan'208";a="918637894"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
 by orsmga005.jf.intel.com with ESMTP; 15 Sep 2023 05:25:55 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qh7tQ-0002xV-2i;
 Fri, 15 Sep 2023 12:25:52 +0000
Date: Fri, 15 Sep 2023 20:25:33 +0800
From: kernel test robot <lkp@intel.com>
To: Joe Thornber <ejt@redhat.com>
Message-ID: <202309152007.7euOF5Fr-lkp@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [device-mapper-dm:for-next 2/4]
 dm-extent-allocator.c:undefined reference to `__udivdi3'
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 oe-kbuild-all@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   df3f51f6ca53e525420cd4cf4c7d9f5cabe9a29e
commit: b97bcee4b9999c9f5aadc06317ade18c5cbe37f6 [2/4] dm persistent data: Introduce extent allocator
config: i386-buildonly-randconfig-004-20230915 (https://download.01.org/0day-ci/archive/20230915/202309152007.7euOF5Fr-lkp@intel.com/config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230915/202309152007.7euOF5Fr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309152007.7euOF5Fr-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/md/persistent-data/dm-extent-allocator.o: in function `dm_alloc_context_alloc':
>> dm-extent-allocator.c:(.text+0x773): undefined reference to `__udivdi3'
>> ld: dm-extent-allocator.c:(.text+0x791): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

