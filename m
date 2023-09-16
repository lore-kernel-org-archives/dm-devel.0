Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69291CD37B2
	for <dm-devel@archiver.kernel.org>; Sat, 16 Sep 2023 05:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694842592;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ogx8+cvAk3P3AeazyEK7ETff+kl/4d2KouWHEpqY6eU=;
	b=dUE90EWv7BXa6Qknbv1rpF/ZVLZJ6sFJ8thzL7lAsOSWjqQmsr4XnEsqaRi9ty8HiaN5pv
	3WPD4Jz8lW+acbKCZ7Tpe/XEhnBqO8UAnGYFoiOY1nP3LiTlFn9CUkvNqpjIawwB9JfG9H
	smrTPvebs5briIcCl8ABOO7sts9oiQU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-GlKFAvmvPlqtNPhTizjDgQ-1; Sat, 16 Sep 2023 01:36:29 -0400
X-MC-Unique: GlKFAvmvPlqtNPhTizjDgQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9380D85A5BA;
	Sat, 16 Sep 2023 05:36:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 58AA5200E4BC;
	Sat, 16 Sep 2023 05:36:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E3069194658C;
	Sat, 16 Sep 2023 05:36:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 83E631946588
 for <dm-devel@listman.corp.redhat.com>; Sat, 16 Sep 2023 05:36:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F5B11C646; Sat, 16 Sep 2023 05:36:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 56B52170EE
 for <dm-devel@redhat.com>; Sat, 16 Sep 2023 05:36:24 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3578E85A5A8
 for <dm-devel@redhat.com>; Sat, 16 Sep 2023 05:36:24 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-VXwCjAdUPXm-hr60kfeyqA-1; Sat, 16 Sep 2023 01:36:21 -0400
X-MC-Unique: VXwCjAdUPXm-hr60kfeyqA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="443459953"
X-IronPort-AV: E=Sophos;i="6.02,151,1688454000"; d="scan'208";a="443459953"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 15 Sep 2023 22:36:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="694943983"
X-IronPort-AV: E=Sophos;i="6.02,151,1688454000"; d="scan'208";a="694943983"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
 by orsmga003.jf.intel.com with ESMTP; 15 Sep 2023 22:36:19 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qhNya-0003uu-2E;
 Sat, 16 Sep 2023 05:36:16 +0000
Date: Sat, 16 Sep 2023 13:36:10 +0800
From: kernel test robot <lkp@intel.com>
To: Joe Thornber <ejt@redhat.com>
Message-ID: <202309161339.iy8ArDEF-lkp@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [device-mapper-dm:for-next 3/5]
 drivers/md/persistent-data/dm-extent-allocator.c:204:57: sparse: sparse:
 incorrect type in argument 2 (different base types)
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   526abb2e9c152c30d398d46e48fe8176640192c2
commit: 1c684a9c9a6efbcb28a4d00bc9b6d40a4a141921 [3/5] dm persistent data: Introduce extent allocator
config: i386-randconfig-062-20230916 (https://download.01.org/0day-ci/archive/20230916/202309161339.iy8ArDEF-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230916/202309161339.iy8ArDEF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309161339.iy8ArDEF-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/md/persistent-data/dm-extent-allocator.c:204:57: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted gfp_t [usertype] flags @@     got int flags @@
   drivers/md/persistent-data/dm-extent-allocator.c:204:57: sparse:     expected restricted gfp_t [usertype] flags
   drivers/md/persistent-data/dm-extent-allocator.c:204:57: sparse:     got int flags
>> drivers/md/persistent-data/dm-extent-allocator.c:252:48: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int flags @@     got restricted gfp_t @@
   drivers/md/persistent-data/dm-extent-allocator.c:252:48: sparse:     expected int flags
   drivers/md/persistent-data/dm-extent-allocator.c:252:48: sparse:     got restricted gfp_t
>> drivers/md/persistent-data/dm-extent-allocator.c:532:41: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int flags @@     got restricted gfp_t [usertype] @@
   drivers/md/persistent-data/dm-extent-allocator.c:532:41: sparse:     expected int flags
   drivers/md/persistent-data/dm-extent-allocator.c:532:41: sparse:     got restricted gfp_t [usertype]

vim +204 drivers/md/persistent-data/dm-extent-allocator.c

   187	
   188	/**
   189	 * alloc_node_list - Allocates a list of nodes.
   190	 * @nr: Number of nodes to allocate.
   191	 * @flags: Flags to pass to kmalloc.
   192	 * @result: Pointer to the list head to store the allocated nodes.
   193	 *
   194	 * Used to initialise the free list of nodes.
   195	 * Returns: 0 on success, or -ENOMEM if allocation failed.
   196	 */
   197	static int alloc_node_list(unsigned nr, int flags, struct list_head *result)
   198	{
   199		int i;
   200	
   201		INIT_LIST_HEAD(result);
   202	
   203		for (i = 0; i < nr; i++) {
 > 204			struct ea_node *n = kmalloc(sizeof(*n), flags);
   205			struct list_head *l = (struct list_head *) n;
   206			if (!n) {
   207				free_node_list(result);
   208				return -ENOMEM;
   209			}
   210	
   211			list_add(l, result);
   212		}
   213	
   214		return 0;
   215	}
   216	
   217	/**
   218	 * __prealloc_nodes - Preallocates nodes for allocation contexts.
   219	 * @ea: Pointer to the extent allocator.
   220	 * @nr: Number of nodes to preallocate.
   221	 */
   222	static void __prealloc_nodes(struct dm_extent_allocator *ea, unsigned nr, int flags)
   223	{
   224		int r;
   225		struct list_head new_nodes;
   226	
   227		r = alloc_node_list(nr, flags, &new_nodes);
   228		if (!r) {
   229			struct list_head *e, *tmp;
   230			list_for_each_safe(e, tmp, &new_nodes) {
   231				list_del(e);
   232				__free_node(ea, (struct ea_node *)e);
   233			}
   234			ea->nr_preallocated_nodes += nr;
   235		}
   236	}
   237	
   238	struct dm_extent_allocator *dm_extent_allocator_create(uint64_t nr_blocks)
   239	{
   240		struct dm_extent_allocator *ea = kmalloc(sizeof(*ea), GFP_KERNEL);
   241	
   242		if (!ea)
   243			return NULL;
   244	
   245		spin_lock_init(&ea->lock);
   246		ea->nr_blocks = nr_blocks;
   247		ea->nr_preallocated_nodes = 0;
   248		ea->nr_free_nodes = 0;
   249		ea->nr_allocation_contexts = 0;
   250	
   251		INIT_LIST_HEAD(&ea->free_nodes);
 > 252		__prealloc_nodes(ea, INITIAL_NR_NODES, GFP_KERNEL);
   253		INIT_LIST_HEAD(&ea->allocation_contexts);
   254		__setup_initial_root(ea);
   255	
   256		return ea;
   257	}
   258	EXPORT_SYMBOL_GPL(dm_extent_allocator_create);
   259	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

