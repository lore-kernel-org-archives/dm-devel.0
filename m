Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011026.outbound.protection.outlook.com [52.101.129.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E7E2500AE
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 07:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732520950; cv=fail; b=X68pbnZD5k/x6joBdRAJtd/N8J2LXjTrycyLBGJoSZCnW6zxpYaodoPmdc69FCavJQC//1ZqfKGM5BiaCne+KH+AIHEGFaB3hLQGXR0simH6K7GWGy3IMU/KUL6CwMCdZcF6g8iK9O3sfCDEtMNawojplO3VZM2GkHevRZpNLUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732520950; c=relaxed/simple;
	bh=mJHn2F2Mw/iyzsHUgTceS12nZOUT60j3zlrSOJ46jBM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZNpDMey7/siIUp4rNJU3kBIPu45Wl8T/VKSTO+52gpJ8483hcOGdlt/SpzuF8yJ7xvb5g0M02okwCg0M9wK80g2piJuWl/3/L7ug+eAh+BRHFRcdOYvz0X70Pq6cVVqBfz7bMJdIknPUxshCwX2hoYi2GpB9J18T9ckjP9SoLOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=ny8bsjzi; arc=fail smtp.client-ip=52.101.129.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="ny8bsjzi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpB+Qmu6mTgLtigijgwAy8OQS/YVul+d3R/GCShoxAdnPZGpEVOh6ualEor0gubPTEcT0ZTI4XM1ryPQZGszi+z0iigTgPmLvLtJH4Xh+seoYfrNPwWaN2OrDQcHBBFC8TE/3bdA+Vx7ng5n8iuJp1yt0K7i5dTPovj8jp5uprMjQ2lkT91gdbz8RZUbEFmqjVaoX9AH2AVx+3EYV+HNr1R+/slp0cgQRuJQadiLgynUdqwy8WM7UiC6SXUsCVZbwoK0+W4k3b2eXc6JD1dOUcHVrtlCQtXQrQzXH7g1pq9Y4zs75luovpau30MhkvOYrGI4bNfY/bvXGsTpPJshHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZxWAml9sbPzdYMNw04htun5JC1bdx2J3LrNRlhsCHMo=;
 b=e3PH5bCiOA52hWEmWu1yeapV819+1C2nwIYGj0U/36acSwIi2rwQRxmvuenmM9KQzWmDWBi7zrjBhiQw110D3CI/zzhXxCvuEDYqdZZQKU4I4oWmfP7m42fma54TYJyyUoUIiDdc5Lfqz06UHWIKFOieSXNKwM6jEh2xq4SFC7NW5Yif4Uo5AS7Rxl+ZNMj+eOTt+2Th9VaJBMlphPcVIIR4EfYi/BIeLZ79axIJM+d7xOX0DX5UbzqxqdsRM9fLi+bh7hvIST4xLaVml13ygRrii1NDCKPlj9S89CHOpqyaV09fufOruYMi4VzdDy2xRWRn8qxPMRKkfkUACpi3vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxWAml9sbPzdYMNw04htun5JC1bdx2J3LrNRlhsCHMo=;
 b=ny8bsjzilIaycH7DX5NjDELKlQytcGTDsmvwYGbJY/Td6mnWIW9HWpqVUyOqRw1AKdAuna8sb/1hSUbE3DV4WwIGs8J8epYyNbbpwAyw1qvda7SHSQ8MTf+LLKiVsNOQCP9fHKzPU6t+IjFO8MFzm7A0a7PyOIoC/CIFzN5pOIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by KL1PR02MB6681.apcprd02.prod.outlook.com (2603:1096:820:105::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Mon, 25 Nov
 2024 07:49:05 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%3]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 07:49:05 +0000
Message-ID: <ec6f2bb7-95d8-4c1b-9654-4c597e1f0da4@oppo.com>
Date: Mon, 25 Nov 2024 15:49:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
To: Christoph Hellwig <hch@infradead.org>, Damien Le Moal <dlemoal@kernel.org>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "ebiggers@google.com" <ebiggers@google.com>
References: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
 <Z0QSqndKs1fyiOmJ@infradead.org>
 <b01f1929-f1bc-4ed6-ae57-dded68f23e26@kernel.org>
 <Z0QVCemvU5_5REWB@infradead.org>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <Z0QVCemvU5_5REWB@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:195::8) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|KL1PR02MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: d4466b7a-1748-497a-3b67-08dd0d25a289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmlzNUJwckdiT3FNSUN0aSt0Sk1UZTQxS2NraXhlMDYvQ1RuN3I0OGw1aTV0?=
 =?utf-8?B?YmZBc2R4VFJmdkRCSUhUVXc0Qnp2VHhBRERtSmJZN0IvNnVBaWFlRU4rNlRq?=
 =?utf-8?B?Um9ielpxYncxOEs3MjJpdnVxMklIUlJvSFgwL3lOQWRNOFNMSStTa1pIUi9H?=
 =?utf-8?B?RlVWNW1GRDh3MWRjeER3ZUt6TzcyQ0RvYnoyK09VamFxWTd1amhJWGVmb243?=
 =?utf-8?B?NmZXaVhNR2pabGE4bjd0b0ZoK29JM1lmWTZkNytjdU11NHhtUTR5OFZXaWxl?=
 =?utf-8?B?K3NNdDh6T3pGV04yYlZYN3JlN2k0Z3ZrbFowZEZqa3AxZXFXL0Z1elJNd0Jo?=
 =?utf-8?B?Z2Vqdi9rOENCdy9XdDNFVnpYazRzbFBQYnZkZ3FZbVRaYk5rT0xLZjJscWNa?=
 =?utf-8?B?YVRQb1BhYjkvTXVmVE1HdktyT0pYWTU5SmxIYmUyMW5FK01VUTNmSFFTZVNX?=
 =?utf-8?B?TFh6L2lFVmh1ZWZ2UWsxN0g3M2xCbmFDMnJtL2dKTzFsMmlYWUtZVDg3cCtx?=
 =?utf-8?B?eFpEV084aWFyTjRhQ0FLNmJvWjVmLzlySjNEM2lVR3RIQUg1OWVOK3o2UDcw?=
 =?utf-8?B?WXF3aTF2eWxzQ3ZSQzBXOWxZTzU1N2x4ZWw5N2EyeExDZVZ3WlE0RHJHRUxV?=
 =?utf-8?B?YnZPcXg4bU9nUDhMcTJqcnRUV0o3TGh6VHQxRVBnZmkzeEozZGRLam55djM3?=
 =?utf-8?B?UWJnYWpvblV1OUhGT05QczhrT09udDR4T25XalU1Q2dxUVNQWUlkZ1M4V3Rq?=
 =?utf-8?B?cmVxbWxQWVhkZTJFcVV3VHRIS2lYOE02dURJOHBMUXEwOTZ5cXVPLy9XcExW?=
 =?utf-8?B?VDJnOWQxd0p1Ukc5S29jMVgzaUY1YWM5WUJDTVV2VmtpRE92SFV5cjhtdnN3?=
 =?utf-8?B?TjgvalV1WTNYVHY5c1F5emxxVUVmcm5HMmxwdHJiRVYzamFYaEIxUkI2RWJY?=
 =?utf-8?B?T3ZjdHlmVkxrMitBVFhidFIzOTd4aHdSSk1YcmRrNjRkUVQ2Rm1FWEprMVJV?=
 =?utf-8?B?d0Z1UXdrUDJZM3lMci9Tb1dFQlVQb2FyL1hzRTRGbUdwNjVCYjUzZ3RxVjkw?=
 =?utf-8?B?UU1CeWczZzFlUVVBeUFVMldTYzhYMGJwK2VHQ3c0ZEpkME9kUXExMTZ0MSt3?=
 =?utf-8?B?dXE5d1Jpam1manNQemViTlFQeFNmSEhzVG5TbjdqTFlpOXI5YW4yTVEzMHZk?=
 =?utf-8?B?eWhaSnlGTGFSdDNHOWhYdFYzcEFSa2Fsa01sc2RoT0JkQW5JV2dKTzQ5TmZE?=
 =?utf-8?B?N0ZneWhiQjlwYmtzV0djY0lKSEpReE1uMjg4VHhTeSt6YWtUY1BQNEZObGFT?=
 =?utf-8?B?RWRNZHUzZlJWbnFROHlVMDQ5UHpNdVdOckF4NlZrNkVSaWw1RENtRVpva2du?=
 =?utf-8?B?bFhxS1cxRjlFeXJsZUpyOGxtK1BoTzBvZnhLQWIrOTF6Uk0vZUdSSktCZHF2?=
 =?utf-8?B?ZGdmd3dSK2NoNHZZTFFkN3dQdmEyMWdoOENBQjhKNzh3d2RWNk1NSkdnQzBQ?=
 =?utf-8?B?djVNdVBOMGVlNjRoWW9TM0hSY1Z5ek84dWQzSzNiMElNWlplL3VvVWk5S1Bu?=
 =?utf-8?B?OGljVlQvTEZBdnU1NzJyYzIxVGRkMGpOcTFwUEl2bGlOdy9vd2lhRGRYZG55?=
 =?utf-8?B?Zm9vRHZiSEJKbVM3STY5ODgybzhsenVLd21nYy9EbjhBVG9sa1ZuSzRDRnhV?=
 =?utf-8?B?RVpVaVVSUkRwUmZtRUJYRTNlcStIcmFMeHFMOVFLdnNKbzNjR0FzeEQzL3BF?=
 =?utf-8?B?MmM0eUYrUFlQQmUzN2pEMHNVY0pteTMxOTRpRENaeDNvU3VxNmF5K0JuM0lF?=
 =?utf-8?B?N3dVZmVESmFyNllzSDR4UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eElicnlYbHZmaVhIN2I5THRBVEw0QVhHd1ZtVHhiVCszVDlGbFVCbTlicHlL?=
 =?utf-8?B?RE9LVzVSWE9GU2d4UG56NjYrbjhldGc5MDZ3clJqdFk2cG8veVBXd3lYdTFK?=
 =?utf-8?B?aTg5Q21MOWdNNWxRdjkxa3lWRmJCODJ0aW4xSk1JVEExY0hUWGs0ZHdTVnFF?=
 =?utf-8?B?WkF5U1hJZUpyazZUUDEzb2lUTitkR0J2NkpTa01pMWZnWlJ2T0pDek1qL3ZP?=
 =?utf-8?B?RXVSWEJaaXNlT1NhZEpVNDF3L29ycjJJT1BTT0dvU0VxSmlGVmJ1Tzd6Q3Rt?=
 =?utf-8?B?R3Z2RFNpQlpNektwTm9FUzNuWFRYZmFlVGVlKzQwdEZ2VzJHZGt5cE5nbENT?=
 =?utf-8?B?bEZlM3pOdGJzeGVzK1dPYUk0K0VYVityejFtM0wrQXdtZTI4RCthc0xqNmdH?=
 =?utf-8?B?VjAwUUtWQXZwNjIxd1Zobm1VcHdENjZRZEJsR0JrTGRQQnhMV3hxWmpuRlFm?=
 =?utf-8?B?Ulc3Rzlwa0dMQytNMit6Sm9kZGZTNXpMTVovd2F5eUJKSFRHa0tHWk5XdUEr?=
 =?utf-8?B?V1NMaW9uTm9ZdlBmQzVGc0R2Z3pjZThHRm5kaXRuOGxhWW9UUHUrbUZFRTNI?=
 =?utf-8?B?SnkxdGN4YlU1VFJkd3Z5YjllaFlHVExIQnpWNEpQT09MWmxkNE5TbktRTFE0?=
 =?utf-8?B?Y1Jrd2o2TVFGeHRlU1pCcnpWMW9hbnFPYWZhZVFKU0Zldm03Q1BRTmFEeUN0?=
 =?utf-8?B?Y2hpdGx0c2hiT2x1VlM3QW9mQmpIMGg3cEliOEk4SmdueEpyaWFUcjZNRWZG?=
 =?utf-8?B?WUMxQ2dsNkxtcEo0eG8wMFNwaWtsNCtxUlhNOVlZakhCRGhNZVZrYjNFbzhL?=
 =?utf-8?B?Nnloc1FpNXZ4ekhCaDRLTVZqdnU0azFZNmxpSDdmYU1zVDlQRWUyUjlCZDNF?=
 =?utf-8?B?TGQwMWJ2TTZqNVdLcGd3bXg5Mzd3WEhabVR5d0VvdnIwbUNyeHdvRG5EWU01?=
 =?utf-8?B?ZE5BWk5vaDVEdlNUUzdIbER4SUNqcWtyQVpRc1VzR0syVi9yTnlGbXJIUnBQ?=
 =?utf-8?B?MHVMRFhMV3JBM1NKZDA3R0FtRDN1eFhObkVBeGxsMExDQiswVHBxS1pJdDE3?=
 =?utf-8?B?c3NLWitudm03MXFqMDNJT3FYTHhjRjZYN0NaNHI2UVh1S2JoRGZhbVBNTUhj?=
 =?utf-8?B?MHl1bldubWhGa0xKeUJhNHFPUjF6K1RCVUdJVnZZaXEyaEV5ZE4zOTBiMm5B?=
 =?utf-8?B?Z1NoejZqWTZyV2Y2c3R6Y1lnRFNYMy9WdUxLeFd0RmxOTURneU9LRDBUNWpI?=
 =?utf-8?B?S09CUTB1U21NRmJpWTdKL0tCQ3lOdVhReUZzK093cmprN2MxOGlKUzA1K3Vr?=
 =?utf-8?B?UDZLVzFHbXEvU09sdkwrOWxzUVZPWnNRdU5VQlBqL2pkWTVXcTZCVlphSmJ0?=
 =?utf-8?B?WXZGSWhsZTlRblVNb0lhZTQ2eHVmOFFOeXRWcDZiTFdVMWhjRHYyV0U0ZThQ?=
 =?utf-8?B?NUlsazArZHU5bmdsYm1TNmdyZmtMcUhFTzJaeTFDYlNaa1lRVTFOS0dYNGlu?=
 =?utf-8?B?dmdYNEJCZnRuWnVRZFFJenE4Y2tQR054USt0NlB4eFpCVkF6cHpWWFJ6K0V3?=
 =?utf-8?B?S09ZcXZOSkxxbkh5Kyt3OTFQRE1wMmFFbS9SOEdsL2lrZ1phTVd6QVYvU1lk?=
 =?utf-8?B?cFE3Uk8xVlBLSnlYYkFJWTJIeEVyQ0VBdkVYdmg1SkpPZm93U3BSeWFsdHpT?=
 =?utf-8?B?SWExcFdQQlBZYlFJTUZZcWpiUTN3bDh6TmpEcE9xZzZ3VzBsSnlWSmg4QjFG?=
 =?utf-8?B?eWU0cEttVDVBK0UvU1pRajBvN1RFY3VsZTlZbE5PUjZDNkNkczhiOGRRemxK?=
 =?utf-8?B?TDlFMjhDbHVLb0dZQ2wvd3diYXVEL2hOeU5aS0hFRGpDbDlHK3dyeXR6RWhE?=
 =?utf-8?B?L3YxQ29yOFdpOXpMWjBtZElxZi81S01EOXd0bkJycWVKOUpMQ3hyRVJndFAv?=
 =?utf-8?B?TkFLcm54clNicnF3aEl4TzBWRTNMb01mYnhhLy93cWwxQ2FXdTJ3d001MURy?=
 =?utf-8?B?Q0xKL083UWhrNTFCZFdmaTlTQ0tDUU9tbzYvcjBBYklhdExsMlhkMWQyS2lF?=
 =?utf-8?B?Y0laRVU4UisvVHhzcHdtY2F3ZlRMbFd6aXQyNWxsVmpWazlSTTBDSTZTK2tR?=
 =?utf-8?B?Q1F2Ymx5Y0pyNzR3L2xxNUlLci9TR1JZalVyaURwRXZXZjUvcWJ2QVFIZjFY?=
 =?utf-8?B?R2c9PQ==?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4466b7a-1748-497a-3b67-08dd0d25a289
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 07:49:05.0430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j84T6vL2iUmXydsNF6yqM3TUo7rqwRvk4Z2JNBjA//+D7pX0rvDNH7aHtMax6AsfuTVITCaUfmdhfiu7LkRDgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB6681

On 2024/11/25 14:11, Christoph Hellwig wrote:
> On Mon, Nov 25, 2024 at 03:07:24PM +0900, Damien Le Moal wrote:
>> 100% agree. But in this case, dm-crypt sees a single BIO which gets split when
>> submitted to the underlying device. But the split issues the requests in
>> reverse order, which breaks write ordering.
> 
> I'd like to see verification of this.  People who send these kinds of
> odd old kernel reports tend to have weird patches applied to their tree
> as well.
> 
> Without an upstream reproducer that actually shows issues I think
> this can be safely ignored.
> 
Thanks for your suggestions.
I will try to make another patch of fault injection to reproduce it on qemu.
