Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC29120E6
	for <dm-devel@lists.linux.dev>; Wed,  9 Jul 2025 01:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752025179; cv=fail; b=owHBwNAfVYMr08YGJEwPm0omPzqvvd9LF+REBytIFnaXj9caSISVPatQfJ3r9djTw0HvrokuJ8eioXtM2cGm/AGJz1EO9QN2A7oKMcKem1X7xD7YURO0EFwrRhB3k34nLCWeFg+5+71Qho/C/UWDHvIcXtaE17+tQODR36KTfo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752025179; c=relaxed/simple;
	bh=eaxmfT2KLyEL71pGJzSXqApsVbPQeaDki9aXbo3ACs8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JMw/pRxhc472ENyG20FLnaKPMjC1zbkzm8GjbeJbLKubjHBxcqMd+lnD/bwgtSLksAKAFfOaTxHu6uA3fMKhbJJ8mTEPqNBDJIXaenE8ueCmQOt0tP1ydo301zHLA6ORdL3/tr3qxd1+XRnOUB+UNaJj+xc56FM8juXRX1sDYb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qLgBBT6r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E7f6+Zrp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qLgBBT6r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E7f6+Zrp"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5691ZrCn026370;
	Wed, 9 Jul 2025 01:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ITiTjyqhozRO/KzMPO
	fn7/B7726GddYAf98kYhZcP1E=; b=qLgBBT6rjo6eSSnpQMvO7Pau3h6GtIFPS5
	tXkF1mjO6tTA2JY2geRjhuQY1OZRlXjLzq7TiNz7vGZWXs9B9mNv25bh7ZnMPCcB
	Cwfs74Mm7eolJKgXzf57mZU3w5+N0uY2CJmXBJnImKIMQJ/yS2z0HzYlBnldKO1d
	BFmiq9dGriDvj4zCvW/elvmSTC95192nyUfIYAHGEyxUSgzN34WqzLUgPZ1A4Ufr
	uODteoGDWnwMZzzQ1Ajfx/7aZUzg+ahxD8q1T9bGZu/Gz2vFB/KyvkirdgvYOeYJ
	4mQgR/YeSRb4X90dW3/nhAWy5PVO+M5l1JzkrRTSYXtf+vPXdJIQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sepq00eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 01:39:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56912D79021402;
	Wed, 9 Jul 2025 01:39:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgaay7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 01:39:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yyYDmdWORicLWOw5+EG0byGPqPyoyCZ/lK273DJRykEOGeRdHCRXT04oqIqY0/d+hhwOXK9FvBJjdmJn5lDJ3voYa4MjHnMKu74fRpKxJK9pjNPI3DM3ino9T221pKz6RAMmc256JNMSUbZ5Z6yJlsHJxlpi6Sq6NCdkZEyS2SJpgGA4eMoCxErUfmdoUN1dtUWK9CIUVWDDUc5mVj9fImVHLe50g1kdnJ4uHnNxZP6lrsN+WzqKGeBwJhdfz7V5kxHd04awZ2CIJvKaMlU6k0JQDLl0YY5a78zx+ZahZiztmrByVXCkceEdt/xLehrXnuPSHi9MsLCjL+FgY3Ebyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITiTjyqhozRO/KzMPOfn7/B7726GddYAf98kYhZcP1E=;
 b=cWpdI6+Kje6uEWAt5FLXDbkV9Gcf3YyRb3A+mf6JHi7+5R0MMIDEZIlHHWqH69Hm1ipTkcmzRgriWTLg0m21Bxsneoj3km4JpFVL33OJZ0lw6odUUicjp0YGsXypOiltLbsksYc6wEzCwi7x1ZV0YKMEd5naVFYxe/Sz3sbAI5wp7X05tQqUwj9DaApzvIEp7AdoAI/hiiQM3y1z7RErf3ulEkic/2A6B3BgCK491Q3vxNsqNbIVtHlX4xGhhGmTSFF2WiBqDVIH8yi1IDvcuMw+bQEJnUdPbmfMCTyV6UYx421bvseVPKWN2Fk8hNnHRUYWzvs4jHNevcl/mxYHlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITiTjyqhozRO/KzMPOfn7/B7726GddYAf98kYhZcP1E=;
 b=E7f6+Zrp8wolUdOLJYpRVVby6ajTCk8KOsc3P//FIPEQ+AIM5EzocAvt9Uq6c9OhrVEJH2jokGTssXFj10qWiKWe9qeGIP7rs/KDjmd1OnjRfTCKmDKx2AZzuNtWPnEb9ON6wLyCwIVv4FvbuPQk9Zg5BOAG0H4ul16EFx8TX+8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7832.namprd10.prod.outlook.com (2603:10b6:806:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 01:39:13 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 01:39:13 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, <axboe@kernel.dk>, <agk@redhat.com>,
        <snitzer@kernel.org>, <song@kernel.org>, <yukuai3@huawei.com>,
        <hch@lst.de>, <nilay@linux.ibm.com>, <dm-devel@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <ojaswin@linux.ibm.com>,
        <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <803d0903-2382-4219-b81e-9d676bd5de1f@oracle.com> (John Garry's
	message of "Thu, 3 Jul 2025 17:01:00 +0100")
Organization: Oracle Corporation
Message-ID: <yq1a55edu8i.fsf@ca-mkp.ca.oracle.com>
References: <20250703114613.9124-1-john.g.garry@oracle.com>
	<20250703114613.9124-6-john.g.garry@oracle.com>
	<b7bd63a0-7aa6-2fb3-0a2b-23285b9fc5fc@redhat.com>
	<f7f342de-1087-47f6-a0c1-e41574abe985@oracle.com>
	<8b5e009a-9e2a-4542-69fb-fc6d47287255@redhat.com>
	<803d0903-2382-4219-b81e-9d676bd5de1f@oracle.com>
Date: Tue, 08 Jul 2025 21:39:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:510:23d::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: b68625fc-9d32-4902-b8b9-08ddbe8968c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TVEjaWpJWs3Z56q8s/N4VN1hlEaGVPZXJz35ZtuuUJbEaMN1GIN2m/5PLCIk?=
 =?us-ascii?Q?FhrSipaJDdYVQEQZN8J7+fWXRHRVFaLhmaKgyNaekjfjkhqw0kwHCKIgqTQQ?=
 =?us-ascii?Q?0MVXhSwDUlwHaQ1L4c+XgRSx0jP/oJkc6MMx04SjpJJyGvz2mQDpP8GFEG9x?=
 =?us-ascii?Q?DPv1viGFFb3uI1S/pUe8S+MszXiqnq99Vz0lJeiDIAZPtC+/sbuwhnAxhfSa?=
 =?us-ascii?Q?1+R6UPut2GhTD/RkLM4j8UVc88it+vZyVbVr64lr5s1xQ/kaEdAeI95tOF6K?=
 =?us-ascii?Q?/V1I2blb9p5WUVh/E4dO9KzGnL7TdqEYocm1jPhm+yIZuXOC3bCADe9Q+OCk?=
 =?us-ascii?Q?lniKYV10bck+tQnvIjOKrz9N6gryiLCgwDyTcsQKOILJLbAh0OJBYmmyLDwW?=
 =?us-ascii?Q?gKjd7UaLlcYk4AUir4jijLfC7GTNfsvL1QoRBxsZsgDS5NdOnA/D8IfiUQMi?=
 =?us-ascii?Q?EqosLHAu0HNcxXHY3I/GcjBd/U3/t/baid9hFBQQXgx24v8EGkOth9DskyOs?=
 =?us-ascii?Q?OU68TTcxHmvCw6Pg+LiuonINAz2th8WIYBeNG1UamJawNLLZBfSjbP/NJpme?=
 =?us-ascii?Q?QUHxSCC4+P2YQXmyR5BRZVPt8gGzdpdi3E9DurruOAU+Nf0+kujyT/rWISW/?=
 =?us-ascii?Q?HPUktSwy8G4l9EVYXaV+KXkLJzDIWxbHDJP04iI/BMN5dcmj9fBZNfYSaSvc?=
 =?us-ascii?Q?u/J45dH55Pj4gjLyu80djLM9PUGGjZpJmhU9V/Ltdrwn0KKM0hA9MiLArQzZ?=
 =?us-ascii?Q?4oEPlPkWVZrSoy80k1Dh+Ybm4x8Iuv72q16L5/bKT3moFJuaHOoBsbrVF9RV?=
 =?us-ascii?Q?YW+Gq7T0Iw+5UtLsYHhNDuXoLxZ4l2K6JvpfX6eMHZS2FruH/+2YPFaLvEL+?=
 =?us-ascii?Q?aiq7dwYiuiQFVo/IG45R2gmM17rcKdX0MYKJ30ENm18aRERr10RbjzXWYCsh?=
 =?us-ascii?Q?H5bA91UrLaO0gs4fjQT1NfZDcC1P/0SFSM5m0hJgE2xDRptuWsPYhAi8aDTE?=
 =?us-ascii?Q?NMRKaTfS3SXAIIBDNEis8nzZnSpf7DAoGiXvgB0buraXlxADrY2Cpe9Y59aO?=
 =?us-ascii?Q?IcDQ/jWeQih7n4KAnXTFofu23IGm94tj36NVvHeuZhYn5Fiy/rRnr5kfp1fH?=
 =?us-ascii?Q?blSBj8ssYxxF904o55IUbOe/wwc4QwI1QslUSeVtWHSTN3yN0MEbWysUl+Nj?=
 =?us-ascii?Q?cMGFYUgJ//hl627B1YqSvjjS8n54O0JJwxUwRuuspHg21Xj7rqAIJERf1T4G?=
 =?us-ascii?Q?Nqz3QMLCSIM5zucYqMKp3ImgcWfvEhvsF7VisedxYjJSyi13/4wvxLdmTaTp?=
 =?us-ascii?Q?wdPzWwvD+e5PxRDymBEFwfSzzFZsu5Y5iDkAHzzCRu9EqeO9zml+RBpKDKKU?=
 =?us-ascii?Q?x5meegCDk4I1AK2F++l8W3Eibe4pt2Ebn9RSlgplDvIbWZzjbrB2sUd36r68?=
 =?us-ascii?Q?xnM0ASXWnTg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZkGWhfnqlluqIhKgE/BRyLNzqGKPTwyVnFmOUl9FRddRK7jBVilcly7XJ2jk?=
 =?us-ascii?Q?taIvtaxLxsKQ2sVrtLjGa0Bh3vHO43MfVo9HWuuxCRQ7fL/2nL/81mWePQgq?=
 =?us-ascii?Q?h6w8mQBeQcHaogUSvFhzpbz4yiR748vFvtkUX4BFveboEmWvc4ER3LQ9B1Gy?=
 =?us-ascii?Q?+zNbbwtXW57KovJGh9RVJ0lqBifsy57Wqjs5ExjKSZLAFjkCmH96J8nqxlip?=
 =?us-ascii?Q?e5VQKecq9kvgH7JuY3VVX/iI51bCT8/DgwChVGCd1qHk9GJcKyopCXcDbHYE?=
 =?us-ascii?Q?Ec/CQBZMk+kPjF4ie1pxLom/n6sLfScFpu0kBlZzjldVOMQRI+Dv8htqv4SL?=
 =?us-ascii?Q?YhgKnfXBVvQKLBrkj+5GGGkne3rRS3ONRMB660lWxvlYgO5XcAkjgA9vKQjn?=
 =?us-ascii?Q?hL3PPgccGmYY79M+6Oqu6eYm+l68243Md5aLX4rFiJFiZFTrP2fdckpfU9kA?=
 =?us-ascii?Q?f132LpdGtcbR8qfzd0UNXGozv0wsqeeLCKjzTkVSQr5Sm8XViDQihKOx/TpA?=
 =?us-ascii?Q?TS2GnbJVYr2P9V8fkwoXqOM2+GnCdOKy3EwwvubLt5gVSZ4Y84ag8i73gqQz?=
 =?us-ascii?Q?tl0DdNOLyuuo+oXwCZ/14jNWCd9hWH13XpLcVbuj8n+wyuEIAEl2d+zqc92h?=
 =?us-ascii?Q?5WgasPx1I2vGGv7O2iho5xcVXJnDU8OfKdW+Hxtju6GgJZPsjOS2xMSugNA3?=
 =?us-ascii?Q?MV1uNpAhvR8OEeLGIPFBGDq/KELTlSsnyU8BUZvXtEz13ioCoD6RvqWRWkz0?=
 =?us-ascii?Q?IE4ICrNLS1fsz6CjF0wtnKpZPVsPWdFzrwVB41UeNkvOATxxO9i3qDAZaFN6?=
 =?us-ascii?Q?7Cs9JLG6JlWLFdqvEr2CuVsCzaPAxbeJxKP+UnmF5n5OaA2TATqBlw1TsQpZ?=
 =?us-ascii?Q?nNOCKgYp3krReig7bTiFP9JG0VPnCzPq9dGFFV7t5/Tg4tWj6VoMfpUGCzxF?=
 =?us-ascii?Q?Sz72FrW8AHG46KK6Vu+qdfA+yOKI0FTxyRpIlPN7ik8aJSP5y8MrKLEZIUKG?=
 =?us-ascii?Q?Isl/FocNYfMT2SlkKuko2p8F3ubOt5bt2405cS2L3ob+koLtGv5sGFVKnrSW?=
 =?us-ascii?Q?fBCJ+UtOnxuvKMcrhpzdQyig3YbsF/hzSKjVOB4BRSE6IlKRR9Da3bpcZTib?=
 =?us-ascii?Q?P58ew2MjkVuIhKzrg3C/191c2tE2fcx5o9MjeryDZezo91DP88UgM8p/XqGt?=
 =?us-ascii?Q?KriydwytkT5wSZsEVlbFENQt8Nfw7k5tYZHL8EQkUkrQ06XwDqynpj5U3hm6?=
 =?us-ascii?Q?F4bVdjdtb+IpFYkR+j1oTSJWcxaR4x3LfEqBbV+1GaY78rOq8S5oezYZ8Kmg?=
 =?us-ascii?Q?gWU2vr8UzWB1OFVRHHt9f26D7gUKzZxWpvHjODXHcTp9wYPiISBGUGdJVf8f?=
 =?us-ascii?Q?YtEHwLH+vCOJiJhRwP306G4zoG5scBhSMstHRgg8A/hoxp8yB7FzEyhtkCRr?=
 =?us-ascii?Q?LkaoyIPM3+0nEdY94Kj+7LgeDSACNvXczCB9k1MbBiulhRmGVCdArODzzurI?=
 =?us-ascii?Q?PwlYCkf5+8KT8o5VQo/cuGvVJPi3+DvT/RqFWe+30QYbidyg8FmdkousE9lI?=
 =?us-ascii?Q?F8V/BOtfMZ+mhH8p1fmr/3C158+cath/nL13oLAxSN50zyqgaSwFuWt39UrV?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3IeeuGHFwDt/8hYW/G07FdEqPdrtkpZ8TxvHn7DEDUIxYdgOWrfNJaTy1AT3HaKBYa2A8h/GR6xwCCNCDEJ9r3q4nHnwepuTNpyzQwYw+icWgG/qdrkcOzR6swlAiySk1GAAPcm896pLIvnEc3EBITwS7K+uuC+IIByQXczQVUCkFPg+jNiI7pfDOgVRAhcYk4mfbIqXLwpWwaNI6GeQQ+IOYqyiZNJpfBtJIkYgJ46w+TDjDlp66cvZQdfQ++Wod56svlzqN7kQXD7yfJzUn1AI5F7jl+Y2mCOLjefVVCefxtn6jJk0au6lT4EpbflyBTqyv4BaSxlVtAKPbV+taM2LM5CCPtOdHvMoj07tlN9/JxjOuRV+xiHwRz04a2qXaPE5RVVyA3etwOl0VIZtize35qpG8URwIFnGys4z0fStYs7+ATBAr3yZRYhzCzLxF1D+hihCWZ4y5d432KdvmHqtO28KjBq2pz/FId34Tc2uYv8vPG9av9QCiUgvjeM0ki3Qzf+2YgXHX05Mc2twrlL3T3Iwqo9ZbdvazttjO4GAxUvzd1+TVUlLApkDv3QrCEJmX2LlaiKkRJ30b4/T5irhznvMJVsaFc8kV/LrI8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b68625fc-9d32-4902-b8b9-08ddbe8968c0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 01:39:13.5028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7xYUD33KKlKdRbLLLFHK2jES6JvUyWuWZKDIK/a1kskkGUD5Oox9up0OHFB9E3/sathUSdydYQQW8Xyb+8FYKSR1X3/iyKQRF8tLr8mS3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_01,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=919 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDAxMyBTYWx0ZWRfXwNPmY9iJG/pV PD+5QoPrA6Kzo42ie9KsivuhZL/g2OqWU1m4BOvKyPpO32r7E9zuNfhswXig460wTElrcr8ABV+ d0pskrq6QA2GhtDkoruxBWbu/YHrGHjq5FzkcdtcYyauXWHpagkuZSvmqOUuafUUAnqE7DDPwLr
 fF75ZBAOeoCn/vF03EzWR6ionULW4pbsKrPABEUPRii8I5GzLYN7rkEUxJXbtvJqUMqC7U8xsLl 4A9SvATsps29RSr8gReJ1VR9vPfIQde5rU6S1/WNGTXGhop0pacIXg0j02t3sqIDTJeW0jMkk2X bM3Y44zuS9nGkZw53lSuGRRhfblZc0t57w2d4SIvtdZQiaMfJE6leh2qCGRXuIsLzaAues4FqgL
 j3tmmiWOq4hTC+amvB1WAC7SE+Gao6d04Oo5sHG6sEvXKnMfi6yKZkChR6U4cziE8xiA3mpw
X-Authority-Analysis: v=2.4 cv=J8yq7BnS c=1 sm=1 tr=0 ts=686dc84c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=l43HSHfcXPU9cvbv6dEA:9
X-Proofpoint-ORIG-GUID: g-vGH5TiSIKkeJuSUjS1uBgAdA_5WxnB
X-Proofpoint-GUID: g-vGH5TiSIKkeJuSUjS1uBgAdA_5WxnB


John,

> For io_min/opt, maybe reduce to a factor of the stripe size / width
> (and which fits in a unsigned int).
>
> I am not sure if it is even sane to have such huge values in io_min
> and the bottom disk io_min should be used directly instead.

The intent for io_min was to convey the physical_block_size in the case
of an individual drive. And for it to be set to the stripe chunk size in
stacking scenarios that would otherwise involve read-modify-write (i.e.
RAID5 and RAID6).

io_opt was meant to communicate the stripe width. Reporting very large
values for io_opt is generally counterproductive since we can't write
multiple gigabytes in a single operation anyway.

logical <= physical <= io_min <= io_opt <= max_sectors <= max_hw_sectors

-- 
Martin K. Petersen
