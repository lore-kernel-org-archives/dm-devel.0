Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCB53CC7CD
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797450; cv=fail; b=eaHBNlhbTHF5sR4HtKNEHWqwf4RB4mxqTdOphPtE2/QhOQ02GIxbo1wbpXErTgUsdsuHXZPWTEFbU0Fh6DMymZdkjPKGRMW9QHu06Kj1hRA16iIAbUmM4e+T1uGTfmwITwhFPYcoPqzDaiucu2ts17eb2oGxD84cikdGavrKBE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797450; c=relaxed/simple;
	bh=Fmw6jRsLrnVIuCVQd3pzDMh+JzFsmiDjabIw71RhPKI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=POZQMzKaajKkMCGiEqgCZHvYi7vcnPQPNebmVPJhq9oM7CR08ZTla4M/NWKbLPuLv6P6L4MtJ+7K9NPUdBbsnxkHKlCeyCH/XGU05PvjIGSq51teS8CPN+o/rlJuARmHiXPPJqReP7O95MMaZP077N46V2z2RuAvhvU4LCypBcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LjT2QXhJ; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LjT2QXhJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790797448; x=1822333448;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Fmw6jRsLrnVIuCVQd3pzDMh+JzFsmiDjabIw71RhPKI=;
  b=LjT2QXhJhbvxrZ+jUwFxouMJFUsRA0J8RRNyaSxshB0t+bg29G0tMYXG
   LmQuHutwHTZ0JSCeQ5EMdzw+pY1vHCnSUrafFx8+5ya+ttUhxVucR5HRt
   wTlvikVKRUd7uB9IXpNF84pRcPBzwxtvwi242axArhyxndzyaRaxtLLWU
   OMWSeKz3ffgvikLk0CcgloAjT/GP9Db6q0Q2/HEanpljV8sAVgpWTzUBo
   Bdqywe3qbxw8CjLvXnX5tK5Iyzx3da/sfZ305NOlYrP6GjX9eyr0BAnLX
   ABSrmjXO7zupzUVHB4JYNg9YXOVxbQyzDF1tsCfuAn00XwqF6KFykr8/U
   Q==;
X-CSE-ConnectionGUID: YCk2rOuUTfa8GoW//v+tzA==
X-CSE-MsgGUID: Gz+8cBcBRvyLb32rCYbMUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95356311"
X-IronPort-AV: E=Sophos;i="6.27,133,1787036400"; 
   d="scan'208";a="95356311"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 12:44:07 -0700
X-CSE-ConnectionGUID: BAE3pRXXSSWcDpCzBXWdgA==
X-CSE-MsgGUID: rysXhI4GR7Wj44skSUsNAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,133,1787036400"; 
   d="scan'208";a="313724829"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 12:44:07 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 12:44:06 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 30 Sep 2026 12:44:06 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.10) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 30 Sep 2026 12:44:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OXciUb9UQfT5BON4avglze2lkeYHtLJLMPYxAF3fiV3tbaI+a8IQBnAwmk0a4KwUaiV6vr3Cm5R0JZB4uFwg0179TYhgpOkAsbI/GCR0YcE34ImUTi5NZYEtpc6eXdXiRzTzZXhFS1gL97ZmlZa6gdkZiUV1IeBh3KK8irkbOTQc3Rjrw3PYjt4mxTDR7Tnpvt6P51eS/fz7qVX16w+FfktcwmlV/xRxbCzqsvRibLDZQbiJh0/m0KXifeZNHZGZLyOAzt3hpg6gGhU3g2V6SYT2RswAMGvDcdRkh/stnk55ajMmYtlevjssEe61pIQBEPZkrO2Fh/qMOuouboy5Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYI3B8OyqGFS3ssejZ9imkq9m+g1jMTnkTmxNJ5FqRo=;
 b=UJ1WGRsRxUNse+gCairW7/zy9BMCudC1jkTq2TEnZ88w+YmRyYHZJtKWKxWqfimSvXCTdNY6Y2n8kd3xo1c6QUXJ64edCf6oh2CJHY794H1KNTSi3aXzhn5Bu0CaCKofqFnWkhyispcVC1Zzzr9dpZbHvqVrW3tVhFpVC9hWbIIoHMwwf5FPvC1T22iilI71Wkj25pUxi97BHzYsTK5x0uQTLu8oQFw/FXnDvKkr8xMpEqRh49JmIMz55kiwEGD5xePlWJ7q5smg31Dfy9LzqLm7cWVi55FuYXm3prMFP0MVFaRvCv0PvRQbVYzcqZdyygqO4XasDyrwX79JEbHBeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:95::23)
 by PH7PR11MB6498.namprd11.prod.outlook.com (2603:10b6:510:1f1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Wed, 30 Sep
 2026 19:43:55 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::e7eb:a872:53d1:21fd]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::e7eb:a872:53d1:21fd%4]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 19:43:55 +0000
Date: Wed, 30 Sep 2026 12:43:51 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Pavel Begunkov <asml.silence@gmail.com>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, <linux-nvme@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <io-uring@vger.kernel.org>, "Christoph
 Hellwig" <hch@lst.de>, Sumit Semwal <sumit.semwal@linaro.org>, Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Keith Busch
	<kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe
	<axboe@kernel.dk>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi
	<joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad
	<tushar.gohad@intel.com>, William Power <william.power@intel.com>, "Phil
 Cayton" <phil.cayton@intel.com>, Alasdair Kergon <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	"Benjamin Marzinski" <bmarzins@redhat.com>, <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v6 01/13] dma-buf: introduce initial file I/O
 infrastructure
Message-ID: <ar1md2N4PkoXSE/N@gsse-cloud1.jf.intel.com>
References: <cover.1789997898.git.asml.silence@gmail.com>
 <5490ee42c4452fd4198b245ead20fcf7438c066e.1789997898.git.asml.silence@gmail.com>
 <arx7ZQ8o9aeHsAqS@gsse-cloud1.jf.intel.com>
 <447c04dd-6bfa-4c45-99e7-37d25a7ab539@gmail.com>
 <c07404e0-33f6-4e5f-a80a-e1901b42dc39@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c07404e0-33f6-4e5f-a80a-e1901b42dc39@gmail.com>
X-ClientProxiedBy: SJ0PR05CA0145.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::30) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:95::23)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4787:EE_|PH7PR11MB6498:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f081bf-bed0-4ebf-182a-08df1f2b2991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|6133799003|10067099003|4143699003|5023799004|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: pu4RpMbSx0h1u4/Dh7Bqc3ep//3wk6pqmzLuSjsmO5+3gbq8dLwoLRc+SmCo/C2d56Tb+skXqpzfeq4CiObkBr1Tfm7Lmx4t2u/goEFX/yVzVfxSDS4uQ3y8QMz+IDNFcS4dWyBI6NyUUXLWTs3iWD6FvkYeQ7ApOSjw6smTeYHFheE4mrUC3yINMUvsSJ3GniIPGzvO+xpGLDiAhOfsVn5tEoftH1AIlJfElH92JK9oASUgGIyazaULWHog//g3pz0KURyWg0x0CAn8Y3sFVfW6hq2GM3E3TcL9RCNYBTusozH/CjjoGjdH0COclr/6HRke+Ztugxcopg/Lwi+q53KOfJo0zkaqv17AK10PyDYbJVuZVKAhsxHT6fCkDtWUVlBSOlSWAuniEJbeP8rrOBHiJrTPOI4IaBVA9zsMsA3BVgDN9I0mbE+doJbfD949NnnLI0QF1fpNFly0R7rq56+Inz1wbETh5adf9JiZAP3CYbk8DtQ5dYJBMpom32fKS2ixCh15InlXIJJOspUHCA/Zn4lZr3kLHqIGgxP2iRj1bqSgGDWxqTHw8+Mswnt3cmpn3ZdkTiQshvOSsIEEQWi20sdzlG/SiyQMgCl3YcnTjeNekk8PPbauw0nQuf7DhcZRtOxkmxk0qhvTeHH+tECHzRHQu7rPT6yuDcyF99U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(6133799003)(10067099003)(4143699003)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?sLQL9tlMeNXRA+DmQwG8OxyqhWpG4eYn2BXjv88Xf5HGIhSGiSW+UQMTiC?=
 =?iso-8859-1?Q?rbSOSBZUt1aJso2rRV44c32cCB4N7PJXR9TSjCt71zr0XhSJ6tzJEpqil2?=
 =?iso-8859-1?Q?+L1NjyqIPWlL2UqMf77EXk9YCx//07WE2sFjLKyfTRXvKh4vfkOhGTfywp?=
 =?iso-8859-1?Q?c52MRs6bzv2NWrjwxXOzgnDQWWB+BNJZc1Cx5Yub7HLgTC0c2p9+B577/E?=
 =?iso-8859-1?Q?e1Y1IAuU4G+LedNR/cZFtgC667PoXiwaLETcCKacgXHzhm1uPtSgy1dvBj?=
 =?iso-8859-1?Q?dMWv4gMDbTg+p00YLLIb7DYuMOZK4Cq8/8hc/Fir6tPFkALZpdnyeqrRWY?=
 =?iso-8859-1?Q?txRTzI7iKn4zqzEz63bQG88c+unZyNC/fKuFW3A/V4UGjHMwTkTh+miUHN?=
 =?iso-8859-1?Q?Qo5wO79EIhS+1vPp7p1injHMPb+DRJ7TyF5djIwsF9r54kIcsl3a0Ji9nS?=
 =?iso-8859-1?Q?w+yhY/m/8+o+GTWaw5RpGOqhrOlUqf7XVii1fPQY7GJForIMklNqpbUjhu?=
 =?iso-8859-1?Q?3FKCp2kr1fiHUHuKC/UAP2HjitGZrapHyLog3g4i1Q7TtnFc6a0LPqmchD?=
 =?iso-8859-1?Q?VdVP6Zw+R29PJ9Yo82bpYvRdS58DiyflKYtCEZc2Gpp5ST20UHlvjtcWgs?=
 =?iso-8859-1?Q?T3pIeH/lkx3SLOfMrp7o1fQlhDa4Wdwiax7eg1zsFZ7wwo5jmeg7LZjlPV?=
 =?iso-8859-1?Q?4X2gl0ThGHxtQJ8EKam1eDOzsjzjQTSGv6Qx6I6u8nH556DTtxOppmfjAA?=
 =?iso-8859-1?Q?/O6ILs+NYwnEo+AmyHc9Q5v6B0pJ8LFczT+vtOfrA+yChVNzJPYMR+0Rbo?=
 =?iso-8859-1?Q?gmK1wsV5ndARN9KjeGNTw5e0HhwfavtRjpJHlla9krAneq49ULDLy9n3mK?=
 =?iso-8859-1?Q?tVMNtKI+b8DoyMeF32qPZSjgADQIfj+ZvMKsRUSeQTpGCS+L6YnArCcEFf?=
 =?iso-8859-1?Q?l2ysEFXY4O+FUHo764F3UFl/VeC3o45XRBUVpAlOZ8VeS8nSa9MRI6fA4s?=
 =?iso-8859-1?Q?oAQKHCApxPR4by2kKKCRBO8k1XRY9Gd9wqqRxfZgI5xKd9vf45q4yZiVdy?=
 =?iso-8859-1?Q?xYFELx8uTdE6Q0bYNaVVCbj2r5l4gw2F2a3/u9B/t/poyzWe8wYaqS4geu?=
 =?iso-8859-1?Q?QJ3hVdDRUj9ATFVsiHCVVXVBQVWJJqspqXg4iHiHVmQVYSlJDDgxRg5y7i?=
 =?iso-8859-1?Q?2PEMSjeRSAvsE1agOQhFRIjsyFMbRlK3zbpudvcnnLZV65oFyF2BxnBKb9?=
 =?iso-8859-1?Q?c4xjL1LGYdNIkwQA/UU7g09OJAmfG//QYA1AvV/gEhORU/E2ASkRu/e4lW?=
 =?iso-8859-1?Q?FPruuK3tzKsZDOrQAcn9+ERhvKJ9ZWXjfTB4EAshtxetbBOOx+eygYqkp4?=
 =?iso-8859-1?Q?vCCRQh4vHGLYPWQI/Qh5TejoHpJBUlqoue8nHONYdS4JldzxExevtLd8mU?=
 =?iso-8859-1?Q?R5U2EwhZEzdKr7E+fIms9ZJdi9pVJfxH/pOl6mDozdbqChZsAp52XPQzaa?=
 =?iso-8859-1?Q?ChnRSZSK2aQnSrYp/BOlXBah8ToyBnb4ODClA7Hjj+1XQuwqgMhO902QVC?=
 =?iso-8859-1?Q?VGsQdtlPOqY8+ZDqLy/kfOr6mxKrXLr2x/dYFGxoXjLPK8/S66AZECB0K3?=
 =?iso-8859-1?Q?6xkg/GsmIfoX6G9PEFPBdezTSek3NYHOKpGDo7+fuApfa5IZ/LUJErF8OK?=
 =?iso-8859-1?Q?gMxnhTP26xK4iY/PVcnnEEmSvU4N1ZLpBnEZs5yU4jZprdJH2CDl1ATwk0?=
 =?iso-8859-1?Q?ukvv4SsCWH3f/KvNNf3dp9Fl/HKQOcyNleW2rbhmzOZvkfpv/SRLZj2TP6?=
 =?iso-8859-1?Q?54XPoBFolucoI54mdKJQI3u/PH2oys0=3D?=
X-Exchange-RoutingPolicyChecked: JUQQoN3GXGmzsHWGDdX/uoFf71hYWwo6dH6kRN7M+SWv74nUu6Bn+fgx12kwKrBfulW3zKnpPkPShJ2nouK/om99IWXiiN2UAvOI/Pu9AyZWVvnRUXAsw1JmwFVuC5/zIxZGPKYgZADCdtboo1069YDr0YuXJB5/uC2m4T7qYjN189HRc7mwsy0qArdrBZSLqwE8aQ6kbVFCXy27MWfBKgdrRw1Dirn0K7aKjm2WdoGol7y9S6IFOsEvbEkFbHDkNtlItK0ydw2seP4s1sg+8WHzvfKXnb1YRn4Tvclv5f4iPIaS5w/XAzaUB25oyHZK0Y4FbxWtbkeg/GeKDfxzwg==
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f081bf-bed0-4ebf-182a-08df1f2b2991
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 19:43:55.2719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQO7usHwnfdkyXgs8WgRkzr0QqC2WbfL5Mb6CjPb3HzWhJINM+ofJ5l7jTRlwt9z1Vdsk1y7SQDOFYY/Fv2HpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6498
X-OriginatorOrg: intel.com

On Wed, Sep 30, 2026 at 01:48:49PM +0100, Pavel Begunkov wrote:
> On 9/30/26 11:08, Pavel Begunkov wrote:
> > On 9/30/26 04:00, Matthew Brost wrote:
> > > On Mon, Sep 21, 2026 at 02:38:45PM +0100, Pavel Begunkov wrote:
> > ...>> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
> > > > +{
> > > > +    struct dma_buf *dmabuf = ctx->dmabuf;
> > > > +    struct dma_buf_io_map *map;
> > > > +    long ret;
> > > > +
> > > > +    guard(mutex)(&ctx->map_create_mutex);
> > > > +
> > > > +    scoped_guard(mutex, &ctx->map_mutex) {
> > > > +        if (ctx->maps_killed)
> > > > +            return ERR_PTR(-ENOENT);
> > > > +        /* recheck under the lock in case it has already been re-created */
> > > > +        map = __dma_buf_io_get_map(ctx);
> > > > +        if (map)
> > > > +            return map;
> > > > +    }
> > > > +
> > > > +    dma_buf_io_wait_active_maps(ctx);
> > > > +
> > > > +    ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
> > > > +    if (ret)
> > > > +        return ERR_PTR(ret);
> > > > +
> > > > +    ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> > > > +                    true, MAX_SCHEDULE_TIMEOUT);
> > > > +    if (ret <= 0) {
> > > > +        if (!ret)
> > > > +            ret = -EAGAIN;
> > > > +        dma_resv_unlock(dmabuf->resv);
> > > > +        return ERR_PTR(ret);
> > > > +    }
> > > > +
> > > > +    map = ctx->dev_ops->map(ctx);
> > > 
> > > I'm playing around this code now.
> > > 
> > > I think you need the dma_resv_wait_timeout after the 'map'?
> > > 
> > > If a device doesn't support p2p ->map() will typically trigger an async
> > > migrate to system memory and data will be moving but the map is valid -
> > > Xe 100% does this, I checked AMDGPU and fairly confident it has the same
> > > async behavior.
> > 
> > There is a wait right before because I read somewhere in dma-buf
> > comments that I need to do that, sounds a bit odd if I need to
> > wait on fences before and after. I can add it, just curious how
> > come that other dma_buf_map_attachment() callers don't need to do
> > that. Or maybe they wait somewhere else?

In GPU drivers, when we receive a foreign object and map it in Xe or
AMDGPU, this logic sits deep in the stack. However, the top-level call
is typically ttm_bo_validate(), which in both drivers eventually
resolves to the TTM ->move() vfunc. That path calls
dma_buf_map_attachment(), which in turn invokes the dma-buf's ->map()
callback.

That ->map() callback can trigger a asynchronous move on a different
device, where the top-level call is again ttm_bo_validate().
We then end up back in the TTM ->move() vfunc, where kernel fences are
installed. I realize that's a lot of layers, but the call chain can end
up looking like this.

Now we have a mapping and an object with kernel fences attached. Before
the object can be used by either the exec IOCTL (batch buffer
submission), the VM bind IOCTL (mapping into the GPU address space), or
a CPU page fault (not relevant for dma-bufs since they cannot be
CPU-mapped, but a useful example of a normal BO move), we wait on those
kernel fences.
 
In the case of the exec IOCTL or VM bind IOCTL, the kernel fences are
added as dependencies to a drm_sched job, delaying its execution until
the fences signal. That is where the wait occurs. In the case of a CPU
page fault, the kernel waits directly on the fences before installing
the CPU page mappings.

So the TL;DR is if you want to immediately hand back a valid mapping,
the kernel fences must be waited on before returning after ->map() call.

Matt

> 
> I can't find it, so maybe it was the comment below and I mixed
> sth up back then. I'll move it after ->map().
> 
> 
> * Note that for non-dynamic exporters the driver must guarantee that
> * that the memory is available for use and cleared of any old data by
> * the time this function returns.  Drivers which pipeline their buffer
> * moves internally must wait for all moves and clears to complete.
> * Dynamic exporters do not need to follow this rule: For non-dynamic
> * importers the buffer is already pinned through @pin, which has the
> * same requirements. Dynamic importers otoh are required to obey the
> * dma_resv fences.
> *
> 
> -- 
> Pavel Begunkov
> 
