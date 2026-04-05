Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010016.outbound.protection.outlook.com [52.103.72.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810441DF27D
	for <dm-devel@lists.linux.dev>; Sun,  5 Apr 2026 06:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775371735; cv=fail; b=fEhDw3e4o7PGIivPFDsxB9MsKRLoSuIHCxsEVHBX7G+gZQg/oCkExUTihPODQDfQ8zS4UNgXqj0b5scMrD1iYNQpHQiNiBjtC8fF8WFjwfIJfZoq4yGynYI2mNpep0l5MNd4aGY0pwoSzRQQRG+v7fSZLsxc3OdrTtb6IAulicA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775371735; c=relaxed/simple;
	bh=zZyG6ClPAT68esjfY5yTx/63jKUajlsiHPqu/HP9A/E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cCdG8a3Rwzl3GBrCBXMcMP2Z4YBtVYAOf3xYJv5KosCnRvq8FHbmoaOBy5ttMMfkqeO5DL5nCv6t73iYYvST2TB9TTu8Te2IQSx1pLqwFkkQH3Kt789Acm//XS2OisAdt8UEdpVOZMlJQc9gL5L+V3nTP0bSrlLgcCvLShbjik4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=TIv7Mf99; arc=fail smtp.client-ip=52.103.72.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="TIv7Mf99"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pwbD0zruLICDr7H1k+oHPlMUZTZ2IXX/KOxRLp924Q7/6cEUEOBXQsznzvmAKKatiudIAP+YIUjb13xhnKDbVHE3lZGv4wAwHooAc61sQp//8o6h6onJTApjSpH/aYpJlh9R63QeLt5Nad98T1SZSjvvvHNtZfZUdrmX17aM8PXUb5JRsCAjryCn2K3G+/0UxOiRTG5t6ecl5SKVrxU+ytC/gL2dqE/wGkChY9yVRNJeJaL0WMjUbuJxi8vpgJz4GCGI911IjxtCVNAB0aVRJ1Z7v75jzlX+iLW6817DGJXsh5N4km5UPgmZ6rb4IkeszCsq1mi6UjZ3+V/LPt/RTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZyG6ClPAT68esjfY5yTx/63jKUajlsiHPqu/HP9A/E=;
 b=DSNTz3JhyL53P0fNvQ0XMRsA7jGccu7Sw2LthXw+dcbxqG0wn/t5hLE62hNQSQ2VytOSJ8nfUxegIIB/xSAK+2V+p36kigMcobfhh+X5AivKgoUfBGSu+UkrCFnnaQmvmon3ncMMKeeYKTvItfrO1G3TyJIz2VKjGfiTFKdktxM2r220sN+cxGJwMAG1GcFp6IT/uMgdZ17VIyYOs9UlmSdBgoGiVWU5crh9jaZQqoI96MYE4AhhwVjLhi5gXOBg0ozS7vUcjfX/LrHO7iiNIxdnLWFy18lPZAz6gXynGXEKX+EVaowSXn3qirsWbLPg43jF1TwxZzT31zzCGNXrlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZyG6ClPAT68esjfY5yTx/63jKUajlsiHPqu/HP9A/E=;
 b=TIv7Mf99G7mbvAfxtQi583pJQFppfXZYuMoZXzZ9HWXdzw1JOTYxTEpveCsOrqegKJqZH0ryWU/M2Rt/Az+deg3tf+vx8UgNacRdpHwiIGKqXO3xVoAoz5mpEQdwZN7P+nwjMqe19SRQ+OWerklfDK/L8vaw6sd/t6LYOkMW8kj4UYRQM/uhzGPNNO6rnyMIKvuz+NgMh8vU4rz/NUab6X61fRQnswR0f14U2DP9WZ8ARn1EfA8VJ8qBQbKH10odpqO30yBtcKPHVYe15RmZQIwSllkwSx9brIpNBgmvSztb6Ir1kW2087Il6TZB0i2uRnQZUp7rWwYRd4yJXyx99A==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY2PPF42FDB976A.ausprd01.prod.outlook.com (2603:10c6:18::293) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Sun, 5 Apr
 2026 06:48:50 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9769.017; Sun, 5 Apr 2026
 06:48:49 +0000
From: Junrui Luo <moonafterrain@outlook.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
CC: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yuhao Jiang
	<danisjiang@gmail.com>
Subject: Re: [PATCH] dm mirror: fix integer overflow in create_dirty_log()
Thread-Topic: [PATCH] dm mirror: fix integer overflow in create_dirty_log()
Thread-Index: AQHcqX3hF2BqjdY3V06YkSN+1dzOY7XQPXoA
Date: Sun, 5 Apr 2026 06:48:49 +0000
Message-ID: <E5B9C799-E007-461D-AC8E-3499E6A80B59@outlook.com>
References:
 <SYBPR01MB78818AAF59CB119B833C535DAF71A@SYBPR01MB7881.ausprd01.prod.outlook.com>
In-Reply-To:
 <SYBPR01MB78818AAF59CB119B833C535DAF71A@SYBPR01MB7881.ausprd01.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SYBPR01MB7881:EE_|SY2PPF42FDB976A:EE_
x-ms-office365-filtering-correlation-id: 3bafa5ff-3d4a-4a19-ff54-08de92df64ba
x-ms-exchange-slblob-mailprops:
 zZTkHIKWWP8EXRfSHz/+bmvhnEayH3FsRjdF4RYzS5/fFCWmVVowILi2SbAa88ucCHCRtFAIQXiVDcsCJOkbrlzsazryT3GyAJ1Prye0kTZ24FQgvVjVx0KTTbukPGKgTPBa+mYX2LpXr0yEcsC4FbykfOXKUYmWrPh6nzOWpRlYV8nOIHI6PHc/IuUM44Gbge9Ni3dEO2De/4B9dma7dJeB1cG/B/nUkG196sZ9pFg3BfMWgEZiX6GlUdlbGzi4a9Cc0bi6XlJ/Z5ngT9wuhzE49M9psknqo0B/sMRw23DIIaKzuNsudoFGBXaAoLvm/H7Rn/j576/q30fxH6fpFcW7xPAY67C/eznPqFFj2BAfYeUu9njq3GhLEezLhlTAh3AJLgt9V+fZt9HcROkt59zsZDAR5N5fojD784+y2wRKq9ECNvhtANhEzt86XyBlfg2upVgMmiSTyq9HmxWpuhGFodre2xumDj+uXlZclUnkhwUba7a73Kp28dpx6vhGy5UHVwV5O/AGKdUFpiVDTOyMB3dMHx3TLpte5ssDichwG/E2plM0jXbeyg1gtB8oXFWVWIlnYjDdUBmel3MSLkfazuNaIZohzcm2+OJHURv9xjPLQML7veHv1OlFxwziMfYeOv4mhbAXtIxytTeSorS0rTN7EUlC20kBd9jbubPxvStdu+pglA==
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|461199028|51005399006|24121999003|15080799012|8060799015|8062599012|31061999003|19110799012|40105399003|440099028|3412199025|26121999003|102099032;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?IdxixUz60ghp/d3Q7WWW8bWTa6uNfJIQSUvnwEcFclcNKShLh83fa79YkxqK?=
 =?us-ascii?Q?B5RgPdYkLtoo1iDq03CTS7haOVljuDJTbutTe2hWcA0eXDrd2+NULHOm8NPo?=
 =?us-ascii?Q?ujm5WVJ5QCwsTnb/Yo97Jk0YsIKFm8I2x+m4M2DyK3MUlyVvTEghrmEztNht?=
 =?us-ascii?Q?Aeb/nYIiloN3aQWBRXKm4jOyb5mKxXWyLyzeAI8dXqnePrWTNNxlYzWADxsk?=
 =?us-ascii?Q?8X36R8SBBbK52YRjCUwm64PYKJdBCsBUhVwSnCDhIATPJwA/lS3vZh86NO3H?=
 =?us-ascii?Q?49U/x1/WUTsLvLNb7AMHxzRD7ZG2e0q0fR+B/oJmzRkyx4jOi5c5wT/bBRNG?=
 =?us-ascii?Q?3GeYV0oHIhlkxPZRkKJn6mN3DEuqPvDd7muj+0gys01muFusUl3wNeEgC4h1?=
 =?us-ascii?Q?rQivgk48r2z5olZn7B19YjixddDnRtXcFQH9L3qXfbFFS5x7xdO8M9kO57zD?=
 =?us-ascii?Q?WD1BMGjaQSrSR3jJgBsNja1FL67Eg5AF4W5rXeC7avJjXTOPvpqpSIzAO/lZ?=
 =?us-ascii?Q?3LSPDuI3sQvY6bqwALBwO2YQ9TwCjxzXYFQhhcAkzcSnot+kb7d6NZj1Zt67?=
 =?us-ascii?Q?0+dw+If/SltW3revEQI56Tzfc9g9gQQ9oOVqTBzQe1oBNHpWzmMXbPglbPQU?=
 =?us-ascii?Q?9wM2BKgh8NjEpf4ESMniYeIMfrDXgdZnZSUZaTnQEl2YcCxf2UJpjwLVpIbE?=
 =?us-ascii?Q?VEsVQ5VJUSGqlai3A6K3UnMsidaa+pooneurEujcz7pLNoSz5U0pKDBZJ4Ky?=
 =?us-ascii?Q?IWIpAEvNy+0oqDhlxuY6v1PBqiiORv+mmFYOttArf/v3FK5ufnllvMr+7JzD?=
 =?us-ascii?Q?zmVC1gMp21epCA7ItzUtI1MyI7SX4gSMGIGhOASqhmI0P6SpovkhzNlYIjYL?=
 =?us-ascii?Q?7t6uN1jgNAQZxAZsNq2TQp7Ug2jZrTv8qfIjfKUYiaCY5cosD83scwrKU5Zf?=
 =?us-ascii?Q?9qWy9LQ6QYKdAcmSiLU65YdilGSuww6aLXtmmpz3F8xvh+zScy3Cl5ALdNBZ?=
 =?us-ascii?Q?44t8?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?A+460w3M2F/hDgg7YiqZAaSA7j64HM+AgtPnPt1uK9Qfw+APVy88j6rQPFoR?=
 =?us-ascii?Q?D0Wu++AavxhwjuGpbvke9/hEH28KQG3rcUWuYNxFnQwaI3/TLHmI7Z3lMLrP?=
 =?us-ascii?Q?wOYnEoiYSQVvviPdZX2jFxMiX+OggCQGIMGEnkOmkm7tbomc4KFy1Y+HpRNd?=
 =?us-ascii?Q?7gpzf5UzDcLu0h86eWwzOVSwPANLddEKVFqu7ABeIXXNOKaq24ocGPC3HDEN?=
 =?us-ascii?Q?Gob8Cj5FO9abAT4ymOFl7NvaJr26AtRPT6Zl3Ra0+8UjB7kb7w44oiRpxa1W?=
 =?us-ascii?Q?5Q4+ERM6EkJqqZlCNB9mya6jkzCZIdURuexxfb0qZgsGM30e7b4j/w1sHyf2?=
 =?us-ascii?Q?/0iOQEbaxMzvtZLTW5cNebQP2fdYLRSK3R+UPqKeQ+DlRWiABXbkMe44MUMk?=
 =?us-ascii?Q?bTQRwzaltxla1D+vSAeSj4hLAfrcHb6xn3fC70iCL4I9k6XjrKalbyinUlX7?=
 =?us-ascii?Q?PIMriBuR1+hGaopX23KmO70b8hZQSeLKnqnJ4ZcmeSZupC8P6ant7lOthCau?=
 =?us-ascii?Q?GxmQAonj02Lr+LG0Wb+rGZ3/AXRQE7cNN/sX/VAEcvcdHKTE3Qz/I34BLySN?=
 =?us-ascii?Q?VX1ADOzMAwkfyyKFmL+bB7JAu5iPguvPU494H3ysJB8+S1hJVOgMZG8EQrl3?=
 =?us-ascii?Q?D8qydmG3XDVYkIElst9IHdLJ+kbfcsUWnwStiIQonEd/61dZ4qZHGtZSriAj?=
 =?us-ascii?Q?+87wfDakV+epkKnrkKucubZ7x1yvwiLKxA6Y4gCdfRCnsIwuhk//gg8XgHLs?=
 =?us-ascii?Q?5mamnXcLakVGho8iBHe+VaEIWOrX2e9RyfPmP/1QY1+mwECOeAy64KV4geRK?=
 =?us-ascii?Q?AJ1jdWG6ky0wz1oUQ1YA714At1yG5O41Vp/egt5VQ5y89wThw3FBo+tiHiDB?=
 =?us-ascii?Q?dwcp/FfTebW3uolo6Q0KaVyS166luP3HCrDndTOPsJFG3xtJT3Q1QBS2QIuu?=
 =?us-ascii?Q?6Q2xuOezsM6eREZ9Xo8nTHuEQBa8nUQETo/2rgWsFKKKKO5xb1OgaeC8KFq1?=
 =?us-ascii?Q?adf0BU9P58+PM2bfMaYkBht4TWa9+G4QMX7jFANv0RS+TppFwZMwkEUTvsrs?=
 =?us-ascii?Q?Z4siNoqZ3qCgNGFT5Xex2aA8SCueg/zUEbn+uA/HfY5pd5vxhVKeoVkpsBcs?=
 =?us-ascii?Q?KbeSMeBKo+N1xdHtEjkb6H8HEKawbAxYVw2I7KikAIMe3snBJT1COc5gUSZP?=
 =?us-ascii?Q?t24RV9S6EpK4lyt50WC+mBm5FIz04rsXeD7bx+q6KfaiEkEKPTLCj/s39CcW?=
 =?us-ascii?Q?KljyNdAnloev6BIzI1mzXbrc5s9gO3oyKutQ3IrSyiAgUlgFV7nj8AM5043i?=
 =?us-ascii?Q?GsyldP6vjeQ9STMjgHwXBkG23vM8qEh+hdn/3G+MVCUwnlQJLm/EPzjI2544?=
 =?us-ascii?Q?lj1pxBqsXAmh8ysAoDycJXUl39hJ5tfy7njHDCwRvUdJQCjDAA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D3F5CA383C617A4592BAD418E781D358@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bafa5ff-3d4a-4a19-ff54-08de92df64ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2026 06:48:49.8284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY2PPF42FDB976A

Hi,

Gentle ping on this patch. It has Benjamin's Reviewed-by but hasn't
been picked up yet. Could this be queued for the next merge window?

Thanks,
Junrui Luo
