Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010027.outbound.protection.outlook.com [52.101.128.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D707082C
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 07:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732520630; cv=fail; b=iuIVM6Dyu7tdWIi2ISdbDVkXzr8hf126uYaWXKdpgXisXpnB8aPlc9V/ge1zOaSN4oPdFwxF/hjF5j9obtR3UyOIJsxOlFbl7Llf6ket+uAXraOnqjlzTZyZ3NLWAQKlrl+KKhH9dDFWX+jtwuiGQTqji2pfwdM1EQ5kCsxlFBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732520630; c=relaxed/simple;
	bh=oaSV10N2GVp59TNSH6KxH/8K1mixkDFgqWZZ1KqbCeQ=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lrDVdwYt4vJ2IXOkF6NceL/PU+xD2YCwDGCNfXkko3xOke2BY/wU8Pf1nHQRzwPxIFYEJwal5YWrJ4UKhmCl8aNuP71SGTiLvJcWr/HdSE3uXSwXTHDeJLr9BcjLmkUv5guVsPW934SH/XWFGdu13/3VnXHT2WcFFMhm4WaPETA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=CDflRN2H; arc=fail smtp.client-ip=52.101.128.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="CDflRN2H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QeMTIIPYuzqbHK7sYQS9OS9kZqt95T5xfE+pikup+jA8Hzfm1F3TZgg4VaxVTDgr0oRcH9FrmPqxDjL8ARuCwVzOTRV8IznexZFkFNcROhitsKKLgnYLiurP7MylHJEKyueEqrqvb5jcSbR/LgpjnpdEfN/a2abAccTDRH+g7hp12QfoVbYGgaT2VhQP+wKaehqAoxyze8I7Y/rE9nqgMhv/bJ6mgj0+8yV3XUjMl2es1mWTmYsnykzCv+M9xeaD7se0ElgUnDFfr34/gEDpMWse2zlMESnjZiZS0fD1e6JKtQsQA2Fq3V/NWXwV5Sb3dotB4kx/157niUAGMXd6BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ap87CxKr6kEke/K/DkD9BzFN8sdDQcA6UWXO4jFSMPc=;
 b=vuYPT9SAi4rTW8Z0e61SK6zcxvdNEHqVTLdfuW//7rr4P0fimhGve0KxGmQ0n+urhmzirkvYwzJtoFkOCbioOqU6qDdoPkPJ2CdU5uUoISqXdygduVdQ8hNSgyeUsJKEoAT+yA4qlVz1e3qXiNJaez/sEPaUuldzLUxbgW12Cg+OckR6PzpnKnRpfOjaX2CvXpD/s6Z30ux8KCBXuP8DSYSmZ61dDf5gTXg8SIO/I0QWO4OZ+t+scc9Z8H9QDNES/LJnd81SQS6MjfiIZYL74Zm8Hx88eaHRYPrZNvomsc5ELpxd/hnA3JLH5WL6Wa7oEyOEovIhctsjmaHAKJr0pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ap87CxKr6kEke/K/DkD9BzFN8sdDQcA6UWXO4jFSMPc=;
 b=CDflRN2H3lvOEDu0SYThcGwmOiOdG8zt/oueWKRfdtoj6R9jvg9zQQNUTQ8na+ZwmMPhC7V7YFos+vDgCH5h2kpRykxoOnynPxcbFCRrteKihVykRLi+YjTO1CdK9yoQaZxTgUJcRdnT8BjK/jpIOyOo1LKIIgPujza9n1rzDzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by JH0PR02MB6869.apcprd02.prod.outlook.com (2603:1096:990:53::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Mon, 25 Nov
 2024 07:43:43 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%3]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 07:43:41 +0000
Message-ID: <94e8977e-647c-4d6c-bfc0-ad32b513596a@oppo.com>
Date: Mon, 25 Nov 2024 15:43:38 +0800
User-Agent: Mozilla Thunderbird
From: LongPing Wei <weilongping@oppo.com>
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
To: Christoph Hellwig <hch@infradead.org>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "dlemoal@kernel.org" <dlemoal@kernel.org>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "ebiggers@google.com" <ebiggers@google.com>
References: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
 <Z0QSqndKs1fyiOmJ@infradead.org>
In-Reply-To: <Z0QSqndKs1fyiOmJ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|JH0PR02MB6869:EE_
X-MS-Office365-Filtering-Correlation-Id: f9856825-0246-4381-9b42-08dd0d24e1b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZC94VWhKY1c0L3cvS3FnRTdjMWNyWE9DUk5NWGNmUS9Ib1hFK3hsNnVvTm5E?=
 =?utf-8?B?S3YxVXFoMDBrMGJvWkx3T3UvK1RNelU0RWZOKzNCM3dISmZkbngvTkNablI5?=
 =?utf-8?B?U3ZrL0w2Y28wOXdURUVkQlZzcGN2UGFTWE1NbnRFQ1NhMW5lZDJTNS9iUVpy?=
 =?utf-8?B?b1Z2U1YyZnlJLzJLOVhPSkJtV0w2QmhvZGR1Rk5BVS9ObWUzeW5KVks0aGVU?=
 =?utf-8?B?NSswK1dINTVjMHRyUnRGZ3lUajRMZkxuVWJEM3FiTlpRWWFVcFgySmpNRGVp?=
 =?utf-8?B?akk1Sm43SHd0YmhMMThsTk5mZGx4cnNKeElobjdpSzd6aEFiL2VrdURZOEk5?=
 =?utf-8?B?ZWJKNFRSZWNlMFJNSEdwai9HU21MNndHQmtxZHNVMkVzdFVjNVVZRk85dHhi?=
 =?utf-8?B?VGJlODZnSmk0eTdhMFEvNklqVWViYzFaQzFpRFM1VFlGaktMa1IreGlXZXVr?=
 =?utf-8?B?RC82dnRVdU9kNWUrNVhzckRQSmNtd0ZJK3lGLzQ1L1FTaUx3MkE1V0MvS1lE?=
 =?utf-8?B?eFBDdzlVSEVaTzYzUFBJY2ROY1pON29Fb3VZNENpMGxDQU9nUVFCYUdpcGw0?=
 =?utf-8?B?a1Y4WnF4WFpadmV6TEUxVzB1dTFQeU9pbUUwWTRBa2pjdWZaYTRXSWJXL1VK?=
 =?utf-8?B?THN3eUZWRU0rNTB5cFlTR1c4emxSZFRnZ05yaWFhU085eFJSUEVKZ1R0bUlD?=
 =?utf-8?B?VlpJbWpVbFJaUitFWUpYb2FRT3AwSmVWQkVUTjRLRnY1bi9aTWtreW9MTjI4?=
 =?utf-8?B?bkJqNDhycGwwdnlxaVpCYnVMQ25ZWlhoRFlyeWkvbWlhQTBpeE56TE9XK3lH?=
 =?utf-8?B?R2hSeGNRajI4MzhBZnoxSFpHM1c3d0t4cTNZZ0VnLzV2NGE3RzBURll6aldV?=
 =?utf-8?B?N0RacWEvSGNjUGVWM0R3VW5ReE9GUUMwdmJOMEJ5N3ljZWxYcEh6ZmhxZ29S?=
 =?utf-8?B?WWdBNGRPbHFuSUxEMzd1NWtINFAvamROS2NhZUFnMjIzN0UrQnA0TFc5b0RJ?=
 =?utf-8?B?WGoxZFZjeXhpNmN2b1NLeDdlczlEcjQ4UUpLeldPb0ZkUkFHbFlQV29KZXBv?=
 =?utf-8?B?cktiSjZPWWVSQTJjb0RwNTZKVEJranVIcExDbWMwMFRwSHFkYmJKS2QzYVpV?=
 =?utf-8?B?K1RjQzdHNG44azJPdHM0Qkxmb2psRndwWHF5c0srWTRUZHQzeVNZOHZab0xF?=
 =?utf-8?B?SkxOcGRHQmtXdUtiQmw2VXRIaWlvZVNNNEtEeFFKUk5MNVV5SXNRQjVaUmpT?=
 =?utf-8?B?cUVPUGY4TUJRaDFXdjVxUkROQmwvekJqMzVIOFU5cDdTVTIzWUxlK2VJazQv?=
 =?utf-8?B?dm1kSTZRSmtCOEl6Zkw1UWhUL2tNZU1JS1phOFEvNUxvNk93b1BQUzd1ejRt?=
 =?utf-8?B?TFdyUXRlRDNHdkprZ3kzYm5WS3UzaU0zbElIdVUyazUwdUc5QXdOV0tMRUdM?=
 =?utf-8?B?R3RCekd3VkEvSEdvNHdGamQrbUppZTJaNUp0TWxYcXp1RGUyekI3ZUpnUWg3?=
 =?utf-8?B?WlBFbUlmWnZGNlVIK1hQZWtMN1IrbVhOYm9IWFM4TGdLZDRzeFFpWnZqeVJG?=
 =?utf-8?B?Nzc0cHRSUlNZOVZ1MEJZTloraFdKYmtlazFqV0lkMEs4QVdLcmhBa2I0TnJM?=
 =?utf-8?B?NzJWaW5wZFdwcWRvbTFyTWJRZFFWK25xQUxjdVdSSk5MNzNMSEc5Ujc3MFFO?=
 =?utf-8?B?SVRiY2ZCUzZjNkliekI5R3hTaTd4MWt2RldwZXRveS8wMlR0eGJ6R3VkMFJq?=
 =?utf-8?B?aGJxM25wMGRSMkNCK0QxZkw3M1J5ZnhtYVkwYjlncDFJNXdQYXdsRi9xSHRw?=
 =?utf-8?B?R0RvVXZoL2xhaTE2OUlzZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0FEalFkRHJtQSt3S2xCbS9saHJCK3NsdTJPQ0UxL0pFM2krM3Z0KzRDT3J6?=
 =?utf-8?B?bm9MamwxVytYcnJ2K0NMQklpUVVpMzFNQm8xNXRMdUZwd3VQYjNDb1VCZU5N?=
 =?utf-8?B?N3BFdWpJMEpQcDF5dG5KQWQ3WGhsbTB0NWlpK1ZhN1ZqcEw0aStxUnpDblRm?=
 =?utf-8?B?U2FLcTJ0VnEyWDRHUUVlQjR6U25Tc0hzU2JBOU9SQ0tmUndCQ3dFV2lxcFYz?=
 =?utf-8?B?VitvMzljc3ZuaG1vaWt0aFQybzh4YkVHQkFmWjJMaFEySk83THFyNkNLVWNx?=
 =?utf-8?B?dkNDVjcwTFRyY01sOEZVVGZCYUt4K1FOa0dPWlIxeFJQVFhRa3JYL09LYlRP?=
 =?utf-8?B?Q2ZJUnlvQ0tFb3lLZEU1aE1pZW1nOUVoWEt3cXNBRldRS0d6Nys0RE5WZVFW?=
 =?utf-8?B?Z2ZGaEFoQTUvVFZValFCYzQ3L3Z2cGFpVzdDbGYrbU0wOGhWYkhhWE1xUmJ1?=
 =?utf-8?B?RGxsWDFSdE9vcTVCVDFwQkFUc0FzZVNVMG5PQzROSFB1MTdVQTVJb0pFM09J?=
 =?utf-8?B?MG5rWFd0S3JzcnYrSy9LdHVFSlc5WTFWdFY5VFJzYVBvQTBMRnZiOW9TcW1E?=
 =?utf-8?B?RndKckt0MFdLWXZhUjl3UjdUbXA0Y1E0U0FSbHZGUmFhSUp2TVBFVWZUVFJQ?=
 =?utf-8?B?K0hRSGJLS3ZNbk1PM3dsNnZIM2tHaTBEN1RsY2RpSmNiSnRkcURpbDhDZTdX?=
 =?utf-8?B?ckJpZzNHQjgvamdKZmx0SVRDbkZpdUI2RjF2V08ydExlbWRRQ2xuVm9DWUdj?=
 =?utf-8?B?aStnUTg4YlNqS005eGJZRHYvNmhxdStqbEZiWS93S2wyVzAwMnNQUEo3dEZw?=
 =?utf-8?B?QWRrNzZWZkhqWUxFbVM5WEtOTjI0bEo0WnVGbTlsWExMY0o1c2xVWWZUaDUv?=
 =?utf-8?B?OXN3U1JlcG05djdVUFFiN0t3ci9hdFMzSmJ1aEJlaW1pMVpGWVlaTTdPVzdv?=
 =?utf-8?B?cXZOYVB6cUhiVnRscnB5UUxLUWNBZlRjS0oxVkpic1d4Wi85VVA2cXN4U0VW?=
 =?utf-8?B?SERKVm5GRnlQQWxKV2M0Y29GQnVwQ0JaMTFreWNHNWxTRnJQTWVpcFM2WFlt?=
 =?utf-8?B?bHNKRDR4TDN4VHVqdlVWbFRlbVpDRk9xWDBLVlNvbFJ0WmhBREJTM2lDT0pz?=
 =?utf-8?B?eXpPSE5nMzErZ3VlbGlLTFhxR1RrNHJWUnRmaTBGU096ZVpkYlMvekZ1LzFN?=
 =?utf-8?B?Wkh0cjV0WHNhVlRPZXBZY3NvODZqcGt2Wkl3VEZWOFg3Ymg1VUR5UklrL1VW?=
 =?utf-8?B?aWM4WG9DdEhMTWhQZW13V3c3OTJCUG9pb0twR2JiVHJaamtSWkxYQTBtNzBx?=
 =?utf-8?B?dkhic2JOVzhSV0FHOXJNU2MwYmdJMEpNMEVZY2E3UUptbUo5SFFYZFpydyti?=
 =?utf-8?B?elo5dlNQNGo0T3FTWGpFZEcyanIyRmIwQVVtbGdYSHVxZTVETXFPcjc4Szh3?=
 =?utf-8?B?UDdjL2s4djcwbDZmTlZEVlpsY1F3TGUvdVNHNVdEQS81RWJtcHY5eDNmL3JB?=
 =?utf-8?B?NHZ4UFE0d2wwTnpPQ1phQzg2U1I3VGJLUXoxOVR1MWxrUmVGTjU1aFNiMU5o?=
 =?utf-8?B?OEg4amZqZkgrNXBZcXFTUzhVQXhNa2JCVFFhekRLUm9Bdnd4ZjdKT2xPR29w?=
 =?utf-8?B?S1VJd1ErdXBRNEpLMzBtbjBnVGdmRWcxK1hWR01EZndMc3hzVFVwUjV2Lzdi?=
 =?utf-8?B?bG9QUUtFcy9DWXdGRnZNU1BNUjVEd0Z4aU1BWWlDVDdBWjlxTmg2RnQxM0dU?=
 =?utf-8?B?Wkd5ZzFJeDgyeDYvSUZvblVWZ1o4OEppZE9kcW9sNFE4dStqbU1iZTBwWnMy?=
 =?utf-8?B?Y1IyVXkxZFJxOElneTIxODlEbjQzTVlXSmR5NDd5NmxqekQ5WUlMMFJKclpH?=
 =?utf-8?B?dFJqNUNhY2c2SzZrNWlmclhZQjJLY3BXKyszOU5jQXhBUjdiU085SmZRMkZF?=
 =?utf-8?B?NHZtVk9YTFRuMjVXM2xSY0RNOHczMk9nakZsenY0aUJzR1o4UVJGK0J2WXV6?=
 =?utf-8?B?TThLVnE1bjNmTFpJVDBuNHEwMGlhM29yRlpYY2JNenYrQTdVcFM4VHF1SUxt?=
 =?utf-8?B?MFlFSUJkVkduSDdMb3NaVnl6elJhbzlhdld5RHMwVDlpYm5MNDc3VFhSa2ZS?=
 =?utf-8?B?QlRPR0lDYllCWEZxbVRlRmhUYXRyKzhJMVgzWERsdzd6bnVDZXR6a2NQUUt1?=
 =?utf-8?B?SHc9PQ==?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9856825-0246-4381-9b42-08dd0d24e1b3
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 07:43:41.5134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+9AVZkMTj/I/0nffK1K+XqEvpiQdHYuG9MF/0xxDA8IbniHkCEUmtukXg7COXP5MtJB1ehS7tpHbeMg0VJ8sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR02MB6869

On 2024/11/25 14:01, Christoph Hellwig wrote:
> On Mon, Nov 25, 2024 at 05:58:22AM +0000, 韦龙平(Groot) wrote:
>>> What is ZWL?  And why mention 6.6?  And why do you care about ordering?
>> ZWL is Zone-Write-Locking and it was replaced by Zone-Write-Plugging on 6.12.
> 
> That's not a generally accepted acronym.  But more importantly it's all
> gone now, so completely irrelevant.
> 
>>
>>> There is no real ordering requirement in the block layer.
>> According to the design constraints of zoned device, write requests in the same
>> zone must be dispatched in order of address and there can be no holes in the middle

__bio_split_to_limits will split read bios with max_sectors too, split
read bios in dm-level won't increase the number of requests dispatched 
to scsi devices.

> Yes.  But none of that matters at the device mapper layer.  Either the
> submitter needs to ensure ordering, or you must use zone append.

Just like what was said in "dm crypt: Fix zoned block device support":
> Zone append BIOs (REQ_OP_ZONE_APPEND) always specify the start sector
> of the zone to be written instead of the actual sector location to
> write. The write location is determined by the device and returned to
> the host upon completion of the operation. This interface, while simple
> and efficient for writing into sequential zones of a zoned block
> device, is incompatible with the use of sector values to calculate a
> cypher block IV. All data written in a zone end up using the same IV
> values corresponding to the first sectors of the zone, but read
> operation will specify any sector within the zone resulting in an IV
> mismatch between encryption and decryption.
> 
> To solve this problem, report to DM core that zone append operations are
> not supported. This result in the zone append operations being emulated
> using regular write operations.

Zone append writes to zoned device will be converted to normal write 
requests and submitted one by one by zone-write-locking OR 
zone-write-plugging.
This patch just want zone-append-emulation which was implemented in
dm-level could works fine even if dm-crypt got a write or zone-append 
bio with size greater than max_sectors.
