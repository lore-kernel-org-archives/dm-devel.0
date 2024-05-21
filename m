Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A787F14AAD;
	Tue, 21 May 2024 03:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716260540; cv=fail; b=WzAdaY3T6SMtUjhvuBQFBGV+Pk0pRXetkEj983/8tmOazVfcimk+cGcR0AvxHDkGuVpKv0Jvm3zWMPPSzBRDzNDsUzbQHZ/uT9yK5L6wE/jK3mw2SNsmd3xu+s0vWaAhIVDO1q0HSzyltZ+gYFTkb20fB+C6gpIU2w2xDm14vZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716260540; c=relaxed/simple;
	bh=MKzeVWy+wjZ7HCwmrYOQARPZTzbTGihUtMhk0VHDDRU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NjXWTDMMTfLj3iD7OE8yM4g/sodPw3WmKGrrcchl8ZByA89W2eyaieVyXKnimUZ7QlBUpQ81ql0zvfmGfr/GUGT041XhUwIaKfOU5v7e0fq0+XrZAslfD5nBJYRANTeDvuAPCNbDBEECyRdvgS4teObsiuVxM+hDC22i2zwN1C8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INNSUhPv; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INNSUhPv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716260537; x=1747796537;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=MKzeVWy+wjZ7HCwmrYOQARPZTzbTGihUtMhk0VHDDRU=;
  b=INNSUhPvdD3a7pYtJrQvTD50dwvwHIVEJeMWc3L3ItTq+6mPYcqZfxoJ
   1LkzNpEhd3l1ZC0uwH/WC52kAKQnhKl/XB+FWbPSKpYs6AMnWcfuHluy0
   5ojX1RNmMVdDGmTJ0SlQQ90c31EiH/RjPGGbj4i7DfjwnThsOU/aPJavj
   uIh8PeRsA1bxbbaUvQ7RPCjdMkEO+3At52vCmsyZM5CGwYd134Jtiytba
   rXX01j2Hy7eS6aoIY6pfUyPWBVcVM1lil3PQ8lGNYgb4nC/wgcd5IiQ1i
   HXLEVPYC8OzPmSoXrBROWwwcJNQb/Zi9OmOnsyZTB8R/b97qenxF7pE8C
   A==;
X-CSE-ConnectionGUID: bgH9555HSS6tOATbpXuiNQ==
X-CSE-MsgGUID: XQS7DdRLSn2gOWHIe7RmYg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12543080"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12543080"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 20:02:16 -0700
X-CSE-ConnectionGUID: H1BTNxqpRqStJVzvnYrfnA==
X-CSE-MsgGUID: rxknXdkZSW6tNMQN/a1Yqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="37703304"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 20:02:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 20:02:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 20:02:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 20:02:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 20:02:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOvxlXsqo6Rpvx8SqRdJxZj0q7jJUgJKtQoBRW0VaITzqa7XZkXeqb4QWQ2OWnaC5/v0xPUBNmRXt1WtSgk2yVudH6rnE7nRhgGadTDV/9sHCmM1rPwLoTgl0kt/YPtXPNUCfORCn/5gu46ECAukrea+2MLHhChTRGLlNwcp/2IkT+Ktw2j+F3qy6UKrOdOgqcCzbRO+33J+3KAKdyA9XfCJPXoZCMOstYPekaZtD1au194vfGND8ZiQPIylJ3hc00GFEU8MLPtdNRtDS4u+M6A0HmIkWZ/F98MiB9lquirek39K+DOEAJPg368D2VOXeHQQrpdhplS4zgQ7xIR30A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IW6d9EssbAugk71Zp4P84s2JGCqUpJj7+DfOxiJHbmI=;
 b=DcP/pR78G/ohOl51VRKDYOKvjTrEL8vp56j5k2i1Ac4+qXJ6vv2o5bTiwcGOBLj276i2MJ9badEQv4gqfoD4ammm7xp5EX3q4KOvo/utpHDllZo6gS75RuKhVo1mO4fRkKPad5wz6jeQOdWjpZXwYa2ImtM6HZ/HA4oIVgb/Qt5Bzyh5uhH7JagxrS0zBbTftPW3f0u3qH7p3IxmyvSoapOuOZztxczlyn2nXIui7Zq+mSVKt9JywV10ZcXq1uAuDoVVzcWKo31UdmhiDLc9JFJVS+6smqpDQ8BEKZ2NYdFyhkJ7zX6gb9Fhnx8HaHKZvu+F35MzE+9va8r3ngPD5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB7607.namprd11.prod.outlook.com (2603:10b6:510:279::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Tue, 21 May
 2024 03:02:06 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7587.030; Tue, 21 May 2024
 03:02:06 +0000
Date: Tue, 21 May 2024 11:01:56 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-raid@vger.kernel.org>,
	<agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <dm-devel@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new
 helpers
Message-ID: <ZkwOpD8rjYeb+4eT@xsang-OptiPlex-9020>
References: <202405202204.4e3dc662-oliver.sang@intel.com>
 <c9406496-7b97-a3c5-b48c-32f8248cee39@huaweicloud.com>
Content-Type: multipart/mixed; boundary="f8HxJDUHT0YS5Psl"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c9406496-7b97-a3c5-b48c-32f8248cee39@huaweicloud.com>
X-ClientProxiedBy: KL1PR01CA0142.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::34) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: e16df422-4777-4c57-61d6-08dc794265d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFhseGNpcnZHRHJ2U1RCL3dUem1rbEJiMkpCTG01bklhT09NNDl5RVpzUnBU?=
 =?utf-8?B?MGk1NW1mdDhha2IxMWUrTENmRTcycXl0U1FBREcvRHQ4OEhlQ1BwU2NNdVpt?=
 =?utf-8?B?NERaMDhFWU1CcmdzWTlEL0ptWWNEODZoeXlzMEFORW9JYTJERjdKajJGT0Vk?=
 =?utf-8?B?aGtUVU5FdE03N2RKb1pNMnBxY21WZHIzN1RFN1V2WTNuSWkzZUtPeU5UeUN1?=
 =?utf-8?B?clZtMEdTa2p2a3hEL096Q3VSTkpNMlNaWGJsZHRHbGdxRnFuakR4TGVKTzdj?=
 =?utf-8?B?MFAvSWoreDZVSC9CT0gyZkJZRFNxRGhpSkZTVnY4Zk9sekExYUNQM3hYTkF4?=
 =?utf-8?B?VEE2eVc2ckNXWWNZdzZ5RklsYTZQTDBzSVlqbjFtOGJOb0VTRzk0WUc3Yk4v?=
 =?utf-8?B?WU1ra2JDUUJ1RGUvSXlYYW5GNEVQNG0yRmdRVm45TGJiUStYS3pmb21CSE5i?=
 =?utf-8?B?Y09TVlFYRURQOGVEeW5vNDNCbkFEbUlQWWxZMWtscXpFaVhZbjFlS3dSVEc3?=
 =?utf-8?B?RTVGMXR5Q0IyWStvaHpLR2l0Ny9RQS9VYjN0RlppVEVmUFVia1hwTVZCMVVj?=
 =?utf-8?B?dVVad25iTWNRano0S2xJQ25jekkvNnBXVGIyTHBqRE40dm1aNFlpbUdmdzdK?=
 =?utf-8?B?UXJ2YzVPZStQQnFaZzlPanhwd0Q4TXR0elk0dmZQVXdiYlU2ZkdaMmt0WUY5?=
 =?utf-8?B?KzdlNlpLY0pNYVVPQWE1TnI3OGFaVW5iRmoyRGt5K054UVA0RzZEclBqSjhs?=
 =?utf-8?B?K1JPZ1d5N3lES0ZsbkNXQnFUNXRvcE15bnNOZENrRlpOTEtnMUYrZjFybks0?=
 =?utf-8?B?MmxtSGR0bU4rY1JWZkNMNXNBZFhrVFZRMXREUk92RXdhZEE2MFRVbUdOcmxJ?=
 =?utf-8?B?S0ttUzRHR04zSWhUcTIxM3M4V1lvNUxzalIvTDBWaWpxRG01RjBvNTZIOHBv?=
 =?utf-8?B?VmFGMlRJU0hSSnNCOFFOejBhMm0wbmJuSjhTakhicno0Zk1la082UXVSNmNq?=
 =?utf-8?B?WmdiV0JKcHIybUdCbFcvdWNHV1R5K3RlRUVJRFlJb1lGaVh3czkxSGtCN0R2?=
 =?utf-8?B?ZUpDWVkyWDBqL3JVVVdwbVZPOENvZE1oc1BHaVltbDBnU21rckpaN29Lekl3?=
 =?utf-8?B?QnRjdW0yME1TbjVZRmdsZlUwOW5palh1WUxPNkM5TFIzS3prNXdtN3RiWE43?=
 =?utf-8?B?amJNNVBRVXB2OVRYaGh6eXZremtMNzRBWFJNTlV5YXVtTWZWM01XMXdKM3or?=
 =?utf-8?B?S1lVWjAydGhHMTRnUDNEYUlqR214STZFdWV0eVgwakRLbDlxSGE3T3lTV0Na?=
 =?utf-8?B?SFZOSXROQkh3QjJVV1kreDd3cDl4RGZsYkZmSDl6TDk1M3llS0V1TGtrSmJt?=
 =?utf-8?B?dkduZlNUYzJGMFMzdFF4QjlHMExMM3ByN0pSK1lBSW9CSE9EN1FBblZKNEE2?=
 =?utf-8?B?a1dLNmNrUGVnREJxL2ZSaDVjUGJQU2xzTmJybzFUZVRHTUxLaDI4ZFNuaEI1?=
 =?utf-8?B?Z3Axb0R2bG5RbElzaFhlK0VPbUxaakFVSVgvNzk5N0duaGJzYzNQb1FGcnRu?=
 =?utf-8?B?Z1g4WDYwQXVPZ1dWVGF1NFRJa3czRE1IbnFKcy9GbCtMTm5WSXozQ1FpbXpE?=
 =?utf-8?Q?YQ0wyKT3lfsC4euG02RYu388zVPBNLk93Qq7DJ6hYLf4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUZqcGJ5UUVUNDQyYkJsOE5TempQS3BPajYzemVxbllCVTVHdmxYckJtK1Qz?=
 =?utf-8?B?TkMvbk40dTdYYWtwWDloUjhtNkJmeFdoM2ZpUjE4SUQ1cEhrazM3eWQ1VGU3?=
 =?utf-8?B?OHV0Y1JsazQ5S0I0WjNhMytwcDliRXUvUWtCRWh4RDVXcGd1K3daNTRHRUpC?=
 =?utf-8?B?U04zcmNYSmRsMWdiSXpuUWhuZzloRTUwT1FNMmdqclVqWDR4cW9NUkkwU0dN?=
 =?utf-8?B?eEcycXpSYkRoZ2NwR0dHRHpJc0F4aDRDNEx5OWdLbVZsTmxia05EK3ErYlh6?=
 =?utf-8?B?ZGpvcjFqSDJ0UXB2WGJQREhYb0N3aHh1RWlXWEVJNndEekJCZitwM09xelFq?=
 =?utf-8?B?ZHBtZU80eFdjM1l4azJSQ3ErbmhBc1RxVUlhZjNhbFBqWUhkUXZsZGsxNDR3?=
 =?utf-8?B?NzBWRWx4SE9jb3R1emM0TGdxcUpteVVSam9SZkZwTUdLbGpRS2JYVE9KeU52?=
 =?utf-8?B?YThDVWRaWW9MTi9sOWVTOWg3WGpUdCs1TUZ2K2o2UEJIYXNzQklTOFU1eXU1?=
 =?utf-8?B?TVN6aXBSemxrVHA2dStxT0ZTSzk4K21TWEpibm0wa2tyZHgvbzU3UHY3NXhn?=
 =?utf-8?B?Z1d4TUQ4OE1CanhLMG01aVNUVFIvcHZPa0xYUjdCcHZVaE9acXdrMTZQSkVU?=
 =?utf-8?B?bXh6YjhwQmxRRHZVS3NqS1BGazlQUEpndUtRYi85SmcrbmtJQmIxb2Y4Uk9O?=
 =?utf-8?B?YmtBVkM1UnlPeWhZZXRZZVQ2bzhCNmF3WDNiSCtRYmVGRWFtdDVkVG82SVhJ?=
 =?utf-8?B?eUlwQXBuaVhZRG9LOXZjemx5V0NGMFVmWkowRStpU3p1TUhMS2gwaHdCdkpN?=
 =?utf-8?B?SEljUnI4a3huRzAwVUxiQTVDZG1UM1Jic0J4Mk1saFNuS2hYYTdlVHZUVDRY?=
 =?utf-8?B?b0Zkb0Y5SFpxeEFYcDJWQy94Vm1qT05IOGhzOEl1SVZFZjhyU3NVUGRiVnMr?=
 =?utf-8?B?UWN0RzFMUkIrdlNNY281N0plWksxTFFjcU5OaS9SV1BRcUd1K3VhYS9UTFQr?=
 =?utf-8?B?SGx1TFMxU2tKdVd6dVRFekZ5d2tUNUh1M0svWG5NTytvK1FQeTJ1N0tNZHFJ?=
 =?utf-8?B?THBoUXp5NjlDd09BcFhiMy82UDc3M0ZsM09KUWxITmdJNmJjL2VIc3NCQ2w2?=
 =?utf-8?B?Tjg5LzJiS3JpSlIrRncrNFU4VW5leFJpQnZnT001UlhCcngzTkRIR29Sd3B6?=
 =?utf-8?B?VUoyVUdKcVYrYytxWXIxSFowdjErajlsU2FrK0tVOWtGVU5LVFNmSk9GeHRE?=
 =?utf-8?B?VEVFaEhrNTFJRHl2THgrRjM3Q2IzN3ZQbUlzeElEL1YxN0cwcXBtbSswdFFn?=
 =?utf-8?B?dHpxOStKQ1A5N0RhdXhXbWNMdTRFdFZSdWlVczFYTEh1R2pjVm9HOW5IK2xR?=
 =?utf-8?B?WUVTNmNxUE9kMWR1QnVMbFNRQXlla0Q4QmdzS2hvdXpJU3dDTVB1c3NTODZI?=
 =?utf-8?B?NXhLaEx1L2dqRU9VTE1mQ1VvZFU5TXRZelBEblJydTZCbExPSE1XbjE5M3Zt?=
 =?utf-8?B?bTJrUCtUQ3dBeEJvaEV4bkJRd2Nta1NzbDF4WkNvQWZCYjRVNU5XVk9Lcmxl?=
 =?utf-8?B?VkoxMXA2Q3J0c1dZdmRlcS9laW1pei9LbEJYdmNrNTRXLzJWaldtb2JwbXdu?=
 =?utf-8?B?Nkk4YmZPaDZVVFdOcnJXUTdOc3J3d3hkUWVUK1pxbWJkME9YRkxic2VUR3p6?=
 =?utf-8?B?aXpoYTg0RDVWSHorcDVKZFR2SHFycXAvOStlRVE0SXIvcXFZRkpsZWJJZFJi?=
 =?utf-8?B?dENVMExObjJCdDNpQkVEMXBLSnFDMUVCcmorM2ZCaEFKakRvTlNHN3Q4NHBJ?=
 =?utf-8?B?UkhRT0J6MnJDaWl5aXVIOFkxQkRFaTlCKzdoYUZFb1p2WFEwSzUrbW9iQWFo?=
 =?utf-8?B?YzBOQW1zSWVINDJsUENHTWFPY0hCWTgra2x5Y012NEh3akJUenBWUnh6MHAy?=
 =?utf-8?B?dnBCUFYzc2t5R0RGNjZJV1FINll2V0c5ZjdTeVdLelpRRG9kR0IybFg3NUhL?=
 =?utf-8?B?ZTBwTEZQRERoNUt5QU4rL0FuMVpRRmQrSFlVa0Vqb09iTFF6N3VQSUxMUHhK?=
 =?utf-8?B?ZFRqWGIrS0U4MWh5K0ovMUFzMmdha2paSTcvQUFqR1MyUTRLU2hiUUR2VkFY?=
 =?utf-8?B?azZsSDd0ZmlQaTBQdTdiM0ZtUFE0bmc0Rlc3UEdVeG9OT0gwSUJCdzFxRFh2?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e16df422-4777-4c57-61d6-08dc794265d3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 03:02:06.6081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oi52Z8KrCJDRNg66ESiRkQOXsscaaujtlsPx1CTdIRSk5w4u44jYATKGHQOJe9vl+KDlt0GZG4prwTdAMrgcfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7607
X-OriginatorOrg: intel.com

--f8HxJDUHT0YS5Psl
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

hi, Yu Kuai,

On Tue, May 21, 2024 at 10:20:54AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2024/05/20 23:01, kernel test robot 写道:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed "mdadm-selftests.07reshape5intr.fail" on:
> > 
> > commit: 18effaab5f57ef44763e537c782f905e06f6c4f5 ("[PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers")
> > url: https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-rearrange-recovery_flage/20240509-093248
> > base: https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git for-next
> > patch link: https://lore.kernel.org/all/20240509011900.2694291-6-yukuai1@huaweicloud.com/
> > patch subject: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers
> > 
> > in testcase: mdadm-selftests
> > version: mdadm-selftests-x86_64-5f41845-1_20240412
> > with following parameters:
> > 
> > 	disk: 1HDD
> > 	test_prefix: 07reshape5intr
> > 
> > 
> > 
> > compiler: gcc-13
> > test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz (Haswell) with 16G memory
> > 
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > 
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202405202204.4e3dc662-oliver.sang@intel.com
> > 
> > 2024-05-14 21:36:26 mkdir -p /var/tmp
> > 2024-05-14 21:36:26 mke2fs -t ext3 -b 4096 -J size=4 -q /dev/sda1
> > 2024-05-14 21:36:57 mount -t ext3 /dev/sda1 /var/tmp
> > sed -e 's/{DEFAULT_METADATA}/1.2/g' \
> > -e 's,{MAP_PATH},/run/mdadm/map,g'  mdadm.8.in > mdadm.8
> > /usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
> > /usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
> > /usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
> > /usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
> > /usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/01-md-raid-creating.rules
> > /usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63-md-raid-arrays.rules
> > /usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/64-md-raid-assembly.rules
> > /usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/udev/rules.d/69-md-clustered-confirm-device.rules
> > /usr/bin/install -D  -m 755 mdadm /sbin/mdadm
> > /usr/bin/install -D  -m 755 mdmon /sbin/mdmon
> > Testing on linux-6.9.0-rc2-00012-g18effaab5f57 kernel
> > /lkp/benchmarks/mdadm-selftests/tests/07reshape5intr... FAILED - see /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for detail
> [root@fedora mdadm]# ./test --dev=loop --tests=07reshape5intr
> test: skipping tests for multipath, which is removed in upstream 6.8+
> kernels
> test: skipping tests for linear, which is removed in upstream 6.8+ kernels
> Testing on linux-6.9.0-rc2-00023-gf092583596a2 kernel
> /root/mdadm/tests/07reshape5intr... FAILED - see /var/tmp/07reshape5intr.log
> and /var/tmp/fail07reshape5intr.log for details
>   (KNOWN BROKEN TEST: always fails)
> 
> So, since this test is marked BROKEN.
> 
> Please share the whole log, and is it possible to share the two logs?


we only captured one log as attached log-18effaab5f.
also attached parent log FYI.


> 
> Thanks,
> Kuai
> 
> > 
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20240520/202405202204.4e3dc662-oliver.sang@intel.com
> > 
> > 
> > 
> 

--f8HxJDUHT0YS5Psl
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="log-18effaab5f"

+ . /lkp/benchmarks/mdadm-selftests/tests/07reshape5intr
++ set -x
++ devs=/dev/loop1
++ st=UU
++ for disks in 2 3 4 5
++ eval 'devs="/dev/loop1' '$dev2"'
+++ devs='/dev/loop1 /dev/loop2'
++ st=UUU
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop1 bs=1024
dd: error writing '/dev/loop1': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.909885 s, 22.5 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop2 bs=1024
dd: error writing '/dev/loop2': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.633683 s, 32.3 MB/s
++ true
++ case $disks in
++ chunk=1024
++ mdadm -CR /dev/md0 -amd -l5 -c 1024 -n2 --assume-clean /dev/loop1 /dev/loop2
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md0 =~ /dev/ ]]
++ [[ /dev/md0 =~ md ]]
++ for args in $*
++ [[ -amd =~ /dev/ ]]
++ for args in $*
++ [[ -l5 =~ /dev/ ]]
++ for args in $*
++ [[ -c =~ /dev/ ]]
++ for args in $*
++ [[ 1024 =~ /dev/ ]]
++ for args in $*
++ [[ -n2 =~ /dev/ ]]
++ for args in $*
++ [[ --assume-clean =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop1 =~ /dev/ ]]
++ [[ /dev/loop1 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop1
mdadm: Unrecognised md component device - /dev/loop1
++ for args in $*
++ [[ /dev/loop2 =~ /dev/ ]]
++ [[ /dev/loop2 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop2
mdadm: Unrecognised md component device - /dev/loop2
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -CR /dev/md0 -amd -l5 -c 1024 -n2 --assume-clean /dev/loop1 /dev/loop2 --auto=yes
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm /dev/md0 --add /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet /dev/md0 --add /dev/loop6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ echo 20
++ echo 20
++ mdadm --grow /dev/md0 -n 3
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --grow /dev/md0 -n 3
++ rv=1
++ case $* in
++ cat /var/tmp/stderr
mdadm: Failed to initiate reshape!
++ return 1
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ '[' 5 -gt 0 ']'
++ grep -v idle /sys/block/md0/md/sync_action
++ die 'no reshape happening'
++ echo -e '\n\tERROR: no reshape happening \n'

	ERROR: no reshape happening 

++ save_log fail
++ status=fail
++ logfile=fail07reshape5intr.log
++ cat /var/tmp/stderr
++ cp /var/tmp/log /var/tmp/07reshape5intr.log
++ echo '## lkp-hsw-d05: saving dmesg.'
++ dmesg -c
++ echo '## lkp-hsw-d05: saving proc mdstat.'
++ cat /proc/mdstat
++ array=($(mdadm -Ds | cut -d' ' -f2))
+++ mdadm -Ds
+++ rm -f /var/tmp/stderr
+++ cut '-d ' -f2
+++ case $* in
+++ case $* in
+++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -Ds
+++ rv=0
+++ case $* in
+++ cat /var/tmp/stderr
+++ return 0
++ '[' fail == fail ']'
++ echo 'FAILED - see /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details'
FAILED - see /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details
++ '[' loop == lvm ']'
++ '[' loop == loop -o loop == disk ']'
++ '[' '!' -z /dev/md0 -a 1 -ge 1 ']'
++ echo '## lkp-hsw-d05: mdadm -D /dev/md0'
++ /lkp/benchmarks/mdadm-selftests/mdadm -D /dev/md0
++ cat /proc/mdstat
++ grep -q 'linear\|external'
++ md_disks=($($mdadm -D -Y ${array[@]} | grep "/dev/" | cut -d'=' -f2))
+++ /lkp/benchmarks/mdadm-selftests/mdadm -D -Y /dev/md0
+++ grep /dev/
+++ cut -d= -f2
++ cat /proc/mdstat
++ grep -q bitmap
++ '[' 1 -eq 0 ']'
++ exit 2

--f8HxJDUHT0YS5Psl
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="log-parent"

+ . /lkp/benchmarks/mdadm-selftests/tests/07reshape5intr
++ set -x
++ devs=/dev/loop1
++ st=UU
++ for disks in 2 3 4 5
++ eval 'devs="/dev/loop1' '$dev2"'
+++ devs='/dev/loop1 /dev/loop2'
++ st=UUU
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop1 bs=1024
dd: error writing '/dev/loop1': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.860819 s, 23.8 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop2 bs=1024
dd: error writing '/dev/loop2': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.648983 s, 31.6 MB/s
++ true
++ case $disks in
++ chunk=1024
++ mdadm -CR /dev/md0 -amd -l5 -c 1024 -n2 --assume-clean /dev/loop1 /dev/loop2
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md0 =~ /dev/ ]]
++ [[ /dev/md0 =~ md ]]
++ for args in $*
++ [[ -amd =~ /dev/ ]]
++ for args in $*
++ [[ -l5 =~ /dev/ ]]
++ for args in $*
++ [[ -c =~ /dev/ ]]
++ for args in $*
++ [[ 1024 =~ /dev/ ]]
++ for args in $*
++ [[ -n2 =~ /dev/ ]]
++ for args in $*
++ [[ --assume-clean =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop1 =~ /dev/ ]]
++ [[ /dev/loop1 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop1
mdadm: Unrecognised md component device - /dev/loop1
++ for args in $*
++ [[ /dev/loop2 =~ /dev/ ]]
++ [[ /dev/loop2 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop2
mdadm: Unrecognised md component device - /dev/loop2
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -CR /dev/md0 -amd -l5 -c 1024 -n2 --assume-clean /dev/loop1 /dev/loop2 --auto=yes
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm /dev/md0 --add /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet /dev/md0 --add /dev/loop6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ echo 20
++ echo 20
++ mdadm --grow /dev/md0 -n 3
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --grow /dev/md0 -n 3
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ '[' 5 -gt 0 ']'
++ grep -v idle /sys/block/md0/md/sync_action
++ sleep 0.5
++ cnt=4
++ grep -sq reshape /proc/mdstat
++ check state UUU
++ case $1 in
++ grep -sq 'blocks.*\[UUU\]$' /proc/mdstat
++ sleep 0.5
++ mdadm --stop /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --stop /dev/md0
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ echo 1000
++ echo 2000
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle /sys/block/md0/md/sync_action
++ echo 2000
++ echo check
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle /sys/block/md0/md/sync_action
++ echo 2000
+++ cat /sys/block/md0/md/mismatch_cnt
++ mm=0
++ '[' 0 -gt 0 ']'
++ mdadm -S /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ udevadm settle
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 20000
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -S /dev/md0
++ rv=0
++ case $* in
++ udevadm settle
++ echo 2000
++ cat /var/tmp/stderr
++ return 0
++ for disks in 2 3 4 5
++ eval 'devs="/dev/loop1' /dev/loop2 '$dev3"'
+++ devs='/dev/loop1 /dev/loop2 /dev/loop3'
++ st=UUUU
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop1 bs=1024
dd: error writing '/dev/loop1': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.430464 s, 47.6 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop2 bs=1024
dd: error writing '/dev/loop2': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.44228 s, 46.3 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop3 bs=1024
dd: error writing '/dev/loop3': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.442369 s, 46.3 MB/s
++ true
++ case $disks in
++ chunk=1024
++ mdadm -CR /dev/md0 -amd -l5 -c 1024 -n3 --assume-clean /dev/loop1 /dev/loop2 /dev/loop3
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md0 =~ /dev/ ]]
++ [[ /dev/md0 =~ md ]]
++ for args in $*
++ [[ -amd =~ /dev/ ]]
++ for args in $*
++ [[ -l5 =~ /dev/ ]]
++ for args in $*
++ [[ -c =~ /dev/ ]]
++ for args in $*
++ [[ 1024 =~ /dev/ ]]
++ for args in $*
++ [[ -n3 =~ /dev/ ]]
++ for args in $*
++ [[ --assume-clean =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop1 =~ /dev/ ]]
++ [[ /dev/loop1 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop1
mdadm: Unrecognised md component device - /dev/loop1
++ for args in $*
++ [[ /dev/loop2 =~ /dev/ ]]
++ [[ /dev/loop2 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop2
mdadm: Unrecognised md component device - /dev/loop2
++ for args in $*
++ [[ /dev/loop3 =~ /dev/ ]]
++ [[ /dev/loop3 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop3
mdadm: Unrecognised md component device - /dev/loop3
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -CR /dev/md0 -amd -l5 -c 1024 -n3 --assume-clean /dev/loop1 /dev/loop2 /dev/loop3 --auto=yes
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm /dev/md0 --add /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet /dev/md0 --add /dev/loop6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ echo 20
++ echo 20
++ mdadm --grow /dev/md0 -n 4
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --grow /dev/md0 -n 4
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
mdadm: Need to backup 6144K of critical section..
++ return 0
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ '[' 5 -gt 0 ']'
++ grep -v idle /sys/block/md0/md/sync_action
++ sleep 0.5
++ cnt=4
++ grep -sq reshape /proc/mdstat
++ check state UUUU
++ case $1 in
++ grep -sq 'blocks.*\[UUUU\]$' /proc/mdstat
++ sleep 0.5
++ mdadm --stop /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --stop /dev/md0
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ echo 1000
++ echo 2000
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle /sys/block/md0/md/sync_action
++ echo 2000
++ echo check
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle /sys/block/md0/md/sync_action
++ echo 2000
+++ cat /sys/block/md0/md/mismatch_cnt
++ mm=0
++ '[' 0 -gt 0 ']'
++ mdadm -S /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ udevadm settle
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 20000
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -S /dev/md0
++ rv=0
++ case $* in
++ udevadm settle
++ echo 2000
++ cat /var/tmp/stderr
++ return 0
++ for disks in 2 3 4 5
++ eval 'devs="/dev/loop1' /dev/loop2 /dev/loop3 '$dev4"'
+++ devs='/dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4'
++ st=UUUUU
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop1 bs=1024
dd: error writing '/dev/loop1': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.406947 s, 50.3 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop2 bs=1024
dd: error writing '/dev/loop2': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.415534 s, 49.3 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop3 bs=1024
dd: error writing '/dev/loop3': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.474736 s, 43.1 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop4 bs=1024
dd: error writing '/dev/loop4': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.467228 s, 43.8 MB/s
++ true
++ case $disks in
++ chunk=512
++ mdadm -CR /dev/md0 -amd -l5 -c 512 -n4 --assume-clean /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md0 =~ /dev/ ]]
++ [[ /dev/md0 =~ md ]]
++ for args in $*
++ [[ -amd =~ /dev/ ]]
++ for args in $*
++ [[ -l5 =~ /dev/ ]]
++ for args in $*
++ [[ -c =~ /dev/ ]]
++ for args in $*
++ [[ 512 =~ /dev/ ]]
++ for args in $*
++ [[ -n4 =~ /dev/ ]]
++ for args in $*
++ [[ --assume-clean =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop1 =~ /dev/ ]]
++ [[ /dev/loop1 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop1
mdadm: Unrecognised md component device - /dev/loop1
++ for args in $*
++ [[ /dev/loop2 =~ /dev/ ]]
++ [[ /dev/loop2 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop2
mdadm: Unrecognised md component device - /dev/loop2
++ for args in $*
++ [[ /dev/loop3 =~ /dev/ ]]
++ [[ /dev/loop3 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop3
mdadm: Unrecognised md component device - /dev/loop3
++ for args in $*
++ [[ /dev/loop4 =~ /dev/ ]]
++ [[ /dev/loop4 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop4
mdadm: Unrecognised md component device - /dev/loop4
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -CR /dev/md0 -amd -l5 -c 512 -n4 --assume-clean /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 --auto=yes
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm /dev/md0 --add /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet /dev/md0 --add /dev/loop6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ echo 20
++ echo 20
++ mdadm --grow /dev/md0 -n 5
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --grow /dev/md0 -n 5
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
mdadm: Need to backup 6144K of critical section..
++ return 0
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ '[' 5 -gt 0 ']'
++ grep -v idle /sys/block/md0/md/sync_action
++ sleep 0.5
++ cnt=4
++ grep -sq reshape /proc/mdstat
++ check state UUUUU
++ case $1 in
++ grep -sq 'blocks.*\[UUUUU\]$' /proc/mdstat
++ sleep 0.5
++ mdadm --stop /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --stop /dev/md0
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ echo 1000
++ echo 2000
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle /sys/block/md0/md/sync_action
++ echo 2000
++ echo check
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle /sys/block/md0/md/sync_action
++ echo 2000
+++ cat /sys/block/md0/md/mismatch_cnt
++ mm=0
++ '[' 0 -gt 0 ']'
++ mdadm -S /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ udevadm settle
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 20000
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -S /dev/md0
++ rv=0
++ case $* in
++ udevadm settle
++ echo 2000
++ cat /var/tmp/stderr
++ return 0
++ for disks in 2 3 4 5
++ eval 'devs="/dev/loop1' /dev/loop2 /dev/loop3 /dev/loop4 '$dev5"'
+++ devs='/dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5'
++ st=UUUUUU
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop1 bs=1024
dd: error writing '/dev/loop1': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.579398 s, 35.3 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop2 bs=1024
dd: error writing '/dev/loop2': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.459501 s, 44.6 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop3 bs=1024
dd: error writing '/dev/loop3': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.460076 s, 44.5 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop4 bs=1024
dd: error writing '/dev/loop4': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.468438 s, 43.7 MB/s
++ true
++ for d in $devs
++ dd if=/dev/urandom of=/dev/loop5 bs=1024
dd: error writing '/dev/loop5': No space left on device
20001+0 records in
20000+0 records out
20480000 bytes (20 MB, 20 MiB) copied, 0.443522 s, 46.2 MB/s
++ true
++ case $disks in
++ chunk=256
++ mdadm -CR /dev/md0 -amd -l5 -c 256 -n5 --assume-clean /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md0 =~ /dev/ ]]
++ [[ /dev/md0 =~ md ]]
++ for args in $*
++ [[ -amd =~ /dev/ ]]
++ for args in $*
++ [[ -l5 =~ /dev/ ]]
++ for args in $*
++ [[ -c =~ /dev/ ]]
++ for args in $*
++ [[ 256 =~ /dev/ ]]
++ for args in $*
++ [[ -n5 =~ /dev/ ]]
++ for args in $*
++ [[ --assume-clean =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop1 =~ /dev/ ]]
++ [[ /dev/loop1 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop1
mdadm: Unrecognised md component device - /dev/loop1
++ for args in $*
++ [[ /dev/loop2 =~ /dev/ ]]
++ [[ /dev/loop2 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop2
mdadm: Unrecognised md component device - /dev/loop2
++ for args in $*
++ [[ /dev/loop3 =~ /dev/ ]]
++ [[ /dev/loop3 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop3
mdadm: Unrecognised md component device - /dev/loop3
++ for args in $*
++ [[ /dev/loop4 =~ /dev/ ]]
++ [[ /dev/loop4 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop4
mdadm: Unrecognised md component device - /dev/loop4
++ for args in $*
++ [[ /dev/loop5 =~ /dev/ ]]
++ [[ /dev/loop5 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop5
mdadm: Unrecognised md component device - /dev/loop5
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -CR /dev/md0 -amd -l5 -c 256 -n5 --assume-clean /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 --auto=yes
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm /dev/md0 --add /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet /dev/md0 --add /dev/loop6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ echo 20
++ echo 20
++ mdadm --grow /dev/md0 -n 6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --grow /dev/md0 -n 6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
mdadm: Need to backup 5120K of critical section..
++ return 0
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ '[' 5 -gt 0 ']'
++ grep -v idle /sys/block/md0/md/sync_action
++ sleep 0.5
++ cnt=4
++ grep -sq reshape /proc/mdstat
++ check state UUUUUU
++ case $1 in
++ grep -sq 'blocks.*\[UUUUUU\]$' /proc/mdstat
++ sleep 0.5
++ mdadm --stop /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --stop /dev/md0
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ mdadm --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet --assemble /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6
mdadm: restoring critical section
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ check reshape
++ case $1 in
++ cnt=5
++ grep -sq reshape /proc/mdstat
++ echo 1000
++ echo 2000
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle /sys/block/md0/md/sync_action
++ echo 2000
++ echo check
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ sleep 0.5
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle /sys/block/md0/md/sync_action
++ echo 2000
+++ cat /sys/block/md0/md/mismatch_cnt
++ mm=0
++ '[' 0 -gt 0 ']'
++ mdadm -S /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ udevadm settle
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 20000
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -S /dev/md0
++ rv=0
++ case $* in
++ udevadm settle
++ echo 2000
++ cat /var/tmp/stderr
++ return 0

--f8HxJDUHT0YS5Psl--
