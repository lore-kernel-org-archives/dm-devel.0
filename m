Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1AB7EE021C
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 04:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694752753;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9dLIXDFV9GHetyFkgmzQgEk9pXiNFSltlHhoUkDjF+U=;
	b=Hob+VhkNA54Ac68cTPx0ala8Nv3+7bcwQ2ylJHC3lJKvSGPz7LPfv/5mSkzQAxwBU2ASDw
	ZXTGyscAxW/cnuyQAqc4kEnVGZEPPG2MujHwHDYi2Dqcaie+yBeNN1YfMndTztbfpMGP4E
	1ZlrwzMzOadHmOXwIjscbUd0zT2VoFg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-qYbnOedtN3yLWIpwWlDcnA-1; Fri, 15 Sep 2023 00:39:09 -0400
X-MC-Unique: qYbnOedtN3yLWIpwWlDcnA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9760D8678C1;
	Fri, 15 Sep 2023 04:39:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09AB72026D4B;
	Fri, 15 Sep 2023 04:39:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 99B67194658C;
	Fri, 15 Sep 2023 04:38:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A6C4D1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 04:38:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5579C40C6EBF; Fri, 15 Sep 2023 04:38:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E8AE40C6EA8
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 04:38:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29E64102F23B
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 04:38:39 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-W_XdN7rQOnWNnZv1DnZrgQ-1; Fri, 15 Sep 2023 00:38:34 -0400
X-MC-Unique: W_XdN7rQOnWNnZv1DnZrgQ-1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="443218052"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; d="scan'208";a="443218052"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 14 Sep 2023 21:33:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="1075659774"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; d="scan'208";a="1075659774"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
 by fmsmga005.fm.intel.com with ESMTP; 14 Sep 2023 21:33:36 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1qh0WK-0002R5-17;
 Fri, 15 Sep 2023 04:33:32 +0000
Date: Fri, 15 Sep 2023 12:32:17 +0800
From: kernel test robot <lkp@intel.com>
To: Joe Thornber <ejt@redhat.com>
Message-ID: <202309151251.TkVrLtEd-lkp@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [device-mapper-dm:for-next 2/4]
 drivers/md/persistent-data/dm-extent-allocator.c:88: warning: Function
 parameter or member 'n' not described in '__free_node'
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   805d736ee48c10d8770f998127887795ffb0106f
commit: 064fc5e0e09b49033693b07003c142d0be27a009 [2/4] dm persistent data: Introduce extent allocator
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20230915/202309151251.TkVrLtEd-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230915/202309151251.TkVrLtEd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309151251.TkVrLtEd-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/md/persistent-data/dm-extent-allocator.c:88: warning: Function parameter or member 'n' not described in '__free_node'
>> drivers/md/persistent-data/dm-extent-allocator.c:88: warning: Excess function parameter 'node' description in '__free_node'
>> drivers/md/persistent-data/dm-extent-allocator.c:111: warning: Cannot understand  * @ea: Pointer to the extent allocator.
    on line 111 - I thought it was a doc line
>> drivers/md/persistent-data/dm-extent-allocator.c:217: warning: Function parameter or member 'flags' not described in '__prealloc_nodes'
>> drivers/md/persistent-data/dm-extent-allocator.c:313: warning: Function parameter or member 'n' not described in '__split_leaf'
>> drivers/md/persistent-data/dm-extent-allocator.c:313: warning: Excess function parameter 'node' description in '__split_leaf'


vim +88 drivers/md/persistent-data/dm-extent-allocator.c

    81	
    82	/**
    83	 * __free_node - Frees a node in the extent allocator.
    84	 * @ea: Pointer to the extent allocator.
    85	 * @node: Node to free.
    86	 */
    87	static inline void __free_node(struct dm_extent_allocator *ea, struct node *n)
  > 88	{
    89		struct list_head *l = (struct list_head *)n;
    90	
    91		list_add(l, &ea->free_nodes);
    92		ea->nr_free_nodes++;
    93	}
    94	
    95	/**
    96	 * __alloc_node - Allocates a node from the extent allocator.
    97	 * @ea: Pointer to the extent allocator.
    98	 */
    99	static inline struct node *__alloc_node(struct dm_extent_allocator *ea)
   100	{
   101		struct list_head *l;
   102	
   103		l = ea->free_nodes.next;
   104		list_del(l);
   105		ea->nr_free_nodes--;
   106	
   107		return (struct node *) l;
   108	}
   109	
   110	/**
 > 111	 * @ea: Pointer to the extent allocator.
   112	 * @node: Index of the node to query.
   113	 *
   114	 * Returns: The number of free blocks in the node.
   115	 */
   116	static inline uint64_t __nr_free_blocks(struct node *n)
   117	{
   118		if (!n)
   119			return 0;
   120	
   121		if (n->is_leaf)
   122			return n->end - n->begin;
   123		else
   124			return n->u.internal.nr_free;
   125	}
   126	
   127	/**
   128	 * __free_tree - Frees all nodes in a tree.
   129	 * @ea: Pointer to the extent allocator.
   130	 * @n: Pointer to the root node of the tree to free.
   131	 */
   132	static void __free_tree(struct dm_extent_allocator *ea, struct node *n)
   133	{
   134		if (!n)
   135			return;
   136	
   137		if (n->is_leaf)
   138			__free_node(ea, n);
   139		else {
   140			__free_tree(ea, n->u.internal.left);
   141			__free_tree(ea, n->u.internal.right);
   142		}
   143	}
   144	
   145	/**
   146	 * __setup_initial_root - Sets up the initial root node for the extent allocator.
   147	 * @ea: Pointer to the extent allocator.
   148	 *
   149	 * The root node is a leaf node that spans the entire device.
   150	 */
   151	static void __setup_initial_root(struct dm_extent_allocator *ea)
   152	{
   153		struct node *n;
   154		struct leaf *l;
   155	
   156		n = ea->root = __alloc_node(ea);
   157		n->is_left_child = true;
   158		n->is_leaf = true;
   159		n->nr_holders = 0;
   160		n->begin = 0;
   161		n->end = ea->nr_blocks;
   162		n->parent = NULL;
   163	
   164		l = &n->u.leaf;
   165		INIT_LIST_HEAD(&l->holders);
   166	}
   167	
   168	/**
   169	 * free_node_list - Frees a list of nodes.
   170	 * @l: Pointer to the list head of the nodes to free.
   171	 */
   172	static void free_node_list(struct list_head *l)
   173	{
   174		struct list_head *e, *tmp;
   175	
   176		list_for_each_safe(e, tmp, l) {
   177			list_del(e);
   178			kfree(e);
   179		}
   180	}
   181	
   182	/**
   183	 * alloc_node_list - Allocates a list of nodes.
   184	 * @nr: Number of nodes to allocate.
   185	 * @flags: Flags to pass to kmalloc.
   186	 * @result: Pointer to the list head to store the allocated nodes.
   187	 *
   188	 * Used to initialise the free list of nodes.
   189	 * Returns: 0 on success, or -ENOMEM if allocation failed.
   190	 */
   191	static int alloc_node_list(unsigned nr, int flags, struct list_head *result)
   192	{
   193		int i;
   194	
   195		INIT_LIST_HEAD(result);
   196	
   197		for (i = 0; i < nr; i++) {
   198			struct node *n = kmalloc(sizeof(*n), flags);
   199			struct list_head *l = (struct list_head *) n;
   200			if (!n) {
   201				free_node_list(result);
   202				return -ENOMEM;
   203			}
   204	
   205			list_add(l, result);
   206		}
   207	
   208		return 0;
   209	}
   210	
   211	/**
   212	 * __prealloc_nodes - Preallocates nodes for allocation contexts.
   213	 * @ea: Pointer to the extent allocator.
   214	 * @nr: Number of nodes to preallocate.
   215	 */
   216	static void __prealloc_nodes(struct dm_extent_allocator *ea, unsigned nr, int flags)
 > 217	{
   218		int r;
   219		struct list_head new_nodes;
   220	
   221		r = alloc_node_list(nr, flags, &new_nodes);
   222		if (!r) {
   223			struct list_head *e, *tmp;
   224			list_for_each_safe(e, tmp, &new_nodes) {
   225				list_del(e);
   226				__free_node(ea, (struct node *)e);
   227			}
   228			ea->nr_preallocated_nodes += nr;
   229		}
   230	}
   231	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

