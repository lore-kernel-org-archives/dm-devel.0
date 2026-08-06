Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271C9430795
	for <dm-devel@lists.linux.dev>; Thu,  6 Aug 2026 09:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010176; cv=fail; b=ex5q+P7r86c9EHhVTSwDYoh9aXBeyshSYCFSvizdE8CP6oEbJrwCeBhQFxFsDzjiaUVmMhepT3fr1AyqOtGv/QVgfluRKo9LsW+WBrvAu0MtVuDKVO2zvOsNGUig6MbW+AEBTuVfztrueASIpG8Md14v4AKm6ZcQq6k802YLiCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010176; c=relaxed/simple;
	bh=rFVcaQLFY2Xv6oteAhA7oumGN1auSPc0OoDgDyoH5A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UIIR96SsZ5uLHI29jfSGojMsAPhDvDZvvlRDW2YfckC46RRUF88KCKX6f0HuFctFApYwc1J95HArW+SaZHhr78A0i0XuUIOzooEcIvd6kc6/AaakpGSUUmaPqQHMVFow3Ewlm/XSh2HqBtbePV/Ysc0ZVp7lsv65p/4bA/1xvNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LooukUkR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Vnyr66IA; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LooukUkR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Vnyr66IA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1786010175; x=1817546175;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rFVcaQLFY2Xv6oteAhA7oumGN1auSPc0OoDgDyoH5A0=;
  b=LooukUkRV2dEOHySla3e1JtdPoJxOPJYMeHNFIvSgM3jjEFgqOYXCf7V
   E3z7pa50eKNVl+ovg4+5pnVzrqBUfpsPtJ+B2WA11F9ZxDbTosfMEa1cp
   t7F+fAhZnbxHWk52K9bG5FJcFnl3Yc9yDCKeAkmZXy5IQsA/zlu1IjF8l
   od8xlwJ6MKPUoTAEinEJz9B4l+1GhnznyB0nLFh+JgHnJYmS/2elfmpB8
   ppcnNPhZxELIc7ffPKRMrOVFhdgMXBEkeUvd0zZz0cOqKDwtq4fiowvLM
   fvuUCkihxZ4SkUGs9N/9c4Wz9II+FhkOnhULKMt4geInWqRx4LpEdGTDW
   Q==;
X-CSE-ConnectionGUID: wR+F22neSNqIh5XNAdvSDw==
X-CSE-MsgGUID: XMTnt6TlRMOEeSe/eMrKyw==
X-IronPort-AV: E=Sophos;i="6.25,208,1779120000"; 
   d="scan'208";a="151037458"
Received: from mail-westusazon11012035.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.35])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Aug 2026 17:55:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfav/lV3cPOjpOJ62YA6YU97MGSZFFq9H4qXQTS/Q0Z8zLi7NsBOaxGha1MOa3fJGC2y54rbqOUmxsmnrUl6hZoSTioDraUMC9sV+sqRXIxGx070qDfc+budlpo4BCfnRJSI4NNxVkl8C121Z4uMmRhAnyowXoPEnhGivRXCEI5aLB/w7e8nk0S6bUkouRSbqcUzmzWnbcbbMOJBraB0ypC0jnCrFkek8Iw+IuQdTqWS+9z/5hmzmO5LBzKTAqVpI8wLHk6mvGs71KHPggC20PR2VNBUDc7lqrk26eOSFzzci0qWY409un9ToxZaviFWgch17K21b5OiaHnq/pr/qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBwD8CGayiWizpl+8iPpVLxjAUo42R0MaHwb2D3y5io=;
 b=uQkGkG9t7+ae3JIcXkUWNnZuP6Zw8e2wGvB3BtBrbipwYtcW/d/jsxRpPlt+79TPepkK3f4qakXEWPISbUqDo2LNsW7SMfkV+IbbKdHEsytVCCr9+fFuDCjuPsdhZ9FGqSwyjmHRNEq8ARdScHmz601U8zdTZJuEnHuqP6nbbEPsTf8rMx1XEthSB1aryRr07J+837K2Xjtr1hANCBz8xY+3OE3T/E7AF86k9M8NaUgNa9I+iSfoDvFfw/42PqVDOl+wluD7Nkhxgn+8b3N87XClrx7HIjAEO6LqD38XFbP0YzsLGQ8VU1vveXdrpvQU7x2kWbfvkbn/t48thFCyXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBwD8CGayiWizpl+8iPpVLxjAUo42R0MaHwb2D3y5io=;
 b=Vnyr66IATnPm4VPX3qhzC7LmPUiI/kwvIdEWKIrdFa5TdiHoOvK//SodbrrWCVfBLptGx8+wbS2QmyvxR4qY0/CW86rcx4r+JLa+E+bxam+XWRDd0JF7Iopg4zJJ+fd+ngZBXQowtQes7uQoLu8KXa72agaQ6+0YeeE5liANbZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by DM6PR04MB6970.namprd04.prod.outlook.com
 (2603:10b6:5:244::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 09:55:02 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%4]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 09:55:02 +0000
Date: Thu, 6 Aug 2026 18:54:54 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: 0wnerD1ed <l7z@0b1t.tech>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk, 
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk, 
	Keith Busch <kbusch@kernel.org>, stable@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH RESEND 5/5] block: validate user space vectors during
 extraction
Message-ID: <anRZZen4cCw3fCPG@shinmob>
References: <20260720201057.1862857-1-kbusch@meta.com>
 <20260720201057.1862857-6-kbusch@meta.com>
 <anMscoGkR5BYjSGy@shinmob>
 <anQ-28nxOqBmQjxu@shinmob>
 <CAKTh27_RnTA_Q8qAbQ60gBo9Op_OQm7J8KyamQ_tbuTRb4XF2w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTh27_RnTA_Q8qAbQ60gBo9Op_OQm7J8KyamQ_tbuTRb4XF2w@mail.gmail.com>
X-ClientProxiedBy: TY6P301CA0027.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:3bf::6) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|DM6PR04MB6970:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab2902f-d1fe-46e9-4d02-08def3a0c8c4
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|19092799006|366016|1800799024|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wbPeE/ksydMe2aJNA7R9h8vqKEJUtErVM86ebuVrlL5r14azjEHyrpEkaju+JML4ufm5eA2tum+PEdqPV0fiaTVTOXEqMSALLoCnxBcFLTNz+xpJkhdZIEm5OrHNv+juxICBwayMQzcfwbz8pzMCXgS9j/hEeZUuGJdNJQUfEZ7pKYV6nMx7AqF1bLeeJWK4arwShhVvwOBmi2SO3q1pMQbjjij34yzqbztBvZuw/SN+kBTVc8XBTG8acq0uqonU05IAko1jcTJNKfKo6CM4x4omAmBLdRGjzxPfdrgo3sgtNlT5nV20soB42iU1npFjfZPhZkdqIVAYiutNWpNze6Y0aDu8vOSdU3fkjdKyxs41u/07ZckzHwskbmX7BjSLbABj6dfPlxnoViyyM1DtP/Tx2DvGifYE6KMNoJdZQCgnkc3tcPK7Uraf0Zl64/vrtV3Xb/8FxuWQGJBPpCbabsDWUMBXNwBoO3h3tBjgQBVBQOzcRxoeDB2ieh/raRLMqyVekMs4RwkLRCad5Y5DWAQUl/q+HiDi2lpcMvByGphPUoaDB+6BoVNnBLyeG+0vPgDV1JVtliDc+2AhTlyQKYlwvDUteiA6vxsTLmq5CDNxQjHlvMX8Osyb6bj7Uu1KijJ7dsaSpbEDeEblb+cf9Lwjy/HdMTgShlJp97Ch8Pw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(19092799006)(366016)(1800799024)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pmaHquAJUn8LnnJurKOtlCKw8Stxa9PkVzSfLWkUC04vgM/LPmAP+E6KYU4n?=
 =?us-ascii?Q?nQJTW3zqWFR9jKi7Qj2IQGgajpb/VrqmdKDA+j1KvoyscD/yU9ho7H9wk+xY?=
 =?us-ascii?Q?T0w4ZD0bZAK5Tfsg9OFknrDxZVFYaadJJDQZl/T204zZi/yLX/7tgV3cwCvY?=
 =?us-ascii?Q?WdepXIHqqdwCKa5KuHskNP5HEHu8YqC5HoA5YyRBVykr6cahElVoEa9/Ujze?=
 =?us-ascii?Q?r++YmOAQMS146rzVgXIgWSTmNnYsPguj1VCFi/YdKHLkn9RswePMcsepW02e?=
 =?us-ascii?Q?tV5r0/w4g/rqFiZL0LTTyrYVtfyegLTHtxAayD2y6kFU3omhgg181TM1ZIHl?=
 =?us-ascii?Q?caJkE6xAgjZQqDH+YvV/1wwgM+63Ki+V3Suj0GA0xi0pXFHF9SeDtDG3vC76?=
 =?us-ascii?Q?gDIp5UK35RIyO8sKwM41wUSCVgLyKsNM8H55txilV6L3heCXIvrEDMIdDfa1?=
 =?us-ascii?Q?Az1NSaIM+Sudsm9d41xF69OoJ5Oj2FKveMfUJLyKb4aCDLzGWuI9pYqDG8fR?=
 =?us-ascii?Q?X3D4Sd9EL1gL/vaWVhDLpsAPeC4HIZVA3U98gt1czYxcYY/huwAErV/lmCff?=
 =?us-ascii?Q?oTFhpv8ltRpEG4+vBLV2k6BndqAIGywIYWFOuO1lchIl0495bskVt0WUxMh6?=
 =?us-ascii?Q?PQNDTiv41iGFtwQuqJ6e5oIGU/0GXfrGu00zJCdpPjtyjlZIq2rklvBBEVyY?=
 =?us-ascii?Q?Cvh7D/39m9xJcIpoIwvJVf/1MI8QSRHIvDL7pBWye/mESghzCE7l3hECgI+s?=
 =?us-ascii?Q?bBMe1Z4Y2TMHnWFQ3XBn9hjbQys7f+2KgExZXxdfbpBdEFuEzo615S3Rm+to?=
 =?us-ascii?Q?M94u0G6DbaLi4wnFIPibEkPav1bGdQstCPaIwdgqU3dO5UbjVMCxbId8vcCu?=
 =?us-ascii?Q?0DUa51blnKFjAA9+u/+0PDsyU1YDmmkV7KqUPjbhYBZaXuMIGLYD6MALEeqg?=
 =?us-ascii?Q?LF+zzsWU19vbuM8EvYJBQs+M+BGGSvFY+S4eq4eqRxZkeJRCfpl4WXQM6hpE?=
 =?us-ascii?Q?zfqFqciMERZ4rgzTBVcLw7BOqIKmaNOC6DwAzVbZ+618NHgUh6ItI/VbfK3M?=
 =?us-ascii?Q?vZA9Om5zC+AdzhAvDsJPT9BqCjHXKGDGCgaRcwm/VmRkN4KwFWN9UVv4EJrZ?=
 =?us-ascii?Q?Z+tuZgq5Hyf9YO1dgJj8RbISym46dWM4SzKMilpL86VYJpxtlaBL937vUKNk?=
 =?us-ascii?Q?rKimXXkrGi9opYnl5pe9AGBru0lH7SkvovvipRGqyYpyl15KSWDy+eYzfIbc?=
 =?us-ascii?Q?nPMozR6Q1oYG50thSoEUhtSj1LcT8PkXO8bTS/5vbs4i5RjMkfGgHMeNU2GM?=
 =?us-ascii?Q?tgyG0WLg1EcwG/763o5drBRcbzUV/Gn3ILxqSYo6v/3T423WtmKzcIT4J+2/?=
 =?us-ascii?Q?/jfnq6Xfa0T6h5HympNv2bPIr9SQ0kcpsUUaADB4ZJTm6aRujJI/zUnSr28t?=
 =?us-ascii?Q?WGx5pVAieNNNXUvbEC7CvhNetxPVLBjrEPttLIbHtQQxAZ961krDWC/oWKle?=
 =?us-ascii?Q?BP/Po8lsRki0Ht6A0iDx2n6EKoFhLPkqYrspeGwHFFcTSZaEftNGPFxJcHiS?=
 =?us-ascii?Q?aE5Xh70tomhYJMc/+UjklxuSUEm4HKcEq5j8BAk3uxw2ZVpBXhGq0903+QL5?=
 =?us-ascii?Q?GL4vZ2zFXv7xKOCpXBK3da9b9xpzAOoA/u/Gfn2+/j8YCgWZqz25VtzvSA5E?=
 =?us-ascii?Q?eYB9upr4qjyMEi8T9AoMJdHXkX+37rGGxJDiK6FLnuIRzE5tzqF5JGrZolw6?=
 =?us-ascii?Q?2Xt9syxA8icnmX7RVtdXzKEjj7WsHxI=3D?=
X-Exchange-RoutingPolicyChecked:
	aSf6h6zqcIP7RPDGRK+ZE7oqCnt7UFNnstOZlSEQw79vDgtOVkLplkUwvdQGZN0WLHXTgVBueoZ8j/A2l64pXvSYDAQ4HF9tX8Sy2iDH068fbQHKjgzq4c4X4WYxgWBcXnvLMBomr1XDg/onhs+jh90cy5EKG4onOdr9A2MPTj9V6tfkSo9CBW3O7bQL+CFV81aFBJgKHuJq27FJYc3l5jFnkRhEypJHPwtdt4ZWQeeoz+kPxW6Ngsu5O0bSjutq9mLP4y1iwPi5EVnS4hvt8OegQBazMeg7LjYe5McpPRMbdDL/rlcGOHHXctLPmS+9jejny859a9/eHZO74bnGMw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VPm8R7Gz/5r8Zu3XttYp8oWFjOP17P0oxxiXzc53ue5qTIMggQDQFE6CpOvHGpa9yScNRqb2duPsXj8hZcbqZfasGz5useY24B59LHlk2+BCKj8aRacHeMhydK5ZwZiX2w6EkQzdKDhH+mZUSPqw3Y19UPKqak/BZiancQ7k5cgDAnPSdl+g6tkdPyWJv4Wxx4mEc02ub4k6IyYYyK1wOOWd96DfqtZ8CIQRadz2jPpwvzz5XKDiIyFfwHUAbLcaes7cy0d9wZqZF98aJ7GmVkocH//7KncY3nT4HsA/KIW65dPOQF4j2Z5lxxO90R69wY0ikqgcrXqYhkvgpG72O4TQa7WBq5ufN1wepkgpX5v4n4ytFkws5Ze+AJ3+aVsDVOfWRjDY0GaSty2eZh+TRweq3zfEGiB8xsw5xzYkea+etNGlH4c5kMNMaDhd1wqJvWI9luPOzNzEgwuNRpAo82GSAVZbOyp+j6dfJjWG4vzpBtdbVAAGrUOA519BvzdVx2Id1G3tDpHZPnXtABhTTW0alBGyeNE2zeym3B7fFFuX+d8EYJug5UVojq7lIMUrM2XzQtiexOW2B39y9Cf58b8QboPPqlBV0WMgEGlQX/zOGPC5MJgE0PTPK3RW66p2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab2902f-d1fe-46e9-4d02-08def3a0c8c4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 09:55:02.2714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qh6l1nxi7fiLfWDyQk3fm05rM6zi4So48Nzeo+VrzN9YyM7nhoEKvE678sUHok8yCVMHr5dlrO1/RL9d2tTPdVBv9QwZxyM1lWHaSm44/XY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6970

On Aug 06, 2026 / 16:29, 0wnerD1ed wrote:
> On Aug 06, 2026 / 16:04, Shin'ichiro Kawasaki wrote:
> > I took a closer look. I modified the test case to respect the dma alignment [*],
> > and now the test case passes. This approach looks working. Will post the change
> > as a formal patch for review.
> 
> Sorry for the slow reply, I have been busy lately.
> 
> Thanks for chasing this down. The test is mine and its assumption is
> wrong, not the kernel, src/bio-full-trim puts the destination at
> p + page_size - 1, and null_blk advertises dma_alignment = 1 since
> commit 3451cf34f51b ("null_blk: allow byte aligned memory offsets"),
> so iov_iter_extract_bvecs() now rejects that odd address before
> anything is extracted and bio_iov_iter_align_down() is never reached.
> That restores the behaviour we had until 5ff3f74e145a ("block:
> simplify direct io validity check"), so the test is what has to
> respect dma_alignment. Your approach is the right one.

Good, thanks for the confirmation.

> 
> One problem in the trial patch, the guard has to be against the
> logical block size, not the page size. What the test needs is a
> fragment that bio_iov_iter_align_down() removes completely, i.e. one
> smaller than the block size, and the read has to reach the PROT_NONE
> page. With dma_alignment = 511 and a 512 byte block size (the block
> layer default for drivers that do not set dma_alignment),
> dma_aligned_offset becomes 512, which is below page_size and passes
> the check, but the read then lies entirely within the first page,
> succeeds, and the helper reports
> 
>       pread returned 512 (errno 0)
> 
> instead of taking the "unexpected dma_alignment" exit. block/045 only
> uses null_blk so this cannot bite today, but the check does not do
> what it intends. block_size comes from BLKSSZGET, so it also has to
> move below that ioctl:
> 
>       if (dma_aligned_offset >= block_size)
>               errx(EXIT_FAILURE,
>                    "unexpected dma_alignment %u for block size %u",
>                    dma_alignment, block_size);
> 
> While there, err() should be errx(), errno is not meaningful at that
> point.

Yep, I reflected this change to the patch.

> 
> I am short on time at the moment, so please go ahead with the formal
> posting. I will send a Tested-by once I get a chance to run it.

Sure, I have posted the patch. Thanks.

https://lore.kernel.org/linux-block/20260806094218.2077413-1-shinichiro.kawasaki@wdc.com/
