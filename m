Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2114.outbound.protection.outlook.com [40.107.22.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BF53D68
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 13:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731935960; cv=fail; b=cHjarz5PvueP9zia4zHmfeqoKQ1vTtmkIi2rl+Z6dTjzpp5m0s0cgIgHeTtQ8Ou8WcJ40mGrwzjjmfLwlomR8xNKmo1Q9LqM9+YBuOtvCYP0BdqF73GF19asgDbwXBEPcQ3282EDfFqrfR/B0Rj8okMBWiZ+HsDKWCJ+ym8MTC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731935960; c=relaxed/simple;
	bh=WMn1Z1w4Z7ToEpseJhUHNzfM2kVdMfcIE6MqSrS24xs=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KYv6bRqwPnUnfSaTJSuGngjD4tih8xM4mxyJSe0Av4q5IH9eOtwa6I5HQhdNYjofkbe0Jc4BuCJBJZPZTQK3twm1UsauJPjgl2/93JdlcGsbrVHmL01QsHAC5WZfYOeqWJm8YhD5QMrYL/q4oR/CO8i+1Mn8gbr35ox5Jr400n0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=jvBz6VF4; arc=fail smtp.client-ip=40.107.22.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="jvBz6VF4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UbHShqzISaLrpeH4Ifxhn270N0sF5IpU++9NJrXynD77V0Qsi/AbYzhKGr0JQo4WhqS0dsXowSrlrc2W/N/Cc7FyWEorNvwv3Kvq7e7kL58p+ITMj3/+9JQRo8gKvZV2Ez31YzQmBbFGjXJVjrVj+NDx7i7eJ9Dnc2vkLInwI8m1JTJCohroaShVCUOgW2MKSltUHtTVwq0M3MEiJFsR3LacaMKmcomE40jb0WoUIgx44UPHYeSiVolAO9crDstitfn9leLoXcDpCEdPfMgIhJI2RzPeflX+m6kGnUndOGDq+udL+G44CjvIAN6Ek1UB7p4xuICxqrYWCrFL6LncKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWTmauqaDTm/nEVvlGYGGycYrJWYomIka8YUwe+fTww=;
 b=KCAwI2+6qQpPzWwfcbDTG29yiVUIF4Qd52rY76TFO3pRfwCytv6xxt91EnFQXbSeIPwkZjzXGS5zQi5kN6P9pm2vt8GHY6WCxfe5kw9+nrbzc09V9F3x12I1xKNhfQArmfpfMRIb1rOrSO8zYrOqnMsu8L5Vgh45+ZzjnA0H46Tc78VbyBiaWA5iFsyO6DSEJ28zokvmGbYSyPSxIJfVynRj2uT0lSL5WBpsMgDmSBRMPfLkNR1BhQzbCI8VyYR37ZMnLvKbr+QuZMpsGa9nHh0QVFVvH38T90k65b4na71kBY1TdbR9TzY2KSlN48uioVzHEpM9v1MSSFN1z7fNTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWTmauqaDTm/nEVvlGYGGycYrJWYomIka8YUwe+fTww=;
 b=jvBz6VF4ElweVJHJVibhRWmOf7uOiziJ9ksjjiIPJxIgWyw+R77E1hFWgBLIvFlYorD4kVWLu5DPSt3rczEdf8jz686Kd7gSlpDoGF5ZSuisf8GpGKV/QD31XUfF1x4dvpcGuypSOhuQ2uzt6K+X+BNnXKAxd9fqA3HUVO6uGA54sCYfuEu7mL+eJZJ0FOp6tCIZMwoFeMYG08uAWINHHc2OJYkA0QXrr5a6feObLumGRRqUdvetr0G2yJhMb2yW5r3cVxTcP/Ycm1it52CxoL/mIKtU1u8fnXAGkNSlCPKePmYnRj3EtKc+mJWX+YOfdImM9ci7IdUpMcOjttd7Xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from VI1PR04MB4958.eurprd04.prod.outlook.com (2603:10a6:803:60::23)
 by AM8PR04MB7348.eurprd04.prod.outlook.com (2603:10a6:20b:1db::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Mon, 18 Nov
 2024 13:19:14 +0000
Received: from VI1PR04MB4958.eurprd04.prod.outlook.com
 ([fe80::27d0:585e:6f58:e194]) by VI1PR04MB4958.eurprd04.prod.outlook.com
 ([fe80::27d0:585e:6f58:e194%6]) with mapi id 15.20.8158.021; Mon, 18 Nov 2024
 13:19:14 +0000
Message-ID: <420a99f1-c076-4a91-8b5f-80ac9be27c7c@volumez.com>
Date: Mon, 18 Nov 2024 15:19:11 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/persistent-data: Set tm hash size via a module_param
From: Meir Elisha <meir.elisha@volumez.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <20241014134944.1264991-1-meir.elisha@volumez.com>
Content-Language: en-US
In-Reply-To: <20241014134944.1264991-1-meir.elisha@volumez.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0014.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::13) To VI1PR04MB4958.eurprd04.prod.outlook.com
 (2603:10a6:803:60::23)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB4958:EE_|AM8PR04MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: 5502bcca-baa2-493e-1966-08dd07d39901
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmtFczZySlAvbTIwUU41UzcyNUk3blVKOG50N3NDZzF2b3YxMWt3UmNRZjh4?=
 =?utf-8?B?SGx3S1FKWHFzK0xIbVpNZ2xCNFVHQ1pEZWlhMzduMHZLZ0xnbTBRY2dSK0Zp?=
 =?utf-8?B?UFpRcFNYKzBjWFExVTZOd3hjaTFwYmE5YXhyc3pheG85MjZYd2pKVXpVK3hk?=
 =?utf-8?B?VVRxVkR6Q0hWa1FBODNlSHZBSDBRUjVZOVRWN2RHS3d2NUdlMnlnbFU3VGhV?=
 =?utf-8?B?OEhMbDNwd01FNjRSemN3VzR5MS8vUnJSc2FkOEdzSDlFN0NNblkrRFcrWmlR?=
 =?utf-8?B?Q0VycmZaWklNbi9YZys2eTF3T1AzWmNwQlgzM0VLbERiV25HSkc3Y09LTUQ5?=
 =?utf-8?B?dElHZFZqdTFFeHNNM2lyblRsYlY3NDlrTWxsQkg3aGNvVjIybFRjRXYwR0hE?=
 =?utf-8?B?TDVyWFMxU0FtM2JpN3VWR29QMXZDbWg3N3NCNUEzdWk0N1lYa0hIUlh1MTh4?=
 =?utf-8?B?MFkxYlVtL2xJeXFZd3djc3h5Tyt3MG51MzUyNktLVnEydk1KVDgxSWJ2Q3h0?=
 =?utf-8?B?YlUyRlNDYUdHdURnQ3hEblJSK2wvcU9mZ1Y0U3Bhb3pmV0QwSEZReDE2MDJG?=
 =?utf-8?B?aDNZWlhFUzVVL3BzWHJZazlwUlgybWk2NTRpNFIwUi95a0FLSlVoT0M2d1Jl?=
 =?utf-8?B?cmRpdWczQzg0MEFMSUtwVC85d1hUMldjSjE2blpUcnNVb1JDZ3NZMklpckVu?=
 =?utf-8?B?bURIRW1jQXJVSFhQOWViR0dOOU4zcjdMaGd6YW9PNVk5eXdSY1c2MHZvWHNL?=
 =?utf-8?B?b25jM0liVGRPb0FCdVlpM0t2bXR3UVpVc0o0OUxxKzgrbTRhWDZ5bEVVMU9r?=
 =?utf-8?B?dTdDWXRqTHFrQ2hNUnVqaVU4YTRETFZBMXBVb1g1Vy9FMHQvVnUwZDhYTnNP?=
 =?utf-8?B?czRCYmxjRkVIQ1R1eW85L3kySnlXMDU2aWhlZGhrektzaHBZeXErVjM0L0xH?=
 =?utf-8?B?YVNJOW9FOEJ0blBzQitBYTBVYlB4dTNzbEtPZDRtYmREZkdiU1VrdTZ4azFh?=
 =?utf-8?B?aW9NOTkxdjN1bHVsTGUxanZwREFhUXFQOGNNNHhzSmRFcmlab3VSTmM5YnFm?=
 =?utf-8?B?SUhHOU91d1JLcVIrcWlrc0dPWnZZdzRQREtlYTYwMFI2ZzZNZTlMa2U4dHE4?=
 =?utf-8?B?akRsTDBSTUl0V010ZENlTmU1Uklhak5tdVpFWE9UWHhRbnAyR0ZIZmJtV1NF?=
 =?utf-8?B?SEwwbFhacDJJOWJGVTN4UFpoUTV2T3o4UlhjbDlKNVBBY05Kb1B1LzZTRnp5?=
 =?utf-8?B?dkU2aWpQWEZ6RmJYYzIrMllDOWhRVTNWS2ViR3Baa0FIV3FsaUNCalZyRlBl?=
 =?utf-8?B?anJja3pPZnBQaVZHb2o3cC8xLzVjSll6VWhKTDZFbDZOQ3hqNCtDQnNGR3E0?=
 =?utf-8?B?ZUxPTXlmaFU2QVJXczNzK3NmWjNYMytZd3dPWlRCdDBTMmNBVEtoTm9jNWJW?=
 =?utf-8?B?Sm9EMk1oQ3I4dVpKWTR0VWpENmJ0bkNpeVdENDl6U0FhUWtvQjBkNnN5c1Js?=
 =?utf-8?B?c2xtWHNubjhuditFaS9Wb0lEamtQY1lOUytLc1J1VkpBZHI1MUVRR1NWQXIx?=
 =?utf-8?B?UDdoTE9palp6RzlhcmJPNFZlWHl1KzRkNU1rTjE5dms3U1hidWNxakt3Vnk3?=
 =?utf-8?B?NHRDRnFTRDZsd0s3T0UrdVVCcXpyWjNzYmJ0OTVOZTNURmRIRlRUTDJuT0dW?=
 =?utf-8?B?U0grYmlMTUs0dzJJSlIwbzgvamZIM0xTcG1mRHdoZ2Z3cWovRWhHM0FiZUZi?=
 =?utf-8?Q?oUQ2jdf1+Ftgj++kzl0cv5/gTdQQOG+/3x5tn/0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4958.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alZ4WG1sZDJla1lIT2EwSjgxL1RIRVUrenY5VElpSlJSWm82b3VRRll0Slda?=
 =?utf-8?B?TklhTFlyem01Qi9NL25tVTFlem5QV3gxcUsyTG9wWlA5NFdybWZQSERJREVs?=
 =?utf-8?B?VTVXb0RHRjRTOEcrKzRONUUwSXR4UDhtVXJCZXoxUHNxTERYdmZnV0U5WU4w?=
 =?utf-8?B?K2gzeE94T1NJbUM0b0FXSW8rNkxtaHZKeWQ3VHNCbjVSVXpXazJEZGNFQ21q?=
 =?utf-8?B?SVU4cHFSM2xKK3dYWjN0WjM0eFI1RnlTTWZKSWFLRVJyQlhSSHJmMHpxdnFX?=
 =?utf-8?B?MTlhUzlIOXppVEpSekdXM2tReEJieG5mN0cva1daRGIxVHFnVW9EZ3JXV1Bz?=
 =?utf-8?B?MStMMlFacE0zWnJtV1ZhYnpvbENFaFdxNFhWdlVXcjdSOGoyMHFrVWk1aUxx?=
 =?utf-8?B?elR6UTM0emZiTVUwdWtMSkZSeXk5U0R0WDl5Rm5oWGw3L0s0ZHFOUUdMdjNz?=
 =?utf-8?B?YWtoeDlFK1FMUlp1cklmQmQ4ZTZVL0JwMHRWQTE1UU1qSU5LMWpuOVpzL05F?=
 =?utf-8?B?dlZPYldNOUFOK1JkV3owZ3dzU05yVjVtVG9jMk1Ka1JJMGxRaEpMYkhIaWkx?=
 =?utf-8?B?RmhBTENwSEJQK1JEZHllendTd092L2NwbU91OFJoRmxHTGVCcEUxTkxUUnFM?=
 =?utf-8?B?eGw5dmRYdnlOZXZzT2RZY1NKZndacExnM0FYakFia0F2SytiMVp4Y3lQN0JY?=
 =?utf-8?B?K1F5R080YklTalVRcHR6MnBOUnE3Ujg0M0V2b1lHeXVVWitCZmcwMmx5Y0pj?=
 =?utf-8?B?Q1dQQWpRekRCQURpY2xSb0dLbEFpeWI4R04vUGJMK0wrRzZNcElvUk9BNDdQ?=
 =?utf-8?B?ZDFUcHFPMUtmQUgxeWd1OG1TR21TdStlTExLMDNzeWhCUWx5UnR1bGRxYW9a?=
 =?utf-8?B?UWlhNDM5YU16VUR6VWw3aE5DZTBkOU9VOGFvRmdqeXEvdzZndEhKVThjRm1v?=
 =?utf-8?B?K0tDb0twMXNZa0pNUklqUTVUUHpsaEdDSHBJZWNUU2Z5NktwVE1vSlh2ekFo?=
 =?utf-8?B?YVhZN2gxeE8xOXcyYlA0U056eVFyc3FIM0ZmeEdXNFdlV0lSd29BQnlQU3RT?=
 =?utf-8?B?bVJOc3k3YUw2T2YwZHZHU0NZckJ6MlpHWmx2Z2I3dC9tV1BQMWVFUUZVdTlh?=
 =?utf-8?B?a1Z2aFp3a3V0SUtnK3E2KzVzN0o4QUluOWVJbkVNS05zVVVLaWNuSUVQajlp?=
 =?utf-8?B?Tm9BNkRVNFRNbWw5cDNrUXNUdEdRV3ZnWkdXMlhvTzFSczRiYTJaZ3pzU0Ry?=
 =?utf-8?B?UkYrbjZzQnJKTmxSbGNDdG1zQ01HOXIxYkpxQmdiaWpUUFU1TVhUUlZRbTVp?=
 =?utf-8?B?a3JKa0RDbUFzR2UrbFpTcEozMTM1a1pCTTVRNzdESG9mYTh5VmlHUE96S2JX?=
 =?utf-8?B?Mm9LOTlKc0lXbk5QMmVGMWhGWG0vd2txL0tUeUIzckt6S3hRQ1V1bkVyVktC?=
 =?utf-8?B?anF1VlcvWnY3ZTJVeFROQWEvSW9zSXpGWlhwd0NsZGJuVUdNWEJlcXNFb1VZ?=
 =?utf-8?B?ZWdjQWx5Z2R0RG1zenhFVWFCcFlMQmtldVBUOFNmajkwWGltdHUvVkFwKzhr?=
 =?utf-8?B?ZFlpNkxWdjlpcWtRZ1FidlNDZVo4RGFWeHZ0UUg4bkRGNHVTNzhlQk5ycW5l?=
 =?utf-8?B?NSswdDhLUjV6NHV0VXk1VHpKUWdhZVAyQWFwcllIZDF0Q3piOXJ4RnpKbTZv?=
 =?utf-8?B?cEs5NU4wSmsyMTBRYm9tQTlHUDR0YWJSaW5GaXhkc2FiWGpIcjZxdVI2SXhR?=
 =?utf-8?B?Um9abGgrL29HNTF1VnFSSGhGWHNaTEdVbmhIUTNxQ3NGWndmZXpZZUdjV2xp?=
 =?utf-8?B?dk5pUVNqZnhjVkdoOHoyZFphbURTQkRXWTRpYURCcG1EdlBKOGk5NG0xU0c0?=
 =?utf-8?B?a2xQMnFxQkpJamNQa0R1OVBrb2hRVUFzeStwek8rN2ZSemFGblJ4YVA0c0xP?=
 =?utf-8?B?TFBYdlkzb2g4bEtwcitXRFVEYnpZUERDVysxQ2dsU1huWGRPb3JQTG5pQUlE?=
 =?utf-8?B?SERialVoWk1vVEFuLzBDdjd4VkJxejVNb3dGbDhreWVHYXlHUmhlTG1UWnBk?=
 =?utf-8?B?c1ozZW1iUjVJU3pRZlZXV0VCVkhQbjV6WFl2dUdqYS9YS0s4K0FvdnlWU0xj?=
 =?utf-8?B?bzFtdEZEYWdiUGo0QnUxMmU2ZjF3bGlXM25VVXQyU0dvbk5rZG8yQklTU2RL?=
 =?utf-8?B?aXc9PQ==?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5502bcca-baa2-493e-1966-08dd07d39901
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4958.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 13:19:14.4634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: weFeUeVG68BUEDaN7V4o9i46vIBD0FSDHc72r+AsOw9l1R4THNO3YB5rsppBZaoqqs6f8/08NqEItCvGFjPLzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7348



On 10/14/24 16:49, Meir Elisha wrote:
> Enlarging the hash table size can significantly improve transaction
> manager hash operations. This commit adds the tm_hash_table_size
> module_param that sets the hash size.
> 
> For demonstration, I've created a thin volume, filled it with 4.8TiB of
> sequential data and took a snapshot. then, I overwritten the volume in a
> way that caused a maximum btree nodes to be allocated. I've repeated the
> process for 5 snapshots and measured the first snapshot deletion time.
> 
> When using 128k hash size (instead of the 256 default value) I was able
> to reduce snapshot deletion time from 42min to 4min (10x improvement).
> 
> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
> ---
> 
> Script used for demonstration attached below.
> 
>  .../persistent-data/dm-transaction-manager.c  | 51 ++++++++++++++++---
>  1 file changed, 43 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
> index c7ba4e6cbbc7..8d486b1e6693 100644
> --- a/drivers/md/persistent-data/dm-transaction-manager.c
> +++ b/drivers/md/persistent-data/dm-transaction-manager.c
> @@ -10,6 +10,7 @@
>  #include "dm-space-map-metadata.h"
>  #include "dm-persistent-data-internal.h"
>  
> +#include <linux/moduleparam.h>
>  #include <linux/export.h>
>  #include <linux/mutex.h>
>  #include <linux/hash.h>
> @@ -84,8 +85,35 @@ struct shadow_info {
>  /*
>   * It would be nice if we scaled with the size of transaction.
>   */
> -#define DM_HASH_SIZE 256
> -#define DM_HASH_MASK (DM_HASH_SIZE - 1)
> +static uint tm_hash_table_size = 256;
> +
> +static int param_set_hash_size(const char *val, const struct kernel_param *kp)
> +{
> +	unsigned int num;
> +	int ret;
> +
> +	if (!val)
> +		return -EINVAL;
> +
> +	ret = kstrtouint(val, 0, &num);
> +	if (ret)
> +		return ret;
> +
> +	/* Hash size must be a power of 2 */
> +	if (!(num && !(num & (num - 1))))
> +		return -EINVAL;
> +
> +	*((unsigned int *)kp->arg) = num;
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops tm_hash_table_size_ops = {
> +	.set = param_set_hash_size,
> +	.get = param_get_uint
> +};
> +
> +module_param_cb(tm_hash_table_size, &tm_hash_table_size_ops, &tm_hash_table_size, 0644);
> +MODULE_PARM_DESC(tm_hash_table_size, "transaction manager hash size");
>  
>  struct dm_transaction_manager {
>  	int is_clone;
> @@ -95,8 +123,9 @@ struct dm_transaction_manager {
>  	struct dm_space_map *sm;
>  
>  	spinlock_t lock;
> -	struct hlist_head buckets[DM_HASH_SIZE];
> -
> +	struct hlist_head *buckets;
> +	uint hash_size;
> +	uint hash_mask;
>  	struct prefetch_set prefetches;
>  };
>  
> @@ -105,7 +134,7 @@ struct dm_transaction_manager {
>  static int is_shadow(struct dm_transaction_manager *tm, dm_block_t b)
>  {
>  	int r = 0;
> -	unsigned int bucket = dm_hash_block(b, DM_HASH_MASK);
> +	unsigned int bucket = dm_hash_block(b, tm->hash_mask);
>  	struct shadow_info *si;
>  
>  	spin_lock(&tm->lock);
> @@ -131,7 +160,7 @@ static void insert_shadow(struct dm_transaction_manager *tm, dm_block_t b)
>  	si = kmalloc(sizeof(*si), GFP_NOIO);
>  	if (si) {
>  		si->where = b;
> -		bucket = dm_hash_block(b, DM_HASH_MASK);
> +		bucket = dm_hash_block(b, tm->hash_mask);
>  		spin_lock(&tm->lock);
>  		hlist_add_head(&si->hlist, tm->buckets + bucket);
>  		spin_unlock(&tm->lock);
> @@ -146,7 +175,7 @@ static void wipe_shadow_table(struct dm_transaction_manager *tm)
>  	int i;
>  
>  	spin_lock(&tm->lock);
> -	for (i = 0; i < DM_HASH_SIZE; i++) {
> +	for (i = 0; i < tm->hash_size; i++) {
>  		bucket = tm->buckets + i;
>  		hlist_for_each_entry_safe(si, tmp, bucket, hlist)
>  			kfree(si);
> @@ -169,13 +198,19 @@ static struct dm_transaction_manager *dm_tm_create(struct dm_block_manager *bm,
>  	if (!tm)
>  		return ERR_PTR(-ENOMEM);
>  
> +	tm->hash_size = tm_hash_table_size;
> +	tm->buckets = kmalloc_array(tm->hash_size, sizeof(*tm->buckets), GFP_KERNEL);
> +	if (!tm->buckets)
> +		return ERR_PTR(-ENOMEM);
> +
>  	tm->is_clone = 0;
>  	tm->real = NULL;
>  	tm->bm = bm;
>  	tm->sm = sm;
> +	tm->hash_mask = tm->hash_size - 1;
>  
>  	spin_lock_init(&tm->lock);
> -	for (i = 0; i < DM_HASH_SIZE; i++)
> +	for (i = 0; i < tm->hash_size; i++)
>  		INIT_HLIST_HEAD(tm->buckets + i);
>  
>  	prefetch_init(&tm->prefetches);

Hi all,

I wanted to follow up on this patch. 
Could you please review it when you have a chance?
If you need any additional information or have concerns, let me know.
Thanks for your time.
