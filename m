Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8A0136997;
	Mon, 20 May 2024 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716217346; cv=fail; b=rBq/ih3Z4Im7RIfdZOvRkByAh4evJTa7QFjrQmjP5TlUeCQArmSkBTdlDe4rUaEamRkoL61y0Apq2lauJ24Pz+7STythwIRALz93F+yjYZ89BM0yq2Q4q1Co1/ufyyIdW/uaNY54deE2U6D7IzMNstTp+0YiptsKN/SAklXxzjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716217346; c=relaxed/simple;
	bh=p5mUJJCosihm2tykqWZjxLJJgv8AMZ5Y2Kdtpxq/KEE=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WQpsv61yI4YFFxDpEzo1KstWiL/dsyzqO0iIZ83M2WL5APVFR0nWlwsP2RXpow0DXK9zlaX3L1QfeYO3KWAW88dIoUqvFH+Pwx3caxq0RZwI8W4Z0jNcDs0EEPmHWECuY7z4nJYFVKd8M82JPhLQAgTdrtNxsYZOJBf8il+Ewuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMQmXjuV; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMQmXjuV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716217344; x=1747753344;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=p5mUJJCosihm2tykqWZjxLJJgv8AMZ5Y2Kdtpxq/KEE=;
  b=nMQmXjuVNPoPX8kJtaKPF11l2knaRN6NSCRcyiykaoTe+Z3JIXdrVaSZ
   Brdt1HVA1Yb3sgIkkKO4MUPcnUiDOgYNpC3kdZ4tZ+5ahJXiH15E634BK
   qNfys9JNemrLp9eGIDoeXFYQsIy3d3BACdc0wnnzBcfDa4YWA3nU/9Eji
   iBN+lq71SCJifg/dnqmMLxQrd7lfs4RFt4AiudFSRUxTfV7j85Rt19WsH
   6wcRYakJhRRZbvstVWKv6eLycFQP8LwsoMjpc25On5NxbsZqH9/K7YeOE
   C/kyvs/NISNqRPMfpce65EsDrVXNe5AetW9iRuhtYnURvVhCmwSZQZqlZ
   A==;
X-CSE-ConnectionGUID: gQP2HlnTTSO7IR06CqEelA==
X-CSE-MsgGUID: scnd/wmeRtOw/1SUrXMQlw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="34864833"
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="34864833"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 08:02:23 -0700
X-CSE-ConnectionGUID: EkPdDL3KRLyWzc1O1Rwiqw==
X-CSE-MsgGUID: n8dPfaFlS/Sv406bj18IZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="36964476"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 08:02:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 08:02:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 08:02:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 08:02:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 08:01:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2/HtxpkD1fQd4EbMgwbp/K6uVbFMYyogRWYuV/zu5TgrqdGWts8v6/HOIH2v4qt3O9JqWVsB/JFBdv4/mysct5sfAAYDJvpChURTtKOLy+aovwtHjdHxzh8K8x4CdLVxLG7zwUJFcftsWAobQSkR1nZv3CzAXckne/fKA9FUv6gNIo3of36Wtc5sinHeO6capXDz+x9QwD9tFk2UysLwxkAqDcT4l2W8/d3GxaptUvzPiO96YhKOP+TUNAgVZ/rzkwl68Zpz0pLz/SU2o197BiuhbRCdoCIBtSwr4M9r7D2W+ZVGpYRG5eW3aSeYOW3qMLxRpVyXRQO31auvBDTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QR0xZhjjpg12W9f5GYsOqgrXG2U0f47oOMM+r5VEn3U=;
 b=bU1C7r6fbupCG6qAZ51UnfZjX0N9klZOn05T7v/QKculjdGoHJuh43Ct3FnQ4oNAh/Pyh7QfzWp/iWOUL4M/kIhXH1rBbYqUfLMDczx1chvI+N84UhtK96Ruq94aDWL1HvVcposO7c7P1zqClTJG72GItRMFqNt5Uj7VCvrujbu7++rsjvmfMgQ5FICXVZ8oO/SdRshtn/Z99aEqfEz11OiRqfa5Db1n2N55TUPIEwSQpdeHalJ3VYzwBnkXnKcRUksvgXNg8eE1Zq7+pj+5TXDjaVA7ysVJtMBX1i+mKCiNxW+5K4a4UPWA0YtUht1fi69XTiuBPilMoAJDRkcFdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SN7PR11MB7538.namprd11.prod.outlook.com (2603:10b6:806:32b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 15:01:53 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 15:01:53 +0000
Date: Mon, 20 May 2024 23:01:45 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-raid@vger.kernel.org>,
	<agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <dm-devel@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new
 helpers
Message-ID: <202405202204.4e3dc662-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240509011900.2694291-6-yukuai1@huaweicloud.com>
X-ClientProxiedBy: TYWPR01CA0038.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::8) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SN7PR11MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: db8a4f41-e8b1-4282-638c-08dc78ddc8ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3JnkxeRJKVC9EwJXrYHaY+wWPZ6C5pIdrcqYKB9eyWnxxUQuTtpbX9nuJQQv?=
 =?us-ascii?Q?eVBK4vwU/bGNEGfHjhodW9Ou5f7qVakQ3jiMAuRdiBkJBKZdX9tgD9WQwGJo?=
 =?us-ascii?Q?OQHCxqGvy9y/rdO0PRTzkxV/EYv0yubDsphgBMXhB+5YDeN4LtaTlmrDDNjZ?=
 =?us-ascii?Q?jXe7lJeKKOgcqAGONb4Pk1l5+EjBk11ivmOgYkHh5tg+UOUjbaziL4ivhBP0?=
 =?us-ascii?Q?paGYibj1nDpQhjaDze5hLAR8ilmHLVwG6k2s6dDBwkT+IvUN/qQ//1fGawdB?=
 =?us-ascii?Q?3b408irgCGajdm9ldz1Fuzck/iU3R+jcL/9/ouIvQt8RZ7qr1HT30FLeUMJi?=
 =?us-ascii?Q?MWPDNm1kOyt0XjxxJ6qdcE9VVevGWEDSsY25uuTbwAyj53hEVV4Do3P1mosO?=
 =?us-ascii?Q?LG+l1EQYeW/l3uQmL6sVcVOnt6gTzG72foL19T224IVJQjgZiyrLQyS9Z49V?=
 =?us-ascii?Q?lkZ7wa0xOIhmYwM/4juIZ8BnxGnzB+HMSA3YGTKfG+GI2iD2dQs3v2TF7uT5?=
 =?us-ascii?Q?eBbWLg8qesWI9WfV+yjvJNrdifFWNTM4N8/a3GF9IkwlhBOMRXmmT56jHng/?=
 =?us-ascii?Q?YOmQ+TqNL9LxbvIVbLy9Gj+0iQOT1I6NaJutbZivd+GxSipp8AyIotOTDqZK?=
 =?us-ascii?Q?9T816Z+bIYhBqyhnkpOTm0luKRPHX5GALRZDxLRjWOBTdgcIGXX3vHy/cwYr?=
 =?us-ascii?Q?EIYoXV5SmLHVjI+PKIdNuGGjrlU2dBaY4+fe+MBWs1tjC/gpsVqpkodEEI0Q?=
 =?us-ascii?Q?9pqNuQRIln+lqS/adhkW1Rffj78Boi4N1ISfiWKvBZrnXV2b7SaU5htj3tMJ?=
 =?us-ascii?Q?Hma9Nr/A7Z/PI3ibjtxojHmljVrIAED2XTvukFUCYcPfxt0EBs9v/aUvG2FQ?=
 =?us-ascii?Q?gleNElz6uGTm/E4pyIifQv/h5G1tWtdfdBvHszO62O2+FgCvn6NBj/5NOq8l?=
 =?us-ascii?Q?FVqFjeroTHY0uj4+ATTPUKluMzBLNqMdTio6mBOA1Gb5mWbCl7hIEW0a7NrT?=
 =?us-ascii?Q?hnOdWDJr8tbJDTVJc2j17g3ynPHmB0NeBSC81fiQ0aNHQFZCBcyQc/vk6MlU?=
 =?us-ascii?Q?y17J9GMzHgXTljKrc2voa+Vja+bItsL1nIBPYNugwPIqZDmiGjy1ohES2hPq?=
 =?us-ascii?Q?6qWsWWirsct+6K2RnbJqLn+35dn4YFU5f5X5/Q+UidrLl/cU9EKqPwjS+nsT?=
 =?us-ascii?Q?JvFFYAZkIAz1jahsm2QCbBvcieRNucjPIvM6qVKvOjc3qvRg1onGSEeYe70?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NkqTxaEzbcRuzrZm+EqnY6ZnzPG9yOStoBOHR7p3ADwo+FVbXMw48pSAXL6o?=
 =?us-ascii?Q?8rbBFlcZjaCynbKxM9950XEoke1EmxAwzX7WTGzGlCsI8U3gAYQWAbSmUu4E?=
 =?us-ascii?Q?8fTHjer7SZtKIEL1chJugmGDuRAJhFWNvBX1y5xNVb7Wfuek1aLaxNb20PrR?=
 =?us-ascii?Q?2klMLJzGUO3G3EUgLrlIVNW0chjkM3u+e0pFSJ7G8KpljuhVRXX88jba05uQ?=
 =?us-ascii?Q?GBUDiCrqf/3MzHMUfzMJ/plVWAsme2dD09nOpnPJwpQV7GRg1pbbydwbdO9g?=
 =?us-ascii?Q?ErHA3HmRIxAXWi/j/wVm9vgup7Jw8/48xt86lpxP/stVOZrswOOGOmatxZLk?=
 =?us-ascii?Q?t4ugaoeYw0VXKXT36Sb6GUlJ5CC7LWis1msyEEn5d4coknoja4aNWsVi/Hu0?=
 =?us-ascii?Q?68CH37+h0Bk5ct/d51sEvIbZ/Rx8dUg+dSmDW8wRCW+XYrTtFcuBxGpY+aXT?=
 =?us-ascii?Q?IA9VejKbsO0QOzLydv3Q3JU4A+99GLNknDiyuYGsVj1tfHkKWe5VG+GGIx4w?=
 =?us-ascii?Q?Hj/spzIWSoPpK0+FPcKMJWvTRKG0oBjIoJprmgO5a0AecQ1sNBnpdYyZwNbW?=
 =?us-ascii?Q?JrWHTzm0sUU1v88f4nIqb+ig8tyQaCUXpnXJjZD3k2j8F1LSOv1vWKRwFiuh?=
 =?us-ascii?Q?9qBmo1nSiTXTfVvqXWdZgmBKwrnW7PXcGfKF+IspiJegznA0S7/hFPESyuxd?=
 =?us-ascii?Q?weabrXQp0KXf2IlbjrH94581zVxYOwXiImwv2rGfkuppzfhvT6JCdfyL9wrA?=
 =?us-ascii?Q?BPuAkrGwpJTj0wPay/IdT+OT5Nxq92ySUuqiq8DVd2NkF87fewWYkTEC1/a5?=
 =?us-ascii?Q?llVuY98gHon4/W0gJ87/wtD9MCLmXlZaZMMYD9XSqMuYoZ42smLL4YqYazYk?=
 =?us-ascii?Q?7EYbd4fdoW57lQEQ2/2DFxxZor7yTmhaQ2m+53IAtkCS6hGm+NVZo5d4eLid?=
 =?us-ascii?Q?k5JKcWBVHR7ORigZq9yqTv/VnU+ywDB0ybWQ5JYsTz2vx7wdVvIptFeZiJBd?=
 =?us-ascii?Q?semp7/avK5I+OJnXS7dF7P8zMUVwd+q4YlZjdX5JJssd3OIup+Yy0uuFWvbt?=
 =?us-ascii?Q?bUgF5hy2WUhONUtgquFgOiIpuQcIfQ12RnvRyhD/b98ImGmRv3gagI8OK6Ze?=
 =?us-ascii?Q?zwGh/yUsjaBYUTXih9b/5adymo0FgnQT26y4JPIAq4mKZxO2XMdus6GsAbbc?=
 =?us-ascii?Q?IoJI7mxC9WAfEwbJKMFHpaTCy3VB/2CF2ROgccnbfesWaZr7vkgOWiEclKbN?=
 =?us-ascii?Q?SvIOiXLYCBaAjCZWW1oDZzBW9FvXddjT7MpGRWB2bz6C4eeKvoYrPDiF0xW8?=
 =?us-ascii?Q?pvgr7si/DML0c6zS33jnq8yHRozIIKcZPIhRFN3H+8a93qYqOZ0RxP1LvN/L?=
 =?us-ascii?Q?t/AOCSGdUZs6NrD3uAzQW22pWKLdKdKV7ZqYrI9MDdeWcTlzjH3Gt9L9Sbgt?=
 =?us-ascii?Q?0dS262VwHEUxgePYj/mAVDR8IMYh5wofE3N3IQ0irUAbYfq4vmyJtrqONJFU?=
 =?us-ascii?Q?fZKyQHoUyXfLyRbpxM4ozqhr+eGZ58ZFfuzdPvBlwOMj39WZhJsY3X8wQ8wi?=
 =?us-ascii?Q?iNaL+k8jNLjopN8b1xioQd8B4QTeUN8x4El4Ss7xbhuYDKVeO6vVnqPrZxA3?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db8a4f41-e8b1-4282-638c-08dc78ddc8ef
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 15:01:53.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFtAUFxFrV20PEUVrc3tydaCEYbjUr02deFnfLwgXo7+CNjpJgPF3BUEq3Q8sE3PtZMLjgRQdvm4UrFBu18DWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7538
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "mdadm-selftests.07reshape5intr.fail" on:

commit: 18effaab5f57ef44763e537c782f905e06f6c4f5 ("[PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers")
url: https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-rearrange-recovery_flage/20240509-093248
base: https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git for-next
patch link: https://lore.kernel.org/all/20240509011900.2694291-6-yukuai1@huaweicloud.com/
patch subject: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers

in testcase: mdadm-selftests
version: mdadm-selftests-x86_64-5f41845-1_20240412
with following parameters:

	disk: 1HDD
	test_prefix: 07reshape5intr



compiler: gcc-13
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz (Haswell) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202405202204.4e3dc662-oliver.sang@intel.com

2024-05-14 21:36:26 mkdir -p /var/tmp
2024-05-14 21:36:26 mke2fs -t ext3 -b 4096 -J size=4 -q /dev/sda1
2024-05-14 21:36:57 mount -t ext3 /dev/sda1 /var/tmp
sed -e 's/{DEFAULT_METADATA}/1.2/g' \
-e 's,{MAP_PATH},/run/mdadm/map,g'  mdadm.8.in > mdadm.8
/usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
/usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
/usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
/usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
/usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/01-md-raid-creating.rules
/usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63-md-raid-arrays.rules
/usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/64-md-raid-assembly.rules
/usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/udev/rules.d/69-md-clustered-confirm-device.rules
/usr/bin/install -D  -m 755 mdadm /sbin/mdadm
/usr/bin/install -D  -m 755 mdmon /sbin/mdmon
Testing on linux-6.9.0-rc2-00012-g18effaab5f57 kernel
/lkp/benchmarks/mdadm-selftests/tests/07reshape5intr... FAILED - see /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240520/202405202204.4e3dc662-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

