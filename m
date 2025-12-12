Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013076.outbound.protection.outlook.com [52.103.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8246299947
	for <dm-devel@lists.linux.dev>; Fri, 12 Dec 2025 12:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765541496; cv=fail; b=Jdhl/rreLsMiOq2bUmVZX74Q4EOsQNBYqBKZVyVH3dK2s/IwjX88MJqPdQCVzzjXdtjmpKPHGjajQmCvzHrnWmwQaoTLpa1tzwN/TgpMPw+ok5uE4IE9zi2uwN2n+tVOaTJDsbsKO2fVdkAOaAnWptIVZC642CQK0awJCzJpHQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765541496; c=relaxed/simple;
	bh=ju27D7Ha7ET1mswZ/C77hWCOwtbQ4Bp8NjdNEAd9UKw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O03EgynfY/TQVpX50Isw8b87g4K37bAkPCqbmgyqsjF1SNhhNI9ckj4XUTm4jEJ5voU4jbIUc4BFlFx8CS7T9ykWpetzJq9W1z5QOazwPRQREVYgcU+D0anneiyfIDEEFfixqIL6XBhLbOGALPYXHjqLRMHp5UcJLxrHgh5N5wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=lPMj80aZ; arc=fail smtp.client-ip=52.103.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="lPMj80aZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OzoJfgsU9MY4zV7/0Vhr094bpbzbR/K8kKl3aAsw5dTgzNEeF4eAjUzoYcjXT5537rIoXXj7gLqqeBLf0mT/4UWgeiea3kMSULJUrA6YMbxNSp1wrWm1mkvXpWW6EYJeUNkuEeSQ3yFK/BRnZz0UybvBxDxj9z7se7AuEoNk2mt5LuSJFMOMXAmd6KgWXsch9f+VFKWKasptG5ooAmpIwCcZwrE6dFQm1xog1m2df/Yv9jrfE4OtH1f/XEv+kiTPpXpTcT15kJ2PxvNIx+B8qKvqZeGsGAw7UnReeid6BXco7lbh6VB0i+7+ll7NQjD7+4hxixOoocJ/LfJLGBfXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOx1Eh60iwklnJdi9xoDKu9crK/mzyO2UMH+uxQ1dWs=;
 b=SOXeIT+7PhiBK9Xybfnhz9+KSewbdFt3jdzXpm+tC/NQRKYaKeH3aiLzqAwYeimkLJSOXOfDPS991vS54oBT4Rm7d5e+N4e5fQ3sDXN3IKYltIj6Xt7AsfD2mMbBPHMygeSF54wNWvTUFQDarxvtCrXViyRSMHfEKKdGNjCnz5Jsy9gxwQDsHji/4ZNrz/uaMzkZBPuF4Dp472EQxraYmRklx/M3ryd+PNPkUVCUdR+57Mba8KI/T64qjFYQRM8J6vWF84b4tyLAyb3TwblLsRN4NY3CspkGNhwNB30z269wguN7BKP1f2tWeMzc1KJxqhVVHWKYiuXpyji+dQqdGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOx1Eh60iwklnJdi9xoDKu9crK/mzyO2UMH+uxQ1dWs=;
 b=lPMj80aZ0rPcGCxEwPvniHglTRazheDbs5UnDcVVB2MuHSUEcRf6Qm+pg2LJPqYo2YLjTLvOUiXJgd+mJ7KSrUXi8TocAQe8shKXa/OqO+mTYbzDAjxexmgcTanZrMaM+4tfYvbCLNRgLrY4kMo5zNsEsrQOui6C3cVRu/y1UFHKkmQV1aq+jX9yFQ2fQNkYBM4nmRr9c9U062vufqKuzA4qtq27t1xu/etYq2sv35m9/0KfJav3phNrpw13m7/sbrjps+aErb3MiGz2BcsKG4ZxGmgUT8UI/N76tzBUNc1SdLJnk1e67Fi6ObvPmAyfea4EKN8aqL9qJNWlfj37AA==
Received: from SI4PR02MB8696.apcprd02.prod.outlook.com (2603:1096:4:26c::5) by
 TYZPR02MB6336.apcprd02.prod.outlook.com (2603:1096:400:41d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.9; Fri, 12 Dec 2025 12:11:27 +0000
Received: from SI4PR02MB8696.apcprd02.prod.outlook.com
 ([fe80::5616:802:bc6b:aba3]) by SI4PR02MB8696.apcprd02.prod.outlook.com
 ([fe80::5616:802:bc6b:aba3%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 12:11:27 +0000
Message-ID:
 <SI4PR02MB8696CCE565CD51031376D43099AEA@SI4PR02MB8696.apcprd02.prod.outlook.com>
Date: Fri, 12 Dec 2025 20:11:22 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dm-stripe: adjust max_hw_discard_sectors to avoid
 unnecessary discard bio splitting
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Yongpeng Yang <yangyongpeng.storage@outlook.com>
Cc: Yongpeng Yang <yangyongpeng.storage@gmail.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251208100713.697542-2-yangyongpeng.storage@gmail.com>
 <aTkOIzJVOcEJB7SU@redhat.com>
 <SI4PR02MB869655E1A6EAD8A9462F432899A1A@SI4PR02MB8696.apcprd02.prod.outlook.com>
 <aTtQGwmfStMjR7xs@redhat.com>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@outlook.com>
In-Reply-To: <aTtQGwmfStMjR7xs@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0127.apcprd03.prod.outlook.com
 (2603:1096:4:91::31) To SI4PR02MB8696.apcprd02.prod.outlook.com
 (2603:1096:4:26c::5)
X-Microsoft-Original-Message-ID:
 <851ea881-b61f-4354-be8c-6723363c11d6@outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI4PR02MB8696:EE_|TYZPR02MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: da4ea95f-f95f-4f5b-a119-08de39779331
X-MS-Exchange-SLBlob-MailProps:
	znQPCv1HvwXZ5XHxNrJCjRnjimRBgM6SsI/AIVEJlhqjdtQLqOpCeH2M8UrAtHcB73PysiwDH34ZX2T1yY1SxOeVN2q21S8sqy+qBlErVtrp9k/+zSgfNXqm/Wygxfq16wgATfTLlGKauGi0pprgKKTo6lN2t2mIWJ6xatQV8Bn6UHsAuLk7jjGRhPvWSbeoY0gYUlVuUcDqYtZ6SFh/fp3jiaCgA3yx0n6+TEUx7K/YaM1EFI/0aCsqC4OJgcgqgZYzWtaY5EkmLrTwzc6tOQHPuY4MMdCk2bie/6LYgRCZCn+mEWhbDrPYJuYwBAEDRjkk9kWsu1PWGJPrkKO2KqvbukTKynz0iNvmSMBCLtXIDI7u2UEmb0ZAohAycLLxDvMQVIXWDyuON3ZuDmx9AE7c9vXTBe+u8lwzUzI8YcK5jk3Ipo4sYeXvbd3G+Te0l0K+yyDlewatUsRTIy3dVbJfeWDnenE2ra4yQnPfH9IFl8nXY38qbQ7GUbfubnslzWhycYHTnBSJuaCaumwb7BwveLrZZi3bog57e8Mhydps5gP2nHNnl0HB5UMW1AkWWp+wZuwqGdC/EIwvUeWHNDQoRQU9kpmp280aCsMhfVLoA4aOsM4EikmknGxmGUYeXX5sgk66nhALH2kk8VmUnbGiAopptwX36snXTE2g+8YhKFVbvfY7pOVOw8cUixCF5ExJfhRTavXdrXO3zuv5Twb478KE8xe4P7BPucQVWT77UPhFk0mM4Dklke9toazQAbjmJW/UOUI=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|51005399006|6090799003|5072599009|8060799015|41001999006|12121999013|19110799012|461199028|23021999003|9112599006|15080799012|3412199025|440099028|40105399003|3430499032|3420499032|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXJaMEFNVDdFMHA5eE1uRnVKMXh4VmcvVjJzbEZqNm12eXBtNGtvaDJiTXlW?=
 =?utf-8?B?Y2JvZTREZmtPUUkzSmo0ZHBFUnJlT094R2s1NkJGRitvZHhFK0E2ZllILzQy?=
 =?utf-8?B?Ung0WjdEZXZFeGVnYTZlY3JRSXM1ejJXZEZjb2oxV0JyQm9SNXEwSWpnVUZp?=
 =?utf-8?B?WXc1VGdyZWplVElvSXU0K0ZUWnM3TUNMb3JnaXBiRGZPMkZ4TnB4RjFEOHFj?=
 =?utf-8?B?eEsvTGlqOW5UaFZrVjdsYVFzb2dxOUtNS2RaVEJIS3QrcEYzNDFNZHBKb2pK?=
 =?utf-8?B?OFRWTVIzQ2N0M1UydG1qdmhCVlFxK1BoZi9nbmk0bmtkSERNcU5JSTNaQ2VB?=
 =?utf-8?B?bVMyTHRxVjBoTG9teEV2NGYwL2cyVk9CS1daNzZyWkxNMUJ0ZTlwWGk4djVp?=
 =?utf-8?B?bWJsKzVjclJrQS8wSnF0ckhiQ2p3NzhmaEwxOWhRQTBOK1JxM3Fza1F3dnl4?=
 =?utf-8?B?RWhlNTJjMmNKY2RJL3VwVHpGVUs1VXZ2VWgyN0dUT2VseTh2V01aUStic0tv?=
 =?utf-8?B?TnoxVHU3UVc2TGJnc0g5QnhjZjJjcDJGbVpaWnJIeVhaZHV3bldSS3FIWEVu?=
 =?utf-8?B?WDk3b0dJUmdhbytVYm13S2VyWTdjTExOOXlIQ0J4eXhDdTd1aTZMWnRDdWdB?=
 =?utf-8?B?SkF5eDlGYkUvZHZHV092TU9BYzZ6eVJXNkNNL21xVjAvVW1XUkZrS3g1Ympk?=
 =?utf-8?B?cGhLTWJIOTNQZTlCUEhNaHU5RVcxdm83c1gyamdZbDlqdTBkZkEwZmdpTERv?=
 =?utf-8?B?UGQ5d1l2WGE4QlRzK1VsbjFBc3ZhMkhQQ0hpamJWU1IvdzV1ZStYOXVMb0Mz?=
 =?utf-8?B?L1ZJanhEYzg1cEZPUisxaGxEb3lxR3VQTmpqK2hHNzhlVjhJMTNPT3FnMXFp?=
 =?utf-8?B?VmhEeW8zeDBBaHFPbVZwNVJMTVRZRXMvaWYvczJDTE9QZkdJczVkeEI1a2p5?=
 =?utf-8?B?TXRIZzUvcGQ2bXRpWWFiOXpoWVJrR01nYU1nMm9iaGwwMUhNN1F4NHc4bEVD?=
 =?utf-8?B?YUkxSkdsOG1TRFk2R0RXRExuOEpBMFY1M1dHK21xOHoxY3Q2RVc4SVdUV2t3?=
 =?utf-8?B?MEVMMG95MFkrWXY0SDFMemZzK3FKak1PTDB2dEZVbFZ5bDVia3RLOTQrZ2Fk?=
 =?utf-8?B?OHFDdWFwQThRQ2hQSTJMQWJ2dldtTGZ1NXJDZzFRYjRhZ1o1V050ZXl1OGhh?=
 =?utf-8?B?cE5DYU9qM2NIVnEvSjBhUE5WQ1FsZUx4ZCswdWoyU0RWR3hDTHhPUEhEdE1E?=
 =?utf-8?B?T1FLR2w1K0dVdmNLMnJUYjZ4aEZjWmJubndEWkJQcjdKRUdtUlZZdUROYW4z?=
 =?utf-8?B?YVRCaHF6NHpVSjRvaFJmSTFzWVZkSlpPY1hLcVhOdHpnem1MK3pRMmFNWnUz?=
 =?utf-8?B?eisxd2JyeHQ0ZUhSYUdXN2UybnY4QjNBN2hFakxNSWJuNW5XTnJMQ3FMNTNl?=
 =?utf-8?B?ZlpiVHhScVlxa3JZYmJFVmcvend4MlhrK2pRWmlYWWNoVEFhRXRCWDdjbWds?=
 =?utf-8?B?UHh3Y3E3NWVMWVpFYStNMjh6TTZyYzlGbGxsdWk3amxMNXpNdFBmWkJwR245?=
 =?utf-8?B?VGRCR25aWHpFaUtjTXFzV3FjcVlISHlzc2ZLMlkvdU9IMTROZHdTWHY0RTR6?=
 =?utf-8?B?YzRxYWhKT1I1SDQrMHlCOUxQb21RTEg0VXZzelVNS2pPZWNzYnZkVy9PVmNH?=
 =?utf-8?B?YVVQVW1IT2RUQURSZ2gvczg1eW1TUW1nZms1Q1diK2dWclV0L2h0SFRnMDFI?=
 =?utf-8?B?MnEvdU1Db2Y1TysyTzlXbmo1RmgzbE1HSWpDRGh3QjhPWnJ4OTRVNHd2QnhD?=
 =?utf-8?B?QUFDNEJXcXJITGdNemNlZz09?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVErbmJPVGV6Snc5QlIyWTVLVnFmN01ieFhVbTlYSUlaNDQ0Y2I4T3dVczgx?=
 =?utf-8?B?aEhnbjJFcjduSDBiRC83MG1MY1QwSkJna2J5Rk45TkhPZ0g2cDMxbTVTS1g4?=
 =?utf-8?B?NTZlV0xoL1JlcGthb0dzellvd1ZUS0cyaUVFQTVBaittNHVmTHlwSnJjZUVM?=
 =?utf-8?B?djNLdmtnYTQzbUE5Z0x1WTJza3M3dTQ4K1FmdFdHS3JzVFFxcWZSUnZkVEl1?=
 =?utf-8?B?eDJaYXJNdi9yK3VRWTBVd1hObk5IVXVFVVA0K2RnSGRWTEhlS1VPblk4Y0hZ?=
 =?utf-8?B?VTVBRGR1WlFrNlhEMmVBaE0vaFBEak5wOXE2bHloNkhMemFKdW1pMzlEdzZz?=
 =?utf-8?B?Yk9OTUFwalljUmE4TWlyOXZsN3BYN09palJiRUpOVVdnQnVFRDUyVlJwaXlh?=
 =?utf-8?B?MWZIUm1yZW8rQi9WSWRIMmtjSnZuTjhzcS9xN1VBbnRSM2lvenZCSW1tN25O?=
 =?utf-8?B?OGVaRkhQa242b21aR0t3YTZSRzZFcHlHck9GR3BiMmRMdytPMkFjVUJPMXg4?=
 =?utf-8?B?QVNyRGtUS2lqS09wQS8ySVBWTVkxUGZFb2R3YW5RdkoybHRma3ZWb3c0Yy9B?=
 =?utf-8?B?Y2QxVElWNlBrd3BUb1NuNEpqV0FmTXBQOWxyT1REZzRpU2FzMFZZOEo0Ykt0?=
 =?utf-8?B?NUZENnVtN2Z5dlFJOUc2SXB4RnZqNmttdjE3dFBJeStvNDFaV3VCL2wzMmtL?=
 =?utf-8?B?RGRBNGVKS2NWN0ppOHVhNjMyQ3d4Y0hIU0xhcEo2THo1eHdud2ZIS0p6VE96?=
 =?utf-8?B?QXZSVm1heEZVQmpVNWhNQm9mbFR3dW5WSlJSQ0x6ZjNJNmwxQmEwSy9jdDVJ?=
 =?utf-8?B?Vk1Md2ZrVmFNRm8wbGdFblB6TkRZS0IzdGROMG9DcTExTUZsaGJ5QmRLUnRo?=
 =?utf-8?B?TWs5TEFVb1NGQkxpcVFORnhKZzhmdlV3emNMZE1zNkF3WWFzbythNzNGU0Mw?=
 =?utf-8?B?SUxtVlJmNUJIcS93WnNWbjNKOUFDR2NZc0J6TzlyLzVvcy9VVEwzTWxVckdG?=
 =?utf-8?B?eENuVEcwWmY5UXN5bStoMzdqcnh2M2htMHh3VlRwVXF1bTA5WXlYRVkyYVdB?=
 =?utf-8?B?d3F2dktGV2dlY01GdWFyNFhDTFp0bldBMEplR1VYeE04MURMd2RQdVk0dkJL?=
 =?utf-8?B?WUxRbDlqb1lORXRiQnE5NWppQUs5YllaZXQ3Zzl1WURFNzQrWExMZEkyb2JG?=
 =?utf-8?B?QkJ5OStjNkxEOVN3UDZBRlNaclg0ZHV6WXJSQm54dlM1a0psTzdDdWdnQmFP?=
 =?utf-8?B?WWlBWmVqNkFva0tvMTBNSEZPQzJJb2pmRXpZTUVsTnhubVYzTTJyRUQ3MWx3?=
 =?utf-8?B?K2pQbmJacFpTY2Y5ZnFSK0hsUmZpZmFkakU3SVo4U1dLNG8ySW0xa1JURkVQ?=
 =?utf-8?B?aG1TNGhheVBzcnlLdDlJVTRzOW02YVY4aTVLRGIrVDl5ejd0bHN5N2psMXdU?=
 =?utf-8?B?Ym56L1o5TUl4RzNKcWUyYzJLeFZJakhVdkRkYWZhZGxoR2VlR2phTENJQU5M?=
 =?utf-8?B?L0FJMVVmZkFVT1NuaC9xUW9RUlhsR0N5WStoOUhaZTdvVUJFOHY1Q0s0cklk?=
 =?utf-8?B?UmlhWHVwUEN3SWZkM2ZYVXV2QUVjaGp2OEVWM2xZZm1pNit1OTUwNXUyN3JK?=
 =?utf-8?B?aG93M0MrYkVrellEMzIxei9IdmFIMkp6RTZwSnUyNnlHUjJVRHlKa2VwZXJS?=
 =?utf-8?B?VXRKTlJNZnZRR3B0azVER01EaTZrekxDdldweGNVcnphUWV1R0czczZBPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4ea95f-f95f-4f5b-a119-08de39779331
X-MS-Exchange-CrossTenant-AuthSource: SI4PR02MB8696.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 12:11:26.8794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6336

On 12/12/25 07:13, Benjamin Marzinski wrote:
> Resending, since somehow, I didn't reply-to-all last time.
> 
> On Thu, Dec 11, 2025 at 03:03:12PM +0800, Yongpeng Yang wrote:
>> On 12/10/25 14:07, Benjamin Marzinski wrote:
>>> On Mon, Dec 08, 2025 at 06:07:14PM +0800, Yongpeng Yang wrote:
>>>> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
>>>>
>>>> Currently, the max_hw_discard_sectors of a stripe target is set to the
>>>> minimum max_hw_discard_sectors among all sub devices. When the discard
>>>> bio is larger than max_hw_discard_sectors, this may cause the stripe
>>>> device to split discard bios unnecessarily, because the value of
>>>> max_hw_discard_sectors affects max_discard_sectors, which equal to
>>>> min(max_hw_discard_sectors, max_user_discard_sectors).
>>>>
>>>> For example:
>>>> root@vm:~# echo '0 33554432 striped 2 256 /dev/vdd 0 /dev/vde 0' | dmsetup create stripe_dev
>>>> root@vm:~# cat /sys/block/dm-1/queue/discard_max_bytes
>>>> 536870912
>>>> root@vm:~# cat /sys/block/dm-1/slaves/vdd/queue/discard_max_bytes
>>>> 536870912
>>>> root@vm:~# blkdiscard -o 0 -l 1073741824 -p 1073741824 /dev/mapper/stripe_dev
>>>>
>>>> dm-1 is the stripe device, and its discard_max_bytes is equal to
>>>> each sub device’s discard_max_bytes. Since the requested discard
>>>> length exceeds discard_max_bytes, the block layer splits the discard bio:
>>>>
>>>> block_bio_queue: 252,1 DS 0 + 2097152 [blkdiscard]
>>>> block_split: 252,1 DS 0 / 1048576 [blkdiscard]
>>>> block_rq_issue: 253,48 DS 268435456 () 0 + 524288 be,0,4 [blkdiscard]
>>>> block_bio_queue: 253,64 DS 524288 + 524288 [blkdiscard]
>>>>
>>>> However, both vdd and vde can actually handle a discard bio of 536870912
>>>> bytes, so this split is not necessary.
>>>>
>>>> This patch updates the stripe target’s q->limits.max_hw_discard_sectors
>>>> to be the minimum max_hw_discard_sectors of the sub devices multiplied
>>>> by the # of stripe devices. This enables the stripe device to handle
>>>> larger discard bios without incurring unnecessary splitting.
>>>>
>>>> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
>>>> ---
>>>>  drivers/md/dm-stripe.c | 16 +++++++++++++++-
>>>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
>>>> index 1461dc740dae..799d6def699b 100644
>>>> --- a/drivers/md/dm-stripe.c
>>>> +++ b/drivers/md/dm-stripe.c
>>>> @@ -38,6 +38,9 @@ struct stripe_c {
>>>>  	uint32_t chunk_size;
>>>>  	int chunk_size_shift;
>>>>  
>>>> +	/* The minimum max_hw_discard_sectors of all sub devices. */
>>>> +	unsigned int max_hw_discard_sectors;
>>>> +
>>>>  	/* Needed for handling events */
>>>>  	struct dm_target *ti;
>>>>  
>>>> @@ -169,6 +172,8 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>>>  	 * Get the stripe destinations.
>>>>  	 */
>>>>  	for (i = 0; i < stripes; i++) {
>>>> +		struct request_queue *q;
>>>> +
>>>>  		argv += 2;
>>>>  
>>>>  		r = get_stripe(ti, sc, i, argv);
>>>> @@ -180,6 +185,13 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>>>  			return r;
>>>>  		}
>>>>  		atomic_set(&(sc->stripe[i].error_count), 0);
>>>> +
>>>> +		q = bdev_get_queue(sc->stripe[i].dev->bdev);
>>>> +		if (i == 0)
>>>> +			sc->max_hw_discard_sectors = q->limits.max_hw_discard_sectors;
>>>> +		else
>>>> +			sc->max_hw_discard_sectors = min_not_zero(sc->max_hw_discard_sectors,
>>>> +					q->limits.max_hw_discard_sectors);
>>>
>>> I don't think any of the above is necessary. When stripe_io_hints() is
>>> called, dm_set_device_limits() will already have been called on all the
>>> underlying stripe devices to combine the limits. So
>>> limits->max_hw_discard_sectors should already be set to the same value
>>> as you're computing for sc->max_hw_discard_sectors. Right?
>>
>> dm_set_device_limits() initializes the stack-local ti_limits defined in
>> dm_calculate_queue_limits(), and stripe_io_hints() modifies this same
>> variable as well.
> 
> Yep. That's why it's o.k. to use limits->max_hw_discard_sectors in
> stripe_io_hints(). dm_set_device_limits() -> blk_stack_limits()
> is called on all of the underlying stripe devices before
> stripe_io_hints() is called. blk_stack_limits() includes the line
> 
> t->max_hw_discard_sectors = min_not_zero(t->max_hw_discard_sectors,
>                                          b->max_hw_discard_sectors);
> 
> Which updates ti_limits.max_hw_discard_sectors. ti_limits is then passed
> into stripe_io_hints(), and has the same value that you compute in
> stripe_ctr().
> 
>> These updates do not affect the stripe device’s
>> q->limits until dm_calculate_queue_limits() later calls
>> blk_stack_limits().
> 
> Actually, we don't update q->limits for the stripe device itself until
> later, via __bind() -> dm_table_set_restrictions() ->
> queue_limits_commit_update(). But we're not checking the queue limits of
> the stripe device. We are checking the queue limits of the underlying
> devices. Those devices are completely set up before we create the dm
> device on top of them.
> 
>> Therefore, the q->limits.max_hw_discard_sectors of
>> each sub device in a stripe target is never modified and it is necessary
>> to record the minimum q->limits.max_hw_discard_sectors
>> across all sub devices.
> 
> You are checking the same underlying q->limits.max_hw_discard of
> each sub device in stripe_ctr(). stripe_ctr() is called when we set up
> the table, well before we call dm_calculate_queue_limits() as part
> of making the table active in dm_swap_table(). So if the
> q->limits.max_hw_discard of the underlying devices is correct in
> stripe_ctr(), it surely must be correct when dm_set_device_limits()
> is called on them.
> 
> If you don't believe be try adding
> DMERR("%u vs %u", sc->max_hw_discard_sectors, limits->max_hw_discard_sectors);
> 
> to stripe_io_hints(). It should show that they have the same number. If
> it doesn't, I apologize for all this noise.
>  

You are right. I was mistaken. Thanks for the patient explanation. We
don't need to add sc->max_hw_discard_sectors.

>>>
>>>>  	}
>>>>  
>>>>  	ti->private = sc;
>>>> @@ -456,7 +468,7 @@ static void stripe_io_hints(struct dm_target *ti,
>>>>  			    struct queue_limits *limits)
>>>>  {
>>>>  	struct stripe_c *sc = ti->private;
>>>> -	unsigned int io_min, io_opt;
>>>> +	unsigned int io_min, io_opt, max_hw_discard_sectors;
>>>>  
>>>>  	limits->chunk_sectors = sc->chunk_size;
>>>>  
>>>> @@ -465,6 +477,8 @@ static void stripe_io_hints(struct dm_target *ti,
>>>>  		limits->io_min = io_min;
>>>>  		limits->io_opt = io_opt;
>>>>  	}
>>>> +	if (!check_mul_overflow(sc->max_hw_discard_sectors, sc->stripes, &max_hw_discard_sectors))
>>>
>>> sc->max_hw_discard_sectors should be the same as
>>> limits->max_hw_discard_sectors here 
>>>
>>>> +		limits->max_hw_discard_sectors = max_hw_discard_sectors;
>>>
>>> I see a couple of issues with this calculation. First, this only works
>>> if max_hw_discard_sectors is greater than sc->chunk_size. But more than
>>> that, before you multiply the original limit by the number of stripes,
>>> you must round it down to a multiple of chunk_size. Otherwise, you can
>>> end up writing too much to some of the underlying devices. To show this
>>> with simple numbers, imagine you had 3 stripes that with a chunk_size of
>>> 4 and all the underlying devices had a max_hw_discard_sectors of 5. You
>>> would set max_hw_discard_sectors to 5 * 3 = 15. But if you discared 15
>>> sectors from the beginning of the device, you would end up discarding
>>> the first 4 sectors of each underlying device, and then loop around
>>> discard 3 more sectors of the first device. This means that you would
>>> discard 7 from the first device, instead of the 5 that it could handle.
>>> Rounding max_hw_discard_sectors down to a multiple of chunk_size will
>>> fix that.

Yes, Rounding down is right, I'll fix this in v3.

>>
>> The splitting of discard bios is based on limits->max_discard_sectors,
>> which is independent of the stripe size. As a result, the discard bio
>> size passed to stripe_map->stripe_map_range() may exceed
>> `sc->chunk_size * sc->stripes`.
> 
> Of course this is true, but my example still holds if you had a
> max_hw_discard_sectors of 9 instead. 9 * 3 = 27, so you would discard
> the first 8 sectors (two chunks) of each stripe device, and then 3 more
> sectors of the first stripe device. This means that you would send a
> discard of 11 sectors to the first device, instead of the 9 that it can
> handle at once.
> 
>> In the example above, stripe_map_range()
>> is invoked three times, and each invocation reduces bio->bi_iter.bi_size
>> to 5 sectors for each sub devices.
> 
> If it did that, that would be a bug.  You were intending to discard
> the first 15 sectors of the dm device, but instead, you would be
> discarding the first 13 sectors (0-12), plus sector 16 and sector 20.
> 
> It's easy to test my original thought experiment using a scsi debug
> device with a discard granularity of 1 and a max_hw_discard_sectors of
> 5, and a stripe device with a 4 sector stripe size. Here's the test:
> 
> # modprobe scsi_debug dev_size_mb=128 max_luns=3 lbpu=1 unmap_max_blocks=5
> # echo '0 786432 striped 3 4 /dev/sda 0 /dev/sdb 0 /dev/sdc 0' | create stripe_dev
> # blkdiscard -o 0 -l 7680 /dev/mapper/stripe_dev
> 
> And here's the perf results:
> 
> block:block_bio_queue: 253,1 DS 0 + 15 [blkdiscard]
> block:block_bio_remap: 8,0 DS 0 + 7 <- (253,1) 0
> block:block_bio_queue: 8,0 DS 0 + 7 [blkdiscard]
> block:block_bio_remap: 8,16 DS 0 + 4 <- (253,1) 0
> block:block_bio_queue: 8,16 DS 0 + 4 [blkdiscard]
> block:block_bio_remap: 8,32 DS 0 + 4 <- (253,1) 0
> block:block_bio_queue: 8,32 DS 0 + 4 [blkdiscard]
>     block:block_split: 8,0 DS 0 / 5 [blkdiscard] 
>  block:block_rq_issue: 8,0 DS 2560 () 0 + 5 0x2,0,4 [kworker/5:1H]
>  block:block_rq_issue: 8,0 DS 1024 () 5 + 2 0x2,0,4 [kworker/5:1H]
>  block:block_rq_issue: 8,16 DS 2048 () 0 + 4 0x2,0,4 [kworker/5:1H] 
>  block:block_rq_issue: 8,32 DS 2048 () 0 + 4 0x2,0,4 [kworker/5:1H] 
> 
> As you can see, it sends 7 sectors down to sda (8:0), which is too
> large, so it needs to get split by the scsi device.

Yes, my previous calculation was incorrect.

Thanks
Yongpeng,

> 
> -Ben
> 
>>>
>>> Lastly, if you do overflow when multiplying max_hw_discard_sectors by
>>> the number of stripes, you should probably just set
>>> limits->max_hw_discard_sectors to UINT_MAX >> SECTOR_SHIFT, instead of
>>> leaving it at what it was.
>>
>> Yes, I overlooked that. I’ll fix it in v2.
>>
>> Thanks
>> Yongpeng,
>>
>>>
>>> -Ben
>>>
>>>>  }
>>>>  
>>>>  static struct target_type stripe_target = {
>>>> -- 
>>>> 2.43.0
>>>
> 

