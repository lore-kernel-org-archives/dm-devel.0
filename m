Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FFB2D63F6
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760516294; cv=fail; b=bmE3vyuQZMo5L3Q94yaHdp/6WNPStA4DvuOdd26m7c2HEfZ1yX3L7mo/rVPYXVZHP3jwmleb81gjOCe+S8U7sHbUcSquPsQnxa+DHnOvEsB4GQUpAbd3mZrcqfzbL5IsbQqNGPIVOKwXiNLN/gEaMT4HXbIG8md2D+XK0CDDImM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760516294; c=relaxed/simple;
	bh=FIes+g0MSynSkv6PUq24nw4utp8YBUzD4ixgR6tmQog=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N5rNbcEC8haXxI5pI15mvfmIcBgUYl7F2ESt5+Iwmv8lx+uDcds5NGDPkzxys+4Y2JVfJ9OephBPNp2B2dhGHJk4bF0jT1rIsa6BNkU6VwoqS6phgRrJX3FOTq4Kb337WvZtL6Sv/ThxYYUXez1UfQUfU8XcM+b8X1IQUfvMbQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=st4WelTB; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="st4WelTB"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59F5ofSP269457;
	Wed, 15 Oct 2025 01:17:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=9u1qmj8xOKRWkbKb/vIKHg5l8oJdWPLGeGURW9YZOhA=; b=
	st4WelTBvAdqMjMvqjQxbZ6xaXnW5Qlw2f1LH/9ZIYlwwnuf0mRy+eA1X6oJZOQb
	eXpg66jsF3BqSjUNmXL3maDKZXY0Gz7XyLd333GbAY8MgYp6+LIxDqW/0ZrvmjKo
	y6ViMN6gcpAoF05MAL/xcHT7fz9b9OjSYgdPoNH1frg6tJTkjwG8aPaLBy0Qqliv
	+wGmGdQa6QGlUbJkn3hY8j8HYiBKrIlhGEZ6mSncg+Lii72BGIZd1EmJr6V0zSG6
	SUnVwFTsBK3gIFe4cwPCru79xpoRdShK+TH8O3i98sgs2VmfB0fD9H0FoIiEecqk
	uBh8HL25yfGWss0FKOcrBw==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010000.outbound.protection.outlook.com [52.101.85.0])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 49qprdv8q6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 01:17:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aE1p61tnaBAsQqzOvuGx6qkYoH+BM8fRJnIs+A4m6rj8HJARqSVwDvqXI0++39QUSR78zQ37M0jXP+TCjRHiFS90OcwEqtox8rQur8G3dkUyzmy/roDth8isBG8mIuUBbDafn1A3e5BG8AC0168Zn2nxQ717hoLolTmGNvH+YliSJQ3Bq2a3ah1PhIuoNbiezzR+iJMfH6gfFrWlGMSrXGjq7VNjo1Ub1dtPk1YJdNsdBSTcThgzceyS5q5p3j+45Am2s1EWmxIiOTY6p9SQ6UcROWQLSna6XugLvBgXkZgPNQEk+wifKvkHSNM3suGt5/nKIcxoyhFA6qdxqslu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9u1qmj8xOKRWkbKb/vIKHg5l8oJdWPLGeGURW9YZOhA=;
 b=NWVnqJs8hhNYJfv+i2ga2SsQzWvN+UxXULgZRoJvEexKJOfuN1k7a8YXWaBLY2QTgWn7Wks4dAcNmphkJQkM1EFPx+KqihfOuiqBDZmAQpy207vtP7Jh3nOysIF+San3/y8+15U3rq1XqX5B2nTH4UO1QT5w6bwAmYbNFN1WJKUjxMo39mwpmHX14hk8OD2pDzsZvxY6Ew82Nw92ybp3edw9Cxs2qzusVKc6caAM+GEVmyqm8c385rix7qjfHKdeS0MoW0k+4u45wNgOpuhWqDZ0tyfsycN3HBR75JIA6k8LYRb1aRjR+Hws89kWEj2khDgr1YXF0fgyRkXN9sQsQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::81d) by CO1PR11MB4980.namprd11.prod.outlook.com
 (2603:10b6:303:98::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Wed, 15 Oct
 2025 08:17:49 +0000
Received: from SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
 ([fe80::5cd3:aaa1:1564:3e48]) by SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
 ([fe80::5cd3:aaa1:1564:3e48%5]) with mapi id 15.20.9228.005; Wed, 15 Oct 2025
 08:17:48 +0000
Message-ID: <b7e58c57-12be-47d6-beae-aa70568bfcc4@windriver.com>
Date: Wed, 15 Oct 2025 16:19:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: fix rcu protection in md_wakeup_thread
To: Yu Kuai <yukuai1@huaweicloud.com>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20251015055924.899423-1-yun.zhou@windriver.com>
 <86705912-07a3-4a24-bacd-ad5ac2038201@molgen.mpg.de>
 <d2574af5-9410-d296-ef74-97f3e43dc1cc@huaweicloud.com>
 <040131e6-08f7-4f64-a317-deaa21e1a5e1@windriver.com>
 <e60b45da-e37d-5530-1511-f6e56effebb2@huaweicloud.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <e60b45da-e37d-5530-1511-f6e56effebb2@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::14) To SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::81d)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF2F7FC4EE6:EE_|CO1PR11MB4980:EE_
X-MS-Office365-Filtering-Correlation-Id: 317a9312-81b2-4838-9e84-08de0bc353d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3hUNnljS2ZMRUJya3UyRnVZbHB5SnU2QStvV1JuK0FpWVNQUUYxd1ZRVlJ2?=
 =?utf-8?B?cmRtLzMvUEJPdE1NZEdxWVFhVkJiRlNjQnFiM0FUaWk5NHo5VVlOYUZidlJF?=
 =?utf-8?B?V29VcUx4ZnY0RXJwUlJrWkFCbE5jbGl6dTFyblZGYVNJRW93VVFJeDFYLzJ3?=
 =?utf-8?B?VXJPV1kvSHQ0d0lCOGZON0VoU25oZmNYM3VFZmkyRk84SVF5SWpFSE01eUJB?=
 =?utf-8?B?bjl2cjl3UFdLVndFN1BnQnRKdlZMR0ZrWStRM2xSWGNwNVYzRnFPS1ZENSt2?=
 =?utf-8?B?V0JCN2J1aWhTdklhd2pycHFMSndCaTcwNDVkaGVkbWlZNTREektNL1ZNYTdV?=
 =?utf-8?B?Z3E0T1pZTUpGdjRNL1B5cGhXOVk3ZXVIbS9veDJIYlhUaU5nVittM091dENN?=
 =?utf-8?B?aUp4WHF5K1EzT0taMzVyaURCUlZhUmpJbVQyNWt2QXd4RUtMNkl5dUVvZjgw?=
 =?utf-8?B?V2p0bkxYSG5QUldkekxpQkFCUE5WUjZkNGpsc1ZHc2xFb09JRXZaZG9YZmdU?=
 =?utf-8?B?S05QdmZDL1RjWGFZVnJUNVp6b1Q3UG94bjJ5a3RCVy9OQnN3Tm1kN1R3SklQ?=
 =?utf-8?B?RWxPczZxdWtzSFNmVW1JUnY1Unh3UjI5UnJvLzFIZkhIb0puRlJtODFUQ1ZY?=
 =?utf-8?B?d1I5NFNLbW1iUWN1ZGxBazJlV2IzaXMxb2k5MmJzV0JvbHFxdWw2c0dML25x?=
 =?utf-8?B?bXEwa0s2cHArMXAzVTArQnlQa2VWMXZRcEQ0cEozaGtBY2kyL0o5bGpVNHFY?=
 =?utf-8?B?VFdheHdvRHlYVmlidWtJeWxtazVPN2hmQWl6dWRUNXNDYy9yMFpSK0dGUDVN?=
 =?utf-8?B?UXlBeGxNZnpRSnNXclJDYTdLbXpxd29QaS9kSHl3UkxsZFNxTW1aWWQ3aXZI?=
 =?utf-8?B?anVBREhZSXFrUXF5WmloTEZNWnhJWkVpUEVFK0dnaU5lZVhCaVZkRlpIWVdn?=
 =?utf-8?B?SHZkYk8rS1RWbkhiSjJGUlQrY1VVdkJHeVlWTjM2Tmh6VjRLMjFsMThoYmx6?=
 =?utf-8?B?eENIbytpMGdaUW5Cc0FJK1hwTXA5Q0g1SkRFT0tGZ3A5V04zaC9ZamY1bkJ6?=
 =?utf-8?B?QmZPRTNRcm05VVVMYzVITkhweTJLVnB4RXRpNlJjNnA4UGdQVzI3bkZ4c2dw?=
 =?utf-8?B?NjU3S0lneENWS0lkeEc5Z3JxMEZ5bCswZk54RzdJMWI4N015M2pFc0x5YmR1?=
 =?utf-8?B?YWFoV1VPbS8reEVra2VmZDcrM2FiZTVPcU8rRG5qRDh3dU1UazRzWFFYRGxL?=
 =?utf-8?B?UzBPdTV1NmtzRmxXcU1uN1o2dGNVNkNtaHJNQVJ6cFVEcE8zTXZ3eXZUN0dH?=
 =?utf-8?B?ZzZnQXFxWW11Y0pmRFVHd3VRbGJleVljbytMcWIyREpwQUhYS2gxb00xOHZu?=
 =?utf-8?B?dnpEb0NPM2xSblN3QmRTU1RDQ1QvaWZ2aTYxS1BtUW1BRTRBOVpVSmNLUExs?=
 =?utf-8?B?VUoyQkU2ZXdQblgyNklIYm5VMVdsSWhsZHN5WndMUzhlMG9hS2M0c1laOUZj?=
 =?utf-8?B?MTVKM0NsVXRYQUVrUkxrNzQyNG5wWWdyOVpvcldmeThpN0JRdUcwVndtcVlV?=
 =?utf-8?B?Wk9ybU96U0ZZdE5qVWw1MGVYak85ellISTBSQVdJWk5pTTVHVjZ0M2RTWW12?=
 =?utf-8?B?Z3lFRjQ1czBDZVhLZW44UnJCS0ZWQ1BNMmVobjNSc2t3dEFjVWszcVF5QTZW?=
 =?utf-8?B?Q2J3VnhISGxWS2daeXdkdEdhbHVHWkVUMVpNekJoT3FQQldDeGpnNXNkazU2?=
 =?utf-8?B?bzI1OWJxM3hPL0FYTGgyZVVOVS9yUEIrVVEweXVxbGcwc013SzVXaUdTbGh4?=
 =?utf-8?B?TXZYZkVaT0JDWldDQy9kVzVyK0pybFFqSTd5V3VmWFZwQTdDbnRqVlVFOWZL?=
 =?utf-8?B?VGVoTktzc0xKMHM2YUZRZUd6eXpFRUtjd3VwNXlVVlI2eUJOdnRMWXJNanRE?=
 =?utf-8?Q?ETbx7Ld4uESZvbPrUcOhx7Pu/m03Fagn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bDJ4TXpvb3dkSjF6cEJoZEVDbCt2TUxQUW1GYkVMWDVIUCszd21RR0NXa1gw?=
 =?utf-8?B?OVRoYy9JYmR2b0lvTm02WVFLT3R0VmhPY3Q5K2tIYzFrNEQ1SHg2TVNWR0NF?=
 =?utf-8?B?S2JxdDRkazFNQW9ZRnZZQmhQZS9rZ0N4TjZSb1JTSmJUcFA1U1BJMm9kM2Q1?=
 =?utf-8?B?U0VHeDR6a09BRXdlMnVkMUNpeHg3SHlsNjY1NlBUWmNLUG45bm4yM0lodTFo?=
 =?utf-8?B?MDFhTUZyaGNzdmJTOVhmbEJCdU5xMnhVWkNZa05wdWFlMUVKdUpYdUpEWkVP?=
 =?utf-8?B?ZElxa0pxK28xcEs5WGttUldjL1hDa0lhcCtRbmViNjV2RGF6K2cvYlk2UnhZ?=
 =?utf-8?B?TFlwS3cvRXJmb000Mm5lTHB5QnlxQlFoa1M0ZzR3TnExajVRclg1QkgyckFk?=
 =?utf-8?B?LzRoT3lDdDVhZ0tGSGQrVWtTcy9sR25uUHFHcVh1cDRORHUvMklNR1hBN3kv?=
 =?utf-8?B?eFdaZ0dBZTViUXRjenpvT09PU0xsSFI5SWRlZzQ0T01IRkFZM3BXSElWem9p?=
 =?utf-8?B?ZktENTRidzJoQlBKNWZnbEpPOGxseFhTZjE4by91WXZJNjArOUtLMzc2L1lN?=
 =?utf-8?B?bVBYaVJsT0hycU5FbXBiU3R5MU1lc2Iwa3ZGaVNDdFJlY0FmWThDMHgwbEh1?=
 =?utf-8?B?Y3ZUYnY2aEwwRVp5VEJSaVZSb1R2d2hza05KZWJ4eHlMNzZBcmtuTVdCQnBC?=
 =?utf-8?B?ajNaRWtzemM4aHhDbUlsdTd4QTJPd0pkV2pROUxMdW5VUTZkL0MzQ3RqaVJV?=
 =?utf-8?B?MkRPanFkZWErZ1dJNTh2aXJ4Sk5tbXhPODMvaFJxWk9INlRkbjFPMm92TkVI?=
 =?utf-8?B?TmFRUE53cGwyU1JvQTVqMEhwZzRHN2grbXRXWWw4dnFNREQ3QlFzMktBYXZj?=
 =?utf-8?B?MWxpM1M5V1pMN3A0c1JEQWxWNGJzUUdlYVZEVEY1ZU1Td211Sy9nZVNzYnBZ?=
 =?utf-8?B?WSsvOElVbWpnSUkyL3Y2Nlh6ZnhvYm8vVUZhTkpEOWdBSDhFV2RPS2Y4TGZ5?=
 =?utf-8?B?V3BSb0NTME83aWQ4K3kzSzV4c3BPaEJGc0lZazRxaExOVERDVjZZWU5uaDIy?=
 =?utf-8?B?TUtGb2hOcDVKdjZrcFloVnNRLy92ZndUakhlb3hpMURUaXpVM09BZWtKalFZ?=
 =?utf-8?B?RWZTMGVZVXFNTkNNVFhGSXJIRm1TU1k2U3VYUHRuMEdaYU83UzRnVjlWcTNQ?=
 =?utf-8?B?T1k2WlhnSmZiYjIzZUpiMUhkSUxtR2tNeHI0ZzlDUi9yMksvd0wxd3k4amNj?=
 =?utf-8?B?RTlNc2RwamdWTWd1bDJBQVZCZExUZ043M0tvNm53djBDU3dxVnlkQTUvejNV?=
 =?utf-8?B?THlUbmh5SVM3VmdFWS91cnMxOW5WZUc5azBNVk5OZnpCdWxubm9FK1FCalRq?=
 =?utf-8?B?cy85a2FMQmNZSHEvTm4xeWR3c0MwNjh4cC8wU2RpemhyejI0azZHcVhRUkZQ?=
 =?utf-8?B?NW5aRm4zYzZ1VjJrT1hTQlg1elBrME5OQldMckpGMm9rTnpZenA0clJtOHZz?=
 =?utf-8?B?N1ZBMDVKUC8xcVRjOWlKaG9PS0x0bUtsekdjVE9DcEMxSCtKMkRoN1pOM015?=
 =?utf-8?B?dFJENUlnQjVkTnl0RHBrNHZObkkrSjNxODhWZHF1R3A1ZldXakJkN3Vna1Bm?=
 =?utf-8?B?aHd0RThGclg0ZDEvUnNqSy9PWE9rTnREOTdxK3VxcWIzSFFwaGpLS2wyWTNq?=
 =?utf-8?B?a0RmRHV4dlRoVXg3Wk14Uk00V293emJHeUVQQ005RmxCUWhwM0VxQWhDekVy?=
 =?utf-8?B?RjBXQVVJQ2xDb3NOZDJTNFd4OXp4WEdoTW1NTmFRZDZEOXlmZjEwdFpZbzM2?=
 =?utf-8?B?ZFhvbDY4Zytyc0Z5VmpVdU5XWWRnUkZMU0R5ZUpsQlpGWWszb095Mm9Pb05Z?=
 =?utf-8?B?OVhuUytYcXVNRm9hNXhiaXdSK3BqK1pXUGJRbmxlbG5objBIaXROSVl0WkFQ?=
 =?utf-8?B?cDdnb3dGSU9GWTd0Z2taS1Q5YkRpZ1hIZWpWc0FBTmEwZWo4bG5TUlNLcnlj?=
 =?utf-8?B?SWdxaHRIQ216SkhGVnFNU1JHQmJaMVdweWYzWEluaFVBWHlKZGhTbjNDdW9I?=
 =?utf-8?B?R1Vrd3JlT0QzQ05hbFVIR20wLzFOV0tEaVhpN05rMU85dWpidzZLNGpXNC9Z?=
 =?utf-8?Q?xXvxhu9Sad6/QBb0rNq2X8d45?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317a9312-81b2-4838-9e84-08de0bc353d1
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 08:17:48.9143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RanB787wsdDZEIrHDnhZq2Hd552DJBpuxzxSiYmmJ6H99+5P/SGpovsICzeOUqh46EMOElVvezmGiKdJSFd8Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4980
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE1MDA2MiBTYWx0ZWRfX4Xdn74WVu+PF
 t7tmhGvxmv9eAYQgqan/s/EJS6PKhcwkiGiPK9z3ifkpYOwkutPVbCPjJ91nOhbCeGVGUzGV9Jh
 iuJnox4+yUlJEM7M7TpvRl4YWkskJCzH7TLofwxrrQUpGtXoHYYA0Lso5Egna90CZzGImUN6nFN
 pE8LxCQbi3I3M7ykaBtAkpWeqxpCqF2bb36YYskoaYzOCy39JgIfD1wFQMP5ViAwsAT6LZkAeqV
 /64tklccVL27YfRCcWUknBzUTEwKjE9JXJcpqTK3kLYf1BqBoYyThzTuiIwiIvCjVXOSifCXo7G
 RyLr52gawAD3vypFL/fE6fUf3TfX6TE9/htkXlVC+DVjwLdgOAXaRmvSsSq8/WZ1oCNPY7NfEmS
 DMOzsGkTPqQj3uh+sUnUv0UZFE8UQA==
X-Proofpoint-GUID: YstMeyjAqb95rbSkXORzpIc2WvlppChA
X-Authority-Analysis: v=2.4 cv=JaKxbEKV c=1 sm=1 tr=0 ts=68ef58af cx=c_pps
 a=UFaLwPLgEuA+t4da0Yst/w==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=JaDH9CAM8n6cr9UliP0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 a=HhbK4dLum7pmb74im6QT:22
 a=cPQSjfK2_nFv0Q5t_7PE:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-ORIG-GUID: YstMeyjAqb95rbSkXORzpIc2WvlppChA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510020000
 definitions=main-2510150062

Hi Kuai,

On 10/15/25 15:57, Yu Kuai wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender 
> and know the content is safe.
>
> Hi,
>
> 在 2025/10/15 15:31, Zhou, Yun 写道:
>> This method only changes a little code. But it holds the lock before the
>> function jumps, which seems to violate the principle of minimizing the
>> critical area.
>
> use rcu to protect the function is fine, all related code is not from
> IO fast path.
>
> Please also notice this patch is impossible for stable backport because
> of too much modifications.
>
I will make v2 according to your suggestion.

Thanks,
Yun
