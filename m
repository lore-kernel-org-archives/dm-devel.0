Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9270CD37A7
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 19:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694807581;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t9qUaUb1Jkxh9Ts7bjtv2ReI1DzeZJjuNLWpR/3jOG0=;
	b=PvFCqTKppqvagkBxDfe77LehQuQR4MwMhBpM4BARE1IaHT7q2yVbIpyT5FYo4ERfMBK5G2
	nCLqx5Zl1l7m27Ww5P+DIo8Ur7zIVNpoXxYTZTIShXI/ndLO+q6YyhYLJY34f2MLqMc45H
	815qNo7jskFv+8MR6A9PZ1vViKWFs/c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-lqWH8CMSOSq_gLyNpWfCCQ-1; Fri, 15 Sep 2023 15:52:57 -0400
X-MC-Unique: lqWH8CMSOSq_gLyNpWfCCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B75F98582AF;
	Fri, 15 Sep 2023 19:52:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 279A31CBC6;
	Fri, 15 Sep 2023 19:52:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E784219465BC;
	Fri, 15 Sep 2023 19:52:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1878A19465B7
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 19:51:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DAC5E1CBC8; Fri, 15 Sep 2023 19:51:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D44F21D0AD
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 19:51:15 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B62C6185A79C
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 19:51:15 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-f83pcdDmOjispvY9NP87_g-1; Fri, 15 Sep 2023 15:51:13 -0400
X-MC-Unique: f83pcdDmOjispvY9NP87_g-1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="364381158"
X-IronPort-AV: E=Sophos;i="6.02,150,1688454000"; d="scan'208";a="364381158"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 15 Sep 2023 12:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="1075888780"
X-IronPort-AV: E=Sophos;i="6.02,150,1688454000"; d="scan'208";a="1075888780"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
 by fmsmga005.fm.intel.com with ESMTP; 15 Sep 2023 12:51:10 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qhEqC-0003La-31;
 Fri, 15 Sep 2023 19:51:07 +0000
Date: Sat, 16 Sep 2023 03:49:53 +0800
From: kernel test robot <lkp@intel.com>
To: Joe Thornber <ejt@redhat.com>
Message-ID: <202309160312.k1ou4uxF-lkp@intel.com>
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
 drivers/md/persistent-data/dm-extent-allocator.c:373: undefined reference
 to `__udivdi3'
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
head:   785f3bb19d40050d0f40c07cbe6345e361acdcae
commit: b97bcee4b9999c9f5aadc06317ade18c5cbe37f6 [2/4] dm persistent data: Introduce extent allocator
config: i386-randconfig-013-20230915 (https://download.01.org/0day-ci/archive/20230916/202309160312.k1ou4uxF-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230916/202309160312.k1ou4uxF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309160312.k1ou4uxF-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/md/persistent-data/dm-extent-allocator.o: in function `__select_child':
>> drivers/md/persistent-data/dm-extent-allocator.c:373: undefined reference to `__udivdi3'
>> ld: drivers/md/persistent-data/dm-extent-allocator.c:374: undefined reference to `__udivdi3'
>> ld: drivers/md/persistent-data/dm-extent-allocator.c:374: undefined reference to `__udivdi3'
>> ld: drivers/md/persistent-data/dm-extent-allocator.c:373: undefined reference to `__udivdi3'


vim +373 drivers/md/persistent-data/dm-extent-allocator.c

   359	
   360	/**
   361	 * __select_child - Selects the best child node to allocate from in the extent allocator.
   362	 * @ea: Pointer to the extent allocator.
   363	 * @left: left child node.
   364	 * @right: right child node.
   365	 *
   366	 * The best child is the one with the highest ratio of free blocks to holders. If the
   367	 * ratios are equal, the left child is preferred.
   368	 */
   369	static struct node **__select_child(struct dm_extent_allocator *ea, struct node **left, struct node **right)
   370	{
   371		uint64_t left_score, right_score;
   372	
 > 373		left_score = __nr_free_blocks(*left) / ((*left)->nr_holders + 1);
 > 374		right_score = __nr_free_blocks(*right) / ((*right)->nr_holders + 1);
   375	
   376		if (left_score >= right_score)
   377			return left;
   378		else
   379			return right;
   380	}
   381	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

