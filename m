Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE8221555
	for <dm-devel@lists.linux.dev>; Fri, 12 Dec 2025 02:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765506417; cv=fail; b=nmAVS6p5FE8PWNB4nsZVbZ38m7hCzgyZ41+bDsUEeOEjKQUuJQOU06Zd25WJ1MMqCM4lf8KNhklNASXLfLWuMSzXpM8TgWKihI5G3VzNXteLy2zXxwr3q7I61G55vkzsEkQ5jrXRjqbyD4up6DB1y2xD1AMS/9ElLIz2F6mmto4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765506417; c=relaxed/simple;
	bh=5L7HPXMNZjpb5vGXjoBOqKzGR1hro+lOsRxcPZIUlT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oo0p9Fyc9t6+dMR0QdL4+arvf0HsTc2kZ9jRvOeSHe0v2btOOeEDdUGpDPHThGAON8PePq0OfW65Uk257m1xAEDhcL2I7zIU0yhiC5s7Jp4EPObLgCKEL2eyjKIB15QoNKkc9i/RNQ/0lYP1NnmVz7L6irStjECKZJFc2/KcLB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=hKuBL8FM; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="hKuBL8FM"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC1oCgH2983746;
	Fri, 12 Dec 2025 02:26:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=5L7HPXMNZjpb5vGXjoBOqKzGR1hro+lOsRxcPZIUlT0=; b=
	hKuBL8FMQ8YysUxCFIsnjASbKyzEtW3x5NMxFNGhj2YRFiOLoTH/bgWmlrvPqKni
	8sf5AKc1g40DYl3ZsHlD0euBl148MwY9Rh6Re8BIkyJtFPwFsy6jzLZvbLjwthj9
	EpZPQzKjfGrEdB6ILvRk1wngwBylCXTpvWZAqcW25kWmQ80SGHxpKSRgbWibHQ7U
	+vCNq8qaAHwj6ucGXFI3m+EtNZjOgKCl8UA8u/akNazdHerI66RBRdnZC7jTNzqM
	XxtMJkOt/SQNGISMA0oPqtmNuHtDlnJHRp52ApuU7L3NIjs7vYGP07bH99h5JWCe
	f00YysTyfrmPP7VrtcWKuA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012029.outbound.protection.outlook.com [52.101.43.29])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ay01njwvb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Dec 2025 02:26:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uDEUQ6MNfLtZ8eiKCLZDtnxrh8oBYw7tlYyGlD+N1RZvITO7Gx9P8nNHW+Ie5/RRkWRYf3JLI3oPGfn5/oJeh8Jri2l5cxrfgQo88Qu+GFbU0DrmC7a0euciMGf2DSN2g6ZJE0EmsPRRZjcYPEx7/NT3zuTqdRMOYDm9dwgRWuR6JvjBUNZ0X6cDaavafXW12YBu90sFTa6otyM/vF5fVjXEO7UOh0r26XcAFrER/4c+h4RtRWLJYoSeK6YsHv0CZarIUx1z1zr7HKu0e6TX7kYsunqTi+feEiEmuIGCXyMiWUAlKmqxhJ+aregbjd9shFX6T4jjZkESeO3h10jEEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5L7HPXMNZjpb5vGXjoBOqKzGR1hro+lOsRxcPZIUlT0=;
 b=NrWw0ApZHEWvX0sM5sUXfh8AbWzXOP2z9OC/kZLK7YtjkW/2aEwBp1bavmMBNFrvRF6LfWG39LnWaimk60sm9RNkfC2Wwo1x1DNCy8ggbgVPaJ9zMGKRITmoUb31DU1K7x3ZYarij7XMr0oUYS8SwvLYw99LYnSLP4yZKEeFYHqlqwgY2FYCZpiQfpz9RUZ4WbKBPDTMJonN67igj+64uqrIQIldBW7+WFDi3AiXebhv6fR2vRw8DuVwA5Uiz3KB/sWBuJ1LtYXjI3mGSm9hRDtWC17hLSmjNoaSH6gr96SpnrZZoB/z0BNIIMY0omE7AsN/VDBU94bYfGF4B7ggAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from IA1PR11MB6489.namprd11.prod.outlook.com (2603:10b6:208:3a7::8)
 by DS0PR11MB7631.namprd11.prod.outlook.com (2603:10b6:8:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 02:26:42 +0000
Received: from IA1PR11MB6489.namprd11.prod.outlook.com
 ([fe80::62d8:4560:90f:63f4]) by IA1PR11MB6489.namprd11.prod.outlook.com
 ([fe80::62d8:4560:90f:63f4%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 02:26:42 +0000
From: Jiping Ma <jiping.ma2@windriver.com>
To: mpatocka@redhat.com
Cc: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        jiping.ma2@windriver.com, snitzer@kernel.org
Subject: Re: [PATCH] dm-snapshot: fix 'scheduling while atomic' on real-time kernels
Date: Fri, 12 Dec 2025 02:26:32 +0000
Message-ID: <20251212022632.3689324-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <4370a6f7-f472-7fc9-3fc1-a28646d8f37e@redhat.com>
References: <4370a6f7-f472-7fc9-3fc1-a28646d8f37e@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To IA1PR11MB6489.namprd11.prod.outlook.com
 (2603:10b6:208:3a7::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6489:EE_|DS0PR11MB7631:EE_
X-MS-Office365-Filtering-Correlation-Id: 604f85d0-d751-4d69-18a4-08de3925e304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pn26ZKiT6c+fT8d6EPerguE2NijOX5Ig7GsHb6nlYnhoPAupJQnJnoBawarN?=
 =?us-ascii?Q?WcRR4sZ2wfBrvyIIBFijngLTvnZxfAUWcxeIt186mrFdum3WJpQ3FO+QvkTf?=
 =?us-ascii?Q?BF0pJIxsEVhb7i++/OJ04tkLxaCCRjbY5MjJNV49xDoBWy+j9DVTePKnliEX?=
 =?us-ascii?Q?8C7uVK2LvFi5C1AbZ6JG5zRYIBn/EyQZT5lOm8Le0huLONqN5EahMdA/mITC?=
 =?us-ascii?Q?Nd2khplaYtV45dWkpjmaENM0599SxVKVvz7NmJIK0idsfYbNmttnOOCq8WaV?=
 =?us-ascii?Q?ItgeSCrqt116hueyWJlo6UuBeYK+P5m13QF7tBlsJk34kCYh+jVdX13hzM7y?=
 =?us-ascii?Q?rqt+/Is7z/mOeTjIWHmsm4OYuIwYMrQIqYBl1Y3ptki7RTCbmV4UtG04d+n/?=
 =?us-ascii?Q?v26pgIop8BIFbwhb3+WR3Epg6IlEHzEJjiXFhp7eHlxdV5qn6MeBuNAa4wcx?=
 =?us-ascii?Q?nuHGYI9TGEOLIbWWGTIlAWfWD+2uhdfFy/Qne+i5dALGgXT98JgzcoK/Hh37?=
 =?us-ascii?Q?clq8IQI402rWeWWGPKL87e1Zuyfvlst4plMR+OofHqe4+eytzBbsunONR8nu?=
 =?us-ascii?Q?+joh/iByv0fiYpExQ5FQf0nw+7Geltzuv9DUYhlE1opF4pX0FEmqqYAv/q9O?=
 =?us-ascii?Q?0CC7hsI4HZzTeL/TtffAHji7J8IMsVZS+ZxHcb+DK75vEki5UIKociBF4mh3?=
 =?us-ascii?Q?oWX19WqlO7coXSVoGhNdebmUFoLdmFGY+qkk39ktpEEBgKHleSwV6KMvaYTv?=
 =?us-ascii?Q?E4wu1/kuc63YzGlsf5CJGm802oAkkvs1mDidEZY2/N0RMPe475z0qmtxIgBO?=
 =?us-ascii?Q?ulgbhGY7ZH04BW2o5sg64GFNsH9pwvjsIwr7PyzfXNkXWHLh77BLVsOovf0q?=
 =?us-ascii?Q?DeP5uNiENsux74EPwii1TX2hG1zD7YH1GSM/PsWXaVimDOzlZzeMnGiqwD7W?=
 =?us-ascii?Q?YXIgrncfrX48T53dV6br4rzkHQ2pFQ8aWX01fQupdw+ea199vsF/g8hviwJa?=
 =?us-ascii?Q?dVkdWbWbgCOvDk0YAOtcenfRXNgiHJxbH2sBXPfcHXviW+IqzanBqQ9TK6Ts?=
 =?us-ascii?Q?qqZ5yt/0ch9E/CLl9b/62DWyv/D5gmv2oOcchEineqzEx6+wAdNn6JsqAss7?=
 =?us-ascii?Q?oTVY+CsiIJ0z5ZaUhbo5A2Ggym4F2Fi6w0HG5Fzw1dcBetyqnxms2FltIEag?=
 =?us-ascii?Q?/4PglVW6SZs4QMWhDp9IEcmEEttTtIYuGq/18jswJSKjQ//kHg3B75UgKuwk?=
 =?us-ascii?Q?MKBfVXr9eYpIVcHxkU7nH107yofgUEcvzYuow1ufDBNM/a9v8Wh5OLZd+1Zq?=
 =?us-ascii?Q?13n8R2FJ6H5MrpIScwIymfpI1weqmIcrcAm8ONw39V6miqKCuZV6zPjLesiy?=
 =?us-ascii?Q?aeo2/VRTO7KBwhN44AByypucCRg35PNnbzbRUljW5WVC1ZkcDyCielH+waYG?=
 =?us-ascii?Q?4ug5V8uLB6KKR+yJgyR9YNyo2XmhZq1MnZfGFxEFq5PxQLv+WOK4BthM2hJj?=
 =?us-ascii?Q?W/T5249fgx6qLelGKvJa4VW/9WzvIi0rBmdb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6489.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v2hi4dcCycuIzTXnHGeW40sj6Bg/lHcq/UL1idyonFdL/VwpFevoRIsefj+Y?=
 =?us-ascii?Q?hrrpGsqhdehNvMNrSbUMDLJNWkruiKvY92t9qKYRrYw42IIQdwZcKuowIzlx?=
 =?us-ascii?Q?l3dmKa7Ug/x+yITVcDIVPdxHo7sSfxaAP6m6EwMdSkcdfb/hChWz7LrQOZhv?=
 =?us-ascii?Q?OW7RZ0e1d7bNLBKToKZgN5FSp/+Bid1DYcVWqFkR5qWQpG7YFc9Q7OHNGb86?=
 =?us-ascii?Q?r66LYSh7vvZP0HBP6uAJ4JKCTsqFNjFUZu7J9XgsBNEO6W8bwS9/wgdMdcFM?=
 =?us-ascii?Q?jcKCJ8jKywM3joX6NxptbjkkLlEeCSH8fF8MmfXAgTt+L9UwKoCj5EDtLwVP?=
 =?us-ascii?Q?kxZWF3rZOKU3swb5MeRSZvd3SKTDWlRjiJOrvitcFCAH+TVR3z+4Q19NtDsU?=
 =?us-ascii?Q?KFZvO7y60i5sco7Ld1nU10+h7xdFEVKNlAWSgeYRNL5iP67vxLryXPRVCkLR?=
 =?us-ascii?Q?J+7CkHOvVyKm+F9a6/PDmnkV/uzMWA9gBxaDNVKIh5LLayjXbMAv0MVgwUPA?=
 =?us-ascii?Q?0wG1QMvNB3E4bu5DAE4CMWxdaXzVh9dZTe8vAvYjgsh1+VR1qFVwraiaOlwS?=
 =?us-ascii?Q?i2kK7pSnPQoo8az003tGip9FZfrPYe7EmC/rTjKZCY9CoRiCfGE0M51KelPN?=
 =?us-ascii?Q?ScLOWGNanlcNxQv2NZKX0G4dovu8yJ2hOX6V6gTgt0wKTjtBXIrC2ozBlyjI?=
 =?us-ascii?Q?jWSU4BFMtzA50jzrc5rzEtgMJErIG0cfkycTAZoH2XfiTf9VuHlUaU6g6Uc7?=
 =?us-ascii?Q?5HsXNQtHwHM5LCR4KhTgwmBiSQ0zVai7IliqS+wjX8W++/H1dc5KCvhOhOlk?=
 =?us-ascii?Q?K83XrZKGChaq6cNtC44fgibHYqvz+QBLd2R65sNJmtK4/UH/tgw8ekKekzCb?=
 =?us-ascii?Q?HCe0TVN+3Kh2DmrBH2YNGd1zvmdA5WBQxDYYiemrHANDp52fzBNOT4/485no?=
 =?us-ascii?Q?bBygKi6D2Ke8QlS85F9rQx8Vhjmu9nxrf1F/kK2xGOqAgSRDDPOwmdSu+zj3?=
 =?us-ascii?Q?msfH+Qa6mtBWJal9CbvsQgXXW1OKuMz1AxGTwNsNqAoZEjIt1v0poXt7xWoY?=
 =?us-ascii?Q?S9x+lBcLD3pS9NdR22itbEz6q6kkGWXpyrh3AYqAxbnoF83MORvVAQNEpmHt?=
 =?us-ascii?Q?NLb27gqoG4DEebHBB45ArRjQUDvdcNzjdKy/+mVQRjkxGVd669Gi56KpAURN?=
 =?us-ascii?Q?te8+0KA5UWjspT6VeIROJjvl2dT+wPqFey47hNBg0RlxmWO1ypjkZODzBupw?=
 =?us-ascii?Q?CeZd2b5t0FAOKj/xWR5MRx+rBnKxUFaSEx/NdzFLf1bQS42PbsB/MB7IMo8p?=
 =?us-ascii?Q?ICdxyy7wAMYQ/kd+WQVRR1aPoxxpIMHt5Wi29eYAQzAPbOlQaIm9Co8W+7i4?=
 =?us-ascii?Q?TYkwqUOn+NpKko5qPdE5K6XLmLaUjs9LdJgqg9dDQexF8z1VDZh2ZpCZfMZj?=
 =?us-ascii?Q?dGpZrIw4g6kk75KED3ZRj2KYOs/PGiwPBMv60kaEk7f1FmzjgpOl61l3ogjM?=
 =?us-ascii?Q?jE2DK8GQGYce93YnNxHz1RPnuRSNLjkiOeLuCyBIy136AOI4M2HSjcsU/kto?=
 =?us-ascii?Q?6mSIyrTjbfmVQARAgm4GliEVHO35wZDBeIPpBVu2H/Wx3ck4hms4YUz/A+WP?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 604f85d0-d751-4d69-18a4-08de3925e304
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6489.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 02:26:42.2282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j7YGpTJtYp37ymPUUtIx+37Pkv2YMlM/vNFit2X0MmjAQZCTv5pflrSjRd21c6NpvpIFUvqLaD0bhaO3Sp5ApiIQ5NlDDX+OkCK9mrqhK0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7631
X-Authority-Analysis: v=2.4 cv=d5/4CBjE c=1 sm=1 tr=0 ts=693b7d65 cx=c_pps
 a=ZKvdAGA7hMB+bqOj1cvlrg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=MQ18jXuaH8rjNqpACdsA:9
X-Proofpoint-GUID: cQfGrKgYm-tr7iIvPN80Pm02OJKqcNS2
X-Proofpoint-ORIG-GUID: cQfGrKgYm-tr7iIvPN80Pm02OJKqcNS2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDAxOSBTYWx0ZWRfXx8+fsDTlrCX3
 00gg13K0ghy/L4DG/qfIeTTRjW98z/xCIOMs7AOUUSMCrvxPH6rUeF/GWWRBKlNBCTCADwxghXz
 SeukrJa5jV6nBYijbqFMb0CBZmWNndYgb3yCq7IEbOhdWBMKbs3GvXhg9fydT6T5SF7yArRAs/l
 H3N+ajWPsRuC/ZR66CjU7vj9/GWqqslNLVLOdvA01mOnKpRIXF56rdAJ0KT6W303+3TBZ/Pbg7Z
 nTnzEdSS92WPShjss7ea/DyBE2RIbr0pcI2bcaK7v4ji6T+1WRtF84GsyH88iOjaLu9wZ70PJq/
 AKhjycqxKznEIbgnRLB3C/DhWrImMXzTcpOxy+1OpSU3752SE81mKe14ExD+QSwusYo+0Sn3aNB
 wcTV9bnXhRxf1zoKctZ2S/Zi5G5GeQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-12_01,2025-12-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512120019

I redo the upgrade and rollback tests with the iso included the patch, and I do not see the issue any more.

Thanks,
Jiping
