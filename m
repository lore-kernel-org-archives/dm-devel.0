Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB18A4F8A7
	for <dm-devel@lists.linux.dev>; Thu, 11 Jan 2024 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hderz+g9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c6S2GMaF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BFEvqP027464;
	Thu, 11 Jan 2024 16:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=CkhQR+lgo+gGjW3U6v/fOLcCcll5PHRwIVQOu0VpMtY=;
 b=hderz+g9aClwmAIIqMygP9F6RvTXq7B7oyPYG82+jn14B/Q6swLpWuYSQEA1HAlCrViF
 /ymTdnOBT6d+tntFW48p/C3bwC8O+/omYzv5JI077Mt46652F55pfVtNMCtLQjDzYTC5
 aF92ABegYfEME/u3srDk7+0m35twLe/HM5XhiQ5esgVWvbwdRu1Z2XFnHzAvgWo5yPBO
 6d8OdT6hNdwp+PNS2sMivguHVOLPw8OqoWAFSkQnvdvvZ0FNha7ugX/vyo8lgDCzuWEe
 EOEWKlqbYDnDKHEzfJI2op8Uflu4zD+y19OFJ7SORDJ+NfFVcyR0rtwCOM3VO1xdUJcD UA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vjcbkh1ps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jan 2024 16:27:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40BFmVhP008836;
	Thu, 11 Jan 2024 16:24:28 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vfuunc77g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jan 2024 16:24:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhMobL7TOnduqPvnJVWRahNIdyw6gFyltBx2evXFMDU2jc1Gfxqi20EOzxVijIHWVCmc0m/OLogQd3fhj5I8usv2AQLSgM5xTI/VE9WFo5l8SrKudAm5jXqGYX0/E1B5NouFW0ZIQROOKm17UhBHtNaYsKzIuHdzKhBOjCk85CTyPmg1YwagPJbUbrVdvJkkgWpAK0OHK7bbd1gu35cD2JpJGIZSC7olFiClLoIeck1igvpskQcJXXwaY4VtwwJcQZDLBROhV8dTKj4vY9fce2OlnbOd8LMjIky3SovWKPj/arbawbaxTuBc/oJCwgZ6pBiaKuemvPfebCnOtQlB9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkhQR+lgo+gGjW3U6v/fOLcCcll5PHRwIVQOu0VpMtY=;
 b=Zq5ytfk+rnjD2CaN1DYEXJJtG11kQ1Lp91ihCu/h3sYypYOjLGjvlqP4a+lrzHBDP4j65vWKdrMIz05JUfIsOgZsK03BVECrz9nxQmUnyUP2moqXaD3pF/Bgj33asK2/V5hkp3XY8VIO3bYqrCNB0GCnQ8t46tLp5xjOkn5A97UVr9oJE8nCqdYGpMJGC3cbkq0nvz0jip2kFiM4Wf7DT84hDfMnjkK7t65UmIpGVY0cIw5Ue58ikzyKeuQPyQ5HnMQ8fJyrkkZbjqSlnrXbudGMiiQ1arKnZ5rKnWa+l+Ukid1Vko2B+r8QcT0VeVqDH8zs0n8W5V+gNsUGw6q6lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkhQR+lgo+gGjW3U6v/fOLcCcll5PHRwIVQOu0VpMtY=;
 b=c6S2GMaFbw2uDS7uEnGI0/v7XaSFHgDY3VfXN1Hh89O23s3bBVO7D5P+AFobnqpiBhGE+MTcWsiKmWCdNpexMAVWFE7ZLsHbfv2wjdhAaviEn3znNYnIsr58QEZH8PabMPW6SU2iL+IkBCAbw/mGH1D4cx4NxpRYRcOWz+a+hMw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW5PR10MB5807.namprd10.prod.outlook.com (2603:10b6:303:19a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Thu, 11 Jan
 2024 16:24:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7181.019; Thu, 11 Jan 2024
 16:24:22 +0000
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        martin.petersen@oracle.com, Mike Snitzer <snitzer@kernel.org>,
        Mikulas
 Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCHSET 0/3] Integrity cleanups and optimization
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7dr6e09.fsf@ca-mkp.ca.oracle.com>
References: <20240111160226.1936351-1-axboe@kernel.dk>
	<ZaASdg+NkFFy8Khx@infradead.org>
Date: Thu, 11 Jan 2024 11:24:19 -0500
In-Reply-To: <ZaASdg+NkFFy8Khx@infradead.org> (Christoph Hellwig's message of
	"Thu, 11 Jan 2024 08:08:22 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:254::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW5PR10MB5807:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf1d30d-aa06-4970-24b4-08dc12c1c519
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	EGZrMvSePA5aHLYwZTtYyVrlZjnl89npPMwiNIabpQbyPcSKGJGrXlci3bqzVw/6yD2igG8HVzb/CfimYb0J04yW29k+G5E2HKKiTpip6Gr734fW6vmDHEOMFXeRnmBdHPVF6MYX+xoPDDv6OfHk50Fls7Kw7BXY/28ktXzgHNITAhSk/WtefJ+D+YfkrSNNKI+FXxFyMSAukpnfZaWsQAKU/irfd8u9NOnxpOfI5SRGr4EqaSB2HtL9NtcqM9q1X2JWKTMTpfdJ60T8wX6xA4EWSM+/OY64G5LBi4wOoyTpLthnYywS2yLpSDXzQ+3ApzWbzUwxO8UAUrVgs7RsqZoEIKuPAoD+XDBSFCXfq/jwctqrG4Hui3HyS7p9flTW4ZdkcWnq4NSVCIogzxhWTosgaDEHnSyoy5AN8ALT6+k+zaAC/RMO7xUo01oBbMPDdTlQ7KDgPPOPb944/Zfs3oY/1ulppE4RG92uPQNrbG0KaXxuMAtKDmdiM9j9VEmLuK+kf7o9N/i+FLh7dSUUL+lIRXxfYL7NoJmqiBLDT4wkB7aS72rlM1kgtsvr/bqD
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(366004)(136003)(346002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(36916002)(6486002)(6512007)(26005)(6506007)(6666004)(478600001)(66946007)(66476007)(41300700001)(2906002)(4744005)(316002)(8936002)(54906003)(6916009)(4326008)(8676002)(66556008)(5660300002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?QO9WsZi0ERgWs2SGrF4/oIJY3/4uhRWn43GYNut/hjxN8gkWF2qvj1epfaHC?=
 =?us-ascii?Q?hvhlP4VrNHBs5aP9RsBS4zIVgZJ68wWv4AgxrBSpJeGYezORmhKqNXA59tSc?=
 =?us-ascii?Q?HASKsMgvqGQogsDFQkWnyx3qZexObJAt90cYPPuMVWOXd4KmN7+tgT0bVvdw?=
 =?us-ascii?Q?+BbjSHuowhUiHRGQJiPAD1ZDXFNUrfkK4w4ou7726CEPyfXi+T0x4un3DyYc?=
 =?us-ascii?Q?4zwnN8mh7Lsg2XI08JlJEbu+0LJnkybmL47tCCL73V5fBL1pISGynwNeULbl?=
 =?us-ascii?Q?chTNSj/rbG9e5DNGn7831UULsAVZlzHwJ4ED5NQmaV39VEYxuWA3nGquuVKI?=
 =?us-ascii?Q?/pKbPOANSsJZKcImFUkE7klbR6Z4Dp5Qm1vn0nhVeah8SfPTEqgkNBo9pDuk?=
 =?us-ascii?Q?asZzD1K77+MBye7+Q4HC1vi1TRBaAyAAen2xmdg394D+AA62lnYj1c97CeRA?=
 =?us-ascii?Q?A3ShV93kb2qRd5gVR9stnHzHCpVGe3Ib6dE/4UMioPkCZcV9tB5hziEkPCPX?=
 =?us-ascii?Q?izyC6OC66nBb1XVwCKXvfeYlwd0Z71LZrAxvbUtyo24GQ8zTrBl6Ews+SjC6?=
 =?us-ascii?Q?u2yPVFhoq2x88rRC60uyBy8f7IlwjYnVQi6lQgWURMyXYDhqh9iZtzJqOHql?=
 =?us-ascii?Q?RbyegIpPNtK65Qar2WYeu3i+AjWZWHxxdwaGeyTh4l82pX9MwSau4s2ilmQp?=
 =?us-ascii?Q?9Z08NUtaCoVJxcAKfiDMgV5iBWd46jAwyZmK6I9z3OlAeAHzKg9nfIqZ6Kms?=
 =?us-ascii?Q?Rk/LyYLxzp0rTQ70vQP/4+rqC7nJYAIIpqeeItdjyrc/+YlenEIvSt8w89XJ?=
 =?us-ascii?Q?6eX76Mm/HYyJ23G+Pkl+ot4Pdoa6eWa6jZ+bUwncTbL4Uh1cVOVm7IYyamjM?=
 =?us-ascii?Q?fiqtRXpnnahYAqTffzHqFZsgp6Qdy0n8Tm5piUGEcXKcaFBlvYtl5Pjf00tt?=
 =?us-ascii?Q?94HPWk6Tk6wygRX2xab855pDBAoVv5njuNwxL6YwGCIhXZH2pGBhJDCxx/1B?=
 =?us-ascii?Q?SF/r04lJU5ivFpcZlht30UDwR+dO1GyiW744PKyxtK7z84LWkBDy1QTIWufo?=
 =?us-ascii?Q?HGoIJUnt8GP8RBgxMUc+ewZDi9n0C2NF0D9+7JnczPRc5sHQc7q6oD3NwNBb?=
 =?us-ascii?Q?LNc+unCFEM7wzB/EdUkB5sZiHcn5jWNVv7falcfUJoyd2AX5DPYy7rQefGrR?=
 =?us-ascii?Q?HP283OToSzSIxstuIM086hIdEEucdPerSQdQakinWGHke6oMt0U1gXCBH2h0?=
 =?us-ascii?Q?gJiOUckFwR/G3+XmnZGrApCRZLCqEg98rV9ZcbGzukC6TsBxxNjvzxbHHut5?=
 =?us-ascii?Q?bJywmhGA1q3SpCyvwtrEP5jwHp6j22X5B25bAUZU30oLMhzQOJ/IBH3hJKV+?=
 =?us-ascii?Q?Oni7O9eeic+cl8tUjl/HLqHeTfhkIOQM5VkfhlXCTk/IaPv8cDns2Ut4CW/C?=
 =?us-ascii?Q?LgQCD2K3kk9X7Koe8Gtv+aulCfnMduSotCHHV23yLq86ake4dLgebBw97ij0?=
 =?us-ascii?Q?pkvWfSk7bxdym5lIUq0dT7ckOYtUH9znUxRJYVwDsf5ueS7ZfFmgjZo0ppWd?=
 =?us-ascii?Q?L0S+oWWrHFkyHIDJNth9pFeiyv/+j8InylphoMAJrcngRBjwoaKkxTM1CCOG?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eD6nQbmYer3ujVD+SiuM3A2Vxqza8FZei3gpOgkanZ2XgDeUxDGpDh0oI7LmQ1NmAjIgvSUV+GgsBrtrUeN9QA7GlZCCURLNj2ae8xq5BrTrO70jhWTAnZXlKtkNIdzuOxF3FEkUNYc5DUBOxv/WfQnbLTwfVIXwf/L9YaezHtRr2rwvgV9sd2JHxWLmDSZbDxVFEe8sjG4OBcATgk9zH8c7kCFtz3OxWcu9f//rCj97Fl5L+NNEDcxE6AEDOyUWCiD3JkeAmxnTBMMadH4Nf0WW/0qxd3nQevkbie7b/xqGC/RYZwCutI7AVLpdldLlBYkKScDo14X3SCbNkUZii+41QuQDIK4LyTKM4chkRnBr+xdDGC0mOZbMkFpf0iH7S+rl1XsbZmCt8izgPgoOBrhN1BhmB+E1orYX2uOJSHkyX6WlQAGtjTonZmhy79y0x4tztPIh0JvnOFNPce6S2yKOvR5tEdo4lqUFhOXJmVb7Le3FIBakuM3Gs6jxXFoQG+kwPzLGuXouIP9hESn7aOF2pB1ELOukM53Xn3X+dUmMDxiKp21JfZqmvBpymj98HkrfIvHLxkdwYoj+fEL4fmrC5aXG5XCizari+7wYH7g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf1d30d-aa06-4970-24b4-08dc12c1c519
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2024 16:24:22.6475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BCfrkEnmIf8WfZXCLiwcijnSTkwCScq+kTUrhzjyHpQTfdJ7X47Tp2kO9zak72wdMwmXu4h+ZpmHxBB4fbBR8KO4SRCiymvMApnSyoNDCuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_09,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=703 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401110128
X-Proofpoint-ORIG-GUID: LhWNRaaL-4fph2z9z3RG6a4nR38IJwo9
X-Proofpoint-GUID: LhWNRaaL-4fph2z9z3RG6a4nR38IJwo9


> Bw, can someone help with what dm_integrity_profile is for?
> It is basically identical to the no-op one, just with a different
> name.  With the no-op removal it is the only one outside of the pi
> once, and killing it would really help with some de-virtualization
> I've looked at a while ago.

No particular objections from me wrt. using a flag.

However, I believe the no-op profile and associated plumbing was a
requirement for DM. I forget the details. Mike?

-- 
Martin K. Petersen	Oracle Linux Engineering
