Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD1E1101;
	Fri,  3 Nov 2023 01:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/DKvkWS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698976584; x=1730512584;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IeyQw0YBzbeSaLgRYj/kpfQdq0M73Q2cDBSZh9K1ia8=;
  b=g/DKvkWS7Mxm7gdxpsehqPWF4T4IZPIUAYKt7U3Whk7fYlyYq8Cv153A
   uFrWj+iGv05YizXWRsAEVrPguL5HL6DyiCf+CAWI0rsuxtJ357ziyGaWR
   aW63NusytNrdKM1YVeNZM1ssRqMfRe0EspdNvNk4rhT8+PB1gClb77Bx8
   EzPRZfrBBixVuu/tPXaz4QfYTCai17KdDuO7ywfwCLoKGkymBse7UaFwO
   UBNczx5o+j8EuDjDVqVzUtTlkzwRRc55YQK26iCzMwm+S4dFj7gTCdtw0
   gq8QIdju7tGyTjP7Po/ZlICmTUDnhqzYWnlevTMvBsuiAqJaYzbNFwSMF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="379257827"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="379257827"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 18:56:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="905183555"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="905183555"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Nov 2023 18:56:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 2 Nov 2023 18:56:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 2 Nov 2023 18:56:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 2 Nov 2023 18:56:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 2 Nov 2023 18:56:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iB15X2TvYQSWAFYfEQRU9wioAQDavRuNqzHLjp2fZbNWDIfwpCs4yFCaBfC2GrTo0ZxgQKsvrO7mo7lCnHfttr3E8/TB+xbmxAywE+J0m/AOQvGSloHhYGcIHu3fTfFzlOppqLX7j7gxq/Qpv0Xrd61sF3uva1bPZ0mMBXyRXmDzB8EKJBuY4GP6VkdN7rzObyJ11LxAwOGeF/YBaKqC44UuBx8UtWQJIz7Q4sg6+3pEMACnU4Slw5oawp8iGhmwmjRxlOPLzK242urua6VlNqiBR0/maZhBo5RsDmNFJeR6uFdomnf8Kh4quLXSdVmDizG3tATXjA27TRIQMRQF8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmqJCr7CFLDrH4mBgWhLdP8Ce/zqrhHtQ/3ZWwcBsXo=;
 b=OMx3kGtsKYLiLHN9Tl7eUUCZR3wSjjzosaHe31gfgvxsRK2FgxsRPALDnhVNAuQTMmFCBa3J0mwGvN3Z/ld82FJaSSUK0yz6SGiDRlmss9XTfsP3MlkLy5MpCFkJAMZWUMghbP4CqeACZkA5/f3ib8gESzUWbcRgoWGzZZrp4GezatnDhb/U5ziv3as7QBDPb1JeFhgbx7/Fc8Bs6ZpgG8hbzDeXrJwXAlX/wwRLkkwYle+KQE5PhHYr1t9UughgvK9XdAWPKKa5ZVW1ko8p4LAo8Bsw0q13BTfJEyiS0w7WOcJ08Qy8nHwOBt1XAUMDVzu3uFlf28JLQJeNZFClzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by IA1PR11MB6172.namprd11.prod.outlook.com (2603:10b6:208:3e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Fri, 3 Nov
 2023 01:56:19 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86%4]) with mapi id 15.20.6933.028; Fri, 3 Nov 2023
 01:56:18 +0000
Date: Fri, 3 Nov 2023 09:51:34 +0800
From: Yujie Liu <yujie.liu@intel.com>
To: Mike Snitzer <snitzer@kernel.org>
CC: Matthew Sakai <msakai@redhat.com>, <oe-kbuild-all@lists.linux.dev>,
	<dm-devel@lists.linux.dev>, "J. corwin Coburn" <corwin@hurlbutnet.net>, "John
 Wiele" <jwiele@redhat.com>, kernel test robot <lkp@intel.com>
Subject: Re: [device-mapper-dm:dm-vdo-wip 55/90]
 drivers/md/dm-vdo/block-map.h:35:37: warning: 'UNMAPPED_BLOCK_MAP_ENTRY'
 defined but not used
Message-ID: <ZURSJr+q462oRC4y@yujie-X299>
References: <202311021353.WMMPQspU-lkp@intel.com>
 <ZUO8OiRFhUNlC2rR@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZUO8OiRFhUNlC2rR@redhat.com>
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|IA1PR11MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: ea7fa635-9443-43d0-fd27-08dbdc101235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1kAeXUmA/LzCVYBG5TzYNMpN/wM9wLS1WbfosgeFeQRpMiFcbE9Lj5TqpL+rX3GapiXcUomhg5JJYmfDeA3YAOaeAUahaakQ0huctsrWmS8+70RX+dCtZ880h3emIKHIM6TDAI+6e6ddvRzZNBv8UrXPBDRCcbqedF5Mo+lPrLnoh3Ky/wVvdT9iYnbSeXoKIbrVQv5A1El0YmRIyGHAoEDHFZIzoVl9ohcmyGPe2g1rAR8WT7kTSZsNxSKdzmiVNSYsfcju1RVCtcgIg4XlcsNbzaK5FAzREiaf5D9iIKbdSWWtkgavcEp7iML6WdLrsqhuJnblBRFFVDBiQC7HoRdH29t9sVk4/IyvC8b8i3DF2KPwXzXmaU+wCxbJEpOwQQLgAvtbSah256KvSfCPwp/RkvhOuccldSPcDS5RRWYMChDd0VlKT8YJOkMX7Qhm3r/uCRQPaWFLRQI4q+j/O40rqYxlaolxrs6JlSprwK2yCWRD41ZK/6eSDiQ4aUY+yT3yIBsZ0CSmsUPZCVASp8XpJVSzfHPNu5XQZmTR6VuyYXmPmOAbMlyXzzdz9x6Usz1qKUTFPT8WaajIKGMrAIO84v74NKQB0MD+xA+OpBFcdF2zfRAilZpYn+pMSenwlCLpuB+DsmmoBw8krPQkN0hKRTUYayHrwZC4cn6tTP4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(39860400002)(376002)(366004)(346002)(136003)(230273577357003)(230922051799003)(230173577357003)(186009)(1800799009)(451199024)(64100799003)(8936002)(8676002)(44832011)(4326008)(107886003)(54906003)(316002)(6916009)(26005)(41300700001)(2906002)(6486002)(6512007)(5660300002)(6506007)(9686003)(478600001)(66946007)(83380400001)(66556008)(38100700002)(966005)(82960400001)(66476007)(6666004)(86362001)(33716001)(4001150100001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qi/9HCashoFB1wKHcuMu+BlDPL+vUSCmSuph+d7TIIyVQsxKG8v7IfyhHcOi?=
 =?us-ascii?Q?HCxz1WroLtcY+F37rxQf/mB7FTFm1RmC8OR68O1+WmBSCZ29YNIWFewlBshx?=
 =?us-ascii?Q?UJenUe6M9MW3iOfzYzn6zTXgUmMWDD7VkezGnQLRrzk+8w/qgfeLGHGRU/Rm?=
 =?us-ascii?Q?45MJSy9j62mMm12uOGMsT9dij6Wl4uQuU4jaBZoIYHG02UI4d7T8aZEiu6tU?=
 =?us-ascii?Q?FDgazTED6J1v15T2Be1B6MyU/N94jnNvjMxJqLdN5o0tx/Klc/Gu59FIZXhU?=
 =?us-ascii?Q?Zk8UMq+py+Lp4SnAA8FK0NfnpUggWECs9mKwUlrvHCV43yEqMxE2t+l+kgSf?=
 =?us-ascii?Q?1aRyn+5T4/6ikl39FgbtDiA9O7qFGMS4hvFl4bzFu0rLIFMHwnoqbPWVPcy5?=
 =?us-ascii?Q?J8Dky/rnEgDVAPYoDquIgJ1XSVEUYF5KqT4+uxUjKsXTbFmxJodpwWwFZ7SR?=
 =?us-ascii?Q?MyJjdBAZdLa+LlYyQs7bBNWJuRzuMcPOiMssaWtWjvjAxgnW1mneOSCw0Qrg?=
 =?us-ascii?Q?sgxTXepAc+2i7BtPQzPT8Ll7T7HJwxH+EAmY/iyvXaIQjmy7oHtmL7Nn43Fq?=
 =?us-ascii?Q?OOrypJ88WQVQJ+yn1tyr4iGKlAkr9Cwb5T/sxRltIRuz8X7nenPwmjYfzrlW?=
 =?us-ascii?Q?043RFjsjfpmuAew8wAn9T8hoNMe1GnyL8IUduKkvqLoVfevL1KKXspe2R4Fb?=
 =?us-ascii?Q?FxYvdfGv4E2zLx6SsfafLfVRfsCI8KuX3NjMIhbN3BSTGQBS8Hm/b9BsQGLJ?=
 =?us-ascii?Q?0cIKPiizKfBRwbuhMSwnoW4cz+Hzue7odcsWTQQy/GvAxKi/FJJOI+1HQMPA?=
 =?us-ascii?Q?g/tEa9p19gYX5/qsa9C/QY9s8BAzbNhCWSWqgI3QperjDercKj+TVF3kRf5W?=
 =?us-ascii?Q?9GTzt2GoQ/RovP6HgxNq3lzfOpO7eOovGTgdWgku7gLED4vcLk0YQLPfzRyX?=
 =?us-ascii?Q?F1cEnVaNQcySBPmBCh9RhG7bswwRbA1VoER4/6v/jYhVHMwWs4zU2stviBen?=
 =?us-ascii?Q?f3dhIFNrlpLx0wzhy5Pnb9iKLqxgTxh1qckqzE49bIlWrV1LM5sFyTnPpi3D?=
 =?us-ascii?Q?JGlJ0/0U7/mDnaU07/audHowXsORcXEd97K9IOhk8RIzjDNKAfOussCm9PZi?=
 =?us-ascii?Q?1PrcP6fGsHvFTuMcoNAkZVfTy7PkrtCS+JTWJtjpV58tdeZTfmM5c5wxtef0?=
 =?us-ascii?Q?lNZVYhoyGjKQhteAb+coKkXfhbj/2MZugkjw9IM0Y70RbEUTYwY+sNHC7u56?=
 =?us-ascii?Q?W3D1cMHEBDNDyT5dnmIanEFAw0U2rQcru3gQtvue9FMXPUmHVMT+ki0c95To?=
 =?us-ascii?Q?lqX3L6uv4cdX5DXAnEWEMyMy0ZEe1LjAzXnBzSRSXGFp4DIY8VmgVx3i+SCL?=
 =?us-ascii?Q?sv6/Xin/JxXp82NV6WtQMvIv7ankbXR5yZyt6ZEz4ol02ZvLvTqBFKnAOj4q?=
 =?us-ascii?Q?4RKA13xmUTlRRY9cdtzCd8YSMf8HG/GD+NXT0JPqt9hyLDHDHAgWMBfxutHT?=
 =?us-ascii?Q?+NKxgzRGDHmkq/gyhjhQggnGAOqxYmjsjyGJZabh70RixTvXe52CWhRN7R7/?=
 =?us-ascii?Q?hU9KylU63VfAlel8QztFhQghphd8/uPqdcMw6JEM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7fa635-9443-43d0-fd27-08dbdc101235
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2023 01:56:18.9134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PBiS178zCUrMLOXiMbZQiKHce8Apmax+pJRChOIU8AwWjGSvqoLbc+tWEV0qrZ3bxtWatRO08nAHQbVgPdUeZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6172
X-OriginatorOrg: intel.com

On Thu, Nov 02, 2023 at 11:11:54AM -0400, Mike Snitzer wrote:
> [lkp: please update your scripts to use the new
> dm-devel@lists.linux.dev when emailing dm-devel. The MAINTAINERS file
> was updated so I don't know why you'd still be using the old
> dm-devel@redhat.com address]

Hi Mike, thanks a lot for this information. We've updated the
configuration of the bot to use the new mailing list address.

Best Regards,
Yujie

> On Thu, Nov 02 2023 at  1:43P -0400,
> kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo-wip
> > head:   d4e7d305aaa9738d9606f986ad8f2f01edbb14b3
> > commit: 5a6d19abe1dc27648b64418df24ea0acef0f38d6 [55/90] dm vdo: enable configuration and building of dm-vdo
> > config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20231102/202311021353.WMMPQspU-lkp@intel.com/config)
> > compiler: alpha-linux-gcc (GCC) 13.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231102/202311021353.WMMPQspU-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202311021353.WMMPQspU-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> >    In file included from drivers/md/dm-vdo-target.c:16:
> > >> drivers/md/dm-vdo/block-map.h:35:37: warning: 'UNMAPPED_BLOCK_MAP_ENTRY' defined but not used [-Wunused-const-variable=]
> >       35 | static const struct block_map_entry UNMAPPED_BLOCK_MAP_ENTRY = {
> >          |                                     ^~~~~~~~~~~~~~~~~~~~~~~~
> > >> drivers/md/dm-vdo/block-map.h:34:38: warning: 'NO_PAGE' defined but not used [-Wunused-const-variable=]
> >       34 | static const physical_block_number_t NO_PAGE = 0xFFFFFFFFFFFFFFFF;
> >          |                                      ^~~~~~~
> > 
> > 
> > vim +/UNMAPPED_BLOCK_MAP_ENTRY +35 drivers/md/dm-vdo/block-map.h
> > 
> > fd98f3e3ccc645 Matthew Sakai 2023-10-26  33  
> > 15deeca3859a19 Matthew Sakai 2023-10-26 @34  static const physical_block_number_t NO_PAGE = 0xFFFFFFFFFFFFFFFF;
> > 15deeca3859a19 Matthew Sakai 2023-10-26 @35  static const struct block_map_entry UNMAPPED_BLOCK_MAP_ENTRY = {
> > 15deeca3859a19 Matthew Sakai 2023-10-26  36  	.mapping_state = VDO_MAPPING_STATE_UNMAPPED & 0x0F,
> > 15deeca3859a19 Matthew Sakai 2023-10-26  37  	.pbn_high_nibble = 0,
> > 15deeca3859a19 Matthew Sakai 2023-10-26  38  	.pbn_low_word = __cpu_to_le32(VDO_ZERO_BLOCK & UINT_MAX),
> > 15deeca3859a19 Matthew Sakai 2023-10-26  39  };
> > 15deeca3859a19 Matthew Sakai 2023-10-26  40  
> > 
> > :::::: The code at line 35 was first introduced by commit
> > :::::: 15deeca3859a19abfaadd333fb3df7a45087ab3e dm vdo: implement the block map page cache
> > 
> > :::::: TO: Matthew Sakai <msakai@redhat.com>
> > :::::: CC: Mike Snitzer <snitzer@kernel.org>
> > 
> > -- 
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> > 
> 
> UNMAPPED_BLOCK_MAP_ENTRY isn't defined until commit 15deeca3859a1 but
> it is used by the earlier commit fd98f3e3ccc645.  So it needs moving
> to that earlier commit.
> 
> But that aside, the above warning is correctly complaining about the
> definition of static variables that aren't ever used.  We need to
> define in block-map.c but declare them as extern in block-map.h
> 
> I've fixed this up in linux-dm.git's dm-vdo (and rebased dm-vdo-wip)
> 
