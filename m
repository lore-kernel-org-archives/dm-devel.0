Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFEFFEDE989
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 02:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694746533;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G/F6Lpxz/TEHTtjUtCTkSKU1Ek2OBBXvxrfqK/TuYbM=;
	b=O4u3T7Xfp6+HQVoEE6m3jfmGRT/yS7jhbozqoilNDAuZHqO1IwJe5Va1Vg2jxJDyoCA8M0
	vPU6aAjVG+9+DDjNSDGV8WxDbXtw2dZ5pw2H0w0iPCvU7r1C04W5LbYBz/7qxxE0EHAvFY
	BQysyavxzkeHgB3eBJDyijtez+BYrzE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-fXeVTIfgNWuqycDB2E_98Q-1; Thu, 14 Sep 2023 22:55:29 -0400
X-MC-Unique: fXeVTIfgNWuqycDB2E_98Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CC9881B54E;
	Fri, 15 Sep 2023 02:55:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71D2128AC;
	Fri, 15 Sep 2023 02:55:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 340FE19465B7;
	Fri, 15 Sep 2023 02:55:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB517194658C
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 02:55:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F58010069B4; Fri, 15 Sep 2023 02:55:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8717210F1BE7
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 02:55:18 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68250101CC82
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 02:55:18 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-8p0ZxG3WO0eFaIjD49H3kA-1; Thu, 14 Sep 2023 22:55:15 -0400
X-MC-Unique: 8p0ZxG3WO0eFaIjD49H3kA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="443202129"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; d="scan'208";a="443202129"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 14 Sep 2023 19:55:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="721513511"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; d="scan'208";a="721513511"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
 by orsmga006.jf.intel.com with ESMTP; 14 Sep 2023 19:55:12 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qgyz7-0002LP-2n;
 Fri, 15 Sep 2023 02:55:09 +0000
Date: Fri, 15 Sep 2023 10:54:53 +0800
From: kernel test robot <lkp@intel.com>
To: Joe Thornber <ejt@redhat.com>
Message-ID: <202309151023.QPBCNoCN-lkp@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [device-mapper-dm:for-next 2/4]
 drivers/md/persistent-data/dm-extent-allocator.c:530:24: error: expected ';
 ' after expression
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
Cc: dm-devel@redhat.com, llvm@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, oe-kbuild-all@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   edcabec81f12dfc9b86b05084bba3232efdc5e4e
commit: 59d814674dd66fc64ba229605174bfe0b8e566d5 [2/4] dm persistent data: Introduce extent allocator
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20230915/202309151023.QPBCNoCN-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230915/202309151023.QPBCNoCN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309151023.QPBCNoCN-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/persistent-data/dm-extent-allocator.c:530:24: error: expected ';' after expression
           spin_unlock(&ea->lock)
                                 ^
                                 ;
   drivers/md/persistent-data/dm-extent-allocator.c:544:24: error: expected ';' after expression
           spin_unlock(&ea->lock)
                                 ^
                                 ;
   2 errors generated.


vim +530 drivers/md/persistent-data/dm-extent-allocator.c

   511	
   512	void dm_alloc_context_get(struct dm_extent_allocator *ea,
   513				  struct dm_alloc_context *ac)
   514	{
   515		spin_lock(&ea->lock);
   516		ac->ea = ea;
   517	
   518		ea->nr_allocation_contexts++;
   519	
   520		/*
   521		 * We try and maintain a couple of nodes per alloc context to avoid sharing.
   522		 * If allocation fails it's no big deal; we'll just get more fragmentation.
   523		 */
   524		if (ea->nr_preallocated_nodes < ea->nr_allocation_contexts * 2)
   525			__prealloc_nodes(ea, 2, GFP_NOIO);
   526	
   527		list_add(&ac->list, &ea->allocation_contexts);
   528		INIT_LIST_HEAD(&ac->holders_list);
   529		ac->leaf = NULL;
 > 530		spin_unlock(&ea->lock)
   531	}
   532	EXPORT_SYMBOL_GPL(dm_alloc_context_get);
   533	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

