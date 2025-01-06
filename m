Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2125.outbound.protection.outlook.com [40.107.102.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325AF1DEFDD
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736184419; cv=fail; b=uu1qm5CUH/Xwhly9gU4TyXD0VqZ+x5CqPQirMPlX7QMUUMYjPkZ9Hp21iRYqZ74Y0hnoajyOynWc/TfJIRy5w0Lakg7zmDdsqdF3venFjdxYYVjwWI33uHm/bsCPvoP5BWG+4ALB6wuXLGUG2H4nhIrH/BYhH7lFiD69dd4B7+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736184419; c=relaxed/simple;
	bh=g0jKjAktmV13AZ4DQGepX+K6gtd9jeuQai23JlgBf4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o4M9BE0ajScAxR22pUloNMo0HMuDIVKjX+gu3sinPXJPXzfSBqlqprixBBVA4ozWM8F0gEyjIXOtbBj2UcCF+Ed944zq6x6ud/FCVVPAevIOQYhiGB7lflGRAyaA8SOfe6cUoqgdq8Gb4T1Z0NtvbtXhUa3M+SVcKcuOkcbkrXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hammerspace.com; spf=pass smtp.mailfrom=hammerspace.com; dkim=pass (1024-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b=XZGdHjoA; arc=fail smtp.client-ip=40.107.102.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b="XZGdHjoA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=urFNT8/UiP3S34/WyFLuJX6tcwhvKwqmmxAnbZDrXDf230jvulGBnUWS+CBmAiOHY7raHZcz6xOUFkutjS6hG7ecMyHvlLmbO4XjPowhW4+qRi3xibTtyFWFn5kVSEy9Ub+CB1ZpjQAucxNsHD0qnUENKOeo3PNouMo/lWNUQnkJej5bi+PGCqx4thC5bsA5l4uP9cXUikHVKT/o/hqruk8x2N1HR/pZiXJU6dbHzuPV59OhKoKIMbn4fi+bw3408pDQROXRiH45HQ2XI0K+S/TQfVxK9MXQkH1KOv+UJmcTU9/zc/f3qt74dUBZS1Khxhfdr468hyFxuxNUtmhY0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvaNweLt2kO4+vJ/JNHmry1HL22qqa+DFUFv739h+oY=;
 b=LMHC/Fflcpaf4YX/GeWV92/QTqj1VMrs97QrIqVIUJM60dMLw38U+ZE+oIecyYU9igsE++G9u2n+PjxryhLrHbede5ezbM5icc4WQuVKXSwwP5Y48SrepDlfw779CADRIxu3SPYnL6cfBmDmeKIrK8hEGlmAWC6PBnK1PY91JgRp0RxcNkeuzsocRDO1Z3SUt32bsyL0tUjNJDMW0l2isWv5KlDWRONMEv2V29NsqLM5hhUwj+4kJ2BScI2YHIRoUb3YQkmrYdueHegL1arTLXxJXoXWF5J+JRkTOrQ/9khXyO+J1uz0pQGCa3QveTNx624ztKMTGqSZG6vII7Y3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvaNweLt2kO4+vJ/JNHmry1HL22qqa+DFUFv739h+oY=;
 b=XZGdHjoAXQzdyi6SiY2Q4RdaaKCtlsUbGJ1/qzT5CrlXz5UVn7lhLfYo2Io65VDM+H11ExlqlbPA6epgGT6iQa5MRm/iSxnHm5ZUQLXiLvN0KkPGxfVmGwEeZTFThE71y4J6Ar41A3hPDwOXIErwHNaun2hxKfmDCn3mbCsfUD0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
Received: from DM6PR13MB4036.namprd13.prod.outlook.com (2603:10b6:5:2a7::14)
 by DM6PR13MB4560.namprd13.prod.outlook.com (2603:10b6:5:209::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 17:26:49 +0000
Received: from DM6PR13MB4036.namprd13.prod.outlook.com
 ([fe80::2a78:7a0:a33:cecd]) by DM6PR13MB4036.namprd13.prod.outlook.com
 ([fe80::2a78:7a0:a33:cecd%7]) with mapi id 15.20.8314.018; Mon, 6 Jan 2025
 17:26:49 +0000
Date: Mon, 6 Jan 2025 12:26:47 -0500
From: Mike Snitzer <snitzer@hammerspace.com>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, agk@redhat.com, hch@lst.de, mpatocka@redhat.com,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] device mapper atomic write support
Message-ID: <Z3wSV0YkR39muivP@hammerspace.com>
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106124119.1318428-1-john.g.garry@oracle.com>
X-ClientProxiedBy: BL1PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:208:256::13) To DM6PR13MB4036.namprd13.prod.outlook.com
 (2603:10b6:5:2a7::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4036:EE_|DM6PR13MB4560:EE_
X-MS-Office365-Filtering-Correlation-Id: 8acc12ac-be99-465a-8227-08dd2e774d9c
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uNfHoJUKzZe30ZlzCF3J4XFEaH0PjA+Y92kLqZRlAQGjtQ5WX4MRqE72I8nB?=
 =?us-ascii?Q?Yt3PrGFfQetj+r6ypLSKt39Rgojj8NruHRidjJaN3Ex6QRgiFAvvqVjwLgkQ?=
 =?us-ascii?Q?Ume5pwuQJyjITl+rGn0tA3Q137Y4C+rf2GaqNUVdeswpbbDJoaPUT3XFHl0E?=
 =?us-ascii?Q?RmSXNDtHFnAKB8fKAguICR2UqoMndsTJgUJRcH3pi3RAUHXZdSJQYYt+/NLP?=
 =?us-ascii?Q?KpZICPQY7xNjfyARKfkpWGTah1vkbcH8/7aRrTx2jPexdbCb1yl1oNUrDxjD?=
 =?us-ascii?Q?JwVYmNYcBW2mAGunmesWsPwIwXmeJgxs8qMafO/Y6+0iBf26Axveyg6tOLB+?=
 =?us-ascii?Q?aRWZuIzERtfXLl3xMDI9g40gce7at5Qtv9dREHKAq72ynt9xTrRHN3YHGg77?=
 =?us-ascii?Q?gQO5ZUgu/dHXHClF0fHoc63ZMeNrjiLa2NbfkSxlIunalP/1sS/zy5FNt7Cr?=
 =?us-ascii?Q?2A56Pks5FbE24MEZgz8suh4j6xqlfOxYCGrS0OaqqeokUeRtzeZgt1FZ1gDa?=
 =?us-ascii?Q?F98RjNVUiI5Jtdy1yfIQWBlHNRwS9FajOCHTotBVY8U/SvkEZDOXooBdJEVJ?=
 =?us-ascii?Q?RfB/M/cJsOEN+jjfHtiehSla4iqxCGDnHk7DXM+KRw0J6EM1TKNCUcoJDYZ+?=
 =?us-ascii?Q?E9R34x54z1SX1Pwz7fVSXizuCIr9SW2k1GB1Z9SEDNTLaO6pTBSda8BvHdZi?=
 =?us-ascii?Q?yxSfpDhmTyjjo5YFIJRvOWaA/QOKZDCxv47v99olDg1kScH2Vxhk3nwkIlir?=
 =?us-ascii?Q?UnHNRnr/AXjT/Z5sRkpkROqnZ93wiuK4bTaFYABd3tJO2TfKOV455BOFhLjU?=
 =?us-ascii?Q?zCbD9+ag5ZSdcVikRQ4pqS7A6g2ebkgbImE8eQDJu+K/6wlJmtM/HunJ9D7N?=
 =?us-ascii?Q?pptBDEEDxQ9TGijkYaFjdLI/MEuEq6RpwH0E1jh8JQipio7/CpaThcav0Tqu?=
 =?us-ascii?Q?i0AmhVslwAC+WNXRqbKnqGoxSjV8SRz/GxmGZaetylZP+AgJ7+VBDmPkovFA?=
 =?us-ascii?Q?0jUuxXax5wds2Fw54nKVP01jtzH1+I4SbWrvERxgbam+eJbUdtOjeWaG8FBE?=
 =?us-ascii?Q?6RWyWt05/KxjgdH66mqpqeXJCbJ7qB3FVxhtcj9cJxXMAZaqU47CvD6d8zjI?=
 =?us-ascii?Q?xs9+fmL8Hi1kyBKGmGXJYkldgyDMZlFaJ5SD6GQyH1FgzBqr3ANgiV7zmnwb?=
 =?us-ascii?Q?RIZLd8Dm+F3oWpP7lznsYl1nI3ETFxEB42uwYRCg+wK/kvnfFx7js8djKbfS?=
 =?us-ascii?Q?tm/3nXK/UV6DpP4HYcRr0C0kcW0wMnDVHqK+5P0UCNJjS2BSqu34SOZkEH17?=
 =?us-ascii?Q?pPUKe7q8oYicqH2b2s9jOmgDLqJPC/zG0/d1cHo3g+r2tvRIDI1bl1qD6Kzh?=
 =?us-ascii?Q?N1isKpyi5nsSLv2E3/dp57O8XjW2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4036.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AMkHU8Yyq7oobNq/+lgVjjROmmyY6i9h8DaZmqLZANIcaAF9QJ5S0X2KQBwc?=
 =?us-ascii?Q?++Ye79s+sb4Z3iDtl9lEbw0ldS6srfnwVUKA3R+PkBrdbU5imc3QrPIv/pIr?=
 =?us-ascii?Q?BoWOqt/EGWZrg2faDHf1dWYrcQVZLP1J8ZkjP+XMfzwN8At3MN2eDkwKrQH9?=
 =?us-ascii?Q?2aC4d2SE5I7e5Mv4zA8bXODi0XvtGhNvYD4if3UXBr+Xj6tmp0RauIgjByWF?=
 =?us-ascii?Q?xO2GNMhII5NwrYDy+sabn9Fb0OawChJOK3bGlaDZBDkXE+/p32pSZ4iSMLeY?=
 =?us-ascii?Q?zE11M2Zexn9xP8AlYjPpDGpnk5BwFONuuBOoKdQ1CFDrTuyBXla3D4FIKx3q?=
 =?us-ascii?Q?MOVW7uhRCR/0HfMZWf35H7cbJ3I+J/CDWBASHANes4IKrNMNm7BdLN+2FVQE?=
 =?us-ascii?Q?FZAoFZIA1BKnzoK3wVgbcZlDyGn3LGAQEer82M/CokNcGC9HjCJQXv6WsScO?=
 =?us-ascii?Q?DwUMqVt2syh77PANIGsAIG5ol5ZrOIw0nEFnMvqBHfjdwZZU0RKVOLc31l6x?=
 =?us-ascii?Q?IBCEnANUkVCc3mFqvMRKR/l0w449pERQVFj8QrZtyLIbAtgGDUo2CtvgqXYF?=
 =?us-ascii?Q?PIzZA3ZBa/g2efHAHbd0f9WTg68h8ddMeeyjaOtL2wnBd8VU559k3YRJVwUI?=
 =?us-ascii?Q?lnqSmt2tTwJOtvhtgs837ljk/8r9CxAS3Pu4P+6fnNGPhH980orYST+3mpyn?=
 =?us-ascii?Q?XUB9PIE4ZcJfgg0zx2WYSwUDEBW73JTwPKxo8cEKm8BvK7SQY8hD11JoD6Iv?=
 =?us-ascii?Q?/9tkm70sf3CoU7EOIdkp1ExV2xI1gom9b1py4wq6PZW+g0ICCdJW/80Rzv+T?=
 =?us-ascii?Q?Xdq4mHhjmHzRtegW65UQpGiHQX9ktmZ8JasA10GXhU8KpgRI7QRPu5htBD0C?=
 =?us-ascii?Q?EDcjtyXBw/dXUxpXKBV6hJGEIWya+EaA6ZrNJrW5EUtfva6KO6YR129O6LLD?=
 =?us-ascii?Q?nNz7Bjb3CUCcfrBqrMe8DWEccYbkSyF7arxGFHPP8MrJm8xwuBeyh7pw2/SK?=
 =?us-ascii?Q?+egs+vwsh1HQ15+dRzQl2rrdzLsQDdkx/h79160cNwA14fVmZbUcDXboM29i?=
 =?us-ascii?Q?0Lr7i0x7OXjvsaODFMNNG9pvo3DcJe7oqcbRDlRiwkpqPPRoYmxoscMruFFB?=
 =?us-ascii?Q?L+1FudrYSmXQ2tif1YctwWbqbRzbXDhY67SNcHAOSP+nhPFEG/3an/JpAlm+?=
 =?us-ascii?Q?wKjl+wGyMn/W2SAwkH6T3ulOc/qrCbhxxCZDM/Stu6D+CMo1PPuaxMUiS/Ap?=
 =?us-ascii?Q?VXdsvZLA8ZEnJnPj+A8JcNAh4AztPt4zMPBMbACY8UfUSYfDYQ51ZfJTOOfU?=
 =?us-ascii?Q?9NdGQRPPZ4EQVM0Q9ko1MIlIqrnvcV915ED5wNZtJHorRiNSTSmUaxnqZwMN?=
 =?us-ascii?Q?MjUgSjqAPHQr4qbBGv5ObZyR0vH8QXAz+L7yc5UrXm73bT2gL+NPW3saJ7kL?=
 =?us-ascii?Q?EhYWdkeFAOEeLbzB6EZBr8N1UsI+afQEhcR7ioLu3NH8H2ZQ6Yjl5mKxsSS7?=
 =?us-ascii?Q?35OraC4KgY6Gar1fLKvIjKwM2ioo0Mzg5hv0UxHMQEFoAD7OuZnHTneUl/yi?=
 =?us-ascii?Q?5PdfUDJjfCWlLIMcmmtXFb3Dxohga81PdxC+b4Xq+D4TJg4heOH3XZKFuqI6?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8acc12ac-be99-465a-8227-08dd2e774d9c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4036.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 17:26:49.6004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGn5AhfhxlkNqUduXhczvbBu3UCDdT02R6lHRu2oUC7baMaYDP1gyTlc4C3z1BvX+bTC1fhUFly/2vAkrno005sDRvqZCdqo+q7r07j33/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4560

On Mon, Jan 06, 2025 at 12:41:14PM +0000, John Garry wrote:
> This series introduces initial device mapper atomic write support.
> 
> Since we already support stacking atomic writes limits, it's quite
> straightforward to support.
> 
> Only dm-linear is supported for now, but other personalities could
> be supported.
> 
> Patch #1 is a proper fix, but the rest of the series is RFC - this is
> because I have not fully tested and we are close to the end of this
> development cycle.

In general, looks reasonable.  But I would prefer to see atomic write
support added to dm-striped as well.  Not that I have some need, but
because it will help verify the correctness of the general stacking
code changes (in both block and DM core).  I wrote and/or fixed a fair
amount of the non-atomic block limits stacking code over the
years.. so this is just me trying to inform this effort based on
limits stacking gotchas we've experienced to this point.

Looks like adding dm-striped support would just need to ensure that
the chunk_size is multiple of atomic write size (so chunk_size >=
atomic write size).

Relative to linear, testing limits stacking in terms of linear should
also verify that concatenated volumes work.

Thanks,
Mike
