Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C315E7D241
	for <dm-devel@archiver.kernel.org>; Tue, 26 Sep 2023 06:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695711550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BZoPg26XP5aJbPsOBIuGsxHL9S2YodwEBWmzBCWYQ78=;
	b=XWKEfjBNQ7fWsthDY+8Ux/7zcibOCIMLy2TZPOnPVT9W/G0Sr6QqummTUg64Hw1/6J3u7N
	/b36snq+bBGmFDvZmUV84FuX6yXRWGRu6LrP4jJCRJseBnZUyfqkY8Z4R6EPi3LMT63H0O
	gCV2qEo4wofogc9nzJ5v9ESC0wY65Js=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-cm__53-HMl26tsUjYCNQlw-1; Tue, 26 Sep 2023 02:59:06 -0400
X-MC-Unique: cm__53-HMl26tsUjYCNQlw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAA2C29ABA38;
	Tue, 26 Sep 2023 06:59:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16E67C15BB8;
	Tue, 26 Sep 2023 06:59:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB62A194658D;
	Tue, 26 Sep 2023 06:59:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8461A194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Sep 2023 05:52:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 40241400F3C; Tue, 26 Sep 2023 05:52:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 37D29492C37
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 05:52:59 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D75729AA2FA
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 05:52:59 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-il-EZUAGMpeFezcHLGqnvg-1; Tue, 26 Sep 2023 01:52:56 -0400
X-MC-Unique: il-EZUAGMpeFezcHLGqnvg-1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="371824875"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; d="scan'208";a="371824875"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 25 Sep 2023 22:51:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="748699253"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; d="scan'208";a="748699253"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
 by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384;
 25 Sep 2023 22:51:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 22:51:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 25 Sep 2023 22:51:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 25 Sep 2023 22:51:50 -0700
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by PH0PR11MB7636.namprd11.prod.outlook.com (2603:10b6:510:26f::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Tue, 26 Sep
 2023 05:51:42 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6813.017; Tue, 26 Sep 2023
 05:51:42 +0000
Date: Tue, 26 Sep 2023 13:51:35 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Joe Thornber <ejt@redhat.com>
Message-ID: <202309261205.37e93c9-oliver.sang@intel.com>
X-ClientProxiedBy: SI2PR01CA0050.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::21) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|PH0PR11MB7636:EE_
X-MS-Office365-Filtering-Correlation-Id: c4fd8008-3339-4e3f-21d2-08dbbe54a8a9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: XvQXGwsTKaqDyTHVKhaqFfBa5uPirt5WVdpxTI9Zh4KpJFITf5oFKISh5p2+FAeQljJlTXEhFobBIR21pC5cQGfn7bGPJjFP+O2XWjhmtdAVhoI14pmBmHCnBR+7U1wcBOEJwm/VIdV93La9Si80mI6D2iTeM3duT9hGoXtDuG/ZXYeVy2yhLRU4bcnpfwXE0/j3AFYZzO8zPTTm2Hdabe3u3pv3/wBRc2f9KUW2kiKRbfKzTOkW4pX2pmLrpzATzpJz7u4hivqa66WH2o1ydZj6bj4fm4FuNeqC6kYK6+c5KdKrPgDDRkb5CVRw8cJ4YFRlcXXm9GsZ6TrVxpNE/DaKOO0XlT3YCIhy5U3BadSGaq7m+qExJKxYHElpc08UurTg8wfuB89Eqrargg+qNmJhOaSL89wVe9arelJOsMUQPOibaCYSJWsXU7VfBLm8sSIZksK37FYZIIITLxZDAFK59hTX0soOuvt0wy3xFKrNWvW3ggHX0cgtgASpyXqbhORNF5kQXdrbGaCS6reX85UzUouSTHEAOSjoIxWq+6Pb0/Q4R/nlcvOzCFrQTwyZTkm6LnI62Prx33fKy4lkiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH8PR11MB6779.namprd11.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(230922051799003)(1800799009)(451199024)(186009)(36756003)(83380400001)(8676002)(5660300002)(82960400001)(26005)(30864003)(6666004)(4326008)(2616005)(8936002)(86362001)(107886003)(6506007)(1076003)(6512007)(6486002)(2906002)(66946007)(41300700001)(45080400002)(38100700002)(966005)(66556008)(316002)(6916009)(66476007)(478600001)(54906003)(579004)(559001);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fAZnCpvttPLmhnsVel/WmtE/2FCVZqgveo91rF8wq7YhqOmCCi83LZ+vRnBE?=
 =?us-ascii?Q?jqok6AVxOdtO8m+4yqfjQduE3pRZkkx9NtUXp15xpQc3aHiNC6k9iVarjC4i?=
 =?us-ascii?Q?3K/B6D35asdbNhw7I8iRW2ghHx5DBO4mdMZJ+C3/+jBrGJYkkG81x/RXKBJw?=
 =?us-ascii?Q?e0HOZnzACCBkgMs9Xs5bY3xRphuhWE53v7DVG4R6i8HoBi9ojiwi7lRAGSx3?=
 =?us-ascii?Q?58AzM5ozNAhDK0BfGyN3T982Qxa7iXQRuKp3AFGKE6PxP14xokkiaJl/FW/j?=
 =?us-ascii?Q?MQP5V1K8wlrQUbdHkkqqft80imY4iC5h01zT6heEvmymAB/7FRS9s8r3KxWK?=
 =?us-ascii?Q?B2gbSi3t/Y5Xm2xT2yafIZRwVU32abAlD0p7UrUgUktqT6tqE899f33DOaQj?=
 =?us-ascii?Q?CGkzE2T8EW0PI2cMZfO/cug4NQmOzbN70M/hKebSaDy5/brQ6VwjZy1VCPWf?=
 =?us-ascii?Q?CAGjfpAJIkIx6X0j0NQQUKxpNHuzv2U28TOGcPyQ3QpvfMwWOV07wTivEDeR?=
 =?us-ascii?Q?Tw68TzF/2gM7haXoh+02Oo5qhPoWqTdjMjh0xJgYndkCdo/qt+uAm6d+1aRD?=
 =?us-ascii?Q?Fx6agVDN4XxcMYlQq0iKWmzUkRt17NkaNb7iST6c2ndRqCbgY4mtGRR8OY4j?=
 =?us-ascii?Q?i/jxVv2K2xWibx9wsba90DtoMhuuVE+/VNIqmPtm8wANt5xtVx6gwTRP6GNe?=
 =?us-ascii?Q?2N9DrN9OGJlBSVAmP455v/qDJa8igJyPKrD+tjxl1wN2ZymfdrVrSJW1Ja0r?=
 =?us-ascii?Q?i7tldfrZU+sduCFbxdfqwLJ+WdVRMsWK5DrUjvnF/ItAOoPwZTtgeK5Q4s5l?=
 =?us-ascii?Q?fOfowpzPdFLQjdXc8glxWxYng/6QzGhwVfiHL1HfkkYjGeKZvM/wNt03ENNn?=
 =?us-ascii?Q?9FqrRHTVt8TXWZ6eymzaDOuAV16uXXOgCjN8bZTYnZE1OB4Kh5TkHfdVIAMV?=
 =?us-ascii?Q?FPY6Hg5/CRufgNkRjz+Btyke3Kujk2WVw+OXajQ0FabSkTkJi+RzedBqblvF?=
 =?us-ascii?Q?IgSS/Nvf56L/z6hKd10wsnZ4ni2tvSv1P1T75szSau2z47CSTkg8f7DQnMw9?=
 =?us-ascii?Q?792I4yDay2Td2AOVnFDixHrwUmgy864MFldSHeEoNKq/Z0FQnbX6i6dzTpSE?=
 =?us-ascii?Q?VhvJOEm+2YEGF2lzi9Mj9qC1YW+PRcJjkfpUTKkLo0ds32jvFskSdpy8hodX?=
 =?us-ascii?Q?oz+WZtGvCqvieNuJCJg5HEwmp6+Loa5TC9QzArUFgtBVZoBXT0WfZVV36Ofj?=
 =?us-ascii?Q?njFb7/l7zg/M6kJcLXVerC/roPbKSbfooL4VySUSt82B/DYjvajo1uiTLOM3?=
 =?us-ascii?Q?YQatp8q1aXBGJcfGNPjA7Qh6vnL7jYRbahxGxTmpCYi47mF582r7WVBY2VT9?=
 =?us-ascii?Q?ZvYC0KVwQkaFdlqrzT4ONxCJBZ80cEVDbK2w7UnLeqNittnlP5aQT1vHFiOx?=
 =?us-ascii?Q?GnsaM3vbTTtmwoJ0BNMbdcv90lEYVPwGuNlKy6lLSQ0TPVRCZP1+3UlVJpZm?=
 =?us-ascii?Q?HdTLNVTQinU0gz6Ihc4KXz0blEM3RnhlOjEZkmYv2mkBNV4wjC7xfYMPRU6o?=
 =?us-ascii?Q?z6p26psjdEb0u0o/n4wBGrvs9Pr8lsyuNRmUJgFfP5MxjxnNMQtal3H1jmwM?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4fd8008-3339-4e3f-21d2-08dbbe54a8a9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 05:51:42.3061 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjt8VlqJOuZiC0tfGSnFcqQg6TXjYeYOhqz41tilvCaUou661UymbDMhYArkf1qzm0DJvkVcudUc5PWu/qxszg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7636
X-OriginatorOrg: intel.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 26 Sep 2023 06:59:01 +0000
Subject: [dm-devel] [linux-next:master] [dm thin] 026e4728c2:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c
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
Cc: lkp@intel.com, Mike Snitzer <snitzer@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>, dm-devel@redhat.com,
 oliver.sang@intel.com, oe-lkp@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



Hello,

kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c" on:

commit: 026e4728c276cdf3ec618a71a38181864596027b ("dm thin: Use the extent allocator for data blocks")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 940fcc189c51032dd0282cbee4497542c982ac59]

in testcase: xfstests
version: xfstests-x86_64-b15b6cc-1_20230828
with following parameters:

	disk: 4HDD
	fs: xfs
	test: generic-group-45



compiler: gcc-12
test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202309261205.37e93c9-oliver.sang@intel.com


[  391.566944][   T11] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1519
[  391.576211][   T11] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 11, name: kworker/u16:0
[  391.585148][   T11] preempt_count: 1, expected: 0
[  391.589848][   T11] RCU nest depth: 0, expected: 0
[  391.594640][   T11] CPU: 6 PID: 11 Comm: kworker/u16:0 Not tainted 6.6.0-rc2-00004-g026e4728c276 #1
[  391.603655][   T11] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  391.612581][   T11] Workqueue: dm-thin do_worker [dm_thin_pool]
[  391.618494][   T11] Call Trace:
[  391.621633][   T11]  <TASK>
[ 391.624420][ T11] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 391.628772][ T11] __might_resched (kernel/sched/core.c:10188) 
[ 391.633379][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 391.638421][ T11] ? cache_get (drivers/md/dm-bufio.c:591) dm_bufio
[ 391.643644][ T11] down_read (include/linux/kernel.h:112 kernel/locking/rwsem.c:1519) 
[ 391.647653][ T11] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[ 391.653215][ T11] ? __flush_write_list (drivers/md/dm-bufio.c:1429) dm_bufio
[ 391.659215][ T11] cache_get (drivers/md/dm-bufio.c:583) dm_bufio
[ 391.664178][ T11] new_read (drivers/md/dm-bufio.c:1832) dm_bufio
[ 391.669048][ T11] ? dm_bufio_client_create (drivers/md/dm-bufio.c:1820) dm_bufio
[ 391.675558][ T11] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[  391.681131][   T11]  ? 0xffffffffc23a2000
[ 391.685131][ T11] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[ 391.690700][ T11] dm_bm_read_lock (drivers/md/persistent-data/dm-block-manager.c:478) dm_persistent_data
[ 391.697059][ T11] ro_step (drivers/md/persistent-data/dm-btree-spine.c:151) dm_persistent_data
[ 391.702721][ T11] btree_lookup_raw+0x3f/0x350 dm_persistent_data
[ 391.710193][ T11] ? arch_stack_walk (arch/x86/kernel/stacktrace.c:24) 
[ 391.714808][ T11] dm_btree_lookup (drivers/md/persistent-data/dm-btree.c:401) dm_persistent_data
[ 391.721255][ T11] ? btree_lookup_raw+0x350/0x350 dm_persistent_data
[ 391.728999][ T11] ? __blk_flush_plug (block/blk-core.c:1149) 
[ 391.733873][ T11] ? filter_irq_stacks (kernel/stacktrace.c:114) 
[ 391.738655][ T11] ? __stack_depot_save (lib/stackdepot.c:379) 
[ 391.743608][ T11] ? kasan_save_stack (mm/kasan/common.c:47) 
[ 391.748308][ T11] disk_ll_load_ie (drivers/md/persistent-data/dm-space-map-common.c:1129) dm_persistent_data
[ 391.754752][ T11] ? disk_ll_commit (drivers/md/persistent-data/dm-space-map-common.c:1110) dm_persistent_data
[ 391.761279][ T11] ? ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[ 391.766059][ T11] ? __evict_pred (drivers/md/dm-bufio.c:1429) dm_bufio
[ 391.771537][ T11] sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:359) dm_persistent_data
[ 391.778499][ T11] ? sm_ll_lookup (drivers/md/persistent-data/dm-space-map-common.c:339) dm_persistent_data
[ 391.784852][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 391.789900][ T11] sm_ll_find_common_free_block (drivers/md/persistent-data/dm-space-map-common.c:400) dm_persistent_data
[ 391.797376][ T11] ? sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:395) dm_persistent_data
[ 391.804507][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 391.808419][ T11] ? cache_put_and_wake (drivers/md/dm-bufio.c:1713) dm_bufio
[ 391.814414][ T11] sm_disk_new_block_in_range (drivers/md/persistent-data/dm-space-map-disk.c:168) dm_persistent_data
[ 391.821714][ T11] ? sm_disk_destroy (drivers/md/persistent-data/dm-space-map-disk.c:159) dm_persistent_data
[ 391.828152][ T11] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153) 
[ 391.833112][ T11] dm_ea_context_alloc (drivers/md/persistent-data/dm-extent-allocator.c:609 drivers/md/persistent-data/dm-extent-allocator.c:634) dm_persistent_data
[ 391.839811][ T11] ? save_sm_roots (drivers/md/dm-thin-metadata.c:1886) dm_thin_pool
[ 391.845726][ T11] dm_thin_alloc_data_block (drivers/md/dm-thin-metadata.c:1898) dm_thin_pool
[ 391.852331][ T11] alloc_data_block (drivers/md/dm-thin.c:1555) dm_thin_pool
[ 391.858327][ T11] ? pool_postsuspend (drivers/md/dm-thin.c:1518) dm_thin_pool
[ 391.864328][ T11] ? __find_block (drivers/md/dm-thin-metadata.c:1594) dm_thin_pool
[ 391.870154][ T11] provision_block (drivers/md/dm-thin.c:1934) dm_thin_pool
[ 391.876067][ T11] ? schedule_zero (drivers/md/dm-thin.c:1908) dm_thin_pool
[ 391.881983][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 391.885896][ T11] process_cell (drivers/md/dm-thin.c:1998) dm_thin_pool
[ 391.891548][ T11] ? process_bio_read_only (drivers/md/dm-thin.c:1956) dm_thin_pool
[ 391.897980][ T11] ? sort_r (lib/sort.c:284) 
[ 391.901980][ T11] ? metadata_low_callback (drivers/md/dm-thin.c:2243) dm_thin_pool
[ 391.908421][ T11] process_thin_deferred_cells (drivers/md/dm-thin.c:2296) dm_thin_pool
[ 391.915374][ T11] ? thin_endio (drivers/md/dm-thin.c:2278) dm_thin_pool
[ 391.921030][ T11] process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 391.927464][ T11] ? thin_dtr (drivers/md/dm-thin.c:2364) dm_thin_pool
[ 391.932938][ T11] ? __mutex_unlock_slowpath+0x2b0/0x2b0 
[ 391.939445][ T11] ? dm_tm_issue_prefetches (drivers/md/persistent-data/dm-transaction-manager.c:69 drivers/md/persistent-data/dm-transaction-manager.c:455) dm_persistent_data
[ 391.946564][ T11] do_worker (drivers/md/dm-thin.c:175 drivers/md/dm-thin.c:2433) dm_thin_pool
[ 391.951952][ T11] ? pool_ctr (drivers/md/dm-thin.c:2420) dm_thin_pool
[ 391.957598][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 391.962725][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 391.967593][ T11] ? read_word_at_a_time (include/asm-generic/rwonce.h:86) 
[ 391.972456][ T11] ? strscpy (lib/string.c:158) 
[ 391.976456][ T11] process_one_work (kernel/workqueue.c:2635) 
[ 391.981153][ T11] worker_thread (kernel/workqueue.c:2697 kernel/workqueue.c:2784) 
[ 391.985586][ T11] ? process_one_work (kernel/workqueue.c:2730) 
[ 391.990451][ T11] kthread (kernel/kthread.c:388) 
[ 391.994369][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 391.999841][ T11] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 392.004098][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 392.009579][ T11] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  392.014186][   T11]  </TASK>
[  392.017167][   T11] BUG: scheduling while atomic: kworker/u16:0/11/0x00000002
[  392.024286][   T11] Modules linked in: dm_snapshot dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio dm_flakey xfs dm_mod btrfs blake2b_generic intel_rapl_msr xor intel_rapl_common raid6_pq zstd_compress x86_pkg_temp_thermal intel_powerclamp libcrc32c coretemp kvm_intel i915 sd_mod kvm t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 sg irqbypass drm_buddy crct10dif_pclmul ipmi_devintf intel_gtt crc32_pclmul ipmi_msghandler crc32c_intel drm_display_helper ghash_clmulni_intel sha512_ssse3 drm_kms_helper rapl ttm wmi_bmof video ahci intel_cstate mei_wdt libahci mei_me intel_uncore serio_raw libata mei intel_pch_thermal wmi intel_pmc_core acpi_pad tpm_infineon drm fuse ip_tables
[  392.084585][   T11] CPU: 6 PID: 11 Comm: kworker/u16:0 Tainted: G        W          6.6.0-rc2-00004-g026e4728c276 #1
[  392.095070][   T11] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  392.104001][   T11] Workqueue: dm-thin do_worker [dm_thin_pool]
[  392.109915][   T11] Call Trace:
[  392.113052][   T11]  <TASK>
[ 392.115844][ T11] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 392.120194][ T11] __schedule_bug (kernel/sched/core.c:5927) 
[ 392.124556][ T11] schedule_debug (arch/x86/include/asm/preempt.h:35 kernel/sched/core.c:5954) 
[ 392.129084][ T11] ? blk_mq_delay_run_hw_queue (block/blk-mq.c:2171 block/blk-mq.c:2219) 
[ 392.134645][ T11] __schedule (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 kernel/sched/features.h:29 kernel/sched/core.c:6591) 
[ 392.138909][ T11] ? kblockd_mod_delayed_work_on (block/blk-core.c:1038) 
[ 392.144555][ T11] ? blk_mq_submit_bio (block/blk-mq.c:2964) 
[ 392.149596][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 392.154722][ T11] ? blk_mq_flush_plug_list (block/blk-mq.c:2964) 
[ 392.159940][ T11] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
[ 392.165152][ T11] ? _raw_read_unlock_irqrestore (kernel/locking/spinlock.c:161) 
[ 392.170797][ T11] schedule (arch/x86/include/asm/preempt.h:85 (discriminator 1) kernel/sched/core.c:6772 (discriminator 1)) 
[ 392.174798][ T11] io_schedule (kernel/sched/core.c:9001 kernel/sched/core.c:9027) 
[ 392.178971][ T11] bit_wait_io (include/linux/sched/signal.h:416 kernel/sched/wait_bit.c:210) 
[ 392.183061][ T11] __wait_on_bit (kernel/sched/wait_bit.c:49) 
[ 392.187410][ T11] ? bit_wait (kernel/sched/wait_bit.c:208) 
[ 392.191413][ T11] out_of_line_wait_on_bit (kernel/sched/wait_bit.c:60) 
[ 392.196627][ T11] ? __wait_on_bit (kernel/sched/wait_bit.c:60) 
[ 392.201229][ T11] ? sched_clock_idle_sleep_event (kernel/sched/wait_bit.c:22) 
[ 392.206966][ T11] new_read (include/linux/wait_bit.h:101 include/linux/wait_bit.h:96 drivers/md/dm-bufio.c:1874) dm_bufio
[ 392.211929][ T11] ? dm_bufio_client_create (drivers/md/dm-bufio.c:1820) dm_bufio
[ 392.218441][ T11] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[  392.224010][   T11]  ? 0xffffffffc23a2000
[ 392.228008][ T11] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[ 392.233583][ T11] dm_bm_read_lock (drivers/md/persistent-data/dm-block-manager.c:478) dm_persistent_data
[ 392.239939][ T11] ro_step (drivers/md/persistent-data/dm-btree-spine.c:151) dm_persistent_data
[ 392.245603][ T11] btree_lookup_raw+0x3f/0x350 dm_persistent_data
[ 392.253080][ T11] ? arch_stack_walk (arch/x86/kernel/stacktrace.c:24) 
[ 392.257692][ T11] dm_btree_lookup (drivers/md/persistent-data/dm-btree.c:401) dm_persistent_data
[ 392.264125][ T11] ? btree_lookup_raw+0x350/0x350 dm_persistent_data
[ 392.271859][ T11] ? __blk_flush_plug (block/blk-core.c:1149) 
[ 392.276726][ T11] ? filter_irq_stacks (kernel/stacktrace.c:114) 
[ 392.281514][ T11] ? __stack_depot_save (lib/stackdepot.c:379) 
[ 392.286468][ T11] ? kasan_save_stack (mm/kasan/common.c:47) 
[ 392.291161][ T11] disk_ll_load_ie (drivers/md/persistent-data/dm-space-map-common.c:1129) dm_persistent_data
[ 392.297604][ T11] ? disk_ll_commit (drivers/md/persistent-data/dm-space-map-common.c:1110) dm_persistent_data
[ 392.304134][ T11] ? ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[ 392.308909][ T11] ? __evict_pred (drivers/md/dm-bufio.c:1429) dm_bufio
[ 392.314393][ T11] sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:359) dm_persistent_data
[ 392.321352][ T11] ? sm_ll_lookup (drivers/md/persistent-data/dm-space-map-common.c:339) dm_persistent_data
[ 392.327703][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 392.332747][ T11] sm_ll_find_common_free_block (drivers/md/persistent-data/dm-space-map-common.c:400) dm_persistent_data
[ 392.340231][ T11] ? sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:395) dm_persistent_data
[ 392.347360][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 392.351273][ T11] ? cache_put_and_wake (drivers/md/dm-bufio.c:1713) dm_bufio
[ 392.357279][ T11] sm_disk_new_block_in_range (drivers/md/persistent-data/dm-space-map-disk.c:168) dm_persistent_data
[ 392.364583][ T11] ? sm_disk_destroy (drivers/md/persistent-data/dm-space-map-disk.c:159) dm_persistent_data
[ 392.371025][ T11] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153) 
[ 392.375983][ T11] dm_ea_context_alloc (drivers/md/persistent-data/dm-extent-allocator.c:609 drivers/md/persistent-data/dm-extent-allocator.c:634) dm_persistent_data
[ 392.382683][ T11] ? save_sm_roots (drivers/md/dm-thin-metadata.c:1886) dm_thin_pool
[ 392.388594][ T11] dm_thin_alloc_data_block (drivers/md/dm-thin-metadata.c:1898) dm_thin_pool
[ 392.395202][ T11] alloc_data_block (drivers/md/dm-thin.c:1555) dm_thin_pool
[ 392.401201][ T11] ? pool_postsuspend (drivers/md/dm-thin.c:1518) dm_thin_pool
[ 392.407201][ T11] ? __find_block (drivers/md/dm-thin-metadata.c:1594) dm_thin_pool
[ 392.413032][ T11] provision_block (drivers/md/dm-thin.c:1934) dm_thin_pool
[ 392.418943][ T11] ? schedule_zero (drivers/md/dm-thin.c:1908) dm_thin_pool
[ 392.424860][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 392.428774][ T11] process_cell (drivers/md/dm-thin.c:1998) dm_thin_pool
[ 392.434426][ T11] ? process_bio_read_only (drivers/md/dm-thin.c:1956) dm_thin_pool
[ 392.440859][ T11] ? sort_r (lib/sort.c:284) 
[ 392.444858][ T11] ? metadata_low_callback (drivers/md/dm-thin.c:2243) dm_thin_pool
[ 392.451296][ T11] process_thin_deferred_cells (drivers/md/dm-thin.c:2296) dm_thin_pool
[ 392.458249][ T11] ? thin_endio (drivers/md/dm-thin.c:2278) dm_thin_pool
[ 392.463901][ T11] process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 392.470333][ T11] ? thin_dtr (drivers/md/dm-thin.c:2364) dm_thin_pool
[ 392.475813][ T11] ? __mutex_unlock_slowpath+0x2b0/0x2b0 
[ 392.482331][ T11] ? dm_tm_issue_prefetches (drivers/md/persistent-data/dm-transaction-manager.c:69 drivers/md/persistent-data/dm-transaction-manager.c:455) dm_persistent_data
[ 392.489467][ T11] do_worker (drivers/md/dm-thin.c:175 drivers/md/dm-thin.c:2433) dm_thin_pool
[ 392.494861][ T11] ? pool_ctr (drivers/md/dm-thin.c:2420) dm_thin_pool
[ 392.500519][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 392.505652][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 392.510521][ T11] ? read_word_at_a_time (include/asm-generic/rwonce.h:86) 
[ 392.515388][ T11] ? strscpy (lib/string.c:158) 
[ 392.519394][ T11] process_one_work (kernel/workqueue.c:2635) 
[ 392.524094][ T11] worker_thread (kernel/workqueue.c:2697 kernel/workqueue.c:2784) 
[ 392.528537][ T11] ? process_one_work (kernel/workqueue.c:2730) 
[ 392.533409][ T11] kthread (kernel/kthread.c:388) 
[ 392.537329][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 392.542803][ T11] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 392.547065][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 392.552540][ T11] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  392.557159][   T11]  </TASK>
[  392.561211][   T11] BUG: scheduling while atomic: kworker/u16:0/11/0x00000000
[  392.568402][   T11] Modules linked in: dm_snapshot dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio dm_flakey xfs dm_mod btrfs blake2b_generic intel_rapl_msr xor intel_rapl_common raid6_pq zstd_compress x86_pkg_temp_thermal intel_powerclamp libcrc32c coretemp kvm_intel i915 sd_mod kvm t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 sg irqbypass drm_buddy crct10dif_pclmul ipmi_devintf intel_gtt crc32_pclmul ipmi_msghandler crc32c_intel drm_display_helper ghash_clmulni_intel sha512_ssse3 drm_kms_helper rapl ttm wmi_bmof video ahci intel_cstate mei_wdt libahci mei_me intel_uncore serio_raw libata mei intel_pch_thermal wmi intel_pmc_core acpi_pad tpm_infineon drm fuse ip_tables
[  392.628793][   T11] CPU: 6 PID: 11 Comm: kworker/u16:0 Tainted: G        W          6.6.0-rc2-00004-g026e4728c276 #1
[  392.639286][   T11] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  392.648223][   T11] Workqueue: dm-thin do_worker [dm_thin_pool]
[  392.654134][   T11] Call Trace:
[  392.657271][   T11]  <TASK>
[ 392.660063][ T11] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 392.664413][ T11] __schedule_bug (kernel/sched/core.c:5927) 
[ 392.668760][ T11] schedule_debug (arch/x86/include/asm/preempt.h:35 kernel/sched/core.c:5954) 
[ 392.673286][ T11] __schedule (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:207 kernel/sched/features.h:29 kernel/sched/core.c:6591) 
[ 392.677547][ T11] ? enqueue_timer (arch/x86/include/asm/bitops.h:68 include/asm-generic/bitops/instrumented-non-atomic.h:29 kernel/time/timer.c:606) 
[ 392.682069][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 392.687196][ T11] ? round_jiffies_up_relative (kernel/time/timer.c:1014) 
[ 392.692842][ T11] ? blk_mq_submit_bio (block/blk-mq.c:3008 (discriminator 1)) 
[ 392.697883][ T11] schedule (arch/x86/include/asm/preempt.h:85 (discriminator 1) kernel/sched/core.c:6772 (discriminator 1)) 
[ 392.701888][ T11] schedule_timeout (kernel/time/timer.c:1628 include/linux/timer.h:200 kernel/time/timer.c:2168) 
[ 392.706584][ T11] ? usleep_range_state (kernel/time/timer.c:2129) 
[ 392.711624][ T11] ? __bpf_trace_tick_stop (kernel/time/timer.c:2091) 
[ 392.716752][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 392.721625][ T11] io_schedule_timeout (kernel/sched/core.c:9001 kernel/sched/core.c:9015) 
[ 392.726494][ T11] __wait_for_common (kernel/sched/completion.c:96 kernel/sched/completion.c:116) 
[ 392.731279][ T11] ? firmware_map_remove (kernel/sched/core.c:9009) 
[ 392.736405][ T11] ? out_of_line_wait_on_bit_timeout (kernel/sched/completion.c:110) 
[ 392.742572][ T11] ? submit_bio_noacct (arch/x86/include/asm/bitops.h:207 arch/x86/include/asm/bitops.h:239 include/asm-generic/bitops/instrumented-non-atomic.h:142 block/blk-core.c:763) 
[ 392.747622][ T11] ? bio_associate_blkg_from_css (block/blk-cgroup.c:2036 block/blk-cgroup.c:2026) 
[ 392.753447][ T11] submit_bio_wait (block/bio.c:1370 (discriminator 1)) 
[ 392.758059][ T11] ? __bio_clone (block/bio.c:1357) 
[ 392.762494][ T11] ? bio_init (arch/x86/include/asm/atomic.h:28 include/linux/atomic/atomic-arch-fallback.h:492 include/linux/atomic/atomic-instrumented.h:68 block/bio.c:279) 
[ 392.766677][ T11] blkdev_issue_flush (block/blk-flush.c:477) 
[ 392.771375][ T11] ? blk_mq_hctx_set_fq_lock_class (block/blk-flush.c:477) 
[ 392.777195][ T11] ? submit_bio_wait (block/bio.c:1341) 
[ 392.781975][ T11] ? schedule_zero (drivers/md/dm-thin.c:1908) dm_thin_pool
[ 392.787886][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 392.791797][ T11] ? __pool_inc (drivers/md/dm-thin.c:3217) dm_thin_pool
[ 392.797280][ T11] __commit_transaction (drivers/md/dm-thin-metadata.c:910) dm_thin_pool
[ 392.803627][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 392.808500][ T11] ? __open_or_format_metadata (drivers/md/dm-thin-metadata.c:894) dm_thin_pool
[ 392.815455][ T11] ? down_write (arch/x86/include/asm/atomic64_64.h:20 include/linux/atomic/atomic-arch-fallback.h:2608 include/linux/atomic/atomic-long.h:79 include/linux/atomic/atomic-instrumented.h:3196 kernel/locking/rwsem.c:143 kernel/locking/rwsem.c:261 kernel/locking/rwsem.c:1305 kernel/locking/rwsem.c:1315 kernel/locking/rwsem.c:1574) 
[ 392.819716][ T11] ? rwsem_down_write_slowpath (kernel/locking/rwsem.c:1571) 
[ 392.825362][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 392.830405][ T11] ? process_thin_deferred_cells (include/linux/list.h:373 drivers/md/dm-thin.c:2321) dm_thin_pool
[ 392.837529][ T11] dm_pool_commit_metadata (drivers/md/dm-thin-metadata.c:1925) dm_thin_pool
[ 392.843962][ T11] commit (drivers/md/dm-thin.c:1494) dm_thin_pool
[ 392.849011][ T11] ? process_prepared_discard_passdown_pt1 (drivers/md/dm-thin.c:1488) dm_thin_pool
[ 392.857000][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 392.861867][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 392.865783][ T11] process_deferred_bios (drivers/md/dm-thin.c:2395) dm_thin_pool
[ 392.872217][ T11] ? thin_dtr (drivers/md/dm-thin.c:2364) dm_thin_pool
[ 392.877695][ T11] ? __mutex_unlock_slowpath+0x2b0/0x2b0 
[ 392.884205][ T11] ? dm_tm_issue_prefetches (drivers/md/persistent-data/dm-transaction-manager.c:69 drivers/md/persistent-data/dm-transaction-manager.c:455) dm_persistent_data
[ 392.891339][ T11] do_worker (drivers/md/dm-thin.c:175 drivers/md/dm-thin.c:2433) dm_thin_pool
[ 392.896735][ T11] ? pool_ctr (drivers/md/dm-thin.c:2420) dm_thin_pool
[ 392.902391][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 392.907516][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 392.912383][ T11] ? read_word_at_a_time (include/asm-generic/rwonce.h:86) 
[ 392.917249][ T11] ? strscpy (lib/string.c:158) 
[ 392.921250][ T11] process_one_work (kernel/workqueue.c:2635) 
[ 392.925946][ T11] worker_thread (kernel/workqueue.c:2697 kernel/workqueue.c:2784) 
[ 392.930382][ T11] ? process_one_work (kernel/workqueue.c:2730) 
[ 392.935256][ T11] kthread (kernel/kthread.c:388) 
[ 392.939173][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 392.944647][ T11] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 392.948907][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 392.954381][ T11] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  392.958994][   T11]  </TASK>
[  393.044001][   T11] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1519
[  393.053203][   T11] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 11, name: kworker/u16:0
[  393.062135][   T11] preempt_count: 1, expected: 0
[  393.066835][   T11] RCU nest depth: 0, expected: 0
[  393.071625][   T11] CPU: 6 PID: 11 Comm: kworker/u16:0 Tainted: G        W          6.6.0-rc2-00004-g026e4728c276 #1
[  393.082114][   T11] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  393.091044][   T11] Workqueue: dm-thin do_worker [dm_thin_pool]
[  393.096969][   T11] Call Trace:
[  393.100106][   T11]  <TASK>
[ 393.102895][ T11] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 393.107247][ T11] __might_resched (kernel/sched/core.c:10188) 
[ 393.111860][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 393.116898][ T11] ? schedule (arch/x86/include/asm/preempt.h:85 (discriminator 1) kernel/sched/core.c:6772 (discriminator 1)) 
[ 393.121074][ T11] down_read (include/linux/kernel.h:112 kernel/locking/rwsem.c:1519) 
[ 393.125076][ T11] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[  393.130634][   T11]  ? 0xffffffffc23a2000
[ 393.134637][ T11] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[ 393.140203][ T11] ? __blk_flush_plug (block/blk-core.c:1149) 
[ 393.145068][ T11] ? orc_find+0x1da/0x3b0 
[ 393.149852][ T11] cache_get (drivers/md/dm-bufio.c:583) dm_bufio
[ 393.154816][ T11] new_read (drivers/md/dm-bufio.c:1832) dm_bufio
[ 393.159688][ T11] ? dm_bufio_client_create (drivers/md/dm-bufio.c:1820) dm_bufio
[ 393.166206][ T11] ? disk_ll_commit (drivers/md/persistent-data/dm-space-map-common.c:1110) dm_persistent_data
[ 393.172734][ T11] dm_bm_read_lock (drivers/md/persistent-data/dm-block-manager.c:478) dm_persistent_data
[ 393.179088][ T11] sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:367) dm_persistent_data
[ 393.186049][ T11] ? sm_ll_lookup (drivers/md/persistent-data/dm-space-map-common.c:339) dm_persistent_data
[ 393.192397][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 393.197435][ T11] ? ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[ 393.202220][ T11] sm_ll_find_common_free_block (drivers/md/persistent-data/dm-space-map-common.c:400) dm_persistent_data
[ 393.209698][ T11] ? sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:395) dm_persistent_data
[ 393.216827][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 393.220739][ T11] ? cache_put_and_wake (drivers/md/dm-bufio.c:1713) dm_bufio
[ 393.226740][ T11] sm_disk_new_block_in_range (drivers/md/persistent-data/dm-space-map-disk.c:168) dm_persistent_data
[ 393.234047][ T11] ? sm_disk_destroy (drivers/md/persistent-data/dm-space-map-disk.c:159) dm_persistent_data
[ 393.240486][ T11] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153) 
[ 393.245442][ T11] dm_ea_context_alloc (drivers/md/persistent-data/dm-extent-allocator.c:609 drivers/md/persistent-data/dm-extent-allocator.c:634) dm_persistent_data
[ 393.252130][ T11] ? save_sm_roots (drivers/md/dm-thin-metadata.c:1886) dm_thin_pool
[ 393.258039][ T11] ? process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 393.264647][ T11] dm_thin_alloc_data_block (drivers/md/dm-thin-metadata.c:1898) dm_thin_pool
[ 393.271253][ T11] alloc_data_block (drivers/md/dm-thin.c:1555) dm_thin_pool
[ 393.277252][ T11] ? pool_postsuspend (drivers/md/dm-thin.c:1518) dm_thin_pool
[ 393.283251][ T11] ? __find_block (drivers/md/dm-thin-metadata.c:1594) dm_thin_pool
[ 393.289071][ T11] provision_block (drivers/md/dm-thin.c:1934) dm_thin_pool
[ 393.294987][ T11] ? schedule_zero (drivers/md/dm-thin.c:1908) dm_thin_pool
[ 393.300898][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 393.304816][ T11] process_cell (drivers/md/dm-thin.c:1998) dm_thin_pool
[ 393.310472][ T11] ? process_bio_read_only (drivers/md/dm-thin.c:1956) dm_thin_pool
[ 393.316900][ T11] ? sort_r (lib/sort.c:284) 
[ 393.320901][ T11] ? metadata_low_callback (drivers/md/dm-thin.c:2243) dm_thin_pool
[ 393.327333][ T11] process_thin_deferred_cells (drivers/md/dm-thin.c:2296) dm_thin_pool
[ 393.334285][ T11] ? thin_endio (drivers/md/dm-thin.c:2278) dm_thin_pool
[ 393.339942][ T11] process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 393.346377][ T11] ? thin_dtr (drivers/md/dm-thin.c:2364) dm_thin_pool
[ 393.351859][ T11] ? __mutex_unlock_slowpath+0x2b0/0x2b0 
[ 393.358369][ T11] ? dm_tm_issue_prefetches (drivers/md/persistent-data/dm-transaction-manager.c:69 drivers/md/persistent-data/dm-transaction-manager.c:455) dm_persistent_data
[ 393.365501][ T11] do_worker (drivers/md/dm-thin.c:175 drivers/md/dm-thin.c:2433) dm_thin_pool
[ 393.370892][ T11] ? pool_ctr (drivers/md/dm-thin.c:2420) dm_thin_pool
[ 393.376549][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 393.381680][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 393.386546][ T11] ? read_word_at_a_time (include/asm-generic/rwonce.h:86) 
[ 393.391413][ T11] ? strscpy (lib/string.c:158) 
[ 393.395416][ T11] process_one_work (kernel/workqueue.c:2635) 
[ 393.400112][ T11] worker_thread (kernel/workqueue.c:2697 kernel/workqueue.c:2784) 
[ 393.404555][ T11] ? process_one_work (kernel/workqueue.c:2730) 
[ 393.409428][ T11] kthread (kernel/kthread.c:388) 
[ 393.413341][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 393.418816][ T11] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 393.423080][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 393.428555][ T11] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  393.433160][   T11]  </TASK>
[  394.478632][T15032] XFS (dm-5): Mounting V5 Filesystem 775c3985-ac38-4321-93b2-4ba41106f9c7
[  394.501028][   T11] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1519
[  394.510357][   T11] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 11, name: kworker/u16:0
[  394.519298][   T11] preempt_count: 1, expected: 0
[  394.523999][   T11] RCU nest depth: 0, expected: 0
[  394.528790][   T11] CPU: 1 PID: 11 Comm: kworker/u16:0 Tainted: G        W          6.6.0-rc2-00004-g026e4728c276 #1
[  394.539280][   T11] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  394.548213][   T11] Workqueue: dm-thin do_worker [dm_thin_pool]
[  394.554133][   T11] Call Trace:
[  394.557270][   T11]  <TASK>
[ 394.560062][ T11] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 394.564411][ T11] __might_resched (kernel/sched/core.c:10188) 
[ 394.569021][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 394.574062][ T11] down_read (include/linux/kernel.h:112 kernel/locking/rwsem.c:1519) 
[ 394.578065][ T11] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[ 394.583624][ T11] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[ 394.589191][ T11] cache_get (drivers/md/dm-bufio.c:583) dm_bufio
[ 394.594151][ T11] new_read (drivers/md/dm-bufio.c:1832) dm_bufio
[ 394.599028][ T11] ? dm_bufio_client_create (drivers/md/dm-bufio.c:1820) dm_bufio
[ 394.605546][ T11] ? disk_ll_commit (drivers/md/persistent-data/dm-space-map-common.c:1110) dm_persistent_data
[ 394.612069][ T11] dm_bm_read_lock (drivers/md/persistent-data/dm-block-manager.c:478) dm_persistent_data
[ 394.618425][ T11] sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:367) dm_persistent_data
[ 394.625386][ T11] ? sm_ll_lookup (drivers/md/persistent-data/dm-space-map-common.c:339) dm_persistent_data
[ 394.631738][ T11] ? filter_irq_stacks (kernel/stacktrace.c:114) 
[ 394.636519][ T11] ? __stack_depot_save (lib/stackdepot.c:379) 
[ 394.641471][ T11] sm_ll_find_common_free_block (drivers/md/persistent-data/dm-space-map-common.c:400) dm_persistent_data
[ 394.648950][ T11] ? process_thin_deferred_cells (drivers/md/dm-thin.c:2296) dm_thin_pool
[ 394.656072][ T11] ? sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:395) dm_persistent_data
[ 394.663203][ T11] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
[ 394.668423][ T11] ? _raw_read_unlock_irqrestore (kernel/locking/spinlock.c:161) 
[ 394.674069][ T11] sm_disk_new_block_in_range (drivers/md/persistent-data/dm-space-map-disk.c:168) dm_persistent_data
[ 394.681378][ T11] ? sm_disk_destroy (drivers/md/persistent-data/dm-space-map-disk.c:159) dm_persistent_data
[ 394.687822][ T11] dm_ea_context_alloc (drivers/md/persistent-data/dm-extent-allocator.c:609 drivers/md/persistent-data/dm-extent-allocator.c:634) dm_persistent_data
[ 394.694523][ T11] ? save_sm_roots (drivers/md/dm-thin-metadata.c:1886) dm_thin_pool
[ 394.700436][ T11] dm_thin_alloc_data_block (drivers/md/dm-thin-metadata.c:1898) dm_thin_pool
[ 394.707039][ T11] alloc_data_block (drivers/md/dm-thin.c:1555) dm_thin_pool
[ 394.713038][ T11] ? pool_postsuspend (drivers/md/dm-thin.c:1518) dm_thin_pool
[ 394.719039][ T11] ? dm_bio_detain (drivers/md/dm-bio-prison-v1.c:198) dm_bio_prison
[ 394.724950][ T11] process_shared_bio (drivers/md/dm-thin.c:1812 drivers/md/dm-thin.c:1892) dm_thin_pool
[ 394.731125][ T11] ? schedule_copy (drivers/md/dm-thin.c:1876) dm_thin_pool
[ 394.737032][ T11] ? sb_prepare_for_write (drivers/md/dm-thin-metadata.c:1581) dm_thin_pool
[ 394.743555][ T11] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[ 394.749112][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 394.753027][ T11] process_cell (drivers/md/dm-thin.c:1972) dm_thin_pool
[ 394.758684][ T11] ? process_bio_read_only (drivers/md/dm-thin.c:1956) dm_thin_pool
[ 394.765120][ T11] ? sort_r (lib/sort.c:284) 
[ 394.769122][ T11] ? metadata_low_callback (drivers/md/dm-thin.c:2243) dm_thin_pool
[ 394.775559][ T11] process_thin_deferred_cells (drivers/md/dm-thin.c:2296) dm_thin_pool
[ 394.782513][ T11] ? thin_endio (drivers/md/dm-thin.c:2278) dm_thin_pool
[ 394.788169][ T11] process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 394.794604][ T11] ? thin_dtr (drivers/md/dm-thin.c:2364) dm_thin_pool
[ 394.800087][ T11] ? __mutex_unlock_slowpath+0x2b0/0x2b0 
[ 394.806599][ T11] ? dm_tm_issue_prefetches (drivers/md/persistent-data/dm-transaction-manager.c:69 drivers/md/persistent-data/dm-transaction-manager.c:455) dm_persistent_data
[ 394.813738][ T11] do_worker (drivers/md/dm-thin.c:175 drivers/md/dm-thin.c:2433) dm_thin_pool
[ 394.819134][ T11] ? pool_ctr (drivers/md/dm-thin.c:2420) dm_thin_pool
[ 394.824790][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 394.829917][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 394.834785][ T11] ? read_word_at_a_time (include/asm-generic/rwonce.h:86) 
[ 394.839652][ T11] ? strscpy (lib/string.c:158) 
[ 394.843657][ T11] process_one_work (kernel/workqueue.c:2635) 
[ 394.848356][ T11] worker_thread (kernel/workqueue.c:2697 kernel/workqueue.c:2784) 
[ 394.852801][ T11] ? process_one_work (kernel/workqueue.c:2730) 
[ 394.857670][ T11] kthread (kernel/kthread.c:388) 
[ 394.861587][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 394.867063][ T11] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 394.871330][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 394.876800][ T11] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  394.881413][   T11]  </TASK>
[  394.907221][T15032] XFS (dm-5): Ending clean mount
[  394.924694][T15032] xfs filesystem being mounted at /fs/scratch supports timestamps until 2038-01-19 (0x7fffffff)
[  395.501918][   T11] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1519
[  395.511129][   T11] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 11, name: kworker/u16:0
[  395.520218][   T11] preempt_count: 1, expected: 0
[  395.524926][   T11] RCU nest depth: 0, expected: 0
[  395.529714][   T11] CPU: 6 PID: 11 Comm: kworker/u16:0 Tainted: G        W          6.6.0-rc2-00004-g026e4728c276 #1
[  395.540214][   T11] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  395.549152][   T11] Workqueue: dm-thin do_worker [dm_thin_pool]
[  395.555071][   T11] Call Trace:
[  395.558208][   T11]  <TASK>
[ 395.560999][ T11] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 395.565356][ T11] __might_resched (kernel/sched/core.c:10188) 
[ 395.569973][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 395.575013][ T11] down_read (include/linux/kernel.h:112 kernel/locking/rwsem.c:1519) 
[ 395.579018][ T11] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[  395.584576][   T11]  ? 0xffffffffc23a2000
[ 395.588581][ T11] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[ 395.594143][ T11] ? __blk_flush_plug (block/blk-core.c:1149) 
[ 395.599009][ T11] ? orc_find+0x1da/0x3b0 
[ 395.603788][ T11] cache_get (drivers/md/dm-bufio.c:583) dm_bufio
[ 395.608750][ T11] new_read (drivers/md/dm-bufio.c:1832) dm_bufio
[ 395.613624][ T11] ? dm_bufio_client_create (drivers/md/dm-bufio.c:1820) dm_bufio
[ 395.620145][ T11] ? disk_ll_commit (drivers/md/persistent-data/dm-space-map-common.c:1110) dm_persistent_data
[ 395.626673][ T11] dm_bm_read_lock (drivers/md/persistent-data/dm-block-manager.c:478) dm_persistent_data
[ 395.633023][ T11] sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:367) dm_persistent_data
[ 395.639983][ T11] ? sm_ll_lookup (drivers/md/persistent-data/dm-space-map-common.c:339) dm_persistent_data
[ 395.646336][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 395.651381][ T11] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[ 395.656940][ T11] sm_ll_find_common_free_block (drivers/md/persistent-data/dm-space-map-common.c:400) dm_persistent_data
[ 395.664413][ T11] ? sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:395) dm_persistent_data
[ 395.671545][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 395.675467][ T11] ? cache_put_and_wake (drivers/md/dm-bufio.c:1713) dm_bufio
[ 395.681469][ T11] sm_disk_new_block_in_range (drivers/md/persistent-data/dm-space-map-disk.c:168) dm_persistent_data
[ 395.688775][ T11] ? sm_disk_destroy (drivers/md/persistent-data/dm-space-map-disk.c:159) dm_persistent_data
[ 395.695211][ T11] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153) 
[ 395.700167][ T11] dm_ea_context_alloc (drivers/md/persistent-data/dm-extent-allocator.c:609 drivers/md/persistent-data/dm-extent-allocator.c:634) dm_persistent_data
[ 395.706866][ T11] ? save_sm_roots (drivers/md/dm-thin-metadata.c:1886) dm_thin_pool
[ 395.712779][ T11] ? process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 395.719381][ T11] dm_thin_alloc_data_block (drivers/md/dm-thin-metadata.c:1898) dm_thin_pool
[ 395.725993][ T11] alloc_data_block (drivers/md/dm-thin.c:1555) dm_thin_pool
[ 395.731994][ T11] ? pool_postsuspend (drivers/md/dm-thin.c:1518) dm_thin_pool
[ 395.737999][ T11] ? __find_block (drivers/md/dm-thin-metadata.c:1594) dm_thin_pool
[ 395.743824][ T11] provision_block (drivers/md/dm-thin.c:1934) dm_thin_pool
[ 395.749739][ T11] ? schedule_zero (drivers/md/dm-thin.c:1908) dm_thin_pool
[ 395.755650][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 395.759571][ T11] process_cell (drivers/md/dm-thin.c:1998) dm_thin_pool
[ 395.765226][ T11] ? process_bio_read_only (drivers/md/dm-thin.c:1956) dm_thin_pool
[ 395.771661][ T11] ? sort_r (lib/sort.c:284) 
[ 395.775669][ T11] ? metadata_low_callback (drivers/md/dm-thin.c:2243) dm_thin_pool
[ 395.782103][ T11] process_thin_deferred_cells (drivers/md/dm-thin.c:2296) dm_thin_pool
[ 395.789056][ T11] ? thin_endio (drivers/md/dm-thin.c:2278) dm_thin_pool
[ 395.794708][ T11] process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 395.801140][ T11] ? thin_dtr (drivers/md/dm-thin.c:2364) dm_thin_pool
[ 395.806624][ T11] ? __mutex_unlock_slowpath+0x2b0/0x2b0 
[ 395.813140][ T11] ? dm_tm_issue_prefetches (drivers/md/persistent-data/dm-transaction-manager.c:69 drivers/md/persistent-data/dm-transaction-manager.c:455) dm_persistent_data
[ 395.820281][ T11] do_worker (drivers/md/dm-thin.c:175 drivers/md/dm-thin.c:2433) dm_thin_pool
[ 395.825676][ T11] ? pool_ctr (drivers/md/dm-thin.c:2420) dm_thin_pool
[ 395.831327][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 395.836456][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 395.841324][ T11] ? read_word_at_a_time (include/asm-generic/rwonce.h:86) 
[ 395.846193][ T11] ? strscpy (lib/string.c:158) 
[ 395.850201][ T11] process_one_work (kernel/workqueue.c:2635) 
[ 395.854895][ T11] worker_thread (kernel/workqueue.c:2697 kernel/workqueue.c:2784) 
[ 395.859332][ T11] ? process_one_work (kernel/workqueue.c:2730) 
[ 395.864200][ T11] kthread (kernel/kthread.c:388) 
[ 395.868122][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 395.873602][ T11] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 395.877870][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 395.883338][ T11] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  395.887951][   T11]  </TASK>
[  396.548412][   T11] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1519
[  396.557620][   T11] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 11, name: kworker/u16:0
[  396.566566][   T11] preempt_count: 1, expected: 0
[  396.571275][   T11] RCU nest depth: 0, expected: 0
[  396.576064][   T11] CPU: 6 PID: 11 Comm: kworker/u16:0 Tainted: G        W          6.6.0-rc2-00004-g026e4728c276 #1
[  396.586560][   T11] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  396.595486][   T11] Workqueue: dm-thin do_worker [dm_thin_pool]
[  396.601405][   T11] Call Trace:
[  396.604545][   T11]  <TASK>
[ 396.607339][ T11] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 396.611686][ T11] __might_resched (kernel/sched/core.c:10188) 
[ 396.616301][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 396.621351][ T11] down_read (include/linux/kernel.h:112 kernel/locking/rwsem.c:1519) 
[ 396.625359][ T11] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[  396.630919][   T11]  ? 0xffffffffc23a2000
[ 396.634916][ T11] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[ 396.640484][ T11] ? __blk_flush_plug (block/blk-core.c:1149) 
[ 396.645345][ T11] ? orc_find+0x1da/0x3b0 
[ 396.650127][ T11] cache_get (drivers/md/dm-bufio.c:583) dm_bufio
[ 396.655087][ T11] new_read (drivers/md/dm-bufio.c:1832) dm_bufio
[ 396.659964][ T11] ? dm_bufio_client_create (drivers/md/dm-bufio.c:1820) dm_bufio
[ 396.666481][ T11] ? disk_ll_commit (drivers/md/persistent-data/dm-space-map-common.c:1110) dm_persistent_data
[ 396.673009][ T11] dm_bm_read_lock (drivers/md/persistent-data/dm-block-manager.c:478) dm_persistent_data
[ 396.679369][ T11] sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:367) dm_persistent_data
[ 396.686331][ T11] ? sm_ll_lookup (drivers/md/persistent-data/dm-space-map-common.c:339) dm_persistent_data
[ 396.692680][ T11] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 396.697723][ T11] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[ 396.703286][ T11] sm_ll_find_common_free_block (drivers/md/persistent-data/dm-space-map-common.c:400) dm_persistent_data
[ 396.710760][ T11] ? sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:395) dm_persistent_data
[ 396.717890][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 396.721807][ T11] ? cache_put_and_wake (drivers/md/dm-bufio.c:1713) dm_bufio
[ 396.727806][ T11] sm_disk_new_block_in_range (drivers/md/persistent-data/dm-space-map-disk.c:168) dm_persistent_data
[ 396.735109][ T11] ? sm_disk_destroy (drivers/md/persistent-data/dm-space-map-disk.c:159) dm_persistent_data
[ 396.741553][ T11] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153) 
[ 396.746505][ T11] dm_ea_context_alloc (drivers/md/persistent-data/dm-extent-allocator.c:609 drivers/md/persistent-data/dm-extent-allocator.c:634) dm_persistent_data
[ 396.753205][ T11] ? save_sm_roots (drivers/md/dm-thin-metadata.c:1886) dm_thin_pool
[ 396.759121][ T11] ? process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 396.765726][ T11] dm_thin_alloc_data_block (drivers/md/dm-thin-metadata.c:1898) dm_thin_pool
[ 396.772330][ T11] alloc_data_block (drivers/md/dm-thin.c:1555) dm_thin_pool
[ 396.778333][ T11] ? pool_postsuspend (drivers/md/dm-thin.c:1518) dm_thin_pool
[ 396.784331][ T11] ? __find_block (drivers/md/dm-thin-metadata.c:1594) dm_thin_pool
[ 396.790160][ T11] provision_block (drivers/md/dm-thin.c:1934) dm_thin_pool
[ 396.796074][ T11] ? schedule_zero (drivers/md/dm-thin.c:1908) dm_thin_pool
[ 396.801988][ T11] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 396.805903][ T11] process_cell (drivers/md/dm-thin.c:1998) dm_thin_pool
[ 396.811555][ T11] ? process_bio_read_only (drivers/md/dm-thin.c:1956) dm_thin_pool
[ 396.817985][ T11] ? sort_r (lib/sort.c:284) 
[ 396.821985][ T11] ? metadata_low_callback (drivers/md/dm-thin.c:2243) dm_thin_pool
[ 396.828417][ T11] process_thin_deferred_cells (drivers/md/dm-thin.c:2296) dm_thin_pool
[ 396.835373][ T11] ? thin_endio (drivers/md/dm-thin.c:2278) dm_thin_pool
[ 396.841026][ T11] process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 396.847458][ T11] ? thin_dtr (drivers/md/dm-thin.c:2364) dm_thin_pool
[ 396.852935][ T11] ? __mutex_unlock_slowpath+0x2b0/0x2b0 
[ 396.859451][ T11] ? dm_tm_issue_prefetches (drivers/md/persistent-data/dm-transaction-manager.c:69 drivers/md/persistent-data/dm-transaction-manager.c:455) dm_persistent_data
[ 396.866583][ T11] do_worker (drivers/md/dm-thin.c:175 drivers/md/dm-thin.c:2433) dm_thin_pool
[ 396.871976][ T11] ? pool_ctr (drivers/md/dm-thin.c:2420) dm_thin_pool
[ 396.877630][ T11] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 396.882752][ T11] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 396.887620][ T11] ? read_word_at_a_time (include/asm-generic/rwonce.h:86) 
[ 396.892490][ T11] ? strscpy (lib/string.c:158) 
[ 396.896491][ T11] process_one_work (kernel/workqueue.c:2635) 
[ 396.901188][ T11] worker_thread (kernel/workqueue.c:2697 kernel/workqueue.c:2784) 
[ 396.905625][ T11] ? process_one_work (kernel/workqueue.c:2730) 
[ 396.910495][ T11] kthread (kernel/kthread.c:388) 
[ 396.914411][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 396.919884][ T11] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 396.924146][ T11] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 396.929624][ T11] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  396.934232][   T11]  </TASK>
[  397.188813][   T11] device-mapper: thin: 253:2: reached low water mark for data device: sending event.
[  397.261199][   T11] device-mapper: thin: 253:2: switching pool to out-of-data-space (error IO) mode
[ 397.434878][ T87] XFS (dm-5): metadata I/O error in "xfs_buf_ioend_handle_error+0x269/0xce0 [xfs]" at daddr 0x8 len 8 error 28 
[ 397.435148][ T89] XFS (dm-5): metadata I/O error in "xfs_buf_ioend_handle_error+0x269/0xce0 [xfs]" at daddr 0x20 len 8 error 28 
[ 397.437634][ T81] XFS (dm-5): metadata I/O error in "xfs_buf_ioend_handle_error+0x269/0xce0 [xfs]" at daddr 0x28 len 8 error 28 
[ 397.437774][ T88] XFS (dm-5): metadata I/O error in "xfs_buf_ioend_handle_error+0x269/0xce0 [xfs]" at daddr 0x5dc08 len 8 error 28 
[  397.489543][T15043] XFS (dm-5): Failing async write on buffer block 0x10. Retrying async write.
[  397.498243][T15043] XFS (dm-5): Failing async write on buffer block 0x38. Retrying async write.
[  397.507066][T15043] XFS (dm-5): Failing async write on buffer block 0x30. Retrying async write.
[  397.515755][T15043] XFS (dm-5): Failing async write on buffer block 0x8. Retrying async write.
[  397.524361][T15043] XFS (dm-5): Failing async write on buffer block 0x28. Retrying async write.
[  397.533052][T15043] XFS (dm-5): Failing async write on buffer block 0x20. Retrying async write.
[  407.489592][T15101] device-mapper: thin: Data device (dm-1) discard unsupported: Disabling discard passdown.
[  407.499752][T15101] device-mapper: thin: 253:2: switching pool to write mode
[  407.506802][T15101] device-mapper: thin: 253:2: growing the data device from 3200 to 4800 blocks
[  407.522935][   T64] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1519
[  407.532159][   T64] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 64, name: kworker/u16:1
[  407.541123][   T64] preempt_count: 1, expected: 0
[  407.545826][   T64] RCU nest depth: 0, expected: 0
[  407.550624][   T64] CPU: 6 PID: 64 Comm: kworker/u16:1 Tainted: G        W          6.6.0-rc2-00004-g026e4728c276 #1
[  407.561129][   T64] Hardware name: HP HP Z240 SFF Workstation/802E, BIOS N51 Ver. 01.63 10/05/2017
[  407.570069][   T64] Workqueue: dm-thin do_worker [dm_thin_pool]
[  407.575996][   T64] Call Trace:
[  407.579132][   T64]  <TASK>
[ 407.581924][ T64] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1)) 
[ 407.586279][ T64] __might_resched (kernel/sched/core.c:10188) 
[ 407.590898][ T64] ? preempt_notifier_dec (kernel/sched/core.c:10142) 
[ 407.595937][ T64] down_read (include/linux/kernel.h:112 kernel/locking/rwsem.c:1519) 
[ 407.599941][ T64] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[ 407.605502][ T64] ? do_worker (drivers/md/dm-thin.c:2432) dm_thin_pool
[ 407.611068][ T64] cache_get (drivers/md/dm-bufio.c:583) dm_bufio
[ 407.616031][ T64] new_read (drivers/md/dm-bufio.c:1832) dm_bufio
[ 407.620908][ T64] ? dm_bufio_client_create (drivers/md/dm-bufio.c:1820) dm_bufio
[ 407.627425][ T64] ? disk_ll_commit (drivers/md/persistent-data/dm-space-map-common.c:1110) dm_persistent_data
[ 407.633959][ T64] dm_bm_read_lock (drivers/md/persistent-data/dm-block-manager.c:478) dm_persistent_data
[ 407.640315][ T64] sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:367) dm_persistent_data
[ 407.647276][ T64] ? sm_ll_lookup (drivers/md/persistent-data/dm-space-map-common.c:339) dm_persistent_data
[ 407.653629][ T64] ? filter_irq_stacks (kernel/stacktrace.c:114) 
[ 407.658410][ T64] ? .slowpath (kernel/locking/qspinlock.c:317) 
[ 407.662508][ T64] sm_ll_find_common_free_block (drivers/md/persistent-data/dm-space-map-common.c:400) dm_persistent_data
[ 407.669980][ T64] ? sm_ll_find_free_block (drivers/md/persistent-data/dm-space-map-common.c:395) dm_persistent_data
[ 407.677104][ T64] ? _raw_spin_lock_irqsave (arch/x86/include/asm/paravirt.h:586 arch/x86/include/asm/qspinlock.h:51 include/asm-generic/qspinlock.h:114 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
[ 407.682318][ T64] ? _raw_read_unlock_irqrestore (kernel/locking/spinlock.c:161) 
[ 407.687968][ T64] sm_disk_new_block_in_range (drivers/md/persistent-data/dm-space-map-disk.c:168) dm_persistent_data
[ 407.695278][ T64] ? sm_disk_destroy (drivers/md/persistent-data/dm-space-map-disk.c:159) dm_persistent_data
[ 407.701715][ T64] ? _raw_write_lock_irq (kernel/locking/spinlock.c:153) 
[ 407.706680][ T64] dm_ea_context_alloc (drivers/md/persistent-data/dm-extent-allocator.c:609 drivers/md/persistent-data/dm-extent-allocator.c:634) dm_persistent_data
[ 407.713377][ T64] ? save_sm_roots (drivers/md/dm-thin-metadata.c:1886) dm_thin_pool
[ 407.719281][ T64] dm_thin_alloc_data_block (drivers/md/dm-thin-metadata.c:1898) dm_thin_pool
[ 407.725882][ T64] alloc_data_block (drivers/md/dm-thin.c:1555) dm_thin_pool
[ 407.731883][ T64] ? pool_postsuspend (drivers/md/dm-thin.c:1518) dm_thin_pool
[ 407.737880][ T64] ? dm_bio_detain (drivers/md/dm-bio-prison-v1.c:198) dm_bio_prison
[ 407.743792][ T64] process_shared_bio (drivers/md/dm-thin.c:1812 drivers/md/dm-thin.c:1892) dm_thin_pool
[ 407.749970][ T64] ? schedule_copy (drivers/md/dm-thin.c:1876) dm_thin_pool
[ 407.755880][ T64] ? sb_prepare_for_write (drivers/md/dm-thin-metadata.c:1581) dm_thin_pool
[ 407.762396][ T64] ? rwsem_down_read_slowpath (kernel/locking/rwsem.c:1518) 
[ 407.767963][ T64] ? up_read (arch/x86/include/asm/atomic64_64.h:79 include/linux/atomic/atomic-arch-fallback.h:2730 include/linux/atomic/atomic-long.h:184 include/linux/atomic/atomic-instrumented.h:3289 kernel/locking/rwsem.c:1347 kernel/locking/rwsem.c:1616) 
[ 407.771889][ T64] process_cell (drivers/md/dm-thin.c:1972) dm_thin_pool
[ 407.777541][ T64] ? process_bio_read_only (drivers/md/dm-thin.c:1956) dm_thin_pool
[ 407.783971][ T64] ? sort_r (lib/sort.c:284) 
[ 407.787977][ T64] ? metadata_low_callback (drivers/md/dm-thin.c:2243) dm_thin_pool
[ 407.794412][ T64] process_thin_deferred_cells (drivers/md/dm-thin.c:2296) dm_thin_pool
[ 407.801366][ T64] ? thin_endio (drivers/md/dm-thin.c:2278) dm_thin_pool
[ 407.807015][ T64] process_deferred_bios (drivers/md/dm-thin.c:2372) dm_thin_pool
[ 407.813450][ T64] ? thin_dtr (drivers/md/dm-thin.c:2364) dm_thin_pool
[ 407.818930][ T64] ? __mutex_unlock_slowpath+0x2b0/0x2b0 
[ 407.825441][ T64] ? dm_tm_issue_prefetches (drivers/md/persistent-data/dm-transaction-manager.c:69 drivers/md/persistent-data/dm-transaction-manager.c:455) dm_persistent_data
[ 407.832577][ T64] do_worker (drivers/md/dm-thin.c:175 drivers/md/dm-thin.c:2433) dm_thin_pool
[ 407.837973][ T64] ? pool_ctr (drivers/md/dm-thin.c:2420) dm_thin_pool
[ 407.843624][ T64] ? io_schedule_timeout (kernel/sched/core.c:6577) 
[ 407.848746][ T64] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:115 include/linux/atomic/atomic-arch-fallback.h:2155 include/linux/atomic/atomic-instrumented.h:1296 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 407.853609][ T64] ? read_word_at_a_time (include/asm-generic/rwonce.h:86) 
[ 407.858472][ T64] ? strscpy (lib/string.c:158) 
[ 407.862479][ T64] process_one_work (kernel/workqueue.c:2635) 
[ 407.867184][ T64] worker_thread (kernel/workqueue.c:2697 kernel/workqueue.c:2784) 
[ 407.871627][ T64] ? process_one_work (kernel/workqueue.c:2730) 
[ 407.876505][ T64] kthread (kernel/kthread.c:388) 
[ 407.880421][ T64] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 407.885895][ T64] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 407.890167][ T64] ? kthread_complete_and_exit (kernel/kthread.c:341) 
[ 407.895638][ T64] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[  407.900250][   T64]  </TASK>
[  408.110589][T15134] XFS (dm-5): Unmounting Filesystem 775c3985-ac38-4321-93b2-4ba41106f9c7
[  409.298910][T15154] XFS (sda1): Unmounting Filesystem 71ed96b5-a402-465a-aacd-b632e1c437af
[  409.455525][  T307] generic/459       _check_dmesg: something found in dmesg (see /lkp/benchmarks/xfstests/results//generic/459.dmesg)
[  409.455560][  T307]
[  444.902451][  T307]
[  444.902467][  T307]
[  444.949452][  T307] Ran: generic/450 generic/451 generic/453 generic/454 generic/456 generic/458 generic/459
[  444.949470][  T307]
[  444.961979][  T307] Failures: generic/459
[  444.961996][  T307]
[  444.968746][  T307] Failed 1 of 7 tests



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230926/202309261205.37e93c9-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

