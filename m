Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7542135A9
	for <dm-devel@lists.linux.dev>; Wed,  5 Feb 2025 02:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738723321; cv=fail; b=JBNlWSTF7QFpnVbq9IJWTjFpb2KCrkgwZMyRN6X6TT8JF8CFeUZaRyOOB7NeLTgrQfWUt9RKCkpsWuGTDwFlF6WACQkdrPQA0EJgh71vskU26toao6nAslfTLacSfdGzv4tdbql8BTOi8XbUpMmIsHAYtYnUEPeg9pFpYmgxJss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738723321; c=relaxed/simple;
	bh=XQjdO0kSgENQis2ofsxHOBXjQTrj066aW/YMERl04zk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XQ0bhaDvKn8T5z0nn4LepoheUmtGnOt5TVdPys0JHaJH8SOX8Q8j4yEa31pH8AWtrvOarujO4UhHwKPzW5MceKAcQJ1VotxVd8ef3tmC05XyXDaFtBWsf1GWd2P1y2QDkeC4XZgSKzOvDdO91XGvzuTUEpoazjiqB9XKWAUl7lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O7/o1hT6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B/UpZcwV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O7/o1hT6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B/UpZcwV"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBrDT013153;
	Wed, 5 Feb 2025 02:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Rqkqko+heyeP6Q3x5M
	iJdVKUBaWG55vo7EqqgVlmR8s=; b=O7/o1hT6IfbsOcrhhkK1B8CO1hhGnBtbHf
	evZqfeuibc0nX3oMdqPf9bD1mTh8VQKU/WhuX/jPExvzDqTp0F1rFXFqsf/VxE4q
	bd0FuCjQartZ8Lk1xy1e1mOPjdnjLhqQe2G9pyiU2Cn5rsXENcI4D3dwlXCvQ5mo
	QT81ILWbRHod4KuNzOLJGiOndIoiEfDo1RkOI+fuyDnGe+6UG69Fz83meM1WkVB8
	SnfhYthrwPVoguvjFzSSvcO+8nlBN103JM24oApw0FbJ/W+QpvWCNOn5VmwJXMj9
	0TAgwWW9G8zFwMkWGEwydT015K4dxm9d8UjXjqbt+y6RmaS1h7Jw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhbte87d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 02:41:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 515149YX037964;
	Wed, 5 Feb 2025 02:41:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2047.outbound.protection.outlook.com [104.47.58.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ghs2d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 02:41:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDSpsdd5iUr/9eoNcB3fj9OQcMgweAq9Pz3Rfy43vT1OgoRo1nj+q2k0yrIoKVulKAd/8J6eYg95OVogOyPMK354A5bC3rXX3TqqhR4ucbhgESCmUFEmTl44XebORGDnB50CioPife1nQpAHckYU8pBg7NB2N8l1EivQSnUqj0ycPk8dkomL5G/CZR0pFlQHxWpidnbzYsQCjLLXuBkWhx959DaOlYTHTld1xhU7T3JhIasXB2oC6rYm6HA8sD3gfJPVfrHwpXAxl9QD20xmSCY1M+4YfxL2ocd+POv+dTDo+LYygPYFaZ7SFWsRNEA81sSW58L5mn/q5oOCinN6Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rqkqko+heyeP6Q3x5MiJdVKUBaWG55vo7EqqgVlmR8s=;
 b=drelMpJipUSpnEQDUpXA8Znepeg6csq1FJdiKtwL/R4vzYKUrqjpedym2so4r+AzwZG56VZ6PFXeQxH5qr+hKpyvrR3LoKgeata31TGVWnoYcKIOXX1A6XII8s+1L1cHV0WbIT72Gtz+bkG3XbB1YPsGfWsyzZBZ39aJZTdmtzqGC5htObcnUklaqT5QGZqP3vq7XaW9QMZnPoKhn7/4N+P8yfvCJSavnAzio7a0p+lIwo41UTlIEPSJseZWx408NH2AysnfLgK0HJciEGlzFct1JVhPsHxOQe3zm9db/0I/5KmdlPGJ09h7XltDQjUopJsfw2/fBPO8DEHg8ECJVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rqkqko+heyeP6Q3x5MiJdVKUBaWG55vo7EqqgVlmR8s=;
 b=B/UpZcwV9Vb/QSZ2M7yLZX4/j3hH0Zo6w7F6vGbnLHcIu9AN/XVkoaepv7fpKrQ1jLfAUetYm+uyZlic+H9lMrZHMZVM4YodBnUGTomXchQy9CwSjDSP5rQWkG4oSEw/W2/QUSndIBzrieisII+7fKxFUsXN2ED8oy3SXkbSjWk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB4736.namprd10.prod.outlook.com (2603:10b6:a03:2d6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Wed, 5 Feb
 2025 02:41:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 02:41:38 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Zdenek Kabelac
 <zkabelac@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <00717ba6-0ce9-5ccd-d93d-ce5db89d85ff@redhat.com> (Mikulas
	Patocka's message of "Tue, 4 Feb 2025 15:56:11 +0100 (CET)")
Organization: Oracle Corporation
Message-ID: <yq1cyfxdsmz.fsf@ca-mkp.ca.oracle.com>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
	<Z5CMPdUFNj0SvzpE@infradead.org>
	<e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
	<yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
	<28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
	<yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
	<00717ba6-0ce9-5ccd-d93d-ce5db89d85ff@redhat.com>
Date: Tue, 04 Feb 2025 21:41:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:208:160::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB4736:EE_
X-MS-Office365-Filtering-Correlation-Id: 947f5bf6-294a-40d8-898b-08dd458e9cfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sIyuGOkhmjsQMFe1wcKV+g0tRO79SkXtSiCNbMPaFUl4/S/r8+GwmOXuuM6r?=
 =?us-ascii?Q?T0j6fyGmk+f3tQKjaMG7sod2SkIyy/pihWRhs1/r0hhwpK46e7NmSXDqEtwa?=
 =?us-ascii?Q?7MCRfQjEgPZYJP0QOwLxGKeOjZTghS2UAjzha4Wvk0JvNc4QZwYTO5N7x68Z?=
 =?us-ascii?Q?es7VqOo3ijxaQ3wX1GuVWcHlTsLjCE2d3mnh5tVXQsQri8XdtMEbbbPSfH2l?=
 =?us-ascii?Q?dWraqaOTjBxKOPtrNiRnklw1aIUnPFMkWAO3e3APLNQ8YgYa1V8nKOhUP/ox?=
 =?us-ascii?Q?oPRxmqN5VhXGVlJa2194XdAONgxorEraNF3i1lXq4rLsegAITffrdJlN9tnA?=
 =?us-ascii?Q?PUzApi4fOtRj2TocNYxM3DH/hFRW/lqIpN62cru+4DfS8P6Ti5Ik3f0DM687?=
 =?us-ascii?Q?mtlmsSC/ANGS+GB166+AFdbmtCoCWQcnIAGMCh5EvM8Wo6PlIQ2WXn/5KDO8?=
 =?us-ascii?Q?j5g81sRgMCvBWt6jaL3BZUGDFUeUGPX8onuKNPg1DudxKOA69QeQj7G5fnfU?=
 =?us-ascii?Q?LEnsQ5Wni6E8MNtuPMPpyc/UpOoLCuicWfKvGwvpIh4E8+qPBqMjDa8x7L9o?=
 =?us-ascii?Q?kqGCeYmz96fYebHg/MnEXbAZziIKnyV2jnBrkrXjtGDVtQisjNSJt5ohM+0p?=
 =?us-ascii?Q?iBJDLiw998Lo46Xk0gXpiD13kaDccBUe5JgMI5xgKJuz6A6BOa2KZfpSH861?=
 =?us-ascii?Q?Z2ROJHkcbm2XZPW0QS47KQmnp4TfdJ0F6eeBU02RnCBKZVBzpugXBFN5XA9N?=
 =?us-ascii?Q?r952CRCC20uoPAL4uywTQ5ZCG59DuMHBH9/uzZKXwtSsOK7iX6kdLlDFjp/s?=
 =?us-ascii?Q?0oussFMOY8Xls3+zGvfBgWRWcD1ENdpcZ0B816ScjEkgSg17PkbQCDJ6Q8uv?=
 =?us-ascii?Q?ukiBrKWosa0U5GrOdD34Low0KCWdBBt82wYrd0iPF+YMxlE9yqQ++TZVoG34?=
 =?us-ascii?Q?4SgENbJ0Z8tA2crYUA+FJv7JCtkBuWJBbYy/uUpXaD2l/iwZ0OeBZyIC6/kI?=
 =?us-ascii?Q?/mtQXcAd77V+vEKkMS3LDQ8cyekHRfDiPtSSodhjONjjGfS7+ALSFmhJixs1?=
 =?us-ascii?Q?Ay2TaYdniFFR7hY+h6+lqMoymEHQjbm9lbF6LkFZk43q3fk/blTn15GdRGJO?=
 =?us-ascii?Q?u/GZSLYse5si61d9blCu63zMWSiIw7EMHepICpnRm4IgeXUM8EbqDJye7Ozv?=
 =?us-ascii?Q?iCQdFI5GSrqD2VtuD2BPiefGbjL2WtioHd/1b+XAZayilqvRv17UHp3va8d5?=
 =?us-ascii?Q?x96GWzwKFAU8EFTUSX7mF62hsiRwy74TD3QEeQb24KT9vPwSsmQZaVJz6h+L?=
 =?us-ascii?Q?1eSj3/mSPHDnJdYXzh/+wGCpCT5drDWI0TvUh03jxlGGLfxbwlQNODQLi5yJ?=
 =?us-ascii?Q?ZbYjJjRkRtCfYydcEmMrdC/CmCoV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?smFE1xjJpcx+tjpSUxhMK2sjshfZhiK+nILhqEd6VWKTHCbQR9+Up3aqQXHl?=
 =?us-ascii?Q?DIcyblKMy+RGYUTGmi4rFvJemG/3n9+Mr6nSkzA2iy0Hk1ojCrE3LA51hQj1?=
 =?us-ascii?Q?4kCDhKrFMXRp2nAg0TjgqRxckmGSe8KobgTy9AYlZRj8uYRQuVc1wCker056?=
 =?us-ascii?Q?/LaBJflFAl1HnCrZKqlXkgShTSSked+XFe08o3muXQrTZi391Z7ZismY+oOa?=
 =?us-ascii?Q?tqaHSd68kHgeoMSlJEaVTYiYABo+4S9c/MB0ITYalG1d6ScADz5jE1pADV69?=
 =?us-ascii?Q?ujLbArMVp67NuinlRdyFVL2tq1583yhchQo4v+hrzoq/ZOPH0AfPxbrBdUZj?=
 =?us-ascii?Q?+I8BQxTFoLH6oG2Kw6asJC01m4jznO3TbH8jT5ozXh206YUee0ciNHiib2lo?=
 =?us-ascii?Q?a2Tqj8DxT7dPmzUQQFP0Jvx1XySNbG/zmKO1HhvES5Bjxt3uqHqQ/5EepB3W?=
 =?us-ascii?Q?suoYYQU5Qp12N8mzRFTA+K4t651YqLwaRFnUaR314jKY5Q+pRzwN9qIERvHy?=
 =?us-ascii?Q?r1yLGkmyV1Xj+niRlFSDVOzOn0gR03qTI4ibP7GGizDWZR0TtIQYmrTymc7J?=
 =?us-ascii?Q?FLaNP0Kc6+XtemfKJKTVCFAUyRX1anPnI/Ksi+TcPyVWGjqVNW+9JQ6WGwdJ?=
 =?us-ascii?Q?55hLhd0UZIctx8d/mWJl4C+tKnuEyT4kEb6xzGujE1WVrlda7r81njL1eisL?=
 =?us-ascii?Q?T222xTfwHGTOfbV/MNDZ6l+ax3A7t45pEh8JU53IeTgbEXTxoKOLHtFCZ0x5?=
 =?us-ascii?Q?tiGj+iYBm5omVXPIf3fciM9OowDNiwZS6+nwZmMFfFHI14TumJ7IKR9LBAK/?=
 =?us-ascii?Q?SdAPpZJzve4LonSiYFDeUqhrHylp5bcdjg/dUtJ0a9weqF/Imm59s2s7MtTu?=
 =?us-ascii?Q?5UBmdHeUxIHWnuXGD1ftt11TwONGvUvkMPiSFHCThw0ce6wUdhFmogq37OF/?=
 =?us-ascii?Q?cc4bUDVWk3JVL7x1mGuREq0RG+jP+KbR1jcLLTUytfwldruyKIJ5LTX9wa8R?=
 =?us-ascii?Q?hyyA5JWKQztwfqmlsN9pGPuuEIgY+1q77J+jHcHzOQfNRgwgC/oXJyYaBzAl?=
 =?us-ascii?Q?m9rDtRtKdQIxQJEtwhrQGbFRP9K7oIPEyHmY2MylkVQ5yzfXswuikbRe9gxw?=
 =?us-ascii?Q?XDWXbo3WvjWM9nSUCdYg7wiFuPWYbU7pxS65nxn3Yf0L4TCgIJmCg3J3/ttr?=
 =?us-ascii?Q?n2CLB/2HjGBAPjZ08vR0EmwWbiTq3uKWg/1bnGLC8ntmWu9Ne+zjuWqBgf3f?=
 =?us-ascii?Q?UfP9G7SEdiygYM7OccQmWWs3W23flmts4FqBb0xZSt1JrUwYJRrjn1jF8JZw?=
 =?us-ascii?Q?QKnv91xWzdpe/JkOTbvYPM6zLnW1Ib0SqqTOOEqWgokIgAYcjTm0nESARFkz?=
 =?us-ascii?Q?C1jkK4X34tYzBRfZ+VWRz2eRnkBQlZ1KUDQouFrb/GpONp3kn9H91IcdN9IM?=
 =?us-ascii?Q?EgDiOoucuuGaimnuAAwuX6qggFYG0671ybZQC1rHNX8bHJeuW5p3ldXYViuL?=
 =?us-ascii?Q?yeyoBHIizPQjWuXoIXkNJRjaUYPp9FNCOb3lEbqhKL1MEW0nwiMgTMbn+aLX?=
 =?us-ascii?Q?zfYIJaEowlokbemORNfp+WkA//PhXUXUD9SAmCJMuzQZ9KPSxBvL32U+0lz+?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VvPqAMzFd+5quXB5ncBO3nesBtqRjUiRady2GGj3ubnbA2IX+fMBNUARo6FYH+1W1dgb8Wneh4NDV/QzGePnJU4qnLFNpVwAI0YAadWZlivoVKfBbqp3I/z0Bs7+ykgfHTScRm7anQChBazVWrlL0howW9CIZbR0bNd6SAhzNwockc7H3g8tv6tkcH1AIENFsNjUSdGzdKhqT6+lA6YZQ11bpzEvtNDu2ydcqQ5BG/NJPx9CH7U0WjRdnvh2C3KqKUzccGMMiLru0PcoHXBJ2keCquTkTwOISBVp1NyJPi8ngtwnnmS2p/AcWA3KwHdXRWWkBObbt1S2e/L6d/ixIgBMbUMSS3CXrdIi5qAbkKrqUGrCxqdDWuvohizjAw5w2oiYbtizU2uqTwWn/I65U/Nk0LZGqd7bJaWkCX02nA+ok7FaavhIarpC3ZMTNniUEBHIVqpNFsd2iC41as62m8yZeZAFAVB9/tBlhni5QrEnodnyKH30+Tb0/4e0yqRR1PS3kSoVXo/gN7a5jrYULr09JYPWiS+t7fUe3RweCF3XusI2L6LKPPnpnn1wX78IbR2biWFuw6+EpnLyRXdMCwUzAMWUcy+vRVZ4g89mqcg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947f5bf6-294a-40d8-898b-08dd458e9cfc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 02:41:37.9369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sv/nebQLgaABC0XN8CE1soxrBUJFlGRDNG801Bm9hy79CBRhngV3LojczdBrWYBwwi6Iz12M3R7qewOMLfEPE4NWJDOmof/x6kGpoJNKQ3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_10,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=787 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050016
X-Proofpoint-GUID: HNEwnEC0fhd358GW_184lJOCTGf4zUgN
X-Proofpoint-ORIG-GUID: HNEwnEC0fhd358GW_184lJOCTGf4zUgN


Mikulas,

> If there is some particular SSD that has more write IOPS for 8k requests 
> than for 4k requests, I'd like to know about it - out of curiosity.

SSD blocks are getting bigger and bigger, some drives hide it better
than others. Also look at all the efforts going on wrt. supporting
larger block sizes in the kernel.

Can you send me the output of:

# sg_vpd -p bl /dev/sdN

and maybe hdparm -I too? I'd like to see if we can come up with a
reasonable heuristic.

-- 
Martin K. Petersen	Oracle Linux Engineering
