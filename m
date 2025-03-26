Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2046.outbound.protection.outlook.com [40.107.255.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D632273FE
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 06:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742970870; cv=fail; b=qNjnuW+ib/7/rxeJJcEk0arR8IQNMgCJuVj/ndnSdSsfG6tDcFC3/WFe+on1OeEZdZrg5Fxy6ngXEDIa9ntmUte2Lvag5Y3UXnZP2MH82Apg8HNqHejJFpQvqT65g3Fkx5h+o2S8rWx/NqK6r7sRfJG1EcJE5TZd7eRKyvdtW38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742970870; c=relaxed/simple;
	bh=0A+N9C3vH5SGgvFSDGnSVTUc7VJjAJMcnkuVSZVYdcQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WzyqzItqYptWUaOLj85Tl1TRahJ5IEuLUGQPrDYVAEzB2CgyKbq2Iu6YrgdGpTm+zI4qtw7uLlfR3CwgJqanoXRsWQRHbVH6OnaAZ6+cVjLAHqtT1IKFPhF3YpJ00P37sq0DF1Wc5/LbxGfOlGdS+nz7rFh5ZD5w2WkH9a9x/Vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=qe9qrj9p; arc=fail smtp.client-ip=40.107.255.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="qe9qrj9p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LO5B2nR7L0/2d+tCGIKkcuvatsOumBeGnwMsRRSTfdEtOq7OOh5aQfYvo6MDlx1n5Z2f/JkTpWgqenXD1B/JmPZnOu5Gsnrftxt/C5z+0o5+2nO8Fp8l4e3wMmaAOQKzLs5GBwBs6XzsTP/DzsiwzLV2/Gx6sTP1n6u+R7lTtcQKs+gy8riGqG1J5WcVj2x9NlR4bhUuDv5n878Zj59N3DevDbVy+qhYN0hhASdlY3t2lobml4CCrolck8DacGVLg9xpgljdO+RYF/0SdWrjAY+e3lqwBYJRF0/MS55i3ze+ozSWSAD8p4Jq9sQ/WZdB2x/d5mSzjSmMVPghlNNFVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GakVcz/285AC6CY5irI7CfDCsSM+ttH6VU5B33jBplc=;
 b=ZYoHein6DYeO7mSAe1CZPOxWLh+A6oM9TueX3wc3pfyFWzb2nTgGJujb6wy3exFLGTEpkKYLdrWQTLVioJ+S5QRFhCgRdhqz3+ObbhA/9sWfF8yGadGPhQrfcq5vPo4wBtVo9Y4sWKwCt0LSeDShlzH6upF/Suem3o6jzK2CPhVEq5sD2zNWETyuWRISraQa7M8Ep7NRNr9WkbYqd0ag2pev6MtAxdtn3+rOvVhSlVIB6NuPi6JyoTbM81g9KGb3prI3Uj0MV1yyjGC/ynFf2ELaBFrpAfp//i3L/1CR9V1Fr0Ez4vB5g8SUep6yWHEiQACqmnUnUDIqk6zFTdmG8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GakVcz/285AC6CY5irI7CfDCsSM+ttH6VU5B33jBplc=;
 b=qe9qrj9pYdx78f3hXrmXlf+wqnpTuGLlhURZo4Fpj3PV/PoKE3vitkPOm+SP+GT3N2f13/Kh0kDkbx4EmaXUFXHa+DcyLUYhrdb5ZEoDPGyOh1wyQrnOLSE2cnbHHvC/pMIJVfRV+qxLT/DyWLIaA3NpMJy5tgOSwUyb28DBp6Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by KL1PR02MB7431.apcprd02.prod.outlook.com (2603:1096:820:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.24; Wed, 26 Mar
 2025 06:34:24 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Wed, 26 Mar 2025
 06:34:24 +0000
Message-ID: <49401f3d-af35-4664-a096-1366e4924732@oppo.com>
Date: Wed, 26 Mar 2025 14:34:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
To: Eric Biggers <ebiggers@kernel.org>
Cc: mpatocka@redhat.com, agk@redhat.com, dm-devel@lists.linux.dev,
 guoweichao@oppo.com, snitzer@kernel.org
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
 <20250326051829.GE1661@sol.localdomain>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <20250326051829.GE1661@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0115.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::19) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|KL1PR02MB7431:EE_
X-MS-Office365-Filtering-Correlation-Id: 173cae34-be23-4f8d-159c-08dd6c303fb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnVEQVJkYTlwWVBmSnZURi9rbHJSUTZxVEh4RGhOQktqMHNXTEhGSWhYNk1E?=
 =?utf-8?B?RjBRWTFHbXJOU0E3eW41Q1JpWldPWTBsZ3hWaVorN0ZpdmxnaEVQTVdTeStB?=
 =?utf-8?B?YWZrNzl4a00xVlBkSXZrSktFMXZBSytHZ0hJMDhPVHhIS2llWFNodEdPRUIx?=
 =?utf-8?B?WS8rT3pjZGs3YTVjT2JLeGxzUk15VDhHYmFBTWFzd3F6Y20xTU9QZDFWMUJF?=
 =?utf-8?B?WTV4OXNuUmZOelI3RHdSWTdBZHA1Z3RJUmNDS0YwTnhRd2FJT3A4bkwyRk1U?=
 =?utf-8?B?amJ3U3JhazRIMUZDN082QnYvaTFVRkhoRFQrQ3BSNWJ0SDdhSnZ1SnVXQ3k5?=
 =?utf-8?B?VnRuTHFQdklMdGJiV2N6N1VPOTExdTVZUGgrM2Z2eFIxSkh6M1RrZU1LYUxX?=
 =?utf-8?B?NmtOTTU0dXFUa0VrdlFmR0xSOFEvM3diQ3ByTHR5elh6dy9QdVVZc0NiY1Ru?=
 =?utf-8?B?L3Q1V3ZiNFJESVdUMnlDdkJBd2xDN00xZE9RY21rZ0tBcW1HMXFwcUNoV1Bi?=
 =?utf-8?B?QUFwUE5NVWtJVFN4Z2cycGk1bzd0YmkvaURDSkJsN3RocXlGZnZGTFpOL2F3?=
 =?utf-8?B?bGRxb2wrRHIrbXo3bjRUT3M0NlArbkhGaGpDT0o0ckhzK2FNd2hBQXk2Sk9R?=
 =?utf-8?B?d25PTGM5QWxmN0NXZ1dSTFA2N3NkOHJQZE8vUkxtZW9FaUo3bnQ3MkpIM2Vj?=
 =?utf-8?B?UUVhVkJ1SlZQbVlTY2pocytlMVFtZ2kyZFpRL21zOW56T3l2L0FxMXlQbURT?=
 =?utf-8?B?SWxiY0N2U3o4WUFDZXJFK0NYaklNRktvNm85anJGUzRwMlNBVGxrLzhzdDV2?=
 =?utf-8?B?UkM5ZCt5TmxQVHBRckFEYnQwUlhuUEFLV2JmOU80bFpZZU1oTFA1eGhpcG84?=
 =?utf-8?B?RVZiUkF5b01ISmFUZGMyNGZZRE1VWUJsQWJ3bTNSeUs1bXZYSjlPRlZpVHJN?=
 =?utf-8?B?SWtQTVNuSkpEeWlZTlVsdnRkeHUrUDB2ZTliOEJWSFkrWm8xbzlwQ3RWb3A1?=
 =?utf-8?B?R09kSGcxYTB1cEpoY2IxSEVQTUJxaUlmNEhsWjRPRTdaTVpzeDN3TlFvVWps?=
 =?utf-8?B?NlhXWFFvS3VKQ0pUanNyL0VjRGp2bWdqL010ZlVjbFVaN042djMyTERrVHdz?=
 =?utf-8?B?SUZQcUZuamF5TEgyeHBqajJuSWZyV0RseGJUNnVQbnhEeEk5VU1zanFRb2Rw?=
 =?utf-8?B?UTRvRVVXbFBIVkx1ZDFVSXErYXZWdUprb2hUdEFFYkh2clJETDhZUDNBLzB6?=
 =?utf-8?B?eWlqM0wyZ0gyUG9QSG5Qa2JXRXR4b1dZeWVBSTB3U2VpNGpHR0JmTGl6dXUr?=
 =?utf-8?B?QUlZQnBPZkkrTlNhSnFtZVlwTzZ6TjlTR2d5MVMzZThRbFFvUVpBbnYrbmVv?=
 =?utf-8?B?cHNwcTAxcWMrUU9QK0VVb0xEZFVxdXJyZFFBR285MmphZVo4YTlEME8rM2dr?=
 =?utf-8?B?ellScjZhaTlLeTdIcGdHKzk3b0FpRlg4QSszOHJwU1ljVmp4MUVTWG9kY0pF?=
 =?utf-8?B?OGwwdVJHc1pJM1UvZWpZSFRielVlaWRGTk9lbytYMXZpVWoveXBEalhEcEZJ?=
 =?utf-8?B?TlhwUSt2MDhCUno2VWd1RC8wYU5RQmdRZlRUS3pTVHlGYW00Yy9Eb0cvZmg4?=
 =?utf-8?B?NXBYOFp5NGYrNWhqWmdqa2pVSWlPUHJmYjNFQXN3UEVvQVBVZ1N1QThzdXVH?=
 =?utf-8?B?c1pXdFM3U3R5c1RZZ1hkMXJsY2VTN1F3dElqY3VLaTlvMGgzNzFxRENjcGtB?=
 =?utf-8?B?elJlbExPRjVJQis1M2NGUDNIVE1XK1VldzdlYmtyT3lWVFlRS2J3SWtYZ1Vh?=
 =?utf-8?B?UTJ0cld4QmVqbGhzTnZKMGprdW9QV0MxdUhhTXNHNXoxL0wwZjRPY3BibG4x?=
 =?utf-8?Q?wiyqryHy1BP9C?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RW5oRDRYNzRlcU84b2d4aENzQ055YXNTRmJnOGpGS1NUNHB3VzhEUXJOYTht?=
 =?utf-8?B?dVZxcC8zdWNJMXpSNUI0TG1wcG9JcW5pZU5wOEh6Vk9iMWF5dDdVd05KMUhu?=
 =?utf-8?B?cHFYWjQ5OHM5NXoxZnRXV2hSZmFBQk9xenZ5Yk9GM3FlTTlHS255V1BTM3dn?=
 =?utf-8?B?cUxKRHhqZFpOd3gzZTduRWkrWWVlbG55VE9KaFgzZUpNZEZNdzZtcHFpYkpn?=
 =?utf-8?B?Ym9vaG8vWmxHN3lPdjE0dTR2VDJ4UE9IN3E5ZHh6d3pabkxoN2xZV09sRXpx?=
 =?utf-8?B?bnhyZEt6dWFmRGpHMDBub0RrTG1qU3dmQlkwRGVuMTJ5R20yKzI2aTNYMnY2?=
 =?utf-8?B?YitsV2hNSTlTSW5xby8yTTk0Q1NQZitlNHpoMUFMalY1cTdPdUtNWVVVTmpY?=
 =?utf-8?B?eFdGMnJqeWVtSk1PbnArN0MvQ3Z6c1J4VzVSQlJtd1N5Yzc3cmhRZlFRWWsx?=
 =?utf-8?B?MDVKRFRuWVJrZjdVY0R2VW9WR21vVDFRV3UvbldxaVlmQk5kbTR1MW9DSU0x?=
 =?utf-8?B?ZGJPZng4ZlJ2ci96Ym9UTXRhTjI3eGM2Z2tlaS9Qd0VzQ3NnWlliOWcyTU5W?=
 =?utf-8?B?OEFCQ1F4SU5DTmFMbkdSRWo4RCtMdm91Y2xSSlQxdW5nOHg3L1BzWXR6NlQ5?=
 =?utf-8?B?dmJzakZJckJhNm1IVHBGdzVMZVAzVVdXeEgreDBaSWQvTUJ4QTRYQzRkQW1t?=
 =?utf-8?B?cG9BOTk1TzRaamR5VEc5clNDRk1yNEdibGExZWlud0hoQmRydjg1T0F3bSty?=
 =?utf-8?B?THZrM25RcnZxd3FKby93Z0EzcGtoUWIyQ2ZzYVJuREVrNG1HU2dNZ0lxOWpU?=
 =?utf-8?B?T1ZQWUFoZnhqVU9oeERWRHdDZTdiaUN6VHFERStlbi9iMTlwalJ5ZWM2S2hK?=
 =?utf-8?B?dGt1aGZRUlFCellZMTlpRU1abWM0aVpMZ3k1VjhSZDBFUG1NZFdqaVBhSExD?=
 =?utf-8?B?Nm9jS2ZUUnRHdkJqNnhqdDFKTHlhalhQcFlteUhjNWVidVFIdUw5VjNvbGEz?=
 =?utf-8?B?cmhadWJtTzFlSGZHYW9lWTN4dFNzVm9pcVBWVmFpckRRRjQ3YmpJL2Q5Vzdu?=
 =?utf-8?B?SGtETTdSTW5LWkFLcWVEOEN4eUEvM0hDbGxTa3EvNWVCQm9uWlhnb3gwa2o0?=
 =?utf-8?B?Ly9jb1IxM05BTHZjM1ZsNENHcVMrdVZrcWtLKzRmNHNIVU0zb3I0M2NEZ0N2?=
 =?utf-8?B?RldQa1hZUXplZGZqR2x0a2VjUUpHUDJPTktycmp3S1p2R0xNRm9OblQ3RG5i?=
 =?utf-8?B?VVBWcHY5bFBPazdlblBsSjJBc3FDQzNiOEFiUnc3Tk5nbWkrbVU2ckVteXhZ?=
 =?utf-8?B?ZGYzMFQ2TnRxTFRMY3hLODVCb3VXMVpWa29YRloxdVZjZ2FSaDBTTUMyb3c1?=
 =?utf-8?B?aVBsc3ZGbTFtbnJGRTJmd2JVQkNTZ1ZpWWJjT0tnd1ZlbHZid2VhN3VSd3JB?=
 =?utf-8?B?eHhxSVptMGRqcG9kQlZFRGE4TEc1Lzc0ZFl6MWpCam1oVTAyM1dNN3lMTWxE?=
 =?utf-8?B?YlhpaWlSalhOOVhTVU5EWkUrNnpBZ1JzQUxIdnRvdVBFL1oyU1FTNThiTFNU?=
 =?utf-8?B?V0Z0Ky9LbHQ2ZHJIYW9MWUxNOUhxWDJ6QndRRFNteTZSajhxU2VvQUhCN1V4?=
 =?utf-8?B?YTk3aWpVQkRMMk94cmp3MS9UYWNFbmdSL1BWc1YwS2g3dDRmR0l1Rjc4SFdN?=
 =?utf-8?B?a3lMVFhwajZvaHNteFk3L2FnM2tVa1pyVUg3NnFYYnpvc1ZQZTlqRUtodW1a?=
 =?utf-8?B?cjBPbE9MbUJSMXhsekd5dVhPbjladTZZN05CSlhTZEllVUZUeDdLV0dXekMz?=
 =?utf-8?B?V0dmRmxKMU1UQzlRYkRWYys3Z1REOXpTYkVVeHhyenE5Qzg0dkNHeEhKNS9j?=
 =?utf-8?B?bTNEcFIzRGpIQlRzRURZQXUrTDQyQnNaTXA5S0YrUmcrRXNuRXZUTzE4YkZ2?=
 =?utf-8?B?dlkwWFVSbmc5dzg4cWR5aEl6S3BzTzJWOXZrMmt5ZWl5VFM2RklUMWlkaTF6?=
 =?utf-8?B?cEJ0a3oybytCaWtidm5OV0E5TmRBZUdsTHpFLzhSTnc2emdpeUZoMVdQdkJl?=
 =?utf-8?B?ZlVZZkpzMTEwYzBCQ1dXM0krYnBENE5xQllsWDJhRFhXUEhFSmxMcWE2a0Nx?=
 =?utf-8?Q?lJQtaXvVp0NOY5ovka75Rj4U0?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173cae34-be23-4f8d-159c-08dd6c303fb3
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 06:34:24.1228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBAs5SC9C2FySjMaihvBR7kcH9cq+JD66JutvgHJ8PDyWDsHV2ZTs5DVGeChrvQIYQuqCS87MMkqfJJA3/3PuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB7431

On 2025/3/26 13:18, Eric Biggers wrote:
> On Wed, Mar 26, 2025 at 09:30:51AM +0800, LongPing Wei wrote:
>>   try_verify_in_tasklet
>>       If verity hashes are in cache, verify data blocks in kernel tasklet instead
>> -    of workqueue. This option can reduce IO latency.
>> +    of workqueue. This option can reduce IO latency. The size limits could be
>> +    configured via /sys/module/dm_verity/parameters/use_bh_bytes. The four
>> +    parameters correspond to limits for IOPRIO_CLASS_NONE,IOPRIO_CLASS_RT,
>> +    IOPRIO_CLASS_BE and IOPRIO_CLASS_IDLE in turn.
>> +    For example:
>> +    <none>,<rt>,<be>,<idle>
>> +    4096,4096,4096,4096
> 
> I'm concerned about adding yet another performance tuning UAPI, which will then
> have to be maintained going forwards, even if the implementation changes.  See
> e.g. how try_verify_in_tasklet has ended up not actually using tasklets anymore.
> Is there any strong reason for userspace needing to configure use_bh_bytes
> differently on different systems, vs. just having the kernel choose the best
> value automatically without any new UAPI surface?
> 
> Keep in mind that the tunables could also be added separately later.
> 
> - Eric

Hi, Eric

It seems that it is not easy to implement the idea that having the 
kernel choose the best value automatically.

Unlike on Linux servers and PCs, the CPU load,number and frequency on 
Android devices may vary. For Android devices, dynamic policies may have 
a more general benefit effect.

On the low-end device I tested locally, soft interrupts would be 
concentrated on CPU4~7. I tried to increase use_bh_bytes but got 
negative effects. The time cost of a single block softirq becomes 
higher, which will defer subsequent block softirq.

But on the devices with UFS MCQ or NVME SSD, most verity_end_io should 
be called in hardirq context directly but not softirq. These devices 
have the potential to raise the threshold.

- LongPing
