Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F20C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 19 Feb 2022 23:35:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-jy9MYIeJMryinPeUO7A_Wg-1; Sat, 19 Feb 2022 18:35:18 -0500
X-MC-Unique: jy9MYIeJMryinPeUO7A_Wg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04F941006AA3;
	Sat, 19 Feb 2022 23:35:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 118084EC8D;
	Sat, 19 Feb 2022 23:35:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 714B44BB7C;
	Sat, 19 Feb 2022 23:35:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21JNZ65V018149 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 19 Feb 2022 18:35:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 14431141DC29; Sat, 19 Feb 2022 23:35:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F6CA141DC28
	for <dm-devel@redhat.com>; Sat, 19 Feb 2022 23:35:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E66F580120D
	for <dm-devel@redhat.com>; Sat, 19 Feb 2022 23:35:05 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-652-7JCv1mTkMuiMxua6x-cKOw-1; Sat, 19 Feb 2022 18:35:04 -0500
X-MC-Unique: 7JCv1mTkMuiMxua6x-cKOw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21JMianm019865; Sat, 19 Feb 2022 23:33:52 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3eapye1616-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Feb 2022 23:33:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JNOkOE053469;
	Sat, 19 Feb 2022 23:33:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by userp3030.oracle.com with ESMTP id 3eanns264v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Feb 2022 23:33:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by BYAPR10MB3477.namprd10.prod.outlook.com (2603:10b6:a03:128::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24;
	Sat, 19 Feb 2022 23:33:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c9f0:b3fb:25a6:3593]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.026;
	Sat, 19 Feb 2022 23:33:39 +0000
To: Christoph Hellwig <hch@lst.de>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0dqfn3t.fsf@ca-mkp.ca.oracle.com>
References: <20220209082828.2629273-1-hch@lst.de>
Date: Sat, 19 Feb 2022 18:33:36 -0500
In-Reply-To: <20220209082828.2629273-1-hch@lst.de> (Christoph Hellwig's
	message of "Wed, 9 Feb 2022 09:28:21 +0100")
X-ClientProxiedBy: SN4PR0401CA0011.namprd04.prod.outlook.com
	(2603:10b6:803:21::21) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12c5e2d5-2149-43ff-4ce5-08d9f400420f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3477:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3477C39F6CDE503731F2E26C8E389@BYAPR10MB3477.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 1XJKaQfnxcui/PzoErRZGN1xFJ84e7pWUsf9g0LN9pljS78O9xaje/EYLeSn1zTAXDJiisaQcVkz2QVtnK73LH8SqNwREWZMg359V75KKaR23TP1q0ki1emTtTVSZmWb7IsDnGPEs2qxlKrm1ZDyHSjeKCkkqSx/2YTd22wYUfhAfkHGs/pLihjdyU0n+vRE2RlXLwmjsbEfR1nOmxhUXND4TcHsBuRSXt0gn8UaR/LevVP5Hk1tvIdu8BlyHqb3x/cy1yoO+FZoOYlXNRxwoC820Yq5llWBnGmw+tUgKvAD0r+rOQvHPaG/vDusGVnQhZuVPYNd0/8/NFK+5tRHrmHPEOtKFQ9Erunu42u5cNyySeqIiOdGnfb2TldPhKBXdmim58LvlVp9+0oMWYzNg5i6Px7H/lNxxTe28t7Y6ELKKxtEzkqCMEtpsUrM6ONBDCdUjXQ6YlC2XCYzZiUrhUwwUl8IL5tuEUzao2LapsbawPH2sI76j2/hBS4Vh0dfTKU1ypsYGvfBaXcVR4SJAVtlQ6mMpvN1FGrT0fWvqIt+KJOUaZM0vXTD/07gzw4gz6Ux02NbNCtM5+WwkxJo2uaBu6tPX/SpVfCmOQU1a2QW9rPZmhpvTEAU5nlD1T3tMAs4DC/7y4YxZM2ilkXbZlEFQU7pKbXxIsHU6PSzTYy1j011H7812RhiIaFSACJPbFLdqNNgT2NNCOat+G7ZEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(316002)(38100700002)(38350700002)(6916009)(8936002)(7416002)(4744005)(2906002)(5660300002)(86362001)(66556008)(66476007)(66946007)(8676002)(4326008)(7116003)(52116002)(6486002)(26005)(508600001)(186003)(6506007)(36916002)(6512007)(6666004);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GmuaDF0OeU2jFbauf1UaeBYQGJzrpSe/5TcagqGaIcXHIzkWxBNKQE7fsl4j?=
	=?us-ascii?Q?JC/AB4/xxLjYWewQ4Vfk6zDDp44VdnutGvGGA01qJMPQj5hYFnF+ijN4sLHN?=
	=?us-ascii?Q?lLLKlNUZcKy04NXMbeM9m6i5hZeRVey62x9sSK7ueTLuWmVoTgNQGlqktHT6?=
	=?us-ascii?Q?CpWvN0s0S7MKYbN+Yf+jmVQsHnEJFfs/NIRjkoPHM1pE6WDZ0cTWpfU6gNQB?=
	=?us-ascii?Q?nwQ288/q2NqheAeBxc7WmCHXLVgLTMvFEO+PYvFzbPADhzcsqI02hzK73VWr?=
	=?us-ascii?Q?sz9IG4xcMUMMxSCx4Hh9gJMPnm3twg2MtsM9MHJYe49F+XUcemdRmD9USjc/?=
	=?us-ascii?Q?7FLh5EadU5EGCIzansuhB84uHQxJIsJ2tpEjRk+QzBX7tTb3HJzSAGx++gXD?=
	=?us-ascii?Q?KfC2ArdCJlalrn+wdXMkIqWyrMhiBNXujjpT4rsMlks5RYdHdDeXH41jxWgV?=
	=?us-ascii?Q?bLi5DISwktsTwI/f0BCJbvFFpKPG1aaNABhslVW/qsexY+OK+VSme3cXvSV0?=
	=?us-ascii?Q?E7QCuqGtsroXTyjAwmUMLvjh0F29ifualX84O1Kgg/H7PG3FWYxa8ijUNp/f?=
	=?us-ascii?Q?EMM0SKjWQCX9xZnH1xAgv57liXTAQt4cyQ+3UumnAXQ2LNh/Tmp9Xwt1pthF?=
	=?us-ascii?Q?A65a1KffMcDti4tSmo983buHTX6mCnfZekwvGimz7BtOUtpmFDXKdCd9QWIP?=
	=?us-ascii?Q?NAazw7pfy0lGqbHhHI5xJqmMXCdd1avEl0M0/mxZ5mNdA+8lvHFpcORVcuSb?=
	=?us-ascii?Q?sGUdbbas7+fL/GB6fJ1TSfgomcVJFM5KQgWafaGK6+J4hXG3yH+ue4m3Z0TA?=
	=?us-ascii?Q?5gQdQskJqYaRk7gQwQObZfPQTFI1bEw7D1Ss/CAS3LttOFtREvZShmCuUgib?=
	=?us-ascii?Q?1gmojyPoFtLDjUro3st9X8m3SqfhikusJm1GBaMG35rGXywYxOFxk31nXXTh?=
	=?us-ascii?Q?ndR4vBt3Z7KhLo/GZsxp03m1G/yvGZp/DNcysnm3S4D8LIPmtPmM9qx899N4?=
	=?us-ascii?Q?L7RTTyPhml9QTO800Yr8u08g5Vu6AYf1gSmwwDE1ikosTmAWHgRLm2ietuvJ?=
	=?us-ascii?Q?BmUgotmEAS/vPKwA4j+wbbWtsyo7n2LgFDrkB/igZPzQ3XoTwHdCIZnYE8pn?=
	=?us-ascii?Q?8YasG3Yqvk/zkMwgCE/VWs7O8FcS8YIMmutFIDbqVED8rs4fTKQOeZv5h9lN?=
	=?us-ascii?Q?jwJIh1fbIWo8ZkkiFHfIui5uSOoo08uqD9knR7+sd30hURtolw/rVWOFPyQU?=
	=?us-ascii?Q?2FRgWR03tVw91OkVg9RcC4fWAd+Jodk4/xSNZ/+Um/ih9wZGzDGhiPMyxiIX?=
	=?us-ascii?Q?ACR4b9vCpcR4mFawnPPx5ZG9XyeqGE/2mfdrfbjE4ydEd+8a7bxh8PLjJhvF?=
	=?us-ascii?Q?eEvBQ+H8LCYHJ7JYti7Rso+snMOA4H6Rql3VyrVpfhuMWTx93GkAV3a0YqNZ?=
	=?us-ascii?Q?YOJKPbBtqjbzqfneNfZnXUKhfoibR891moVjzTtmfW6E5W6EfhKgAWfrKWvs?=
	=?us-ascii?Q?j7Vfkl5x9IVxn6Usg/XvdnFlS82IuQWRpMw217nObdRwTF1ZHUwc68926ykp?=
	=?us-ascii?Q?Lrjd3zfoVdIdJ+C2ziT8GeXxsyndzWcz7pk03Qow+28DdPBgeGn3oVrnXovT?=
	=?us-ascii?Q?LUOMrDJR7Amo7XoZlLdLx8zIUe2PHM50GF2JI3uY0GKcIm20N7kiYVD+51+p?=
	=?us-ascii?Q?cKafBg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12c5e2d5-2149-43ff-4ce5-08d9f400420f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 23:33:39.7767 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AS7sAbLmsfSr5TzLBSBhZ34VD5J1R0LqwDz0G30F1ucJrVX2Fiz0b+wpGli10jGb+IgpANGTP9CGHkp+6ip5VNlxUsysLgSS2nLzm2uGMqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3477
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263
	signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	suspectscore=0 adultscore=0
	malwarescore=0 phishscore=0 mlxlogscore=540 mlxscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202190152
X-Proofpoint-ORIG-GUID: dWz8lW2zbgilvtGix758Y-Nv8kEVN_6g
X-Proofpoint-GUID: dWz8lW2zbgilvtGix758Y-Nv8kEVN_6g
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, philipp.reisner@linbit.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, haris.iqbal@ionos.com,
	ukrishn@linux.ibm.com, lars.ellenberg@linbit.com,
	drbd-dev@lists.linbit.com, jinpu.wang@ionos.com, mrochs@linux.ibm.com
Subject: Re: [dm-devel] remove REQ_OP_WRITE_SAME v2
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Christoph,

> Now that we are using REQ_OP_WRITE_ZEROES for all zeroing needs in the
> kernel there is very little use left for REQ_OP_WRITE_SAME.  We only
> have two callers left, and both just export optional protocol features
> to remote systems: DRBD and the target code.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

